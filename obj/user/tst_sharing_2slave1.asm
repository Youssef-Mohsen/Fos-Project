
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
  80003f:	a1 04 30 80 00       	mov    0x803004,%eax
  800044:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004a:	a1 04 30 80 00       	mov    0x803004,%eax
  80004f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800055:	39 c2                	cmp    %eax,%edx
  800057:	72 14                	jb     80006d <_main+0x35>
			panic("Please increase the WS size");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 00 1e 80 00       	push   $0x801e00
  800061:	6a 0d                	push   $0xd
  800063:	68 1c 1e 80 00       	push   $0x801e1c
  800068:	e8 7c 03 00 00       	call   8003e9 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006d:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)

	uint32 *x,*y,*z, *expectedVA;
	int freeFrames, diff, expected;
	int32 parentenvID = sys_getparentenvid();
  800074:	e8 f3 17 00 00       	call   80186c <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 56 15 00 00       	call   8015d7 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 04 16 00 00       	call   80168a <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 37 1e 80 00       	push   $0x801e37
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 2f 14 00 00       	call   8014c8 <sget>
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
  8000b6:	68 3c 1e 80 00       	push   $0x801e3c
  8000bb:	6a 21                	push   $0x21
  8000bd:	68 1c 1e 80 00       	push   $0x801e1c
  8000c2:	e8 22 03 00 00       	call   8003e9 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 b4 15 00 00       	call   80168a <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 9d 15 00 00       	call   80168a <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 b8 1e 80 00       	push   $0x801eb8
  8000fd:	6a 24                	push   $0x24
  8000ff:	68 1c 1e 80 00       	push   $0x801e1c
  800104:	e8 e0 02 00 00       	call   8003e9 <_panic>
	}
	sys_unlock_cons();
  800109:	e8 e3 14 00 00       	call   8015f1 <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 c4 14 00 00       	call   8015d7 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 72 15 00 00       	call   80168a <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = sget(parentenvID,"y");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 50 1f 80 00       	push   $0x801f50
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 9d 13 00 00       	call   8014c8 <sget>
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
  80014d:	68 3c 1e 80 00       	push   $0x801e3c
  800152:	6a 2f                	push   $0x2f
  800154:	68 1c 1e 80 00       	push   $0x801e1c
  800159:	e8 8b 02 00 00       	call   8003e9 <_panic>
		expected = 0 ;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 1d 15 00 00       	call   80168a <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 06 15 00 00       	call   80168a <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 b8 1e 80 00       	push   $0x801eb8
  800194:	6a 32                	push   $0x32
  800196:	68 1c 1e 80 00       	push   $0x801e1c
  80019b:	e8 49 02 00 00       	call   8003e9 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 4c 14 00 00       	call   8015f1 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 14             	cmp    $0x14,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 54 1f 80 00       	push   $0x801f54
  8001b7:	6a 37                	push   $0x37
  8001b9:	68 1c 1e 80 00       	push   $0x801e1c
  8001be:	e8 26 02 00 00       	call   8003e9 <_panic>

	//sys_lock_cons();
	sys_lock_cons();
  8001c3:	e8 0f 14 00 00       	call   8015d7 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  8001c8:	e8 bd 14 00 00       	call   80168a <sys_calculate_free_frames>
  8001cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	68 8b 1f 80 00       	push   $0x801f8b
  8001d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8001db:	e8 e8 12 00 00       	call   8014c8 <sget>
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
  800202:	68 3c 1e 80 00       	push   $0x801e3c
  800207:	6a 3f                	push   $0x3f
  800209:	68 1c 1e 80 00       	push   $0x801e1c
  80020e:	e8 d6 01 00 00       	call   8003e9 <_panic>
		expected = 0 ;
  800213:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80021a:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80021d:	e8 68 14 00 00       	call   80168a <sys_calculate_free_frames>
  800222:	29 c3                	sub    %eax,%ebx
  800224:	89 d8                	mov    %ebx,%eax
  800226:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800229:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022f:	74 24                	je     800255 <_main+0x21d>
  800231:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800234:	e8 51 14 00 00       	call   80168a <sys_calculate_free_frames>
  800239:	29 c3                	sub    %eax,%ebx
  80023b:	89 d8                	mov    %ebx,%eax
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	ff 75 e0             	pushl  -0x20(%ebp)
  800243:	50                   	push   %eax
  800244:	68 b8 1e 80 00       	push   $0x801eb8
  800249:	6a 42                	push   $0x42
  80024b:	68 1c 1e 80 00       	push   $0x801e1c
  800250:	e8 94 01 00 00       	call   8003e9 <_panic>
	}
	sys_unlock_cons();
  800255:	e8 97 13 00 00       	call   8015f1 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  80025a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80025d:	8b 00                	mov    (%eax),%eax
  80025f:	83 f8 0a             	cmp    $0xa,%eax
  800262:	74 14                	je     800278 <_main+0x240>
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	68 54 1f 80 00       	push   $0x801f54
  80026c:	6a 47                	push   $0x47
  80026e:	68 1c 1e 80 00       	push   $0x801e1c
  800273:	e8 71 01 00 00       	call   8003e9 <_panic>

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
  800296:	68 54 1f 80 00       	push   $0x801f54
  80029b:	6a 4a                	push   $0x4a
  80029d:	68 1c 1e 80 00       	push   $0x801e1c
  8002a2:	e8 42 01 00 00       	call   8003e9 <_panic>

	//To indicate that it's completed successfully
	inctst();
  8002a7:	e8 e5 16 00 00       	call   801991 <inctst>

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
  8002b8:	e8 96 15 00 00       	call   801853 <sys_getenvindex>
  8002bd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8002c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002c3:	89 d0                	mov    %edx,%eax
  8002c5:	c1 e0 02             	shl    $0x2,%eax
  8002c8:	01 d0                	add    %edx,%eax
  8002ca:	01 c0                	add    %eax,%eax
  8002cc:	01 d0                	add    %edx,%eax
  8002ce:	c1 e0 02             	shl    $0x2,%eax
  8002d1:	01 d0                	add    %edx,%eax
  8002d3:	01 c0                	add    %eax,%eax
  8002d5:	01 d0                	add    %edx,%eax
  8002d7:	c1 e0 04             	shl    $0x4,%eax
  8002da:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002df:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002e4:	a1 04 30 80 00       	mov    0x803004,%eax
  8002e9:	8a 40 20             	mov    0x20(%eax),%al
  8002ec:	84 c0                	test   %al,%al
  8002ee:	74 0d                	je     8002fd <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8002f0:	a1 04 30 80 00       	mov    0x803004,%eax
  8002f5:	83 c0 20             	add    $0x20,%eax
  8002f8:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800301:	7e 0a                	jle    80030d <libmain+0x5b>
		binaryname = argv[0];
  800303:	8b 45 0c             	mov    0xc(%ebp),%eax
  800306:	8b 00                	mov    (%eax),%eax
  800308:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80030d:	83 ec 08             	sub    $0x8,%esp
  800310:	ff 75 0c             	pushl  0xc(%ebp)
  800313:	ff 75 08             	pushl  0x8(%ebp)
  800316:	e8 1d fd ff ff       	call   800038 <_main>
  80031b:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80031e:	e8 b4 12 00 00       	call   8015d7 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800323:	83 ec 0c             	sub    $0xc,%esp
  800326:	68 a8 1f 80 00       	push   $0x801fa8
  80032b:	e8 76 03 00 00       	call   8006a6 <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800333:	a1 04 30 80 00       	mov    0x803004,%eax
  800338:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80033e:	a1 04 30 80 00       	mov    0x803004,%eax
  800343:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800349:	83 ec 04             	sub    $0x4,%esp
  80034c:	52                   	push   %edx
  80034d:	50                   	push   %eax
  80034e:	68 d0 1f 80 00       	push   $0x801fd0
  800353:	e8 4e 03 00 00       	call   8006a6 <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80035b:	a1 04 30 80 00       	mov    0x803004,%eax
  800360:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800366:	a1 04 30 80 00       	mov    0x803004,%eax
  80036b:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800371:	a1 04 30 80 00       	mov    0x803004,%eax
  800376:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80037c:	51                   	push   %ecx
  80037d:	52                   	push   %edx
  80037e:	50                   	push   %eax
  80037f:	68 f8 1f 80 00       	push   $0x801ff8
  800384:	e8 1d 03 00 00       	call   8006a6 <cprintf>
  800389:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80038c:	a1 04 30 80 00       	mov    0x803004,%eax
  800391:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800397:	83 ec 08             	sub    $0x8,%esp
  80039a:	50                   	push   %eax
  80039b:	68 50 20 80 00       	push   $0x802050
  8003a0:	e8 01 03 00 00       	call   8006a6 <cprintf>
  8003a5:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	68 a8 1f 80 00       	push   $0x801fa8
  8003b0:	e8 f1 02 00 00       	call   8006a6 <cprintf>
  8003b5:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003b8:	e8 34 12 00 00       	call   8015f1 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8003bd:	e8 19 00 00 00       	call   8003db <exit>
}
  8003c2:	90                   	nop
  8003c3:	c9                   	leave  
  8003c4:	c3                   	ret    

008003c5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003c5:	55                   	push   %ebp
  8003c6:	89 e5                	mov    %esp,%ebp
  8003c8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003cb:	83 ec 0c             	sub    $0xc,%esp
  8003ce:	6a 00                	push   $0x0
  8003d0:	e8 4a 14 00 00       	call   80181f <sys_destroy_env>
  8003d5:	83 c4 10             	add    $0x10,%esp
}
  8003d8:	90                   	nop
  8003d9:	c9                   	leave  
  8003da:	c3                   	ret    

008003db <exit>:

void
exit(void)
{
  8003db:	55                   	push   %ebp
  8003dc:	89 e5                	mov    %esp,%ebp
  8003de:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003e1:	e8 9f 14 00 00       	call   801885 <sys_exit_env>
}
  8003e6:	90                   	nop
  8003e7:	c9                   	leave  
  8003e8:	c3                   	ret    

008003e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003ef:	8d 45 10             	lea    0x10(%ebp),%eax
  8003f2:	83 c0 04             	add    $0x4,%eax
  8003f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003f8:	a1 24 30 80 00       	mov    0x803024,%eax
  8003fd:	85 c0                	test   %eax,%eax
  8003ff:	74 16                	je     800417 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800401:	a1 24 30 80 00       	mov    0x803024,%eax
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	50                   	push   %eax
  80040a:	68 64 20 80 00       	push   $0x802064
  80040f:	e8 92 02 00 00       	call   8006a6 <cprintf>
  800414:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800417:	a1 00 30 80 00       	mov    0x803000,%eax
  80041c:	ff 75 0c             	pushl  0xc(%ebp)
  80041f:	ff 75 08             	pushl  0x8(%ebp)
  800422:	50                   	push   %eax
  800423:	68 69 20 80 00       	push   $0x802069
  800428:	e8 79 02 00 00       	call   8006a6 <cprintf>
  80042d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800430:	8b 45 10             	mov    0x10(%ebp),%eax
  800433:	83 ec 08             	sub    $0x8,%esp
  800436:	ff 75 f4             	pushl  -0xc(%ebp)
  800439:	50                   	push   %eax
  80043a:	e8 fc 01 00 00       	call   80063b <vcprintf>
  80043f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	6a 00                	push   $0x0
  800447:	68 85 20 80 00       	push   $0x802085
  80044c:	e8 ea 01 00 00       	call   80063b <vcprintf>
  800451:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800454:	e8 82 ff ff ff       	call   8003db <exit>

	// should not return here
	while (1) ;
  800459:	eb fe                	jmp    800459 <_panic+0x70>

