
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
  80005c:	68 c0 3c 80 00       	push   $0x803cc0
  800061:	6a 0d                	push   $0xd
  800063:	68 dc 3c 80 00       	push   $0x803cdc
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
  800074:	e8 16 1c 00 00       	call   801c8f <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 79 19 00 00       	call   8019fa <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 27 1a 00 00       	call   801aad <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 f7 3c 80 00       	push   $0x803cf7
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 9a 17 00 00       	call   801833 <sget>
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
  8000b6:	68 fc 3c 80 00       	push   $0x803cfc
  8000bb:	6a 21                	push   $0x21
  8000bd:	68 dc 3c 80 00       	push   $0x803cdc
  8000c2:	e8 2a 03 00 00       	call   8003f1 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 d7 19 00 00       	call   801aad <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 c0 19 00 00       	call   801aad <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 78 3d 80 00       	push   $0x803d78
  8000fd:	6a 24                	push   $0x24
  8000ff:	68 dc 3c 80 00       	push   $0x803cdc
  800104:	e8 e8 02 00 00       	call   8003f1 <_panic>

	}
	sys_unlock_cons();
  800109:	e8 06 19 00 00       	call   801a14 <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 e7 18 00 00       	call   8019fa <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 95 19 00 00       	call   801aad <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = sget(parentenvID,"y");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 10 3e 80 00       	push   $0x803e10
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 08 17 00 00       	call   801833 <sget>
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
  80014d:	68 fc 3c 80 00       	push   $0x803cfc
  800152:	6a 30                	push   $0x30
  800154:	68 dc 3c 80 00       	push   $0x803cdc
  800159:	e8 93 02 00 00       	call   8003f1 <_panic>
		expected = 0 ;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 40 19 00 00       	call   801aad <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 29 19 00 00       	call   801aad <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 78 3d 80 00       	push   $0x803d78
  800194:	6a 33                	push   $0x33
  800196:	68 dc 3c 80 00       	push   $0x803cdc
  80019b:	e8 51 02 00 00       	call   8003f1 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 6f 18 00 00       	call   801a14 <sys_unlock_cons>
	//sys_unlock_cons();
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 14             	cmp    $0x14,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 14 3e 80 00       	push   $0x803e14
  8001b7:	6a 37                	push   $0x37
  8001b9:	68 dc 3c 80 00       	push   $0x803cdc
  8001be:	e8 2e 02 00 00       	call   8003f1 <_panic>
	//sys_lock_cons();
	sys_lock_cons();
  8001c3:	e8 32 18 00 00       	call   8019fa <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  8001c8:	e8 e0 18 00 00       	call   801aad <sys_calculate_free_frames>
  8001cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	68 4b 3e 80 00       	push   $0x803e4b
  8001d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8001db:	e8 53 16 00 00       	call   801833 <sget>
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
  800202:	68 fc 3c 80 00       	push   $0x803cfc
  800207:	6a 3e                	push   $0x3e
  800209:	68 dc 3c 80 00       	push   $0x803cdc
  80020e:	e8 de 01 00 00       	call   8003f1 <_panic>
		expected = 0 ;
  800213:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80021a:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80021d:	e8 8b 18 00 00       	call   801aad <sys_calculate_free_frames>
  800222:	29 c3                	sub    %eax,%ebx
  800224:	89 d8                	mov    %ebx,%eax
  800226:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800229:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022f:	74 24                	je     800255 <_main+0x21d>
  800231:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800234:	e8 74 18 00 00       	call   801aad <sys_calculate_free_frames>
  800239:	29 c3                	sub    %eax,%ebx
  80023b:	89 d8                	mov    %ebx,%eax
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	ff 75 e0             	pushl  -0x20(%ebp)
  800243:	50                   	push   %eax
  800244:	68 78 3d 80 00       	push   $0x803d78
  800249:	6a 41                	push   $0x41
  80024b:	68 dc 3c 80 00       	push   $0x803cdc
  800250:	e8 9c 01 00 00       	call   8003f1 <_panic>
	}
	sys_unlock_cons();
  800255:	e8 ba 17 00 00       	call   801a14 <sys_unlock_cons>
	//sys_unlock_cons();
	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  80025a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80025d:	8b 00                	mov    (%eax),%eax
  80025f:	83 f8 0a             	cmp    $0xa,%eax
  800262:	74 14                	je     800278 <_main+0x240>
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	68 14 3e 80 00       	push   $0x803e14
  80026c:	6a 45                	push   $0x45
  80026e:	68 dc 3c 80 00       	push   $0x803cdc
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
  800296:	68 14 3e 80 00       	push   $0x803e14
  80029b:	6a 48                	push   $0x48
  80029d:	68 dc 3c 80 00       	push   $0x803cdc
  8002a2:	e8 4a 01 00 00       	call   8003f1 <_panic>

	//To indicate that it's completed successfully
	inctst();
  8002a7:	e8 08 1b 00 00       	call   801db4 <inctst>

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
  8002b8:	e8 b9 19 00 00       	call   801c76 <sys_getenvindex>
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
  800326:	e8 cf 16 00 00       	call   8019fa <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80032b:	83 ec 0c             	sub    $0xc,%esp
  80032e:	68 68 3e 80 00       	push   $0x803e68
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
  800356:	68 90 3e 80 00       	push   $0x803e90
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
  800387:	68 b8 3e 80 00       	push   $0x803eb8
  80038c:	e8 1d 03 00 00       	call   8006ae <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800394:	a1 20 50 80 00       	mov    0x805020,%eax
  800399:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80039f:	83 ec 08             	sub    $0x8,%esp
  8003a2:	50                   	push   %eax
  8003a3:	68 10 3f 80 00       	push   $0x803f10
  8003a8:	e8 01 03 00 00       	call   8006ae <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003b0:	83 ec 0c             	sub    $0xc,%esp
  8003b3:	68 68 3e 80 00       	push   $0x803e68
  8003b8:	e8 f1 02 00 00       	call   8006ae <cprintf>
  8003bd:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003c0:	e8 4f 16 00 00       	call   801a14 <sys_unlock_cons>
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
  8003d8:	e8 65 18 00 00       	call   801c42 <sys_destroy_env>
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
  8003e9:	e8 ba 18 00 00       	call   801ca8 <sys_exit_env>
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
  800412:	68 24 3f 80 00       	push   $0x803f24
  800417:	e8 92 02 00 00       	call   8006ae <cprintf>
  80041c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80041f:	a1 00 50 80 00       	mov    0x805000,%eax
  800424:	ff 75 0c             	pushl  0xc(%ebp)
  800427:	ff 75 08             	pushl  0x8(%ebp)
  80042a:	50                   	push   %eax
  80042b:	68 29 3f 80 00       	push   $0x803f29
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
  80044f:	68 45 3f 80 00       	push   $0x803f45
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
  80047e:	68 48 3f 80 00       	push   $0x803f48
  800483:	6a 26                	push   $0x26
  800485:	68 94 3f 80 00       	push   $0x803f94
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
  800553:	68 a0 3f 80 00       	push   $0x803fa0
  800558:	6a 3a                	push   $0x3a
  80055a:	68 94 3f 80 00       	push   $0x803f94
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
  8005c6:	68 f4 3f 80 00       	push   $0x803ff4
  8005cb:	6a 44                	push   $0x44
  8005cd:	68 94 3f 80 00       	push   $0x803f94
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
  800620:	e8 93 13 00 00       	call   8019b8 <sys_cputs>
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
  800697:	e8 1c 13 00 00       	call   8019b8 <sys_cputs>
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
  8006e1:	e8 14 13 00 00       	call   8019fa <sys_lock_cons>
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
  800701:	e8 0e 13 00 00       	call   801a14 <sys_unlock_cons>
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
  80074b:	e8 00 33 00 00       	call   803a50 <__udivdi3>
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
  80079b:	e8 c0 33 00 00       	call   803b60 <__umoddi3>
  8007a0:	83 c4 10             	add    $0x10,%esp
  8007a3:	05 54 42 80 00       	add    $0x804254,%eax
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
  8008f6:	8b 04 85 78 42 80 00 	mov    0x804278(,%eax,4),%eax
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
  8009d7:	8b 34 9d c0 40 80 00 	mov    0x8040c0(,%ebx,4),%esi
  8009de:	85 f6                	test   %esi,%esi
  8009e0:	75 19                	jne    8009fb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e2:	53                   	push   %ebx
  8009e3:	68 65 42 80 00       	push   $0x804265
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
  8009fc:	68 6e 42 80 00       	push   $0x80426e
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
  800a29:	be 71 42 80 00       	mov    $0x804271,%esi
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
  801434:	68 e8 43 80 00       	push   $0x8043e8
  801439:	68 3f 01 00 00       	push   $0x13f
  80143e:	68 0a 44 80 00       	push   $0x80440a
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
  801454:	e8 0a 0b 00 00       	call   801f63 <sys_sbrk>
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
  8014cf:	e8 13 09 00 00       	call   801de7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	74 16                	je     8014ee <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	ff 75 08             	pushl  0x8(%ebp)
  8014de:	e8 53 0e 00 00       	call   802336 <alloc_block_FF>
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e9:	e9 8a 01 00 00       	jmp    801678 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014ee:	e8 25 09 00 00       	call   801e18 <sys_isUHeapPlacementStrategyBESTFIT>
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	0f 84 7d 01 00 00    	je     801678 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014fb:	83 ec 0c             	sub    $0xc,%esp
  8014fe:	ff 75 08             	pushl  0x8(%ebp)
  801501:	e8 ec 12 00 00       	call   8027f2 <alloc_block_BF>
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
  801551:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  80159e:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  8015f5:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
  801657:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  80165e:	83 ec 08             	sub    $0x8,%esp
  801661:	ff 75 08             	pushl  0x8(%ebp)
  801664:	ff 75 f0             	pushl  -0x10(%ebp)
  801667:	e8 2e 09 00 00       	call   801f9a <sys_allocate_user_mem>
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
  8016af:	e8 02 09 00 00       	call   801fb6 <get_block_size>
  8016b4:	83 c4 10             	add    $0x10,%esp
  8016b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016ba:	83 ec 0c             	sub    $0xc,%esp
  8016bd:	ff 75 08             	pushl  0x8(%ebp)
  8016c0:	e8 35 1b 00 00       	call   8031fa <free_block>
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
  8016fa:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  801737:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  801757:	e8 22 08 00 00       	call   801f7e <sys_free_user_mem>
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
  801765:	68 18 44 80 00       	push   $0x804418
  80176a:	68 85 00 00 00       	push   $0x85
  80176f:	68 42 44 80 00       	push   $0x804442
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
  80178b:	75 0a                	jne    801797 <smalloc+0x1c>
  80178d:	b8 00 00 00 00       	mov    $0x0,%eax
  801792:	e9 9a 00 00 00       	jmp    801831 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801797:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80179d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017aa:	39 d0                	cmp    %edx,%eax
  8017ac:	73 02                	jae    8017b0 <smalloc+0x35>
  8017ae:	89 d0                	mov    %edx,%eax
  8017b0:	83 ec 0c             	sub    $0xc,%esp
  8017b3:	50                   	push   %eax
  8017b4:	e8 a5 fc ff ff       	call   80145e <malloc>
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8017bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017c3:	75 07                	jne    8017cc <smalloc+0x51>
  8017c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ca:	eb 65                	jmp    801831 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017cc:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8017d3:	50                   	push   %eax
  8017d4:	ff 75 0c             	pushl  0xc(%ebp)
  8017d7:	ff 75 08             	pushl  0x8(%ebp)
  8017da:	e8 a6 03 00 00       	call   801b85 <sys_createSharedObject>
  8017df:	83 c4 10             	add    $0x10,%esp
  8017e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017e5:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017e9:	74 06                	je     8017f1 <smalloc+0x76>
  8017eb:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017ef:	75 07                	jne    8017f8 <smalloc+0x7d>
  8017f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f6:	eb 39                	jmp    801831 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  8017f8:	83 ec 08             	sub    $0x8,%esp
  8017fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8017fe:	68 4e 44 80 00       	push   $0x80444e
  801803:	e8 a6 ee ff ff       	call   8006ae <cprintf>
  801808:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  80180b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80180e:	a1 20 50 80 00       	mov    0x805020,%eax
  801813:	8b 40 78             	mov    0x78(%eax),%eax
  801816:	29 c2                	sub    %eax,%edx
  801818:	89 d0                	mov    %edx,%eax
  80181a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80181f:	c1 e8 0c             	shr    $0xc,%eax
  801822:	89 c2                	mov    %eax,%edx
  801824:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801827:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  80182e:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801839:	83 ec 08             	sub    $0x8,%esp
  80183c:	ff 75 0c             	pushl  0xc(%ebp)
  80183f:	ff 75 08             	pushl  0x8(%ebp)
  801842:	e8 68 03 00 00       	call   801baf <sys_getSizeOfSharedObject>
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80184d:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801851:	75 07                	jne    80185a <sget+0x27>
  801853:	b8 00 00 00 00       	mov    $0x0,%eax
  801858:	eb 7f                	jmp    8018d9 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80185a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801860:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801867:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80186a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186d:	39 d0                	cmp    %edx,%eax
  80186f:	7d 02                	jge    801873 <sget+0x40>
  801871:	89 d0                	mov    %edx,%eax
  801873:	83 ec 0c             	sub    $0xc,%esp
  801876:	50                   	push   %eax
  801877:	e8 e2 fb ff ff       	call   80145e <malloc>
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801882:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801886:	75 07                	jne    80188f <sget+0x5c>
  801888:	b8 00 00 00 00       	mov    $0x0,%eax
  80188d:	eb 4a                	jmp    8018d9 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80188f:	83 ec 04             	sub    $0x4,%esp
  801892:	ff 75 e8             	pushl  -0x18(%ebp)
  801895:	ff 75 0c             	pushl  0xc(%ebp)
  801898:	ff 75 08             	pushl  0x8(%ebp)
  80189b:	e8 2c 03 00 00       	call   801bcc <sys_getSharedObject>
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8018a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8018ae:	8b 40 78             	mov    0x78(%eax),%eax
  8018b1:	29 c2                	sub    %eax,%edx
  8018b3:	89 d0                	mov    %edx,%eax
  8018b5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018ba:	c1 e8 0c             	shr    $0xc,%eax
  8018bd:	89 c2                	mov    %eax,%edx
  8018bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018c2:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8018c9:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018cd:	75 07                	jne    8018d6 <sget+0xa3>
  8018cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d4:	eb 03                	jmp    8018d9 <sget+0xa6>
	return ptr;
  8018d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8018e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8018e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8018e9:	8b 40 78             	mov    0x78(%eax),%eax
  8018ec:	29 c2                	sub    %eax,%edx
  8018ee:	89 d0                	mov    %edx,%eax
  8018f0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018f5:	c1 e8 0c             	shr    $0xc,%eax
  8018f8:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8018ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801902:	83 ec 08             	sub    $0x8,%esp
  801905:	ff 75 08             	pushl  0x8(%ebp)
  801908:	ff 75 f4             	pushl  -0xc(%ebp)
  80190b:	e8 db 02 00 00       	call   801beb <sys_freeSharedObject>
  801910:	83 c4 10             	add    $0x10,%esp
  801913:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801916:	90                   	nop
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80191f:	83 ec 04             	sub    $0x4,%esp
  801922:	68 60 44 80 00       	push   $0x804460
  801927:	68 de 00 00 00       	push   $0xde
  80192c:	68 42 44 80 00       	push   $0x804442
  801931:	e8 bb ea ff ff       	call   8003f1 <_panic>

00801936 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80193c:	83 ec 04             	sub    $0x4,%esp
  80193f:	68 86 44 80 00       	push   $0x804486
  801944:	68 ea 00 00 00       	push   $0xea
  801949:	68 42 44 80 00       	push   $0x804442
  80194e:	e8 9e ea ff ff       	call   8003f1 <_panic>

00801953 <shrink>:

}
void shrink(uint32 newSize)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801959:	83 ec 04             	sub    $0x4,%esp
  80195c:	68 86 44 80 00       	push   $0x804486
  801961:	68 ef 00 00 00       	push   $0xef
  801966:	68 42 44 80 00       	push   $0x804442
  80196b:	e8 81 ea ff ff       	call   8003f1 <_panic>

00801970 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801976:	83 ec 04             	sub    $0x4,%esp
  801979:	68 86 44 80 00       	push   $0x804486
  80197e:	68 f4 00 00 00       	push   $0xf4
  801983:	68 42 44 80 00       	push   $0x804442
  801988:	e8 64 ea ff ff       	call   8003f1 <_panic>

