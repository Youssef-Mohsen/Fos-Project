
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
  80003e:	a1 04 30 80 00       	mov    0x803004,%eax
  800043:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  800049:	a1 04 30 80 00       	mov    0x803004,%eax
  80004e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800054:	39 c2                	cmp    %eax,%edx
  800056:	72 14                	jb     80006c <_main+0x34>
			panic("Please increase the WS size");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 c0 1d 80 00       	push   $0x801dc0
  800060:	6a 0c                	push   $0xc
  800062:	68 dc 1d 80 00       	push   $0x801ddc
  800067:	e8 46 03 00 00       	call   8003b2 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	cprintf("************************************************\n");
  80006c:	83 ec 0c             	sub    $0xc,%esp
  80006f:	68 f4 1d 80 00       	push   $0x801df4
  800074:	e8 f6 05 00 00       	call   80066f <cprintf>
  800079:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	68 28 1e 80 00       	push   $0x801e28
  800084:	e8 e6 05 00 00       	call   80066f <cprintf>
  800089:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 84 1e 80 00       	push   $0x801e84
  800094:	e8 d6 05 00 00       	call   80066f <cprintf>
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
  8000b4:	68 b8 1e 80 00       	push   $0x801eb8
  8000b9:	e8 b1 05 00 00       	call   80066f <cprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 01                	push   $0x1
  8000c6:	68 00 10 00 00       	push   $0x1000
  8000cb:	68 06 1f 80 00       	push   $0x801f06
  8000d0:	e8 8d 13 00 00       	call   801462 <smalloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000db:	e8 73 15 00 00       	call   801653 <sys_calculate_free_frames>
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e3:	83 ec 04             	sub    $0x4,%esp
  8000e6:	6a 01                	push   $0x1
  8000e8:	68 00 10 00 00       	push   $0x1000
  8000ed:	68 06 1f 80 00       	push   $0x801f06
  8000f2:	e8 6b 13 00 00       	call   801462 <smalloc>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to create an already exists object and corresponding error is not returned!!");}
  8000fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800101:	74 17                	je     80011a <_main+0xe2>
  800103:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	68 08 1f 80 00       	push   $0x801f08
  800112:	e8 58 05 00 00       	call   80066f <cprintf>
  800117:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");}
  80011a:	e8 34 15 00 00       	call   801653 <sys_calculate_free_frames>
  80011f:	89 c2                	mov    %eax,%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	39 c2                	cmp    %eax,%edx
  800126:	74 17                	je     80013f <_main+0x107>
  800128:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 5c 1f 80 00       	push   $0x801f5c
  800137:	e8 33 05 00 00       	call   80066f <cprintf>
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
  800153:	68 b8 1f 80 00       	push   $0x801fb8
  800158:	e8 12 05 00 00       	call   80066f <cprintf>
  80015d:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		x = sget(myEnv->env_id, "xx");
  800160:	a1 04 30 80 00       	mov    0x803004,%eax
  800165:	8b 40 10             	mov    0x10(%eax),%eax
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	68 fd 1f 80 00       	push   $0x801ffd
  800170:	50                   	push   %eax
  800171:	e8 1b 13 00 00       	call   801491 <sget>
  800176:	83 c4 10             	add    $0x10,%esp
  800179:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  80017c:	e8 d2 14 00 00       	call   801653 <sys_calculate_free_frames>
  800181:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to get a NON existing object and corresponding error is not returned!!");}
  800184:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800188:	74 17                	je     8001a1 <_main+0x169>
  80018a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	68 00 20 80 00       	push   $0x802000
  800199:	e8 d1 04 00 00       	call   80066f <cprintf>
  80019e:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong get: make sure that you don't allocate any memory if the shared object not exists");}
  8001a1:	e8 ad 14 00 00       	call   801653 <sys_calculate_free_frames>
  8001a6:	89 c2                	mov    %eax,%edx
  8001a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ab:	39 c2                	cmp    %eax,%edx
  8001ad:	74 17                	je     8001c6 <_main+0x18e>
  8001af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	68 50 20 80 00       	push   $0x802050
  8001be:	e8 ac 04 00 00       	call   80066f <cprintf>
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
  8001da:	68 a8 20 80 00       	push   $0x8020a8
  8001df:	e8 8b 04 00 00       	call   80066f <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8001e7:	e8 67 14 00 00       	call   801653 <sys_calculate_free_frames>
  8001ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uint32 size = USER_HEAP_MAX - pagealloc_start - PAGE_SIZE + 1;
  8001ef:	b8 01 f0 ff 9f       	mov    $0x9ffff001,%eax
  8001f4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8001f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		y = smalloc("y", size, 1);
  8001fa:	83 ec 04             	sub    $0x4,%esp
  8001fd:	6a 01                	push   $0x1
  8001ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800202:	68 05 21 80 00       	push   $0x802105
  800207:	e8 56 12 00 00       	call   801462 <smalloc>
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (y != NULL) {is_correct = 0; cprintf("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");}
  800212:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800216:	74 17                	je     80022f <_main+0x1f7>
  800218:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	68 08 21 80 00       	push   $0x802108
  800227:	e8 43 04 00 00       	call   80066f <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");}
  80022f:	e8 1f 14 00 00       	call   801653 <sys_calculate_free_frames>
  800234:	89 c2                	mov    %eax,%edx
  800236:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800239:	39 c2                	cmp    %eax,%edx
  80023b:	74 17                	je     800254 <_main+0x21c>
  80023d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 7c 21 80 00       	push   $0x80217c
  80024c:	e8 1e 04 00 00       	call   80066f <cprintf>
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
  80026b:	68 f0 21 80 00       	push   $0x8021f0
  800270:	e8 fa 03 00 00       	call   80066f <cprintf>
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
  800281:	e8 96 15 00 00       	call   80181c <sys_getenvindex>
  800286:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800289:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80028c:	89 d0                	mov    %edx,%eax
  80028e:	c1 e0 02             	shl    $0x2,%eax
  800291:	01 d0                	add    %edx,%eax
  800293:	01 c0                	add    %eax,%eax
  800295:	01 d0                	add    %edx,%eax
  800297:	c1 e0 02             	shl    $0x2,%eax
  80029a:	01 d0                	add    %edx,%eax
  80029c:	01 c0                	add    %eax,%eax
  80029e:	01 d0                	add    %edx,%eax
  8002a0:	c1 e0 04             	shl    $0x4,%eax
  8002a3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002a8:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002ad:	a1 04 30 80 00       	mov    0x803004,%eax
  8002b2:	8a 40 20             	mov    0x20(%eax),%al
  8002b5:	84 c0                	test   %al,%al
  8002b7:	74 0d                	je     8002c6 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8002b9:	a1 04 30 80 00       	mov    0x803004,%eax
  8002be:	83 c0 20             	add    $0x20,%eax
  8002c1:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002ca:	7e 0a                	jle    8002d6 <libmain+0x5b>
		binaryname = argv[0];
  8002cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cf:	8b 00                	mov    (%eax),%eax
  8002d1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8002d6:	83 ec 08             	sub    $0x8,%esp
  8002d9:	ff 75 0c             	pushl  0xc(%ebp)
  8002dc:	ff 75 08             	pushl  0x8(%ebp)
  8002df:	e8 54 fd ff ff       	call   800038 <_main>
  8002e4:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8002e7:	e8 b4 12 00 00       	call   8015a0 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8002ec:	83 ec 0c             	sub    $0xc,%esp
  8002ef:	68 5c 22 80 00       	push   $0x80225c
  8002f4:	e8 76 03 00 00       	call   80066f <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002fc:	a1 04 30 80 00       	mov    0x803004,%eax
  800301:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800307:	a1 04 30 80 00       	mov    0x803004,%eax
  80030c:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	52                   	push   %edx
  800316:	50                   	push   %eax
  800317:	68 84 22 80 00       	push   $0x802284
  80031c:	e8 4e 03 00 00       	call   80066f <cprintf>
  800321:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800324:	a1 04 30 80 00       	mov    0x803004,%eax
  800329:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  80032f:	a1 04 30 80 00       	mov    0x803004,%eax
  800334:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  80033a:	a1 04 30 80 00       	mov    0x803004,%eax
  80033f:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800345:	51                   	push   %ecx
  800346:	52                   	push   %edx
  800347:	50                   	push   %eax
  800348:	68 ac 22 80 00       	push   $0x8022ac
  80034d:	e8 1d 03 00 00       	call   80066f <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800355:	a1 04 30 80 00       	mov    0x803004,%eax
  80035a:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	50                   	push   %eax
  800364:	68 04 23 80 00       	push   $0x802304
  800369:	e8 01 03 00 00       	call   80066f <cprintf>
  80036e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800371:	83 ec 0c             	sub    $0xc,%esp
  800374:	68 5c 22 80 00       	push   $0x80225c
  800379:	e8 f1 02 00 00       	call   80066f <cprintf>
  80037e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800381:	e8 34 12 00 00       	call   8015ba <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800386:	e8 19 00 00 00       	call   8003a4 <exit>
}
  80038b:	90                   	nop
  80038c:	c9                   	leave  
  80038d:	c3                   	ret    

0080038e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800394:	83 ec 0c             	sub    $0xc,%esp
  800397:	6a 00                	push   $0x0
  800399:	e8 4a 14 00 00       	call   8017e8 <sys_destroy_env>
  80039e:	83 c4 10             	add    $0x10,%esp
}
  8003a1:	90                   	nop
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    

008003a4 <exit>:

void
exit(void)
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003aa:	e8 9f 14 00 00       	call   80184e <sys_exit_env>
}
  8003af:	90                   	nop
  8003b0:	c9                   	leave  
  8003b1:	c3                   	ret    

008003b2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003b8:	8d 45 10             	lea    0x10(%ebp),%eax
  8003bb:	83 c0 04             	add    $0x4,%eax
  8003be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003c1:	a1 24 30 80 00       	mov    0x803024,%eax
  8003c6:	85 c0                	test   %eax,%eax
  8003c8:	74 16                	je     8003e0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003ca:	a1 24 30 80 00       	mov    0x803024,%eax
  8003cf:	83 ec 08             	sub    $0x8,%esp
  8003d2:	50                   	push   %eax
  8003d3:	68 18 23 80 00       	push   $0x802318
  8003d8:	e8 92 02 00 00       	call   80066f <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003e0:	a1 00 30 80 00       	mov    0x803000,%eax
  8003e5:	ff 75 0c             	pushl  0xc(%ebp)
  8003e8:	ff 75 08             	pushl  0x8(%ebp)
  8003eb:	50                   	push   %eax
  8003ec:	68 1d 23 80 00       	push   $0x80231d
  8003f1:	e8 79 02 00 00       	call   80066f <cprintf>
  8003f6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800402:	50                   	push   %eax
  800403:	e8 fc 01 00 00       	call   800604 <vcprintf>
  800408:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80040b:	83 ec 08             	sub    $0x8,%esp
  80040e:	6a 00                	push   $0x0
  800410:	68 39 23 80 00       	push   $0x802339
  800415:	e8 ea 01 00 00       	call   800604 <vcprintf>
  80041a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80041d:	e8 82 ff ff ff       	call   8003a4 <exit>

	// should not return here
	while (1) ;
  800422:	eb fe                	jmp    800422 <_panic+0x70>