0080045b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80045b:	55                   	push   %ebp
  80045c:	89 e5                	mov    %esp,%ebp
  80045e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800461:	a1 04 30 80 00       	mov    0x803004,%eax
  800466:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80046c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046f:	39 c2                	cmp    %eax,%edx
  800471:	74 14                	je     800487 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800473:	83 ec 04             	sub    $0x4,%esp
  800476:	68 88 20 80 00       	push   $0x802088
  80047b:	6a 26                	push   $0x26
  80047d:	68 d4 20 80 00       	push   $0x8020d4
  800482:	e8 62 ff ff ff       	call   8003e9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800487:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80048e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800495:	e9 c5 00 00 00       	jmp    80055f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80049a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80049d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	01 d0                	add    %edx,%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	75 08                	jne    8004b7 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004af:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004b2:	e9 a5 00 00 00       	jmp    80055c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004be:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004c5:	eb 69                	jmp    800530 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004c7:	a1 04 30 80 00       	mov    0x803004,%eax
  8004cc:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8004d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004d5:	89 d0                	mov    %edx,%eax
  8004d7:	01 c0                	add    %eax,%eax
  8004d9:	01 d0                	add    %edx,%eax
  8004db:	c1 e0 03             	shl    $0x3,%eax
  8004de:	01 c8                	add    %ecx,%eax
  8004e0:	8a 40 04             	mov    0x4(%eax),%al
  8004e3:	84 c0                	test   %al,%al
  8004e5:	75 46                	jne    80052d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004e7:	a1 04 30 80 00       	mov    0x803004,%eax
  8004ec:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8004f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004f5:	89 d0                	mov    %edx,%eax
  8004f7:	01 c0                	add    %eax,%eax
  8004f9:	01 d0                	add    %edx,%eax
  8004fb:	c1 e0 03             	shl    $0x3,%eax
  8004fe:	01 c8                	add    %ecx,%eax
  800500:	8b 00                	mov    (%eax),%eax
  800502:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800505:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800508:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80050d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80050f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800512:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800519:	8b 45 08             	mov    0x8(%ebp),%eax
  80051c:	01 c8                	add    %ecx,%eax
  80051e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800520:	39 c2                	cmp    %eax,%edx
  800522:	75 09                	jne    80052d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800524:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80052b:	eb 15                	jmp    800542 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052d:	ff 45 e8             	incl   -0x18(%ebp)
  800530:	a1 04 30 80 00       	mov    0x803004,%eax
  800535:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80053b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	77 85                	ja     8004c7 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800542:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800546:	75 14                	jne    80055c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800548:	83 ec 04             	sub    $0x4,%esp
  80054b:	68 e0 20 80 00       	push   $0x8020e0
  800550:	6a 3a                	push   $0x3a
  800552:	68 d4 20 80 00       	push   $0x8020d4
  800557:	e8 8d fe ff ff       	call   8003e9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80055c:	ff 45 f0             	incl   -0x10(%ebp)
  80055f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800562:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800565:	0f 8c 2f ff ff ff    	jl     80049a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80056b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800572:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800579:	eb 26                	jmp    8005a1 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80057b:	a1 04 30 80 00       	mov    0x803004,%eax
  800580:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800586:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800589:	89 d0                	mov    %edx,%eax
  80058b:	01 c0                	add    %eax,%eax
  80058d:	01 d0                	add    %edx,%eax
  80058f:	c1 e0 03             	shl    $0x3,%eax
  800592:	01 c8                	add    %ecx,%eax
  800594:	8a 40 04             	mov    0x4(%eax),%al
  800597:	3c 01                	cmp    $0x1,%al
  800599:	75 03                	jne    80059e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80059b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80059e:	ff 45 e0             	incl   -0x20(%ebp)
  8005a1:	a1 04 30 80 00       	mov    0x803004,%eax
  8005a6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005af:	39 c2                	cmp    %eax,%edx
  8005b1:	77 c8                	ja     80057b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005b9:	74 14                	je     8005cf <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005bb:	83 ec 04             	sub    $0x4,%esp
  8005be:	68 34 21 80 00       	push   $0x802134
  8005c3:	6a 44                	push   $0x44
  8005c5:	68 d4 20 80 00       	push   $0x8020d4
  8005ca:	e8 1a fe ff ff       	call   8003e9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005cf:	90                   	nop
  8005d0:	c9                   	leave  
  8005d1:	c3                   	ret    

008005d2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005d2:	55                   	push   %ebp
  8005d3:	89 e5                	mov    %esp,%ebp
  8005d5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8005e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e3:	89 0a                	mov    %ecx,(%edx)
  8005e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8005e8:	88 d1                	mov    %dl,%cl
  8005ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ed:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f4:	8b 00                	mov    (%eax),%eax
  8005f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005fb:	75 2c                	jne    800629 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005fd:	a0 08 30 80 00       	mov    0x803008,%al
  800602:	0f b6 c0             	movzbl %al,%eax
  800605:	8b 55 0c             	mov    0xc(%ebp),%edx
  800608:	8b 12                	mov    (%edx),%edx
  80060a:	89 d1                	mov    %edx,%ecx
  80060c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060f:	83 c2 08             	add    $0x8,%edx
  800612:	83 ec 04             	sub    $0x4,%esp
  800615:	50                   	push   %eax
  800616:	51                   	push   %ecx
  800617:	52                   	push   %edx
  800618:	e8 78 0f 00 00       	call   801595 <sys_cputs>
  80061d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800620:	8b 45 0c             	mov    0xc(%ebp),%eax
  800623:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062c:	8b 40 04             	mov    0x4(%eax),%eax
  80062f:	8d 50 01             	lea    0x1(%eax),%edx
  800632:	8b 45 0c             	mov    0xc(%ebp),%eax
  800635:	89 50 04             	mov    %edx,0x4(%eax)
}
  800638:	90                   	nop
  800639:	c9                   	leave  
  80063a:	c3                   	ret    

0080063b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800644:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80064b:	00 00 00 
	b.cnt = 0;
  80064e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800655:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800658:	ff 75 0c             	pushl  0xc(%ebp)
  80065b:	ff 75 08             	pushl  0x8(%ebp)
  80065e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800664:	50                   	push   %eax
  800665:	68 d2 05 80 00       	push   $0x8005d2
  80066a:	e8 11 02 00 00       	call   800880 <vprintfmt>
  80066f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800672:	a0 08 30 80 00       	mov    0x803008,%al
  800677:	0f b6 c0             	movzbl %al,%eax
  80067a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800680:	83 ec 04             	sub    $0x4,%esp
  800683:	50                   	push   %eax
  800684:	52                   	push   %edx
  800685:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80068b:	83 c0 08             	add    $0x8,%eax
  80068e:	50                   	push   %eax
  80068f:	e8 01 0f 00 00       	call   801595 <sys_cputs>
  800694:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800697:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80069e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006a4:	c9                   	leave  
  8006a5:	c3                   	ret    

008006a6 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
  8006a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ac:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8006b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c2:	50                   	push   %eax
  8006c3:	e8 73 ff ff ff       	call   80063b <vcprintf>
  8006c8:	83 c4 10             	add    $0x10,%esp
  8006cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d1:	c9                   	leave  
  8006d2:	c3                   	ret    

008006d3 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
  8006d6:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006d9:	e8 f9 0e 00 00       	call   8015d7 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ed:	50                   	push   %eax
  8006ee:	e8 48 ff ff ff       	call   80063b <vcprintf>
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006f9:	e8 f3 0e 00 00       	call   8015f1 <sys_unlock_cons>
	return cnt;
  8006fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800701:	c9                   	leave  
  800702:	c3                   	ret    

00800703 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800703:	55                   	push   %ebp
  800704:	89 e5                	mov    %esp,%ebp
  800706:	53                   	push   %ebx
  800707:	83 ec 14             	sub    $0x14,%esp
  80070a:	8b 45 10             	mov    0x10(%ebp),%eax
  80070d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800716:	8b 45 18             	mov    0x18(%ebp),%eax
  800719:	ba 00 00 00 00       	mov    $0x0,%edx
  80071e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800721:	77 55                	ja     800778 <printnum+0x75>
  800723:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800726:	72 05                	jb     80072d <printnum+0x2a>
  800728:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80072b:	77 4b                	ja     800778 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80072d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800730:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800733:	8b 45 18             	mov    0x18(%ebp),%eax
  800736:	ba 00 00 00 00       	mov    $0x0,%edx
  80073b:	52                   	push   %edx
  80073c:	50                   	push   %eax
  80073d:	ff 75 f4             	pushl  -0xc(%ebp)
  800740:	ff 75 f0             	pushl  -0x10(%ebp)
  800743:	e8 4c 14 00 00       	call   801b94 <__udivdi3>
  800748:	83 c4 10             	add    $0x10,%esp
  80074b:	83 ec 04             	sub    $0x4,%esp
  80074e:	ff 75 20             	pushl  0x20(%ebp)
  800751:	53                   	push   %ebx
  800752:	ff 75 18             	pushl  0x18(%ebp)
  800755:	52                   	push   %edx
  800756:	50                   	push   %eax
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	ff 75 08             	pushl  0x8(%ebp)
  80075d:	e8 a1 ff ff ff       	call   800703 <printnum>
  800762:	83 c4 20             	add    $0x20,%esp
  800765:	eb 1a                	jmp    800781 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	ff 75 0c             	pushl  0xc(%ebp)
  80076d:	ff 75 20             	pushl  0x20(%ebp)
  800770:	8b 45 08             	mov    0x8(%ebp),%eax
  800773:	ff d0                	call   *%eax
  800775:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800778:	ff 4d 1c             	decl   0x1c(%ebp)
  80077b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80077f:	7f e6                	jg     800767 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800781:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800784:	bb 00 00 00 00       	mov    $0x0,%ebx
  800789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80078f:	53                   	push   %ebx
  800790:	51                   	push   %ecx
  800791:	52                   	push   %edx
  800792:	50                   	push   %eax
  800793:	e8 0c 15 00 00       	call   801ca4 <__umoddi3>
  800798:	83 c4 10             	add    $0x10,%esp
  80079b:	05 94 23 80 00       	add    $0x802394,%eax
  8007a0:	8a 00                	mov    (%eax),%al
  8007a2:	0f be c0             	movsbl %al,%eax
  8007a5:	83 ec 08             	sub    $0x8,%esp
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	50                   	push   %eax
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	ff d0                	call   *%eax
  8007b1:	83 c4 10             	add    $0x10,%esp
}
  8007b4:	90                   	nop
  8007b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    

008007ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c1:	7e 1c                	jle    8007df <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	8d 50 08             	lea    0x8(%eax),%edx
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	89 10                	mov    %edx,(%eax)
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	8b 00                	mov    (%eax),%eax
  8007d5:	83 e8 08             	sub    $0x8,%eax
  8007d8:	8b 50 04             	mov    0x4(%eax),%edx
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	eb 40                	jmp    80081f <getuint+0x65>
	else if (lflag)
  8007df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e3:	74 1e                	je     800803 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	8d 50 04             	lea    0x4(%eax),%edx
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	89 10                	mov    %edx,(%eax)
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	83 e8 04             	sub    $0x4,%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800801:	eb 1c                	jmp    80081f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	8d 50 04             	lea    0x4(%eax),%edx
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	89 10                	mov    %edx,(%eax)
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	8b 00                	mov    (%eax),%eax
  800815:	83 e8 04             	sub    $0x4,%eax
  800818:	8b 00                	mov    (%eax),%eax
  80081a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80081f:	5d                   	pop    %ebp
  800820:	c3                   	ret    