0080198d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	57                   	push   %edi
  801991:	56                   	push   %esi
  801992:	53                   	push   %ebx
  801993:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80199f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019a2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019a5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019a8:	cd 30                	int    $0x30
  8019aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019b0:	83 c4 10             	add    $0x10,%esp
  8019b3:	5b                   	pop    %ebx
  8019b4:	5e                   	pop    %esi
  8019b5:	5f                   	pop    %edi
  8019b6:	5d                   	pop    %ebp
  8019b7:	c3                   	ret    

008019b8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 04             	sub    $0x4,%esp
  8019be:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019c4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	52                   	push   %edx
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	50                   	push   %eax
  8019d4:	6a 00                	push   $0x0
  8019d6:	e8 b2 ff ff ff       	call   80198d <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	90                   	nop
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 02                	push   $0x2
  8019f0:	e8 98 ff ff ff       	call   80198d <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 03                	push   $0x3
  801a09:	e8 7f ff ff ff       	call   80198d <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	90                   	nop
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 04                	push   $0x4
  801a23:	e8 65 ff ff ff       	call   80198d <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	90                   	nop
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	52                   	push   %edx
  801a3e:	50                   	push   %eax
  801a3f:	6a 08                	push   $0x8
  801a41:	e8 47 ff ff ff       	call   80198d <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	56                   	push   %esi
  801a4f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a50:	8b 75 18             	mov    0x18(%ebp),%esi
  801a53:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a56:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	56                   	push   %esi
  801a60:	53                   	push   %ebx
  801a61:	51                   	push   %ecx
  801a62:	52                   	push   %edx
  801a63:	50                   	push   %eax
  801a64:	6a 09                	push   $0x9
  801a66:	e8 22 ff ff ff       	call   80198d <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
}
  801a6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a71:	5b                   	pop    %ebx
  801a72:	5e                   	pop    %esi
  801a73:	5d                   	pop    %ebp
  801a74:	c3                   	ret    

00801a75 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	52                   	push   %edx
  801a85:	50                   	push   %eax
  801a86:	6a 0a                	push   $0xa
  801a88:	e8 00 ff ff ff       	call   80198d <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	ff 75 0c             	pushl  0xc(%ebp)
  801a9e:	ff 75 08             	pushl  0x8(%ebp)
  801aa1:	6a 0b                	push   $0xb
  801aa3:	e8 e5 fe ff ff       	call   80198d <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 0c                	push   $0xc
  801abc:	e8 cc fe ff ff       	call   80198d <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 0d                	push   $0xd
  801ad5:	e8 b3 fe ff ff       	call   80198d <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 0e                	push   $0xe
  801aee:	e8 9a fe ff ff       	call   80198d <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 0f                	push   $0xf
  801b07:	e8 81 fe ff ff       	call   80198d <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	ff 75 08             	pushl  0x8(%ebp)
  801b1f:	6a 10                	push   $0x10
  801b21:	e8 67 fe ff ff       	call   80198d <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 11                	push   $0x11
  801b3a:	e8 4e fe ff ff       	call   80198d <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	90                   	nop
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 04             	sub    $0x4,%esp
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b51:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	50                   	push   %eax
  801b5e:	6a 01                	push   $0x1
  801b60:	e8 28 fe ff ff       	call   80198d <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	90                   	nop
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 14                	push   $0x14
  801b7a:	e8 0e fe ff ff       	call   80198d <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	90                   	nop
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	83 ec 04             	sub    $0x4,%esp
  801b8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b91:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b94:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	51                   	push   %ecx
  801b9e:	52                   	push   %edx
  801b9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ba2:	50                   	push   %eax
  801ba3:	6a 15                	push   $0x15
  801ba5:	e8 e3 fd ff ff       	call   80198d <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	52                   	push   %edx
  801bbf:	50                   	push   %eax
  801bc0:	6a 16                	push   $0x16
  801bc2:	e8 c6 fd ff ff       	call   80198d <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bcf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	51                   	push   %ecx
  801bdd:	52                   	push   %edx
  801bde:	50                   	push   %eax
  801bdf:	6a 17                	push   $0x17
  801be1:	e8 a7 fd ff ff       	call   80198d <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	52                   	push   %edx
  801bfb:	50                   	push   %eax
  801bfc:	6a 18                	push   $0x18
  801bfe:	e8 8a fd ff ff       	call   80198d <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	6a 00                	push   $0x0
  801c10:	ff 75 14             	pushl  0x14(%ebp)
  801c13:	ff 75 10             	pushl  0x10(%ebp)
  801c16:	ff 75 0c             	pushl  0xc(%ebp)
  801c19:	50                   	push   %eax
  801c1a:	6a 19                	push   $0x19
  801c1c:	e8 6c fd ff ff       	call   80198d <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	50                   	push   %eax
  801c35:	6a 1a                	push   $0x1a
  801c37:	e8 51 fd ff ff       	call   80198d <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
}
  801c3f:	90                   	nop
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	50                   	push   %eax
  801c51:	6a 1b                	push   $0x1b
  801c53:	e8 35 fd ff ff       	call   80198d <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 05                	push   $0x5
  801c6c:	e8 1c fd ff ff       	call   80198d <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 06                	push   $0x6
  801c85:	e8 03 fd ff ff       	call   80198d <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 07                	push   $0x7
  801c9e:	e8 ea fc ff ff       	call   80198d <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_exit_env>:


void sys_exit_env(void)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 1c                	push   $0x1c
  801cb7:	e8 d1 fc ff ff       	call   80198d <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	90                   	nop
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cc8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ccb:	8d 50 04             	lea    0x4(%eax),%edx
  801cce:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	52                   	push   %edx
  801cd8:	50                   	push   %eax
  801cd9:	6a 1d                	push   $0x1d
  801cdb:	e8 ad fc ff ff       	call   80198d <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
	return result;
  801ce3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ce9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cec:	89 01                	mov    %eax,(%ecx)
  801cee:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	c9                   	leave  
  801cf5:	c2 04 00             	ret    $0x4

00801cf8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	ff 75 10             	pushl  0x10(%ebp)
  801d02:	ff 75 0c             	pushl  0xc(%ebp)
  801d05:	ff 75 08             	pushl  0x8(%ebp)
  801d08:	6a 13                	push   $0x13
  801d0a:	e8 7e fc ff ff       	call   80198d <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d12:	90                   	nop
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 1e                	push   $0x1e
  801d24:	e8 64 fc ff ff       	call   80198d <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 04             	sub    $0x4,%esp
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d3a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	50                   	push   %eax
  801d47:	6a 1f                	push   $0x1f
  801d49:	e8 3f fc ff ff       	call   80198d <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d51:	90                   	nop
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <rsttst>:
void rsttst()
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 21                	push   $0x21
  801d63:	e8 25 fc ff ff       	call   80198d <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6b:	90                   	nop
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 04             	sub    $0x4,%esp
  801d74:	8b 45 14             	mov    0x14(%ebp),%eax
  801d77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d7a:	8b 55 18             	mov    0x18(%ebp),%edx
  801d7d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d81:	52                   	push   %edx
  801d82:	50                   	push   %eax
  801d83:	ff 75 10             	pushl  0x10(%ebp)
  801d86:	ff 75 0c             	pushl  0xc(%ebp)
  801d89:	ff 75 08             	pushl  0x8(%ebp)
  801d8c:	6a 20                	push   $0x20
  801d8e:	e8 fa fb ff ff       	call   80198d <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
	return ;
  801d96:	90                   	nop
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <chktst>:
void chktst(uint32 n)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	ff 75 08             	pushl  0x8(%ebp)
  801da7:	6a 22                	push   $0x22
  801da9:	e8 df fb ff ff       	call   80198d <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
	return ;
  801db1:	90                   	nop
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <inctst>:

void inctst()
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 23                	push   $0x23
  801dc3:	e8 c5 fb ff ff       	call   80198d <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dcb:	90                   	nop
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <gettst>:
uint32 gettst()
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 24                	push   $0x24
  801ddd:	e8 ab fb ff ff       	call   80198d <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 25                	push   $0x25
  801df9:	e8 8f fb ff ff       	call   80198d <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
  801e01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e04:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e08:	75 07                	jne    801e11 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0f:	eb 05                	jmp    801e16 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 25                	push   $0x25
  801e2a:	e8 5e fb ff ff       	call   80198d <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
  801e32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e35:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e39:	75 07                	jne    801e42 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e40:	eb 05                	jmp    801e47 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 25                	push   $0x25
  801e5b:	e8 2d fb ff ff       	call   80198d <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
  801e63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e66:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e6a:	75 07                	jne    801e73 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e6c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e71:	eb 05                	jmp    801e78 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 25                	push   $0x25
  801e8c:	e8 fc fa ff ff       	call   80198d <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
  801e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e97:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e9b:	75 07                	jne    801ea4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea2:	eb 05                	jmp    801ea9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ea4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	ff 75 08             	pushl  0x8(%ebp)
  801eb9:	6a 26                	push   $0x26
  801ebb:	e8 cd fa ff ff       	call   80198d <syscall>
  801ec0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec3:	90                   	nop
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ecd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ed0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	6a 00                	push   $0x0
  801ed8:	53                   	push   %ebx
  801ed9:	51                   	push   %ecx
  801eda:	52                   	push   %edx
  801edb:	50                   	push   %eax
  801edc:	6a 27                	push   $0x27
  801ede:	e8 aa fa ff ff       	call   80198d <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
}
  801ee6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801eee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	52                   	push   %edx
  801efb:	50                   	push   %eax
  801efc:	6a 28                	push   $0x28
  801efe:	e8 8a fa ff ff       	call   80198d <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f0b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	6a 00                	push   $0x0
  801f16:	51                   	push   %ecx
  801f17:	ff 75 10             	pushl  0x10(%ebp)
  801f1a:	52                   	push   %edx
  801f1b:	50                   	push   %eax
  801f1c:	6a 29                	push   $0x29
  801f1e:	e8 6a fa ff ff       	call   80198d <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	ff 75 10             	pushl  0x10(%ebp)
  801f32:	ff 75 0c             	pushl  0xc(%ebp)
  801f35:	ff 75 08             	pushl  0x8(%ebp)
  801f38:	6a 12                	push   $0x12
  801f3a:	e8 4e fa ff ff       	call   80198d <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f42:	90                   	nop
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	52                   	push   %edx
  801f55:	50                   	push   %eax
  801f56:	6a 2a                	push   $0x2a
  801f58:	e8 30 fa ff ff       	call   80198d <syscall>
  801f5d:	83 c4 18             	add    $0x18,%esp
	return;
  801f60:	90                   	nop
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	50                   	push   %eax
  801f72:	6a 2b                	push   $0x2b
  801f74:	e8 14 fa ff ff       	call   80198d <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	ff 75 0c             	pushl  0xc(%ebp)
  801f8a:	ff 75 08             	pushl  0x8(%ebp)
  801f8d:	6a 2c                	push   $0x2c
  801f8f:	e8 f9 f9 ff ff       	call   80198d <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
	return;
  801f97:	90                   	nop
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	ff 75 0c             	pushl  0xc(%ebp)
  801fa6:	ff 75 08             	pushl  0x8(%ebp)
  801fa9:	6a 2d                	push   $0x2d
  801fab:	e8 dd f9 ff ff       	call   80198d <syscall>
  801fb0:	83 c4 18             	add    $0x18,%esp
	return;
  801fb3:	90                   	nop
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	83 e8 04             	sub    $0x4,%eax
  801fc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801fc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc8:	8b 00                	mov    (%eax),%eax
  801fca:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	83 e8 04             	sub    $0x4,%eax
  801fdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801fde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fe1:	8b 00                	mov    (%eax),%eax
  801fe3:	83 e0 01             	and    $0x1,%eax
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	0f 94 c0             	sete   %al
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801ff3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffd:	83 f8 02             	cmp    $0x2,%eax
  802000:	74 2b                	je     80202d <alloc_block+0x40>
  802002:	83 f8 02             	cmp    $0x2,%eax
  802005:	7f 07                	jg     80200e <alloc_block+0x21>
  802007:	83 f8 01             	cmp    $0x1,%eax
  80200a:	74 0e                	je     80201a <alloc_block+0x2d>
  80200c:	eb 58                	jmp    802066 <alloc_block+0x79>
  80200e:	83 f8 03             	cmp    $0x3,%eax
  802011:	74 2d                	je     802040 <alloc_block+0x53>
  802013:	83 f8 04             	cmp    $0x4,%eax
  802016:	74 3b                	je     802053 <alloc_block+0x66>
  802018:	eb 4c                	jmp    802066 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80201a:	83 ec 0c             	sub    $0xc,%esp
  80201d:	ff 75 08             	pushl  0x8(%ebp)
  802020:	e8 11 03 00 00       	call   802336 <alloc_block_FF>
  802025:	83 c4 10             	add    $0x10,%esp
  802028:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80202b:	eb 4a                	jmp    802077 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80202d:	83 ec 0c             	sub    $0xc,%esp
  802030:	ff 75 08             	pushl  0x8(%ebp)
  802033:	e8 fa 19 00 00       	call   803a32 <alloc_block_NF>
  802038:	83 c4 10             	add    $0x10,%esp
  80203b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80203e:	eb 37                	jmp    802077 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802040:	83 ec 0c             	sub    $0xc,%esp
  802043:	ff 75 08             	pushl  0x8(%ebp)
  802046:	e8 a7 07 00 00       	call   8027f2 <alloc_block_BF>
  80204b:	83 c4 10             	add    $0x10,%esp
  80204e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802051:	eb 24                	jmp    802077 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802053:	83 ec 0c             	sub    $0xc,%esp
  802056:	ff 75 08             	pushl  0x8(%ebp)
  802059:	e8 b7 19 00 00       	call   803a15 <alloc_block_WF>
  80205e:	83 c4 10             	add    $0x10,%esp
  802061:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802064:	eb 11                	jmp    802077 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802066:	83 ec 0c             	sub    $0xc,%esp
  802069:	68 98 44 80 00       	push   $0x804498
  80206e:	e8 3b e6 ff ff       	call   8006ae <cprintf>
  802073:	83 c4 10             	add    $0x10,%esp
		break;
  802076:	90                   	nop
	}
	return va;
  802077:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	53                   	push   %ebx
  802080:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802083:	83 ec 0c             	sub    $0xc,%esp
  802086:	68 b8 44 80 00       	push   $0x8044b8
  80208b:	e8 1e e6 ff ff       	call   8006ae <cprintf>
  802090:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802093:	83 ec 0c             	sub    $0xc,%esp
  802096:	68 e3 44 80 00       	push   $0x8044e3
  80209b:	e8 0e e6 ff ff       	call   8006ae <cprintf>
  8020a0:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a9:	eb 37                	jmp    8020e2 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8020ab:	83 ec 0c             	sub    $0xc,%esp
  8020ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b1:	e8 19 ff ff ff       	call   801fcf <is_free_block>
  8020b6:	83 c4 10             	add    $0x10,%esp
  8020b9:	0f be d8             	movsbl %al,%ebx
  8020bc:	83 ec 0c             	sub    $0xc,%esp
  8020bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c2:	e8 ef fe ff ff       	call   801fb6 <get_block_size>
  8020c7:	83 c4 10             	add    $0x10,%esp
  8020ca:	83 ec 04             	sub    $0x4,%esp
  8020cd:	53                   	push   %ebx
  8020ce:	50                   	push   %eax
  8020cf:	68 fb 44 80 00       	push   $0x8044fb
  8020d4:	e8 d5 e5 ff ff       	call   8006ae <cprintf>
  8020d9:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8020dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8020df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e6:	74 07                	je     8020ef <print_blocks_list+0x73>
  8020e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020eb:	8b 00                	mov    (%eax),%eax
  8020ed:	eb 05                	jmp    8020f4 <print_blocks_list+0x78>
  8020ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f4:	89 45 10             	mov    %eax,0x10(%ebp)
  8020f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	75 ad                	jne    8020ab <print_blocks_list+0x2f>
  8020fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802102:	75 a7                	jne    8020ab <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802104:	83 ec 0c             	sub    $0xc,%esp
  802107:	68 b8 44 80 00       	push   $0x8044b8
  80210c:	e8 9d e5 ff ff       	call   8006ae <cprintf>
  802111:	83 c4 10             	add    $0x10,%esp

}
  802114:	90                   	nop
  802115:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802120:	8b 45 0c             	mov    0xc(%ebp),%eax
  802123:	83 e0 01             	and    $0x1,%eax
  802126:	85 c0                	test   %eax,%eax
  802128:	74 03                	je     80212d <initialize_dynamic_allocator+0x13>
  80212a:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80212d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802131:	0f 84 c7 01 00 00    	je     8022fe <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802137:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80213e:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802141:	8b 55 08             	mov    0x8(%ebp),%edx
  802144:	8b 45 0c             	mov    0xc(%ebp),%eax
  802147:	01 d0                	add    %edx,%eax
  802149:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80214e:	0f 87 ad 01 00 00    	ja     802301 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	85 c0                	test   %eax,%eax
  802159:	0f 89 a5 01 00 00    	jns    802304 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80215f:	8b 55 08             	mov    0x8(%ebp),%edx
  802162:	8b 45 0c             	mov    0xc(%ebp),%eax
  802165:	01 d0                	add    %edx,%eax
  802167:	83 e8 04             	sub    $0x4,%eax
  80216a:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80216f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802176:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80217b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217e:	e9 87 00 00 00       	jmp    80220a <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802183:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802187:	75 14                	jne    80219d <initialize_dynamic_allocator+0x83>
  802189:	83 ec 04             	sub    $0x4,%esp
  80218c:	68 13 45 80 00       	push   $0x804513
  802191:	6a 79                	push   $0x79
  802193:	68 31 45 80 00       	push   $0x804531
  802198:	e8 54 e2 ff ff       	call   8003f1 <_panic>
  80219d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a0:	8b 00                	mov    (%eax),%eax
  8021a2:	85 c0                	test   %eax,%eax
  8021a4:	74 10                	je     8021b6 <initialize_dynamic_allocator+0x9c>
  8021a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a9:	8b 00                	mov    (%eax),%eax
  8021ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ae:	8b 52 04             	mov    0x4(%edx),%edx
  8021b1:	89 50 04             	mov    %edx,0x4(%eax)
  8021b4:	eb 0b                	jmp    8021c1 <initialize_dynamic_allocator+0xa7>
  8021b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b9:	8b 40 04             	mov    0x4(%eax),%eax
  8021bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8021c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c4:	8b 40 04             	mov    0x4(%eax),%eax
  8021c7:	85 c0                	test   %eax,%eax
  8021c9:	74 0f                	je     8021da <initialize_dynamic_allocator+0xc0>
  8021cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ce:	8b 40 04             	mov    0x4(%eax),%eax
  8021d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d4:	8b 12                	mov    (%edx),%edx
  8021d6:	89 10                	mov    %edx,(%eax)
  8021d8:	eb 0a                	jmp    8021e4 <initialize_dynamic_allocator+0xca>
  8021da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dd:	8b 00                	mov    (%eax),%eax
  8021df:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8021fc:	48                   	dec    %eax
  8021fd:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802202:	a1 34 50 80 00       	mov    0x805034,%eax
  802207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80220a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220e:	74 07                	je     802217 <initialize_dynamic_allocator+0xfd>
  802210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802213:	8b 00                	mov    (%eax),%eax
  802215:	eb 05                	jmp    80221c <initialize_dynamic_allocator+0x102>
  802217:	b8 00 00 00 00       	mov    $0x0,%eax
  80221c:	a3 34 50 80 00       	mov    %eax,0x805034
  802221:	a1 34 50 80 00       	mov    0x805034,%eax
  802226:	85 c0                	test   %eax,%eax
  802228:	0f 85 55 ff ff ff    	jne    802183 <initialize_dynamic_allocator+0x69>
  80222e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802232:	0f 85 4b ff ff ff    	jne    802183 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80223e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802241:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802247:	a1 44 50 80 00       	mov    0x805044,%eax
  80224c:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802251:	a1 40 50 80 00       	mov    0x805040,%eax
  802256:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	83 c0 08             	add    $0x8,%eax
  802262:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	83 c0 04             	add    $0x4,%eax
  80226b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226e:	83 ea 08             	sub    $0x8,%edx
  802271:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802273:	8b 55 0c             	mov    0xc(%ebp),%edx
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	01 d0                	add    %edx,%eax
  80227b:	83 e8 08             	sub    $0x8,%eax
  80227e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802281:	83 ea 08             	sub    $0x8,%edx
  802284:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802286:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802289:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80228f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802292:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802299:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80229d:	75 17                	jne    8022b6 <initialize_dynamic_allocator+0x19c>
  80229f:	83 ec 04             	sub    $0x4,%esp
  8022a2:	68 4c 45 80 00       	push   $0x80454c
  8022a7:	68 90 00 00 00       	push   $0x90
  8022ac:	68 31 45 80 00       	push   $0x804531
  8022b1:	e8 3b e1 ff ff       	call   8003f1 <_panic>
  8022b6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022bf:	89 10                	mov    %edx,(%eax)
  8022c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c4:	8b 00                	mov    (%eax),%eax
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	74 0d                	je     8022d7 <initialize_dynamic_allocator+0x1bd>
  8022ca:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022d2:	89 50 04             	mov    %edx,0x4(%eax)
  8022d5:	eb 08                	jmp    8022df <initialize_dynamic_allocator+0x1c5>
  8022d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022da:	a3 30 50 80 00       	mov    %eax,0x805030
  8022df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f1:	a1 38 50 80 00       	mov    0x805038,%eax
  8022f6:	40                   	inc    %eax
  8022f7:	a3 38 50 80 00       	mov    %eax,0x805038
  8022fc:	eb 07                	jmp    802305 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022fe:	90                   	nop
  8022ff:	eb 04                	jmp    802305 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802301:	90                   	nop
  802302:	eb 01                	jmp    802305 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802304:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80230a:	8b 45 10             	mov    0x10(%ebp),%eax
  80230d:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	8d 50 fc             	lea    -0x4(%eax),%edx
  802316:	8b 45 0c             	mov    0xc(%ebp),%eax
  802319:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	83 e8 04             	sub    $0x4,%eax
  802321:	8b 00                	mov    (%eax),%eax
  802323:	83 e0 fe             	and    $0xfffffffe,%eax
  802326:	8d 50 f8             	lea    -0x8(%eax),%edx
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	01 c2                	add    %eax,%edx
  80232e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802331:	89 02                	mov    %eax,(%edx)
}
  802333:	90                   	nop
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    