00800424 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80042a:	a1 04 30 80 00       	mov    0x803004,%eax
  80042f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800435:	8b 45 0c             	mov    0xc(%ebp),%eax
  800438:	39 c2                	cmp    %eax,%edx
  80043a:	74 14                	je     800450 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80043c:	83 ec 04             	sub    $0x4,%esp
  80043f:	68 3c 23 80 00       	push   $0x80233c
  800444:	6a 26                	push   $0x26
  800446:	68 88 23 80 00       	push   $0x802388
  80044b:	e8 62 ff ff ff       	call   8003b2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800450:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800457:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80045e:	e9 c5 00 00 00       	jmp    800528 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800466:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	01 d0                	add    %edx,%eax
  800472:	8b 00                	mov    (%eax),%eax
  800474:	85 c0                	test   %eax,%eax
  800476:	75 08                	jne    800480 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800478:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80047b:	e9 a5 00 00 00       	jmp    800525 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800480:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800487:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80048e:	eb 69                	jmp    8004f9 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800490:	a1 04 30 80 00       	mov    0x803004,%eax
  800495:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80049b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80049e:	89 d0                	mov    %edx,%eax
  8004a0:	01 c0                	add    %eax,%eax
  8004a2:	01 d0                	add    %edx,%eax
  8004a4:	c1 e0 03             	shl    $0x3,%eax
  8004a7:	01 c8                	add    %ecx,%eax
  8004a9:	8a 40 04             	mov    0x4(%eax),%al
  8004ac:	84 c0                	test   %al,%al
  8004ae:	75 46                	jne    8004f6 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004b0:	a1 04 30 80 00       	mov    0x803004,%eax
  8004b5:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8004bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004be:	89 d0                	mov    %edx,%eax
  8004c0:	01 c0                	add    %eax,%eax
  8004c2:	01 d0                	add    %edx,%eax
  8004c4:	c1 e0 03             	shl    $0x3,%eax
  8004c7:	01 c8                	add    %ecx,%eax
  8004c9:	8b 00                	mov    (%eax),%eax
  8004cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004d6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004db:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	01 c8                	add    %ecx,%eax
  8004e7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004e9:	39 c2                	cmp    %eax,%edx
  8004eb:	75 09                	jne    8004f6 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8004ed:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004f4:	eb 15                	jmp    80050b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004f6:	ff 45 e8             	incl   -0x18(%ebp)
  8004f9:	a1 04 30 80 00       	mov    0x803004,%eax
  8004fe:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800504:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800507:	39 c2                	cmp    %eax,%edx
  800509:	77 85                	ja     800490 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80050b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80050f:	75 14                	jne    800525 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800511:	83 ec 04             	sub    $0x4,%esp
  800514:	68 94 23 80 00       	push   $0x802394
  800519:	6a 3a                	push   $0x3a
  80051b:	68 88 23 80 00       	push   $0x802388
  800520:	e8 8d fe ff ff       	call   8003b2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800525:	ff 45 f0             	incl   -0x10(%ebp)
  800528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80052b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80052e:	0f 8c 2f ff ff ff    	jl     800463 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800534:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800542:	eb 26                	jmp    80056a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800544:	a1 04 30 80 00       	mov    0x803004,%eax
  800549:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80054f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800552:	89 d0                	mov    %edx,%eax
  800554:	01 c0                	add    %eax,%eax
  800556:	01 d0                	add    %edx,%eax
  800558:	c1 e0 03             	shl    $0x3,%eax
  80055b:	01 c8                	add    %ecx,%eax
  80055d:	8a 40 04             	mov    0x4(%eax),%al
  800560:	3c 01                	cmp    $0x1,%al
  800562:	75 03                	jne    800567 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800564:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800567:	ff 45 e0             	incl   -0x20(%ebp)
  80056a:	a1 04 30 80 00       	mov    0x803004,%eax
  80056f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800575:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800578:	39 c2                	cmp    %eax,%edx
  80057a:	77 c8                	ja     800544 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80057c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800582:	74 14                	je     800598 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800584:	83 ec 04             	sub    $0x4,%esp
  800587:	68 e8 23 80 00       	push   $0x8023e8
  80058c:	6a 44                	push   $0x44
  80058e:	68 88 23 80 00       	push   $0x802388
  800593:	e8 1a fe ff ff       	call   8003b2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800598:	90                   	nop
  800599:	c9                   	leave  
  80059a:	c3                   	ret    

0080059b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80059b:	55                   	push   %ebp
  80059c:	89 e5                	mov    %esp,%ebp
  80059e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	8d 48 01             	lea    0x1(%eax),%ecx
  8005a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ac:	89 0a                	mov    %ecx,(%edx)
  8005ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8005b1:	88 d1                	mov    %dl,%cl
  8005b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005c4:	75 2c                	jne    8005f2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005c6:	a0 08 30 80 00       	mov    0x803008,%al
  8005cb:	0f b6 c0             	movzbl %al,%eax
  8005ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005d1:	8b 12                	mov    (%edx),%edx
  8005d3:	89 d1                	mov    %edx,%ecx
  8005d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005d8:	83 c2 08             	add    $0x8,%edx
  8005db:	83 ec 04             	sub    $0x4,%esp
  8005de:	50                   	push   %eax
  8005df:	51                   	push   %ecx
  8005e0:	52                   	push   %edx
  8005e1:	e8 78 0f 00 00       	call   80155e <sys_cputs>
  8005e6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f5:	8b 40 04             	mov    0x4(%eax),%eax
  8005f8:	8d 50 01             	lea    0x1(%eax),%edx
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	89 50 04             	mov    %edx,0x4(%eax)
}
  800601:	90                   	nop
  800602:	c9                   	leave  
  800603:	c3                   	ret    

00800604 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800604:	55                   	push   %ebp
  800605:	89 e5                	mov    %esp,%ebp
  800607:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80060d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800614:	00 00 00 
	b.cnt = 0;
  800617:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80061e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800621:	ff 75 0c             	pushl  0xc(%ebp)
  800624:	ff 75 08             	pushl  0x8(%ebp)
  800627:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80062d:	50                   	push   %eax
  80062e:	68 9b 05 80 00       	push   $0x80059b
  800633:	e8 11 02 00 00       	call   800849 <vprintfmt>
  800638:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80063b:	a0 08 30 80 00       	mov    0x803008,%al
  800640:	0f b6 c0             	movzbl %al,%eax
  800643:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800649:	83 ec 04             	sub    $0x4,%esp
  80064c:	50                   	push   %eax
  80064d:	52                   	push   %edx
  80064e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800654:	83 c0 08             	add    $0x8,%eax
  800657:	50                   	push   %eax
  800658:	e8 01 0f 00 00       	call   80155e <sys_cputs>
  80065d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800660:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800667:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80066d:	c9                   	leave  
  80066e:	c3                   	ret    

0080066f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80066f:	55                   	push   %ebp
  800670:	89 e5                	mov    %esp,%ebp
  800672:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800675:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80067c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80067f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	ff 75 f4             	pushl  -0xc(%ebp)
  80068b:	50                   	push   %eax
  80068c:	e8 73 ff ff ff       	call   800604 <vcprintf>
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800697:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80069a:	c9                   	leave  
  80069b:	c3                   	ret    

0080069c <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80069c:	55                   	push   %ebp
  80069d:	89 e5                	mov    %esp,%ebp
  80069f:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006a2:	e8 f9 0e 00 00       	call   8015a0 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006a7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b6:	50                   	push   %eax
  8006b7:	e8 48 ff ff ff       	call   800604 <vcprintf>
  8006bc:	83 c4 10             	add    $0x10,%esp
  8006bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006c2:	e8 f3 0e 00 00       	call   8015ba <sys_unlock_cons>
	return cnt;
  8006c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ca:	c9                   	leave  
  8006cb:	c3                   	ret    

008006cc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006cc:	55                   	push   %ebp
  8006cd:	89 e5                	mov    %esp,%ebp
  8006cf:	53                   	push   %ebx
  8006d0:	83 ec 14             	sub    $0x14,%esp
  8006d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006df:	8b 45 18             	mov    0x18(%ebp),%eax
  8006e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ea:	77 55                	ja     800741 <printnum+0x75>
  8006ec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ef:	72 05                	jb     8006f6 <printnum+0x2a>
  8006f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006f4:	77 4b                	ja     800741 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006f6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006f9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006fc:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800704:	52                   	push   %edx
  800705:	50                   	push   %eax
  800706:	ff 75 f4             	pushl  -0xc(%ebp)
  800709:	ff 75 f0             	pushl  -0x10(%ebp)
  80070c:	e8 4b 14 00 00       	call   801b5c <__udivdi3>
  800711:	83 c4 10             	add    $0x10,%esp
  800714:	83 ec 04             	sub    $0x4,%esp
  800717:	ff 75 20             	pushl  0x20(%ebp)
  80071a:	53                   	push   %ebx
  80071b:	ff 75 18             	pushl  0x18(%ebp)
  80071e:	52                   	push   %edx
  80071f:	50                   	push   %eax
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	ff 75 08             	pushl  0x8(%ebp)
  800726:	e8 a1 ff ff ff       	call   8006cc <printnum>
  80072b:	83 c4 20             	add    $0x20,%esp
  80072e:	eb 1a                	jmp    80074a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	ff 75 20             	pushl  0x20(%ebp)
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	ff d0                	call   *%eax
  80073e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800741:	ff 4d 1c             	decl   0x1c(%ebp)
  800744:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800748:	7f e6                	jg     800730 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80074a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80074d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800755:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800758:	53                   	push   %ebx
  800759:	51                   	push   %ecx
  80075a:	52                   	push   %edx
  80075b:	50                   	push   %eax
  80075c:	e8 0b 15 00 00       	call   801c6c <__umoddi3>
  800761:	83 c4 10             	add    $0x10,%esp
  800764:	05 54 26 80 00       	add    $0x802654,%eax
  800769:	8a 00                	mov    (%eax),%al
  80076b:	0f be c0             	movsbl %al,%eax
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 0c             	pushl  0xc(%ebp)
  800774:	50                   	push   %eax
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	ff d0                	call   *%eax
  80077a:	83 c4 10             	add    $0x10,%esp
}
  80077d:	90                   	nop
  80077e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800781:	c9                   	leave  
  800782:	c3                   	ret    

00800783 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800786:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80078a:	7e 1c                	jle    8007a8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	8d 50 08             	lea    0x8(%eax),%edx
  800794:	8b 45 08             	mov    0x8(%ebp),%eax
  800797:	89 10                	mov    %edx,(%eax)
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	83 e8 08             	sub    $0x8,%eax
  8007a1:	8b 50 04             	mov    0x4(%eax),%edx
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	eb 40                	jmp    8007e8 <getuint+0x65>
	else if (lflag)
  8007a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ac:	74 1e                	je     8007cc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	8d 50 04             	lea    0x4(%eax),%edx
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	89 10                	mov    %edx,(%eax)
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ca:	eb 1c                	jmp    8007e8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	8d 50 04             	lea    0x4(%eax),%edx
  8007d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d7:	89 10                	mov    %edx,(%eax)
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	8b 00                	mov    (%eax),%eax
  8007de:	83 e8 04             	sub    $0x4,%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007e8:	5d                   	pop    %ebp
  8007e9:	c3                   	ret    