00800821 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800824:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800828:	7e 1c                	jle    800846 <getint+0x25>
		return va_arg(*ap, long long);
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	8b 00                	mov    (%eax),%eax
  80082f:	8d 50 08             	lea    0x8(%eax),%edx
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	89 10                	mov    %edx,(%eax)
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	83 e8 08             	sub    $0x8,%eax
  80083f:	8b 50 04             	mov    0x4(%eax),%edx
  800842:	8b 00                	mov    (%eax),%eax
  800844:	eb 38                	jmp    80087e <getint+0x5d>
	else if (lflag)
  800846:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80084a:	74 1a                	je     800866 <getint+0x45>
		return va_arg(*ap, long);
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	8d 50 04             	lea    0x4(%eax),%edx
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	89 10                	mov    %edx,(%eax)
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
  80085c:	8b 00                	mov    (%eax),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	99                   	cltd   
  800864:	eb 18                	jmp    80087e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	8d 50 04             	lea    0x4(%eax),%edx
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	89 10                	mov    %edx,(%eax)
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	8b 00                	mov    (%eax),%eax
  800878:	83 e8 04             	sub    $0x4,%eax
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	99                   	cltd   
}
  80087e:	5d                   	pop    %ebp
  80087f:	c3                   	ret    

00800880 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	56                   	push   %esi
  800884:	53                   	push   %ebx
  800885:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800888:	eb 17                	jmp    8008a1 <vprintfmt+0x21>
			if (ch == '\0')
  80088a:	85 db                	test   %ebx,%ebx
  80088c:	0f 84 c1 03 00 00    	je     800c53 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800892:	83 ec 08             	sub    $0x8,%esp
  800895:	ff 75 0c             	pushl  0xc(%ebp)
  800898:	53                   	push   %ebx
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	ff d0                	call   *%eax
  80089e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a4:	8d 50 01             	lea    0x1(%eax),%edx
  8008a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8008aa:	8a 00                	mov    (%eax),%al
  8008ac:	0f b6 d8             	movzbl %al,%ebx
  8008af:	83 fb 25             	cmp    $0x25,%ebx
  8008b2:	75 d6                	jne    80088a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d7:	8d 50 01             	lea    0x1(%eax),%edx
  8008da:	89 55 10             	mov    %edx,0x10(%ebp)
  8008dd:	8a 00                	mov    (%eax),%al
  8008df:	0f b6 d8             	movzbl %al,%ebx
  8008e2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008e5:	83 f8 5b             	cmp    $0x5b,%eax
  8008e8:	0f 87 3d 03 00 00    	ja     800c2b <vprintfmt+0x3ab>
  8008ee:	8b 04 85 b8 23 80 00 	mov    0x8023b8(,%eax,4),%eax
  8008f5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008f7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008fb:	eb d7                	jmp    8008d4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008fd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800901:	eb d1                	jmp    8008d4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800903:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80090a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80090d:	89 d0                	mov    %edx,%eax
  80090f:	c1 e0 02             	shl    $0x2,%eax
  800912:	01 d0                	add    %edx,%eax
  800914:	01 c0                	add    %eax,%eax
  800916:	01 d8                	add    %ebx,%eax
  800918:	83 e8 30             	sub    $0x30,%eax
  80091b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80091e:	8b 45 10             	mov    0x10(%ebp),%eax
  800921:	8a 00                	mov    (%eax),%al
  800923:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800926:	83 fb 2f             	cmp    $0x2f,%ebx
  800929:	7e 3e                	jle    800969 <vprintfmt+0xe9>
  80092b:	83 fb 39             	cmp    $0x39,%ebx
  80092e:	7f 39                	jg     800969 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800930:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800933:	eb d5                	jmp    80090a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	83 c0 04             	add    $0x4,%eax
  80093b:	89 45 14             	mov    %eax,0x14(%ebp)
  80093e:	8b 45 14             	mov    0x14(%ebp),%eax
  800941:	83 e8 04             	sub    $0x4,%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800949:	eb 1f                	jmp    80096a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80094b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094f:	79 83                	jns    8008d4 <vprintfmt+0x54>
				width = 0;
  800951:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800958:	e9 77 ff ff ff       	jmp    8008d4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80095d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800964:	e9 6b ff ff ff       	jmp    8008d4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800969:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80096a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096e:	0f 89 60 ff ff ff    	jns    8008d4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800974:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800977:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800981:	e9 4e ff ff ff       	jmp    8008d4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800986:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800989:	e9 46 ff ff ff       	jmp    8008d4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80098e:	8b 45 14             	mov    0x14(%ebp),%eax
  800991:	83 c0 04             	add    $0x4,%eax
  800994:	89 45 14             	mov    %eax,0x14(%ebp)
  800997:	8b 45 14             	mov    0x14(%ebp),%eax
  80099a:	83 e8 04             	sub    $0x4,%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	ff 75 0c             	pushl  0xc(%ebp)
  8009a5:	50                   	push   %eax
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	ff d0                	call   *%eax
  8009ab:	83 c4 10             	add    $0x10,%esp
			break;
  8009ae:	e9 9b 02 00 00       	jmp    800c4e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b6:	83 c0 04             	add    $0x4,%eax
  8009b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bf:	83 e8 04             	sub    $0x4,%eax
  8009c2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009c4:	85 db                	test   %ebx,%ebx
  8009c6:	79 02                	jns    8009ca <vprintfmt+0x14a>
				err = -err;
  8009c8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009ca:	83 fb 64             	cmp    $0x64,%ebx
  8009cd:	7f 0b                	jg     8009da <vprintfmt+0x15a>
  8009cf:	8b 34 9d 00 22 80 00 	mov    0x802200(,%ebx,4),%esi
  8009d6:	85 f6                	test   %esi,%esi
  8009d8:	75 19                	jne    8009f3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009da:	53                   	push   %ebx
  8009db:	68 a5 23 80 00       	push   $0x8023a5
  8009e0:	ff 75 0c             	pushl  0xc(%ebp)
  8009e3:	ff 75 08             	pushl  0x8(%ebp)
  8009e6:	e8 70 02 00 00       	call   800c5b <printfmt>
  8009eb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009ee:	e9 5b 02 00 00       	jmp    800c4e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009f3:	56                   	push   %esi
  8009f4:	68 ae 23 80 00       	push   $0x8023ae
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	ff 75 08             	pushl  0x8(%ebp)
  8009ff:	e8 57 02 00 00       	call   800c5b <printfmt>
  800a04:	83 c4 10             	add    $0x10,%esp
			break;
  800a07:	e9 42 02 00 00       	jmp    800c4e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0f:	83 c0 04             	add    $0x4,%eax
  800a12:	89 45 14             	mov    %eax,0x14(%ebp)
  800a15:	8b 45 14             	mov    0x14(%ebp),%eax
  800a18:	83 e8 04             	sub    $0x4,%eax
  800a1b:	8b 30                	mov    (%eax),%esi
  800a1d:	85 f6                	test   %esi,%esi
  800a1f:	75 05                	jne    800a26 <vprintfmt+0x1a6>
				p = "(null)";
  800a21:	be b1 23 80 00       	mov    $0x8023b1,%esi
			if (width > 0 && padc != '-')
  800a26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2a:	7e 6d                	jle    800a99 <vprintfmt+0x219>
  800a2c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a30:	74 67                	je     800a99 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a35:	83 ec 08             	sub    $0x8,%esp
  800a38:	50                   	push   %eax
  800a39:	56                   	push   %esi
  800a3a:	e8 1e 03 00 00       	call   800d5d <strnlen>
  800a3f:	83 c4 10             	add    $0x10,%esp
  800a42:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a45:	eb 16                	jmp    800a5d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a47:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	50                   	push   %eax
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	ff d0                	call   *%eax
  800a57:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a5a:	ff 4d e4             	decl   -0x1c(%ebp)
  800a5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a61:	7f e4                	jg     800a47 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a63:	eb 34                	jmp    800a99 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a69:	74 1c                	je     800a87 <vprintfmt+0x207>
  800a6b:	83 fb 1f             	cmp    $0x1f,%ebx
  800a6e:	7e 05                	jle    800a75 <vprintfmt+0x1f5>
  800a70:	83 fb 7e             	cmp    $0x7e,%ebx
  800a73:	7e 12                	jle    800a87 <vprintfmt+0x207>
					putch('?', putdat);
  800a75:	83 ec 08             	sub    $0x8,%esp
  800a78:	ff 75 0c             	pushl  0xc(%ebp)
  800a7b:	6a 3f                	push   $0x3f
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	ff d0                	call   *%eax
  800a82:	83 c4 10             	add    $0x10,%esp
  800a85:	eb 0f                	jmp    800a96 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	53                   	push   %ebx
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	ff d0                	call   *%eax
  800a93:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a96:	ff 4d e4             	decl   -0x1c(%ebp)
  800a99:	89 f0                	mov    %esi,%eax
  800a9b:	8d 70 01             	lea    0x1(%eax),%esi
  800a9e:	8a 00                	mov    (%eax),%al
  800aa0:	0f be d8             	movsbl %al,%ebx
  800aa3:	85 db                	test   %ebx,%ebx
  800aa5:	74 24                	je     800acb <vprintfmt+0x24b>
  800aa7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aab:	78 b8                	js     800a65 <vprintfmt+0x1e5>
  800aad:	ff 4d e0             	decl   -0x20(%ebp)
  800ab0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab4:	79 af                	jns    800a65 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab6:	eb 13                	jmp    800acb <vprintfmt+0x24b>
				putch(' ', putdat);
  800ab8:	83 ec 08             	sub    $0x8,%esp
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	6a 20                	push   $0x20
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	ff d0                	call   *%eax
  800ac5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac8:	ff 4d e4             	decl   -0x1c(%ebp)
  800acb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800acf:	7f e7                	jg     800ab8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ad1:	e9 78 01 00 00       	jmp    800c4e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ad6:	83 ec 08             	sub    $0x8,%esp
  800ad9:	ff 75 e8             	pushl  -0x18(%ebp)
  800adc:	8d 45 14             	lea    0x14(%ebp),%eax
  800adf:	50                   	push   %eax
  800ae0:	e8 3c fd ff ff       	call   800821 <getint>
  800ae5:	83 c4 10             	add    $0x10,%esp
  800ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aeb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af4:	85 d2                	test   %edx,%edx
  800af6:	79 23                	jns    800b1b <vprintfmt+0x29b>
				putch('-', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 2d                	push   $0x2d
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b0e:	f7 d8                	neg    %eax
  800b10:	83 d2 00             	adc    $0x0,%edx
  800b13:	f7 da                	neg    %edx
  800b15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b22:	e9 bc 00 00 00       	jmp    800be3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b27:	83 ec 08             	sub    $0x8,%esp
  800b2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b30:	50                   	push   %eax
  800b31:	e8 84 fc ff ff       	call   8007ba <getuint>
  800b36:	83 c4 10             	add    $0x10,%esp
  800b39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b46:	e9 98 00 00 00       	jmp    800be3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	6a 58                	push   $0x58
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	ff d0                	call   *%eax
  800b58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b5b:	83 ec 08             	sub    $0x8,%esp
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	6a 58                	push   $0x58
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	ff d0                	call   *%eax
  800b68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	6a 58                	push   $0x58
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	ff d0                	call   *%eax
  800b78:	83 c4 10             	add    $0x10,%esp
			break;
  800b7b:	e9 ce 00 00 00       	jmp    800c4e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	6a 30                	push   $0x30
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b90:	83 ec 08             	sub    $0x8,%esp
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	6a 78                	push   $0x78
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	ff d0                	call   *%eax
  800b9d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ba0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba3:	83 c0 04             	add    $0x4,%eax
  800ba6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ba9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bac:	83 e8 04             	sub    $0x4,%eax
  800baf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bbb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bc2:	eb 1f                	jmp    800be3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	ff 75 e8             	pushl  -0x18(%ebp)
  800bca:	8d 45 14             	lea    0x14(%ebp),%eax
  800bcd:	50                   	push   %eax
  800bce:	e8 e7 fb ff ff       	call   8007ba <getuint>
  800bd3:	83 c4 10             	add    $0x10,%esp
  800bd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bdc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800be3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bea:	83 ec 04             	sub    $0x4,%esp
  800bed:	52                   	push   %edx
  800bee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf1:	50                   	push   %eax
  800bf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf5:	ff 75 f0             	pushl  -0x10(%ebp)
  800bf8:	ff 75 0c             	pushl  0xc(%ebp)
  800bfb:	ff 75 08             	pushl  0x8(%ebp)
  800bfe:	e8 00 fb ff ff       	call   800703 <printnum>
  800c03:	83 c4 20             	add    $0x20,%esp
			break;
  800c06:	eb 46                	jmp    800c4e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c08:	83 ec 08             	sub    $0x8,%esp
  800c0b:	ff 75 0c             	pushl  0xc(%ebp)
  800c0e:	53                   	push   %ebx
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	ff d0                	call   *%eax
  800c14:	83 c4 10             	add    $0x10,%esp
			break;
  800c17:	eb 35                	jmp    800c4e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c19:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800c20:	eb 2c                	jmp    800c4e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c22:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800c29:	eb 23                	jmp    800c4e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c2b:	83 ec 08             	sub    $0x8,%esp
  800c2e:	ff 75 0c             	pushl  0xc(%ebp)
  800c31:	6a 25                	push   $0x25
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	ff d0                	call   *%eax
  800c38:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c3b:	ff 4d 10             	decl   0x10(%ebp)
  800c3e:	eb 03                	jmp    800c43 <vprintfmt+0x3c3>
  800c40:	ff 4d 10             	decl   0x10(%ebp)
  800c43:	8b 45 10             	mov    0x10(%ebp),%eax
  800c46:	48                   	dec    %eax
  800c47:	8a 00                	mov    (%eax),%al
  800c49:	3c 25                	cmp    $0x25,%al
  800c4b:	75 f3                	jne    800c40 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c4d:	90                   	nop
		}
	}
  800c4e:	e9 35 fc ff ff       	jmp    800888 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c53:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c57:	5b                   	pop    %ebx
  800c58:	5e                   	pop    %esi
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c61:	8d 45 10             	lea    0x10(%ebp),%eax
  800c64:	83 c0 04             	add    $0x4,%eax
  800c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c70:	50                   	push   %eax
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	ff 75 08             	pushl  0x8(%ebp)
  800c77:	e8 04 fc ff ff       	call   800880 <vprintfmt>
  800c7c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c7f:	90                   	nop
  800c80:	c9                   	leave  
  800c81:	c3                   	ret    

