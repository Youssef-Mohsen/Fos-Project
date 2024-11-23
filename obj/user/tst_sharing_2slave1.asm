
obj/user/tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 7c 02 00 00       	call   8002b2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003f:	a1 20 50 80 00       	mov    0x805020,%eax
  800044:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  80004a:	a1 20 50 80 00       	mov    0x805020,%eax
  80004f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 40 3c 80 00       	push   $0x803c40
  800061:	6a 0d                	push   $0xd
  800063:	68 5c 3c 80 00       	push   $0x803c5c
  800068:	e8 84 03 00 00       	call   8003f1 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)

	uint32 *x,*y,*z, *expectedVA;
	int freeFrames, diff, expected;
	int32 parentenvID = sys_getparentenvid();
  800074:	e8 99 1b 00 00       	call   801c12 <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 fc 18 00 00       	call   80197d <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 aa 19 00 00       	call   801a30 <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 77 3c 80 00       	push   $0x803c77
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 61 17 00 00       	call   8017fa <sget>
  800099:	83 c4 10             	add    $0x10,%esp
  80009c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 0 * PAGE_SIZE);
  80009f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (z != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, z);
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000ab:	74 1a                	je     8000c7 <_main+0x8f>
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	68 7c 3c 80 00       	push   $0x803c7c
  8000bb:	6a 21                	push   $0x21
  8000bd:	68 5c 3c 80 00       	push   $0x803c5c
  8000c2:	e8 2a 03 00 00       	call   8003f1 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 5a 19 00 00       	call   801a30 <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 43 19 00 00       	call   801a30 <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 f8 3c 80 00       	push   $0x803cf8
  8000fd:	6a 24                	push   $0x24
  8000ff:	68 5c 3c 80 00       	push   $0x803c5c
  800104:	e8 e8 02 00 00       	call   8003f1 <_panic>

	}
	sys_unlock_cons();
  800109:	e8 89 18 00 00       	call   801997 <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 6a 18 00 00       	call   80197d <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 18 19 00 00       	call   801a30 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = sget(parentenvID,"y");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 90 3d 80 00       	push   $0x803d90
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 cf 16 00 00       	call   8017fa <sget>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  800131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800134:	05 00 10 00 00       	add    $0x1000,%eax
  800139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (y != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, y);
  80013c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800142:	74 1a                	je     80015e <_main+0x126>
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	ff 75 d8             	pushl  -0x28(%ebp)
  80014a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014d:	68 7c 3c 80 00       	push   $0x803c7c
  800152:	6a 30                	push   $0x30
  800154:	68 5c 3c 80 00       	push   $0x803c5c
  800159:	e8 93 02 00 00       	call   8003f1 <_panic>
		expected = 0 ;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 c3 18 00 00       	call   801a30 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 ac 18 00 00       	call   801a30 <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 f8 3c 80 00       	push   $0x803cf8
  800194:	6a 33                	push   $0x33
  800196:	68 5c 3c 80 00       	push   $0x803c5c
  80019b:	e8 51 02 00 00       	call   8003f1 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 f2 17 00 00       	call   801997 <sys_unlock_cons>
	//sys_unlock_cons();
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 14             	cmp    $0x14,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 94 3d 80 00       	push   $0x803d94
  8001b7:	6a 37                	push   $0x37
  8001b9:	68 5c 3c 80 00       	push   $0x803c5c
  8001be:	e8 2e 02 00 00       	call   8003f1 <_panic>
	//sys_lock_cons();
	sys_lock_cons();
  8001c3:	e8 b5 17 00 00       	call   80197d <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  8001c8:	e8 63 18 00 00       	call   801a30 <sys_calculate_free_frames>
  8001cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	68 cb 3d 80 00       	push   $0x803dcb
  8001d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8001db:	e8 1a 16 00 00       	call   8017fa <sget>
  8001e0:	83 c4 10             	add    $0x10,%esp
  8001e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 2 * PAGE_SIZE);
  8001e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001e9:	05 00 20 00 00       	add    $0x2000,%eax
  8001ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  8001f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001f4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001f7:	74 1a                	je     800213 <_main+0x1db>
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800202:	68 7c 3c 80 00       	push   $0x803c7c
  800207:	6a 3e                	push   $0x3e
  800209:	68 5c 3c 80 00       	push   $0x803c5c
  80020e:	e8 de 01 00 00       	call   8003f1 <_panic>
		expected = 0 ;
  800213:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80021a:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80021d:	e8 0e 18 00 00       	call   801a30 <sys_calculate_free_frames>
  800222:	29 c3                	sub    %eax,%ebx
  800224:	89 d8                	mov    %ebx,%eax
  800226:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800229:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022f:	74 24                	je     800255 <_main+0x21d>
  800231:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800234:	e8 f7 17 00 00       	call   801a30 <sys_calculate_free_frames>
  800239:	29 c3                	sub    %eax,%ebx
  80023b:	89 d8                	mov    %ebx,%eax
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	ff 75 e0             	pushl  -0x20(%ebp)
  800243:	50                   	push   %eax
  800244:	68 f8 3c 80 00       	push   $0x803cf8
  800249:	6a 41                	push   $0x41
  80024b:	68 5c 3c 80 00       	push   $0x803c5c
  800250:	e8 9c 01 00 00       	call   8003f1 <_panic>
	}
	sys_unlock_cons();
  800255:	e8 3d 17 00 00       	call   801997 <sys_unlock_cons>
	//sys_unlock_cons();
	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  80025a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80025d:	8b 00                	mov    (%eax),%eax
  80025f:	83 f8 0a             	cmp    $0xa,%eax
  800262:	74 14                	je     800278 <_main+0x240>
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	68 94 3d 80 00       	push   $0x803d94
  80026c:	6a 45                	push   $0x45
  80026e:	68 5c 3c 80 00       	push   $0x803c5c
  800273:	e8 79 01 00 00       	call   8003f1 <_panic>

	*z = *x + *y ;
  800278:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80027b:	8b 10                	mov    (%eax),%edx
  80027d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800280:	8b 00                	mov    (%eax),%eax
  800282:	01 c2                	add    %eax,%edx
  800284:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800287:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028c:	8b 00                	mov    (%eax),%eax
  80028e:	83 f8 1e             	cmp    $0x1e,%eax
  800291:	74 14                	je     8002a7 <_main+0x26f>
  800293:	83 ec 04             	sub    $0x4,%esp
  800296:	68 94 3d 80 00       	push   $0x803d94
  80029b:	6a 48                	push   $0x48
  80029d:	68 5c 3c 80 00       	push   $0x803c5c
  8002a2:	e8 4a 01 00 00       	call   8003f1 <_panic>

	//To indicate that it's completed successfully
	inctst();
  8002a7:	e8 8b 1a 00 00       	call   801d37 <inctst>

	return;
  8002ac:	90                   	nop
}
  8002ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

008002b2 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002b8:	e8 3c 19 00 00       	call   801bf9 <sys_getenvindex>
  8002bd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8002c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002c3:	89 d0                	mov    %edx,%eax
  8002c5:	c1 e0 03             	shl    $0x3,%eax
  8002c8:	01 d0                	add    %edx,%eax
  8002ca:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8002d1:	01 c8                	add    %ecx,%eax
  8002d3:	01 c0                	add    %eax,%eax
  8002d5:	01 d0                	add    %edx,%eax
  8002d7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8002de:	01 c8                	add    %ecx,%eax
  8002e0:	01 d0                	add    %edx,%eax
  8002e2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e7:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002ec:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f1:	8a 40 20             	mov    0x20(%eax),%al
  8002f4:	84 c0                	test   %al,%al
  8002f6:	74 0d                	je     800305 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8002f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002fd:	83 c0 20             	add    $0x20,%eax
  800300:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800305:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800309:	7e 0a                	jle    800315 <libmain+0x63>
		binaryname = argv[0];
  80030b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030e:	8b 00                	mov    (%eax),%eax
  800310:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800315:	83 ec 08             	sub    $0x8,%esp
  800318:	ff 75 0c             	pushl  0xc(%ebp)
  80031b:	ff 75 08             	pushl  0x8(%ebp)
  80031e:	e8 15 fd ff ff       	call   800038 <_main>
  800323:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800326:	e8 52 16 00 00       	call   80197d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80032b:	83 ec 0c             	sub    $0xc,%esp
  80032e:	68 e8 3d 80 00       	push   $0x803de8
  800333:	e8 76 03 00 00       	call   8006ae <cprintf>
  800338:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80033b:	a1 20 50 80 00       	mov    0x805020,%eax
  800340:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800346:	a1 20 50 80 00       	mov    0x805020,%eax
  80034b:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	52                   	push   %edx
  800355:	50                   	push   %eax
  800356:	68 10 3e 80 00       	push   $0x803e10
  80035b:	e8 4e 03 00 00       	call   8006ae <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800363:	a1 20 50 80 00       	mov    0x805020,%eax
  800368:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80036e:	a1 20 50 80 00       	mov    0x805020,%eax
  800373:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800379:	a1 20 50 80 00       	mov    0x805020,%eax
  80037e:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800384:	51                   	push   %ecx
  800385:	52                   	push   %edx
  800386:	50                   	push   %eax
  800387:	68 38 3e 80 00       	push   $0x803e38
  80038c:	e8 1d 03 00 00       	call   8006ae <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800394:	a1 20 50 80 00       	mov    0x805020,%eax
  800399:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80039f:	83 ec 08             	sub    $0x8,%esp
  8003a2:	50                   	push   %eax
  8003a3:	68 90 3e 80 00       	push   $0x803e90
  8003a8:	e8 01 03 00 00       	call   8006ae <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003b0:	83 ec 0c             	sub    $0xc,%esp
  8003b3:	68 e8 3d 80 00       	push   $0x803de8
  8003b8:	e8 f1 02 00 00       	call   8006ae <cprintf>
  8003bd:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003c0:	e8 d2 15 00 00       	call   801997 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8003c5:	e8 19 00 00 00       	call   8003e3 <exit>
}
  8003ca:	90                   	nop
  8003cb:	c9                   	leave  
  8003cc:	c3                   	ret    

008003cd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003cd:	55                   	push   %ebp
  8003ce:	89 e5                	mov    %esp,%ebp
  8003d0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003d3:	83 ec 0c             	sub    $0xc,%esp
  8003d6:	6a 00                	push   $0x0
  8003d8:	e8 e8 17 00 00       	call   801bc5 <sys_destroy_env>
  8003dd:	83 c4 10             	add    $0x10,%esp
}
  8003e0:	90                   	nop
  8003e1:	c9                   	leave  
  8003e2:	c3                   	ret    

008003e3 <exit>:

void
exit(void)
{
  8003e3:	55                   	push   %ebp
  8003e4:	89 e5                	mov    %esp,%ebp
  8003e6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003e9:	e8 3d 18 00 00       	call   801c2b <sys_exit_env>
}
  8003ee:	90                   	nop
  8003ef:	c9                   	leave  
  8003f0:	c3                   	ret    

008003f1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003f1:	55                   	push   %ebp
  8003f2:	89 e5                	mov    %esp,%ebp
  8003f4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003f7:	8d 45 10             	lea    0x10(%ebp),%eax
  8003fa:	83 c0 04             	add    $0x4,%eax
  8003fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800400:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800405:	85 c0                	test   %eax,%eax
  800407:	74 16                	je     80041f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800409:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80040e:	83 ec 08             	sub    $0x8,%esp
  800411:	50                   	push   %eax
  800412:	68 a4 3e 80 00       	push   $0x803ea4
  800417:	e8 92 02 00 00       	call   8006ae <cprintf>
  80041c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80041f:	a1 00 50 80 00       	mov    0x805000,%eax
  800424:	ff 75 0c             	pushl  0xc(%ebp)
  800427:	ff 75 08             	pushl  0x8(%ebp)
  80042a:	50                   	push   %eax
  80042b:	68 a9 3e 80 00       	push   $0x803ea9
  800430:	e8 79 02 00 00       	call   8006ae <cprintf>
  800435:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800438:	8b 45 10             	mov    0x10(%ebp),%eax
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	ff 75 f4             	pushl  -0xc(%ebp)
  800441:	50                   	push   %eax
  800442:	e8 fc 01 00 00       	call   800643 <vcprintf>
  800447:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80044a:	83 ec 08             	sub    $0x8,%esp
  80044d:	6a 00                	push   $0x0
  80044f:	68 c5 3e 80 00       	push   $0x803ec5
  800454:	e8 ea 01 00 00       	call   800643 <vcprintf>
  800459:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80045c:	e8 82 ff ff ff       	call   8003e3 <exit>

	// should not return here
	while (1) ;
  800461:	eb fe                	jmp    800461 <_panic+0x70>

00800463 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
  800466:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800469:	a1 20 50 80 00       	mov    0x805020,%eax
  80046e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800474:	8b 45 0c             	mov    0xc(%ebp),%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 c8 3e 80 00       	push   $0x803ec8
  800483:	6a 26                	push   $0x26
  800485:	68 14 3f 80 00       	push   $0x803f14
  80048a:	e8 62 ff ff ff       	call   8003f1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80048f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800496:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80049d:	e9 c5 00 00 00       	jmp    800567 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	01 d0                	add    %edx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	85 c0                	test   %eax,%eax
  8004b5:	75 08                	jne    8004bf <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004b7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004ba:	e9 a5 00 00 00       	jmp    800564 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004cd:	eb 69                	jmp    800538 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d4:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8004da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004dd:	89 d0                	mov    %edx,%eax
  8004df:	01 c0                	add    %eax,%eax
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	c1 e0 03             	shl    $0x3,%eax
  8004e6:	01 c8                	add    %ecx,%eax
  8004e8:	8a 40 04             	mov    0x4(%eax),%al
  8004eb:	84 c0                	test   %al,%al
  8004ed:	75 46                	jne    800535 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f4:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8004fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004fd:	89 d0                	mov    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	c1 e0 03             	shl    $0x3,%eax
  800506:	01 c8                	add    %ecx,%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80050d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800510:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800515:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	01 c8                	add    %ecx,%eax
  800526:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800528:	39 c2                	cmp    %eax,%edx
  80052a:	75 09                	jne    800535 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80052c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800533:	eb 15                	jmp    80054a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800535:	ff 45 e8             	incl   -0x18(%ebp)
  800538:	a1 20 50 80 00       	mov    0x805020,%eax
  80053d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800543:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800546:	39 c2                	cmp    %eax,%edx
  800548:	77 85                	ja     8004cf <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80054a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80054e:	75 14                	jne    800564 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800550:	83 ec 04             	sub    $0x4,%esp
  800553:	68 20 3f 80 00       	push   $0x803f20
  800558:	6a 3a                	push   $0x3a
  80055a:	68 14 3f 80 00       	push   $0x803f14
  80055f:	e8 8d fe ff ff       	call   8003f1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800564:	ff 45 f0             	incl   -0x10(%ebp)
  800567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80056d:	0f 8c 2f ff ff ff    	jl     8004a2 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800573:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80057a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800581:	eb 26                	jmp    8005a9 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800583:	a1 20 50 80 00       	mov    0x805020,%eax
  800588:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80058e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800591:	89 d0                	mov    %edx,%eax
  800593:	01 c0                	add    %eax,%eax
  800595:	01 d0                	add    %edx,%eax
  800597:	c1 e0 03             	shl    $0x3,%eax
  80059a:	01 c8                	add    %ecx,%eax
  80059c:	8a 40 04             	mov    0x4(%eax),%al
  80059f:	3c 01                	cmp    $0x1,%al
  8005a1:	75 03                	jne    8005a6 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005a3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a6:	ff 45 e0             	incl   -0x20(%ebp)
  8005a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ae:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b7:	39 c2                	cmp    %eax,%edx
  8005b9:	77 c8                	ja     800583 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005be:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005c1:	74 14                	je     8005d7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	68 74 3f 80 00       	push   $0x803f74
  8005cb:	6a 44                	push   $0x44
  8005cd:	68 14 3f 80 00       	push   $0x803f14
  8005d2:	e8 1a fe ff ff       	call   8003f1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d7:	90                   	nop
  8005d8:	c9                   	leave  
  8005d9:	c3                   	ret    

008005da <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e3:	8b 00                	mov    (%eax),%eax
  8005e5:	8d 48 01             	lea    0x1(%eax),%ecx
  8005e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005eb:	89 0a                	mov    %ecx,(%edx)
  8005ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8005f0:	88 d1                	mov    %dl,%cl
  8005f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	3d ff 00 00 00       	cmp    $0xff,%eax
  800603:	75 2c                	jne    800631 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800605:	a0 28 50 80 00       	mov    0x805028,%al
  80060a:	0f b6 c0             	movzbl %al,%eax
  80060d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800610:	8b 12                	mov    (%edx),%edx
  800612:	89 d1                	mov    %edx,%ecx
  800614:	8b 55 0c             	mov    0xc(%ebp),%edx
  800617:	83 c2 08             	add    $0x8,%edx
  80061a:	83 ec 04             	sub    $0x4,%esp
  80061d:	50                   	push   %eax
  80061e:	51                   	push   %ecx
  80061f:	52                   	push   %edx
  800620:	e8 16 13 00 00       	call   80193b <sys_cputs>
  800625:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800631:	8b 45 0c             	mov    0xc(%ebp),%eax
  800634:	8b 40 04             	mov    0x4(%eax),%eax
  800637:	8d 50 01             	lea    0x1(%eax),%edx
  80063a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800640:	90                   	nop
  800641:	c9                   	leave  
  800642:	c3                   	ret    

00800643 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800643:	55                   	push   %ebp
  800644:	89 e5                	mov    %esp,%ebp
  800646:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80064c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800653:	00 00 00 
	b.cnt = 0;
  800656:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80065d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800660:	ff 75 0c             	pushl  0xc(%ebp)
  800663:	ff 75 08             	pushl  0x8(%ebp)
  800666:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80066c:	50                   	push   %eax
  80066d:	68 da 05 80 00       	push   $0x8005da
  800672:	e8 11 02 00 00       	call   800888 <vprintfmt>
  800677:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80067a:	a0 28 50 80 00       	mov    0x805028,%al
  80067f:	0f b6 c0             	movzbl %al,%eax
  800682:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	50                   	push   %eax
  80068c:	52                   	push   %edx
  80068d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800693:	83 c0 08             	add    $0x8,%eax
  800696:	50                   	push   %eax
  800697:	e8 9f 12 00 00       	call   80193b <sys_cputs>
  80069c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80069f:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  8006a6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    

008006ae <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
  8006b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006b4:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  8006bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ca:	50                   	push   %eax
  8006cb:	e8 73 ff ff ff       	call   800643 <vcprintf>
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d9:	c9                   	leave  
  8006da:	c3                   	ret    

008006db <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006db:	55                   	push   %ebp
  8006dc:	89 e5                	mov    %esp,%ebp
  8006de:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006e1:	e8 97 12 00 00       	call   80197d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006e6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f5:	50                   	push   %eax
  8006f6:	e8 48 ff ff ff       	call   800643 <vcprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800701:	e8 91 12 00 00       	call   801997 <sys_unlock_cons>
	return cnt;
  800706:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800709:	c9                   	leave  
  80070a:	c3                   	ret    

0080070b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80070b:	55                   	push   %ebp
  80070c:	89 e5                	mov    %esp,%ebp
  80070e:	53                   	push   %ebx
  80070f:	83 ec 14             	sub    $0x14,%esp
  800712:	8b 45 10             	mov    0x10(%ebp),%eax
  800715:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80071e:	8b 45 18             	mov    0x18(%ebp),%eax
  800721:	ba 00 00 00 00       	mov    $0x0,%edx
  800726:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800729:	77 55                	ja     800780 <printnum+0x75>
  80072b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80072e:	72 05                	jb     800735 <printnum+0x2a>
  800730:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800733:	77 4b                	ja     800780 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800735:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800738:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80073b:	8b 45 18             	mov    0x18(%ebp),%eax
  80073e:	ba 00 00 00 00       	mov    $0x0,%edx
  800743:	52                   	push   %edx
  800744:	50                   	push   %eax
  800745:	ff 75 f4             	pushl  -0xc(%ebp)
  800748:	ff 75 f0             	pushl  -0x10(%ebp)
  80074b:	e8 84 32 00 00       	call   8039d4 <__udivdi3>
  800750:	83 c4 10             	add    $0x10,%esp
  800753:	83 ec 04             	sub    $0x4,%esp
  800756:	ff 75 20             	pushl  0x20(%ebp)
  800759:	53                   	push   %ebx
  80075a:	ff 75 18             	pushl  0x18(%ebp)
  80075d:	52                   	push   %edx
  80075e:	50                   	push   %eax
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	ff 75 08             	pushl  0x8(%ebp)
  800765:	e8 a1 ff ff ff       	call   80070b <printnum>
  80076a:	83 c4 20             	add    $0x20,%esp
  80076d:	eb 1a                	jmp    800789 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80076f:	83 ec 08             	sub    $0x8,%esp
  800772:	ff 75 0c             	pushl  0xc(%ebp)
  800775:	ff 75 20             	pushl  0x20(%ebp)
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	ff d0                	call   *%eax
  80077d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800780:	ff 4d 1c             	decl   0x1c(%ebp)
  800783:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800787:	7f e6                	jg     80076f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800789:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80078c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800791:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800794:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800797:	53                   	push   %ebx
  800798:	51                   	push   %ecx
  800799:	52                   	push   %edx
  80079a:	50                   	push   %eax
  80079b:	e8 44 33 00 00       	call   803ae4 <__umoddi3>
  8007a0:	83 c4 10             	add    $0x10,%esp
  8007a3:	05 d4 41 80 00       	add    $0x8041d4,%eax
  8007a8:	8a 00                	mov    (%eax),%al
  8007aa:	0f be c0             	movsbl %al,%eax
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	50                   	push   %eax
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	ff d0                	call   *%eax
  8007b9:	83 c4 10             	add    $0x10,%esp
}
  8007bc:	90                   	nop
  8007bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c0:	c9                   	leave  
  8007c1:	c3                   	ret    