008007ea <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007ed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007f1:	7e 1c                	jle    80080f <getint+0x25>
		return va_arg(*ap, long long);
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	8b 00                	mov    (%eax),%eax
  8007f8:	8d 50 08             	lea    0x8(%eax),%edx
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	89 10                	mov    %edx,(%eax)
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	83 e8 08             	sub    $0x8,%eax
  800808:	8b 50 04             	mov    0x4(%eax),%edx
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	eb 38                	jmp    800847 <getint+0x5d>
	else if (lflag)
  80080f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800813:	74 1a                	je     80082f <getint+0x45>
		return va_arg(*ap, long);
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	8b 00                	mov    (%eax),%eax
  80081a:	8d 50 04             	lea    0x4(%eax),%edx
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	89 10                	mov    %edx,(%eax)
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	8b 00                	mov    (%eax),%eax
  800827:	83 e8 04             	sub    $0x4,%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	99                   	cltd   
  80082d:	eb 18                	jmp    800847 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	8d 50 04             	lea    0x4(%eax),%edx
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	89 10                	mov    %edx,(%eax)
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	8b 00                	mov    (%eax),%eax
  800841:	83 e8 04             	sub    $0x4,%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	99                   	cltd   
}
  800847:	5d                   	pop    %ebp
  800848:	c3                   	ret    

00800849 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	56                   	push   %esi
  80084d:	53                   	push   %ebx
  80084e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800851:	eb 17                	jmp    80086a <vprintfmt+0x21>
			if (ch == '\0')
  800853:	85 db                	test   %ebx,%ebx
  800855:	0f 84 c1 03 00 00    	je     800c1c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80085b:	83 ec 08             	sub    $0x8,%esp
  80085e:	ff 75 0c             	pushl  0xc(%ebp)
  800861:	53                   	push   %ebx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	ff d0                	call   *%eax
  800867:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80086a:	8b 45 10             	mov    0x10(%ebp),%eax
  80086d:	8d 50 01             	lea    0x1(%eax),%edx
  800870:	89 55 10             	mov    %edx,0x10(%ebp)
  800873:	8a 00                	mov    (%eax),%al
  800875:	0f b6 d8             	movzbl %al,%ebx
  800878:	83 fb 25             	cmp    $0x25,%ebx
  80087b:	75 d6                	jne    800853 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80087d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800881:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800888:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80088f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800896:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80089d:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a0:	8d 50 01             	lea    0x1(%eax),%edx
  8008a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8008a6:	8a 00                	mov    (%eax),%al
  8008a8:	0f b6 d8             	movzbl %al,%ebx
  8008ab:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008ae:	83 f8 5b             	cmp    $0x5b,%eax
  8008b1:	0f 87 3d 03 00 00    	ja     800bf4 <vprintfmt+0x3ab>
  8008b7:	8b 04 85 78 26 80 00 	mov    0x802678(,%eax,4),%eax
  8008be:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008c0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008c4:	eb d7                	jmp    80089d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008c6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008ca:	eb d1                	jmp    80089d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008d6:	89 d0                	mov    %edx,%eax
  8008d8:	c1 e0 02             	shl    $0x2,%eax
  8008db:	01 d0                	add    %edx,%eax
  8008dd:	01 c0                	add    %eax,%eax
  8008df:	01 d8                	add    %ebx,%eax
  8008e1:	83 e8 30             	sub    $0x30,%eax
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ea:	8a 00                	mov    (%eax),%al
  8008ec:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008ef:	83 fb 2f             	cmp    $0x2f,%ebx
  8008f2:	7e 3e                	jle    800932 <vprintfmt+0xe9>
  8008f4:	83 fb 39             	cmp    $0x39,%ebx
  8008f7:	7f 39                	jg     800932 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008f9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008fc:	eb d5                	jmp    8008d3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	83 c0 04             	add    $0x4,%eax
  800904:	89 45 14             	mov    %eax,0x14(%ebp)
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	83 e8 04             	sub    $0x4,%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800912:	eb 1f                	jmp    800933 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800914:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800918:	79 83                	jns    80089d <vprintfmt+0x54>
				width = 0;
  80091a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800921:	e9 77 ff ff ff       	jmp    80089d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800926:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80092d:	e9 6b ff ff ff       	jmp    80089d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800932:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800933:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800937:	0f 89 60 ff ff ff    	jns    80089d <vprintfmt+0x54>
				width = precision, precision = -1;
  80093d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800940:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800943:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80094a:	e9 4e ff ff ff       	jmp    80089d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80094f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800952:	e9 46 ff ff ff       	jmp    80089d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800957:	8b 45 14             	mov    0x14(%ebp),%eax
  80095a:	83 c0 04             	add    $0x4,%eax
  80095d:	89 45 14             	mov    %eax,0x14(%ebp)
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	83 e8 04             	sub    $0x4,%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	83 ec 08             	sub    $0x8,%esp
  80096b:	ff 75 0c             	pushl  0xc(%ebp)
  80096e:	50                   	push   %eax
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	ff d0                	call   *%eax
  800974:	83 c4 10             	add    $0x10,%esp
			break;
  800977:	e9 9b 02 00 00       	jmp    800c17 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80097c:	8b 45 14             	mov    0x14(%ebp),%eax
  80097f:	83 c0 04             	add    $0x4,%eax
  800982:	89 45 14             	mov    %eax,0x14(%ebp)
  800985:	8b 45 14             	mov    0x14(%ebp),%eax
  800988:	83 e8 04             	sub    $0x4,%eax
  80098b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80098d:	85 db                	test   %ebx,%ebx
  80098f:	79 02                	jns    800993 <vprintfmt+0x14a>
				err = -err;
  800991:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800993:	83 fb 64             	cmp    $0x64,%ebx
  800996:	7f 0b                	jg     8009a3 <vprintfmt+0x15a>
  800998:	8b 34 9d c0 24 80 00 	mov    0x8024c0(,%ebx,4),%esi
  80099f:	85 f6                	test   %esi,%esi
  8009a1:	75 19                	jne    8009bc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009a3:	53                   	push   %ebx
  8009a4:	68 65 26 80 00       	push   $0x802665
  8009a9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ac:	ff 75 08             	pushl  0x8(%ebp)
  8009af:	e8 70 02 00 00       	call   800c24 <printfmt>
  8009b4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009b7:	e9 5b 02 00 00       	jmp    800c17 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009bc:	56                   	push   %esi
  8009bd:	68 6e 26 80 00       	push   $0x80266e
  8009c2:	ff 75 0c             	pushl  0xc(%ebp)
  8009c5:	ff 75 08             	pushl  0x8(%ebp)
  8009c8:	e8 57 02 00 00       	call   800c24 <printfmt>
  8009cd:	83 c4 10             	add    $0x10,%esp
			break;
  8009d0:	e9 42 02 00 00       	jmp    800c17 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 c0 04             	add    $0x4,%eax
  8009db:	89 45 14             	mov    %eax,0x14(%ebp)
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	83 e8 04             	sub    $0x4,%eax
  8009e4:	8b 30                	mov    (%eax),%esi
  8009e6:	85 f6                	test   %esi,%esi
  8009e8:	75 05                	jne    8009ef <vprintfmt+0x1a6>
				p = "(null)";
  8009ea:	be 71 26 80 00       	mov    $0x802671,%esi
			if (width > 0 && padc != '-')
  8009ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f3:	7e 6d                	jle    800a62 <vprintfmt+0x219>
  8009f5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009f9:	74 67                	je     800a62 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	50                   	push   %eax
  800a02:	56                   	push   %esi
  800a03:	e8 1e 03 00 00       	call   800d26 <strnlen>
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a0e:	eb 16                	jmp    800a26 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a10:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a14:	83 ec 08             	sub    $0x8,%esp
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	50                   	push   %eax
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a23:	ff 4d e4             	decl   -0x1c(%ebp)
  800a26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2a:	7f e4                	jg     800a10 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a2c:	eb 34                	jmp    800a62 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a32:	74 1c                	je     800a50 <vprintfmt+0x207>
  800a34:	83 fb 1f             	cmp    $0x1f,%ebx
  800a37:	7e 05                	jle    800a3e <vprintfmt+0x1f5>
  800a39:	83 fb 7e             	cmp    $0x7e,%ebx
  800a3c:	7e 12                	jle    800a50 <vprintfmt+0x207>
					putch('?', putdat);
  800a3e:	83 ec 08             	sub    $0x8,%esp
  800a41:	ff 75 0c             	pushl  0xc(%ebp)
  800a44:	6a 3f                	push   $0x3f
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	ff d0                	call   *%eax
  800a4b:	83 c4 10             	add    $0x10,%esp
  800a4e:	eb 0f                	jmp    800a5f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	ff 75 0c             	pushl  0xc(%ebp)
  800a56:	53                   	push   %ebx
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	ff d0                	call   *%eax
  800a5c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800a62:	89 f0                	mov    %esi,%eax
  800a64:	8d 70 01             	lea    0x1(%eax),%esi
  800a67:	8a 00                	mov    (%eax),%al
  800a69:	0f be d8             	movsbl %al,%ebx
  800a6c:	85 db                	test   %ebx,%ebx
  800a6e:	74 24                	je     800a94 <vprintfmt+0x24b>
  800a70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a74:	78 b8                	js     800a2e <vprintfmt+0x1e5>
  800a76:	ff 4d e0             	decl   -0x20(%ebp)
  800a79:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a7d:	79 af                	jns    800a2e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a7f:	eb 13                	jmp    800a94 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a81:	83 ec 08             	sub    $0x8,%esp
  800a84:	ff 75 0c             	pushl  0xc(%ebp)
  800a87:	6a 20                	push   $0x20
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	ff d0                	call   *%eax
  800a8e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a91:	ff 4d e4             	decl   -0x1c(%ebp)
  800a94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a98:	7f e7                	jg     800a81 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a9a:	e9 78 01 00 00       	jmp    800c17 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa5:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa8:	50                   	push   %eax
  800aa9:	e8 3c fd ff ff       	call   8007ea <getint>
  800aae:	83 c4 10             	add    $0x10,%esp
  800ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800abd:	85 d2                	test   %edx,%edx
  800abf:	79 23                	jns    800ae4 <vprintfmt+0x29b>
				putch('-', putdat);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	6a 2d                	push   $0x2d
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	ff d0                	call   *%eax
  800ace:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad7:	f7 d8                	neg    %eax
  800ad9:	83 d2 00             	adc    $0x0,%edx
  800adc:	f7 da                	neg    %edx
  800ade:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ae4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aeb:	e9 bc 00 00 00       	jmp    800bac <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	ff 75 e8             	pushl  -0x18(%ebp)
  800af6:	8d 45 14             	lea    0x14(%ebp),%eax
  800af9:	50                   	push   %eax
  800afa:	e8 84 fc ff ff       	call   800783 <getuint>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b08:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b0f:	e9 98 00 00 00       	jmp    800bac <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	ff 75 0c             	pushl  0xc(%ebp)
  800b1a:	6a 58                	push   $0x58
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	ff d0                	call   *%eax
  800b21:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b24:	83 ec 08             	sub    $0x8,%esp
  800b27:	ff 75 0c             	pushl  0xc(%ebp)
  800b2a:	6a 58                	push   $0x58
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	ff d0                	call   *%eax
  800b31:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	ff 75 0c             	pushl  0xc(%ebp)
  800b3a:	6a 58                	push   $0x58
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	ff d0                	call   *%eax
  800b41:	83 c4 10             	add    $0x10,%esp
			break;
  800b44:	e9 ce 00 00 00       	jmp    800c17 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	ff 75 0c             	pushl  0xc(%ebp)
  800b4f:	6a 30                	push   $0x30
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	ff d0                	call   *%eax
  800b56:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	6a 78                	push   $0x78
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	ff d0                	call   *%eax
  800b66:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b69:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6c:	83 c0 04             	add    $0x4,%eax
  800b6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b72:	8b 45 14             	mov    0x14(%ebp),%eax
  800b75:	83 e8 04             	sub    $0x4,%eax
  800b78:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b84:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b8b:	eb 1f                	jmp    800bac <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	ff 75 e8             	pushl  -0x18(%ebp)
  800b93:	8d 45 14             	lea    0x14(%ebp),%eax
  800b96:	50                   	push   %eax
  800b97:	e8 e7 fb ff ff       	call   800783 <getuint>
  800b9c:	83 c4 10             	add    $0x10,%esp
  800b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ba5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bac:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb3:	83 ec 04             	sub    $0x4,%esp
  800bb6:	52                   	push   %edx
  800bb7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bba:	50                   	push   %eax
  800bbb:	ff 75 f4             	pushl  -0xc(%ebp)
  800bbe:	ff 75 f0             	pushl  -0x10(%ebp)
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	ff 75 08             	pushl  0x8(%ebp)
  800bc7:	e8 00 fb ff ff       	call   8006cc <printnum>
  800bcc:	83 c4 20             	add    $0x20,%esp
			break;
  800bcf:	eb 46                	jmp    800c17 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bd1:	83 ec 08             	sub    $0x8,%esp
  800bd4:	ff 75 0c             	pushl  0xc(%ebp)
  800bd7:	53                   	push   %ebx
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	ff d0                	call   *%eax
  800bdd:	83 c4 10             	add    $0x10,%esp
			break;
  800be0:	eb 35                	jmp    800c17 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800be2:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800be9:	eb 2c                	jmp    800c17 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800beb:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800bf2:	eb 23                	jmp    800c17 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bf4:	83 ec 08             	sub    $0x8,%esp
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	6a 25                	push   $0x25
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	ff d0                	call   *%eax
  800c01:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c04:	ff 4d 10             	decl   0x10(%ebp)
  800c07:	eb 03                	jmp    800c0c <vprintfmt+0x3c3>
  800c09:	ff 4d 10             	decl   0x10(%ebp)
  800c0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0f:	48                   	dec    %eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	3c 25                	cmp    $0x25,%al
  800c14:	75 f3                	jne    800c09 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c16:	90                   	nop
		}
	}
  800c17:	e9 35 fc ff ff       	jmp    800851 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c1c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c2a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c2d:	83 c0 04             	add    $0x4,%eax
  800c30:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c33:	8b 45 10             	mov    0x10(%ebp),%eax
  800c36:	ff 75 f4             	pushl  -0xc(%ebp)
  800c39:	50                   	push   %eax
  800c3a:	ff 75 0c             	pushl  0xc(%ebp)
  800c3d:	ff 75 08             	pushl  0x8(%ebp)
  800c40:	e8 04 fc ff ff       	call   800849 <vprintfmt>
  800c45:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c48:	90                   	nop
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c51:	8b 40 08             	mov    0x8(%eax),%eax
  800c54:	8d 50 01             	lea    0x1(%eax),%edx
  800c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	8b 10                	mov    (%eax),%edx
  800c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c65:	8b 40 04             	mov    0x4(%eax),%eax
  800c68:	39 c2                	cmp    %eax,%edx
  800c6a:	73 12                	jae    800c7e <sprintputch+0x33>
		*b->buf++ = ch;
  800c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6f:	8b 00                	mov    (%eax),%eax
  800c71:	8d 48 01             	lea    0x1(%eax),%ecx
  800c74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c77:	89 0a                	mov    %ecx,(%edx)
  800c79:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7c:	88 10                	mov    %dl,(%eax)
}
  800c7e:	90                   	nop
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c90:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	01 d0                	add    %edx,%eax
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ca2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ca6:	74 06                	je     800cae <vsnprintf+0x2d>
  800ca8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cac:	7f 07                	jg     800cb5 <vsnprintf+0x34>
		return -E_INVAL;
  800cae:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb3:	eb 20                	jmp    800cd5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cb5:	ff 75 14             	pushl  0x14(%ebp)
  800cb8:	ff 75 10             	pushl  0x10(%ebp)
  800cbb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cbe:	50                   	push   %eax
  800cbf:	68 4b 0c 80 00       	push   $0x800c4b
  800cc4:	e8 80 fb ff ff       	call   800849 <vprintfmt>
  800cc9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ccf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cd5:	c9                   	leave  
  800cd6:	c3                   	ret    