00802336 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80233c:	8b 45 08             	mov    0x8(%ebp),%eax
  80233f:	83 e0 01             	and    $0x1,%eax
  802342:	85 c0                	test   %eax,%eax
  802344:	74 03                	je     802349 <alloc_block_FF+0x13>
  802346:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802349:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80234d:	77 07                	ja     802356 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80234f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802356:	a1 24 50 80 00       	mov    0x805024,%eax
  80235b:	85 c0                	test   %eax,%eax
  80235d:	75 73                	jne    8023d2 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	83 c0 10             	add    $0x10,%eax
  802365:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802368:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80236f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802372:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802375:	01 d0                	add    %edx,%eax
  802377:	48                   	dec    %eax
  802378:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80237b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80237e:	ba 00 00 00 00       	mov    $0x0,%edx
  802383:	f7 75 ec             	divl   -0x14(%ebp)
  802386:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802389:	29 d0                	sub    %edx,%eax
  80238b:	c1 e8 0c             	shr    $0xc,%eax
  80238e:	83 ec 0c             	sub    $0xc,%esp
  802391:	50                   	push   %eax
  802392:	e8 b1 f0 ff ff       	call   801448 <sbrk>
  802397:	83 c4 10             	add    $0x10,%esp
  80239a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80239d:	83 ec 0c             	sub    $0xc,%esp
  8023a0:	6a 00                	push   $0x0
  8023a2:	e8 a1 f0 ff ff       	call   801448 <sbrk>
  8023a7:	83 c4 10             	add    $0x10,%esp
  8023aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8023ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8023b3:	83 ec 08             	sub    $0x8,%esp
  8023b6:	50                   	push   %eax
  8023b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023ba:	e8 5b fd ff ff       	call   80211a <initialize_dynamic_allocator>
  8023bf:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8023c2:	83 ec 0c             	sub    $0xc,%esp
  8023c5:	68 6f 45 80 00       	push   $0x80456f
  8023ca:	e8 df e2 ff ff       	call   8006ae <cprintf>
  8023cf:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8023d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d6:	75 0a                	jne    8023e2 <alloc_block_FF+0xac>
	        return NULL;
  8023d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023dd:	e9 0e 04 00 00       	jmp    8027f0 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8023e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023e9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f1:	e9 f3 02 00 00       	jmp    8026e9 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f9:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023fc:	83 ec 0c             	sub    $0xc,%esp
  8023ff:	ff 75 bc             	pushl  -0x44(%ebp)
  802402:	e8 af fb ff ff       	call   801fb6 <get_block_size>
  802407:	83 c4 10             	add    $0x10,%esp
  80240a:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	83 c0 08             	add    $0x8,%eax
  802413:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802416:	0f 87 c5 02 00 00    	ja     8026e1 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80241c:	8b 45 08             	mov    0x8(%ebp),%eax
  80241f:	83 c0 18             	add    $0x18,%eax
  802422:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802425:	0f 87 19 02 00 00    	ja     802644 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80242b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80242e:	2b 45 08             	sub    0x8(%ebp),%eax
  802431:	83 e8 08             	sub    $0x8,%eax
  802434:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802437:	8b 45 08             	mov    0x8(%ebp),%eax
  80243a:	8d 50 08             	lea    0x8(%eax),%edx
  80243d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802440:	01 d0                	add    %edx,%eax
  802442:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802445:	8b 45 08             	mov    0x8(%ebp),%eax
  802448:	83 c0 08             	add    $0x8,%eax
  80244b:	83 ec 04             	sub    $0x4,%esp
  80244e:	6a 01                	push   $0x1
  802450:	50                   	push   %eax
  802451:	ff 75 bc             	pushl  -0x44(%ebp)
  802454:	e8 ae fe ff ff       	call   802307 <set_block_data>
  802459:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	8b 40 04             	mov    0x4(%eax),%eax
  802462:	85 c0                	test   %eax,%eax
  802464:	75 68                	jne    8024ce <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802466:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80246a:	75 17                	jne    802483 <alloc_block_FF+0x14d>
  80246c:	83 ec 04             	sub    $0x4,%esp
  80246f:	68 4c 45 80 00       	push   $0x80454c
  802474:	68 d7 00 00 00       	push   $0xd7
  802479:	68 31 45 80 00       	push   $0x804531
  80247e:	e8 6e df ff ff       	call   8003f1 <_panic>
  802483:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802489:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80248c:	89 10                	mov    %edx,(%eax)
  80248e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802491:	8b 00                	mov    (%eax),%eax
  802493:	85 c0                	test   %eax,%eax
  802495:	74 0d                	je     8024a4 <alloc_block_FF+0x16e>
  802497:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80249c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80249f:	89 50 04             	mov    %edx,0x4(%eax)
  8024a2:	eb 08                	jmp    8024ac <alloc_block_FF+0x176>
  8024a4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a7:	a3 30 50 80 00       	mov    %eax,0x805030
  8024ac:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024af:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024b4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024be:	a1 38 50 80 00       	mov    0x805038,%eax
  8024c3:	40                   	inc    %eax
  8024c4:	a3 38 50 80 00       	mov    %eax,0x805038
  8024c9:	e9 dc 00 00 00       	jmp    8025aa <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	8b 00                	mov    (%eax),%eax
  8024d3:	85 c0                	test   %eax,%eax
  8024d5:	75 65                	jne    80253c <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024d7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024db:	75 17                	jne    8024f4 <alloc_block_FF+0x1be>
  8024dd:	83 ec 04             	sub    $0x4,%esp
  8024e0:	68 80 45 80 00       	push   $0x804580
  8024e5:	68 db 00 00 00       	push   $0xdb
  8024ea:	68 31 45 80 00       	push   $0x804531
  8024ef:	e8 fd de ff ff       	call   8003f1 <_panic>
  8024f4:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024fd:	89 50 04             	mov    %edx,0x4(%eax)
  802500:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802503:	8b 40 04             	mov    0x4(%eax),%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	74 0c                	je     802516 <alloc_block_FF+0x1e0>
  80250a:	a1 30 50 80 00       	mov    0x805030,%eax
  80250f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802512:	89 10                	mov    %edx,(%eax)
  802514:	eb 08                	jmp    80251e <alloc_block_FF+0x1e8>
  802516:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802519:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80251e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802521:	a3 30 50 80 00       	mov    %eax,0x805030
  802526:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802529:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252f:	a1 38 50 80 00       	mov    0x805038,%eax
  802534:	40                   	inc    %eax
  802535:	a3 38 50 80 00       	mov    %eax,0x805038
  80253a:	eb 6e                	jmp    8025aa <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80253c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802540:	74 06                	je     802548 <alloc_block_FF+0x212>
  802542:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802546:	75 17                	jne    80255f <alloc_block_FF+0x229>
  802548:	83 ec 04             	sub    $0x4,%esp
  80254b:	68 a4 45 80 00       	push   $0x8045a4
  802550:	68 df 00 00 00       	push   $0xdf
  802555:	68 31 45 80 00       	push   $0x804531
  80255a:	e8 92 de ff ff       	call   8003f1 <_panic>
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	8b 10                	mov    (%eax),%edx
  802564:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802567:	89 10                	mov    %edx,(%eax)
  802569:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80256c:	8b 00                	mov    (%eax),%eax
  80256e:	85 c0                	test   %eax,%eax
  802570:	74 0b                	je     80257d <alloc_block_FF+0x247>
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	8b 00                	mov    (%eax),%eax
  802577:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80257a:	89 50 04             	mov    %edx,0x4(%eax)
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802583:	89 10                	mov    %edx,(%eax)
  802585:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802588:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258b:	89 50 04             	mov    %edx,0x4(%eax)
  80258e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802591:	8b 00                	mov    (%eax),%eax
  802593:	85 c0                	test   %eax,%eax
  802595:	75 08                	jne    80259f <alloc_block_FF+0x269>
  802597:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80259a:	a3 30 50 80 00       	mov    %eax,0x805030
  80259f:	a1 38 50 80 00       	mov    0x805038,%eax
  8025a4:	40                   	inc    %eax
  8025a5:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8025aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ae:	75 17                	jne    8025c7 <alloc_block_FF+0x291>
  8025b0:	83 ec 04             	sub    $0x4,%esp
  8025b3:	68 13 45 80 00       	push   $0x804513
  8025b8:	68 e1 00 00 00       	push   $0xe1
  8025bd:	68 31 45 80 00       	push   $0x804531
  8025c2:	e8 2a de ff ff       	call   8003f1 <_panic>
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	8b 00                	mov    (%eax),%eax
  8025cc:	85 c0                	test   %eax,%eax
  8025ce:	74 10                	je     8025e0 <alloc_block_FF+0x2aa>
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 00                	mov    (%eax),%eax
  8025d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d8:	8b 52 04             	mov    0x4(%edx),%edx
  8025db:	89 50 04             	mov    %edx,0x4(%eax)
  8025de:	eb 0b                	jmp    8025eb <alloc_block_FF+0x2b5>
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	8b 40 04             	mov    0x4(%eax),%eax
  8025e6:	a3 30 50 80 00       	mov    %eax,0x805030
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 40 04             	mov    0x4(%eax),%eax
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	74 0f                	je     802604 <alloc_block_FF+0x2ce>
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	8b 40 04             	mov    0x4(%eax),%eax
  8025fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fe:	8b 12                	mov    (%edx),%edx
  802600:	89 10                	mov    %edx,(%eax)
  802602:	eb 0a                	jmp    80260e <alloc_block_FF+0x2d8>
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 00                	mov    (%eax),%eax
  802609:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80260e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802611:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802621:	a1 38 50 80 00       	mov    0x805038,%eax
  802626:	48                   	dec    %eax
  802627:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80262c:	83 ec 04             	sub    $0x4,%esp
  80262f:	6a 00                	push   $0x0
  802631:	ff 75 b4             	pushl  -0x4c(%ebp)
  802634:	ff 75 b0             	pushl  -0x50(%ebp)
  802637:	e8 cb fc ff ff       	call   802307 <set_block_data>
  80263c:	83 c4 10             	add    $0x10,%esp
  80263f:	e9 95 00 00 00       	jmp    8026d9 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802644:	83 ec 04             	sub    $0x4,%esp
  802647:	6a 01                	push   $0x1
  802649:	ff 75 b8             	pushl  -0x48(%ebp)
  80264c:	ff 75 bc             	pushl  -0x44(%ebp)
  80264f:	e8 b3 fc ff ff       	call   802307 <set_block_data>
  802654:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265b:	75 17                	jne    802674 <alloc_block_FF+0x33e>
  80265d:	83 ec 04             	sub    $0x4,%esp
  802660:	68 13 45 80 00       	push   $0x804513
  802665:	68 e8 00 00 00       	push   $0xe8
  80266a:	68 31 45 80 00       	push   $0x804531
  80266f:	e8 7d dd ff ff       	call   8003f1 <_panic>
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 00                	mov    (%eax),%eax
  802679:	85 c0                	test   %eax,%eax
  80267b:	74 10                	je     80268d <alloc_block_FF+0x357>
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 00                	mov    (%eax),%eax
  802682:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802685:	8b 52 04             	mov    0x4(%edx),%edx
  802688:	89 50 04             	mov    %edx,0x4(%eax)
  80268b:	eb 0b                	jmp    802698 <alloc_block_FF+0x362>
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 40 04             	mov    0x4(%eax),%eax
  802693:	a3 30 50 80 00       	mov    %eax,0x805030
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	8b 40 04             	mov    0x4(%eax),%eax
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	74 0f                	je     8026b1 <alloc_block_FF+0x37b>
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	8b 40 04             	mov    0x4(%eax),%eax
  8026a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ab:	8b 12                	mov    (%edx),%edx
  8026ad:	89 10                	mov    %edx,(%eax)
  8026af:	eb 0a                	jmp    8026bb <alloc_block_FF+0x385>
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	8b 00                	mov    (%eax),%eax
  8026b6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ce:	a1 38 50 80 00       	mov    0x805038,%eax
  8026d3:	48                   	dec    %eax
  8026d4:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8026d9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026dc:	e9 0f 01 00 00       	jmp    8027f0 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8026e1:	a1 34 50 80 00       	mov    0x805034,%eax
  8026e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ed:	74 07                	je     8026f6 <alloc_block_FF+0x3c0>
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f2:	8b 00                	mov    (%eax),%eax
  8026f4:	eb 05                	jmp    8026fb <alloc_block_FF+0x3c5>
  8026f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026fb:	a3 34 50 80 00       	mov    %eax,0x805034
  802700:	a1 34 50 80 00       	mov    0x805034,%eax
  802705:	85 c0                	test   %eax,%eax
  802707:	0f 85 e9 fc ff ff    	jne    8023f6 <alloc_block_FF+0xc0>
  80270d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802711:	0f 85 df fc ff ff    	jne    8023f6 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802717:	8b 45 08             	mov    0x8(%ebp),%eax
  80271a:	83 c0 08             	add    $0x8,%eax
  80271d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802720:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802727:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80272a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80272d:	01 d0                	add    %edx,%eax
  80272f:	48                   	dec    %eax
  802730:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802733:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802736:	ba 00 00 00 00       	mov    $0x0,%edx
  80273b:	f7 75 d8             	divl   -0x28(%ebp)
  80273e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802741:	29 d0                	sub    %edx,%eax
  802743:	c1 e8 0c             	shr    $0xc,%eax
  802746:	83 ec 0c             	sub    $0xc,%esp
  802749:	50                   	push   %eax
  80274a:	e8 f9 ec ff ff       	call   801448 <sbrk>
  80274f:	83 c4 10             	add    $0x10,%esp
  802752:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802755:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802759:	75 0a                	jne    802765 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80275b:	b8 00 00 00 00       	mov    $0x0,%eax
  802760:	e9 8b 00 00 00       	jmp    8027f0 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802765:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80276c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80276f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802772:	01 d0                	add    %edx,%eax
  802774:	48                   	dec    %eax
  802775:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802778:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80277b:	ba 00 00 00 00       	mov    $0x0,%edx
  802780:	f7 75 cc             	divl   -0x34(%ebp)
  802783:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802786:	29 d0                	sub    %edx,%eax
  802788:	8d 50 fc             	lea    -0x4(%eax),%edx
  80278b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80278e:	01 d0                	add    %edx,%eax
  802790:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802795:	a1 40 50 80 00       	mov    0x805040,%eax
  80279a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8027a0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8027a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027aa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027ad:	01 d0                	add    %edx,%eax
  8027af:	48                   	dec    %eax
  8027b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8027b3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8027bb:	f7 75 c4             	divl   -0x3c(%ebp)
  8027be:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027c1:	29 d0                	sub    %edx,%eax
  8027c3:	83 ec 04             	sub    $0x4,%esp
  8027c6:	6a 01                	push   $0x1
  8027c8:	50                   	push   %eax
  8027c9:	ff 75 d0             	pushl  -0x30(%ebp)
  8027cc:	e8 36 fb ff ff       	call   802307 <set_block_data>
  8027d1:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8027d4:	83 ec 0c             	sub    $0xc,%esp
  8027d7:	ff 75 d0             	pushl  -0x30(%ebp)
  8027da:	e8 1b 0a 00 00       	call   8031fa <free_block>
  8027df:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8027e2:	83 ec 0c             	sub    $0xc,%esp
  8027e5:	ff 75 08             	pushl  0x8(%ebp)
  8027e8:	e8 49 fb ff ff       	call   802336 <alloc_block_FF>
  8027ed:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027f0:	c9                   	leave  
  8027f1:	c3                   	ret    