008007c2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c9:	7e 1c                	jle    8007e7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	8d 50 08             	lea    0x8(%eax),%edx
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	89 10                	mov    %edx,(%eax)
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	83 e8 08             	sub    $0x8,%eax
  8007e0:	8b 50 04             	mov    0x4(%eax),%edx
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	eb 40                	jmp    800827 <getuint+0x65>
	else if (lflag)
  8007e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007eb:	74 1e                	je     80080b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	8d 50 04             	lea    0x4(%eax),%edx
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	89 10                	mov    %edx,(%eax)
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	8b 00                	mov    (%eax),%eax
  8007ff:	83 e8 04             	sub    $0x4,%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	ba 00 00 00 00       	mov    $0x0,%edx
  800809:	eb 1c                	jmp    800827 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	8b 00                	mov    (%eax),%eax
  800810:	8d 50 04             	lea    0x4(%eax),%edx
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	89 10                	mov    %edx,(%eax)
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	83 e8 04             	sub    $0x4,%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800827:	5d                   	pop    %ebp
  800828:	c3                   	ret    

00800829 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800829:	55                   	push   %ebp
  80082a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80082c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800830:	7e 1c                	jle    80084e <getint+0x25>
		return va_arg(*ap, long long);
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	8b 00                	mov    (%eax),%eax
  800837:	8d 50 08             	lea    0x8(%eax),%edx
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	89 10                	mov    %edx,(%eax)
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	8b 00                	mov    (%eax),%eax
  800844:	83 e8 08             	sub    $0x8,%eax
  800847:	8b 50 04             	mov    0x4(%eax),%edx
  80084a:	8b 00                	mov    (%eax),%eax
  80084c:	eb 38                	jmp    800886 <getint+0x5d>
	else if (lflag)
  80084e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800852:	74 1a                	je     80086e <getint+0x45>
		return va_arg(*ap, long);
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	8b 00                	mov    (%eax),%eax
  800859:	8d 50 04             	lea    0x4(%eax),%edx
  80085c:	8b 45 08             	mov    0x8(%ebp),%eax
  80085f:	89 10                	mov    %edx,(%eax)
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	8b 00                	mov    (%eax),%eax
  800866:	83 e8 04             	sub    $0x4,%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	99                   	cltd   
  80086c:	eb 18                	jmp    800886 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	8b 00                	mov    (%eax),%eax
  800873:	8d 50 04             	lea    0x4(%eax),%edx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	89 10                	mov    %edx,(%eax)
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 00                	mov    (%eax),%eax
  800880:	83 e8 04             	sub    $0x4,%eax
  800883:	8b 00                	mov    (%eax),%eax
  800885:	99                   	cltd   
}
  800886:	5d                   	pop    %ebp
  800887:	c3                   	ret    

00800888 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	56                   	push   %esi
  80088c:	53                   	push   %ebx
  80088d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800890:	eb 17                	jmp    8008a9 <vprintfmt+0x21>
			if (ch == '\0')
  800892:	85 db                	test   %ebx,%ebx
  800894:	0f 84 c1 03 00 00    	je     800c5b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	ff 75 0c             	pushl  0xc(%ebp)
  8008a0:	53                   	push   %ebx
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	ff d0                	call   *%eax
  8008a6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ac:	8d 50 01             	lea    0x1(%eax),%edx
  8008af:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b2:	8a 00                	mov    (%eax),%al
  8008b4:	0f b6 d8             	movzbl %al,%ebx
  8008b7:	83 fb 25             	cmp    $0x25,%ebx
  8008ba:	75 d6                	jne    800892 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008bc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008c0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008ce:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008d5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008df:	8d 50 01             	lea    0x1(%eax),%edx
  8008e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8008e5:	8a 00                	mov    (%eax),%al
  8008e7:	0f b6 d8             	movzbl %al,%ebx
  8008ea:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008ed:	83 f8 5b             	cmp    $0x5b,%eax
  8008f0:	0f 87 3d 03 00 00    	ja     800c33 <vprintfmt+0x3ab>
  8008f6:	8b 04 85 f8 41 80 00 	mov    0x8041f8(,%eax,4),%eax
  8008fd:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008ff:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800903:	eb d7                	jmp    8008dc <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800905:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800909:	eb d1                	jmp    8008dc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800912:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800915:	89 d0                	mov    %edx,%eax
  800917:	c1 e0 02             	shl    $0x2,%eax
  80091a:	01 d0                	add    %edx,%eax
  80091c:	01 c0                	add    %eax,%eax
  80091e:	01 d8                	add    %ebx,%eax
  800920:	83 e8 30             	sub    $0x30,%eax
  800923:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800926:	8b 45 10             	mov    0x10(%ebp),%eax
  800929:	8a 00                	mov    (%eax),%al
  80092b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80092e:	83 fb 2f             	cmp    $0x2f,%ebx
  800931:	7e 3e                	jle    800971 <vprintfmt+0xe9>
  800933:	83 fb 39             	cmp    $0x39,%ebx
  800936:	7f 39                	jg     800971 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800938:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80093b:	eb d5                	jmp    800912 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	83 c0 04             	add    $0x4,%eax
  800943:	89 45 14             	mov    %eax,0x14(%ebp)
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	83 e8 04             	sub    $0x4,%eax
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800951:	eb 1f                	jmp    800972 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800953:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800957:	79 83                	jns    8008dc <vprintfmt+0x54>
				width = 0;
  800959:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800960:	e9 77 ff ff ff       	jmp    8008dc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800965:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80096c:	e9 6b ff ff ff       	jmp    8008dc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800971:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800972:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800976:	0f 89 60 ff ff ff    	jns    8008dc <vprintfmt+0x54>
				width = precision, precision = -1;
  80097c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80097f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800982:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800989:	e9 4e ff ff ff       	jmp    8008dc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80098e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800991:	e9 46 ff ff ff       	jmp    8008dc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800996:	8b 45 14             	mov    0x14(%ebp),%eax
  800999:	83 c0 04             	add    $0x4,%eax
  80099c:	89 45 14             	mov    %eax,0x14(%ebp)
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	83 e8 04             	sub    $0x4,%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	83 ec 08             	sub    $0x8,%esp
  8009aa:	ff 75 0c             	pushl  0xc(%ebp)
  8009ad:	50                   	push   %eax
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	ff d0                	call   *%eax
  8009b3:	83 c4 10             	add    $0x10,%esp
			break;
  8009b6:	e9 9b 02 00 00       	jmp    800c56 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	83 c0 04             	add    $0x4,%eax
  8009c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	83 e8 04             	sub    $0x4,%eax
  8009ca:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009cc:	85 db                	test   %ebx,%ebx
  8009ce:	79 02                	jns    8009d2 <vprintfmt+0x14a>
				err = -err;
  8009d0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009d2:	83 fb 64             	cmp    $0x64,%ebx
  8009d5:	7f 0b                	jg     8009e2 <vprintfmt+0x15a>
  8009d7:	8b 34 9d 40 40 80 00 	mov    0x804040(,%ebx,4),%esi
  8009de:	85 f6                	test   %esi,%esi
  8009e0:	75 19                	jne    8009fb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e2:	53                   	push   %ebx
  8009e3:	68 e5 41 80 00       	push   $0x8041e5
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	ff 75 08             	pushl  0x8(%ebp)
  8009ee:	e8 70 02 00 00       	call   800c63 <printfmt>
  8009f3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f6:	e9 5b 02 00 00       	jmp    800c56 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009fb:	56                   	push   %esi
  8009fc:	68 ee 41 80 00       	push   $0x8041ee
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	ff 75 08             	pushl  0x8(%ebp)
  800a07:	e8 57 02 00 00       	call   800c63 <printfmt>
  800a0c:	83 c4 10             	add    $0x10,%esp
			break;
  800a0f:	e9 42 02 00 00       	jmp    800c56 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a14:	8b 45 14             	mov    0x14(%ebp),%eax
  800a17:	83 c0 04             	add    $0x4,%eax
  800a1a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a20:	83 e8 04             	sub    $0x4,%eax
  800a23:	8b 30                	mov    (%eax),%esi
  800a25:	85 f6                	test   %esi,%esi
  800a27:	75 05                	jne    800a2e <vprintfmt+0x1a6>
				p = "(null)";
  800a29:	be f1 41 80 00       	mov    $0x8041f1,%esi
			if (width > 0 && padc != '-')
  800a2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a32:	7e 6d                	jle    800aa1 <vprintfmt+0x219>
  800a34:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a38:	74 67                	je     800aa1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a3d:	83 ec 08             	sub    $0x8,%esp
  800a40:	50                   	push   %eax
  800a41:	56                   	push   %esi
  800a42:	e8 1e 03 00 00       	call   800d65 <strnlen>
  800a47:	83 c4 10             	add    $0x10,%esp
  800a4a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a4d:	eb 16                	jmp    800a65 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a4f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	50                   	push   %eax
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a62:	ff 4d e4             	decl   -0x1c(%ebp)
  800a65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a69:	7f e4                	jg     800a4f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a6b:	eb 34                	jmp    800aa1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a6d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a71:	74 1c                	je     800a8f <vprintfmt+0x207>
  800a73:	83 fb 1f             	cmp    $0x1f,%ebx
  800a76:	7e 05                	jle    800a7d <vprintfmt+0x1f5>
  800a78:	83 fb 7e             	cmp    $0x7e,%ebx
  800a7b:	7e 12                	jle    800a8f <vprintfmt+0x207>
					putch('?', putdat);
  800a7d:	83 ec 08             	sub    $0x8,%esp
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	6a 3f                	push   $0x3f
  800a85:	8b 45 08             	mov    0x8(%ebp),%eax
  800a88:	ff d0                	call   *%eax
  800a8a:	83 c4 10             	add    $0x10,%esp
  800a8d:	eb 0f                	jmp    800a9e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	53                   	push   %ebx
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a9e:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa1:	89 f0                	mov    %esi,%eax
  800aa3:	8d 70 01             	lea    0x1(%eax),%esi
  800aa6:	8a 00                	mov    (%eax),%al
  800aa8:	0f be d8             	movsbl %al,%ebx
  800aab:	85 db                	test   %ebx,%ebx
  800aad:	74 24                	je     800ad3 <vprintfmt+0x24b>
  800aaf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab3:	78 b8                	js     800a6d <vprintfmt+0x1e5>
  800ab5:	ff 4d e0             	decl   -0x20(%ebp)
  800ab8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800abc:	79 af                	jns    800a6d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800abe:	eb 13                	jmp    800ad3 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	6a 20                	push   $0x20
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	ff d0                	call   *%eax
  800acd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad0:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad7:	7f e7                	jg     800ac0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ad9:	e9 78 01 00 00       	jmp    800c56 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ade:	83 ec 08             	sub    $0x8,%esp
  800ae1:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae7:	50                   	push   %eax
  800ae8:	e8 3c fd ff ff       	call   800829 <getint>
  800aed:	83 c4 10             	add    $0x10,%esp
  800af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afc:	85 d2                	test   %edx,%edx
  800afe:	79 23                	jns    800b23 <vprintfmt+0x29b>
				putch('-', putdat);
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	6a 2d                	push   $0x2d
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	ff d0                	call   *%eax
  800b0d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b16:	f7 d8                	neg    %eax
  800b18:	83 d2 00             	adc    $0x0,%edx
  800b1b:	f7 da                	neg    %edx
  800b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b20:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b23:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b2a:	e9 bc 00 00 00       	jmp    800beb <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 e8             	pushl  -0x18(%ebp)
  800b35:	8d 45 14             	lea    0x14(%ebp),%eax
  800b38:	50                   	push   %eax
  800b39:	e8 84 fc ff ff       	call   8007c2 <getuint>
  800b3e:	83 c4 10             	add    $0x10,%esp
  800b41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b44:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b47:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b4e:	e9 98 00 00 00       	jmp    800beb <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	6a 58                	push   $0x58
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	ff d0                	call   *%eax
  800b60:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b63:	83 ec 08             	sub    $0x8,%esp
  800b66:	ff 75 0c             	pushl  0xc(%ebp)
  800b69:	6a 58                	push   $0x58
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	ff d0                	call   *%eax
  800b70:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b73:	83 ec 08             	sub    $0x8,%esp
  800b76:	ff 75 0c             	pushl  0xc(%ebp)
  800b79:	6a 58                	push   $0x58
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	ff d0                	call   *%eax
  800b80:	83 c4 10             	add    $0x10,%esp
			break;
  800b83:	e9 ce 00 00 00       	jmp    800c56 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b88:	83 ec 08             	sub    $0x8,%esp
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	6a 30                	push   $0x30
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	ff d0                	call   *%eax
  800b95:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	ff 75 0c             	pushl  0xc(%ebp)
  800b9e:	6a 78                	push   $0x78
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	ff d0                	call   *%eax
  800ba5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ba8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bab:	83 c0 04             	add    $0x4,%eax
  800bae:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb4:	83 e8 04             	sub    $0x4,%eax
  800bb7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bc3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bca:	eb 1f                	jmp    800beb <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd2:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd5:	50                   	push   %eax
  800bd6:	e8 e7 fb ff ff       	call   8007c2 <getuint>
  800bdb:	83 c4 10             	add    $0x10,%esp
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800be4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800beb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bf2:	83 ec 04             	sub    $0x4,%esp
  800bf5:	52                   	push   %edx
  800bf6:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf9:	50                   	push   %eax
  800bfa:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfd:	ff 75 f0             	pushl  -0x10(%ebp)
  800c00:	ff 75 0c             	pushl  0xc(%ebp)
  800c03:	ff 75 08             	pushl  0x8(%ebp)
  800c06:	e8 00 fb ff ff       	call   80070b <printnum>
  800c0b:	83 c4 20             	add    $0x20,%esp
			break;
  800c0e:	eb 46                	jmp    800c56 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	53                   	push   %ebx
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	ff d0                	call   *%eax
  800c1c:	83 c4 10             	add    $0x10,%esp
			break;
  800c1f:	eb 35                	jmp    800c56 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c21:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800c28:	eb 2c                	jmp    800c56 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c2a:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800c31:	eb 23                	jmp    800c56 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c33:	83 ec 08             	sub    $0x8,%esp
  800c36:	ff 75 0c             	pushl  0xc(%ebp)
  800c39:	6a 25                	push   $0x25
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	ff d0                	call   *%eax
  800c40:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c43:	ff 4d 10             	decl   0x10(%ebp)
  800c46:	eb 03                	jmp    800c4b <vprintfmt+0x3c3>
  800c48:	ff 4d 10             	decl   0x10(%ebp)
  800c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4e:	48                   	dec    %eax
  800c4f:	8a 00                	mov    (%eax),%al
  800c51:	3c 25                	cmp    $0x25,%al
  800c53:	75 f3                	jne    800c48 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c55:	90                   	nop
		}
	}
  800c56:	e9 35 fc ff ff       	jmp    800890 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c5b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c5f:	5b                   	pop    %ebx
  800c60:	5e                   	pop    %esi
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c69:	8d 45 10             	lea    0x10(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c72:	8b 45 10             	mov    0x10(%ebp),%eax
  800c75:	ff 75 f4             	pushl  -0xc(%ebp)
  800c78:	50                   	push   %eax
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	ff 75 08             	pushl  0x8(%ebp)
  800c7f:	e8 04 fc ff ff       	call   800888 <vprintfmt>
  800c84:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c87:	90                   	nop
  800c88:	c9                   	leave  
  800c89:	c3                   	ret    

00800c8a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c90:	8b 40 08             	mov    0x8(%eax),%eax
  800c93:	8d 50 01             	lea    0x1(%eax),%edx
  800c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c99:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9f:	8b 10                	mov    (%eax),%edx
  800ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca4:	8b 40 04             	mov    0x4(%eax),%eax
  800ca7:	39 c2                	cmp    %eax,%edx
  800ca9:	73 12                	jae    800cbd <sprintputch+0x33>
		*b->buf++ = ch;
  800cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cae:	8b 00                	mov    (%eax),%eax
  800cb0:	8d 48 01             	lea    0x1(%eax),%ecx
  800cb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb6:	89 0a                	mov    %ecx,(%edx)
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	88 10                	mov    %dl,(%eax)
}
  800cbd:	90                   	nop
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    

00800cc0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	01 d0                	add    %edx,%eax
  800cd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ce1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ce5:	74 06                	je     800ced <vsnprintf+0x2d>
  800ce7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ceb:	7f 07                	jg     800cf4 <vsnprintf+0x34>
		return -E_INVAL;
  800ced:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf2:	eb 20                	jmp    800d14 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cf4:	ff 75 14             	pushl  0x14(%ebp)
  800cf7:	ff 75 10             	pushl  0x10(%ebp)
  800cfa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cfd:	50                   	push   %eax
  800cfe:	68 8a 0c 80 00       	push   $0x800c8a
  800d03:	e8 80 fb ff ff       	call   800888 <vprintfmt>
  800d08:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d0e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d14:	c9                   	leave  
  800d15:	c3                   	ret    

00800d16 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d1c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d1f:	83 c0 04             	add    $0x4,%eax
  800d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d25:	8b 45 10             	mov    0x10(%ebp),%eax
  800d28:	ff 75 f4             	pushl  -0xc(%ebp)
  800d2b:	50                   	push   %eax
  800d2c:	ff 75 0c             	pushl  0xc(%ebp)
  800d2f:	ff 75 08             	pushl  0x8(%ebp)
  800d32:	e8 89 ff ff ff       	call   800cc0 <vsnprintf>
  800d37:	83 c4 10             	add    $0x10,%esp
  800d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d40:	c9                   	leave  
  800d41:	c3                   	ret    

00800d42 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d4f:	eb 06                	jmp    800d57 <strlen+0x15>
		n++;
  800d51:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d54:	ff 45 08             	incl   0x8(%ebp)
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	84 c0                	test   %al,%al
  800d5e:	75 f1                	jne    800d51 <strlen+0xf>
		n++;
	return n;
  800d60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d63:	c9                   	leave  
  800d64:	c3                   	ret    

00800d65 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d72:	eb 09                	jmp    800d7d <strnlen+0x18>
		n++;
  800d74:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d77:	ff 45 08             	incl   0x8(%ebp)
  800d7a:	ff 4d 0c             	decl   0xc(%ebp)
  800d7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d81:	74 09                	je     800d8c <strnlen+0x27>
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	84 c0                	test   %al,%al
  800d8a:	75 e8                	jne    800d74 <strnlen+0xf>
		n++;
	return n;
  800d8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d9d:	90                   	nop
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8d 50 01             	lea    0x1(%eax),%edx
  800da4:	89 55 08             	mov    %edx,0x8(%ebp)
  800da7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800daa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db0:	8a 12                	mov    (%edx),%dl
  800db2:	88 10                	mov    %dl,(%eax)
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	84 c0                	test   %al,%al
  800db8:	75 e4                	jne    800d9e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dcb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd2:	eb 1f                	jmp    800df3 <strncpy+0x34>
		*dst++ = *src;
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8d 50 01             	lea    0x1(%eax),%edx
  800dda:	89 55 08             	mov    %edx,0x8(%ebp)
  800ddd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de0:	8a 12                	mov    (%edx),%dl
  800de2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	74 03                	je     800df0 <strncpy+0x31>
			src++;
  800ded:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800df0:	ff 45 fc             	incl   -0x4(%ebp)
  800df3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800df9:	72 d9                	jb     800dd4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e10:	74 30                	je     800e42 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e12:	eb 16                	jmp    800e2a <strlcpy+0x2a>
			*dst++ = *src++;
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8d 50 01             	lea    0x1(%eax),%edx
  800e1a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e23:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e26:	8a 12                	mov    (%edx),%dl
  800e28:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e2a:	ff 4d 10             	decl   0x10(%ebp)
  800e2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e31:	74 09                	je     800e3c <strlcpy+0x3c>
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	84 c0                	test   %al,%al
  800e3a:	75 d8                	jne    800e14 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e42:	8b 55 08             	mov    0x8(%ebp),%edx
  800e45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e48:	29 c2                	sub    %eax,%edx
  800e4a:	89 d0                	mov    %edx,%eax
}
  800e4c:	c9                   	leave  
  800e4d:	c3                   	ret    

00800e4e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e51:	eb 06                	jmp    800e59 <strcmp+0xb>
		p++, q++;
  800e53:	ff 45 08             	incl   0x8(%ebp)
  800e56:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	84 c0                	test   %al,%al
  800e60:	74 0e                	je     800e70 <strcmp+0x22>
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	8a 10                	mov    (%eax),%dl
  800e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	38 c2                	cmp    %al,%dl
  800e6e:	74 e3                	je     800e53 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	0f b6 d0             	movzbl %al,%edx
  800e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	0f b6 c0             	movzbl %al,%eax
  800e80:	29 c2                	sub    %eax,%edx
  800e82:	89 d0                	mov    %edx,%eax
}
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    

00800e86 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e89:	eb 09                	jmp    800e94 <strncmp+0xe>
		n--, p++, q++;
  800e8b:	ff 4d 10             	decl   0x10(%ebp)
  800e8e:	ff 45 08             	incl   0x8(%ebp)
  800e91:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e98:	74 17                	je     800eb1 <strncmp+0x2b>
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8a 00                	mov    (%eax),%al
  800e9f:	84 c0                	test   %al,%al
  800ea1:	74 0e                	je     800eb1 <strncmp+0x2b>
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 10                	mov    (%eax),%dl
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	8a 00                	mov    (%eax),%al
  800ead:	38 c2                	cmp    %al,%dl
  800eaf:	74 da                	je     800e8b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800eb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb5:	75 07                	jne    800ebe <strncmp+0x38>
		return 0;
  800eb7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ebc:	eb 14                	jmp    800ed2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	0f b6 d0             	movzbl %al,%edx
  800ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	0f b6 c0             	movzbl %al,%eax
  800ece:	29 c2                	sub    %eax,%edx
  800ed0:	89 d0                	mov    %edx,%eax
}
  800ed2:	5d                   	pop    %ebp
  800ed3:	c3                   	ret    