00800cd7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cdd:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce0:	83 c0 04             	add    $0x4,%eax
  800ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ce6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce9:	ff 75 f4             	pushl  -0xc(%ebp)
  800cec:	50                   	push   %eax
  800ced:	ff 75 0c             	pushl  0xc(%ebp)
  800cf0:	ff 75 08             	pushl  0x8(%ebp)
  800cf3:	e8 89 ff ff ff       	call   800c81 <vsnprintf>
  800cf8:	83 c4 10             	add    $0x10,%esp
  800cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d01:	c9                   	leave  
  800d02:	c3                   	ret    

00800d03 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d10:	eb 06                	jmp    800d18 <strlen+0x15>
		n++;
  800d12:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d15:	ff 45 08             	incl   0x8(%ebp)
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	84 c0                	test   %al,%al
  800d1f:	75 f1                	jne    800d12 <strlen+0xf>
		n++;
	return n;
  800d21:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d33:	eb 09                	jmp    800d3e <strnlen+0x18>
		n++;
  800d35:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d38:	ff 45 08             	incl   0x8(%ebp)
  800d3b:	ff 4d 0c             	decl   0xc(%ebp)
  800d3e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d42:	74 09                	je     800d4d <strnlen+0x27>
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	84 c0                	test   %al,%al
  800d4b:	75 e8                	jne    800d35 <strnlen+0xf>
		n++;
	return n;
  800d4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d50:	c9                   	leave  
  800d51:	c3                   	ret    

00800d52 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d5e:	90                   	nop
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8d 50 01             	lea    0x1(%eax),%edx
  800d65:	89 55 08             	mov    %edx,0x8(%ebp)
  800d68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d6e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d71:	8a 12                	mov    (%edx),%dl
  800d73:	88 10                	mov    %dl,(%eax)
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	84 c0                	test   %al,%al
  800d79:	75 e4                	jne    800d5f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d7e:	c9                   	leave  
  800d7f:	c3                   	ret    

00800d80 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d93:	eb 1f                	jmp    800db4 <strncpy+0x34>
		*dst++ = *src;
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8d 50 01             	lea    0x1(%eax),%edx
  800d9b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da1:	8a 12                	mov    (%edx),%dl
  800da3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	74 03                	je     800db1 <strncpy+0x31>
			src++;
  800dae:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800db1:	ff 45 fc             	incl   -0x4(%ebp)
  800db4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dba:	72 d9                	jb     800d95 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dbf:	c9                   	leave  
  800dc0:	c3                   	ret    

00800dc1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd1:	74 30                	je     800e03 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dd3:	eb 16                	jmp    800deb <strlcpy+0x2a>
			*dst++ = *src++;
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	8d 50 01             	lea    0x1(%eax),%edx
  800ddb:	89 55 08             	mov    %edx,0x8(%ebp)
  800dde:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800de7:	8a 12                	mov    (%edx),%dl
  800de9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800deb:	ff 4d 10             	decl   0x10(%ebp)
  800dee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df2:	74 09                	je     800dfd <strlcpy+0x3c>
  800df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	84 c0                	test   %al,%al
  800dfb:	75 d8                	jne    800dd5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e03:	8b 55 08             	mov    0x8(%ebp),%edx
  800e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e09:	29 c2                	sub    %eax,%edx
  800e0b:	89 d0                	mov    %edx,%eax
}
  800e0d:	c9                   	leave  
  800e0e:	c3                   	ret    

00800e0f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e12:	eb 06                	jmp    800e1a <strcmp+0xb>
		p++, q++;
  800e14:	ff 45 08             	incl   0x8(%ebp)
  800e17:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	84 c0                	test   %al,%al
  800e21:	74 0e                	je     800e31 <strcmp+0x22>
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8a 10                	mov    (%eax),%dl
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	38 c2                	cmp    %al,%dl
  800e2f:	74 e3                	je     800e14 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	0f b6 d0             	movzbl %al,%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	0f b6 c0             	movzbl %al,%eax
  800e41:	29 c2                	sub    %eax,%edx
  800e43:	89 d0                	mov    %edx,%eax
}
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    

00800e47 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e4a:	eb 09                	jmp    800e55 <strncmp+0xe>
		n--, p++, q++;
  800e4c:	ff 4d 10             	decl   0x10(%ebp)
  800e4f:	ff 45 08             	incl   0x8(%ebp)
  800e52:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e59:	74 17                	je     800e72 <strncmp+0x2b>
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	8a 00                	mov    (%eax),%al
  800e60:	84 c0                	test   %al,%al
  800e62:	74 0e                	je     800e72 <strncmp+0x2b>
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	8a 10                	mov    (%eax),%dl
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	38 c2                	cmp    %al,%dl
  800e70:	74 da                	je     800e4c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e76:	75 07                	jne    800e7f <strncmp+0x38>
		return 0;
  800e78:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7d:	eb 14                	jmp    800e93 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	0f b6 d0             	movzbl %al,%edx
  800e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	0f b6 c0             	movzbl %al,%eax
  800e8f:	29 c2                	sub    %eax,%edx
  800e91:	89 d0                	mov    %edx,%eax
}
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    

00800e95 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 04             	sub    $0x4,%esp
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea1:	eb 12                	jmp    800eb5 <strchr+0x20>
		if (*s == c)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eab:	75 05                	jne    800eb2 <strchr+0x1d>
			return (char *) s;
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	eb 11                	jmp    800ec3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eb2:	ff 45 08             	incl   0x8(%ebp)
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	84 c0                	test   %al,%al
  800ebc:	75 e5                	jne    800ea3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ebe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec3:	c9                   	leave  
  800ec4:	c3                   	ret    