00800c82 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c88:	8b 40 08             	mov    0x8(%eax),%eax
  800c8b:	8d 50 01             	lea    0x1(%eax),%edx
  800c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c91:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c97:	8b 10                	mov    (%eax),%edx
  800c99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9c:	8b 40 04             	mov    0x4(%eax),%eax
  800c9f:	39 c2                	cmp    %eax,%edx
  800ca1:	73 12                	jae    800cb5 <sprintputch+0x33>
		*b->buf++ = ch;
  800ca3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca6:	8b 00                	mov    (%eax),%eax
  800ca8:	8d 48 01             	lea    0x1(%eax),%ecx
  800cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cae:	89 0a                	mov    %ecx,(%edx)
  800cb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb3:	88 10                	mov    %dl,(%eax)
}
  800cb5:	90                   	nop
  800cb6:	5d                   	pop    %ebp
  800cb7:	c3                   	ret    

00800cb8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	01 d0                	add    %edx,%eax
  800ccf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cdd:	74 06                	je     800ce5 <vsnprintf+0x2d>
  800cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce3:	7f 07                	jg     800cec <vsnprintf+0x34>
		return -E_INVAL;
  800ce5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cea:	eb 20                	jmp    800d0c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cec:	ff 75 14             	pushl  0x14(%ebp)
  800cef:	ff 75 10             	pushl  0x10(%ebp)
  800cf2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cf5:	50                   	push   %eax
  800cf6:	68 82 0c 80 00       	push   $0x800c82
  800cfb:	e8 80 fb ff ff       	call   800880 <vprintfmt>
  800d00:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d06:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d0c:	c9                   	leave  
  800d0d:	c3                   	ret    

00800d0e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d14:	8d 45 10             	lea    0x10(%ebp),%eax
  800d17:	83 c0 04             	add    $0x4,%eax
  800d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d20:	ff 75 f4             	pushl  -0xc(%ebp)
  800d23:	50                   	push   %eax
  800d24:	ff 75 0c             	pushl  0xc(%ebp)
  800d27:	ff 75 08             	pushl  0x8(%ebp)
  800d2a:	e8 89 ff ff ff       	call   800cb8 <vsnprintf>
  800d2f:	83 c4 10             	add    $0x10,%esp
  800d32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d38:	c9                   	leave  
  800d39:	c3                   	ret    

00800d3a <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d47:	eb 06                	jmp    800d4f <strlen+0x15>
		n++;
  800d49:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d4c:	ff 45 08             	incl   0x8(%ebp)
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	84 c0                	test   %al,%al
  800d56:	75 f1                	jne    800d49 <strlen+0xf>
		n++;
	return n;
  800d58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d6a:	eb 09                	jmp    800d75 <strnlen+0x18>
		n++;
  800d6c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d6f:	ff 45 08             	incl   0x8(%ebp)
  800d72:	ff 4d 0c             	decl   0xc(%ebp)
  800d75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d79:	74 09                	je     800d84 <strnlen+0x27>
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8a 00                	mov    (%eax),%al
  800d80:	84 c0                	test   %al,%al
  800d82:	75 e8                	jne    800d6c <strnlen+0xf>
		n++;
	return n;
  800d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d87:	c9                   	leave  
  800d88:	c3                   	ret    

00800d89 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d95:	90                   	nop
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8d 50 01             	lea    0x1(%eax),%edx
  800d9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da8:	8a 12                	mov    (%edx),%dl
  800daa:	88 10                	mov    %dl,(%eax)
  800dac:	8a 00                	mov    (%eax),%al
  800dae:	84 c0                	test   %al,%al
  800db0:	75 e4                	jne    800d96 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800db2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800db5:	c9                   	leave  
  800db6:	c3                   	ret    

00800db7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dc3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dca:	eb 1f                	jmp    800deb <strncpy+0x34>
		*dst++ = *src;
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8d 50 01             	lea    0x1(%eax),%edx
  800dd2:	89 55 08             	mov    %edx,0x8(%ebp)
  800dd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd8:	8a 12                	mov    (%edx),%dl
  800dda:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	84 c0                	test   %al,%al
  800de3:	74 03                	je     800de8 <strncpy+0x31>
			src++;
  800de5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800de8:	ff 45 fc             	incl   -0x4(%ebp)
  800deb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dee:	3b 45 10             	cmp    0x10(%ebp),%eax
  800df1:	72 d9                	jb     800dcc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800df3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800df6:	c9                   	leave  
  800df7:	c3                   	ret    

00800df8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e08:	74 30                	je     800e3a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e0a:	eb 16                	jmp    800e22 <strlcpy+0x2a>
			*dst++ = *src++;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8d 50 01             	lea    0x1(%eax),%edx
  800e12:	89 55 08             	mov    %edx,0x8(%ebp)
  800e15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e18:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e1b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e1e:	8a 12                	mov    (%edx),%dl
  800e20:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e22:	ff 4d 10             	decl   0x10(%ebp)
  800e25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e29:	74 09                	je     800e34 <strlcpy+0x3c>
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	84 c0                	test   %al,%al
  800e32:	75 d8                	jne    800e0c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e40:	29 c2                	sub    %eax,%edx
  800e42:	89 d0                	mov    %edx,%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e49:	eb 06                	jmp    800e51 <strcmp+0xb>
		p++, q++;
  800e4b:	ff 45 08             	incl   0x8(%ebp)
  800e4e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8a 00                	mov    (%eax),%al
  800e56:	84 c0                	test   %al,%al
  800e58:	74 0e                	je     800e68 <strcmp+0x22>
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	8a 10                	mov    (%eax),%dl
  800e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	38 c2                	cmp    %al,%dl
  800e66:	74 e3                	je     800e4b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	0f b6 d0             	movzbl %al,%edx
  800e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	0f b6 c0             	movzbl %al,%eax
  800e78:	29 c2                	sub    %eax,%edx
  800e7a:	89 d0                	mov    %edx,%eax
}
  800e7c:	5d                   	pop    %ebp
  800e7d:	c3                   	ret    

00800e7e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e81:	eb 09                	jmp    800e8c <strncmp+0xe>
		n--, p++, q++;
  800e83:	ff 4d 10             	decl   0x10(%ebp)
  800e86:	ff 45 08             	incl   0x8(%ebp)
  800e89:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e90:	74 17                	je     800ea9 <strncmp+0x2b>
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	84 c0                	test   %al,%al
  800e99:	74 0e                	je     800ea9 <strncmp+0x2b>
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8a 10                	mov    (%eax),%dl
  800ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	38 c2                	cmp    %al,%dl
  800ea7:	74 da                	je     800e83 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ea9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ead:	75 07                	jne    800eb6 <strncmp+0x38>
		return 0;
  800eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb4:	eb 14                	jmp    800eca <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	0f b6 d0             	movzbl %al,%edx
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	0f b6 c0             	movzbl %al,%eax
  800ec6:	29 c2                	sub    %eax,%edx
  800ec8:	89 d0                	mov    %edx,%eax
}
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    

00800ecc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 04             	sub    $0x4,%esp
  800ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed8:	eb 12                	jmp    800eec <strchr+0x20>
		if (*s == c)
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ee2:	75 05                	jne    800ee9 <strchr+0x1d>
			return (char *) s;
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	eb 11                	jmp    800efa <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ee9:	ff 45 08             	incl   0x8(%ebp)
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	84 c0                	test   %al,%al
  800ef3:	75 e5                	jne    800eda <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ef5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800efa:	c9                   	leave  
  800efb:	c3                   	ret    

00800efc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	83 ec 04             	sub    $0x4,%esp
  800f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f05:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f08:	eb 0d                	jmp    800f17 <strfind+0x1b>
		if (*s == c)
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f12:	74 0e                	je     800f22 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f14:	ff 45 08             	incl   0x8(%ebp)
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	84 c0                	test   %al,%al
  800f1e:	75 ea                	jne    800f0a <strfind+0xe>
  800f20:	eb 01                	jmp    800f23 <strfind+0x27>
		if (*s == c)
			break;
  800f22:	90                   	nop
	return (char *) s;
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f26:	c9                   	leave  
  800f27:	c3                   	ret    