008027f2 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027f2:	55                   	push   %ebp
  8027f3:	89 e5                	mov    %esp,%ebp
  8027f5:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fb:	83 e0 01             	and    $0x1,%eax
  8027fe:	85 c0                	test   %eax,%eax
  802800:	74 03                	je     802805 <alloc_block_BF+0x13>
  802802:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802805:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802809:	77 07                	ja     802812 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80280b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802812:	a1 24 50 80 00       	mov    0x805024,%eax
  802817:	85 c0                	test   %eax,%eax
  802819:	75 73                	jne    80288e <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80281b:	8b 45 08             	mov    0x8(%ebp),%eax
  80281e:	83 c0 10             	add    $0x10,%eax
  802821:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802824:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80282b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80282e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802831:	01 d0                	add    %edx,%eax
  802833:	48                   	dec    %eax
  802834:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802837:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80283a:	ba 00 00 00 00       	mov    $0x0,%edx
  80283f:	f7 75 e0             	divl   -0x20(%ebp)
  802842:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802845:	29 d0                	sub    %edx,%eax
  802847:	c1 e8 0c             	shr    $0xc,%eax
  80284a:	83 ec 0c             	sub    $0xc,%esp
  80284d:	50                   	push   %eax
  80284e:	e8 f5 eb ff ff       	call   801448 <sbrk>
  802853:	83 c4 10             	add    $0x10,%esp
  802856:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802859:	83 ec 0c             	sub    $0xc,%esp
  80285c:	6a 00                	push   $0x0
  80285e:	e8 e5 eb ff ff       	call   801448 <sbrk>
  802863:	83 c4 10             	add    $0x10,%esp
  802866:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802869:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80286c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80286f:	83 ec 08             	sub    $0x8,%esp
  802872:	50                   	push   %eax
  802873:	ff 75 d8             	pushl  -0x28(%ebp)
  802876:	e8 9f f8 ff ff       	call   80211a <initialize_dynamic_allocator>
  80287b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80287e:	83 ec 0c             	sub    $0xc,%esp
  802881:	68 6f 45 80 00       	push   $0x80456f
  802886:	e8 23 de ff ff       	call   8006ae <cprintf>
  80288b:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80288e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802895:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80289c:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8028a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8028aa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b2:	e9 1d 01 00 00       	jmp    8029d4 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8028bd:	83 ec 0c             	sub    $0xc,%esp
  8028c0:	ff 75 a8             	pushl  -0x58(%ebp)
  8028c3:	e8 ee f6 ff ff       	call   801fb6 <get_block_size>
  8028c8:	83 c4 10             	add    $0x10,%esp
  8028cb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	83 c0 08             	add    $0x8,%eax
  8028d4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028d7:	0f 87 ef 00 00 00    	ja     8029cc <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e0:	83 c0 18             	add    $0x18,%eax
  8028e3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028e6:	77 1d                	ja     802905 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8028e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028eb:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028ee:	0f 86 d8 00 00 00    	jbe    8029cc <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028f4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028fa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802900:	e9 c7 00 00 00       	jmp    8029cc <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802905:	8b 45 08             	mov    0x8(%ebp),%eax
  802908:	83 c0 08             	add    $0x8,%eax
  80290b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80290e:	0f 85 9d 00 00 00    	jne    8029b1 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802914:	83 ec 04             	sub    $0x4,%esp
  802917:	6a 01                	push   $0x1
  802919:	ff 75 a4             	pushl  -0x5c(%ebp)
  80291c:	ff 75 a8             	pushl  -0x58(%ebp)
  80291f:	e8 e3 f9 ff ff       	call   802307 <set_block_data>
  802924:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802927:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80292b:	75 17                	jne    802944 <alloc_block_BF+0x152>
  80292d:	83 ec 04             	sub    $0x4,%esp
  802930:	68 13 45 80 00       	push   $0x804513
  802935:	68 2c 01 00 00       	push   $0x12c
  80293a:	68 31 45 80 00       	push   $0x804531
  80293f:	e8 ad da ff ff       	call   8003f1 <_panic>
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	8b 00                	mov    (%eax),%eax
  802949:	85 c0                	test   %eax,%eax
  80294b:	74 10                	je     80295d <alloc_block_BF+0x16b>
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	8b 00                	mov    (%eax),%eax
  802952:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802955:	8b 52 04             	mov    0x4(%edx),%edx
  802958:	89 50 04             	mov    %edx,0x4(%eax)
  80295b:	eb 0b                	jmp    802968 <alloc_block_BF+0x176>
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 40 04             	mov    0x4(%eax),%eax
  802963:	a3 30 50 80 00       	mov    %eax,0x805030
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	8b 40 04             	mov    0x4(%eax),%eax
  80296e:	85 c0                	test   %eax,%eax
  802970:	74 0f                	je     802981 <alloc_block_BF+0x18f>
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 40 04             	mov    0x4(%eax),%eax
  802978:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80297b:	8b 12                	mov    (%edx),%edx
  80297d:	89 10                	mov    %edx,(%eax)
  80297f:	eb 0a                	jmp    80298b <alloc_block_BF+0x199>
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 00                	mov    (%eax),%eax
  802986:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80299e:	a1 38 50 80 00       	mov    0x805038,%eax
  8029a3:	48                   	dec    %eax
  8029a4:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8029a9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029ac:	e9 24 04 00 00       	jmp    802dd5 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8029b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029b7:	76 13                	jbe    8029cc <alloc_block_BF+0x1da>
					{
						internal = 1;
  8029b9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8029c0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8029c6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029c9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8029cc:	a1 34 50 80 00       	mov    0x805034,%eax
  8029d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d8:	74 07                	je     8029e1 <alloc_block_BF+0x1ef>
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 00                	mov    (%eax),%eax
  8029df:	eb 05                	jmp    8029e6 <alloc_block_BF+0x1f4>
  8029e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e6:	a3 34 50 80 00       	mov    %eax,0x805034
  8029eb:	a1 34 50 80 00       	mov    0x805034,%eax
  8029f0:	85 c0                	test   %eax,%eax
  8029f2:	0f 85 bf fe ff ff    	jne    8028b7 <alloc_block_BF+0xc5>
  8029f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fc:	0f 85 b5 fe ff ff    	jne    8028b7 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802a02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a06:	0f 84 26 02 00 00    	je     802c32 <alloc_block_BF+0x440>
  802a0c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a10:	0f 85 1c 02 00 00    	jne    802c32 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a19:	2b 45 08             	sub    0x8(%ebp),%eax
  802a1c:	83 e8 08             	sub    $0x8,%eax
  802a1f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802a22:	8b 45 08             	mov    0x8(%ebp),%eax
  802a25:	8d 50 08             	lea    0x8(%eax),%edx
  802a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2b:	01 d0                	add    %edx,%eax
  802a2d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	83 c0 08             	add    $0x8,%eax
  802a36:	83 ec 04             	sub    $0x4,%esp
  802a39:	6a 01                	push   $0x1
  802a3b:	50                   	push   %eax
  802a3c:	ff 75 f0             	pushl  -0x10(%ebp)
  802a3f:	e8 c3 f8 ff ff       	call   802307 <set_block_data>
  802a44:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4a:	8b 40 04             	mov    0x4(%eax),%eax
  802a4d:	85 c0                	test   %eax,%eax
  802a4f:	75 68                	jne    802ab9 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a51:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a55:	75 17                	jne    802a6e <alloc_block_BF+0x27c>
  802a57:	83 ec 04             	sub    $0x4,%esp
  802a5a:	68 4c 45 80 00       	push   $0x80454c
  802a5f:	68 45 01 00 00       	push   $0x145
  802a64:	68 31 45 80 00       	push   $0x804531
  802a69:	e8 83 d9 ff ff       	call   8003f1 <_panic>
  802a6e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a74:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a77:	89 10                	mov    %edx,(%eax)
  802a79:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7c:	8b 00                	mov    (%eax),%eax
  802a7e:	85 c0                	test   %eax,%eax
  802a80:	74 0d                	je     802a8f <alloc_block_BF+0x29d>
  802a82:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a87:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a8a:	89 50 04             	mov    %edx,0x4(%eax)
  802a8d:	eb 08                	jmp    802a97 <alloc_block_BF+0x2a5>
  802a8f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a92:	a3 30 50 80 00       	mov    %eax,0x805030
  802a97:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a9a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a9f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa9:	a1 38 50 80 00       	mov    0x805038,%eax
  802aae:	40                   	inc    %eax
  802aaf:	a3 38 50 80 00       	mov    %eax,0x805038
  802ab4:	e9 dc 00 00 00       	jmp    802b95 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	75 65                	jne    802b27 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ac2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ac6:	75 17                	jne    802adf <alloc_block_BF+0x2ed>
  802ac8:	83 ec 04             	sub    $0x4,%esp
  802acb:	68 80 45 80 00       	push   $0x804580
  802ad0:	68 4a 01 00 00       	push   $0x14a
  802ad5:	68 31 45 80 00       	push   $0x804531
  802ada:	e8 12 d9 ff ff       	call   8003f1 <_panic>
  802adf:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ae5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae8:	89 50 04             	mov    %edx,0x4(%eax)
  802aeb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aee:	8b 40 04             	mov    0x4(%eax),%eax
  802af1:	85 c0                	test   %eax,%eax
  802af3:	74 0c                	je     802b01 <alloc_block_BF+0x30f>
  802af5:	a1 30 50 80 00       	mov    0x805030,%eax
  802afa:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802afd:	89 10                	mov    %edx,(%eax)
  802aff:	eb 08                	jmp    802b09 <alloc_block_BF+0x317>
  802b01:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b04:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b0c:	a3 30 50 80 00       	mov    %eax,0x805030
  802b11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1a:	a1 38 50 80 00       	mov    0x805038,%eax
  802b1f:	40                   	inc    %eax
  802b20:	a3 38 50 80 00       	mov    %eax,0x805038
  802b25:	eb 6e                	jmp    802b95 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802b27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b2b:	74 06                	je     802b33 <alloc_block_BF+0x341>
  802b2d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b31:	75 17                	jne    802b4a <alloc_block_BF+0x358>
  802b33:	83 ec 04             	sub    $0x4,%esp
  802b36:	68 a4 45 80 00       	push   $0x8045a4
  802b3b:	68 4f 01 00 00       	push   $0x14f
  802b40:	68 31 45 80 00       	push   $0x804531
  802b45:	e8 a7 d8 ff ff       	call   8003f1 <_panic>
  802b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4d:	8b 10                	mov    (%eax),%edx
  802b4f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b52:	89 10                	mov    %edx,(%eax)
  802b54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b57:	8b 00                	mov    (%eax),%eax
  802b59:	85 c0                	test   %eax,%eax
  802b5b:	74 0b                	je     802b68 <alloc_block_BF+0x376>
  802b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b60:	8b 00                	mov    (%eax),%eax
  802b62:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b65:	89 50 04             	mov    %edx,0x4(%eax)
  802b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b6e:	89 10                	mov    %edx,(%eax)
  802b70:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b76:	89 50 04             	mov    %edx,0x4(%eax)
  802b79:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	75 08                	jne    802b8a <alloc_block_BF+0x398>
  802b82:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b85:	a3 30 50 80 00       	mov    %eax,0x805030
  802b8a:	a1 38 50 80 00       	mov    0x805038,%eax
  802b8f:	40                   	inc    %eax
  802b90:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b99:	75 17                	jne    802bb2 <alloc_block_BF+0x3c0>
  802b9b:	83 ec 04             	sub    $0x4,%esp
  802b9e:	68 13 45 80 00       	push   $0x804513
  802ba3:	68 51 01 00 00       	push   $0x151
  802ba8:	68 31 45 80 00       	push   $0x804531
  802bad:	e8 3f d8 ff ff       	call   8003f1 <_panic>
  802bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb5:	8b 00                	mov    (%eax),%eax
  802bb7:	85 c0                	test   %eax,%eax
  802bb9:	74 10                	je     802bcb <alloc_block_BF+0x3d9>
  802bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbe:	8b 00                	mov    (%eax),%eax
  802bc0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc3:	8b 52 04             	mov    0x4(%edx),%edx
  802bc6:	89 50 04             	mov    %edx,0x4(%eax)
  802bc9:	eb 0b                	jmp    802bd6 <alloc_block_BF+0x3e4>
  802bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bce:	8b 40 04             	mov    0x4(%eax),%eax
  802bd1:	a3 30 50 80 00       	mov    %eax,0x805030
  802bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd9:	8b 40 04             	mov    0x4(%eax),%eax
  802bdc:	85 c0                	test   %eax,%eax
  802bde:	74 0f                	je     802bef <alloc_block_BF+0x3fd>
  802be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be3:	8b 40 04             	mov    0x4(%eax),%eax
  802be6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be9:	8b 12                	mov    (%edx),%edx
  802beb:	89 10                	mov    %edx,(%eax)
  802bed:	eb 0a                	jmp    802bf9 <alloc_block_BF+0x407>
  802bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf2:	8b 00                	mov    (%eax),%eax
  802bf4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c0c:	a1 38 50 80 00       	mov    0x805038,%eax
  802c11:	48                   	dec    %eax
  802c12:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802c17:	83 ec 04             	sub    $0x4,%esp
  802c1a:	6a 00                	push   $0x0
  802c1c:	ff 75 d0             	pushl  -0x30(%ebp)
  802c1f:	ff 75 cc             	pushl  -0x34(%ebp)
  802c22:	e8 e0 f6 ff ff       	call   802307 <set_block_data>
  802c27:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2d:	e9 a3 01 00 00       	jmp    802dd5 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802c32:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802c36:	0f 85 9d 00 00 00    	jne    802cd9 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c3c:	83 ec 04             	sub    $0x4,%esp
  802c3f:	6a 01                	push   $0x1
  802c41:	ff 75 ec             	pushl  -0x14(%ebp)
  802c44:	ff 75 f0             	pushl  -0x10(%ebp)
  802c47:	e8 bb f6 ff ff       	call   802307 <set_block_data>
  802c4c:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c53:	75 17                	jne    802c6c <alloc_block_BF+0x47a>
  802c55:	83 ec 04             	sub    $0x4,%esp
  802c58:	68 13 45 80 00       	push   $0x804513
  802c5d:	68 58 01 00 00       	push   $0x158
  802c62:	68 31 45 80 00       	push   $0x804531
  802c67:	e8 85 d7 ff ff       	call   8003f1 <_panic>
  802c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6f:	8b 00                	mov    (%eax),%eax
  802c71:	85 c0                	test   %eax,%eax
  802c73:	74 10                	je     802c85 <alloc_block_BF+0x493>
  802c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c78:	8b 00                	mov    (%eax),%eax
  802c7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7d:	8b 52 04             	mov    0x4(%edx),%edx
  802c80:	89 50 04             	mov    %edx,0x4(%eax)
  802c83:	eb 0b                	jmp    802c90 <alloc_block_BF+0x49e>
  802c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c88:	8b 40 04             	mov    0x4(%eax),%eax
  802c8b:	a3 30 50 80 00       	mov    %eax,0x805030
  802c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c93:	8b 40 04             	mov    0x4(%eax),%eax
  802c96:	85 c0                	test   %eax,%eax
  802c98:	74 0f                	je     802ca9 <alloc_block_BF+0x4b7>
  802c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ca0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca3:	8b 12                	mov    (%edx),%edx
  802ca5:	89 10                	mov    %edx,(%eax)
  802ca7:	eb 0a                	jmp    802cb3 <alloc_block_BF+0x4c1>
  802ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cac:	8b 00                	mov    (%eax),%eax
  802cae:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc6:	a1 38 50 80 00       	mov    0x805038,%eax
  802ccb:	48                   	dec    %eax
  802ccc:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd4:	e9 fc 00 00 00       	jmp    802dd5 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	83 c0 08             	add    $0x8,%eax
  802cdf:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ce2:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ce9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cec:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cef:	01 d0                	add    %edx,%eax
  802cf1:	48                   	dec    %eax
  802cf2:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cf5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cf8:	ba 00 00 00 00       	mov    $0x0,%edx
  802cfd:	f7 75 c4             	divl   -0x3c(%ebp)
  802d00:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d03:	29 d0                	sub    %edx,%eax
  802d05:	c1 e8 0c             	shr    $0xc,%eax
  802d08:	83 ec 0c             	sub    $0xc,%esp
  802d0b:	50                   	push   %eax
  802d0c:	e8 37 e7 ff ff       	call   801448 <sbrk>
  802d11:	83 c4 10             	add    $0x10,%esp
  802d14:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802d17:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802d1b:	75 0a                	jne    802d27 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802d1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d22:	e9 ae 00 00 00       	jmp    802dd5 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d27:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802d2e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d31:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d34:	01 d0                	add    %edx,%eax
  802d36:	48                   	dec    %eax
  802d37:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802d3a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d3d:	ba 00 00 00 00       	mov    $0x0,%edx
  802d42:	f7 75 b8             	divl   -0x48(%ebp)
  802d45:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d48:	29 d0                	sub    %edx,%eax
  802d4a:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d4d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d50:	01 d0                	add    %edx,%eax
  802d52:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d57:	a1 40 50 80 00       	mov    0x805040,%eax
  802d5c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d62:	83 ec 0c             	sub    $0xc,%esp
  802d65:	68 d8 45 80 00       	push   $0x8045d8
  802d6a:	e8 3f d9 ff ff       	call   8006ae <cprintf>
  802d6f:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d72:	83 ec 08             	sub    $0x8,%esp
  802d75:	ff 75 bc             	pushl  -0x44(%ebp)
  802d78:	68 dd 45 80 00       	push   $0x8045dd
  802d7d:	e8 2c d9 ff ff       	call   8006ae <cprintf>
  802d82:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d85:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d8c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d8f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d92:	01 d0                	add    %edx,%eax
  802d94:	48                   	dec    %eax
  802d95:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d98:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d9b:	ba 00 00 00 00       	mov    $0x0,%edx
  802da0:	f7 75 b0             	divl   -0x50(%ebp)
  802da3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802da6:	29 d0                	sub    %edx,%eax
  802da8:	83 ec 04             	sub    $0x4,%esp
  802dab:	6a 01                	push   $0x1
  802dad:	50                   	push   %eax
  802dae:	ff 75 bc             	pushl  -0x44(%ebp)
  802db1:	e8 51 f5 ff ff       	call   802307 <set_block_data>
  802db6:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802db9:	83 ec 0c             	sub    $0xc,%esp
  802dbc:	ff 75 bc             	pushl  -0x44(%ebp)
  802dbf:	e8 36 04 00 00       	call   8031fa <free_block>
  802dc4:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802dc7:	83 ec 0c             	sub    $0xc,%esp
  802dca:	ff 75 08             	pushl  0x8(%ebp)
  802dcd:	e8 20 fa ff ff       	call   8027f2 <alloc_block_BF>
  802dd2:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802dd5:	c9                   	leave  
  802dd6:	c3                   	ret    

00802dd7 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802dd7:	55                   	push   %ebp
  802dd8:	89 e5                	mov    %esp,%ebp
  802dda:	53                   	push   %ebx
  802ddb:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802dde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802de5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802dec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df0:	74 1e                	je     802e10 <merging+0x39>
  802df2:	ff 75 08             	pushl  0x8(%ebp)
  802df5:	e8 bc f1 ff ff       	call   801fb6 <get_block_size>
  802dfa:	83 c4 04             	add    $0x4,%esp
  802dfd:	89 c2                	mov    %eax,%edx
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	01 d0                	add    %edx,%eax
  802e04:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e07:	75 07                	jne    802e10 <merging+0x39>
		prev_is_free = 1;
  802e09:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802e10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e14:	74 1e                	je     802e34 <merging+0x5d>
  802e16:	ff 75 10             	pushl  0x10(%ebp)
  802e19:	e8 98 f1 ff ff       	call   801fb6 <get_block_size>
  802e1e:	83 c4 04             	add    $0x4,%esp
  802e21:	89 c2                	mov    %eax,%edx
  802e23:	8b 45 10             	mov    0x10(%ebp),%eax
  802e26:	01 d0                	add    %edx,%eax
  802e28:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e2b:	75 07                	jne    802e34 <merging+0x5d>
		next_is_free = 1;
  802e2d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802e34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e38:	0f 84 cc 00 00 00    	je     802f0a <merging+0x133>
  802e3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e42:	0f 84 c2 00 00 00    	je     802f0a <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e48:	ff 75 08             	pushl  0x8(%ebp)
  802e4b:	e8 66 f1 ff ff       	call   801fb6 <get_block_size>
  802e50:	83 c4 04             	add    $0x4,%esp
  802e53:	89 c3                	mov    %eax,%ebx
  802e55:	ff 75 10             	pushl  0x10(%ebp)
  802e58:	e8 59 f1 ff ff       	call   801fb6 <get_block_size>
  802e5d:	83 c4 04             	add    $0x4,%esp
  802e60:	01 c3                	add    %eax,%ebx
  802e62:	ff 75 0c             	pushl  0xc(%ebp)
  802e65:	e8 4c f1 ff ff       	call   801fb6 <get_block_size>
  802e6a:	83 c4 04             	add    $0x4,%esp
  802e6d:	01 d8                	add    %ebx,%eax
  802e6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e72:	6a 00                	push   $0x0
  802e74:	ff 75 ec             	pushl  -0x14(%ebp)
  802e77:	ff 75 08             	pushl  0x8(%ebp)
  802e7a:	e8 88 f4 ff ff       	call   802307 <set_block_data>
  802e7f:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e86:	75 17                	jne    802e9f <merging+0xc8>
  802e88:	83 ec 04             	sub    $0x4,%esp
  802e8b:	68 13 45 80 00       	push   $0x804513
  802e90:	68 7d 01 00 00       	push   $0x17d
  802e95:	68 31 45 80 00       	push   $0x804531
  802e9a:	e8 52 d5 ff ff       	call   8003f1 <_panic>
  802e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea2:	8b 00                	mov    (%eax),%eax
  802ea4:	85 c0                	test   %eax,%eax
  802ea6:	74 10                	je     802eb8 <merging+0xe1>
  802ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eab:	8b 00                	mov    (%eax),%eax
  802ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb0:	8b 52 04             	mov    0x4(%edx),%edx
  802eb3:	89 50 04             	mov    %edx,0x4(%eax)
  802eb6:	eb 0b                	jmp    802ec3 <merging+0xec>
  802eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ebb:	8b 40 04             	mov    0x4(%eax),%eax
  802ebe:	a3 30 50 80 00       	mov    %eax,0x805030
  802ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec6:	8b 40 04             	mov    0x4(%eax),%eax
  802ec9:	85 c0                	test   %eax,%eax
  802ecb:	74 0f                	je     802edc <merging+0x105>
  802ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed0:	8b 40 04             	mov    0x4(%eax),%eax
  802ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ed6:	8b 12                	mov    (%edx),%edx
  802ed8:	89 10                	mov    %edx,(%eax)
  802eda:	eb 0a                	jmp    802ee6 <merging+0x10f>
  802edc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eef:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef9:	a1 38 50 80 00       	mov    0x805038,%eax
  802efe:	48                   	dec    %eax
  802eff:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f04:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f05:	e9 ea 02 00 00       	jmp    8031f4 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802f0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0e:	74 3b                	je     802f4b <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802f10:	83 ec 0c             	sub    $0xc,%esp
  802f13:	ff 75 08             	pushl  0x8(%ebp)
  802f16:	e8 9b f0 ff ff       	call   801fb6 <get_block_size>
  802f1b:	83 c4 10             	add    $0x10,%esp
  802f1e:	89 c3                	mov    %eax,%ebx
  802f20:	83 ec 0c             	sub    $0xc,%esp
  802f23:	ff 75 10             	pushl  0x10(%ebp)
  802f26:	e8 8b f0 ff ff       	call   801fb6 <get_block_size>
  802f2b:	83 c4 10             	add    $0x10,%esp
  802f2e:	01 d8                	add    %ebx,%eax
  802f30:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f33:	83 ec 04             	sub    $0x4,%esp
  802f36:	6a 00                	push   $0x0
  802f38:	ff 75 e8             	pushl  -0x18(%ebp)
  802f3b:	ff 75 08             	pushl  0x8(%ebp)
  802f3e:	e8 c4 f3 ff ff       	call   802307 <set_block_data>
  802f43:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f46:	e9 a9 02 00 00       	jmp    8031f4 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f4f:	0f 84 2d 01 00 00    	je     803082 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f55:	83 ec 0c             	sub    $0xc,%esp
  802f58:	ff 75 10             	pushl  0x10(%ebp)
  802f5b:	e8 56 f0 ff ff       	call   801fb6 <get_block_size>
  802f60:	83 c4 10             	add    $0x10,%esp
  802f63:	89 c3                	mov    %eax,%ebx
  802f65:	83 ec 0c             	sub    $0xc,%esp
  802f68:	ff 75 0c             	pushl  0xc(%ebp)
  802f6b:	e8 46 f0 ff ff       	call   801fb6 <get_block_size>
  802f70:	83 c4 10             	add    $0x10,%esp
  802f73:	01 d8                	add    %ebx,%eax
  802f75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f78:	83 ec 04             	sub    $0x4,%esp
  802f7b:	6a 00                	push   $0x0
  802f7d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f80:	ff 75 10             	pushl  0x10(%ebp)
  802f83:	e8 7f f3 ff ff       	call   802307 <set_block_data>
  802f88:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f8b:	8b 45 10             	mov    0x10(%ebp),%eax
  802f8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f95:	74 06                	je     802f9d <merging+0x1c6>
  802f97:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f9b:	75 17                	jne    802fb4 <merging+0x1dd>
  802f9d:	83 ec 04             	sub    $0x4,%esp
  802fa0:	68 ec 45 80 00       	push   $0x8045ec
  802fa5:	68 8d 01 00 00       	push   $0x18d
  802faa:	68 31 45 80 00       	push   $0x804531
  802faf:	e8 3d d4 ff ff       	call   8003f1 <_panic>
  802fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb7:	8b 50 04             	mov    0x4(%eax),%edx
  802fba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fbd:	89 50 04             	mov    %edx,0x4(%eax)
  802fc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fc6:	89 10                	mov    %edx,(%eax)
  802fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcb:	8b 40 04             	mov    0x4(%eax),%eax
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	74 0d                	je     802fdf <merging+0x208>
  802fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd5:	8b 40 04             	mov    0x4(%eax),%eax
  802fd8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fdb:	89 10                	mov    %edx,(%eax)
  802fdd:	eb 08                	jmp    802fe7 <merging+0x210>
  802fdf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fed:	89 50 04             	mov    %edx,0x4(%eax)
  802ff0:	a1 38 50 80 00       	mov    0x805038,%eax
  802ff5:	40                   	inc    %eax
  802ff6:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802ffb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fff:	75 17                	jne    803018 <merging+0x241>
  803001:	83 ec 04             	sub    $0x4,%esp
  803004:	68 13 45 80 00       	push   $0x804513
  803009:	68 8e 01 00 00       	push   $0x18e
  80300e:	68 31 45 80 00       	push   $0x804531
  803013:	e8 d9 d3 ff ff       	call   8003f1 <_panic>
  803018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301b:	8b 00                	mov    (%eax),%eax
  80301d:	85 c0                	test   %eax,%eax
  80301f:	74 10                	je     803031 <merging+0x25a>
  803021:	8b 45 0c             	mov    0xc(%ebp),%eax
  803024:	8b 00                	mov    (%eax),%eax
  803026:	8b 55 0c             	mov    0xc(%ebp),%edx
  803029:	8b 52 04             	mov    0x4(%edx),%edx
  80302c:	89 50 04             	mov    %edx,0x4(%eax)
  80302f:	eb 0b                	jmp    80303c <merging+0x265>
  803031:	8b 45 0c             	mov    0xc(%ebp),%eax
  803034:	8b 40 04             	mov    0x4(%eax),%eax
  803037:	a3 30 50 80 00       	mov    %eax,0x805030
  80303c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303f:	8b 40 04             	mov    0x4(%eax),%eax
  803042:	85 c0                	test   %eax,%eax
  803044:	74 0f                	je     803055 <merging+0x27e>
  803046:	8b 45 0c             	mov    0xc(%ebp),%eax
  803049:	8b 40 04             	mov    0x4(%eax),%eax
  80304c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80304f:	8b 12                	mov    (%edx),%edx
  803051:	89 10                	mov    %edx,(%eax)
  803053:	eb 0a                	jmp    80305f <merging+0x288>
  803055:	8b 45 0c             	mov    0xc(%ebp),%eax
  803058:	8b 00                	mov    (%eax),%eax
  80305a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80305f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803062:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80306b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803072:	a1 38 50 80 00       	mov    0x805038,%eax
  803077:	48                   	dec    %eax
  803078:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80307d:	e9 72 01 00 00       	jmp    8031f4 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803082:	8b 45 10             	mov    0x10(%ebp),%eax
  803085:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803088:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80308c:	74 79                	je     803107 <merging+0x330>
  80308e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803092:	74 73                	je     803107 <merging+0x330>
  803094:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803098:	74 06                	je     8030a0 <merging+0x2c9>
  80309a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80309e:	75 17                	jne    8030b7 <merging+0x2e0>
  8030a0:	83 ec 04             	sub    $0x4,%esp
  8030a3:	68 a4 45 80 00       	push   $0x8045a4
  8030a8:	68 94 01 00 00       	push   $0x194
  8030ad:	68 31 45 80 00       	push   $0x804531
  8030b2:	e8 3a d3 ff ff       	call   8003f1 <_panic>
  8030b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ba:	8b 10                	mov    (%eax),%edx
  8030bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bf:	89 10                	mov    %edx,(%eax)
  8030c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c4:	8b 00                	mov    (%eax),%eax
  8030c6:	85 c0                	test   %eax,%eax
  8030c8:	74 0b                	je     8030d5 <merging+0x2fe>
  8030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cd:	8b 00                	mov    (%eax),%eax
  8030cf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030d2:	89 50 04             	mov    %edx,0x4(%eax)
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030db:	89 10                	mov    %edx,(%eax)
  8030dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e3:	89 50 04             	mov    %edx,0x4(%eax)
  8030e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	85 c0                	test   %eax,%eax
  8030ed:	75 08                	jne    8030f7 <merging+0x320>
  8030ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8030f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8030fc:	40                   	inc    %eax
  8030fd:	a3 38 50 80 00       	mov    %eax,0x805038
  803102:	e9 ce 00 00 00       	jmp    8031d5 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803107:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80310b:	74 65                	je     803172 <merging+0x39b>
  80310d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803111:	75 17                	jne    80312a <merging+0x353>
  803113:	83 ec 04             	sub    $0x4,%esp
  803116:	68 80 45 80 00       	push   $0x804580
  80311b:	68 95 01 00 00       	push   $0x195
  803120:	68 31 45 80 00       	push   $0x804531
  803125:	e8 c7 d2 ff ff       	call   8003f1 <_panic>
  80312a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803130:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803133:	89 50 04             	mov    %edx,0x4(%eax)
  803136:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803139:	8b 40 04             	mov    0x4(%eax),%eax
  80313c:	85 c0                	test   %eax,%eax
  80313e:	74 0c                	je     80314c <merging+0x375>
  803140:	a1 30 50 80 00       	mov    0x805030,%eax
  803145:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803148:	89 10                	mov    %edx,(%eax)
  80314a:	eb 08                	jmp    803154 <merging+0x37d>
  80314c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80314f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803154:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803157:	a3 30 50 80 00       	mov    %eax,0x805030
  80315c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803165:	a1 38 50 80 00       	mov    0x805038,%eax
  80316a:	40                   	inc    %eax
  80316b:	a3 38 50 80 00       	mov    %eax,0x805038
  803170:	eb 63                	jmp    8031d5 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803172:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803176:	75 17                	jne    80318f <merging+0x3b8>
  803178:	83 ec 04             	sub    $0x4,%esp
  80317b:	68 4c 45 80 00       	push   $0x80454c
  803180:	68 98 01 00 00       	push   $0x198
  803185:	68 31 45 80 00       	push   $0x804531
  80318a:	e8 62 d2 ff ff       	call   8003f1 <_panic>
  80318f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803195:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803198:	89 10                	mov    %edx,(%eax)
  80319a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80319d:	8b 00                	mov    (%eax),%eax
  80319f:	85 c0                	test   %eax,%eax
  8031a1:	74 0d                	je     8031b0 <merging+0x3d9>
  8031a3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031ab:	89 50 04             	mov    %edx,0x4(%eax)
  8031ae:	eb 08                	jmp    8031b8 <merging+0x3e1>
  8031b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b3:	a3 30 50 80 00       	mov    %eax,0x805030
  8031b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031bb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ca:	a1 38 50 80 00       	mov    0x805038,%eax
  8031cf:	40                   	inc    %eax
  8031d0:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8031d5:	83 ec 0c             	sub    $0xc,%esp
  8031d8:	ff 75 10             	pushl  0x10(%ebp)
  8031db:	e8 d6 ed ff ff       	call   801fb6 <get_block_size>
  8031e0:	83 c4 10             	add    $0x10,%esp
  8031e3:	83 ec 04             	sub    $0x4,%esp
  8031e6:	6a 00                	push   $0x0
  8031e8:	50                   	push   %eax
  8031e9:	ff 75 10             	pushl  0x10(%ebp)
  8031ec:	e8 16 f1 ff ff       	call   802307 <set_block_data>
  8031f1:	83 c4 10             	add    $0x10,%esp
	}
}
  8031f4:	90                   	nop
  8031f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031f8:	c9                   	leave  
  8031f9:	c3                   	ret    