00800ed4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	83 ec 04             	sub    $0x4,%esp
  800eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ee0:	eb 12                	jmp    800ef4 <strchr+0x20>
		if (*s == c)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eea:	75 05                	jne    800ef1 <strchr+0x1d>
			return (char *) s;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	eb 11                	jmp    800f02 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ef1:	ff 45 08             	incl   0x8(%ebp)
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	84 c0                	test   %al,%al
  800efb:	75 e5                	jne    800ee2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800efd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f02:	c9                   	leave  
  800f03:	c3                   	ret    

00800f04 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	83 ec 04             	sub    $0x4,%esp
  800f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f10:	eb 0d                	jmp    800f1f <strfind+0x1b>
		if (*s == c)
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f1a:	74 0e                	je     800f2a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f1c:	ff 45 08             	incl   0x8(%ebp)
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	84 c0                	test   %al,%al
  800f26:	75 ea                	jne    800f12 <strfind+0xe>
  800f28:	eb 01                	jmp    800f2b <strfind+0x27>
		if (*s == c)
			break;
  800f2a:	90                   	nop
	return (char *) s;
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2e:	c9                   	leave  
  800f2f:	c3                   	ret    

00800f30 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f42:	eb 0e                	jmp    800f52 <memset+0x22>
		*p++ = c;
  800f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f47:	8d 50 01             	lea    0x1(%eax),%edx
  800f4a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f50:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f52:	ff 4d f8             	decl   -0x8(%ebp)
  800f55:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f59:	79 e9                	jns    800f44 <memset+0x14>
		*p++ = c;

	return v;
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5e:	c9                   	leave  
  800f5f:	c3                   	ret    

00800f60 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f72:	eb 16                	jmp    800f8a <memcpy+0x2a>
		*d++ = *s++;
  800f74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f77:	8d 50 01             	lea    0x1(%eax),%edx
  800f7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f86:	8a 12                	mov    (%edx),%dl
  800f88:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f90:	89 55 10             	mov    %edx,0x10(%ebp)
  800f93:	85 c0                	test   %eax,%eax
  800f95:	75 dd                	jne    800f74 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb4:	73 50                	jae    801006 <memmove+0x6a>
  800fb6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	01 d0                	add    %edx,%eax
  800fbe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc1:	76 43                	jbe    801006 <memmove+0x6a>
		s += n;
  800fc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fcf:	eb 10                	jmp    800fe1 <memmove+0x45>
			*--d = *--s;
  800fd1:	ff 4d f8             	decl   -0x8(%ebp)
  800fd4:	ff 4d fc             	decl   -0x4(%ebp)
  800fd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fda:	8a 10                	mov    (%eax),%dl
  800fdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fea:	85 c0                	test   %eax,%eax
  800fec:	75 e3                	jne    800fd1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fee:	eb 23                	jmp    801013 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ff0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff3:	8d 50 01             	lea    0x1(%eax),%edx
  800ff6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fff:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801002:	8a 12                	mov    (%edx),%dl
  801004:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801006:	8b 45 10             	mov    0x10(%ebp),%eax
  801009:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100c:	89 55 10             	mov    %edx,0x10(%ebp)
  80100f:	85 c0                	test   %eax,%eax
  801011:	75 dd                	jne    800ff0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801016:	c9                   	leave  
  801017:	c3                   	ret    

00801018 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801024:	8b 45 0c             	mov    0xc(%ebp),%eax
  801027:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80102a:	eb 2a                	jmp    801056 <memcmp+0x3e>
		if (*s1 != *s2)
  80102c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102f:	8a 10                	mov    (%eax),%dl
  801031:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	38 c2                	cmp    %al,%dl
  801038:	74 16                	je     801050 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80103a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	0f b6 d0             	movzbl %al,%edx
  801042:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	0f b6 c0             	movzbl %al,%eax
  80104a:	29 c2                	sub    %eax,%edx
  80104c:	89 d0                	mov    %edx,%eax
  80104e:	eb 18                	jmp    801068 <memcmp+0x50>
		s1++, s2++;
  801050:	ff 45 fc             	incl   -0x4(%ebp)
  801053:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801056:	8b 45 10             	mov    0x10(%ebp),%eax
  801059:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105c:	89 55 10             	mov    %edx,0x10(%ebp)
  80105f:	85 c0                	test   %eax,%eax
  801061:	75 c9                	jne    80102c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801063:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801068:	c9                   	leave  
  801069:	c3                   	ret    

0080106a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801070:	8b 55 08             	mov    0x8(%ebp),%edx
  801073:	8b 45 10             	mov    0x10(%ebp),%eax
  801076:	01 d0                	add    %edx,%eax
  801078:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80107b:	eb 15                	jmp    801092 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	0f b6 d0             	movzbl %al,%edx
  801085:	8b 45 0c             	mov    0xc(%ebp),%eax
  801088:	0f b6 c0             	movzbl %al,%eax
  80108b:	39 c2                	cmp    %eax,%edx
  80108d:	74 0d                	je     80109c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80108f:	ff 45 08             	incl   0x8(%ebp)
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801098:	72 e3                	jb     80107d <memfind+0x13>
  80109a:	eb 01                	jmp    80109d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80109c:	90                   	nop
	return (void *) s;
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b6:	eb 03                	jmp    8010bb <strtol+0x19>
		s++;
  8010b8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	3c 20                	cmp    $0x20,%al
  8010c2:	74 f4                	je     8010b8 <strtol+0x16>
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	3c 09                	cmp    $0x9,%al
  8010cb:	74 eb                	je     8010b8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	3c 2b                	cmp    $0x2b,%al
  8010d4:	75 05                	jne    8010db <strtol+0x39>
		s++;
  8010d6:	ff 45 08             	incl   0x8(%ebp)
  8010d9:	eb 13                	jmp    8010ee <strtol+0x4c>
	else if (*s == '-')
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	8a 00                	mov    (%eax),%al
  8010e0:	3c 2d                	cmp    $0x2d,%al
  8010e2:	75 0a                	jne    8010ee <strtol+0x4c>
		s++, neg = 1;
  8010e4:	ff 45 08             	incl   0x8(%ebp)
  8010e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f2:	74 06                	je     8010fa <strtol+0x58>
  8010f4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010f8:	75 20                	jne    80111a <strtol+0x78>
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	3c 30                	cmp    $0x30,%al
  801101:	75 17                	jne    80111a <strtol+0x78>
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	40                   	inc    %eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 78                	cmp    $0x78,%al
  80110b:	75 0d                	jne    80111a <strtol+0x78>
		s += 2, base = 16;
  80110d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801111:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801118:	eb 28                	jmp    801142 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80111a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111e:	75 15                	jne    801135 <strtol+0x93>
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	3c 30                	cmp    $0x30,%al
  801127:	75 0c                	jne    801135 <strtol+0x93>
		s++, base = 8;
  801129:	ff 45 08             	incl   0x8(%ebp)
  80112c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801133:	eb 0d                	jmp    801142 <strtol+0xa0>
	else if (base == 0)
  801135:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801139:	75 07                	jne    801142 <strtol+0xa0>
		base = 10;
  80113b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	3c 2f                	cmp    $0x2f,%al
  801149:	7e 19                	jle    801164 <strtol+0xc2>
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	8a 00                	mov    (%eax),%al
  801150:	3c 39                	cmp    $0x39,%al
  801152:	7f 10                	jg     801164 <strtol+0xc2>
			dig = *s - '0';
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	0f be c0             	movsbl %al,%eax
  80115c:	83 e8 30             	sub    $0x30,%eax
  80115f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801162:	eb 42                	jmp    8011a6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	3c 60                	cmp    $0x60,%al
  80116b:	7e 19                	jle    801186 <strtol+0xe4>
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	3c 7a                	cmp    $0x7a,%al
  801174:	7f 10                	jg     801186 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	0f be c0             	movsbl %al,%eax
  80117e:	83 e8 57             	sub    $0x57,%eax
  801181:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801184:	eb 20                	jmp    8011a6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	8a 00                	mov    (%eax),%al
  80118b:	3c 40                	cmp    $0x40,%al
  80118d:	7e 39                	jle    8011c8 <strtol+0x126>
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	3c 5a                	cmp    $0x5a,%al
  801196:	7f 30                	jg     8011c8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	0f be c0             	movsbl %al,%eax
  8011a0:	83 e8 37             	sub    $0x37,%eax
  8011a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011ac:	7d 19                	jge    8011c7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011ae:	ff 45 08             	incl   0x8(%ebp)
  8011b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011b8:	89 c2                	mov    %eax,%edx
  8011ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bd:	01 d0                	add    %edx,%eax
  8011bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011c2:	e9 7b ff ff ff       	jmp    801142 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011c7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011cc:	74 08                	je     8011d6 <strtol+0x134>
		*endptr = (char *) s;
  8011ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011da:	74 07                	je     8011e3 <strtol+0x141>
  8011dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011df:	f7 d8                	neg    %eax
  8011e1:	eb 03                	jmp    8011e6 <strtol+0x144>
  8011e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011e6:	c9                   	leave  
  8011e7:	c3                   	ret    

008011e8 <ltostr>:

void
ltostr(long value, char *str)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801200:	79 13                	jns    801215 <ltostr+0x2d>
	{
		neg = 1;
  801202:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80120f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801212:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80121d:	99                   	cltd   
  80121e:	f7 f9                	idiv   %ecx
  801220:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801223:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801226:	8d 50 01             	lea    0x1(%eax),%edx
  801229:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80122c:	89 c2                	mov    %eax,%edx
  80122e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801231:	01 d0                	add    %edx,%eax
  801233:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801236:	83 c2 30             	add    $0x30,%edx
  801239:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80123b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801243:	f7 e9                	imul   %ecx
  801245:	c1 fa 02             	sar    $0x2,%edx
  801248:	89 c8                	mov    %ecx,%eax
  80124a:	c1 f8 1f             	sar    $0x1f,%eax
  80124d:	29 c2                	sub    %eax,%edx
  80124f:	89 d0                	mov    %edx,%eax
  801251:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801254:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801258:	75 bb                	jne    801215 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80125a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801261:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801264:	48                   	dec    %eax
  801265:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801268:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80126c:	74 3d                	je     8012ab <ltostr+0xc3>
		start = 1 ;
  80126e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801275:	eb 34                	jmp    8012ab <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801277:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127d:	01 d0                	add    %edx,%eax
  80127f:	8a 00                	mov    (%eax),%al
  801281:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801284:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128a:	01 c2                	add    %eax,%edx
  80128c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80128f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801292:	01 c8                	add    %ecx,%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801298:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80129b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129e:	01 c2                	add    %eax,%edx
  8012a0:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012a3:	88 02                	mov    %al,(%edx)
		start++ ;
  8012a5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012a8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b1:	7c c4                	jl     801277 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012b3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	01 d0                	add    %edx,%eax
  8012bb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012be:	90                   	nop
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012c7:	ff 75 08             	pushl  0x8(%ebp)
  8012ca:	e8 73 fa ff ff       	call   800d42 <strlen>
  8012cf:	83 c4 04             	add    $0x4,%esp
  8012d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012d5:	ff 75 0c             	pushl  0xc(%ebp)
  8012d8:	e8 65 fa ff ff       	call   800d42 <strlen>
  8012dd:	83 c4 04             	add    $0x4,%esp
  8012e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f1:	eb 17                	jmp    80130a <strcconcat+0x49>
		final[s] = str1[s] ;
  8012f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f9:	01 c2                	add    %eax,%edx
  8012fb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	01 c8                	add    %ecx,%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801307:	ff 45 fc             	incl   -0x4(%ebp)
  80130a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801310:	7c e1                	jl     8012f3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801312:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801319:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801320:	eb 1f                	jmp    801341 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801322:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801325:	8d 50 01             	lea    0x1(%eax),%edx
  801328:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80132b:	89 c2                	mov    %eax,%edx
  80132d:	8b 45 10             	mov    0x10(%ebp),%eax
  801330:	01 c2                	add    %eax,%edx
  801332:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801335:	8b 45 0c             	mov    0xc(%ebp),%eax
  801338:	01 c8                	add    %ecx,%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80133e:	ff 45 f8             	incl   -0x8(%ebp)
  801341:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801344:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801347:	7c d9                	jl     801322 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801349:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80134c:	8b 45 10             	mov    0x10(%ebp),%eax
  80134f:	01 d0                	add    %edx,%eax
  801351:	c6 00 00             	movb   $0x0,(%eax)
}
  801354:	90                   	nop
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80135a:	8b 45 14             	mov    0x14(%ebp),%eax
  80135d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801363:	8b 45 14             	mov    0x14(%ebp),%eax
  801366:	8b 00                	mov    (%eax),%eax
  801368:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80136f:	8b 45 10             	mov    0x10(%ebp),%eax
  801372:	01 d0                	add    %edx,%eax
  801374:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80137a:	eb 0c                	jmp    801388 <strsplit+0x31>
			*string++ = 0;
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	8d 50 01             	lea    0x1(%eax),%edx
  801382:	89 55 08             	mov    %edx,0x8(%ebp)
  801385:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	8a 00                	mov    (%eax),%al
  80138d:	84 c0                	test   %al,%al
  80138f:	74 18                	je     8013a9 <strsplit+0x52>
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	8a 00                	mov    (%eax),%al
  801396:	0f be c0             	movsbl %al,%eax
  801399:	50                   	push   %eax
  80139a:	ff 75 0c             	pushl  0xc(%ebp)
  80139d:	e8 32 fb ff ff       	call   800ed4 <strchr>
  8013a2:	83 c4 08             	add    $0x8,%esp
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	75 d3                	jne    80137c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	8a 00                	mov    (%eax),%al
  8013ae:	84 c0                	test   %al,%al
  8013b0:	74 5a                	je     80140c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b5:	8b 00                	mov    (%eax),%eax
  8013b7:	83 f8 0f             	cmp    $0xf,%eax
  8013ba:	75 07                	jne    8013c3 <strsplit+0x6c>
		{
			return 0;
  8013bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c1:	eb 66                	jmp    801429 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c6:	8b 00                	mov    (%eax),%eax
  8013c8:	8d 48 01             	lea    0x1(%eax),%ecx
  8013cb:	8b 55 14             	mov    0x14(%ebp),%edx
  8013ce:	89 0a                	mov    %ecx,(%edx)
  8013d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013da:	01 c2                	add    %eax,%edx
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e1:	eb 03                	jmp    8013e6 <strsplit+0x8f>
			string++;
  8013e3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	84 c0                	test   %al,%al
  8013ed:	74 8b                	je     80137a <strsplit+0x23>
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8a 00                	mov    (%eax),%al
  8013f4:	0f be c0             	movsbl %al,%eax
  8013f7:	50                   	push   %eax
  8013f8:	ff 75 0c             	pushl  0xc(%ebp)
  8013fb:	e8 d4 fa ff ff       	call   800ed4 <strchr>
  801400:	83 c4 08             	add    $0x8,%esp
  801403:	85 c0                	test   %eax,%eax
  801405:	74 dc                	je     8013e3 <strsplit+0x8c>
			string++;
	}
  801407:	e9 6e ff ff ff       	jmp    80137a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80140c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80140d:	8b 45 14             	mov    0x14(%ebp),%eax
  801410:	8b 00                	mov    (%eax),%eax
  801412:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801419:	8b 45 10             	mov    0x10(%ebp),%eax
  80141c:	01 d0                	add    %edx,%eax
  80141e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801424:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801431:	83 ec 04             	sub    $0x4,%esp
  801434:	68 68 43 80 00       	push   $0x804368
  801439:	68 3f 01 00 00       	push   $0x13f
  80143e:	68 8a 43 80 00       	push   $0x80438a
  801443:	e8 a9 ef ff ff       	call   8003f1 <_panic>