00800f28 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f34:	8b 45 10             	mov    0x10(%ebp),%eax
  800f37:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f3a:	eb 0e                	jmp    800f4a <memset+0x22>
		*p++ = c;
  800f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3f:	8d 50 01             	lea    0x1(%eax),%edx
  800f42:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f48:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f4a:	ff 4d f8             	decl   -0x8(%ebp)
  800f4d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f51:	79 e9                	jns    800f3c <memset+0x14>
		*p++ = c;

	return v;
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f56:	c9                   	leave  
  800f57:	c3                   	ret    

00800f58 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f6a:	eb 16                	jmp    800f82 <memcpy+0x2a>
		*d++ = *s++;
  800f6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6f:	8d 50 01             	lea    0x1(%eax),%edx
  800f72:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f75:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f78:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f7b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f7e:	8a 12                	mov    (%edx),%dl
  800f80:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f82:	8b 45 10             	mov    0x10(%ebp),%eax
  800f85:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f88:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	75 dd                	jne    800f6c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f92:	c9                   	leave  
  800f93:	c3                   	ret    

00800f94 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fac:	73 50                	jae    800ffe <memmove+0x6a>
  800fae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	01 d0                	add    %edx,%eax
  800fb6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb9:	76 43                	jbe    800ffe <memmove+0x6a>
		s += n;
  800fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbe:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fc7:	eb 10                	jmp    800fd9 <memmove+0x45>
			*--d = *--s;
  800fc9:	ff 4d f8             	decl   -0x8(%ebp)
  800fcc:	ff 4d fc             	decl   -0x4(%ebp)
  800fcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd2:	8a 10                	mov    (%eax),%dl
  800fd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fdf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe2:	85 c0                	test   %eax,%eax
  800fe4:	75 e3                	jne    800fc9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fe6:	eb 23                	jmp    80100b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fe8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800feb:	8d 50 01             	lea    0x1(%eax),%edx
  800fee:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ff7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ffa:	8a 12                	mov    (%edx),%dl
  800ffc:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ffe:	8b 45 10             	mov    0x10(%ebp),%eax
  801001:	8d 50 ff             	lea    -0x1(%eax),%edx
  801004:	89 55 10             	mov    %edx,0x10(%ebp)
  801007:	85 c0                	test   %eax,%eax
  801009:	75 dd                	jne    800fe8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100e:	c9                   	leave  
  80100f:	c3                   	ret    

00801010 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801022:	eb 2a                	jmp    80104e <memcmp+0x3e>
		if (*s1 != *s2)
  801024:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801027:	8a 10                	mov    (%eax),%dl
  801029:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	38 c2                	cmp    %al,%dl
  801030:	74 16                	je     801048 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801032:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f b6 d0             	movzbl %al,%edx
  80103a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	0f b6 c0             	movzbl %al,%eax
  801042:	29 c2                	sub    %eax,%edx
  801044:	89 d0                	mov    %edx,%eax
  801046:	eb 18                	jmp    801060 <memcmp+0x50>
		s1++, s2++;
  801048:	ff 45 fc             	incl   -0x4(%ebp)
  80104b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80104e:	8b 45 10             	mov    0x10(%ebp),%eax
  801051:	8d 50 ff             	lea    -0x1(%eax),%edx
  801054:	89 55 10             	mov    %edx,0x10(%ebp)
  801057:	85 c0                	test   %eax,%eax
  801059:	75 c9                	jne    801024 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80105b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801060:	c9                   	leave  
  801061:	c3                   	ret    

00801062 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801068:	8b 55 08             	mov    0x8(%ebp),%edx
  80106b:	8b 45 10             	mov    0x10(%ebp),%eax
  80106e:	01 d0                	add    %edx,%eax
  801070:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801073:	eb 15                	jmp    80108a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	0f b6 d0             	movzbl %al,%edx
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	0f b6 c0             	movzbl %al,%eax
  801083:	39 c2                	cmp    %eax,%edx
  801085:	74 0d                	je     801094 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801087:	ff 45 08             	incl   0x8(%ebp)
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801090:	72 e3                	jb     801075 <memfind+0x13>
  801092:	eb 01                	jmp    801095 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801094:	90                   	nop
	return (void *) s;
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801098:	c9                   	leave  
  801099:	c3                   	ret    

0080109a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ae:	eb 03                	jmp    8010b3 <strtol+0x19>
		s++;
  8010b0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	3c 20                	cmp    $0x20,%al
  8010ba:	74 f4                	je     8010b0 <strtol+0x16>
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	8a 00                	mov    (%eax),%al
  8010c1:	3c 09                	cmp    $0x9,%al
  8010c3:	74 eb                	je     8010b0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	8a 00                	mov    (%eax),%al
  8010ca:	3c 2b                	cmp    $0x2b,%al
  8010cc:	75 05                	jne    8010d3 <strtol+0x39>
		s++;
  8010ce:	ff 45 08             	incl   0x8(%ebp)
  8010d1:	eb 13                	jmp    8010e6 <strtol+0x4c>
	else if (*s == '-')
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	3c 2d                	cmp    $0x2d,%al
  8010da:	75 0a                	jne    8010e6 <strtol+0x4c>
		s++, neg = 1;
  8010dc:	ff 45 08             	incl   0x8(%ebp)
  8010df:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ea:	74 06                	je     8010f2 <strtol+0x58>
  8010ec:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010f0:	75 20                	jne    801112 <strtol+0x78>
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	3c 30                	cmp    $0x30,%al
  8010f9:	75 17                	jne    801112 <strtol+0x78>
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	40                   	inc    %eax
  8010ff:	8a 00                	mov    (%eax),%al
  801101:	3c 78                	cmp    $0x78,%al
  801103:	75 0d                	jne    801112 <strtol+0x78>
		s += 2, base = 16;
  801105:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801109:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801110:	eb 28                	jmp    80113a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801112:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801116:	75 15                	jne    80112d <strtol+0x93>
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	3c 30                	cmp    $0x30,%al
  80111f:	75 0c                	jne    80112d <strtol+0x93>
		s++, base = 8;
  801121:	ff 45 08             	incl   0x8(%ebp)
  801124:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80112b:	eb 0d                	jmp    80113a <strtol+0xa0>
	else if (base == 0)
  80112d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801131:	75 07                	jne    80113a <strtol+0xa0>
		base = 10;
  801133:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	3c 2f                	cmp    $0x2f,%al
  801141:	7e 19                	jle    80115c <strtol+0xc2>
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	3c 39                	cmp    $0x39,%al
  80114a:	7f 10                	jg     80115c <strtol+0xc2>
			dig = *s - '0';
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	0f be c0             	movsbl %al,%eax
  801154:	83 e8 30             	sub    $0x30,%eax
  801157:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80115a:	eb 42                	jmp    80119e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	3c 60                	cmp    $0x60,%al
  801163:	7e 19                	jle    80117e <strtol+0xe4>
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	3c 7a                	cmp    $0x7a,%al
  80116c:	7f 10                	jg     80117e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	0f be c0             	movsbl %al,%eax
  801176:	83 e8 57             	sub    $0x57,%eax
  801179:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80117c:	eb 20                	jmp    80119e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	3c 40                	cmp    $0x40,%al
  801185:	7e 39                	jle    8011c0 <strtol+0x126>
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	3c 5a                	cmp    $0x5a,%al
  80118e:	7f 30                	jg     8011c0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	8a 00                	mov    (%eax),%al
  801195:	0f be c0             	movsbl %al,%eax
  801198:	83 e8 37             	sub    $0x37,%eax
  80119b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80119e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a4:	7d 19                	jge    8011bf <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011a6:	ff 45 08             	incl   0x8(%ebp)
  8011a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ac:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011b0:	89 c2                	mov    %eax,%edx
  8011b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011ba:	e9 7b ff ff ff       	jmp    80113a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011bf:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c4:	74 08                	je     8011ce <strtol+0x134>
		*endptr = (char *) s;
  8011c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d2:	74 07                	je     8011db <strtol+0x141>
  8011d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d7:	f7 d8                	neg    %eax
  8011d9:	eb 03                	jmp    8011de <strtol+0x144>
  8011db:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <ltostr>:

void
ltostr(long value, char *str)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f8:	79 13                	jns    80120d <ltostr+0x2d>
	{
		neg = 1;
  8011fa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801201:	8b 45 0c             	mov    0xc(%ebp),%eax
  801204:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801207:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80120a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801215:	99                   	cltd   
  801216:	f7 f9                	idiv   %ecx
  801218:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121e:	8d 50 01             	lea    0x1(%eax),%edx
  801221:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801224:	89 c2                	mov    %eax,%edx
  801226:	8b 45 0c             	mov    0xc(%ebp),%eax
  801229:	01 d0                	add    %edx,%eax
  80122b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80122e:	83 c2 30             	add    $0x30,%edx
  801231:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801233:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801236:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80123b:	f7 e9                	imul   %ecx
  80123d:	c1 fa 02             	sar    $0x2,%edx
  801240:	89 c8                	mov    %ecx,%eax
  801242:	c1 f8 1f             	sar    $0x1f,%eax
  801245:	29 c2                	sub    %eax,%edx
  801247:	89 d0                	mov    %edx,%eax
  801249:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80124c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801250:	75 bb                	jne    80120d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801259:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125c:	48                   	dec    %eax
  80125d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801260:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801264:	74 3d                	je     8012a3 <ltostr+0xc3>
		start = 1 ;
  801266:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80126d:	eb 34                	jmp    8012a3 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80126f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801272:	8b 45 0c             	mov    0xc(%ebp),%eax
  801275:	01 d0                	add    %edx,%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80127c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801282:	01 c2                	add    %eax,%edx
  801284:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128a:	01 c8                	add    %ecx,%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801290:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801293:	8b 45 0c             	mov    0xc(%ebp),%eax
  801296:	01 c2                	add    %eax,%edx
  801298:	8a 45 eb             	mov    -0x15(%ebp),%al
  80129b:	88 02                	mov    %al,(%edx)
		start++ ;
  80129d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012a0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012a9:	7c c4                	jl     80126f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012ab:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b1:	01 d0                	add    %edx,%eax
  8012b3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012b6:	90                   	nop
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

008012b9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012bf:	ff 75 08             	pushl  0x8(%ebp)
  8012c2:	e8 73 fa ff ff       	call   800d3a <strlen>
  8012c7:	83 c4 04             	add    $0x4,%esp
  8012ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012cd:	ff 75 0c             	pushl  0xc(%ebp)
  8012d0:	e8 65 fa ff ff       	call   800d3a <strlen>
  8012d5:	83 c4 04             	add    $0x4,%esp
  8012d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012e9:	eb 17                	jmp    801302 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f1:	01 c2                	add    %eax,%edx
  8012f3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	01 c8                	add    %ecx,%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012ff:	ff 45 fc             	incl   -0x4(%ebp)
  801302:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801305:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801308:	7c e1                	jl     8012eb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80130a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801311:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801318:	eb 1f                	jmp    801339 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80131a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131d:	8d 50 01             	lea    0x1(%eax),%edx
  801320:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801323:	89 c2                	mov    %eax,%edx
  801325:	8b 45 10             	mov    0x10(%ebp),%eax
  801328:	01 c2                	add    %eax,%edx
  80132a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80132d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801330:	01 c8                	add    %ecx,%eax
  801332:	8a 00                	mov    (%eax),%al
  801334:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801336:	ff 45 f8             	incl   -0x8(%ebp)
  801339:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80133f:	7c d9                	jl     80131a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801341:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801344:	8b 45 10             	mov    0x10(%ebp),%eax
  801347:	01 d0                	add    %edx,%eax
  801349:	c6 00 00             	movb   $0x0,(%eax)
}
  80134c:	90                   	nop
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801352:	8b 45 14             	mov    0x14(%ebp),%eax
  801355:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80135b:	8b 45 14             	mov    0x14(%ebp),%eax
  80135e:	8b 00                	mov    (%eax),%eax
  801360:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801367:	8b 45 10             	mov    0x10(%ebp),%eax
  80136a:	01 d0                	add    %edx,%eax
  80136c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801372:	eb 0c                	jmp    801380 <strsplit+0x31>
			*string++ = 0;
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	8d 50 01             	lea    0x1(%eax),%edx
  80137a:	89 55 08             	mov    %edx,0x8(%ebp)
  80137d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	84 c0                	test   %al,%al
  801387:	74 18                	je     8013a1 <strsplit+0x52>
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8a 00                	mov    (%eax),%al
  80138e:	0f be c0             	movsbl %al,%eax
  801391:	50                   	push   %eax
  801392:	ff 75 0c             	pushl  0xc(%ebp)
  801395:	e8 32 fb ff ff       	call   800ecc <strchr>
  80139a:	83 c4 08             	add    $0x8,%esp
  80139d:	85 c0                	test   %eax,%eax
  80139f:	75 d3                	jne    801374 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	8a 00                	mov    (%eax),%al
  8013a6:	84 c0                	test   %al,%al
  8013a8:	74 5a                	je     801404 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ad:	8b 00                	mov    (%eax),%eax
  8013af:	83 f8 0f             	cmp    $0xf,%eax
  8013b2:	75 07                	jne    8013bb <strsplit+0x6c>
		{
			return 0;
  8013b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b9:	eb 66                	jmp    801421 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013be:	8b 00                	mov    (%eax),%eax
  8013c0:	8d 48 01             	lea    0x1(%eax),%ecx
  8013c3:	8b 55 14             	mov    0x14(%ebp),%edx
  8013c6:	89 0a                	mov    %ecx,(%edx)
  8013c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d2:	01 c2                	add    %eax,%edx
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013d9:	eb 03                	jmp    8013de <strsplit+0x8f>
			string++;
  8013db:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	8a 00                	mov    (%eax),%al
  8013e3:	84 c0                	test   %al,%al
  8013e5:	74 8b                	je     801372 <strsplit+0x23>
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	8a 00                	mov    (%eax),%al
  8013ec:	0f be c0             	movsbl %al,%eax
  8013ef:	50                   	push   %eax
  8013f0:	ff 75 0c             	pushl  0xc(%ebp)
  8013f3:	e8 d4 fa ff ff       	call   800ecc <strchr>
  8013f8:	83 c4 08             	add    $0x8,%esp
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	74 dc                	je     8013db <strsplit+0x8c>
			string++;
	}
  8013ff:	e9 6e ff ff ff       	jmp    801372 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801404:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801405:	8b 45 14             	mov    0x14(%ebp),%eax
  801408:	8b 00                	mov    (%eax),%eax
  80140a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801411:	8b 45 10             	mov    0x10(%ebp),%eax
  801414:	01 d0                	add    %edx,%eax
  801416:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80141c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
  801426:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801429:	83 ec 04             	sub    $0x4,%esp
  80142c:	68 28 25 80 00       	push   $0x802528
  801431:	68 3f 01 00 00       	push   $0x13f
  801436:	68 4a 25 80 00       	push   $0x80254a
  80143b:	e8 a9 ef ff ff       	call   8003e9 <_panic>

00801440 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801446:	83 ec 0c             	sub    $0xc,%esp
  801449:	ff 75 08             	pushl  0x8(%ebp)
  80144c:	e8 ef 06 00 00       	call   801b40 <sys_sbrk>
  801451:	83 c4 10             	add    $0x10,%esp
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80145c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801460:	75 07                	jne    801469 <malloc+0x13>
  801462:	b8 00 00 00 00       	mov    $0x0,%eax
  801467:	eb 14                	jmp    80147d <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801469:	83 ec 04             	sub    $0x4,%esp
  80146c:	68 58 25 80 00       	push   $0x802558
  801471:	6a 1b                	push   $0x1b
  801473:	68 7d 25 80 00       	push   $0x80257d
  801478:	e8 6c ef ff ff       	call   8003e9 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801485:	83 ec 04             	sub    $0x4,%esp
  801488:	68 8c 25 80 00       	push   $0x80258c
  80148d:	6a 29                	push   $0x29
  80148f:	68 7d 25 80 00       	push   $0x80257d
  801494:	e8 50 ef ff ff       	call   8003e9 <_panic>

00801499 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	83 ec 18             	sub    $0x18,%esp
  80149f:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a2:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8014a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a9:	75 07                	jne    8014b2 <smalloc+0x19>
  8014ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b0:	eb 14                	jmp    8014c6 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8014b2:	83 ec 04             	sub    $0x4,%esp
  8014b5:	68 b0 25 80 00       	push   $0x8025b0
  8014ba:	6a 38                	push   $0x38
  8014bc:	68 7d 25 80 00       	push   $0x80257d
  8014c1:	e8 23 ef ff ff       	call   8003e9 <_panic>
	return NULL;
}
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
  8014cb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	68 d8 25 80 00       	push   $0x8025d8
  8014d6:	6a 43                	push   $0x43
  8014d8:	68 7d 25 80 00       	push   $0x80257d
  8014dd:	e8 07 ef ff ff       	call   8003e9 <_panic>

008014e2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
  8014e5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8014e8:	83 ec 04             	sub    $0x4,%esp
  8014eb:	68 fc 25 80 00       	push   $0x8025fc
  8014f0:	6a 5b                	push   $0x5b
  8014f2:	68 7d 25 80 00       	push   $0x80257d
  8014f7:	e8 ed ee ff ff       	call   8003e9 <_panic>

008014fc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801502:	83 ec 04             	sub    $0x4,%esp
  801505:	68 20 26 80 00       	push   $0x802620
  80150a:	6a 72                	push   $0x72
  80150c:	68 7d 25 80 00       	push   $0x80257d
  801511:	e8 d3 ee ff ff       	call   8003e9 <_panic>

00801516 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80151c:	83 ec 04             	sub    $0x4,%esp
  80151f:	68 46 26 80 00       	push   $0x802646
  801524:	6a 7e                	push   $0x7e
  801526:	68 7d 25 80 00       	push   $0x80257d
  80152b:	e8 b9 ee ff ff       	call   8003e9 <_panic>

00801530 <shrink>:

}
void shrink(uint32 newSize)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801536:	83 ec 04             	sub    $0x4,%esp
  801539:	68 46 26 80 00       	push   $0x802646
  80153e:	68 83 00 00 00       	push   $0x83
  801543:	68 7d 25 80 00       	push   $0x80257d
  801548:	e8 9c ee ff ff       	call   8003e9 <_panic>

0080154d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801553:	83 ec 04             	sub    $0x4,%esp
  801556:	68 46 26 80 00       	push   $0x802646
  80155b:	68 88 00 00 00       	push   $0x88
  801560:	68 7d 25 80 00       	push   $0x80257d
  801565:	e8 7f ee ff ff       	call   8003e9 <_panic>

0080156a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	57                   	push   %edi
  80156e:	56                   	push   %esi
  80156f:	53                   	push   %ebx
  801570:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	8b 55 0c             	mov    0xc(%ebp),%edx
  801579:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80157c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80157f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801582:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801585:	cd 30                	int    $0x30
  801587:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80158a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80158d:	83 c4 10             	add    $0x10,%esp
  801590:	5b                   	pop    %ebx
  801591:	5e                   	pop    %esi
  801592:	5f                   	pop    %edi
  801593:	5d                   	pop    %ebp
  801594:	c3                   	ret    

00801595 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	83 ec 04             	sub    $0x4,%esp
  80159b:	8b 45 10             	mov    0x10(%ebp),%eax
  80159e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015a1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	52                   	push   %edx
  8015ad:	ff 75 0c             	pushl  0xc(%ebp)
  8015b0:	50                   	push   %eax
  8015b1:	6a 00                	push   $0x0
  8015b3:	e8 b2 ff ff ff       	call   80156a <syscall>
  8015b8:	83 c4 18             	add    $0x18,%esp
}
  8015bb:	90                   	nop
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_cgetc>:

int
sys_cgetc(void)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 02                	push   $0x2
  8015cd:	e8 98 ff ff ff       	call   80156a <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 03                	push   $0x3
  8015e6:	e8 7f ff ff ff       	call   80156a <syscall>
  8015eb:	83 c4 18             	add    $0x18,%esp
}
  8015ee:	90                   	nop
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 04                	push   $0x4
  801600:	e8 65 ff ff ff       	call   80156a <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
}
  801608:	90                   	nop
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80160e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	52                   	push   %edx
  80161b:	50                   	push   %eax
  80161c:	6a 08                	push   $0x8
  80161e:	e8 47 ff ff ff       	call   80156a <syscall>
  801623:	83 c4 18             	add    $0x18,%esp
}
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	56                   	push   %esi
  80162c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80162d:	8b 75 18             	mov    0x18(%ebp),%esi
  801630:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801633:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801636:	8b 55 0c             	mov    0xc(%ebp),%edx
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	56                   	push   %esi
  80163d:	53                   	push   %ebx
  80163e:	51                   	push   %ecx
  80163f:	52                   	push   %edx
  801640:	50                   	push   %eax
  801641:	6a 09                	push   $0x9
  801643:	e8 22 ff ff ff       	call   80156a <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
}
  80164b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164e:	5b                   	pop    %ebx
  80164f:	5e                   	pop    %esi
  801650:	5d                   	pop    %ebp
  801651:	c3                   	ret    

00801652 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801655:	8b 55 0c             	mov    0xc(%ebp),%edx
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	52                   	push   %edx
  801662:	50                   	push   %eax
  801663:	6a 0a                	push   $0xa
  801665:	e8 00 ff ff ff       	call   80156a <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	ff 75 0c             	pushl  0xc(%ebp)
  80167b:	ff 75 08             	pushl  0x8(%ebp)
  80167e:	6a 0b                	push   $0xb
  801680:	e8 e5 fe ff ff       	call   80156a <syscall>
  801685:	83 c4 18             	add    $0x18,%esp
}
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 0c                	push   $0xc
  801699:	e8 cc fe ff ff       	call   80156a <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 0d                	push   $0xd
  8016b2:	e8 b3 fe ff ff       	call   80156a <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 0e                	push   $0xe
  8016cb:	e8 9a fe ff ff       	call   80156a <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 0f                	push   $0xf
  8016e4:	e8 81 fe ff ff       	call   80156a <syscall>
  8016e9:	83 c4 18             	add    $0x18,%esp
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	ff 75 08             	pushl  0x8(%ebp)
  8016fc:	6a 10                	push   $0x10
  8016fe:	e8 67 fe ff ff       	call   80156a <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 11                	push   $0x11
  801717:	e8 4e fe ff ff       	call   80156a <syscall>
  80171c:	83 c4 18             	add    $0x18,%esp
}
  80171f:	90                   	nop
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <sys_cputc>:

void
sys_cputc(const char c)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 04             	sub    $0x4,%esp
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80172e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	50                   	push   %eax
  80173b:	6a 01                	push   $0x1
  80173d:	e8 28 fe ff ff       	call   80156a <syscall>
  801742:	83 c4 18             	add    $0x18,%esp
}
  801745:	90                   	nop
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 14                	push   $0x14
  801757:	e8 0e fe ff ff       	call   80156a <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
}
  80175f:	90                   	nop
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 04             	sub    $0x4,%esp
  801768:	8b 45 10             	mov    0x10(%ebp),%eax
  80176b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80176e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801771:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	6a 00                	push   $0x0
  80177a:	51                   	push   %ecx
  80177b:	52                   	push   %edx
  80177c:	ff 75 0c             	pushl  0xc(%ebp)
  80177f:	50                   	push   %eax
  801780:	6a 15                	push   $0x15
  801782:	e8 e3 fd ff ff       	call   80156a <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
}
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80178f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	52                   	push   %edx
  80179c:	50                   	push   %eax
  80179d:	6a 16                	push   $0x16
  80179f:	e8 c6 fd ff ff       	call   80156a <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	51                   	push   %ecx
  8017ba:	52                   	push   %edx
  8017bb:	50                   	push   %eax
  8017bc:	6a 17                	push   $0x17
  8017be:	e8 a7 fd ff ff       	call   80156a <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	52                   	push   %edx
  8017d8:	50                   	push   %eax
  8017d9:	6a 18                	push   $0x18
  8017db:	e8 8a fd ff ff       	call   80156a <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	6a 00                	push   $0x0
  8017ed:	ff 75 14             	pushl  0x14(%ebp)
  8017f0:	ff 75 10             	pushl  0x10(%ebp)
  8017f3:	ff 75 0c             	pushl  0xc(%ebp)
  8017f6:	50                   	push   %eax
  8017f7:	6a 19                	push   $0x19
  8017f9:	e8 6c fd ff ff       	call   80156a <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	50                   	push   %eax
  801812:	6a 1a                	push   $0x1a
  801814:	e8 51 fd ff ff       	call   80156a <syscall>
  801819:	83 c4 18             	add    $0x18,%esp
}
  80181c:	90                   	nop
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	50                   	push   %eax
  80182e:	6a 1b                	push   $0x1b
  801830:	e8 35 fd ff ff       	call   80156a <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 05                	push   $0x5
  801849:	e8 1c fd ff ff       	call   80156a <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 06                	push   $0x6
  801862:	e8 03 fd ff ff       	call   80156a <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 07                	push   $0x7
  80187b:	e8 ea fc ff ff       	call   80156a <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <sys_exit_env>:


void sys_exit_env(void)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 1c                	push   $0x1c
  801894:	e8 d1 fc ff ff       	call   80156a <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
}
  80189c:	90                   	nop
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018a5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018a8:	8d 50 04             	lea    0x4(%eax),%edx
  8018ab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	52                   	push   %edx
  8018b5:	50                   	push   %eax
  8018b6:	6a 1d                	push   $0x1d
  8018b8:	e8 ad fc ff ff       	call   80156a <syscall>
  8018bd:	83 c4 18             	add    $0x18,%esp
	return result;
  8018c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018c9:	89 01                	mov    %eax,(%ecx)
  8018cb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d1:	c9                   	leave  
  8018d2:	c2 04 00             	ret    $0x4

008018d5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	ff 75 10             	pushl  0x10(%ebp)
  8018df:	ff 75 0c             	pushl  0xc(%ebp)
  8018e2:	ff 75 08             	pushl  0x8(%ebp)
  8018e5:	6a 13                	push   $0x13
  8018e7:	e8 7e fc ff ff       	call   80156a <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ef:	90                   	nop
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 1e                	push   $0x1e
  801901:	e8 64 fc ff ff       	call   80156a <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 04             	sub    $0x4,%esp
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801917:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	50                   	push   %eax
  801924:	6a 1f                	push   $0x1f
  801926:	e8 3f fc ff ff       	call   80156a <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
	return ;
  80192e:	90                   	nop
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <rsttst>:
void rsttst()
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 21                	push   $0x21
  801940:	e8 25 fc ff ff       	call   80156a <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
	return ;
  801948:	90                   	nop
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	83 ec 04             	sub    $0x4,%esp
  801951:	8b 45 14             	mov    0x14(%ebp),%eax
  801954:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801957:	8b 55 18             	mov    0x18(%ebp),%edx
  80195a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80195e:	52                   	push   %edx
  80195f:	50                   	push   %eax
  801960:	ff 75 10             	pushl  0x10(%ebp)
  801963:	ff 75 0c             	pushl  0xc(%ebp)
  801966:	ff 75 08             	pushl  0x8(%ebp)
  801969:	6a 20                	push   $0x20
  80196b:	e8 fa fb ff ff       	call   80156a <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
	return ;
  801973:	90                   	nop
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <chktst>:
void chktst(uint32 n)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	ff 75 08             	pushl  0x8(%ebp)
  801984:	6a 22                	push   $0x22
  801986:	e8 df fb ff ff       	call   80156a <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
	return ;
  80198e:	90                   	nop
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <inctst>:

void inctst()
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 23                	push   $0x23
  8019a0:	e8 c5 fb ff ff       	call   80156a <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a8:	90                   	nop
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <gettst>:
uint32 gettst()
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 24                	push   $0x24
  8019ba:	e8 ab fb ff ff       	call   80156a <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 25                	push   $0x25
  8019d6:	e8 8f fb ff ff       	call   80156a <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
  8019de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019e1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019e5:	75 07                	jne    8019ee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ec:	eb 05                	jmp    8019f3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 25                	push   $0x25
  801a07:	e8 5e fb ff ff       	call   80156a <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
  801a0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a12:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a16:	75 07                	jne    801a1f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a18:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1d:	eb 05                	jmp    801a24 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 25                	push   $0x25
  801a38:	e8 2d fb ff ff       	call   80156a <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
  801a40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a43:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a47:	75 07                	jne    801a50 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a49:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4e:	eb 05                	jmp    801a55 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 25                	push   $0x25
  801a69:	e8 fc fa ff ff       	call   80156a <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
  801a71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a74:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a78:	75 07                	jne    801a81 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7f:	eb 05                	jmp    801a86 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	ff 75 08             	pushl  0x8(%ebp)
  801a96:	6a 26                	push   $0x26
  801a98:	e8 cd fa ff ff       	call   80156a <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa0:	90                   	nop
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801aa7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aaa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	6a 00                	push   $0x0
  801ab5:	53                   	push   %ebx
  801ab6:	51                   	push   %ecx
  801ab7:	52                   	push   %edx
  801ab8:	50                   	push   %eax
  801ab9:	6a 27                	push   $0x27
  801abb:	e8 aa fa ff ff       	call   80156a <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801acb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	52                   	push   %edx
  801ad8:	50                   	push   %eax
  801ad9:	6a 28                	push   $0x28
  801adb:	e8 8a fa ff ff       	call   80156a <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ae8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	6a 00                	push   $0x0
  801af3:	51                   	push   %ecx
  801af4:	ff 75 10             	pushl  0x10(%ebp)
  801af7:	52                   	push   %edx
  801af8:	50                   	push   %eax
  801af9:	6a 29                	push   $0x29
  801afb:	e8 6a fa ff ff       	call   80156a <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	ff 75 10             	pushl  0x10(%ebp)
  801b0f:	ff 75 0c             	pushl  0xc(%ebp)
  801b12:	ff 75 08             	pushl  0x8(%ebp)
  801b15:	6a 12                	push   $0x12
  801b17:	e8 4e fa ff ff       	call   80156a <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1f:	90                   	nop
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	52                   	push   %edx
  801b32:	50                   	push   %eax
  801b33:	6a 2a                	push   $0x2a
  801b35:	e8 30 fa ff ff       	call   80156a <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
	return;
  801b3d:	90                   	nop
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	50                   	push   %eax
  801b4f:	6a 2b                	push   $0x2b
  801b51:	e8 14 fa ff ff       	call   80156a <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	ff 75 0c             	pushl  0xc(%ebp)
  801b67:	ff 75 08             	pushl  0x8(%ebp)
  801b6a:	6a 2c                	push   $0x2c
  801b6c:	e8 f9 f9 ff ff       	call   80156a <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
	return;
  801b74:	90                   	nop
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	ff 75 0c             	pushl  0xc(%ebp)
  801b83:	ff 75 08             	pushl  0x8(%ebp)
  801b86:	6a 2d                	push   $0x2d
  801b88:	e8 dd f9 ff ff       	call   80156a <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
	return;
  801b90:	90                   	nop
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    
  801b93:	90                   	nop