008031fa <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031fa:	55                   	push   %ebp
  8031fb:	89 e5                	mov    %esp,%ebp
  8031fd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803200:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803205:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803208:	a1 30 50 80 00       	mov    0x805030,%eax
  80320d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803210:	73 1b                	jae    80322d <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803212:	a1 30 50 80 00       	mov    0x805030,%eax
  803217:	83 ec 04             	sub    $0x4,%esp
  80321a:	ff 75 08             	pushl  0x8(%ebp)
  80321d:	6a 00                	push   $0x0
  80321f:	50                   	push   %eax
  803220:	e8 b2 fb ff ff       	call   802dd7 <merging>
  803225:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803228:	e9 8b 00 00 00       	jmp    8032b8 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80322d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803232:	3b 45 08             	cmp    0x8(%ebp),%eax
  803235:	76 18                	jbe    80324f <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803237:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80323c:	83 ec 04             	sub    $0x4,%esp
  80323f:	ff 75 08             	pushl  0x8(%ebp)
  803242:	50                   	push   %eax
  803243:	6a 00                	push   $0x0
  803245:	e8 8d fb ff ff       	call   802dd7 <merging>
  80324a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80324d:	eb 69                	jmp    8032b8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80324f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803254:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803257:	eb 39                	jmp    803292 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80325f:	73 29                	jae    80328a <free_block+0x90>
  803261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803264:	8b 00                	mov    (%eax),%eax
  803266:	3b 45 08             	cmp    0x8(%ebp),%eax
  803269:	76 1f                	jbe    80328a <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80326b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326e:	8b 00                	mov    (%eax),%eax
  803270:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803273:	83 ec 04             	sub    $0x4,%esp
  803276:	ff 75 08             	pushl  0x8(%ebp)
  803279:	ff 75 f0             	pushl  -0x10(%ebp)
  80327c:	ff 75 f4             	pushl  -0xc(%ebp)
  80327f:	e8 53 fb ff ff       	call   802dd7 <merging>
  803284:	83 c4 10             	add    $0x10,%esp
			break;
  803287:	90                   	nop
		}
	}
}
  803288:	eb 2e                	jmp    8032b8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80328a:	a1 34 50 80 00       	mov    0x805034,%eax
  80328f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803292:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803296:	74 07                	je     80329f <free_block+0xa5>
  803298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329b:	8b 00                	mov    (%eax),%eax
  80329d:	eb 05                	jmp    8032a4 <free_block+0xaa>
  80329f:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a4:	a3 34 50 80 00       	mov    %eax,0x805034
  8032a9:	a1 34 50 80 00       	mov    0x805034,%eax
  8032ae:	85 c0                	test   %eax,%eax
  8032b0:	75 a7                	jne    803259 <free_block+0x5f>
  8032b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b6:	75 a1                	jne    803259 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032b8:	90                   	nop
  8032b9:	c9                   	leave  
  8032ba:	c3                   	ret    