00801448 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	ff 75 08             	pushl  0x8(%ebp)
  801454:	e8 8d 0a 00 00       	call   801ee6 <sys_sbrk>
  801459:	83 c4 10             	add    $0x10,%esp
}
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801464:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801468:	75 0a                	jne    801474 <malloc+0x16>
  80146a:	b8 00 00 00 00       	mov    $0x0,%eax
  80146f:	e9 07 02 00 00       	jmp    80167b <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801474:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80147b:	8b 55 08             	mov    0x8(%ebp),%edx
  80147e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801481:	01 d0                	add    %edx,%eax
  801483:	48                   	dec    %eax
  801484:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801487:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80148a:	ba 00 00 00 00       	mov    $0x0,%edx
  80148f:	f7 75 dc             	divl   -0x24(%ebp)
  801492:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801495:	29 d0                	sub    %edx,%eax
  801497:	c1 e8 0c             	shr    $0xc,%eax
  80149a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  80149d:	a1 20 50 80 00       	mov    0x805020,%eax
  8014a2:	8b 40 78             	mov    0x78(%eax),%eax
  8014a5:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8014aa:	29 c2                	sub    %eax,%edx
  8014ac:	89 d0                	mov    %edx,%eax
  8014ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8014b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014b9:	c1 e8 0c             	shr    $0xc,%eax
  8014bc:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  8014bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8014c6:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8014cd:	77 42                	ja     801511 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8014cf:	e8 96 08 00 00       	call   801d6a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	74 16                	je     8014ee <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	ff 75 08             	pushl  0x8(%ebp)
  8014de:	e8 d6 0d 00 00       	call   8022b9 <alloc_block_FF>
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e9:	e9 8a 01 00 00       	jmp    801678 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014ee:	e8 a8 08 00 00       	call   801d9b <sys_isUHeapPlacementStrategyBESTFIT>
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	0f 84 7d 01 00 00    	je     801678 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014fb:	83 ec 0c             	sub    $0xc,%esp
  8014fe:	ff 75 08             	pushl  0x8(%ebp)
  801501:	e8 6f 12 00 00       	call   802775 <alloc_block_BF>
  801506:	83 c4 10             	add    $0x10,%esp
  801509:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80150c:	e9 67 01 00 00       	jmp    801678 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801511:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801514:	48                   	dec    %eax
  801515:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801518:	0f 86 53 01 00 00    	jbe    801671 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  80151e:	a1 20 50 80 00       	mov    0x805020,%eax
  801523:	8b 40 78             	mov    0x78(%eax),%eax
  801526:	05 00 10 00 00       	add    $0x1000,%eax
  80152b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  80152e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801535:	e9 de 00 00 00       	jmp    801618 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  80153a:	a1 20 50 80 00       	mov    0x805020,%eax
  80153f:	8b 40 78             	mov    0x78(%eax),%eax
  801542:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801545:	29 c2                	sub    %eax,%edx
  801547:	89 d0                	mov    %edx,%eax
  801549:	2d 00 10 00 00       	sub    $0x1000,%eax
  80154e:	c1 e8 0c             	shr    $0xc,%eax
  801551:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801558:	85 c0                	test   %eax,%eax
  80155a:	0f 85 ab 00 00 00    	jne    80160b <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801560:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801563:	05 00 10 00 00       	add    $0x1000,%eax
  801568:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80156b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801572:	eb 47                	jmp    8015bb <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801574:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80157b:	76 0a                	jbe    801587 <malloc+0x129>
  80157d:	b8 00 00 00 00       	mov    $0x0,%eax
  801582:	e9 f4 00 00 00       	jmp    80167b <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801587:	a1 20 50 80 00       	mov    0x805020,%eax
  80158c:	8b 40 78             	mov    0x78(%eax),%eax
  80158f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801592:	29 c2                	sub    %eax,%edx
  801594:	89 d0                	mov    %edx,%eax
  801596:	2d 00 10 00 00       	sub    $0x1000,%eax
  80159b:	c1 e8 0c             	shr    $0xc,%eax
  80159e:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	74 08                	je     8015b1 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  8015a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  8015af:	eb 5a                	jmp    80160b <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  8015b1:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  8015b8:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8015bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8015be:	48                   	dec    %eax
  8015bf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8015c2:	77 b0                	ja     801574 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  8015c4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  8015cb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8015d2:	eb 2f                	jmp    801603 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  8015d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015d7:	c1 e0 0c             	shl    $0xc,%eax
  8015da:	89 c2                	mov    %eax,%edx
  8015dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015df:	01 c2                	add    %eax,%edx
  8015e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8015e6:	8b 40 78             	mov    0x78(%eax),%eax
  8015e9:	29 c2                	sub    %eax,%edx
  8015eb:	89 d0                	mov    %edx,%eax
  8015ed:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015f2:	c1 e8 0c             	shr    $0xc,%eax
  8015f5:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
  8015fc:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801600:	ff 45 e0             	incl   -0x20(%ebp)
  801603:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801606:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801609:	72 c9                	jb     8015d4 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  80160b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80160f:	75 16                	jne    801627 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801611:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801618:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80161f:	0f 86 15 ff ff ff    	jbe    80153a <malloc+0xdc>
  801625:	eb 01                	jmp    801628 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801627:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801628:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80162c:	75 07                	jne    801635 <malloc+0x1d7>
  80162e:	b8 00 00 00 00       	mov    $0x0,%eax
  801633:	eb 46                	jmp    80167b <malloc+0x21d>
		ptr = (void*)i;
  801635:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801638:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  80163b:	a1 20 50 80 00       	mov    0x805020,%eax
  801640:	8b 40 78             	mov    0x78(%eax),%eax
  801643:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801646:	29 c2                	sub    %eax,%edx
  801648:	89 d0                	mov    %edx,%eax
  80164a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80164f:	c1 e8 0c             	shr    $0xc,%eax
  801652:	89 c2                	mov    %eax,%edx
  801654:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801657:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  80165e:	83 ec 08             	sub    $0x8,%esp
  801661:	ff 75 08             	pushl  0x8(%ebp)
  801664:	ff 75 f0             	pushl  -0x10(%ebp)
  801667:	e8 b1 08 00 00       	call   801f1d <sys_allocate_user_mem>
  80166c:	83 c4 10             	add    $0x10,%esp
  80166f:	eb 07                	jmp    801678 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801671:	b8 00 00 00 00       	mov    $0x0,%eax
  801676:	eb 03                	jmp    80167b <malloc+0x21d>
	}
	return ptr;
  801678:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801683:	a1 20 50 80 00       	mov    0x805020,%eax
  801688:	8b 40 78             	mov    0x78(%eax),%eax
  80168b:	05 00 10 00 00       	add    $0x1000,%eax
  801690:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801693:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  80169a:	a1 20 50 80 00       	mov    0x805020,%eax
  80169f:	8b 50 78             	mov    0x78(%eax),%edx
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	39 c2                	cmp    %eax,%edx
  8016a7:	76 24                	jbe    8016cd <free+0x50>
		size = get_block_size(va);
  8016a9:	83 ec 0c             	sub    $0xc,%esp
  8016ac:	ff 75 08             	pushl  0x8(%ebp)
  8016af:	e8 85 08 00 00       	call   801f39 <get_block_size>
  8016b4:	83 c4 10             	add    $0x10,%esp
  8016b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016ba:	83 ec 0c             	sub    $0xc,%esp
  8016bd:	ff 75 08             	pushl  0x8(%ebp)
  8016c0:	e8 b8 1a 00 00       	call   80317d <free_block>
  8016c5:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8016c8:	e9 ac 00 00 00       	jmp    801779 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016d3:	0f 82 89 00 00 00    	jb     801762 <free+0xe5>
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  8016e1:	77 7f                	ja     801762 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  8016e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8016eb:	8b 40 78             	mov    0x78(%eax),%eax
  8016ee:	29 c2                	sub    %eax,%edx
  8016f0:	89 d0                	mov    %edx,%eax
  8016f2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016f7:	c1 e8 0c             	shr    $0xc,%eax
  8016fa:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801701:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801704:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801707:	c1 e0 0c             	shl    $0xc,%eax
  80170a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  80170d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801714:	eb 2f                	jmp    801745 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801719:	c1 e0 0c             	shl    $0xc,%eax
  80171c:	89 c2                	mov    %eax,%edx
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	01 c2                	add    %eax,%edx
  801723:	a1 20 50 80 00       	mov    0x805020,%eax
  801728:	8b 40 78             	mov    0x78(%eax),%eax
  80172b:	29 c2                	sub    %eax,%edx
  80172d:	89 d0                	mov    %edx,%eax
  80172f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801734:	c1 e8 0c             	shr    $0xc,%eax
  801737:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  80173e:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801742:	ff 45 f4             	incl   -0xc(%ebp)
  801745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801748:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80174b:	72 c9                	jb     801716 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	83 ec 08             	sub    $0x8,%esp
  801753:	ff 75 ec             	pushl  -0x14(%ebp)
  801756:	50                   	push   %eax
  801757:	e8 a5 07 00 00       	call   801f01 <sys_free_user_mem>
  80175c:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80175f:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801760:	eb 17                	jmp    801779 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801762:	83 ec 04             	sub    $0x4,%esp
  801765:	68 98 43 80 00       	push   $0x804398
  80176a:	68 84 00 00 00       	push   $0x84
  80176f:	68 c2 43 80 00       	push   $0x8043c2
  801774:	e8 78 ec ff ff       	call   8003f1 <_panic>
	}
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 28             	sub    $0x28,%esp
  801781:	8b 45 10             	mov    0x10(%ebp),%eax
  801784:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801787:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80178b:	75 07                	jne    801794 <smalloc+0x19>
  80178d:	b8 00 00 00 00       	mov    $0x0,%eax
  801792:	eb 64                	jmp    8017f8 <smalloc+0x7d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80179a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a7:	39 d0                	cmp    %edx,%eax
  8017a9:	73 02                	jae    8017ad <smalloc+0x32>
  8017ab:	89 d0                	mov    %edx,%eax
  8017ad:	83 ec 0c             	sub    $0xc,%esp
  8017b0:	50                   	push   %eax
  8017b1:	e8 a8 fc ff ff       	call   80145e <malloc>
  8017b6:	83 c4 10             	add    $0x10,%esp
  8017b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8017bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017c0:	75 07                	jne    8017c9 <smalloc+0x4e>
  8017c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c7:	eb 2f                	jmp    8017f8 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017c9:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017cd:	ff 75 ec             	pushl  -0x14(%ebp)
  8017d0:	50                   	push   %eax
  8017d1:	ff 75 0c             	pushl  0xc(%ebp)
  8017d4:	ff 75 08             	pushl  0x8(%ebp)
  8017d7:	e8 2c 03 00 00       	call   801b08 <sys_createSharedObject>
  8017dc:	83 c4 10             	add    $0x10,%esp
  8017df:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017e2:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017e6:	74 06                	je     8017ee <smalloc+0x73>
  8017e8:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017ec:	75 07                	jne    8017f5 <smalloc+0x7a>
  8017ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f3:	eb 03                	jmp    8017f8 <smalloc+0x7d>
	 return ptr;
  8017f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801800:	83 ec 08             	sub    $0x8,%esp
  801803:	ff 75 0c             	pushl  0xc(%ebp)
  801806:	ff 75 08             	pushl  0x8(%ebp)
  801809:	e8 24 03 00 00       	call   801b32 <sys_getSizeOfSharedObject>
  80180e:	83 c4 10             	add    $0x10,%esp
  801811:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801814:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801818:	75 07                	jne    801821 <sget+0x27>
  80181a:	b8 00 00 00 00       	mov    $0x0,%eax
  80181f:	eb 5c                	jmp    80187d <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801824:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801827:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80182e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801834:	39 d0                	cmp    %edx,%eax
  801836:	7d 02                	jge    80183a <sget+0x40>
  801838:	89 d0                	mov    %edx,%eax
  80183a:	83 ec 0c             	sub    $0xc,%esp
  80183d:	50                   	push   %eax
  80183e:	e8 1b fc ff ff       	call   80145e <malloc>
  801843:	83 c4 10             	add    $0x10,%esp
  801846:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801849:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80184d:	75 07                	jne    801856 <sget+0x5c>
  80184f:	b8 00 00 00 00       	mov    $0x0,%eax
  801854:	eb 27                	jmp    80187d <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801856:	83 ec 04             	sub    $0x4,%esp
  801859:	ff 75 e8             	pushl  -0x18(%ebp)
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	ff 75 08             	pushl  0x8(%ebp)
  801862:	e8 e8 02 00 00       	call   801b4f <sys_getSharedObject>
  801867:	83 c4 10             	add    $0x10,%esp
  80186a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80186d:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801871:	75 07                	jne    80187a <sget+0x80>
  801873:	b8 00 00 00 00       	mov    $0x0,%eax
  801878:	eb 03                	jmp    80187d <sget+0x83>
	return ptr;
  80187a:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801885:	83 ec 04             	sub    $0x4,%esp
  801888:	68 d0 43 80 00       	push   $0x8043d0
  80188d:	68 c1 00 00 00       	push   $0xc1
  801892:	68 c2 43 80 00       	push   $0x8043c2
  801897:	e8 55 eb ff ff       	call   8003f1 <_panic>

0080189c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018a2:	83 ec 04             	sub    $0x4,%esp
  8018a5:	68 f4 43 80 00       	push   $0x8043f4
  8018aa:	68 d8 00 00 00       	push   $0xd8
  8018af:	68 c2 43 80 00       	push   $0x8043c2
  8018b4:	e8 38 eb ff ff       	call   8003f1 <_panic>

008018b9 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018bf:	83 ec 04             	sub    $0x4,%esp
  8018c2:	68 1a 44 80 00       	push   $0x80441a
  8018c7:	68 e4 00 00 00       	push   $0xe4
  8018cc:	68 c2 43 80 00       	push   $0x8043c2
  8018d1:	e8 1b eb ff ff       	call   8003f1 <_panic>

008018d6 <shrink>:

}
void shrink(uint32 newSize)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018dc:	83 ec 04             	sub    $0x4,%esp
  8018df:	68 1a 44 80 00       	push   $0x80441a
  8018e4:	68 e9 00 00 00       	push   $0xe9
  8018e9:	68 c2 43 80 00       	push   $0x8043c2
  8018ee:	e8 fe ea ff ff       	call   8003f1 <_panic>

008018f3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018f9:	83 ec 04             	sub    $0x4,%esp
  8018fc:	68 1a 44 80 00       	push   $0x80441a
  801901:	68 ee 00 00 00       	push   $0xee
  801906:	68 c2 43 80 00       	push   $0x8043c2
  80190b:	e8 e1 ea ff ff       	call   8003f1 <_panic>

00801910 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	57                   	push   %edi
  801914:	56                   	push   %esi
  801915:	53                   	push   %ebx
  801916:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801922:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801925:	8b 7d 18             	mov    0x18(%ebp),%edi
  801928:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80192b:	cd 30                	int    $0x30
  80192d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801930:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801933:	83 c4 10             	add    $0x10,%esp
  801936:	5b                   	pop    %ebx
  801937:	5e                   	pop    %esi
  801938:	5f                   	pop    %edi
  801939:	5d                   	pop    %ebp
  80193a:	c3                   	ret    

0080193b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	83 ec 04             	sub    $0x4,%esp
  801941:	8b 45 10             	mov    0x10(%ebp),%eax
  801944:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801947:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	52                   	push   %edx
  801953:	ff 75 0c             	pushl  0xc(%ebp)
  801956:	50                   	push   %eax
  801957:	6a 00                	push   $0x0
  801959:	e8 b2 ff ff ff       	call   801910 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	90                   	nop
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_cgetc>:

int
sys_cgetc(void)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 02                	push   $0x2
  801973:	e8 98 ff ff ff       	call   801910 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 03                	push   $0x3
  80198c:	e8 7f ff ff ff       	call   801910 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	90                   	nop
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 04                	push   $0x4
  8019a6:	e8 65 ff ff ff       	call   801910 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	90                   	nop
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	52                   	push   %edx
  8019c1:	50                   	push   %eax
  8019c2:	6a 08                	push   $0x8
  8019c4:	e8 47 ff ff ff       	call   801910 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
  8019d1:	56                   	push   %esi
  8019d2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019d3:	8b 75 18             	mov    0x18(%ebp),%esi
  8019d6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	56                   	push   %esi
  8019e3:	53                   	push   %ebx
  8019e4:	51                   	push   %ecx
  8019e5:	52                   	push   %edx
  8019e6:	50                   	push   %eax
  8019e7:	6a 09                	push   $0x9
  8019e9:	e8 22 ff ff ff       	call   801910 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f4:	5b                   	pop    %ebx
  8019f5:	5e                   	pop    %esi
  8019f6:	5d                   	pop    %ebp
  8019f7:	c3                   	ret    

008019f8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	52                   	push   %edx
  801a08:	50                   	push   %eax
  801a09:	6a 0a                	push   $0xa
  801a0b:	e8 00 ff ff ff       	call   801910 <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	ff 75 0c             	pushl  0xc(%ebp)
  801a21:	ff 75 08             	pushl  0x8(%ebp)
  801a24:	6a 0b                	push   $0xb
  801a26:	e8 e5 fe ff ff       	call   801910 <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 0c                	push   $0xc
  801a3f:	e8 cc fe ff ff       	call   801910 <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 0d                	push   $0xd
  801a58:	e8 b3 fe ff ff       	call   801910 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 0e                	push   $0xe
  801a71:	e8 9a fe ff ff       	call   801910 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 0f                	push   $0xf
  801a8a:	e8 81 fe ff ff       	call   801910 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	ff 75 08             	pushl  0x8(%ebp)
  801aa2:	6a 10                	push   $0x10
  801aa4:	e8 67 fe ff ff       	call   801910 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 11                	push   $0x11
  801abd:	e8 4e fe ff ff       	call   801910 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	90                   	nop
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_cputc>:

void
sys_cputc(const char c)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ad4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	50                   	push   %eax
  801ae1:	6a 01                	push   $0x1
  801ae3:	e8 28 fe ff ff       	call   801910 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	90                   	nop
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 14                	push   $0x14
  801afd:	e8 0e fe ff ff       	call   801910 <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	90                   	nop
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	83 ec 04             	sub    $0x4,%esp
  801b0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b11:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b14:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b17:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	51                   	push   %ecx
  801b21:	52                   	push   %edx
  801b22:	ff 75 0c             	pushl  0xc(%ebp)
  801b25:	50                   	push   %eax
  801b26:	6a 15                	push   $0x15
  801b28:	e8 e3 fd ff ff       	call   801910 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b38:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	52                   	push   %edx
  801b42:	50                   	push   %eax
  801b43:	6a 16                	push   $0x16
  801b45:	e8 c6 fd ff ff       	call   801910 <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b52:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	51                   	push   %ecx
  801b60:	52                   	push   %edx
  801b61:	50                   	push   %eax
  801b62:	6a 17                	push   $0x17
  801b64:	e8 a7 fd ff ff       	call   801910 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	52                   	push   %edx
  801b7e:	50                   	push   %eax
  801b7f:	6a 18                	push   $0x18
  801b81:	e8 8a fd ff ff       	call   801910 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	6a 00                	push   $0x0
  801b93:	ff 75 14             	pushl  0x14(%ebp)
  801b96:	ff 75 10             	pushl  0x10(%ebp)
  801b99:	ff 75 0c             	pushl  0xc(%ebp)
  801b9c:	50                   	push   %eax
  801b9d:	6a 19                	push   $0x19
  801b9f:	e8 6c fd ff ff       	call   801910 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	50                   	push   %eax
  801bb8:	6a 1a                	push   $0x1a
  801bba:	e8 51 fd ff ff       	call   801910 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	90                   	nop
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	50                   	push   %eax
  801bd4:	6a 1b                	push   $0x1b
  801bd6:	e8 35 fd ff ff       	call   801910 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 05                	push   $0x5
  801bef:	e8 1c fd ff ff       	call   801910 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 06                	push   $0x6
  801c08:	e8 03 fd ff ff       	call   801910 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 07                	push   $0x7
  801c21:	e8 ea fc ff ff       	call   801910 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_exit_env>:


void sys_exit_env(void)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 1c                	push   $0x1c
  801c3a:	e8 d1 fc ff ff       	call   801910 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	90                   	nop
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c4b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c4e:	8d 50 04             	lea    0x4(%eax),%edx
  801c51:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	52                   	push   %edx
  801c5b:	50                   	push   %eax
  801c5c:	6a 1d                	push   $0x1d
  801c5e:	e8 ad fc ff ff       	call   801910 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
	return result;
  801c66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c6f:	89 01                	mov    %eax,(%ecx)
  801c71:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	c9                   	leave  
  801c78:	c2 04 00             	ret    $0x4

00801c7b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	ff 75 10             	pushl  0x10(%ebp)
  801c85:	ff 75 0c             	pushl  0xc(%ebp)
  801c88:	ff 75 08             	pushl  0x8(%ebp)
  801c8b:	6a 13                	push   $0x13
  801c8d:	e8 7e fc ff ff       	call   801910 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
	return ;
  801c95:	90                   	nop
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 1e                	push   $0x1e
  801ca7:	e8 64 fc ff ff       	call   801910 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 04             	sub    $0x4,%esp
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cbd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	50                   	push   %eax
  801cca:	6a 1f                	push   $0x1f
  801ccc:	e8 3f fc ff ff       	call   801910 <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd4:	90                   	nop
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <rsttst>:
void rsttst()
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 21                	push   $0x21
  801ce6:	e8 25 fc ff ff       	call   801910 <syscall>
  801ceb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cee:	90                   	nop
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	83 ec 04             	sub    $0x4,%esp
  801cf7:	8b 45 14             	mov    0x14(%ebp),%eax
  801cfa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cfd:	8b 55 18             	mov    0x18(%ebp),%edx
  801d00:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d04:	52                   	push   %edx
  801d05:	50                   	push   %eax
  801d06:	ff 75 10             	pushl  0x10(%ebp)
  801d09:	ff 75 0c             	pushl  0xc(%ebp)
  801d0c:	ff 75 08             	pushl  0x8(%ebp)
  801d0f:	6a 20                	push   $0x20
  801d11:	e8 fa fb ff ff       	call   801910 <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
	return ;
  801d19:	90                   	nop
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <chktst>:
void chktst(uint32 n)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	ff 75 08             	pushl  0x8(%ebp)
  801d2a:	6a 22                	push   $0x22
  801d2c:	e8 df fb ff ff       	call   801910 <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
	return ;
  801d34:	90                   	nop
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <inctst>:

void inctst()
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 23                	push   $0x23
  801d46:	e8 c5 fb ff ff       	call   801910 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4e:	90                   	nop
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <gettst>:
uint32 gettst()
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 24                	push   $0x24
  801d60:	e8 ab fb ff ff       	call   801910 <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 25                	push   $0x25
  801d7c:	e8 8f fb ff ff       	call   801910 <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
  801d84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d87:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d8b:	75 07                	jne    801d94 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d92:	eb 05                	jmp    801d99 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 25                	push   $0x25
  801dad:	e8 5e fb ff ff       	call   801910 <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
  801db5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801db8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dbc:	75 07                	jne    801dc5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc3:	eb 05                	jmp    801dca <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 25                	push   $0x25
  801dde:	e8 2d fb ff ff       	call   801910 <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
  801de6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801de9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ded:	75 07                	jne    801df6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801def:	b8 01 00 00 00       	mov    $0x1,%eax
  801df4:	eb 05                	jmp    801dfb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801df6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 25                	push   $0x25
  801e0f:	e8 fc fa ff ff       	call   801910 <syscall>
  801e14:	83 c4 18             	add    $0x18,%esp
  801e17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e1a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e1e:	75 07                	jne    801e27 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e20:	b8 01 00 00 00       	mov    $0x1,%eax
  801e25:	eb 05                	jmp    801e2c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	ff 75 08             	pushl  0x8(%ebp)
  801e3c:	6a 26                	push   $0x26
  801e3e:	e8 cd fa ff ff       	call   801910 <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
	return ;
  801e46:	90                   	nop
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e4d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e50:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e56:	8b 45 08             	mov    0x8(%ebp),%eax
  801e59:	6a 00                	push   $0x0
  801e5b:	53                   	push   %ebx
  801e5c:	51                   	push   %ecx
  801e5d:	52                   	push   %edx
  801e5e:	50                   	push   %eax
  801e5f:	6a 27                	push   $0x27
  801e61:	e8 aa fa ff ff       	call   801910 <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
}
  801e69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e74:	8b 45 08             	mov    0x8(%ebp),%eax
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	52                   	push   %edx
  801e7e:	50                   	push   %eax
  801e7f:	6a 28                	push   $0x28
  801e81:	e8 8a fa ff ff       	call   801910 <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e8e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e94:	8b 45 08             	mov    0x8(%ebp),%eax
  801e97:	6a 00                	push   $0x0
  801e99:	51                   	push   %ecx
  801e9a:	ff 75 10             	pushl  0x10(%ebp)
  801e9d:	52                   	push   %edx
  801e9e:	50                   	push   %eax
  801e9f:	6a 29                	push   $0x29
  801ea1:	e8 6a fa ff ff       	call   801910 <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	ff 75 10             	pushl  0x10(%ebp)
  801eb5:	ff 75 0c             	pushl  0xc(%ebp)
  801eb8:	ff 75 08             	pushl  0x8(%ebp)
  801ebb:	6a 12                	push   $0x12
  801ebd:	e8 4e fa ff ff       	call   801910 <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec5:	90                   	nop
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ece:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	52                   	push   %edx
  801ed8:	50                   	push   %eax
  801ed9:	6a 2a                	push   $0x2a
  801edb:	e8 30 fa ff ff       	call   801910 <syscall>
  801ee0:	83 c4 18             	add    $0x18,%esp
	return;
  801ee3:	90                   	nop
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	50                   	push   %eax
  801ef5:	6a 2b                	push   $0x2b
  801ef7:	e8 14 fa ff ff       	call   801910 <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	ff 75 0c             	pushl  0xc(%ebp)
  801f0d:	ff 75 08             	pushl  0x8(%ebp)
  801f10:	6a 2c                	push   $0x2c
  801f12:	e8 f9 f9 ff ff       	call   801910 <syscall>
  801f17:	83 c4 18             	add    $0x18,%esp
	return;
  801f1a:	90                   	nop
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	ff 75 0c             	pushl  0xc(%ebp)
  801f29:	ff 75 08             	pushl  0x8(%ebp)
  801f2c:	6a 2d                	push   $0x2d
  801f2e:	e8 dd f9 ff ff       	call   801910 <syscall>
  801f33:	83 c4 18             	add    $0x18,%esp
	return;
  801f36:	90                   	nop
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	83 e8 04             	sub    $0x4,%eax
  801f45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f4b:	8b 00                	mov    (%eax),%eax
  801f4d:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	83 e8 04             	sub    $0x4,%eax
  801f5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f64:	8b 00                	mov    (%eax),%eax
  801f66:	83 e0 01             	and    $0x1,%eax
  801f69:	85 c0                	test   %eax,%eax
  801f6b:	0f 94 c0             	sete   %al
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f80:	83 f8 02             	cmp    $0x2,%eax
  801f83:	74 2b                	je     801fb0 <alloc_block+0x40>
  801f85:	83 f8 02             	cmp    $0x2,%eax
  801f88:	7f 07                	jg     801f91 <alloc_block+0x21>
  801f8a:	83 f8 01             	cmp    $0x1,%eax
  801f8d:	74 0e                	je     801f9d <alloc_block+0x2d>
  801f8f:	eb 58                	jmp    801fe9 <alloc_block+0x79>
  801f91:	83 f8 03             	cmp    $0x3,%eax
  801f94:	74 2d                	je     801fc3 <alloc_block+0x53>
  801f96:	83 f8 04             	cmp    $0x4,%eax
  801f99:	74 3b                	je     801fd6 <alloc_block+0x66>
  801f9b:	eb 4c                	jmp    801fe9 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f9d:	83 ec 0c             	sub    $0xc,%esp
  801fa0:	ff 75 08             	pushl  0x8(%ebp)
  801fa3:	e8 11 03 00 00       	call   8022b9 <alloc_block_FF>
  801fa8:	83 c4 10             	add    $0x10,%esp
  801fab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fae:	eb 4a                	jmp    801ffa <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801fb0:	83 ec 0c             	sub    $0xc,%esp
  801fb3:	ff 75 08             	pushl  0x8(%ebp)
  801fb6:	e8 fa 19 00 00       	call   8039b5 <alloc_block_NF>
  801fbb:	83 c4 10             	add    $0x10,%esp
  801fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fc1:	eb 37                	jmp    801ffa <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fc3:	83 ec 0c             	sub    $0xc,%esp
  801fc6:	ff 75 08             	pushl  0x8(%ebp)
  801fc9:	e8 a7 07 00 00       	call   802775 <alloc_block_BF>
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fd4:	eb 24                	jmp    801ffa <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801fd6:	83 ec 0c             	sub    $0xc,%esp
  801fd9:	ff 75 08             	pushl  0x8(%ebp)
  801fdc:	e8 b7 19 00 00       	call   803998 <alloc_block_WF>
  801fe1:	83 c4 10             	add    $0x10,%esp
  801fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fe7:	eb 11                	jmp    801ffa <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801fe9:	83 ec 0c             	sub    $0xc,%esp
  801fec:	68 2c 44 80 00       	push   $0x80442c
  801ff1:	e8 b8 e6 ff ff       	call   8006ae <cprintf>
  801ff6:	83 c4 10             	add    $0x10,%esp
		break;
  801ff9:	90                   	nop
	}
	return va;
  801ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	53                   	push   %ebx
  802003:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802006:	83 ec 0c             	sub    $0xc,%esp
  802009:	68 4c 44 80 00       	push   $0x80444c
  80200e:	e8 9b e6 ff ff       	call   8006ae <cprintf>
  802013:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802016:	83 ec 0c             	sub    $0xc,%esp
  802019:	68 77 44 80 00       	push   $0x804477
  80201e:	e8 8b e6 ff ff       	call   8006ae <cprintf>
  802023:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80202c:	eb 37                	jmp    802065 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80202e:	83 ec 0c             	sub    $0xc,%esp
  802031:	ff 75 f4             	pushl  -0xc(%ebp)
  802034:	e8 19 ff ff ff       	call   801f52 <is_free_block>
  802039:	83 c4 10             	add    $0x10,%esp
  80203c:	0f be d8             	movsbl %al,%ebx
  80203f:	83 ec 0c             	sub    $0xc,%esp
  802042:	ff 75 f4             	pushl  -0xc(%ebp)
  802045:	e8 ef fe ff ff       	call   801f39 <get_block_size>
  80204a:	83 c4 10             	add    $0x10,%esp
  80204d:	83 ec 04             	sub    $0x4,%esp
  802050:	53                   	push   %ebx
  802051:	50                   	push   %eax
  802052:	68 8f 44 80 00       	push   $0x80448f
  802057:	e8 52 e6 ff ff       	call   8006ae <cprintf>
  80205c:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80205f:	8b 45 10             	mov    0x10(%ebp),%eax
  802062:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802065:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802069:	74 07                	je     802072 <print_blocks_list+0x73>
  80206b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206e:	8b 00                	mov    (%eax),%eax
  802070:	eb 05                	jmp    802077 <print_blocks_list+0x78>
  802072:	b8 00 00 00 00       	mov    $0x0,%eax
  802077:	89 45 10             	mov    %eax,0x10(%ebp)
  80207a:	8b 45 10             	mov    0x10(%ebp),%eax
  80207d:	85 c0                	test   %eax,%eax
  80207f:	75 ad                	jne    80202e <print_blocks_list+0x2f>
  802081:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802085:	75 a7                	jne    80202e <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802087:	83 ec 0c             	sub    $0xc,%esp
  80208a:	68 4c 44 80 00       	push   $0x80444c
  80208f:	e8 1a e6 ff ff       	call   8006ae <cprintf>
  802094:	83 c4 10             	add    $0x10,%esp

}
  802097:	90                   	nop
  802098:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a6:	83 e0 01             	and    $0x1,%eax
  8020a9:	85 c0                	test   %eax,%eax
  8020ab:	74 03                	je     8020b0 <initialize_dynamic_allocator+0x13>
  8020ad:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020b4:	0f 84 c7 01 00 00    	je     802281 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020ba:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020c1:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ca:	01 d0                	add    %edx,%eax
  8020cc:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020d1:	0f 87 ad 01 00 00    	ja     802284 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	85 c0                	test   %eax,%eax
  8020dc:	0f 89 a5 01 00 00    	jns    802287 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8020e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e8:	01 d0                	add    %edx,%eax
  8020ea:	83 e8 04             	sub    $0x4,%eax
  8020ed:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8020f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8020f9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802101:	e9 87 00 00 00       	jmp    80218d <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802106:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80210a:	75 14                	jne    802120 <initialize_dynamic_allocator+0x83>
  80210c:	83 ec 04             	sub    $0x4,%esp
  80210f:	68 a7 44 80 00       	push   $0x8044a7
  802114:	6a 79                	push   $0x79
  802116:	68 c5 44 80 00       	push   $0x8044c5
  80211b:	e8 d1 e2 ff ff       	call   8003f1 <_panic>
  802120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802123:	8b 00                	mov    (%eax),%eax
  802125:	85 c0                	test   %eax,%eax
  802127:	74 10                	je     802139 <initialize_dynamic_allocator+0x9c>
  802129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212c:	8b 00                	mov    (%eax),%eax
  80212e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802131:	8b 52 04             	mov    0x4(%edx),%edx
  802134:	89 50 04             	mov    %edx,0x4(%eax)
  802137:	eb 0b                	jmp    802144 <initialize_dynamic_allocator+0xa7>
  802139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213c:	8b 40 04             	mov    0x4(%eax),%eax
  80213f:	a3 30 50 80 00       	mov    %eax,0x805030
  802144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802147:	8b 40 04             	mov    0x4(%eax),%eax
  80214a:	85 c0                	test   %eax,%eax
  80214c:	74 0f                	je     80215d <initialize_dynamic_allocator+0xc0>
  80214e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802151:	8b 40 04             	mov    0x4(%eax),%eax
  802154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802157:	8b 12                	mov    (%edx),%edx
  802159:	89 10                	mov    %edx,(%eax)
  80215b:	eb 0a                	jmp    802167 <initialize_dynamic_allocator+0xca>
  80215d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802160:	8b 00                	mov    (%eax),%eax
  802162:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802173:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80217a:	a1 38 50 80 00       	mov    0x805038,%eax
  80217f:	48                   	dec    %eax
  802180:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802185:	a1 34 50 80 00       	mov    0x805034,%eax
  80218a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80218d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802191:	74 07                	je     80219a <initialize_dynamic_allocator+0xfd>
  802193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802196:	8b 00                	mov    (%eax),%eax
  802198:	eb 05                	jmp    80219f <initialize_dynamic_allocator+0x102>
  80219a:	b8 00 00 00 00       	mov    $0x0,%eax
  80219f:	a3 34 50 80 00       	mov    %eax,0x805034
  8021a4:	a1 34 50 80 00       	mov    0x805034,%eax
  8021a9:	85 c0                	test   %eax,%eax
  8021ab:	0f 85 55 ff ff ff    	jne    802106 <initialize_dynamic_allocator+0x69>
  8021b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b5:	0f 85 4b ff ff ff    	jne    802106 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021ca:	a1 44 50 80 00       	mov    0x805044,%eax
  8021cf:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8021d4:	a1 40 50 80 00       	mov    0x805040,%eax
  8021d9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	83 c0 08             	add    $0x8,%eax
  8021e5:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	83 c0 04             	add    $0x4,%eax
  8021ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f1:	83 ea 08             	sub    $0x8,%edx
  8021f4:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	01 d0                	add    %edx,%eax
  8021fe:	83 e8 08             	sub    $0x8,%eax
  802201:	8b 55 0c             	mov    0xc(%ebp),%edx
  802204:	83 ea 08             	sub    $0x8,%edx
  802207:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802212:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802215:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80221c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802220:	75 17                	jne    802239 <initialize_dynamic_allocator+0x19c>
  802222:	83 ec 04             	sub    $0x4,%esp
  802225:	68 e0 44 80 00       	push   $0x8044e0
  80222a:	68 90 00 00 00       	push   $0x90
  80222f:	68 c5 44 80 00       	push   $0x8044c5
  802234:	e8 b8 e1 ff ff       	call   8003f1 <_panic>
  802239:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80223f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802242:	89 10                	mov    %edx,(%eax)
  802244:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802247:	8b 00                	mov    (%eax),%eax
  802249:	85 c0                	test   %eax,%eax
  80224b:	74 0d                	je     80225a <initialize_dynamic_allocator+0x1bd>
  80224d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802252:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802255:	89 50 04             	mov    %edx,0x4(%eax)
  802258:	eb 08                	jmp    802262 <initialize_dynamic_allocator+0x1c5>
  80225a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225d:	a3 30 50 80 00       	mov    %eax,0x805030
  802262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802265:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80226a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802274:	a1 38 50 80 00       	mov    0x805038,%eax
  802279:	40                   	inc    %eax
  80227a:	a3 38 50 80 00       	mov    %eax,0x805038
  80227f:	eb 07                	jmp    802288 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802281:	90                   	nop
  802282:	eb 04                	jmp    802288 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802284:	90                   	nop
  802285:	eb 01                	jmp    802288 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802287:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802288:	c9                   	leave  
  802289:	c3                   	ret    

0080228a <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80228a:	55                   	push   %ebp
  80228b:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80228d:	8b 45 10             	mov    0x10(%ebp),%eax
  802290:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	8d 50 fc             	lea    -0x4(%eax),%edx
  802299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229c:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	83 e8 04             	sub    $0x4,%eax
  8022a4:	8b 00                	mov    (%eax),%eax
  8022a6:	83 e0 fe             	and    $0xfffffffe,%eax
  8022a9:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	01 c2                	add    %eax,%edx
  8022b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b4:	89 02                	mov    %eax,(%edx)
}
  8022b6:	90                   	nop
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    

008022b9 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	83 e0 01             	and    $0x1,%eax
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	74 03                	je     8022cc <alloc_block_FF+0x13>
  8022c9:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022cc:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022d0:	77 07                	ja     8022d9 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022d2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022d9:	a1 24 50 80 00       	mov    0x805024,%eax
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	75 73                	jne    802355 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	83 c0 10             	add    $0x10,%eax
  8022e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022eb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f8:	01 d0                	add    %edx,%eax
  8022fa:	48                   	dec    %eax
  8022fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802301:	ba 00 00 00 00       	mov    $0x0,%edx
  802306:	f7 75 ec             	divl   -0x14(%ebp)
  802309:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80230c:	29 d0                	sub    %edx,%eax
  80230e:	c1 e8 0c             	shr    $0xc,%eax
  802311:	83 ec 0c             	sub    $0xc,%esp
  802314:	50                   	push   %eax
  802315:	e8 2e f1 ff ff       	call   801448 <sbrk>
  80231a:	83 c4 10             	add    $0x10,%esp
  80231d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802320:	83 ec 0c             	sub    $0xc,%esp
  802323:	6a 00                	push   $0x0
  802325:	e8 1e f1 ff ff       	call   801448 <sbrk>
  80232a:	83 c4 10             	add    $0x10,%esp
  80232d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802330:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802333:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802336:	83 ec 08             	sub    $0x8,%esp
  802339:	50                   	push   %eax
  80233a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80233d:	e8 5b fd ff ff       	call   80209d <initialize_dynamic_allocator>
  802342:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802345:	83 ec 0c             	sub    $0xc,%esp
  802348:	68 03 45 80 00       	push   $0x804503
  80234d:	e8 5c e3 ff ff       	call   8006ae <cprintf>
  802352:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802355:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802359:	75 0a                	jne    802365 <alloc_block_FF+0xac>
	        return NULL;
  80235b:	b8 00 00 00 00       	mov    $0x0,%eax
  802360:	e9 0e 04 00 00       	jmp    802773 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802365:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80236c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802371:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802374:	e9 f3 02 00 00       	jmp    80266c <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80237f:	83 ec 0c             	sub    $0xc,%esp
  802382:	ff 75 bc             	pushl  -0x44(%ebp)
  802385:	e8 af fb ff ff       	call   801f39 <get_block_size>
  80238a:	83 c4 10             	add    $0x10,%esp
  80238d:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	83 c0 08             	add    $0x8,%eax
  802396:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802399:	0f 87 c5 02 00 00    	ja     802664 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80239f:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a2:	83 c0 18             	add    $0x18,%eax
  8023a5:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023a8:	0f 87 19 02 00 00    	ja     8025c7 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023b1:	2b 45 08             	sub    0x8(%ebp),%eax
  8023b4:	83 e8 08             	sub    $0x8,%eax
  8023b7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	8d 50 08             	lea    0x8(%eax),%edx
  8023c0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023c3:	01 d0                	add    %edx,%eax
  8023c5:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	83 c0 08             	add    $0x8,%eax
  8023ce:	83 ec 04             	sub    $0x4,%esp
  8023d1:	6a 01                	push   $0x1
  8023d3:	50                   	push   %eax
  8023d4:	ff 75 bc             	pushl  -0x44(%ebp)
  8023d7:	e8 ae fe ff ff       	call   80228a <set_block_data>
  8023dc:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	8b 40 04             	mov    0x4(%eax),%eax
  8023e5:	85 c0                	test   %eax,%eax
  8023e7:	75 68                	jne    802451 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023e9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023ed:	75 17                	jne    802406 <alloc_block_FF+0x14d>
  8023ef:	83 ec 04             	sub    $0x4,%esp
  8023f2:	68 e0 44 80 00       	push   $0x8044e0
  8023f7:	68 d7 00 00 00       	push   $0xd7
  8023fc:	68 c5 44 80 00       	push   $0x8044c5
  802401:	e8 eb df ff ff       	call   8003f1 <_panic>
  802406:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80240c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80240f:	89 10                	mov    %edx,(%eax)
  802411:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802414:	8b 00                	mov    (%eax),%eax
  802416:	85 c0                	test   %eax,%eax
  802418:	74 0d                	je     802427 <alloc_block_FF+0x16e>
  80241a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80241f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802422:	89 50 04             	mov    %edx,0x4(%eax)
  802425:	eb 08                	jmp    80242f <alloc_block_FF+0x176>
  802427:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80242a:	a3 30 50 80 00       	mov    %eax,0x805030
  80242f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802432:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802437:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80243a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802441:	a1 38 50 80 00       	mov    0x805038,%eax
  802446:	40                   	inc    %eax
  802447:	a3 38 50 80 00       	mov    %eax,0x805038
  80244c:	e9 dc 00 00 00       	jmp    80252d <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802454:	8b 00                	mov    (%eax),%eax
  802456:	85 c0                	test   %eax,%eax
  802458:	75 65                	jne    8024bf <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80245a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80245e:	75 17                	jne    802477 <alloc_block_FF+0x1be>
  802460:	83 ec 04             	sub    $0x4,%esp
  802463:	68 14 45 80 00       	push   $0x804514
  802468:	68 db 00 00 00       	push   $0xdb
  80246d:	68 c5 44 80 00       	push   $0x8044c5
  802472:	e8 7a df ff ff       	call   8003f1 <_panic>
  802477:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80247d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802480:	89 50 04             	mov    %edx,0x4(%eax)
  802483:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802486:	8b 40 04             	mov    0x4(%eax),%eax
  802489:	85 c0                	test   %eax,%eax
  80248b:	74 0c                	je     802499 <alloc_block_FF+0x1e0>
  80248d:	a1 30 50 80 00       	mov    0x805030,%eax
  802492:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802495:	89 10                	mov    %edx,(%eax)
  802497:	eb 08                	jmp    8024a1 <alloc_block_FF+0x1e8>
  802499:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80249c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a4:	a3 30 50 80 00       	mov    %eax,0x805030
  8024a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8024b7:	40                   	inc    %eax
  8024b8:	a3 38 50 80 00       	mov    %eax,0x805038
  8024bd:	eb 6e                	jmp    80252d <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c3:	74 06                	je     8024cb <alloc_block_FF+0x212>
  8024c5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024c9:	75 17                	jne    8024e2 <alloc_block_FF+0x229>
  8024cb:	83 ec 04             	sub    $0x4,%esp
  8024ce:	68 38 45 80 00       	push   $0x804538
  8024d3:	68 df 00 00 00       	push   $0xdf
  8024d8:	68 c5 44 80 00       	push   $0x8044c5
  8024dd:	e8 0f df ff ff       	call   8003f1 <_panic>
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 10                	mov    (%eax),%edx
  8024e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ea:	89 10                	mov    %edx,(%eax)
  8024ec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ef:	8b 00                	mov    (%eax),%eax
  8024f1:	85 c0                	test   %eax,%eax
  8024f3:	74 0b                	je     802500 <alloc_block_FF+0x247>
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 00                	mov    (%eax),%eax
  8024fa:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024fd:	89 50 04             	mov    %edx,0x4(%eax)
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802506:	89 10                	mov    %edx,(%eax)
  802508:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80250b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250e:	89 50 04             	mov    %edx,0x4(%eax)
  802511:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802514:	8b 00                	mov    (%eax),%eax
  802516:	85 c0                	test   %eax,%eax
  802518:	75 08                	jne    802522 <alloc_block_FF+0x269>
  80251a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80251d:	a3 30 50 80 00       	mov    %eax,0x805030
  802522:	a1 38 50 80 00       	mov    0x805038,%eax
  802527:	40                   	inc    %eax
  802528:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80252d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802531:	75 17                	jne    80254a <alloc_block_FF+0x291>
  802533:	83 ec 04             	sub    $0x4,%esp
  802536:	68 a7 44 80 00       	push   $0x8044a7
  80253b:	68 e1 00 00 00       	push   $0xe1
  802540:	68 c5 44 80 00       	push   $0x8044c5
  802545:	e8 a7 de ff ff       	call   8003f1 <_panic>
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	8b 00                	mov    (%eax),%eax
  80254f:	85 c0                	test   %eax,%eax
  802551:	74 10                	je     802563 <alloc_block_FF+0x2aa>
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	8b 00                	mov    (%eax),%eax
  802558:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255b:	8b 52 04             	mov    0x4(%edx),%edx
  80255e:	89 50 04             	mov    %edx,0x4(%eax)
  802561:	eb 0b                	jmp    80256e <alloc_block_FF+0x2b5>
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 40 04             	mov    0x4(%eax),%eax
  802569:	a3 30 50 80 00       	mov    %eax,0x805030
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	8b 40 04             	mov    0x4(%eax),%eax
  802574:	85 c0                	test   %eax,%eax
  802576:	74 0f                	je     802587 <alloc_block_FF+0x2ce>
  802578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257b:	8b 40 04             	mov    0x4(%eax),%eax
  80257e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802581:	8b 12                	mov    (%edx),%edx
  802583:	89 10                	mov    %edx,(%eax)
  802585:	eb 0a                	jmp    802591 <alloc_block_FF+0x2d8>
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 00                	mov    (%eax),%eax
  80258c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a4:	a1 38 50 80 00       	mov    0x805038,%eax
  8025a9:	48                   	dec    %eax
  8025aa:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025af:	83 ec 04             	sub    $0x4,%esp
  8025b2:	6a 00                	push   $0x0
  8025b4:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025b7:	ff 75 b0             	pushl  -0x50(%ebp)
  8025ba:	e8 cb fc ff ff       	call   80228a <set_block_data>
  8025bf:	83 c4 10             	add    $0x10,%esp
  8025c2:	e9 95 00 00 00       	jmp    80265c <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025c7:	83 ec 04             	sub    $0x4,%esp
  8025ca:	6a 01                	push   $0x1
  8025cc:	ff 75 b8             	pushl  -0x48(%ebp)
  8025cf:	ff 75 bc             	pushl  -0x44(%ebp)
  8025d2:	e8 b3 fc ff ff       	call   80228a <set_block_data>
  8025d7:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025de:	75 17                	jne    8025f7 <alloc_block_FF+0x33e>
  8025e0:	83 ec 04             	sub    $0x4,%esp
  8025e3:	68 a7 44 80 00       	push   $0x8044a7
  8025e8:	68 e8 00 00 00       	push   $0xe8
  8025ed:	68 c5 44 80 00       	push   $0x8044c5
  8025f2:	e8 fa dd ff ff       	call   8003f1 <_panic>
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	85 c0                	test   %eax,%eax
  8025fe:	74 10                	je     802610 <alloc_block_FF+0x357>
  802600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802603:	8b 00                	mov    (%eax),%eax
  802605:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802608:	8b 52 04             	mov    0x4(%edx),%edx
  80260b:	89 50 04             	mov    %edx,0x4(%eax)
  80260e:	eb 0b                	jmp    80261b <alloc_block_FF+0x362>
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	8b 40 04             	mov    0x4(%eax),%eax
  802616:	a3 30 50 80 00       	mov    %eax,0x805030
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	8b 40 04             	mov    0x4(%eax),%eax
  802621:	85 c0                	test   %eax,%eax
  802623:	74 0f                	je     802634 <alloc_block_FF+0x37b>
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	8b 40 04             	mov    0x4(%eax),%eax
  80262b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262e:	8b 12                	mov    (%edx),%edx
  802630:	89 10                	mov    %edx,(%eax)
  802632:	eb 0a                	jmp    80263e <alloc_block_FF+0x385>
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 00                	mov    (%eax),%eax
  802639:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802641:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802651:	a1 38 50 80 00       	mov    0x805038,%eax
  802656:	48                   	dec    %eax
  802657:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80265c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80265f:	e9 0f 01 00 00       	jmp    802773 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802664:	a1 34 50 80 00       	mov    0x805034,%eax
  802669:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802670:	74 07                	je     802679 <alloc_block_FF+0x3c0>
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	8b 00                	mov    (%eax),%eax
  802677:	eb 05                	jmp    80267e <alloc_block_FF+0x3c5>
  802679:	b8 00 00 00 00       	mov    $0x0,%eax
  80267e:	a3 34 50 80 00       	mov    %eax,0x805034
  802683:	a1 34 50 80 00       	mov    0x805034,%eax
  802688:	85 c0                	test   %eax,%eax
  80268a:	0f 85 e9 fc ff ff    	jne    802379 <alloc_block_FF+0xc0>
  802690:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802694:	0f 85 df fc ff ff    	jne    802379 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80269a:	8b 45 08             	mov    0x8(%ebp),%eax
  80269d:	83 c0 08             	add    $0x8,%eax
  8026a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026a3:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026b0:	01 d0                	add    %edx,%eax
  8026b2:	48                   	dec    %eax
  8026b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026be:	f7 75 d8             	divl   -0x28(%ebp)
  8026c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026c4:	29 d0                	sub    %edx,%eax
  8026c6:	c1 e8 0c             	shr    $0xc,%eax
  8026c9:	83 ec 0c             	sub    $0xc,%esp
  8026cc:	50                   	push   %eax
  8026cd:	e8 76 ed ff ff       	call   801448 <sbrk>
  8026d2:	83 c4 10             	add    $0x10,%esp
  8026d5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026d8:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026dc:	75 0a                	jne    8026e8 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8026de:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e3:	e9 8b 00 00 00       	jmp    802773 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8026e8:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026ef:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026f5:	01 d0                	add    %edx,%eax
  8026f7:	48                   	dec    %eax
  8026f8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026fe:	ba 00 00 00 00       	mov    $0x0,%edx
  802703:	f7 75 cc             	divl   -0x34(%ebp)
  802706:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802709:	29 d0                	sub    %edx,%eax
  80270b:	8d 50 fc             	lea    -0x4(%eax),%edx
  80270e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802711:	01 d0                	add    %edx,%eax
  802713:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802718:	a1 40 50 80 00       	mov    0x805040,%eax
  80271d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802723:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80272a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80272d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802730:	01 d0                	add    %edx,%eax
  802732:	48                   	dec    %eax
  802733:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802736:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802739:	ba 00 00 00 00       	mov    $0x0,%edx
  80273e:	f7 75 c4             	divl   -0x3c(%ebp)
  802741:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802744:	29 d0                	sub    %edx,%eax
  802746:	83 ec 04             	sub    $0x4,%esp
  802749:	6a 01                	push   $0x1
  80274b:	50                   	push   %eax
  80274c:	ff 75 d0             	pushl  -0x30(%ebp)
  80274f:	e8 36 fb ff ff       	call   80228a <set_block_data>
  802754:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802757:	83 ec 0c             	sub    $0xc,%esp
  80275a:	ff 75 d0             	pushl  -0x30(%ebp)
  80275d:	e8 1b 0a 00 00       	call   80317d <free_block>
  802762:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802765:	83 ec 0c             	sub    $0xc,%esp
  802768:	ff 75 08             	pushl  0x8(%ebp)
  80276b:	e8 49 fb ff ff       	call   8022b9 <alloc_block_FF>
  802770:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802773:	c9                   	leave  
  802774:	c3                   	ret    