00800ec5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 04             	sub    $0x4,%esp
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed1:	eb 0d                	jmp    800ee0 <strfind+0x1b>
		if (*s == c)
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8a 00                	mov    (%eax),%al
  800ed8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800edb:	74 0e                	je     800eeb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800edd:	ff 45 08             	incl   0x8(%ebp)
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	84 c0                	test   %al,%al
  800ee7:	75 ea                	jne    800ed3 <strfind+0xe>
  800ee9:	eb 01                	jmp    800eec <strfind+0x27>
		if (*s == c)
			break;
  800eeb:	90                   	nop
	return (char *) s;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800efd:	8b 45 10             	mov    0x10(%ebp),%eax
  800f00:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f03:	eb 0e                	jmp    800f13 <memset+0x22>
		*p++ = c;
  800f05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f08:	8d 50 01             	lea    0x1(%eax),%edx
  800f0b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f11:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f13:	ff 4d f8             	decl   -0x8(%ebp)
  800f16:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f1a:	79 e9                	jns    800f05 <memset+0x14>
		*p++ = c;

	return v;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f33:	eb 16                	jmp    800f4b <memcpy+0x2a>
		*d++ = *s++;
  800f35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f38:	8d 50 01             	lea    0x1(%eax),%edx
  800f3b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f41:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f44:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f47:	8a 12                	mov    (%edx),%dl
  800f49:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f51:	89 55 10             	mov    %edx,0x10(%ebp)
  800f54:	85 c0                	test   %eax,%eax
  800f56:	75 dd                	jne    800f35 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5b:	c9                   	leave  
  800f5c:	c3                   	ret    

00800f5d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f72:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f75:	73 50                	jae    800fc7 <memmove+0x6a>
  800f77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7d:	01 d0                	add    %edx,%eax
  800f7f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f82:	76 43                	jbe    800fc7 <memmove+0x6a>
		s += n;
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f90:	eb 10                	jmp    800fa2 <memmove+0x45>
			*--d = *--s;
  800f92:	ff 4d f8             	decl   -0x8(%ebp)
  800f95:	ff 4d fc             	decl   -0x4(%ebp)
  800f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9b:	8a 10                	mov    (%eax),%dl
  800f9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fa2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa8:	89 55 10             	mov    %edx,0x10(%ebp)
  800fab:	85 c0                	test   %eax,%eax
  800fad:	75 e3                	jne    800f92 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800faf:	eb 23                	jmp    800fd4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb4:	8d 50 01             	lea    0x1(%eax),%edx
  800fb7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fc3:	8a 12                	mov    (%edx),%dl
  800fc5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fca:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcd:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	75 dd                	jne    800fb1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800feb:	eb 2a                	jmp    801017 <memcmp+0x3e>
		if (*s1 != *s2)
  800fed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff0:	8a 10                	mov    (%eax),%dl
  800ff2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	38 c2                	cmp    %al,%dl
  800ff9:	74 16                	je     801011 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ffb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	0f b6 d0             	movzbl %al,%edx
  801003:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	0f b6 c0             	movzbl %al,%eax
  80100b:	29 c2                	sub    %eax,%edx
  80100d:	89 d0                	mov    %edx,%eax
  80100f:	eb 18                	jmp    801029 <memcmp+0x50>
		s1++, s2++;
  801011:	ff 45 fc             	incl   -0x4(%ebp)
  801014:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801017:	8b 45 10             	mov    0x10(%ebp),%eax
  80101a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101d:	89 55 10             	mov    %edx,0x10(%ebp)
  801020:	85 c0                	test   %eax,%eax
  801022:	75 c9                	jne    800fed <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801024:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801029:	c9                   	leave  
  80102a:	c3                   	ret    

0080102b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801031:	8b 55 08             	mov    0x8(%ebp),%edx
  801034:	8b 45 10             	mov    0x10(%ebp),%eax
  801037:	01 d0                	add    %edx,%eax
  801039:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80103c:	eb 15                	jmp    801053 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	0f b6 d0             	movzbl %al,%edx
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	0f b6 c0             	movzbl %al,%eax
  80104c:	39 c2                	cmp    %eax,%edx
  80104e:	74 0d                	je     80105d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801050:	ff 45 08             	incl   0x8(%ebp)
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801059:	72 e3                	jb     80103e <memfind+0x13>
  80105b:	eb 01                	jmp    80105e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80105d:	90                   	nop
	return (void *) s;
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801069:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801070:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801077:	eb 03                	jmp    80107c <strtol+0x19>
		s++;
  801079:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	3c 20                	cmp    $0x20,%al
  801083:	74 f4                	je     801079 <strtol+0x16>
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	3c 09                	cmp    $0x9,%al
  80108c:	74 eb                	je     801079 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	8a 00                	mov    (%eax),%al
  801093:	3c 2b                	cmp    $0x2b,%al
  801095:	75 05                	jne    80109c <strtol+0x39>
		s++;
  801097:	ff 45 08             	incl   0x8(%ebp)
  80109a:	eb 13                	jmp    8010af <strtol+0x4c>
	else if (*s == '-')
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	3c 2d                	cmp    $0x2d,%al
  8010a3:	75 0a                	jne    8010af <strtol+0x4c>
		s++, neg = 1;
  8010a5:	ff 45 08             	incl   0x8(%ebp)
  8010a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b3:	74 06                	je     8010bb <strtol+0x58>
  8010b5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010b9:	75 20                	jne    8010db <strtol+0x78>
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	3c 30                	cmp    $0x30,%al
  8010c2:	75 17                	jne    8010db <strtol+0x78>
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	40                   	inc    %eax
  8010c8:	8a 00                	mov    (%eax),%al
  8010ca:	3c 78                	cmp    $0x78,%al
  8010cc:	75 0d                	jne    8010db <strtol+0x78>
		s += 2, base = 16;
  8010ce:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010d2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010d9:	eb 28                	jmp    801103 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010df:	75 15                	jne    8010f6 <strtol+0x93>
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	3c 30                	cmp    $0x30,%al
  8010e8:	75 0c                	jne    8010f6 <strtol+0x93>
		s++, base = 8;
  8010ea:	ff 45 08             	incl   0x8(%ebp)
  8010ed:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010f4:	eb 0d                	jmp    801103 <strtol+0xa0>
	else if (base == 0)
  8010f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fa:	75 07                	jne    801103 <strtol+0xa0>
		base = 10;
  8010fc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	8a 00                	mov    (%eax),%al
  801108:	3c 2f                	cmp    $0x2f,%al
  80110a:	7e 19                	jle    801125 <strtol+0xc2>
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	3c 39                	cmp    $0x39,%al
  801113:	7f 10                	jg     801125 <strtol+0xc2>
			dig = *s - '0';
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	0f be c0             	movsbl %al,%eax
  80111d:	83 e8 30             	sub    $0x30,%eax
  801120:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801123:	eb 42                	jmp    801167 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	3c 60                	cmp    $0x60,%al
  80112c:	7e 19                	jle    801147 <strtol+0xe4>
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	3c 7a                	cmp    $0x7a,%al
  801135:	7f 10                	jg     801147 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	0f be c0             	movsbl %al,%eax
  80113f:	83 e8 57             	sub    $0x57,%eax
  801142:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801145:	eb 20                	jmp    801167 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	3c 40                	cmp    $0x40,%al
  80114e:	7e 39                	jle    801189 <strtol+0x126>
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	3c 5a                	cmp    $0x5a,%al
  801157:	7f 30                	jg     801189 <strtol+0x126>
			dig = *s - 'A' + 10;
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	0f be c0             	movsbl %al,%eax
  801161:	83 e8 37             	sub    $0x37,%eax
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80116d:	7d 19                	jge    801188 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80116f:	ff 45 08             	incl   0x8(%ebp)
  801172:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801175:	0f af 45 10          	imul   0x10(%ebp),%eax
  801179:	89 c2                	mov    %eax,%edx
  80117b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801183:	e9 7b ff ff ff       	jmp    801103 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801188:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801189:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80118d:	74 08                	je     801197 <strtol+0x134>
		*endptr = (char *) s;
  80118f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801192:	8b 55 08             	mov    0x8(%ebp),%edx
  801195:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801197:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119b:	74 07                	je     8011a4 <strtol+0x141>
  80119d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a0:	f7 d8                	neg    %eax
  8011a2:	eb 03                	jmp    8011a7 <strtol+0x144>
  8011a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011a7:	c9                   	leave  
  8011a8:	c3                   	ret    

008011a9 <ltostr>:

void
ltostr(long value, char *str)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c1:	79 13                	jns    8011d6 <ltostr+0x2d>
	{
		neg = 1;
  8011c3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011d0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011d3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011de:	99                   	cltd   
  8011df:	f7 f9                	idiv   %ecx
  8011e1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ea:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ed:	89 c2                	mov    %eax,%edx
  8011ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011f7:	83 c2 30             	add    $0x30,%edx
  8011fa:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011ff:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801204:	f7 e9                	imul   %ecx
  801206:	c1 fa 02             	sar    $0x2,%edx
  801209:	89 c8                	mov    %ecx,%eax
  80120b:	c1 f8 1f             	sar    $0x1f,%eax
  80120e:	29 c2                	sub    %eax,%edx
  801210:	89 d0                	mov    %edx,%eax
  801212:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801215:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801219:	75 bb                	jne    8011d6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80121b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801222:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801225:	48                   	dec    %eax
  801226:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801229:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80122d:	74 3d                	je     80126c <ltostr+0xc3>
		start = 1 ;
  80122f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801236:	eb 34                	jmp    80126c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801238:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123e:	01 d0                	add    %edx,%eax
  801240:	8a 00                	mov    (%eax),%al
  801242:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801245:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	01 c2                	add    %eax,%edx
  80124d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801250:	8b 45 0c             	mov    0xc(%ebp),%eax
  801253:	01 c8                	add    %ecx,%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801259:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	01 c2                	add    %eax,%edx
  801261:	8a 45 eb             	mov    -0x15(%ebp),%al
  801264:	88 02                	mov    %al,(%edx)
		start++ ;
  801266:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801269:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80126c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801272:	7c c4                	jl     801238 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801274:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	01 d0                	add    %edx,%eax
  80127c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80127f:	90                   	nop
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801288:	ff 75 08             	pushl  0x8(%ebp)
  80128b:	e8 73 fa ff ff       	call   800d03 <strlen>
  801290:	83 c4 04             	add    $0x4,%esp
  801293:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	e8 65 fa ff ff       	call   800d03 <strlen>
  80129e:	83 c4 04             	add    $0x4,%esp
  8012a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b2:	eb 17                	jmp    8012cb <strcconcat+0x49>
		final[s] = str1[s] ;
  8012b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ba:	01 c2                	add    %eax,%edx
  8012bc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	01 c8                	add    %ecx,%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012c8:	ff 45 fc             	incl   -0x4(%ebp)
  8012cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ce:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012d1:	7c e1                	jl     8012b4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012e1:	eb 1f                	jmp    801302 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e6:	8d 50 01             	lea    0x1(%eax),%edx
  8012e9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ec:	89 c2                	mov    %eax,%edx
  8012ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f1:	01 c2                	add    %eax,%edx
  8012f3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f9:	01 c8                	add    %ecx,%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012ff:	ff 45 f8             	incl   -0x8(%ebp)
  801302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801305:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801308:	7c d9                	jl     8012e3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80130a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130d:	8b 45 10             	mov    0x10(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	c6 00 00             	movb   $0x0,(%eax)
}
  801315:	90                   	nop
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80131b:	8b 45 14             	mov    0x14(%ebp),%eax
  80131e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801324:	8b 45 14             	mov    0x14(%ebp),%eax
  801327:	8b 00                	mov    (%eax),%eax
  801329:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801330:	8b 45 10             	mov    0x10(%ebp),%eax
  801333:	01 d0                	add    %edx,%eax
  801335:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80133b:	eb 0c                	jmp    801349 <strsplit+0x31>
			*string++ = 0;
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	8d 50 01             	lea    0x1(%eax),%edx
  801343:	89 55 08             	mov    %edx,0x8(%ebp)
  801346:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	84 c0                	test   %al,%al
  801350:	74 18                	je     80136a <strsplit+0x52>
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	0f be c0             	movsbl %al,%eax
  80135a:	50                   	push   %eax
  80135b:	ff 75 0c             	pushl  0xc(%ebp)
  80135e:	e8 32 fb ff ff       	call   800e95 <strchr>
  801363:	83 c4 08             	add    $0x8,%esp
  801366:	85 c0                	test   %eax,%eax
  801368:	75 d3                	jne    80133d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	84 c0                	test   %al,%al
  801371:	74 5a                	je     8013cd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801373:	8b 45 14             	mov    0x14(%ebp),%eax
  801376:	8b 00                	mov    (%eax),%eax
  801378:	83 f8 0f             	cmp    $0xf,%eax
  80137b:	75 07                	jne    801384 <strsplit+0x6c>
		{
			return 0;
  80137d:	b8 00 00 00 00       	mov    $0x0,%eax
  801382:	eb 66                	jmp    8013ea <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801384:	8b 45 14             	mov    0x14(%ebp),%eax
  801387:	8b 00                	mov    (%eax),%eax
  801389:	8d 48 01             	lea    0x1(%eax),%ecx
  80138c:	8b 55 14             	mov    0x14(%ebp),%edx
  80138f:	89 0a                	mov    %ecx,(%edx)
  801391:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801398:	8b 45 10             	mov    0x10(%ebp),%eax
  80139b:	01 c2                	add    %eax,%edx
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a2:	eb 03                	jmp    8013a7 <strsplit+0x8f>
			string++;
  8013a4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	8a 00                	mov    (%eax),%al
  8013ac:	84 c0                	test   %al,%al
  8013ae:	74 8b                	je     80133b <strsplit+0x23>
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	0f be c0             	movsbl %al,%eax
  8013b8:	50                   	push   %eax
  8013b9:	ff 75 0c             	pushl  0xc(%ebp)
  8013bc:	e8 d4 fa ff ff       	call   800e95 <strchr>
  8013c1:	83 c4 08             	add    $0x8,%esp
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	74 dc                	je     8013a4 <strsplit+0x8c>
			string++;
	}
  8013c8:	e9 6e ff ff ff       	jmp    80133b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013cd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d1:	8b 00                	mov    (%eax),%eax
  8013d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013da:	8b 45 10             	mov    0x10(%ebp),%eax
  8013dd:	01 d0                	add    %edx,%eax
  8013df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013e5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8013f2:	83 ec 04             	sub    $0x4,%esp
  8013f5:	68 e8 27 80 00       	push   $0x8027e8
  8013fa:	68 3f 01 00 00       	push   $0x13f
  8013ff:	68 0a 28 80 00       	push   $0x80280a
  801404:	e8 a9 ef ff ff       	call   8003b2 <_panic>

00801409 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
  80140c:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80140f:	83 ec 0c             	sub    $0xc,%esp
  801412:	ff 75 08             	pushl  0x8(%ebp)
  801415:	e8 ef 06 00 00       	call   801b09 <sys_sbrk>
  80141a:	83 c4 10             	add    $0x10,%esp
}
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801425:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801429:	75 07                	jne    801432 <malloc+0x13>
  80142b:	b8 00 00 00 00       	mov    $0x0,%eax
  801430:	eb 14                	jmp    801446 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801432:	83 ec 04             	sub    $0x4,%esp
  801435:	68 18 28 80 00       	push   $0x802818
  80143a:	6a 1b                	push   $0x1b
  80143c:	68 3d 28 80 00       	push   $0x80283d
  801441:	e8 6c ef ff ff       	call   8003b2 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801446:	c9                   	leave  
  801447:	c3                   	ret    

00801448 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80144e:	83 ec 04             	sub    $0x4,%esp
  801451:	68 4c 28 80 00       	push   $0x80284c
  801456:	6a 29                	push   $0x29
  801458:	68 3d 28 80 00       	push   $0x80283d
  80145d:	e8 50 ef ff ff       	call   8003b2 <_panic>

00801462 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 18             	sub    $0x18,%esp
  801468:	8b 45 10             	mov    0x10(%ebp),%eax
  80146b:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80146e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801472:	75 07                	jne    80147b <smalloc+0x19>
  801474:	b8 00 00 00 00       	mov    $0x0,%eax
  801479:	eb 14                	jmp    80148f <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80147b:	83 ec 04             	sub    $0x4,%esp
  80147e:	68 70 28 80 00       	push   $0x802870
  801483:	6a 38                	push   $0x38
  801485:	68 3d 28 80 00       	push   $0x80283d
  80148a:	e8 23 ef ff ff       	call   8003b2 <_panic>
	return NULL;
}
  80148f:	c9                   	leave  
  801490:	c3                   	ret    

00801491 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801497:	83 ec 04             	sub    $0x4,%esp
  80149a:	68 98 28 80 00       	push   $0x802898
  80149f:	6a 43                	push   $0x43
  8014a1:	68 3d 28 80 00       	push   $0x80283d
  8014a6:	e8 07 ef ff ff       	call   8003b2 <_panic>

008014ab <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8014b1:	83 ec 04             	sub    $0x4,%esp
  8014b4:	68 bc 28 80 00       	push   $0x8028bc
  8014b9:	6a 5b                	push   $0x5b
  8014bb:	68 3d 28 80 00       	push   $0x80283d
  8014c0:	e8 ed ee ff ff       	call   8003b2 <_panic>

008014c5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8014cb:	83 ec 04             	sub    $0x4,%esp
  8014ce:	68 e0 28 80 00       	push   $0x8028e0
  8014d3:	6a 72                	push   $0x72
  8014d5:	68 3d 28 80 00       	push   $0x80283d
  8014da:	e8 d3 ee ff ff       	call   8003b2 <_panic>

008014df <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014e5:	83 ec 04             	sub    $0x4,%esp
  8014e8:	68 06 29 80 00       	push   $0x802906
  8014ed:	6a 7e                	push   $0x7e
  8014ef:	68 3d 28 80 00       	push   $0x80283d
  8014f4:	e8 b9 ee ff ff       	call   8003b2 <_panic>

008014f9 <shrink>:

}
void shrink(uint32 newSize)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014ff:	83 ec 04             	sub    $0x4,%esp
  801502:	68 06 29 80 00       	push   $0x802906
  801507:	68 83 00 00 00       	push   $0x83
  80150c:	68 3d 28 80 00       	push   $0x80283d
  801511:	e8 9c ee ff ff       	call   8003b2 <_panic>

00801516 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80151c:	83 ec 04             	sub    $0x4,%esp
  80151f:	68 06 29 80 00       	push   $0x802906
  801524:	68 88 00 00 00       	push   $0x88
  801529:	68 3d 28 80 00       	push   $0x80283d
  80152e:	e8 7f ee ff ff       	call   8003b2 <_panic>

00801533 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	57                   	push   %edi
  801537:	56                   	push   %esi
  801538:	53                   	push   %ebx
  801539:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801542:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801545:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801548:	8b 7d 18             	mov    0x18(%ebp),%edi
  80154b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80154e:	cd 30                	int    $0x30
  801550:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801553:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801556:	83 c4 10             	add    $0x10,%esp
  801559:	5b                   	pop    %ebx
  80155a:	5e                   	pop    %esi
  80155b:	5f                   	pop    %edi
  80155c:	5d                   	pop    %ebp
  80155d:	c3                   	ret    

0080155e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 04             	sub    $0x4,%esp
  801564:	8b 45 10             	mov    0x10(%ebp),%eax
  801567:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80156a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	52                   	push   %edx
  801576:	ff 75 0c             	pushl  0xc(%ebp)
  801579:	50                   	push   %eax
  80157a:	6a 00                	push   $0x0
  80157c:	e8 b2 ff ff ff       	call   801533 <syscall>
  801581:	83 c4 18             	add    $0x18,%esp
}
  801584:	90                   	nop
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <sys_cgetc>:

int
sys_cgetc(void)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 02                	push   $0x2
  801596:	e8 98 ff ff ff       	call   801533 <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 03                	push   $0x3
  8015af:	e8 7f ff ff ff       	call   801533 <syscall>
  8015b4:	83 c4 18             	add    $0x18,%esp
}
  8015b7:	90                   	nop
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 04                	push   $0x4
  8015c9:	e8 65 ff ff ff       	call   801533 <syscall>
  8015ce:	83 c4 18             	add    $0x18,%esp
}
  8015d1:	90                   	nop
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	52                   	push   %edx
  8015e4:	50                   	push   %eax
  8015e5:	6a 08                	push   $0x8
  8015e7:	e8 47 ff ff ff       	call   801533 <syscall>
  8015ec:	83 c4 18             	add    $0x18,%esp
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	56                   	push   %esi
  8015f5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015f6:	8b 75 18             	mov    0x18(%ebp),%esi
  8015f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	56                   	push   %esi
  801606:	53                   	push   %ebx
  801607:	51                   	push   %ecx
  801608:	52                   	push   %edx
  801609:	50                   	push   %eax
  80160a:	6a 09                	push   $0x9
  80160c:	e8 22 ff ff ff       	call   801533 <syscall>
  801611:	83 c4 18             	add    $0x18,%esp
}
  801614:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801617:	5b                   	pop    %ebx
  801618:	5e                   	pop    %esi
  801619:	5d                   	pop    %ebp
  80161a:	c3                   	ret    

0080161b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80161e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	52                   	push   %edx
  80162b:	50                   	push   %eax
  80162c:	6a 0a                	push   $0xa
  80162e:	e8 00 ff ff ff       	call   801533 <syscall>
  801633:	83 c4 18             	add    $0x18,%esp
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	ff 75 0c             	pushl  0xc(%ebp)
  801644:	ff 75 08             	pushl  0x8(%ebp)
  801647:	6a 0b                	push   $0xb
  801649:	e8 e5 fe ff ff       	call   801533 <syscall>
  80164e:	83 c4 18             	add    $0x18,%esp
}
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 0c                	push   $0xc
  801662:	e8 cc fe ff ff       	call   801533 <syscall>
  801667:	83 c4 18             	add    $0x18,%esp
}
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 0d                	push   $0xd
  80167b:	e8 b3 fe ff ff       	call   801533 <syscall>
  801680:	83 c4 18             	add    $0x18,%esp
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 0e                	push   $0xe
  801694:	e8 9a fe ff ff       	call   801533 <syscall>
  801699:	83 c4 18             	add    $0x18,%esp
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 0f                	push   $0xf
  8016ad:	e8 81 fe ff ff       	call   801533 <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	ff 75 08             	pushl  0x8(%ebp)
  8016c5:	6a 10                	push   $0x10
  8016c7:	e8 67 fe ff ff       	call   801533 <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 11                	push   $0x11
  8016e0:	e8 4e fe ff ff       	call   801533 <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
}
  8016e8:	90                   	nop
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sys_cputc>:

void
sys_cputc(const char c)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	83 ec 04             	sub    $0x4,%esp
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016f7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	50                   	push   %eax
  801704:	6a 01                	push   $0x1
  801706:	e8 28 fe ff ff       	call   801533 <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	90                   	nop
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 14                	push   $0x14
  801720:	e8 0e fe ff ff       	call   801533 <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
}
  801728:	90                   	nop
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	83 ec 04             	sub    $0x4,%esp
  801731:	8b 45 10             	mov    0x10(%ebp),%eax
  801734:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801737:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80173a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	6a 00                	push   $0x0
  801743:	51                   	push   %ecx
  801744:	52                   	push   %edx
  801745:	ff 75 0c             	pushl  0xc(%ebp)
  801748:	50                   	push   %eax
  801749:	6a 15                	push   $0x15
  80174b:	e8 e3 fd ff ff       	call   801533 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801758:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	52                   	push   %edx
  801765:	50                   	push   %eax
  801766:	6a 16                	push   $0x16
  801768:	e8 c6 fd ff ff       	call   801533 <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801775:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801778:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	51                   	push   %ecx
  801783:	52                   	push   %edx
  801784:	50                   	push   %eax
  801785:	6a 17                	push   $0x17
  801787:	e8 a7 fd ff ff       	call   801533 <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801794:	8b 55 0c             	mov    0xc(%ebp),%edx
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	52                   	push   %edx
  8017a1:	50                   	push   %eax
  8017a2:	6a 18                	push   $0x18
  8017a4:	e8 8a fd ff ff       	call   801533 <syscall>
  8017a9:	83 c4 18             	add    $0x18,%esp
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	6a 00                	push   $0x0
  8017b6:	ff 75 14             	pushl  0x14(%ebp)
  8017b9:	ff 75 10             	pushl  0x10(%ebp)
  8017bc:	ff 75 0c             	pushl  0xc(%ebp)
  8017bf:	50                   	push   %eax
  8017c0:	6a 19                	push   $0x19
  8017c2:	e8 6c fd ff ff       	call   801533 <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <sys_run_env>:

void sys_run_env(int32 envId)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	50                   	push   %eax
  8017db:	6a 1a                	push   $0x1a
  8017dd:	e8 51 fd ff ff       	call   801533 <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
}
  8017e5:	90                   	nop
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	50                   	push   %eax
  8017f7:	6a 1b                	push   $0x1b
  8017f9:	e8 35 fd ff ff       	call   801533 <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 05                	push   $0x5
  801812:	e8 1c fd ff ff       	call   801533 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 06                	push   $0x6
  80182b:	e8 03 fd ff ff       	call   801533 <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 07                	push   $0x7
  801844:	e8 ea fc ff ff       	call   801533 <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_exit_env>:


void sys_exit_env(void)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 1c                	push   $0x1c
  80185d:	e8 d1 fc ff ff       	call   801533 <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
}
  801865:	90                   	nop
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80186e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801871:	8d 50 04             	lea    0x4(%eax),%edx
  801874:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	52                   	push   %edx
  80187e:	50                   	push   %eax
  80187f:	6a 1d                	push   $0x1d
  801881:	e8 ad fc ff ff       	call   801533 <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
	return result;
  801889:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80188c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80188f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801892:	89 01                	mov    %eax,(%ecx)
  801894:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	c9                   	leave  
  80189b:	c2 04 00             	ret    $0x4

0080189e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	ff 75 10             	pushl  0x10(%ebp)
  8018a8:	ff 75 0c             	pushl  0xc(%ebp)
  8018ab:	ff 75 08             	pushl  0x8(%ebp)
  8018ae:	6a 13                	push   $0x13
  8018b0:	e8 7e fc ff ff       	call   801533 <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b8:	90                   	nop
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_rcr2>:
uint32 sys_rcr2()
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 1e                	push   $0x1e
  8018ca:	e8 64 fc ff ff       	call   801533 <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	83 ec 04             	sub    $0x4,%esp
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018e0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	50                   	push   %eax
  8018ed:	6a 1f                	push   $0x1f
  8018ef:	e8 3f fc ff ff       	call   801533 <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f7:	90                   	nop
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <rsttst>:
void rsttst()
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 21                	push   $0x21
  801909:	e8 25 fc ff ff       	call   801533 <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
	return ;
  801911:	90                   	nop
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 04             	sub    $0x4,%esp
  80191a:	8b 45 14             	mov    0x14(%ebp),%eax
  80191d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801920:	8b 55 18             	mov    0x18(%ebp),%edx
  801923:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801927:	52                   	push   %edx
  801928:	50                   	push   %eax
  801929:	ff 75 10             	pushl  0x10(%ebp)
  80192c:	ff 75 0c             	pushl  0xc(%ebp)
  80192f:	ff 75 08             	pushl  0x8(%ebp)
  801932:	6a 20                	push   $0x20
  801934:	e8 fa fb ff ff       	call   801533 <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
	return ;
  80193c:	90                   	nop
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <chktst>:
void chktst(uint32 n)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	ff 75 08             	pushl  0x8(%ebp)
  80194d:	6a 22                	push   $0x22
  80194f:	e8 df fb ff ff       	call   801533 <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
	return ;
  801957:	90                   	nop
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <inctst>:

void inctst()
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 23                	push   $0x23
  801969:	e8 c5 fb ff ff       	call   801533 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
	return ;
  801971:	90                   	nop
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <gettst>:
uint32 gettst()
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 24                	push   $0x24
  801983:	e8 ab fb ff ff       	call   801533 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 25                	push   $0x25
  80199f:	e8 8f fb ff ff       	call   801533 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
  8019a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019aa:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019ae:	75 07                	jne    8019b7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b5:	eb 05                	jmp    8019bc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 25                	push   $0x25
  8019d0:	e8 5e fb ff ff       	call   801533 <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
  8019d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019db:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019df:	75 07                	jne    8019e8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e6:	eb 05                	jmp    8019ed <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 25                	push   $0x25
  801a01:	e8 2d fb ff ff       	call   801533 <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
  801a09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a0c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a10:	75 07                	jne    801a19 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a12:	b8 01 00 00 00       	mov    $0x1,%eax
  801a17:	eb 05                	jmp    801a1e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 25                	push   $0x25
  801a32:	e8 fc fa ff ff       	call   801533 <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
  801a3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a3d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a41:	75 07                	jne    801a4a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a43:	b8 01 00 00 00       	mov    $0x1,%eax
  801a48:	eb 05                	jmp    801a4f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	ff 75 08             	pushl  0x8(%ebp)
  801a5f:	6a 26                	push   $0x26
  801a61:	e8 cd fa ff ff       	call   801533 <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
	return ;
  801a69:	90                   	nop
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a70:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a73:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	6a 00                	push   $0x0
  801a7e:	53                   	push   %ebx
  801a7f:	51                   	push   %ecx
  801a80:	52                   	push   %edx
  801a81:	50                   	push   %eax
  801a82:	6a 27                	push   $0x27
  801a84:	e8 aa fa ff ff       	call   801533 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	52                   	push   %edx
  801aa1:	50                   	push   %eax
  801aa2:	6a 28                	push   $0x28
  801aa4:	e8 8a fa ff ff       	call   801533 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ab1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ab4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	6a 00                	push   $0x0
  801abc:	51                   	push   %ecx
  801abd:	ff 75 10             	pushl  0x10(%ebp)
  801ac0:	52                   	push   %edx
  801ac1:	50                   	push   %eax
  801ac2:	6a 29                	push   $0x29
  801ac4:	e8 6a fa ff ff       	call   801533 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	ff 75 10             	pushl  0x10(%ebp)
  801ad8:	ff 75 0c             	pushl  0xc(%ebp)
  801adb:	ff 75 08             	pushl  0x8(%ebp)
  801ade:	6a 12                	push   $0x12
  801ae0:	e8 4e fa ff ff       	call   801533 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae8:	90                   	nop
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	52                   	push   %edx
  801afb:	50                   	push   %eax
  801afc:	6a 2a                	push   $0x2a
  801afe:	e8 30 fa ff ff       	call   801533 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
	return;
  801b06:	90                   	nop
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	50                   	push   %eax
  801b18:	6a 2b                	push   $0x2b
  801b1a:	e8 14 fa ff ff       	call   801533 <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	ff 75 0c             	pushl  0xc(%ebp)
  801b30:	ff 75 08             	pushl  0x8(%ebp)
  801b33:	6a 2c                	push   $0x2c
  801b35:	e8 f9 f9 ff ff       	call   801533 <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
	return;
  801b3d:	90                   	nop
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	ff 75 0c             	pushl  0xc(%ebp)
  801b4c:	ff 75 08             	pushl  0x8(%ebp)
  801b4f:	6a 2d                	push   $0x2d
  801b51:	e8 dd f9 ff ff       	call   801533 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
	return;
  801b59:	90                   	nop
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <__udivdi3>:
  801b5c:	55                   	push   %ebp
  801b5d:	57                   	push   %edi
  801b5e:	56                   	push   %esi
  801b5f:	53                   	push   %ebx
  801b60:	83 ec 1c             	sub    $0x1c,%esp
  801b63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b73:	89 ca                	mov    %ecx,%edx
  801b75:	89 f8                	mov    %edi,%eax
  801b77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b7b:	85 f6                	test   %esi,%esi
  801b7d:	75 2d                	jne    801bac <__udivdi3+0x50>
  801b7f:	39 cf                	cmp    %ecx,%edi
  801b81:	77 65                	ja     801be8 <__udivdi3+0x8c>
  801b83:	89 fd                	mov    %edi,%ebp
  801b85:	85 ff                	test   %edi,%edi
  801b87:	75 0b                	jne    801b94 <__udivdi3+0x38>
  801b89:	b8 01 00 00 00       	mov    $0x1,%eax
  801b8e:	31 d2                	xor    %edx,%edx
  801b90:	f7 f7                	div    %edi
  801b92:	89 c5                	mov    %eax,%ebp
  801b94:	31 d2                	xor    %edx,%edx
  801b96:	89 c8                	mov    %ecx,%eax
  801b98:	f7 f5                	div    %ebp
  801b9a:	89 c1                	mov    %eax,%ecx
  801b9c:	89 d8                	mov    %ebx,%eax
  801b9e:	f7 f5                	div    %ebp
  801ba0:	89 cf                	mov    %ecx,%edi
  801ba2:	89 fa                	mov    %edi,%edx
  801ba4:	83 c4 1c             	add    $0x1c,%esp
  801ba7:	5b                   	pop    %ebx
  801ba8:	5e                   	pop    %esi
  801ba9:	5f                   	pop    %edi
  801baa:	5d                   	pop    %ebp
  801bab:	c3                   	ret    
  801bac:	39 ce                	cmp    %ecx,%esi
  801bae:	77 28                	ja     801bd8 <__udivdi3+0x7c>
  801bb0:	0f bd fe             	bsr    %esi,%edi
  801bb3:	83 f7 1f             	xor    $0x1f,%edi
  801bb6:	75 40                	jne    801bf8 <__udivdi3+0x9c>
  801bb8:	39 ce                	cmp    %ecx,%esi
  801bba:	72 0a                	jb     801bc6 <__udivdi3+0x6a>
  801bbc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bc0:	0f 87 9e 00 00 00    	ja     801c64 <__udivdi3+0x108>
  801bc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bcb:	89 fa                	mov    %edi,%edx
  801bcd:	83 c4 1c             	add    $0x1c,%esp
  801bd0:	5b                   	pop    %ebx
  801bd1:	5e                   	pop    %esi
  801bd2:	5f                   	pop    %edi
  801bd3:	5d                   	pop    %ebp
  801bd4:	c3                   	ret    
  801bd5:	8d 76 00             	lea    0x0(%esi),%esi
  801bd8:	31 ff                	xor    %edi,%edi
  801bda:	31 c0                	xor    %eax,%eax
  801bdc:	89 fa                	mov    %edi,%edx
  801bde:	83 c4 1c             	add    $0x1c,%esp
  801be1:	5b                   	pop    %ebx
  801be2:	5e                   	pop    %esi
  801be3:	5f                   	pop    %edi
  801be4:	5d                   	pop    %ebp
  801be5:	c3                   	ret    
  801be6:	66 90                	xchg   %ax,%ax
  801be8:	89 d8                	mov    %ebx,%eax
  801bea:	f7 f7                	div    %edi
  801bec:	31 ff                	xor    %edi,%edi
  801bee:	89 fa                	mov    %edi,%edx
  801bf0:	83 c4 1c             	add    $0x1c,%esp
  801bf3:	5b                   	pop    %ebx
  801bf4:	5e                   	pop    %esi
  801bf5:	5f                   	pop    %edi
  801bf6:	5d                   	pop    %ebp
  801bf7:	c3                   	ret    
  801bf8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801bfd:	89 eb                	mov    %ebp,%ebx
  801bff:	29 fb                	sub    %edi,%ebx
  801c01:	89 f9                	mov    %edi,%ecx
  801c03:	d3 e6                	shl    %cl,%esi
  801c05:	89 c5                	mov    %eax,%ebp
  801c07:	88 d9                	mov    %bl,%cl
  801c09:	d3 ed                	shr    %cl,%ebp
  801c0b:	89 e9                	mov    %ebp,%ecx
  801c0d:	09 f1                	or     %esi,%ecx
  801c0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c13:	89 f9                	mov    %edi,%ecx
  801c15:	d3 e0                	shl    %cl,%eax
  801c17:	89 c5                	mov    %eax,%ebp
  801c19:	89 d6                	mov    %edx,%esi
  801c1b:	88 d9                	mov    %bl,%cl
  801c1d:	d3 ee                	shr    %cl,%esi
  801c1f:	89 f9                	mov    %edi,%ecx
  801c21:	d3 e2                	shl    %cl,%edx
  801c23:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c27:	88 d9                	mov    %bl,%cl
  801c29:	d3 e8                	shr    %cl,%eax
  801c2b:	09 c2                	or     %eax,%edx
  801c2d:	89 d0                	mov    %edx,%eax
  801c2f:	89 f2                	mov    %esi,%edx
  801c31:	f7 74 24 0c          	divl   0xc(%esp)
  801c35:	89 d6                	mov    %edx,%esi
  801c37:	89 c3                	mov    %eax,%ebx
  801c39:	f7 e5                	mul    %ebp
  801c3b:	39 d6                	cmp    %edx,%esi
  801c3d:	72 19                	jb     801c58 <__udivdi3+0xfc>
  801c3f:	74 0b                	je     801c4c <__udivdi3+0xf0>
  801c41:	89 d8                	mov    %ebx,%eax
  801c43:	31 ff                	xor    %edi,%edi
  801c45:	e9 58 ff ff ff       	jmp    801ba2 <__udivdi3+0x46>
  801c4a:	66 90                	xchg   %ax,%ax
  801c4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c50:	89 f9                	mov    %edi,%ecx
  801c52:	d3 e2                	shl    %cl,%edx
  801c54:	39 c2                	cmp    %eax,%edx
  801c56:	73 e9                	jae    801c41 <__udivdi3+0xe5>
  801c58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c5b:	31 ff                	xor    %edi,%edi
  801c5d:	e9 40 ff ff ff       	jmp    801ba2 <__udivdi3+0x46>
  801c62:	66 90                	xchg   %ax,%ax
  801c64:	31 c0                	xor    %eax,%eax
  801c66:	e9 37 ff ff ff       	jmp    801ba2 <__udivdi3+0x46>
  801c6b:	90                   	nop