008032bb <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8032bb:	55                   	push   %ebp
  8032bc:	89 e5                	mov    %esp,%ebp
  8032be:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8032c1:	ff 75 08             	pushl  0x8(%ebp)
  8032c4:	e8 ed ec ff ff       	call   801fb6 <get_block_size>
  8032c9:	83 c4 04             	add    $0x4,%esp
  8032cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8032cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8032d6:	eb 17                	jmp    8032ef <copy_data+0x34>
  8032d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032de:	01 c2                	add    %eax,%edx
  8032e0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e6:	01 c8                	add    %ecx,%eax
  8032e8:	8a 00                	mov    (%eax),%al
  8032ea:	88 02                	mov    %al,(%edx)
  8032ec:	ff 45 fc             	incl   -0x4(%ebp)
  8032ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032f5:	72 e1                	jb     8032d8 <copy_data+0x1d>
}
  8032f7:	90                   	nop
  8032f8:	c9                   	leave  
  8032f9:	c3                   	ret    

008032fa <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032fa:	55                   	push   %ebp
  8032fb:	89 e5                	mov    %esp,%ebp
  8032fd:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803300:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803304:	75 23                	jne    803329 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803306:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80330a:	74 13                	je     80331f <realloc_block_FF+0x25>
  80330c:	83 ec 0c             	sub    $0xc,%esp
  80330f:	ff 75 0c             	pushl  0xc(%ebp)
  803312:	e8 1f f0 ff ff       	call   802336 <alloc_block_FF>
  803317:	83 c4 10             	add    $0x10,%esp
  80331a:	e9 f4 06 00 00       	jmp    803a13 <realloc_block_FF+0x719>
		return NULL;
  80331f:	b8 00 00 00 00       	mov    $0x0,%eax
  803324:	e9 ea 06 00 00       	jmp    803a13 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803329:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80332d:	75 18                	jne    803347 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80332f:	83 ec 0c             	sub    $0xc,%esp
  803332:	ff 75 08             	pushl  0x8(%ebp)
  803335:	e8 c0 fe ff ff       	call   8031fa <free_block>
  80333a:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80333d:	b8 00 00 00 00       	mov    $0x0,%eax
  803342:	e9 cc 06 00 00       	jmp    803a13 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803347:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80334b:	77 07                	ja     803354 <realloc_block_FF+0x5a>
  80334d:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803354:	8b 45 0c             	mov    0xc(%ebp),%eax
  803357:	83 e0 01             	and    $0x1,%eax
  80335a:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80335d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803360:	83 c0 08             	add    $0x8,%eax
  803363:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803366:	83 ec 0c             	sub    $0xc,%esp
  803369:	ff 75 08             	pushl  0x8(%ebp)
  80336c:	e8 45 ec ff ff       	call   801fb6 <get_block_size>
  803371:	83 c4 10             	add    $0x10,%esp
  803374:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803377:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80337a:	83 e8 08             	sub    $0x8,%eax
  80337d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	83 e8 04             	sub    $0x4,%eax
  803386:	8b 00                	mov    (%eax),%eax
  803388:	83 e0 fe             	and    $0xfffffffe,%eax
  80338b:	89 c2                	mov    %eax,%edx
  80338d:	8b 45 08             	mov    0x8(%ebp),%eax
  803390:	01 d0                	add    %edx,%eax
  803392:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803395:	83 ec 0c             	sub    $0xc,%esp
  803398:	ff 75 e4             	pushl  -0x1c(%ebp)
  80339b:	e8 16 ec ff ff       	call   801fb6 <get_block_size>
  8033a0:	83 c4 10             	add    $0x10,%esp
  8033a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033a9:	83 e8 08             	sub    $0x8,%eax
  8033ac:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8033af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033b5:	75 08                	jne    8033bf <realloc_block_FF+0xc5>
	{
		 return va;
  8033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ba:	e9 54 06 00 00       	jmp    803a13 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8033bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033c5:	0f 83 e5 03 00 00    	jae    8037b0 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8033cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ce:	2b 45 0c             	sub    0xc(%ebp),%eax
  8033d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8033d4:	83 ec 0c             	sub    $0xc,%esp
  8033d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033da:	e8 f0 eb ff ff       	call   801fcf <is_free_block>
  8033df:	83 c4 10             	add    $0x10,%esp
  8033e2:	84 c0                	test   %al,%al
  8033e4:	0f 84 3b 01 00 00    	je     803525 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8033ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033f0:	01 d0                	add    %edx,%eax
  8033f2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8033f5:	83 ec 04             	sub    $0x4,%esp
  8033f8:	6a 01                	push   $0x1
  8033fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8033fd:	ff 75 08             	pushl  0x8(%ebp)
  803400:	e8 02 ef ff ff       	call   802307 <set_block_data>
  803405:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803408:	8b 45 08             	mov    0x8(%ebp),%eax
  80340b:	83 e8 04             	sub    $0x4,%eax
  80340e:	8b 00                	mov    (%eax),%eax
  803410:	83 e0 fe             	and    $0xfffffffe,%eax
  803413:	89 c2                	mov    %eax,%edx
  803415:	8b 45 08             	mov    0x8(%ebp),%eax
  803418:	01 d0                	add    %edx,%eax
  80341a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80341d:	83 ec 04             	sub    $0x4,%esp
  803420:	6a 00                	push   $0x0
  803422:	ff 75 cc             	pushl  -0x34(%ebp)
  803425:	ff 75 c8             	pushl  -0x38(%ebp)
  803428:	e8 da ee ff ff       	call   802307 <set_block_data>
  80342d:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803430:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803434:	74 06                	je     80343c <realloc_block_FF+0x142>
  803436:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80343a:	75 17                	jne    803453 <realloc_block_FF+0x159>
  80343c:	83 ec 04             	sub    $0x4,%esp
  80343f:	68 a4 45 80 00       	push   $0x8045a4
  803444:	68 f6 01 00 00       	push   $0x1f6
  803449:	68 31 45 80 00       	push   $0x804531
  80344e:	e8 9e cf ff ff       	call   8003f1 <_panic>
  803453:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803456:	8b 10                	mov    (%eax),%edx
  803458:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80345b:	89 10                	mov    %edx,(%eax)
  80345d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803460:	8b 00                	mov    (%eax),%eax
  803462:	85 c0                	test   %eax,%eax
  803464:	74 0b                	je     803471 <realloc_block_FF+0x177>
  803466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803469:	8b 00                	mov    (%eax),%eax
  80346b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80346e:	89 50 04             	mov    %edx,0x4(%eax)
  803471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803474:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803477:	89 10                	mov    %edx,(%eax)
  803479:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80347c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80347f:	89 50 04             	mov    %edx,0x4(%eax)
  803482:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803485:	8b 00                	mov    (%eax),%eax
  803487:	85 c0                	test   %eax,%eax
  803489:	75 08                	jne    803493 <realloc_block_FF+0x199>
  80348b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80348e:	a3 30 50 80 00       	mov    %eax,0x805030
  803493:	a1 38 50 80 00       	mov    0x805038,%eax
  803498:	40                   	inc    %eax
  803499:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80349e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034a2:	75 17                	jne    8034bb <realloc_block_FF+0x1c1>
  8034a4:	83 ec 04             	sub    $0x4,%esp
  8034a7:	68 13 45 80 00       	push   $0x804513
  8034ac:	68 f7 01 00 00       	push   $0x1f7
  8034b1:	68 31 45 80 00       	push   $0x804531
  8034b6:	e8 36 cf ff ff       	call   8003f1 <_panic>
  8034bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034be:	8b 00                	mov    (%eax),%eax
  8034c0:	85 c0                	test   %eax,%eax
  8034c2:	74 10                	je     8034d4 <realloc_block_FF+0x1da>
  8034c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c7:	8b 00                	mov    (%eax),%eax
  8034c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034cc:	8b 52 04             	mov    0x4(%edx),%edx
  8034cf:	89 50 04             	mov    %edx,0x4(%eax)
  8034d2:	eb 0b                	jmp    8034df <realloc_block_FF+0x1e5>
  8034d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d7:	8b 40 04             	mov    0x4(%eax),%eax
  8034da:	a3 30 50 80 00       	mov    %eax,0x805030
  8034df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e2:	8b 40 04             	mov    0x4(%eax),%eax
  8034e5:	85 c0                	test   %eax,%eax
  8034e7:	74 0f                	je     8034f8 <realloc_block_FF+0x1fe>
  8034e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ec:	8b 40 04             	mov    0x4(%eax),%eax
  8034ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034f2:	8b 12                	mov    (%edx),%edx
  8034f4:	89 10                	mov    %edx,(%eax)
  8034f6:	eb 0a                	jmp    803502 <realloc_block_FF+0x208>
  8034f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fb:	8b 00                	mov    (%eax),%eax
  8034fd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803505:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80350b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803515:	a1 38 50 80 00       	mov    0x805038,%eax
  80351a:	48                   	dec    %eax
  80351b:	a3 38 50 80 00       	mov    %eax,0x805038
  803520:	e9 83 02 00 00       	jmp    8037a8 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803525:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803529:	0f 86 69 02 00 00    	jbe    803798 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80352f:	83 ec 04             	sub    $0x4,%esp
  803532:	6a 01                	push   $0x1
  803534:	ff 75 f0             	pushl  -0x10(%ebp)
  803537:	ff 75 08             	pushl  0x8(%ebp)
  80353a:	e8 c8 ed ff ff       	call   802307 <set_block_data>
  80353f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	83 e8 04             	sub    $0x4,%eax
  803548:	8b 00                	mov    (%eax),%eax
  80354a:	83 e0 fe             	and    $0xfffffffe,%eax
  80354d:	89 c2                	mov    %eax,%edx
  80354f:	8b 45 08             	mov    0x8(%ebp),%eax
  803552:	01 d0                	add    %edx,%eax
  803554:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803557:	a1 38 50 80 00       	mov    0x805038,%eax
  80355c:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80355f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803563:	75 68                	jne    8035cd <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803565:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803569:	75 17                	jne    803582 <realloc_block_FF+0x288>
  80356b:	83 ec 04             	sub    $0x4,%esp
  80356e:	68 4c 45 80 00       	push   $0x80454c
  803573:	68 06 02 00 00       	push   $0x206
  803578:	68 31 45 80 00       	push   $0x804531
  80357d:	e8 6f ce ff ff       	call   8003f1 <_panic>
  803582:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803588:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358b:	89 10                	mov    %edx,(%eax)
  80358d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803590:	8b 00                	mov    (%eax),%eax
  803592:	85 c0                	test   %eax,%eax
  803594:	74 0d                	je     8035a3 <realloc_block_FF+0x2a9>
  803596:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80359b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80359e:	89 50 04             	mov    %edx,0x4(%eax)
  8035a1:	eb 08                	jmp    8035ab <realloc_block_FF+0x2b1>
  8035a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a6:	a3 30 50 80 00       	mov    %eax,0x805030
  8035ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ae:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8035c2:	40                   	inc    %eax
  8035c3:	a3 38 50 80 00       	mov    %eax,0x805038
  8035c8:	e9 b0 01 00 00       	jmp    80377d <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8035cd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035d2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035d5:	76 68                	jbe    80363f <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035d7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035db:	75 17                	jne    8035f4 <realloc_block_FF+0x2fa>
  8035dd:	83 ec 04             	sub    $0x4,%esp
  8035e0:	68 4c 45 80 00       	push   $0x80454c
  8035e5:	68 0b 02 00 00       	push   $0x20b
  8035ea:	68 31 45 80 00       	push   $0x804531
  8035ef:	e8 fd cd ff ff       	call   8003f1 <_panic>
  8035f4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035fd:	89 10                	mov    %edx,(%eax)
  8035ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803602:	8b 00                	mov    (%eax),%eax
  803604:	85 c0                	test   %eax,%eax
  803606:	74 0d                	je     803615 <realloc_block_FF+0x31b>
  803608:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80360d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803610:	89 50 04             	mov    %edx,0x4(%eax)
  803613:	eb 08                	jmp    80361d <realloc_block_FF+0x323>
  803615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803618:	a3 30 50 80 00       	mov    %eax,0x805030
  80361d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803620:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803625:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803628:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80362f:	a1 38 50 80 00       	mov    0x805038,%eax
  803634:	40                   	inc    %eax
  803635:	a3 38 50 80 00       	mov    %eax,0x805038
  80363a:	e9 3e 01 00 00       	jmp    80377d <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80363f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803644:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803647:	73 68                	jae    8036b1 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803649:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80364d:	75 17                	jne    803666 <realloc_block_FF+0x36c>
  80364f:	83 ec 04             	sub    $0x4,%esp
  803652:	68 80 45 80 00       	push   $0x804580
  803657:	68 10 02 00 00       	push   $0x210
  80365c:	68 31 45 80 00       	push   $0x804531
  803661:	e8 8b cd ff ff       	call   8003f1 <_panic>
  803666:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80366c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80366f:	89 50 04             	mov    %edx,0x4(%eax)
  803672:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803675:	8b 40 04             	mov    0x4(%eax),%eax
  803678:	85 c0                	test   %eax,%eax
  80367a:	74 0c                	je     803688 <realloc_block_FF+0x38e>
  80367c:	a1 30 50 80 00       	mov    0x805030,%eax
  803681:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803684:	89 10                	mov    %edx,(%eax)
  803686:	eb 08                	jmp    803690 <realloc_block_FF+0x396>
  803688:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80368b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803690:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803693:	a3 30 50 80 00       	mov    %eax,0x805030
  803698:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8036a6:	40                   	inc    %eax
  8036a7:	a3 38 50 80 00       	mov    %eax,0x805038
  8036ac:	e9 cc 00 00 00       	jmp    80377d <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8036b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8036b8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036c0:	e9 8a 00 00 00       	jmp    80374f <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8036c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036cb:	73 7a                	jae    803747 <realloc_block_FF+0x44d>
  8036cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d0:	8b 00                	mov    (%eax),%eax
  8036d2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036d5:	73 70                	jae    803747 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8036d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036db:	74 06                	je     8036e3 <realloc_block_FF+0x3e9>
  8036dd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036e1:	75 17                	jne    8036fa <realloc_block_FF+0x400>
  8036e3:	83 ec 04             	sub    $0x4,%esp
  8036e6:	68 a4 45 80 00       	push   $0x8045a4
  8036eb:	68 1a 02 00 00       	push   $0x21a
  8036f0:	68 31 45 80 00       	push   $0x804531
  8036f5:	e8 f7 cc ff ff       	call   8003f1 <_panic>
  8036fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fd:	8b 10                	mov    (%eax),%edx
  8036ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803702:	89 10                	mov    %edx,(%eax)
  803704:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803707:	8b 00                	mov    (%eax),%eax
  803709:	85 c0                	test   %eax,%eax
  80370b:	74 0b                	je     803718 <realloc_block_FF+0x41e>
  80370d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803710:	8b 00                	mov    (%eax),%eax
  803712:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803715:	89 50 04             	mov    %edx,0x4(%eax)
  803718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80371e:	89 10                	mov    %edx,(%eax)
  803720:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803723:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803726:	89 50 04             	mov    %edx,0x4(%eax)
  803729:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80372c:	8b 00                	mov    (%eax),%eax
  80372e:	85 c0                	test   %eax,%eax
  803730:	75 08                	jne    80373a <realloc_block_FF+0x440>
  803732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803735:	a3 30 50 80 00       	mov    %eax,0x805030
  80373a:	a1 38 50 80 00       	mov    0x805038,%eax
  80373f:	40                   	inc    %eax
  803740:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803745:	eb 36                	jmp    80377d <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803747:	a1 34 50 80 00       	mov    0x805034,%eax
  80374c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80374f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803753:	74 07                	je     80375c <realloc_block_FF+0x462>
  803755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803758:	8b 00                	mov    (%eax),%eax
  80375a:	eb 05                	jmp    803761 <realloc_block_FF+0x467>
  80375c:	b8 00 00 00 00       	mov    $0x0,%eax
  803761:	a3 34 50 80 00       	mov    %eax,0x805034
  803766:	a1 34 50 80 00       	mov    0x805034,%eax
  80376b:	85 c0                	test   %eax,%eax
  80376d:	0f 85 52 ff ff ff    	jne    8036c5 <realloc_block_FF+0x3cb>
  803773:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803777:	0f 85 48 ff ff ff    	jne    8036c5 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80377d:	83 ec 04             	sub    $0x4,%esp
  803780:	6a 00                	push   $0x0
  803782:	ff 75 d8             	pushl  -0x28(%ebp)
  803785:	ff 75 d4             	pushl  -0x2c(%ebp)
  803788:	e8 7a eb ff ff       	call   802307 <set_block_data>
  80378d:	83 c4 10             	add    $0x10,%esp
				return va;
  803790:	8b 45 08             	mov    0x8(%ebp),%eax
  803793:	e9 7b 02 00 00       	jmp    803a13 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803798:	83 ec 0c             	sub    $0xc,%esp
  80379b:	68 21 46 80 00       	push   $0x804621
  8037a0:	e8 09 cf ff ff       	call   8006ae <cprintf>
  8037a5:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8037a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ab:	e9 63 02 00 00       	jmp    803a13 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8037b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037b6:	0f 86 4d 02 00 00    	jbe    803a09 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8037bc:	83 ec 0c             	sub    $0xc,%esp
  8037bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037c2:	e8 08 e8 ff ff       	call   801fcf <is_free_block>
  8037c7:	83 c4 10             	add    $0x10,%esp
  8037ca:	84 c0                	test   %al,%al
  8037cc:	0f 84 37 02 00 00    	je     803a09 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8037d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037d5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8037d8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8037db:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037e1:	76 38                	jbe    80381b <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8037e3:	83 ec 0c             	sub    $0xc,%esp
  8037e6:	ff 75 08             	pushl  0x8(%ebp)
  8037e9:	e8 0c fa ff ff       	call   8031fa <free_block>
  8037ee:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8037f1:	83 ec 0c             	sub    $0xc,%esp
  8037f4:	ff 75 0c             	pushl  0xc(%ebp)
  8037f7:	e8 3a eb ff ff       	call   802336 <alloc_block_FF>
  8037fc:	83 c4 10             	add    $0x10,%esp
  8037ff:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803802:	83 ec 08             	sub    $0x8,%esp
  803805:	ff 75 c0             	pushl  -0x40(%ebp)
  803808:	ff 75 08             	pushl  0x8(%ebp)
  80380b:	e8 ab fa ff ff       	call   8032bb <copy_data>
  803810:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803813:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803816:	e9 f8 01 00 00       	jmp    803a13 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80381b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80381e:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803821:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803824:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803828:	0f 87 a0 00 00 00    	ja     8038ce <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80382e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803832:	75 17                	jne    80384b <realloc_block_FF+0x551>
  803834:	83 ec 04             	sub    $0x4,%esp
  803837:	68 13 45 80 00       	push   $0x804513
  80383c:	68 38 02 00 00       	push   $0x238
  803841:	68 31 45 80 00       	push   $0x804531
  803846:	e8 a6 cb ff ff       	call   8003f1 <_panic>
  80384b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384e:	8b 00                	mov    (%eax),%eax
  803850:	85 c0                	test   %eax,%eax
  803852:	74 10                	je     803864 <realloc_block_FF+0x56a>
  803854:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803857:	8b 00                	mov    (%eax),%eax
  803859:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80385c:	8b 52 04             	mov    0x4(%edx),%edx
  80385f:	89 50 04             	mov    %edx,0x4(%eax)
  803862:	eb 0b                	jmp    80386f <realloc_block_FF+0x575>
  803864:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803867:	8b 40 04             	mov    0x4(%eax),%eax
  80386a:	a3 30 50 80 00       	mov    %eax,0x805030
  80386f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803872:	8b 40 04             	mov    0x4(%eax),%eax
  803875:	85 c0                	test   %eax,%eax
  803877:	74 0f                	je     803888 <realloc_block_FF+0x58e>
  803879:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387c:	8b 40 04             	mov    0x4(%eax),%eax
  80387f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803882:	8b 12                	mov    (%edx),%edx
  803884:	89 10                	mov    %edx,(%eax)
  803886:	eb 0a                	jmp    803892 <realloc_block_FF+0x598>
  803888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388b:	8b 00                	mov    (%eax),%eax
  80388d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803892:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803895:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80389b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8038aa:	48                   	dec    %eax
  8038ab:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8038b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038b6:	01 d0                	add    %edx,%eax
  8038b8:	83 ec 04             	sub    $0x4,%esp
  8038bb:	6a 01                	push   $0x1
  8038bd:	50                   	push   %eax
  8038be:	ff 75 08             	pushl  0x8(%ebp)
  8038c1:	e8 41 ea ff ff       	call   802307 <set_block_data>
  8038c6:	83 c4 10             	add    $0x10,%esp
  8038c9:	e9 36 01 00 00       	jmp    803a04 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8038ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038d1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038d4:	01 d0                	add    %edx,%eax
  8038d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8038d9:	83 ec 04             	sub    $0x4,%esp
  8038dc:	6a 01                	push   $0x1
  8038de:	ff 75 f0             	pushl  -0x10(%ebp)
  8038e1:	ff 75 08             	pushl  0x8(%ebp)
  8038e4:	e8 1e ea ff ff       	call   802307 <set_block_data>
  8038e9:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ef:	83 e8 04             	sub    $0x4,%eax
  8038f2:	8b 00                	mov    (%eax),%eax
  8038f4:	83 e0 fe             	and    $0xfffffffe,%eax
  8038f7:	89 c2                	mov    %eax,%edx
  8038f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fc:	01 d0                	add    %edx,%eax
  8038fe:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803901:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803905:	74 06                	je     80390d <realloc_block_FF+0x613>
  803907:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80390b:	75 17                	jne    803924 <realloc_block_FF+0x62a>
  80390d:	83 ec 04             	sub    $0x4,%esp
  803910:	68 a4 45 80 00       	push   $0x8045a4
  803915:	68 44 02 00 00       	push   $0x244
  80391a:	68 31 45 80 00       	push   $0x804531
  80391f:	e8 cd ca ff ff       	call   8003f1 <_panic>
  803924:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803927:	8b 10                	mov    (%eax),%edx
  803929:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80392c:	89 10                	mov    %edx,(%eax)
  80392e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803931:	8b 00                	mov    (%eax),%eax
  803933:	85 c0                	test   %eax,%eax
  803935:	74 0b                	je     803942 <realloc_block_FF+0x648>
  803937:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393a:	8b 00                	mov    (%eax),%eax
  80393c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80393f:	89 50 04             	mov    %edx,0x4(%eax)
  803942:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803945:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803948:	89 10                	mov    %edx,(%eax)
  80394a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80394d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803950:	89 50 04             	mov    %edx,0x4(%eax)
  803953:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803956:	8b 00                	mov    (%eax),%eax
  803958:	85 c0                	test   %eax,%eax
  80395a:	75 08                	jne    803964 <realloc_block_FF+0x66a>
  80395c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80395f:	a3 30 50 80 00       	mov    %eax,0x805030
  803964:	a1 38 50 80 00       	mov    0x805038,%eax
  803969:	40                   	inc    %eax
  80396a:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80396f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803973:	75 17                	jne    80398c <realloc_block_FF+0x692>
  803975:	83 ec 04             	sub    $0x4,%esp
  803978:	68 13 45 80 00       	push   $0x804513
  80397d:	68 45 02 00 00       	push   $0x245
  803982:	68 31 45 80 00       	push   $0x804531
  803987:	e8 65 ca ff ff       	call   8003f1 <_panic>
  80398c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398f:	8b 00                	mov    (%eax),%eax
  803991:	85 c0                	test   %eax,%eax
  803993:	74 10                	je     8039a5 <realloc_block_FF+0x6ab>
  803995:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803998:	8b 00                	mov    (%eax),%eax
  80399a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80399d:	8b 52 04             	mov    0x4(%edx),%edx
  8039a0:	89 50 04             	mov    %edx,0x4(%eax)
  8039a3:	eb 0b                	jmp    8039b0 <realloc_block_FF+0x6b6>
  8039a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a8:	8b 40 04             	mov    0x4(%eax),%eax
  8039ab:	a3 30 50 80 00       	mov    %eax,0x805030
  8039b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b3:	8b 40 04             	mov    0x4(%eax),%eax
  8039b6:	85 c0                	test   %eax,%eax
  8039b8:	74 0f                	je     8039c9 <realloc_block_FF+0x6cf>
  8039ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bd:	8b 40 04             	mov    0x4(%eax),%eax
  8039c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039c3:	8b 12                	mov    (%edx),%edx
  8039c5:	89 10                	mov    %edx,(%eax)
  8039c7:	eb 0a                	jmp    8039d3 <realloc_block_FF+0x6d9>
  8039c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cc:	8b 00                	mov    (%eax),%eax
  8039ce:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039e6:	a1 38 50 80 00       	mov    0x805038,%eax
  8039eb:	48                   	dec    %eax
  8039ec:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8039f1:	83 ec 04             	sub    $0x4,%esp
  8039f4:	6a 00                	push   $0x0
  8039f6:	ff 75 bc             	pushl  -0x44(%ebp)
  8039f9:	ff 75 b8             	pushl  -0x48(%ebp)
  8039fc:	e8 06 e9 ff ff       	call   802307 <set_block_data>
  803a01:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a04:	8b 45 08             	mov    0x8(%ebp),%eax
  803a07:	eb 0a                	jmp    803a13 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a09:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803a10:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803a13:	c9                   	leave  
  803a14:	c3                   	ret    

00803a15 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a15:	55                   	push   %ebp
  803a16:	89 e5                	mov    %esp,%ebp
  803a18:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a1b:	83 ec 04             	sub    $0x4,%esp
  803a1e:	68 28 46 80 00       	push   $0x804628
  803a23:	68 58 02 00 00       	push   $0x258
  803a28:	68 31 45 80 00       	push   $0x804531
  803a2d:	e8 bf c9 ff ff       	call   8003f1 <_panic>

00803a32 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803a32:	55                   	push   %ebp
  803a33:	89 e5                	mov    %esp,%ebp
  803a35:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803a38:	83 ec 04             	sub    $0x4,%esp
  803a3b:	68 50 46 80 00       	push   $0x804650
  803a40:	68 61 02 00 00       	push   $0x261
  803a45:	68 31 45 80 00       	push   $0x804531
  803a4a:	e8 a2 c9 ff ff       	call   8003f1 <_panic>
  803a4f:	90                   	nop

00803a50 <__udivdi3>:
  803a50:	55                   	push   %ebp
  803a51:	57                   	push   %edi
  803a52:	56                   	push   %esi
  803a53:	53                   	push   %ebx
  803a54:	83 ec 1c             	sub    $0x1c,%esp
  803a57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a67:	89 ca                	mov    %ecx,%edx
  803a69:	89 f8                	mov    %edi,%eax
  803a6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a6f:	85 f6                	test   %esi,%esi
  803a71:	75 2d                	jne    803aa0 <__udivdi3+0x50>
  803a73:	39 cf                	cmp    %ecx,%edi
  803a75:	77 65                	ja     803adc <__udivdi3+0x8c>
  803a77:	89 fd                	mov    %edi,%ebp
  803a79:	85 ff                	test   %edi,%edi
  803a7b:	75 0b                	jne    803a88 <__udivdi3+0x38>
  803a7d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a82:	31 d2                	xor    %edx,%edx
  803a84:	f7 f7                	div    %edi
  803a86:	89 c5                	mov    %eax,%ebp
  803a88:	31 d2                	xor    %edx,%edx
  803a8a:	89 c8                	mov    %ecx,%eax
  803a8c:	f7 f5                	div    %ebp
  803a8e:	89 c1                	mov    %eax,%ecx
  803a90:	89 d8                	mov    %ebx,%eax
  803a92:	f7 f5                	div    %ebp
  803a94:	89 cf                	mov    %ecx,%edi
  803a96:	89 fa                	mov    %edi,%edx
  803a98:	83 c4 1c             	add    $0x1c,%esp
  803a9b:	5b                   	pop    %ebx
  803a9c:	5e                   	pop    %esi
  803a9d:	5f                   	pop    %edi
  803a9e:	5d                   	pop    %ebp
  803a9f:	c3                   	ret    
  803aa0:	39 ce                	cmp    %ecx,%esi
  803aa2:	77 28                	ja     803acc <__udivdi3+0x7c>
  803aa4:	0f bd fe             	bsr    %esi,%edi
  803aa7:	83 f7 1f             	xor    $0x1f,%edi
  803aaa:	75 40                	jne    803aec <__udivdi3+0x9c>
  803aac:	39 ce                	cmp    %ecx,%esi
  803aae:	72 0a                	jb     803aba <__udivdi3+0x6a>
  803ab0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ab4:	0f 87 9e 00 00 00    	ja     803b58 <__udivdi3+0x108>
  803aba:	b8 01 00 00 00       	mov    $0x1,%eax
  803abf:	89 fa                	mov    %edi,%edx
  803ac1:	83 c4 1c             	add    $0x1c,%esp
  803ac4:	5b                   	pop    %ebx
  803ac5:	5e                   	pop    %esi
  803ac6:	5f                   	pop    %edi
  803ac7:	5d                   	pop    %ebp
  803ac8:	c3                   	ret    
  803ac9:	8d 76 00             	lea    0x0(%esi),%esi
  803acc:	31 ff                	xor    %edi,%edi
  803ace:	31 c0                	xor    %eax,%eax
  803ad0:	89 fa                	mov    %edi,%edx
  803ad2:	83 c4 1c             	add    $0x1c,%esp
  803ad5:	5b                   	pop    %ebx
  803ad6:	5e                   	pop    %esi
  803ad7:	5f                   	pop    %edi
  803ad8:	5d                   	pop    %ebp
  803ad9:	c3                   	ret    
  803ada:	66 90                	xchg   %ax,%ax
  803adc:	89 d8                	mov    %ebx,%eax
  803ade:	f7 f7                	div    %edi
  803ae0:	31 ff                	xor    %edi,%edi
  803ae2:	89 fa                	mov    %edi,%edx
  803ae4:	83 c4 1c             	add    $0x1c,%esp
  803ae7:	5b                   	pop    %ebx
  803ae8:	5e                   	pop    %esi
  803ae9:	5f                   	pop    %edi
  803aea:	5d                   	pop    %ebp
  803aeb:	c3                   	ret    
  803aec:	bd 20 00 00 00       	mov    $0x20,%ebp
  803af1:	89 eb                	mov    %ebp,%ebx
  803af3:	29 fb                	sub    %edi,%ebx
  803af5:	89 f9                	mov    %edi,%ecx
  803af7:	d3 e6                	shl    %cl,%esi
  803af9:	89 c5                	mov    %eax,%ebp
  803afb:	88 d9                	mov    %bl,%cl
  803afd:	d3 ed                	shr    %cl,%ebp
  803aff:	89 e9                	mov    %ebp,%ecx
  803b01:	09 f1                	or     %esi,%ecx
  803b03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b07:	89 f9                	mov    %edi,%ecx
  803b09:	d3 e0                	shl    %cl,%eax
  803b0b:	89 c5                	mov    %eax,%ebp
  803b0d:	89 d6                	mov    %edx,%esi
  803b0f:	88 d9                	mov    %bl,%cl
  803b11:	d3 ee                	shr    %cl,%esi
  803b13:	89 f9                	mov    %edi,%ecx
  803b15:	d3 e2                	shl    %cl,%edx
  803b17:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b1b:	88 d9                	mov    %bl,%cl
  803b1d:	d3 e8                	shr    %cl,%eax
  803b1f:	09 c2                	or     %eax,%edx
  803b21:	89 d0                	mov    %edx,%eax
  803b23:	89 f2                	mov    %esi,%edx
  803b25:	f7 74 24 0c          	divl   0xc(%esp)
  803b29:	89 d6                	mov    %edx,%esi
  803b2b:	89 c3                	mov    %eax,%ebx
  803b2d:	f7 e5                	mul    %ebp
  803b2f:	39 d6                	cmp    %edx,%esi
  803b31:	72 19                	jb     803b4c <__udivdi3+0xfc>
  803b33:	74 0b                	je     803b40 <__udivdi3+0xf0>
  803b35:	89 d8                	mov    %ebx,%eax
  803b37:	31 ff                	xor    %edi,%edi
  803b39:	e9 58 ff ff ff       	jmp    803a96 <__udivdi3+0x46>
  803b3e:	66 90                	xchg   %ax,%ax
  803b40:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b44:	89 f9                	mov    %edi,%ecx
  803b46:	d3 e2                	shl    %cl,%edx
  803b48:	39 c2                	cmp    %eax,%edx
  803b4a:	73 e9                	jae    803b35 <__udivdi3+0xe5>
  803b4c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b4f:	31 ff                	xor    %edi,%edi
  803b51:	e9 40 ff ff ff       	jmp    803a96 <__udivdi3+0x46>
  803b56:	66 90                	xchg   %ax,%ax
  803b58:	31 c0                	xor    %eax,%eax
  803b5a:	e9 37 ff ff ff       	jmp    803a96 <__udivdi3+0x46>
  803b5f:	90                   	nop

00803b60 <__umoddi3>:
  803b60:	55                   	push   %ebp
  803b61:	57                   	push   %edi
  803b62:	56                   	push   %esi
  803b63:	53                   	push   %ebx
  803b64:	83 ec 1c             	sub    $0x1c,%esp
  803b67:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b6b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b73:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b7f:	89 f3                	mov    %esi,%ebx
  803b81:	89 fa                	mov    %edi,%edx
  803b83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b87:	89 34 24             	mov    %esi,(%esp)
  803b8a:	85 c0                	test   %eax,%eax
  803b8c:	75 1a                	jne    803ba8 <__umoddi3+0x48>
  803b8e:	39 f7                	cmp    %esi,%edi
  803b90:	0f 86 a2 00 00 00    	jbe    803c38 <__umoddi3+0xd8>
  803b96:	89 c8                	mov    %ecx,%eax
  803b98:	89 f2                	mov    %esi,%edx
  803b9a:	f7 f7                	div    %edi
  803b9c:	89 d0                	mov    %edx,%eax
  803b9e:	31 d2                	xor    %edx,%edx
  803ba0:	83 c4 1c             	add    $0x1c,%esp
  803ba3:	5b                   	pop    %ebx
  803ba4:	5e                   	pop    %esi
  803ba5:	5f                   	pop    %edi
  803ba6:	5d                   	pop    %ebp
  803ba7:	c3                   	ret    
  803ba8:	39 f0                	cmp    %esi,%eax
  803baa:	0f 87 ac 00 00 00    	ja     803c5c <__umoddi3+0xfc>
  803bb0:	0f bd e8             	bsr    %eax,%ebp
  803bb3:	83 f5 1f             	xor    $0x1f,%ebp
  803bb6:	0f 84 ac 00 00 00    	je     803c68 <__umoddi3+0x108>
  803bbc:	bf 20 00 00 00       	mov    $0x20,%edi
  803bc1:	29 ef                	sub    %ebp,%edi
  803bc3:	89 fe                	mov    %edi,%esi
  803bc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bc9:	89 e9                	mov    %ebp,%ecx
  803bcb:	d3 e0                	shl    %cl,%eax
  803bcd:	89 d7                	mov    %edx,%edi
  803bcf:	89 f1                	mov    %esi,%ecx
  803bd1:	d3 ef                	shr    %cl,%edi
  803bd3:	09 c7                	or     %eax,%edi
  803bd5:	89 e9                	mov    %ebp,%ecx
  803bd7:	d3 e2                	shl    %cl,%edx
  803bd9:	89 14 24             	mov    %edx,(%esp)
  803bdc:	89 d8                	mov    %ebx,%eax
  803bde:	d3 e0                	shl    %cl,%eax
  803be0:	89 c2                	mov    %eax,%edx
  803be2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803be6:	d3 e0                	shl    %cl,%eax
  803be8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bec:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bf0:	89 f1                	mov    %esi,%ecx
  803bf2:	d3 e8                	shr    %cl,%eax
  803bf4:	09 d0                	or     %edx,%eax
  803bf6:	d3 eb                	shr    %cl,%ebx
  803bf8:	89 da                	mov    %ebx,%edx
  803bfa:	f7 f7                	div    %edi
  803bfc:	89 d3                	mov    %edx,%ebx
  803bfe:	f7 24 24             	mull   (%esp)
  803c01:	89 c6                	mov    %eax,%esi
  803c03:	89 d1                	mov    %edx,%ecx
  803c05:	39 d3                	cmp    %edx,%ebx
  803c07:	0f 82 87 00 00 00    	jb     803c94 <__umoddi3+0x134>
  803c0d:	0f 84 91 00 00 00    	je     803ca4 <__umoddi3+0x144>
  803c13:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c17:	29 f2                	sub    %esi,%edx
  803c19:	19 cb                	sbb    %ecx,%ebx
  803c1b:	89 d8                	mov    %ebx,%eax
  803c1d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c21:	d3 e0                	shl    %cl,%eax
  803c23:	89 e9                	mov    %ebp,%ecx
  803c25:	d3 ea                	shr    %cl,%edx
  803c27:	09 d0                	or     %edx,%eax
  803c29:	89 e9                	mov    %ebp,%ecx
  803c2b:	d3 eb                	shr    %cl,%ebx
  803c2d:	89 da                	mov    %ebx,%edx
  803c2f:	83 c4 1c             	add    $0x1c,%esp
  803c32:	5b                   	pop    %ebx
  803c33:	5e                   	pop    %esi
  803c34:	5f                   	pop    %edi
  803c35:	5d                   	pop    %ebp
  803c36:	c3                   	ret    
  803c37:	90                   	nop
  803c38:	89 fd                	mov    %edi,%ebp
  803c3a:	85 ff                	test   %edi,%edi
  803c3c:	75 0b                	jne    803c49 <__umoddi3+0xe9>
  803c3e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c43:	31 d2                	xor    %edx,%edx
  803c45:	f7 f7                	div    %edi
  803c47:	89 c5                	mov    %eax,%ebp
  803c49:	89 f0                	mov    %esi,%eax
  803c4b:	31 d2                	xor    %edx,%edx
  803c4d:	f7 f5                	div    %ebp
  803c4f:	89 c8                	mov    %ecx,%eax
  803c51:	f7 f5                	div    %ebp
  803c53:	89 d0                	mov    %edx,%eax
  803c55:	e9 44 ff ff ff       	jmp    803b9e <__umoddi3+0x3e>
  803c5a:	66 90                	xchg   %ax,%ax
  803c5c:	89 c8                	mov    %ecx,%eax
  803c5e:	89 f2                	mov    %esi,%edx
  803c60:	83 c4 1c             	add    $0x1c,%esp
  803c63:	5b                   	pop    %ebx
  803c64:	5e                   	pop    %esi
  803c65:	5f                   	pop    %edi
  803c66:	5d                   	pop    %ebp
  803c67:	c3                   	ret    
  803c68:	3b 04 24             	cmp    (%esp),%eax
  803c6b:	72 06                	jb     803c73 <__umoddi3+0x113>
  803c6d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c71:	77 0f                	ja     803c82 <__umoddi3+0x122>
  803c73:	89 f2                	mov    %esi,%edx
  803c75:	29 f9                	sub    %edi,%ecx
  803c77:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c7b:	89 14 24             	mov    %edx,(%esp)
  803c7e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c82:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c86:	8b 14 24             	mov    (%esp),%edx
  803c89:	83 c4 1c             	add    $0x1c,%esp
  803c8c:	5b                   	pop    %ebx
  803c8d:	5e                   	pop    %esi
  803c8e:	5f                   	pop    %edi
  803c8f:	5d                   	pop    %ebp
  803c90:	c3                   	ret    
  803c91:	8d 76 00             	lea    0x0(%esi),%esi
  803c94:	2b 04 24             	sub    (%esp),%eax
  803c97:	19 fa                	sbb    %edi,%edx
  803c99:	89 d1                	mov    %edx,%ecx
  803c9b:	89 c6                	mov    %eax,%esi
  803c9d:	e9 71 ff ff ff       	jmp    803c13 <__umoddi3+0xb3>
  803ca2:	66 90                	xchg   %ax,%ax
  803ca4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ca8:	72 ea                	jb     803c94 <__umoddi3+0x134>
  803caa:	89 d9                	mov    %ebx,%ecx
  803cac:	e9 62 ff ff ff       	jmp    803c13 <__umoddi3+0xb3>