00802775 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802775:	55                   	push   %ebp
  802776:	89 e5                	mov    %esp,%ebp
  802778:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80277b:	8b 45 08             	mov    0x8(%ebp),%eax
  80277e:	83 e0 01             	and    $0x1,%eax
  802781:	85 c0                	test   %eax,%eax
  802783:	74 03                	je     802788 <alloc_block_BF+0x13>
  802785:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802788:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80278c:	77 07                	ja     802795 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80278e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802795:	a1 24 50 80 00       	mov    0x805024,%eax
  80279a:	85 c0                	test   %eax,%eax
  80279c:	75 73                	jne    802811 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80279e:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a1:	83 c0 10             	add    $0x10,%eax
  8027a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027a7:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b4:	01 d0                	add    %edx,%eax
  8027b6:	48                   	dec    %eax
  8027b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c2:	f7 75 e0             	divl   -0x20(%ebp)
  8027c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027c8:	29 d0                	sub    %edx,%eax
  8027ca:	c1 e8 0c             	shr    $0xc,%eax
  8027cd:	83 ec 0c             	sub    $0xc,%esp
  8027d0:	50                   	push   %eax
  8027d1:	e8 72 ec ff ff       	call   801448 <sbrk>
  8027d6:	83 c4 10             	add    $0x10,%esp
  8027d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027dc:	83 ec 0c             	sub    $0xc,%esp
  8027df:	6a 00                	push   $0x0
  8027e1:	e8 62 ec ff ff       	call   801448 <sbrk>
  8027e6:	83 c4 10             	add    $0x10,%esp
  8027e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027ef:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8027f2:	83 ec 08             	sub    $0x8,%esp
  8027f5:	50                   	push   %eax
  8027f6:	ff 75 d8             	pushl  -0x28(%ebp)
  8027f9:	e8 9f f8 ff ff       	call   80209d <initialize_dynamic_allocator>
  8027fe:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802801:	83 ec 0c             	sub    $0xc,%esp
  802804:	68 03 45 80 00       	push   $0x804503
  802809:	e8 a0 de ff ff       	call   8006ae <cprintf>
  80280e:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802811:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802818:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80281f:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802826:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80282d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802832:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802835:	e9 1d 01 00 00       	jmp    802957 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802840:	83 ec 0c             	sub    $0xc,%esp
  802843:	ff 75 a8             	pushl  -0x58(%ebp)
  802846:	e8 ee f6 ff ff       	call   801f39 <get_block_size>
  80284b:	83 c4 10             	add    $0x10,%esp
  80284e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802851:	8b 45 08             	mov    0x8(%ebp),%eax
  802854:	83 c0 08             	add    $0x8,%eax
  802857:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80285a:	0f 87 ef 00 00 00    	ja     80294f <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	83 c0 18             	add    $0x18,%eax
  802866:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802869:	77 1d                	ja     802888 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80286b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802871:	0f 86 d8 00 00 00    	jbe    80294f <alloc_block_BF+0x1da>
				{
					best_va = va;
  802877:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80287a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80287d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802880:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802883:	e9 c7 00 00 00       	jmp    80294f <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802888:	8b 45 08             	mov    0x8(%ebp),%eax
  80288b:	83 c0 08             	add    $0x8,%eax
  80288e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802891:	0f 85 9d 00 00 00    	jne    802934 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802897:	83 ec 04             	sub    $0x4,%esp
  80289a:	6a 01                	push   $0x1
  80289c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80289f:	ff 75 a8             	pushl  -0x58(%ebp)
  8028a2:	e8 e3 f9 ff ff       	call   80228a <set_block_data>
  8028a7:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ae:	75 17                	jne    8028c7 <alloc_block_BF+0x152>
  8028b0:	83 ec 04             	sub    $0x4,%esp
  8028b3:	68 a7 44 80 00       	push   $0x8044a7
  8028b8:	68 2c 01 00 00       	push   $0x12c
  8028bd:	68 c5 44 80 00       	push   $0x8044c5
  8028c2:	e8 2a db ff ff       	call   8003f1 <_panic>
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	8b 00                	mov    (%eax),%eax
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	74 10                	je     8028e0 <alloc_block_BF+0x16b>
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 00                	mov    (%eax),%eax
  8028d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d8:	8b 52 04             	mov    0x4(%edx),%edx
  8028db:	89 50 04             	mov    %edx,0x4(%eax)
  8028de:	eb 0b                	jmp    8028eb <alloc_block_BF+0x176>
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 40 04             	mov    0x4(%eax),%eax
  8028e6:	a3 30 50 80 00       	mov    %eax,0x805030
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 40 04             	mov    0x4(%eax),%eax
  8028f1:	85 c0                	test   %eax,%eax
  8028f3:	74 0f                	je     802904 <alloc_block_BF+0x18f>
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 40 04             	mov    0x4(%eax),%eax
  8028fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fe:	8b 12                	mov    (%edx),%edx
  802900:	89 10                	mov    %edx,(%eax)
  802902:	eb 0a                	jmp    80290e <alloc_block_BF+0x199>
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 00                	mov    (%eax),%eax
  802909:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802921:	a1 38 50 80 00       	mov    0x805038,%eax
  802926:	48                   	dec    %eax
  802927:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80292c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80292f:	e9 24 04 00 00       	jmp    802d58 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802934:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802937:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80293a:	76 13                	jbe    80294f <alloc_block_BF+0x1da>
					{
						internal = 1;
  80293c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802943:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802946:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802949:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80294c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80294f:	a1 34 50 80 00       	mov    0x805034,%eax
  802954:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802957:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295b:	74 07                	je     802964 <alloc_block_BF+0x1ef>
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 00                	mov    (%eax),%eax
  802962:	eb 05                	jmp    802969 <alloc_block_BF+0x1f4>
  802964:	b8 00 00 00 00       	mov    $0x0,%eax
  802969:	a3 34 50 80 00       	mov    %eax,0x805034
  80296e:	a1 34 50 80 00       	mov    0x805034,%eax
  802973:	85 c0                	test   %eax,%eax
  802975:	0f 85 bf fe ff ff    	jne    80283a <alloc_block_BF+0xc5>
  80297b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297f:	0f 85 b5 fe ff ff    	jne    80283a <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802985:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802989:	0f 84 26 02 00 00    	je     802bb5 <alloc_block_BF+0x440>
  80298f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802993:	0f 85 1c 02 00 00    	jne    802bb5 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802999:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299c:	2b 45 08             	sub    0x8(%ebp),%eax
  80299f:	83 e8 08             	sub    $0x8,%eax
  8029a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	8d 50 08             	lea    0x8(%eax),%edx
  8029ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ae:	01 d0                	add    %edx,%eax
  8029b0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	83 c0 08             	add    $0x8,%eax
  8029b9:	83 ec 04             	sub    $0x4,%esp
  8029bc:	6a 01                	push   $0x1
  8029be:	50                   	push   %eax
  8029bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8029c2:	e8 c3 f8 ff ff       	call   80228a <set_block_data>
  8029c7:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cd:	8b 40 04             	mov    0x4(%eax),%eax
  8029d0:	85 c0                	test   %eax,%eax
  8029d2:	75 68                	jne    802a3c <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029d4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029d8:	75 17                	jne    8029f1 <alloc_block_BF+0x27c>
  8029da:	83 ec 04             	sub    $0x4,%esp
  8029dd:	68 e0 44 80 00       	push   $0x8044e0
  8029e2:	68 45 01 00 00       	push   $0x145
  8029e7:	68 c5 44 80 00       	push   $0x8044c5
  8029ec:	e8 00 da ff ff       	call   8003f1 <_panic>
  8029f1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8029f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029fa:	89 10                	mov    %edx,(%eax)
  8029fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ff:	8b 00                	mov    (%eax),%eax
  802a01:	85 c0                	test   %eax,%eax
  802a03:	74 0d                	je     802a12 <alloc_block_BF+0x29d>
  802a05:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a0a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a0d:	89 50 04             	mov    %edx,0x4(%eax)
  802a10:	eb 08                	jmp    802a1a <alloc_block_BF+0x2a5>
  802a12:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a15:	a3 30 50 80 00       	mov    %eax,0x805030
  802a1a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a1d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a22:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2c:	a1 38 50 80 00       	mov    0x805038,%eax
  802a31:	40                   	inc    %eax
  802a32:	a3 38 50 80 00       	mov    %eax,0x805038
  802a37:	e9 dc 00 00 00       	jmp    802b18 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3f:	8b 00                	mov    (%eax),%eax
  802a41:	85 c0                	test   %eax,%eax
  802a43:	75 65                	jne    802aaa <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a45:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a49:	75 17                	jne    802a62 <alloc_block_BF+0x2ed>
  802a4b:	83 ec 04             	sub    $0x4,%esp
  802a4e:	68 14 45 80 00       	push   $0x804514
  802a53:	68 4a 01 00 00       	push   $0x14a
  802a58:	68 c5 44 80 00       	push   $0x8044c5
  802a5d:	e8 8f d9 ff ff       	call   8003f1 <_panic>
  802a62:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a68:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a6b:	89 50 04             	mov    %edx,0x4(%eax)
  802a6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a71:	8b 40 04             	mov    0x4(%eax),%eax
  802a74:	85 c0                	test   %eax,%eax
  802a76:	74 0c                	je     802a84 <alloc_block_BF+0x30f>
  802a78:	a1 30 50 80 00       	mov    0x805030,%eax
  802a7d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a80:	89 10                	mov    %edx,(%eax)
  802a82:	eb 08                	jmp    802a8c <alloc_block_BF+0x317>
  802a84:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a87:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a8f:	a3 30 50 80 00       	mov    %eax,0x805030
  802a94:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a9d:	a1 38 50 80 00       	mov    0x805038,%eax
  802aa2:	40                   	inc    %eax
  802aa3:	a3 38 50 80 00       	mov    %eax,0x805038
  802aa8:	eb 6e                	jmp    802b18 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802aaa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aae:	74 06                	je     802ab6 <alloc_block_BF+0x341>
  802ab0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ab4:	75 17                	jne    802acd <alloc_block_BF+0x358>
  802ab6:	83 ec 04             	sub    $0x4,%esp
  802ab9:	68 38 45 80 00       	push   $0x804538
  802abe:	68 4f 01 00 00       	push   $0x14f
  802ac3:	68 c5 44 80 00       	push   $0x8044c5
  802ac8:	e8 24 d9 ff ff       	call   8003f1 <_panic>
  802acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad0:	8b 10                	mov    (%eax),%edx
  802ad2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad5:	89 10                	mov    %edx,(%eax)
  802ad7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ada:	8b 00                	mov    (%eax),%eax
  802adc:	85 c0                	test   %eax,%eax
  802ade:	74 0b                	je     802aeb <alloc_block_BF+0x376>
  802ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae3:	8b 00                	mov    (%eax),%eax
  802ae5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ae8:	89 50 04             	mov    %edx,0x4(%eax)
  802aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aee:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802af1:	89 10                	mov    %edx,(%eax)
  802af3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af9:	89 50 04             	mov    %edx,0x4(%eax)
  802afc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aff:	8b 00                	mov    (%eax),%eax
  802b01:	85 c0                	test   %eax,%eax
  802b03:	75 08                	jne    802b0d <alloc_block_BF+0x398>
  802b05:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b08:	a3 30 50 80 00       	mov    %eax,0x805030
  802b0d:	a1 38 50 80 00       	mov    0x805038,%eax
  802b12:	40                   	inc    %eax
  802b13:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b1c:	75 17                	jne    802b35 <alloc_block_BF+0x3c0>
  802b1e:	83 ec 04             	sub    $0x4,%esp
  802b21:	68 a7 44 80 00       	push   $0x8044a7
  802b26:	68 51 01 00 00       	push   $0x151
  802b2b:	68 c5 44 80 00       	push   $0x8044c5
  802b30:	e8 bc d8 ff ff       	call   8003f1 <_panic>
  802b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	74 10                	je     802b4e <alloc_block_BF+0x3d9>
  802b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b46:	8b 52 04             	mov    0x4(%edx),%edx
  802b49:	89 50 04             	mov    %edx,0x4(%eax)
  802b4c:	eb 0b                	jmp    802b59 <alloc_block_BF+0x3e4>
  802b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b51:	8b 40 04             	mov    0x4(%eax),%eax
  802b54:	a3 30 50 80 00       	mov    %eax,0x805030
  802b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5c:	8b 40 04             	mov    0x4(%eax),%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	74 0f                	je     802b72 <alloc_block_BF+0x3fd>
  802b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b66:	8b 40 04             	mov    0x4(%eax),%eax
  802b69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b6c:	8b 12                	mov    (%edx),%edx
  802b6e:	89 10                	mov    %edx,(%eax)
  802b70:	eb 0a                	jmp    802b7c <alloc_block_BF+0x407>
  802b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8f:	a1 38 50 80 00       	mov    0x805038,%eax
  802b94:	48                   	dec    %eax
  802b95:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b9a:	83 ec 04             	sub    $0x4,%esp
  802b9d:	6a 00                	push   $0x0
  802b9f:	ff 75 d0             	pushl  -0x30(%ebp)
  802ba2:	ff 75 cc             	pushl  -0x34(%ebp)
  802ba5:	e8 e0 f6 ff ff       	call   80228a <set_block_data>
  802baa:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb0:	e9 a3 01 00 00       	jmp    802d58 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802bb5:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bb9:	0f 85 9d 00 00 00    	jne    802c5c <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802bbf:	83 ec 04             	sub    $0x4,%esp
  802bc2:	6a 01                	push   $0x1
  802bc4:	ff 75 ec             	pushl  -0x14(%ebp)
  802bc7:	ff 75 f0             	pushl  -0x10(%ebp)
  802bca:	e8 bb f6 ff ff       	call   80228a <set_block_data>
  802bcf:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802bd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bd6:	75 17                	jne    802bef <alloc_block_BF+0x47a>
  802bd8:	83 ec 04             	sub    $0x4,%esp
  802bdb:	68 a7 44 80 00       	push   $0x8044a7
  802be0:	68 58 01 00 00       	push   $0x158
  802be5:	68 c5 44 80 00       	push   $0x8044c5
  802bea:	e8 02 d8 ff ff       	call   8003f1 <_panic>
  802bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf2:	8b 00                	mov    (%eax),%eax
  802bf4:	85 c0                	test   %eax,%eax
  802bf6:	74 10                	je     802c08 <alloc_block_BF+0x493>
  802bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfb:	8b 00                	mov    (%eax),%eax
  802bfd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c00:	8b 52 04             	mov    0x4(%edx),%edx
  802c03:	89 50 04             	mov    %edx,0x4(%eax)
  802c06:	eb 0b                	jmp    802c13 <alloc_block_BF+0x49e>
  802c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0b:	8b 40 04             	mov    0x4(%eax),%eax
  802c0e:	a3 30 50 80 00       	mov    %eax,0x805030
  802c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c16:	8b 40 04             	mov    0x4(%eax),%eax
  802c19:	85 c0                	test   %eax,%eax
  802c1b:	74 0f                	je     802c2c <alloc_block_BF+0x4b7>
  802c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c20:	8b 40 04             	mov    0x4(%eax),%eax
  802c23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c26:	8b 12                	mov    (%edx),%edx
  802c28:	89 10                	mov    %edx,(%eax)
  802c2a:	eb 0a                	jmp    802c36 <alloc_block_BF+0x4c1>
  802c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2f:	8b 00                	mov    (%eax),%eax
  802c31:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c49:	a1 38 50 80 00       	mov    0x805038,%eax
  802c4e:	48                   	dec    %eax
  802c4f:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c57:	e9 fc 00 00 00       	jmp    802d58 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5f:	83 c0 08             	add    $0x8,%eax
  802c62:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c65:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c6c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c6f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c72:	01 d0                	add    %edx,%eax
  802c74:	48                   	dec    %eax
  802c75:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c78:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c7b:	ba 00 00 00 00       	mov    $0x0,%edx
  802c80:	f7 75 c4             	divl   -0x3c(%ebp)
  802c83:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c86:	29 d0                	sub    %edx,%eax
  802c88:	c1 e8 0c             	shr    $0xc,%eax
  802c8b:	83 ec 0c             	sub    $0xc,%esp
  802c8e:	50                   	push   %eax
  802c8f:	e8 b4 e7 ff ff       	call   801448 <sbrk>
  802c94:	83 c4 10             	add    $0x10,%esp
  802c97:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c9a:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c9e:	75 0a                	jne    802caa <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802ca0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca5:	e9 ae 00 00 00       	jmp    802d58 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802caa:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802cb1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cb4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cb7:	01 d0                	add    %edx,%eax
  802cb9:	48                   	dec    %eax
  802cba:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802cbd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cc0:	ba 00 00 00 00       	mov    $0x0,%edx
  802cc5:	f7 75 b8             	divl   -0x48(%ebp)
  802cc8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ccb:	29 d0                	sub    %edx,%eax
  802ccd:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cd0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cd3:	01 d0                	add    %edx,%eax
  802cd5:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802cda:	a1 40 50 80 00       	mov    0x805040,%eax
  802cdf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802ce5:	83 ec 0c             	sub    $0xc,%esp
  802ce8:	68 6c 45 80 00       	push   $0x80456c
  802ced:	e8 bc d9 ff ff       	call   8006ae <cprintf>
  802cf2:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802cf5:	83 ec 08             	sub    $0x8,%esp
  802cf8:	ff 75 bc             	pushl  -0x44(%ebp)
  802cfb:	68 71 45 80 00       	push   $0x804571
  802d00:	e8 a9 d9 ff ff       	call   8006ae <cprintf>
  802d05:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d08:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d0f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d12:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d15:	01 d0                	add    %edx,%eax
  802d17:	48                   	dec    %eax
  802d18:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d1b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d1e:	ba 00 00 00 00       	mov    $0x0,%edx
  802d23:	f7 75 b0             	divl   -0x50(%ebp)
  802d26:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d29:	29 d0                	sub    %edx,%eax
  802d2b:	83 ec 04             	sub    $0x4,%esp
  802d2e:	6a 01                	push   $0x1
  802d30:	50                   	push   %eax
  802d31:	ff 75 bc             	pushl  -0x44(%ebp)
  802d34:	e8 51 f5 ff ff       	call   80228a <set_block_data>
  802d39:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d3c:	83 ec 0c             	sub    $0xc,%esp
  802d3f:	ff 75 bc             	pushl  -0x44(%ebp)
  802d42:	e8 36 04 00 00       	call   80317d <free_block>
  802d47:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d4a:	83 ec 0c             	sub    $0xc,%esp
  802d4d:	ff 75 08             	pushl  0x8(%ebp)
  802d50:	e8 20 fa ff ff       	call   802775 <alloc_block_BF>
  802d55:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d58:	c9                   	leave  
  802d59:	c3                   	ret    

00802d5a <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d5a:	55                   	push   %ebp
  802d5b:	89 e5                	mov    %esp,%ebp
  802d5d:	53                   	push   %ebx
  802d5e:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d68:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d73:	74 1e                	je     802d93 <merging+0x39>
  802d75:	ff 75 08             	pushl  0x8(%ebp)
  802d78:	e8 bc f1 ff ff       	call   801f39 <get_block_size>
  802d7d:	83 c4 04             	add    $0x4,%esp
  802d80:	89 c2                	mov    %eax,%edx
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	01 d0                	add    %edx,%eax
  802d87:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d8a:	75 07                	jne    802d93 <merging+0x39>
		prev_is_free = 1;
  802d8c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d97:	74 1e                	je     802db7 <merging+0x5d>
  802d99:	ff 75 10             	pushl  0x10(%ebp)
  802d9c:	e8 98 f1 ff ff       	call   801f39 <get_block_size>
  802da1:	83 c4 04             	add    $0x4,%esp
  802da4:	89 c2                	mov    %eax,%edx
  802da6:	8b 45 10             	mov    0x10(%ebp),%eax
  802da9:	01 d0                	add    %edx,%eax
  802dab:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802dae:	75 07                	jne    802db7 <merging+0x5d>
		next_is_free = 1;
  802db0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802db7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dbb:	0f 84 cc 00 00 00    	je     802e8d <merging+0x133>
  802dc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc5:	0f 84 c2 00 00 00    	je     802e8d <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802dcb:	ff 75 08             	pushl  0x8(%ebp)
  802dce:	e8 66 f1 ff ff       	call   801f39 <get_block_size>
  802dd3:	83 c4 04             	add    $0x4,%esp
  802dd6:	89 c3                	mov    %eax,%ebx
  802dd8:	ff 75 10             	pushl  0x10(%ebp)
  802ddb:	e8 59 f1 ff ff       	call   801f39 <get_block_size>
  802de0:	83 c4 04             	add    $0x4,%esp
  802de3:	01 c3                	add    %eax,%ebx
  802de5:	ff 75 0c             	pushl  0xc(%ebp)
  802de8:	e8 4c f1 ff ff       	call   801f39 <get_block_size>
  802ded:	83 c4 04             	add    $0x4,%esp
  802df0:	01 d8                	add    %ebx,%eax
  802df2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802df5:	6a 00                	push   $0x0
  802df7:	ff 75 ec             	pushl  -0x14(%ebp)
  802dfa:	ff 75 08             	pushl  0x8(%ebp)
  802dfd:	e8 88 f4 ff ff       	call   80228a <set_block_data>
  802e02:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e09:	75 17                	jne    802e22 <merging+0xc8>
  802e0b:	83 ec 04             	sub    $0x4,%esp
  802e0e:	68 a7 44 80 00       	push   $0x8044a7
  802e13:	68 7d 01 00 00       	push   $0x17d
  802e18:	68 c5 44 80 00       	push   $0x8044c5
  802e1d:	e8 cf d5 ff ff       	call   8003f1 <_panic>
  802e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e25:	8b 00                	mov    (%eax),%eax
  802e27:	85 c0                	test   %eax,%eax
  802e29:	74 10                	je     802e3b <merging+0xe1>
  802e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2e:	8b 00                	mov    (%eax),%eax
  802e30:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e33:	8b 52 04             	mov    0x4(%edx),%edx
  802e36:	89 50 04             	mov    %edx,0x4(%eax)
  802e39:	eb 0b                	jmp    802e46 <merging+0xec>
  802e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3e:	8b 40 04             	mov    0x4(%eax),%eax
  802e41:	a3 30 50 80 00       	mov    %eax,0x805030
  802e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e49:	8b 40 04             	mov    0x4(%eax),%eax
  802e4c:	85 c0                	test   %eax,%eax
  802e4e:	74 0f                	je     802e5f <merging+0x105>
  802e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e53:	8b 40 04             	mov    0x4(%eax),%eax
  802e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e59:	8b 12                	mov    (%edx),%edx
  802e5b:	89 10                	mov    %edx,(%eax)
  802e5d:	eb 0a                	jmp    802e69 <merging+0x10f>
  802e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e62:	8b 00                	mov    (%eax),%eax
  802e64:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7c:	a1 38 50 80 00       	mov    0x805038,%eax
  802e81:	48                   	dec    %eax
  802e82:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e87:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e88:	e9 ea 02 00 00       	jmp    803177 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e91:	74 3b                	je     802ece <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e93:	83 ec 0c             	sub    $0xc,%esp
  802e96:	ff 75 08             	pushl  0x8(%ebp)
  802e99:	e8 9b f0 ff ff       	call   801f39 <get_block_size>
  802e9e:	83 c4 10             	add    $0x10,%esp
  802ea1:	89 c3                	mov    %eax,%ebx
  802ea3:	83 ec 0c             	sub    $0xc,%esp
  802ea6:	ff 75 10             	pushl  0x10(%ebp)
  802ea9:	e8 8b f0 ff ff       	call   801f39 <get_block_size>
  802eae:	83 c4 10             	add    $0x10,%esp
  802eb1:	01 d8                	add    %ebx,%eax
  802eb3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802eb6:	83 ec 04             	sub    $0x4,%esp
  802eb9:	6a 00                	push   $0x0
  802ebb:	ff 75 e8             	pushl  -0x18(%ebp)
  802ebe:	ff 75 08             	pushl  0x8(%ebp)
  802ec1:	e8 c4 f3 ff ff       	call   80228a <set_block_data>
  802ec6:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ec9:	e9 a9 02 00 00       	jmp    803177 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802ece:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ed2:	0f 84 2d 01 00 00    	je     803005 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ed8:	83 ec 0c             	sub    $0xc,%esp
  802edb:	ff 75 10             	pushl  0x10(%ebp)
  802ede:	e8 56 f0 ff ff       	call   801f39 <get_block_size>
  802ee3:	83 c4 10             	add    $0x10,%esp
  802ee6:	89 c3                	mov    %eax,%ebx
  802ee8:	83 ec 0c             	sub    $0xc,%esp
  802eeb:	ff 75 0c             	pushl  0xc(%ebp)
  802eee:	e8 46 f0 ff ff       	call   801f39 <get_block_size>
  802ef3:	83 c4 10             	add    $0x10,%esp
  802ef6:	01 d8                	add    %ebx,%eax
  802ef8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802efb:	83 ec 04             	sub    $0x4,%esp
  802efe:	6a 00                	push   $0x0
  802f00:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f03:	ff 75 10             	pushl  0x10(%ebp)
  802f06:	e8 7f f3 ff ff       	call   80228a <set_block_data>
  802f0b:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  802f11:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f18:	74 06                	je     802f20 <merging+0x1c6>
  802f1a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f1e:	75 17                	jne    802f37 <merging+0x1dd>
  802f20:	83 ec 04             	sub    $0x4,%esp
  802f23:	68 80 45 80 00       	push   $0x804580
  802f28:	68 8d 01 00 00       	push   $0x18d
  802f2d:	68 c5 44 80 00       	push   $0x8044c5
  802f32:	e8 ba d4 ff ff       	call   8003f1 <_panic>
  802f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3a:	8b 50 04             	mov    0x4(%eax),%edx
  802f3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f40:	89 50 04             	mov    %edx,0x4(%eax)
  802f43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f46:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f49:	89 10                	mov    %edx,(%eax)
  802f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4e:	8b 40 04             	mov    0x4(%eax),%eax
  802f51:	85 c0                	test   %eax,%eax
  802f53:	74 0d                	je     802f62 <merging+0x208>
  802f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f58:	8b 40 04             	mov    0x4(%eax),%eax
  802f5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f5e:	89 10                	mov    %edx,(%eax)
  802f60:	eb 08                	jmp    802f6a <merging+0x210>
  802f62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f65:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f70:	89 50 04             	mov    %edx,0x4(%eax)
  802f73:	a1 38 50 80 00       	mov    0x805038,%eax
  802f78:	40                   	inc    %eax
  802f79:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f82:	75 17                	jne    802f9b <merging+0x241>
  802f84:	83 ec 04             	sub    $0x4,%esp
  802f87:	68 a7 44 80 00       	push   $0x8044a7
  802f8c:	68 8e 01 00 00       	push   $0x18e
  802f91:	68 c5 44 80 00       	push   $0x8044c5
  802f96:	e8 56 d4 ff ff       	call   8003f1 <_panic>
  802f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9e:	8b 00                	mov    (%eax),%eax
  802fa0:	85 c0                	test   %eax,%eax
  802fa2:	74 10                	je     802fb4 <merging+0x25a>
  802fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa7:	8b 00                	mov    (%eax),%eax
  802fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fac:	8b 52 04             	mov    0x4(%edx),%edx
  802faf:	89 50 04             	mov    %edx,0x4(%eax)
  802fb2:	eb 0b                	jmp    802fbf <merging+0x265>
  802fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb7:	8b 40 04             	mov    0x4(%eax),%eax
  802fba:	a3 30 50 80 00       	mov    %eax,0x805030
  802fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc2:	8b 40 04             	mov    0x4(%eax),%eax
  802fc5:	85 c0                	test   %eax,%eax
  802fc7:	74 0f                	je     802fd8 <merging+0x27e>
  802fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcc:	8b 40 04             	mov    0x4(%eax),%eax
  802fcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd2:	8b 12                	mov    (%edx),%edx
  802fd4:	89 10                	mov    %edx,(%eax)
  802fd6:	eb 0a                	jmp    802fe2 <merging+0x288>
  802fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdb:	8b 00                	mov    (%eax),%eax
  802fdd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff5:	a1 38 50 80 00       	mov    0x805038,%eax
  802ffa:	48                   	dec    %eax
  802ffb:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803000:	e9 72 01 00 00       	jmp    803177 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803005:	8b 45 10             	mov    0x10(%ebp),%eax
  803008:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80300b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300f:	74 79                	je     80308a <merging+0x330>
  803011:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803015:	74 73                	je     80308a <merging+0x330>
  803017:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80301b:	74 06                	je     803023 <merging+0x2c9>
  80301d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803021:	75 17                	jne    80303a <merging+0x2e0>
  803023:	83 ec 04             	sub    $0x4,%esp
  803026:	68 38 45 80 00       	push   $0x804538
  80302b:	68 94 01 00 00       	push   $0x194
  803030:	68 c5 44 80 00       	push   $0x8044c5
  803035:	e8 b7 d3 ff ff       	call   8003f1 <_panic>
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	8b 10                	mov    (%eax),%edx
  80303f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803042:	89 10                	mov    %edx,(%eax)
  803044:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803047:	8b 00                	mov    (%eax),%eax
  803049:	85 c0                	test   %eax,%eax
  80304b:	74 0b                	je     803058 <merging+0x2fe>
  80304d:	8b 45 08             	mov    0x8(%ebp),%eax
  803050:	8b 00                	mov    (%eax),%eax
  803052:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803055:	89 50 04             	mov    %edx,0x4(%eax)
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80305e:	89 10                	mov    %edx,(%eax)
  803060:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803063:	8b 55 08             	mov    0x8(%ebp),%edx
  803066:	89 50 04             	mov    %edx,0x4(%eax)
  803069:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306c:	8b 00                	mov    (%eax),%eax
  80306e:	85 c0                	test   %eax,%eax
  803070:	75 08                	jne    80307a <merging+0x320>
  803072:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803075:	a3 30 50 80 00       	mov    %eax,0x805030
  80307a:	a1 38 50 80 00       	mov    0x805038,%eax
  80307f:	40                   	inc    %eax
  803080:	a3 38 50 80 00       	mov    %eax,0x805038
  803085:	e9 ce 00 00 00       	jmp    803158 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80308a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80308e:	74 65                	je     8030f5 <merging+0x39b>
  803090:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803094:	75 17                	jne    8030ad <merging+0x353>
  803096:	83 ec 04             	sub    $0x4,%esp
  803099:	68 14 45 80 00       	push   $0x804514
  80309e:	68 95 01 00 00       	push   $0x195
  8030a3:	68 c5 44 80 00       	push   $0x8044c5
  8030a8:	e8 44 d3 ff ff       	call   8003f1 <_panic>
  8030ad:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b6:	89 50 04             	mov    %edx,0x4(%eax)
  8030b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bc:	8b 40 04             	mov    0x4(%eax),%eax
  8030bf:	85 c0                	test   %eax,%eax
  8030c1:	74 0c                	je     8030cf <merging+0x375>
  8030c3:	a1 30 50 80 00       	mov    0x805030,%eax
  8030c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030cb:	89 10                	mov    %edx,(%eax)
  8030cd:	eb 08                	jmp    8030d7 <merging+0x37d>
  8030cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030da:	a3 30 50 80 00       	mov    %eax,0x805030
  8030df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e8:	a1 38 50 80 00       	mov    0x805038,%eax
  8030ed:	40                   	inc    %eax
  8030ee:	a3 38 50 80 00       	mov    %eax,0x805038
  8030f3:	eb 63                	jmp    803158 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8030f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030f9:	75 17                	jne    803112 <merging+0x3b8>
  8030fb:	83 ec 04             	sub    $0x4,%esp
  8030fe:	68 e0 44 80 00       	push   $0x8044e0
  803103:	68 98 01 00 00       	push   $0x198
  803108:	68 c5 44 80 00       	push   $0x8044c5
  80310d:	e8 df d2 ff ff       	call   8003f1 <_panic>
  803112:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803118:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311b:	89 10                	mov    %edx,(%eax)
  80311d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	85 c0                	test   %eax,%eax
  803124:	74 0d                	je     803133 <merging+0x3d9>
  803126:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80312b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80312e:	89 50 04             	mov    %edx,0x4(%eax)
  803131:	eb 08                	jmp    80313b <merging+0x3e1>
  803133:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803136:	a3 30 50 80 00       	mov    %eax,0x805030
  80313b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80313e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803143:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803146:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314d:	a1 38 50 80 00       	mov    0x805038,%eax
  803152:	40                   	inc    %eax
  803153:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803158:	83 ec 0c             	sub    $0xc,%esp
  80315b:	ff 75 10             	pushl  0x10(%ebp)
  80315e:	e8 d6 ed ff ff       	call   801f39 <get_block_size>
  803163:	83 c4 10             	add    $0x10,%esp
  803166:	83 ec 04             	sub    $0x4,%esp
  803169:	6a 00                	push   $0x0
  80316b:	50                   	push   %eax
  80316c:	ff 75 10             	pushl  0x10(%ebp)
  80316f:	e8 16 f1 ff ff       	call   80228a <set_block_data>
  803174:	83 c4 10             	add    $0x10,%esp
	}
}
  803177:	90                   	nop
  803178:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80317b:	c9                   	leave  
  80317c:	c3                   	ret    