00801c6c <__umoddi3>:
  801c6c:	55                   	push   %ebp
  801c6d:	57                   	push   %edi
  801c6e:	56                   	push   %esi
  801c6f:	53                   	push   %ebx
  801c70:	83 ec 1c             	sub    $0x1c,%esp
  801c73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c77:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c8b:	89 f3                	mov    %esi,%ebx
  801c8d:	89 fa                	mov    %edi,%edx
  801c8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c93:	89 34 24             	mov    %esi,(%esp)
  801c96:	85 c0                	test   %eax,%eax
  801c98:	75 1a                	jne    801cb4 <__umoddi3+0x48>
  801c9a:	39 f7                	cmp    %esi,%edi
  801c9c:	0f 86 a2 00 00 00    	jbe    801d44 <__umoddi3+0xd8>
  801ca2:	89 c8                	mov    %ecx,%eax
  801ca4:	89 f2                	mov    %esi,%edx
  801ca6:	f7 f7                	div    %edi
  801ca8:	89 d0                	mov    %edx,%eax
  801caa:	31 d2                	xor    %edx,%edx
  801cac:	83 c4 1c             	add    $0x1c,%esp
  801caf:	5b                   	pop    %ebx
  801cb0:	5e                   	pop    %esi
  801cb1:	5f                   	pop    %edi
  801cb2:	5d                   	pop    %ebp
  801cb3:	c3                   	ret    
  801cb4:	39 f0                	cmp    %esi,%eax
  801cb6:	0f 87 ac 00 00 00    	ja     801d68 <__umoddi3+0xfc>
  801cbc:	0f bd e8             	bsr    %eax,%ebp
  801cbf:	83 f5 1f             	xor    $0x1f,%ebp
  801cc2:	0f 84 ac 00 00 00    	je     801d74 <__umoddi3+0x108>
  801cc8:	bf 20 00 00 00       	mov    $0x20,%edi
  801ccd:	29 ef                	sub    %ebp,%edi
  801ccf:	89 fe                	mov    %edi,%esi
  801cd1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cd5:	89 e9                	mov    %ebp,%ecx
  801cd7:	d3 e0                	shl    %cl,%eax
  801cd9:	89 d7                	mov    %edx,%edi
  801cdb:	89 f1                	mov    %esi,%ecx
  801cdd:	d3 ef                	shr    %cl,%edi
  801cdf:	09 c7                	or     %eax,%edi
  801ce1:	89 e9                	mov    %ebp,%ecx
  801ce3:	d3 e2                	shl    %cl,%edx
  801ce5:	89 14 24             	mov    %edx,(%esp)
  801ce8:	89 d8                	mov    %ebx,%eax
  801cea:	d3 e0                	shl    %cl,%eax
  801cec:	89 c2                	mov    %eax,%edx
  801cee:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cf2:	d3 e0                	shl    %cl,%eax
  801cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cfc:	89 f1                	mov    %esi,%ecx
  801cfe:	d3 e8                	shr    %cl,%eax
  801d00:	09 d0                	or     %edx,%eax
  801d02:	d3 eb                	shr    %cl,%ebx
  801d04:	89 da                	mov    %ebx,%edx
  801d06:	f7 f7                	div    %edi
  801d08:	89 d3                	mov    %edx,%ebx
  801d0a:	f7 24 24             	mull   (%esp)
  801d0d:	89 c6                	mov    %eax,%esi
  801d0f:	89 d1                	mov    %edx,%ecx
  801d11:	39 d3                	cmp    %edx,%ebx
  801d13:	0f 82 87 00 00 00    	jb     801da0 <__umoddi3+0x134>
  801d19:	0f 84 91 00 00 00    	je     801db0 <__umoddi3+0x144>
  801d1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d23:	29 f2                	sub    %esi,%edx
  801d25:	19 cb                	sbb    %ecx,%ebx
  801d27:	89 d8                	mov    %ebx,%eax
  801d29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d2d:	d3 e0                	shl    %cl,%eax
  801d2f:	89 e9                	mov    %ebp,%ecx
  801d31:	d3 ea                	shr    %cl,%edx
  801d33:	09 d0                	or     %edx,%eax
  801d35:	89 e9                	mov    %ebp,%ecx
  801d37:	d3 eb                	shr    %cl,%ebx
  801d39:	89 da                	mov    %ebx,%edx
  801d3b:	83 c4 1c             	add    $0x1c,%esp
  801d3e:	5b                   	pop    %ebx
  801d3f:	5e                   	pop    %esi
  801d40:	5f                   	pop    %edi
  801d41:	5d                   	pop    %ebp
  801d42:	c3                   	ret    
  801d43:	90                   	nop
  801d44:	89 fd                	mov    %edi,%ebp
  801d46:	85 ff                	test   %edi,%edi
  801d48:	75 0b                	jne    801d55 <__umoddi3+0xe9>
  801d4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d4f:	31 d2                	xor    %edx,%edx
  801d51:	f7 f7                	div    %edi
  801d53:	89 c5                	mov    %eax,%ebp
  801d55:	89 f0                	mov    %esi,%eax
  801d57:	31 d2                	xor    %edx,%edx
  801d59:	f7 f5                	div    %ebp
  801d5b:	89 c8                	mov    %ecx,%eax
  801d5d:	f7 f5                	div    %ebp
  801d5f:	89 d0                	mov    %edx,%eax
  801d61:	e9 44 ff ff ff       	jmp    801caa <__umoddi3+0x3e>
  801d66:	66 90                	xchg   %ax,%ax
  801d68:	89 c8                	mov    %ecx,%eax
  801d6a:	89 f2                	mov    %esi,%edx
  801d6c:	83 c4 1c             	add    $0x1c,%esp
  801d6f:	5b                   	pop    %ebx
  801d70:	5e                   	pop    %esi
  801d71:	5f                   	pop    %edi
  801d72:	5d                   	pop    %ebp
  801d73:	c3                   	ret    
  801d74:	3b 04 24             	cmp    (%esp),%eax
  801d77:	72 06                	jb     801d7f <__umoddi3+0x113>
  801d79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d7d:	77 0f                	ja     801d8e <__umoddi3+0x122>
  801d7f:	89 f2                	mov    %esi,%edx
  801d81:	29 f9                	sub    %edi,%ecx
  801d83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d87:	89 14 24             	mov    %edx,(%esp)
  801d8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d92:	8b 14 24             	mov    (%esp),%edx
  801d95:	83 c4 1c             	add    $0x1c,%esp
  801d98:	5b                   	pop    %ebx
  801d99:	5e                   	pop    %esi
  801d9a:	5f                   	pop    %edi
  801d9b:	5d                   	pop    %ebp
  801d9c:	c3                   	ret    
  801d9d:	8d 76 00             	lea    0x0(%esi),%esi
  801da0:	2b 04 24             	sub    (%esp),%eax
  801da3:	19 fa                	sbb    %edi,%edx
  801da5:	89 d1                	mov    %edx,%ecx
  801da7:	89 c6                	mov    %eax,%esi
  801da9:	e9 71 ff ff ff       	jmp    801d1f <__umoddi3+0xb3>
  801dae:	66 90                	xchg   %ax,%ax
  801db0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801db4:	72 ea                	jb     801da0 <__umoddi3+0x134>
  801db6:	89 d9                	mov    %ebx,%ecx
  801db8:	e9 62 ff ff ff       	jmp    801d1f <__umoddi3+0xb3>