00801b94 <__udivdi3>:
  801b94:	55                   	push   %ebp
  801b95:	57                   	push   %edi
  801b96:	56                   	push   %esi
  801b97:	53                   	push   %ebx
  801b98:	83 ec 1c             	sub    $0x1c,%esp
  801b9b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b9f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ba3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ba7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bab:	89 ca                	mov    %ecx,%edx
  801bad:	89 f8                	mov    %edi,%eax
  801baf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bb3:	85 f6                	test   %esi,%esi
  801bb5:	75 2d                	jne    801be4 <__udivdi3+0x50>
  801bb7:	39 cf                	cmp    %ecx,%edi
  801bb9:	77 65                	ja     801c20 <__udivdi3+0x8c>
  801bbb:	89 fd                	mov    %edi,%ebp
  801bbd:	85 ff                	test   %edi,%edi
  801bbf:	75 0b                	jne    801bcc <__udivdi3+0x38>
  801bc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc6:	31 d2                	xor    %edx,%edx
  801bc8:	f7 f7                	div    %edi
  801bca:	89 c5                	mov    %eax,%ebp
  801bcc:	31 d2                	xor    %edx,%edx
  801bce:	89 c8                	mov    %ecx,%eax
  801bd0:	f7 f5                	div    %ebp
  801bd2:	89 c1                	mov    %eax,%ecx
  801bd4:	89 d8                	mov    %ebx,%eax
  801bd6:	f7 f5                	div    %ebp
  801bd8:	89 cf                	mov    %ecx,%edi
  801bda:	89 fa                	mov    %edi,%edx
  801bdc:	83 c4 1c             	add    $0x1c,%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5f                   	pop    %edi
  801be2:	5d                   	pop    %ebp
  801be3:	c3                   	ret    
  801be4:	39 ce                	cmp    %ecx,%esi
  801be6:	77 28                	ja     801c10 <__udivdi3+0x7c>
  801be8:	0f bd fe             	bsr    %esi,%edi
  801beb:	83 f7 1f             	xor    $0x1f,%edi
  801bee:	75 40                	jne    801c30 <__udivdi3+0x9c>
  801bf0:	39 ce                	cmp    %ecx,%esi
  801bf2:	72 0a                	jb     801bfe <__udivdi3+0x6a>
  801bf4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bf8:	0f 87 9e 00 00 00    	ja     801c9c <__udivdi3+0x108>
  801bfe:	b8 01 00 00 00       	mov    $0x1,%eax
  801c03:	89 fa                	mov    %edi,%edx
  801c05:	83 c4 1c             	add    $0x1c,%esp
  801c08:	5b                   	pop    %ebx
  801c09:	5e                   	pop    %esi
  801c0a:	5f                   	pop    %edi
  801c0b:	5d                   	pop    %ebp
  801c0c:	c3                   	ret    
  801c0d:	8d 76 00             	lea    0x0(%esi),%esi
  801c10:	31 ff                	xor    %edi,%edi
  801c12:	31 c0                	xor    %eax,%eax
  801c14:	89 fa                	mov    %edi,%edx
  801c16:	83 c4 1c             	add    $0x1c,%esp
  801c19:	5b                   	pop    %ebx
  801c1a:	5e                   	pop    %esi
  801c1b:	5f                   	pop    %edi
  801c1c:	5d                   	pop    %ebp
  801c1d:	c3                   	ret    
  801c1e:	66 90                	xchg   %ax,%ax
  801c20:	89 d8                	mov    %ebx,%eax
  801c22:	f7 f7                	div    %edi
  801c24:	31 ff                	xor    %edi,%edi
  801c26:	89 fa                	mov    %edi,%edx
  801c28:	83 c4 1c             	add    $0x1c,%esp
  801c2b:	5b                   	pop    %ebx
  801c2c:	5e                   	pop    %esi
  801c2d:	5f                   	pop    %edi
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    
  801c30:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c35:	89 eb                	mov    %ebp,%ebx
  801c37:	29 fb                	sub    %edi,%ebx
  801c39:	89 f9                	mov    %edi,%ecx
  801c3b:	d3 e6                	shl    %cl,%esi
  801c3d:	89 c5                	mov    %eax,%ebp
  801c3f:	88 d9                	mov    %bl,%cl
  801c41:	d3 ed                	shr    %cl,%ebp
  801c43:	89 e9                	mov    %ebp,%ecx
  801c45:	09 f1                	or     %esi,%ecx
  801c47:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c4b:	89 f9                	mov    %edi,%ecx
  801c4d:	d3 e0                	shl    %cl,%eax
  801c4f:	89 c5                	mov    %eax,%ebp
  801c51:	89 d6                	mov    %edx,%esi
  801c53:	88 d9                	mov    %bl,%cl
  801c55:	d3 ee                	shr    %cl,%esi
  801c57:	89 f9                	mov    %edi,%ecx
  801c59:	d3 e2                	shl    %cl,%edx
  801c5b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c5f:	88 d9                	mov    %bl,%cl
  801c61:	d3 e8                	shr    %cl,%eax
  801c63:	09 c2                	or     %eax,%edx
  801c65:	89 d0                	mov    %edx,%eax
  801c67:	89 f2                	mov    %esi,%edx
  801c69:	f7 74 24 0c          	divl   0xc(%esp)
  801c6d:	89 d6                	mov    %edx,%esi
  801c6f:	89 c3                	mov    %eax,%ebx
  801c71:	f7 e5                	mul    %ebp
  801c73:	39 d6                	cmp    %edx,%esi
  801c75:	72 19                	jb     801c90 <__udivdi3+0xfc>
  801c77:	74 0b                	je     801c84 <__udivdi3+0xf0>
  801c79:	89 d8                	mov    %ebx,%eax
  801c7b:	31 ff                	xor    %edi,%edi
  801c7d:	e9 58 ff ff ff       	jmp    801bda <__udivdi3+0x46>
  801c82:	66 90                	xchg   %ax,%ax
  801c84:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c88:	89 f9                	mov    %edi,%ecx
  801c8a:	d3 e2                	shl    %cl,%edx
  801c8c:	39 c2                	cmp    %eax,%edx
  801c8e:	73 e9                	jae    801c79 <__udivdi3+0xe5>
  801c90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c93:	31 ff                	xor    %edi,%edi
  801c95:	e9 40 ff ff ff       	jmp    801bda <__udivdi3+0x46>
  801c9a:	66 90                	xchg   %ax,%ax
  801c9c:	31 c0                	xor    %eax,%eax
  801c9e:	e9 37 ff ff ff       	jmp    801bda <__udivdi3+0x46>
  801ca3:	90                   	nop

00801ca4 <__umoddi3>:
  801ca4:	55                   	push   %ebp
  801ca5:	57                   	push   %edi
  801ca6:	56                   	push   %esi
  801ca7:	53                   	push   %ebx
  801ca8:	83 ec 1c             	sub    $0x1c,%esp
  801cab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801caf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cb7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cbb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cbf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cc3:	89 f3                	mov    %esi,%ebx
  801cc5:	89 fa                	mov    %edi,%edx
  801cc7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ccb:	89 34 24             	mov    %esi,(%esp)
  801cce:	85 c0                	test   %eax,%eax
  801cd0:	75 1a                	jne    801cec <__umoddi3+0x48>
  801cd2:	39 f7                	cmp    %esi,%edi
  801cd4:	0f 86 a2 00 00 00    	jbe    801d7c <__umoddi3+0xd8>
  801cda:	89 c8                	mov    %ecx,%eax
  801cdc:	89 f2                	mov    %esi,%edx
  801cde:	f7 f7                	div    %edi
  801ce0:	89 d0                	mov    %edx,%eax
  801ce2:	31 d2                	xor    %edx,%edx
  801ce4:	83 c4 1c             	add    $0x1c,%esp
  801ce7:	5b                   	pop    %ebx
  801ce8:	5e                   	pop    %esi
  801ce9:	5f                   	pop    %edi
  801cea:	5d                   	pop    %ebp
  801ceb:	c3                   	ret    
  801cec:	39 f0                	cmp    %esi,%eax
  801cee:	0f 87 ac 00 00 00    	ja     801da0 <__umoddi3+0xfc>
  801cf4:	0f bd e8             	bsr    %eax,%ebp
  801cf7:	83 f5 1f             	xor    $0x1f,%ebp
  801cfa:	0f 84 ac 00 00 00    	je     801dac <__umoddi3+0x108>
  801d00:	bf 20 00 00 00       	mov    $0x20,%edi
  801d05:	29 ef                	sub    %ebp,%edi
  801d07:	89 fe                	mov    %edi,%esi
  801d09:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d0d:	89 e9                	mov    %ebp,%ecx
  801d0f:	d3 e0                	shl    %cl,%eax
  801d11:	89 d7                	mov    %edx,%edi
  801d13:	89 f1                	mov    %esi,%ecx
  801d15:	d3 ef                	shr    %cl,%edi
  801d17:	09 c7                	or     %eax,%edi
  801d19:	89 e9                	mov    %ebp,%ecx
  801d1b:	d3 e2                	shl    %cl,%edx
  801d1d:	89 14 24             	mov    %edx,(%esp)
  801d20:	89 d8                	mov    %ebx,%eax
  801d22:	d3 e0                	shl    %cl,%eax
  801d24:	89 c2                	mov    %eax,%edx
  801d26:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d2a:	d3 e0                	shl    %cl,%eax
  801d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d30:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d34:	89 f1                	mov    %esi,%ecx
  801d36:	d3 e8                	shr    %cl,%eax
  801d38:	09 d0                	or     %edx,%eax
  801d3a:	d3 eb                	shr    %cl,%ebx
  801d3c:	89 da                	mov    %ebx,%edx
  801d3e:	f7 f7                	div    %edi
  801d40:	89 d3                	mov    %edx,%ebx
  801d42:	f7 24 24             	mull   (%esp)
  801d45:	89 c6                	mov    %eax,%esi
  801d47:	89 d1                	mov    %edx,%ecx
  801d49:	39 d3                	cmp    %edx,%ebx
  801d4b:	0f 82 87 00 00 00    	jb     801dd8 <__umoddi3+0x134>
  801d51:	0f 84 91 00 00 00    	je     801de8 <__umoddi3+0x144>
  801d57:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d5b:	29 f2                	sub    %esi,%edx
  801d5d:	19 cb                	sbb    %ecx,%ebx
  801d5f:	89 d8                	mov    %ebx,%eax
  801d61:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d65:	d3 e0                	shl    %cl,%eax
  801d67:	89 e9                	mov    %ebp,%ecx
  801d69:	d3 ea                	shr    %cl,%edx
  801d6b:	09 d0                	or     %edx,%eax
  801d6d:	89 e9                	mov    %ebp,%ecx
  801d6f:	d3 eb                	shr    %cl,%ebx
  801d71:	89 da                	mov    %ebx,%edx
  801d73:	83 c4 1c             	add    $0x1c,%esp
  801d76:	5b                   	pop    %ebx
  801d77:	5e                   	pop    %esi
  801d78:	5f                   	pop    %edi
  801d79:	5d                   	pop    %ebp
  801d7a:	c3                   	ret    
  801d7b:	90                   	nop
  801d7c:	89 fd                	mov    %edi,%ebp
  801d7e:	85 ff                	test   %edi,%edi
  801d80:	75 0b                	jne    801d8d <__umoddi3+0xe9>
  801d82:	b8 01 00 00 00       	mov    $0x1,%eax
  801d87:	31 d2                	xor    %edx,%edx
  801d89:	f7 f7                	div    %edi
  801d8b:	89 c5                	mov    %eax,%ebp
  801d8d:	89 f0                	mov    %esi,%eax
  801d8f:	31 d2                	xor    %edx,%edx
  801d91:	f7 f5                	div    %ebp
  801d93:	89 c8                	mov    %ecx,%eax
  801d95:	f7 f5                	div    %ebp
  801d97:	89 d0                	mov    %edx,%eax
  801d99:	e9 44 ff ff ff       	jmp    801ce2 <__umoddi3+0x3e>
  801d9e:	66 90                	xchg   %ax,%ax
  801da0:	89 c8                	mov    %ecx,%eax
  801da2:	89 f2                	mov    %esi,%edx
  801da4:	83 c4 1c             	add    $0x1c,%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5f                   	pop    %edi
  801daa:	5d                   	pop    %ebp
  801dab:	c3                   	ret    
  801dac:	3b 04 24             	cmp    (%esp),%eax
  801daf:	72 06                	jb     801db7 <__umoddi3+0x113>
  801db1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801db5:	77 0f                	ja     801dc6 <__umoddi3+0x122>
  801db7:	89 f2                	mov    %esi,%edx
  801db9:	29 f9                	sub    %edi,%ecx
  801dbb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801dbf:	89 14 24             	mov    %edx,(%esp)
  801dc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dc6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dca:	8b 14 24             	mov    (%esp),%edx
  801dcd:	83 c4 1c             	add    $0x1c,%esp
  801dd0:	5b                   	pop    %ebx
  801dd1:	5e                   	pop    %esi
  801dd2:	5f                   	pop    %edi
  801dd3:	5d                   	pop    %ebp
  801dd4:	c3                   	ret    
  801dd5:	8d 76 00             	lea    0x0(%esi),%esi
  801dd8:	2b 04 24             	sub    (%esp),%eax
  801ddb:	19 fa                	sbb    %edi,%edx
  801ddd:	89 d1                	mov    %edx,%ecx
  801ddf:	89 c6                	mov    %eax,%esi
  801de1:	e9 71 ff ff ff       	jmp    801d57 <__umoddi3+0xb3>
  801de6:	66 90                	xchg   %ax,%ax
  801de8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dec:	72 ea                	jb     801dd8 <__umoddi3+0x134>
  801dee:	89 d9                	mov    %ebx,%ecx
  801df0:	e9 62 ff ff ff       	jmp    801d57 <__umoddi3+0xb3>