0080317d <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80317d:	55                   	push   %ebp
  80317e:	89 e5                	mov    %esp,%ebp
  803180:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803183:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803188:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80318b:	a1 30 50 80 00       	mov    0x805030,%eax
  803190:	3b 45 08             	cmp    0x8(%ebp),%eax
  803193:	73 1b                	jae    8031b0 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803195:	a1 30 50 80 00       	mov    0x805030,%eax
  80319a:	83 ec 04             	sub    $0x4,%esp
  80319d:	ff 75 08             	pushl  0x8(%ebp)
  8031a0:	6a 00                	push   $0x0
  8031a2:	50                   	push   %eax
  8031a3:	e8 b2 fb ff ff       	call   802d5a <merging>
  8031a8:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031ab:	e9 8b 00 00 00       	jmp    80323b <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031b0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031b8:	76 18                	jbe    8031d2 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031ba:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031bf:	83 ec 04             	sub    $0x4,%esp
  8031c2:	ff 75 08             	pushl  0x8(%ebp)
  8031c5:	50                   	push   %eax
  8031c6:	6a 00                	push   $0x0
  8031c8:	e8 8d fb ff ff       	call   802d5a <merging>
  8031cd:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031d0:	eb 69                	jmp    80323b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031d2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031da:	eb 39                	jmp    803215 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e2:	73 29                	jae    80320d <free_block+0x90>
  8031e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e7:	8b 00                	mov    (%eax),%eax
  8031e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ec:	76 1f                	jbe    80320d <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f1:	8b 00                	mov    (%eax),%eax
  8031f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8031f6:	83 ec 04             	sub    $0x4,%esp
  8031f9:	ff 75 08             	pushl  0x8(%ebp)
  8031fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8031ff:	ff 75 f4             	pushl  -0xc(%ebp)
  803202:	e8 53 fb ff ff       	call   802d5a <merging>
  803207:	83 c4 10             	add    $0x10,%esp
			break;
  80320a:	90                   	nop
		}
	}
}
  80320b:	eb 2e                	jmp    80323b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80320d:	a1 34 50 80 00       	mov    0x805034,%eax
  803212:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803215:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803219:	74 07                	je     803222 <free_block+0xa5>
  80321b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321e:	8b 00                	mov    (%eax),%eax
  803220:	eb 05                	jmp    803227 <free_block+0xaa>
  803222:	b8 00 00 00 00       	mov    $0x0,%eax
  803227:	a3 34 50 80 00       	mov    %eax,0x805034
  80322c:	a1 34 50 80 00       	mov    0x805034,%eax
  803231:	85 c0                	test   %eax,%eax
  803233:	75 a7                	jne    8031dc <free_block+0x5f>
  803235:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803239:	75 a1                	jne    8031dc <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80323b:	90                   	nop
  80323c:	c9                   	leave  
  80323d:	c3                   	ret    

0080323e <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80323e:	55                   	push   %ebp
  80323f:	89 e5                	mov    %esp,%ebp
  803241:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803244:	ff 75 08             	pushl  0x8(%ebp)
  803247:	e8 ed ec ff ff       	call   801f39 <get_block_size>
  80324c:	83 c4 04             	add    $0x4,%esp
  80324f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803252:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803259:	eb 17                	jmp    803272 <copy_data+0x34>
  80325b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80325e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803261:	01 c2                	add    %eax,%edx
  803263:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803266:	8b 45 08             	mov    0x8(%ebp),%eax
  803269:	01 c8                	add    %ecx,%eax
  80326b:	8a 00                	mov    (%eax),%al
  80326d:	88 02                	mov    %al,(%edx)
  80326f:	ff 45 fc             	incl   -0x4(%ebp)
  803272:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803275:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803278:	72 e1                	jb     80325b <copy_data+0x1d>
}
  80327a:	90                   	nop
  80327b:	c9                   	leave  
  80327c:	c3                   	ret    

0080327d <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80327d:	55                   	push   %ebp
  80327e:	89 e5                	mov    %esp,%ebp
  803280:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803283:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803287:	75 23                	jne    8032ac <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803289:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80328d:	74 13                	je     8032a2 <realloc_block_FF+0x25>
  80328f:	83 ec 0c             	sub    $0xc,%esp
  803292:	ff 75 0c             	pushl  0xc(%ebp)
  803295:	e8 1f f0 ff ff       	call   8022b9 <alloc_block_FF>
  80329a:	83 c4 10             	add    $0x10,%esp
  80329d:	e9 f4 06 00 00       	jmp    803996 <realloc_block_FF+0x719>
		return NULL;
  8032a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a7:	e9 ea 06 00 00       	jmp    803996 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032b0:	75 18                	jne    8032ca <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032b2:	83 ec 0c             	sub    $0xc,%esp
  8032b5:	ff 75 08             	pushl  0x8(%ebp)
  8032b8:	e8 c0 fe ff ff       	call   80317d <free_block>
  8032bd:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c5:	e9 cc 06 00 00       	jmp    803996 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8032ca:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032ce:	77 07                	ja     8032d7 <realloc_block_FF+0x5a>
  8032d0:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032da:	83 e0 01             	and    $0x1,%eax
  8032dd:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e3:	83 c0 08             	add    $0x8,%eax
  8032e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032e9:	83 ec 0c             	sub    $0xc,%esp
  8032ec:	ff 75 08             	pushl  0x8(%ebp)
  8032ef:	e8 45 ec ff ff       	call   801f39 <get_block_size>
  8032f4:	83 c4 10             	add    $0x10,%esp
  8032f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fd:	83 e8 08             	sub    $0x8,%eax
  803300:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	83 e8 04             	sub    $0x4,%eax
  803309:	8b 00                	mov    (%eax),%eax
  80330b:	83 e0 fe             	and    $0xfffffffe,%eax
  80330e:	89 c2                	mov    %eax,%edx
  803310:	8b 45 08             	mov    0x8(%ebp),%eax
  803313:	01 d0                	add    %edx,%eax
  803315:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803318:	83 ec 0c             	sub    $0xc,%esp
  80331b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80331e:	e8 16 ec ff ff       	call   801f39 <get_block_size>
  803323:	83 c4 10             	add    $0x10,%esp
  803326:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803329:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80332c:	83 e8 08             	sub    $0x8,%eax
  80332f:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803332:	8b 45 0c             	mov    0xc(%ebp),%eax
  803335:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803338:	75 08                	jne    803342 <realloc_block_FF+0xc5>
	{
		 return va;
  80333a:	8b 45 08             	mov    0x8(%ebp),%eax
  80333d:	e9 54 06 00 00       	jmp    803996 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803342:	8b 45 0c             	mov    0xc(%ebp),%eax
  803345:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803348:	0f 83 e5 03 00 00    	jae    803733 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80334e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803351:	2b 45 0c             	sub    0xc(%ebp),%eax
  803354:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803357:	83 ec 0c             	sub    $0xc,%esp
  80335a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80335d:	e8 f0 eb ff ff       	call   801f52 <is_free_block>
  803362:	83 c4 10             	add    $0x10,%esp
  803365:	84 c0                	test   %al,%al
  803367:	0f 84 3b 01 00 00    	je     8034a8 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80336d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803370:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803373:	01 d0                	add    %edx,%eax
  803375:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803378:	83 ec 04             	sub    $0x4,%esp
  80337b:	6a 01                	push   $0x1
  80337d:	ff 75 f0             	pushl  -0x10(%ebp)
  803380:	ff 75 08             	pushl  0x8(%ebp)
  803383:	e8 02 ef ff ff       	call   80228a <set_block_data>
  803388:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80338b:	8b 45 08             	mov    0x8(%ebp),%eax
  80338e:	83 e8 04             	sub    $0x4,%eax
  803391:	8b 00                	mov    (%eax),%eax
  803393:	83 e0 fe             	and    $0xfffffffe,%eax
  803396:	89 c2                	mov    %eax,%edx
  803398:	8b 45 08             	mov    0x8(%ebp),%eax
  80339b:	01 d0                	add    %edx,%eax
  80339d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033a0:	83 ec 04             	sub    $0x4,%esp
  8033a3:	6a 00                	push   $0x0
  8033a5:	ff 75 cc             	pushl  -0x34(%ebp)
  8033a8:	ff 75 c8             	pushl  -0x38(%ebp)
  8033ab:	e8 da ee ff ff       	call   80228a <set_block_data>
  8033b0:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033b7:	74 06                	je     8033bf <realloc_block_FF+0x142>
  8033b9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033bd:	75 17                	jne    8033d6 <realloc_block_FF+0x159>
  8033bf:	83 ec 04             	sub    $0x4,%esp
  8033c2:	68 38 45 80 00       	push   $0x804538
  8033c7:	68 f6 01 00 00       	push   $0x1f6
  8033cc:	68 c5 44 80 00       	push   $0x8044c5
  8033d1:	e8 1b d0 ff ff       	call   8003f1 <_panic>
  8033d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d9:	8b 10                	mov    (%eax),%edx
  8033db:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033de:	89 10                	mov    %edx,(%eax)
  8033e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033e3:	8b 00                	mov    (%eax),%eax
  8033e5:	85 c0                	test   %eax,%eax
  8033e7:	74 0b                	je     8033f4 <realloc_block_FF+0x177>
  8033e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ec:	8b 00                	mov    (%eax),%eax
  8033ee:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033f1:	89 50 04             	mov    %edx,0x4(%eax)
  8033f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033fa:	89 10                	mov    %edx,(%eax)
  8033fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803402:	89 50 04             	mov    %edx,0x4(%eax)
  803405:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803408:	8b 00                	mov    (%eax),%eax
  80340a:	85 c0                	test   %eax,%eax
  80340c:	75 08                	jne    803416 <realloc_block_FF+0x199>
  80340e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803411:	a3 30 50 80 00       	mov    %eax,0x805030
  803416:	a1 38 50 80 00       	mov    0x805038,%eax
  80341b:	40                   	inc    %eax
  80341c:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803421:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803425:	75 17                	jne    80343e <realloc_block_FF+0x1c1>
  803427:	83 ec 04             	sub    $0x4,%esp
  80342a:	68 a7 44 80 00       	push   $0x8044a7
  80342f:	68 f7 01 00 00       	push   $0x1f7
  803434:	68 c5 44 80 00       	push   $0x8044c5
  803439:	e8 b3 cf ff ff       	call   8003f1 <_panic>
  80343e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803441:	8b 00                	mov    (%eax),%eax
  803443:	85 c0                	test   %eax,%eax
  803445:	74 10                	je     803457 <realloc_block_FF+0x1da>
  803447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80344a:	8b 00                	mov    (%eax),%eax
  80344c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80344f:	8b 52 04             	mov    0x4(%edx),%edx
  803452:	89 50 04             	mov    %edx,0x4(%eax)
  803455:	eb 0b                	jmp    803462 <realloc_block_FF+0x1e5>
  803457:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345a:	8b 40 04             	mov    0x4(%eax),%eax
  80345d:	a3 30 50 80 00       	mov    %eax,0x805030
  803462:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803465:	8b 40 04             	mov    0x4(%eax),%eax
  803468:	85 c0                	test   %eax,%eax
  80346a:	74 0f                	je     80347b <realloc_block_FF+0x1fe>
  80346c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346f:	8b 40 04             	mov    0x4(%eax),%eax
  803472:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803475:	8b 12                	mov    (%edx),%edx
  803477:	89 10                	mov    %edx,(%eax)
  803479:	eb 0a                	jmp    803485 <realloc_block_FF+0x208>
  80347b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347e:	8b 00                	mov    (%eax),%eax
  803480:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803485:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803488:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80348e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803491:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803498:	a1 38 50 80 00       	mov    0x805038,%eax
  80349d:	48                   	dec    %eax
  80349e:	a3 38 50 80 00       	mov    %eax,0x805038
  8034a3:	e9 83 02 00 00       	jmp    80372b <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034a8:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034ac:	0f 86 69 02 00 00    	jbe    80371b <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034b2:	83 ec 04             	sub    $0x4,%esp
  8034b5:	6a 01                	push   $0x1
  8034b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8034ba:	ff 75 08             	pushl  0x8(%ebp)
  8034bd:	e8 c8 ed ff ff       	call   80228a <set_block_data>
  8034c2:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c8:	83 e8 04             	sub    $0x4,%eax
  8034cb:	8b 00                	mov    (%eax),%eax
  8034cd:	83 e0 fe             	and    $0xfffffffe,%eax
  8034d0:	89 c2                	mov    %eax,%edx
  8034d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d5:	01 d0                	add    %edx,%eax
  8034d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034da:	a1 38 50 80 00       	mov    0x805038,%eax
  8034df:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034e2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034e6:	75 68                	jne    803550 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034e8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034ec:	75 17                	jne    803505 <realloc_block_FF+0x288>
  8034ee:	83 ec 04             	sub    $0x4,%esp
  8034f1:	68 e0 44 80 00       	push   $0x8044e0
  8034f6:	68 06 02 00 00       	push   $0x206
  8034fb:	68 c5 44 80 00       	push   $0x8044c5
  803500:	e8 ec ce ff ff       	call   8003f1 <_panic>
  803505:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80350b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80350e:	89 10                	mov    %edx,(%eax)
  803510:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803513:	8b 00                	mov    (%eax),%eax
  803515:	85 c0                	test   %eax,%eax
  803517:	74 0d                	je     803526 <realloc_block_FF+0x2a9>
  803519:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80351e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803521:	89 50 04             	mov    %edx,0x4(%eax)
  803524:	eb 08                	jmp    80352e <realloc_block_FF+0x2b1>
  803526:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803529:	a3 30 50 80 00       	mov    %eax,0x805030
  80352e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803531:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803536:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803539:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803540:	a1 38 50 80 00       	mov    0x805038,%eax
  803545:	40                   	inc    %eax
  803546:	a3 38 50 80 00       	mov    %eax,0x805038
  80354b:	e9 b0 01 00 00       	jmp    803700 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803550:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803555:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803558:	76 68                	jbe    8035c2 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80355a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80355e:	75 17                	jne    803577 <realloc_block_FF+0x2fa>
  803560:	83 ec 04             	sub    $0x4,%esp
  803563:	68 e0 44 80 00       	push   $0x8044e0
  803568:	68 0b 02 00 00       	push   $0x20b
  80356d:	68 c5 44 80 00       	push   $0x8044c5
  803572:	e8 7a ce ff ff       	call   8003f1 <_panic>
  803577:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80357d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803580:	89 10                	mov    %edx,(%eax)
  803582:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803585:	8b 00                	mov    (%eax),%eax
  803587:	85 c0                	test   %eax,%eax
  803589:	74 0d                	je     803598 <realloc_block_FF+0x31b>
  80358b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803590:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803593:	89 50 04             	mov    %edx,0x4(%eax)
  803596:	eb 08                	jmp    8035a0 <realloc_block_FF+0x323>
  803598:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359b:	a3 30 50 80 00       	mov    %eax,0x805030
  8035a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8035b7:	40                   	inc    %eax
  8035b8:	a3 38 50 80 00       	mov    %eax,0x805038
  8035bd:	e9 3e 01 00 00       	jmp    803700 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035c2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035c7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035ca:	73 68                	jae    803634 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035cc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035d0:	75 17                	jne    8035e9 <realloc_block_FF+0x36c>
  8035d2:	83 ec 04             	sub    $0x4,%esp
  8035d5:	68 14 45 80 00       	push   $0x804514
  8035da:	68 10 02 00 00       	push   $0x210
  8035df:	68 c5 44 80 00       	push   $0x8044c5
  8035e4:	e8 08 ce ff ff       	call   8003f1 <_panic>
  8035e9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f2:	89 50 04             	mov    %edx,0x4(%eax)
  8035f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f8:	8b 40 04             	mov    0x4(%eax),%eax
  8035fb:	85 c0                	test   %eax,%eax
  8035fd:	74 0c                	je     80360b <realloc_block_FF+0x38e>
  8035ff:	a1 30 50 80 00       	mov    0x805030,%eax
  803604:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803607:	89 10                	mov    %edx,(%eax)
  803609:	eb 08                	jmp    803613 <realloc_block_FF+0x396>
  80360b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80360e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803613:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803616:	a3 30 50 80 00       	mov    %eax,0x805030
  80361b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803624:	a1 38 50 80 00       	mov    0x805038,%eax
  803629:	40                   	inc    %eax
  80362a:	a3 38 50 80 00       	mov    %eax,0x805038
  80362f:	e9 cc 00 00 00       	jmp    803700 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803634:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80363b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803640:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803643:	e9 8a 00 00 00       	jmp    8036d2 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80364e:	73 7a                	jae    8036ca <realloc_block_FF+0x44d>
  803650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803653:	8b 00                	mov    (%eax),%eax
  803655:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803658:	73 70                	jae    8036ca <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80365a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80365e:	74 06                	je     803666 <realloc_block_FF+0x3e9>
  803660:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803664:	75 17                	jne    80367d <realloc_block_FF+0x400>
  803666:	83 ec 04             	sub    $0x4,%esp
  803669:	68 38 45 80 00       	push   $0x804538
  80366e:	68 1a 02 00 00       	push   $0x21a
  803673:	68 c5 44 80 00       	push   $0x8044c5
  803678:	e8 74 cd ff ff       	call   8003f1 <_panic>
  80367d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803680:	8b 10                	mov    (%eax),%edx
  803682:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803685:	89 10                	mov    %edx,(%eax)
  803687:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80368a:	8b 00                	mov    (%eax),%eax
  80368c:	85 c0                	test   %eax,%eax
  80368e:	74 0b                	je     80369b <realloc_block_FF+0x41e>
  803690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803693:	8b 00                	mov    (%eax),%eax
  803695:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803698:	89 50 04             	mov    %edx,0x4(%eax)
  80369b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036a1:	89 10                	mov    %edx,(%eax)
  8036a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036a9:	89 50 04             	mov    %edx,0x4(%eax)
  8036ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036af:	8b 00                	mov    (%eax),%eax
  8036b1:	85 c0                	test   %eax,%eax
  8036b3:	75 08                	jne    8036bd <realloc_block_FF+0x440>
  8036b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8036bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8036c2:	40                   	inc    %eax
  8036c3:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8036c8:	eb 36                	jmp    803700 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036ca:	a1 34 50 80 00       	mov    0x805034,%eax
  8036cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d6:	74 07                	je     8036df <realloc_block_FF+0x462>
  8036d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036db:	8b 00                	mov    (%eax),%eax
  8036dd:	eb 05                	jmp    8036e4 <realloc_block_FF+0x467>
  8036df:	b8 00 00 00 00       	mov    $0x0,%eax
  8036e4:	a3 34 50 80 00       	mov    %eax,0x805034
  8036e9:	a1 34 50 80 00       	mov    0x805034,%eax
  8036ee:	85 c0                	test   %eax,%eax
  8036f0:	0f 85 52 ff ff ff    	jne    803648 <realloc_block_FF+0x3cb>
  8036f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036fa:	0f 85 48 ff ff ff    	jne    803648 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803700:	83 ec 04             	sub    $0x4,%esp
  803703:	6a 00                	push   $0x0
  803705:	ff 75 d8             	pushl  -0x28(%ebp)
  803708:	ff 75 d4             	pushl  -0x2c(%ebp)
  80370b:	e8 7a eb ff ff       	call   80228a <set_block_data>
  803710:	83 c4 10             	add    $0x10,%esp
				return va;
  803713:	8b 45 08             	mov    0x8(%ebp),%eax
  803716:	e9 7b 02 00 00       	jmp    803996 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80371b:	83 ec 0c             	sub    $0xc,%esp
  80371e:	68 b5 45 80 00       	push   $0x8045b5
  803723:	e8 86 cf ff ff       	call   8006ae <cprintf>
  803728:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80372b:	8b 45 08             	mov    0x8(%ebp),%eax
  80372e:	e9 63 02 00 00       	jmp    803996 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803733:	8b 45 0c             	mov    0xc(%ebp),%eax
  803736:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803739:	0f 86 4d 02 00 00    	jbe    80398c <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80373f:	83 ec 0c             	sub    $0xc,%esp
  803742:	ff 75 e4             	pushl  -0x1c(%ebp)
  803745:	e8 08 e8 ff ff       	call   801f52 <is_free_block>
  80374a:	83 c4 10             	add    $0x10,%esp
  80374d:	84 c0                	test   %al,%al
  80374f:	0f 84 37 02 00 00    	je     80398c <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803755:	8b 45 0c             	mov    0xc(%ebp),%eax
  803758:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80375b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80375e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803761:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803764:	76 38                	jbe    80379e <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803766:	83 ec 0c             	sub    $0xc,%esp
  803769:	ff 75 08             	pushl  0x8(%ebp)
  80376c:	e8 0c fa ff ff       	call   80317d <free_block>
  803771:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803774:	83 ec 0c             	sub    $0xc,%esp
  803777:	ff 75 0c             	pushl  0xc(%ebp)
  80377a:	e8 3a eb ff ff       	call   8022b9 <alloc_block_FF>
  80377f:	83 c4 10             	add    $0x10,%esp
  803782:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803785:	83 ec 08             	sub    $0x8,%esp
  803788:	ff 75 c0             	pushl  -0x40(%ebp)
  80378b:	ff 75 08             	pushl  0x8(%ebp)
  80378e:	e8 ab fa ff ff       	call   80323e <copy_data>
  803793:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803796:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803799:	e9 f8 01 00 00       	jmp    803996 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80379e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037a1:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037a4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037a7:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037ab:	0f 87 a0 00 00 00    	ja     803851 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037b5:	75 17                	jne    8037ce <realloc_block_FF+0x551>
  8037b7:	83 ec 04             	sub    $0x4,%esp
  8037ba:	68 a7 44 80 00       	push   $0x8044a7
  8037bf:	68 38 02 00 00       	push   $0x238
  8037c4:	68 c5 44 80 00       	push   $0x8044c5
  8037c9:	e8 23 cc ff ff       	call   8003f1 <_panic>
  8037ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d1:	8b 00                	mov    (%eax),%eax
  8037d3:	85 c0                	test   %eax,%eax
  8037d5:	74 10                	je     8037e7 <realloc_block_FF+0x56a>
  8037d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037da:	8b 00                	mov    (%eax),%eax
  8037dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037df:	8b 52 04             	mov    0x4(%edx),%edx
  8037e2:	89 50 04             	mov    %edx,0x4(%eax)
  8037e5:	eb 0b                	jmp    8037f2 <realloc_block_FF+0x575>
  8037e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ea:	8b 40 04             	mov    0x4(%eax),%eax
  8037ed:	a3 30 50 80 00       	mov    %eax,0x805030
  8037f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f5:	8b 40 04             	mov    0x4(%eax),%eax
  8037f8:	85 c0                	test   %eax,%eax
  8037fa:	74 0f                	je     80380b <realloc_block_FF+0x58e>
  8037fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ff:	8b 40 04             	mov    0x4(%eax),%eax
  803802:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803805:	8b 12                	mov    (%edx),%edx
  803807:	89 10                	mov    %edx,(%eax)
  803809:	eb 0a                	jmp    803815 <realloc_block_FF+0x598>
  80380b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380e:	8b 00                	mov    (%eax),%eax
  803810:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803815:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803818:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80381e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803821:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803828:	a1 38 50 80 00       	mov    0x805038,%eax
  80382d:	48                   	dec    %eax
  80382e:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803833:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803836:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803839:	01 d0                	add    %edx,%eax
  80383b:	83 ec 04             	sub    $0x4,%esp
  80383e:	6a 01                	push   $0x1
  803840:	50                   	push   %eax
  803841:	ff 75 08             	pushl  0x8(%ebp)
  803844:	e8 41 ea ff ff       	call   80228a <set_block_data>
  803849:	83 c4 10             	add    $0x10,%esp
  80384c:	e9 36 01 00 00       	jmp    803987 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803851:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803854:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803857:	01 d0                	add    %edx,%eax
  803859:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80385c:	83 ec 04             	sub    $0x4,%esp
  80385f:	6a 01                	push   $0x1
  803861:	ff 75 f0             	pushl  -0x10(%ebp)
  803864:	ff 75 08             	pushl  0x8(%ebp)
  803867:	e8 1e ea ff ff       	call   80228a <set_block_data>
  80386c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80386f:	8b 45 08             	mov    0x8(%ebp),%eax
  803872:	83 e8 04             	sub    $0x4,%eax
  803875:	8b 00                	mov    (%eax),%eax
  803877:	83 e0 fe             	and    $0xfffffffe,%eax
  80387a:	89 c2                	mov    %eax,%edx
  80387c:	8b 45 08             	mov    0x8(%ebp),%eax
  80387f:	01 d0                	add    %edx,%eax
  803881:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803884:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803888:	74 06                	je     803890 <realloc_block_FF+0x613>
  80388a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80388e:	75 17                	jne    8038a7 <realloc_block_FF+0x62a>
  803890:	83 ec 04             	sub    $0x4,%esp
  803893:	68 38 45 80 00       	push   $0x804538
  803898:	68 44 02 00 00       	push   $0x244
  80389d:	68 c5 44 80 00       	push   $0x8044c5
  8038a2:	e8 4a cb ff ff       	call   8003f1 <_panic>
  8038a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038aa:	8b 10                	mov    (%eax),%edx
  8038ac:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038af:	89 10                	mov    %edx,(%eax)
  8038b1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038b4:	8b 00                	mov    (%eax),%eax
  8038b6:	85 c0                	test   %eax,%eax
  8038b8:	74 0b                	je     8038c5 <realloc_block_FF+0x648>
  8038ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038bd:	8b 00                	mov    (%eax),%eax
  8038bf:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038c2:	89 50 04             	mov    %edx,0x4(%eax)
  8038c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c8:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038cb:	89 10                	mov    %edx,(%eax)
  8038cd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038d3:	89 50 04             	mov    %edx,0x4(%eax)
  8038d6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038d9:	8b 00                	mov    (%eax),%eax
  8038db:	85 c0                	test   %eax,%eax
  8038dd:	75 08                	jne    8038e7 <realloc_block_FF+0x66a>
  8038df:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038e2:	a3 30 50 80 00       	mov    %eax,0x805030
  8038e7:	a1 38 50 80 00       	mov    0x805038,%eax
  8038ec:	40                   	inc    %eax
  8038ed:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038f6:	75 17                	jne    80390f <realloc_block_FF+0x692>
  8038f8:	83 ec 04             	sub    $0x4,%esp
  8038fb:	68 a7 44 80 00       	push   $0x8044a7
  803900:	68 45 02 00 00       	push   $0x245
  803905:	68 c5 44 80 00       	push   $0x8044c5
  80390a:	e8 e2 ca ff ff       	call   8003f1 <_panic>
  80390f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803912:	8b 00                	mov    (%eax),%eax
  803914:	85 c0                	test   %eax,%eax
  803916:	74 10                	je     803928 <realloc_block_FF+0x6ab>
  803918:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391b:	8b 00                	mov    (%eax),%eax
  80391d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803920:	8b 52 04             	mov    0x4(%edx),%edx
  803923:	89 50 04             	mov    %edx,0x4(%eax)
  803926:	eb 0b                	jmp    803933 <realloc_block_FF+0x6b6>
  803928:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392b:	8b 40 04             	mov    0x4(%eax),%eax
  80392e:	a3 30 50 80 00       	mov    %eax,0x805030
  803933:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803936:	8b 40 04             	mov    0x4(%eax),%eax
  803939:	85 c0                	test   %eax,%eax
  80393b:	74 0f                	je     80394c <realloc_block_FF+0x6cf>
  80393d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803940:	8b 40 04             	mov    0x4(%eax),%eax
  803943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803946:	8b 12                	mov    (%edx),%edx
  803948:	89 10                	mov    %edx,(%eax)
  80394a:	eb 0a                	jmp    803956 <realloc_block_FF+0x6d9>
  80394c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394f:	8b 00                	mov    (%eax),%eax
  803951:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803959:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80395f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803962:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803969:	a1 38 50 80 00       	mov    0x805038,%eax
  80396e:	48                   	dec    %eax
  80396f:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803974:	83 ec 04             	sub    $0x4,%esp
  803977:	6a 00                	push   $0x0
  803979:	ff 75 bc             	pushl  -0x44(%ebp)
  80397c:	ff 75 b8             	pushl  -0x48(%ebp)
  80397f:	e8 06 e9 ff ff       	call   80228a <set_block_data>
  803984:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803987:	8b 45 08             	mov    0x8(%ebp),%eax
  80398a:	eb 0a                	jmp    803996 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80398c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803993:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803996:	c9                   	leave  
  803997:	c3                   	ret    

00803998 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803998:	55                   	push   %ebp
  803999:	89 e5                	mov    %esp,%ebp
  80399b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80399e:	83 ec 04             	sub    $0x4,%esp
  8039a1:	68 bc 45 80 00       	push   $0x8045bc
  8039a6:	68 58 02 00 00       	push   $0x258
  8039ab:	68 c5 44 80 00       	push   $0x8044c5
  8039b0:	e8 3c ca ff ff       	call   8003f1 <_panic>

008039b5 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039b5:	55                   	push   %ebp
  8039b6:	89 e5                	mov    %esp,%ebp
  8039b8:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039bb:	83 ec 04             	sub    $0x4,%esp
  8039be:	68 e4 45 80 00       	push   $0x8045e4
  8039c3:	68 61 02 00 00       	push   $0x261
  8039c8:	68 c5 44 80 00       	push   $0x8044c5
  8039cd:	e8 1f ca ff ff       	call   8003f1 <_panic>
  8039d2:	66 90                	xchg   %ax,%ax

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
