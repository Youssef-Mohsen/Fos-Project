
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
  80005c:	68 a0 3c 80 00       	push   $0x803ca0
  800061:	6a 0d                	push   $0xd
  800063:	68 bc 3c 80 00       	push   $0x803cbc
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
  800074:	e8 f3 1b 00 00       	call   801c6c <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 56 19 00 00       	call   8019d7 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 04 1a 00 00       	call   801a8a <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 d7 3c 80 00       	push   $0x803cd7
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
  8000b6:	68 dc 3c 80 00       	push   $0x803cdc
  8000bb:	6a 21                	push   $0x21
  8000bd:	68 bc 3c 80 00       	push   $0x803cbc
  8000c2:	e8 2a 03 00 00       	call   8003f1 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 b4 19 00 00       	call   801a8a <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 9d 19 00 00       	call   801a8a <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 58 3d 80 00       	push   $0x803d58
  8000fd:	6a 24                	push   $0x24
  8000ff:	68 bc 3c 80 00       	push   $0x803cbc
  800104:	e8 e8 02 00 00       	call   8003f1 <_panic>

	}
	sys_unlock_cons();
  800109:	e8 e3 18 00 00       	call   8019f1 <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 c4 18 00 00       	call   8019d7 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 72 19 00 00       	call   801a8a <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = sget(parentenvID,"y");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 f0 3d 80 00       	push   $0x803df0
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
  80014d:	68 dc 3c 80 00       	push   $0x803cdc
  800152:	6a 30                	push   $0x30
  800154:	68 bc 3c 80 00       	push   $0x803cbc
  800159:	e8 93 02 00 00       	call   8003f1 <_panic>
		expected = 0 ;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 1d 19 00 00       	call   801a8a <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 06 19 00 00       	call   801a8a <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 58 3d 80 00       	push   $0x803d58
  800194:	6a 33                	push   $0x33
  800196:	68 bc 3c 80 00       	push   $0x803cbc
  80019b:	e8 51 02 00 00       	call   8003f1 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 4c 18 00 00       	call   8019f1 <sys_unlock_cons>
	//sys_unlock_cons();
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 14             	cmp    $0x14,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 f4 3d 80 00       	push   $0x803df4
  8001b7:	6a 37                	push   $0x37
  8001b9:	68 bc 3c 80 00       	push   $0x803cbc
  8001be:	e8 2e 02 00 00       	call   8003f1 <_panic>
	//sys_lock_cons();
	sys_lock_cons();
  8001c3:	e8 0f 18 00 00       	call   8019d7 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  8001c8:	e8 bd 18 00 00       	call   801a8a <sys_calculate_free_frames>
  8001cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	68 2b 3e 80 00       	push   $0x803e2b
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
  800202:	68 dc 3c 80 00       	push   $0x803cdc
  800207:	6a 3e                	push   $0x3e
  800209:	68 bc 3c 80 00       	push   $0x803cbc
  80020e:	e8 de 01 00 00       	call   8003f1 <_panic>
		expected = 0 ;
  800213:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80021a:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80021d:	e8 68 18 00 00       	call   801a8a <sys_calculate_free_frames>
  800222:	29 c3                	sub    %eax,%ebx
  800224:	89 d8                	mov    %ebx,%eax
  800226:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800229:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022f:	74 24                	je     800255 <_main+0x21d>
  800231:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800234:	e8 51 18 00 00       	call   801a8a <sys_calculate_free_frames>
  800239:	29 c3                	sub    %eax,%ebx
  80023b:	89 d8                	mov    %ebx,%eax
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	ff 75 e0             	pushl  -0x20(%ebp)
  800243:	50                   	push   %eax
  800244:	68 58 3d 80 00       	push   $0x803d58
  800249:	6a 41                	push   $0x41
  80024b:	68 bc 3c 80 00       	push   $0x803cbc
  800250:	e8 9c 01 00 00       	call   8003f1 <_panic>
	}
	sys_unlock_cons();
  800255:	e8 97 17 00 00       	call   8019f1 <sys_unlock_cons>
	//sys_unlock_cons();
	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  80025a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80025d:	8b 00                	mov    (%eax),%eax
  80025f:	83 f8 0a             	cmp    $0xa,%eax
  800262:	74 14                	je     800278 <_main+0x240>
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	68 f4 3d 80 00       	push   $0x803df4
  80026c:	6a 45                	push   $0x45
  80026e:	68 bc 3c 80 00       	push   $0x803cbc
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
  800296:	68 f4 3d 80 00       	push   $0x803df4
  80029b:	6a 48                	push   $0x48
  80029d:	68 bc 3c 80 00       	push   $0x803cbc
  8002a2:	e8 4a 01 00 00       	call   8003f1 <_panic>

	//To indicate that it's completed successfully
	inctst();
  8002a7:	e8 e5 1a 00 00       	call   801d91 <inctst>

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
  8002b8:	e8 96 19 00 00       	call   801c53 <sys_getenvindex>
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
  800326:	e8 ac 16 00 00       	call   8019d7 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80032b:	83 ec 0c             	sub    $0xc,%esp
  80032e:	68 48 3e 80 00       	push   $0x803e48
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
  800356:	68 70 3e 80 00       	push   $0x803e70
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
  800387:	68 98 3e 80 00       	push   $0x803e98
  80038c:	e8 1d 03 00 00       	call   8006ae <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800394:	a1 20 50 80 00       	mov    0x805020,%eax
  800399:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80039f:	83 ec 08             	sub    $0x8,%esp
  8003a2:	50                   	push   %eax
  8003a3:	68 f0 3e 80 00       	push   $0x803ef0
  8003a8:	e8 01 03 00 00       	call   8006ae <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003b0:	83 ec 0c             	sub    $0xc,%esp
  8003b3:	68 48 3e 80 00       	push   $0x803e48
  8003b8:	e8 f1 02 00 00       	call   8006ae <cprintf>
  8003bd:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003c0:	e8 2c 16 00 00       	call   8019f1 <sys_unlock_cons>
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
  8003d8:	e8 42 18 00 00       	call   801c1f <sys_destroy_env>
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
  8003e9:	e8 97 18 00 00       	call   801c85 <sys_exit_env>
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
  800412:	68 04 3f 80 00       	push   $0x803f04
  800417:	e8 92 02 00 00       	call   8006ae <cprintf>
  80041c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80041f:	a1 00 50 80 00       	mov    0x805000,%eax
  800424:	ff 75 0c             	pushl  0xc(%ebp)
  800427:	ff 75 08             	pushl  0x8(%ebp)
  80042a:	50                   	push   %eax
  80042b:	68 09 3f 80 00       	push   $0x803f09
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
  80044f:	68 25 3f 80 00       	push   $0x803f25
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
  80047e:	68 28 3f 80 00       	push   $0x803f28
  800483:	6a 26                	push   $0x26
  800485:	68 74 3f 80 00       	push   $0x803f74
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
  800553:	68 80 3f 80 00       	push   $0x803f80
  800558:	6a 3a                	push   $0x3a
  80055a:	68 74 3f 80 00       	push   $0x803f74
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
  8005c6:	68 d4 3f 80 00       	push   $0x803fd4
  8005cb:	6a 44                	push   $0x44
  8005cd:	68 74 3f 80 00       	push   $0x803f74
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
  800620:	e8 70 13 00 00       	call   801995 <sys_cputs>
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
  800697:	e8 f9 12 00 00       	call   801995 <sys_cputs>
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
  8006e1:	e8 f1 12 00 00       	call   8019d7 <sys_lock_cons>
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
  800701:	e8 eb 12 00 00       	call   8019f1 <sys_unlock_cons>
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
  80074b:	e8 dc 32 00 00       	call   803a2c <__udivdi3>
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
  80079b:	e8 9c 33 00 00       	call   803b3c <__umoddi3>
  8007a0:	83 c4 10             	add    $0x10,%esp
  8007a3:	05 34 42 80 00       	add    $0x804234,%eax
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
  8008f6:	8b 04 85 58 42 80 00 	mov    0x804258(,%eax,4),%eax
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
  8009d7:	8b 34 9d a0 40 80 00 	mov    0x8040a0(,%ebx,4),%esi
  8009de:	85 f6                	test   %esi,%esi
  8009e0:	75 19                	jne    8009fb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e2:	53                   	push   %ebx
  8009e3:	68 45 42 80 00       	push   $0x804245
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
  8009fc:	68 4e 42 80 00       	push   $0x80424e
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
  800a29:	be 51 42 80 00       	mov    $0x804251,%esi
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
  801434:	68 c8 43 80 00       	push   $0x8043c8
  801439:	68 3f 01 00 00       	push   $0x13f
  80143e:	68 ea 43 80 00       	push   $0x8043ea
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
  801454:	e8 e7 0a 00 00       	call   801f40 <sys_sbrk>
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
  8014cf:	e8 f0 08 00 00       	call   801dc4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	74 16                	je     8014ee <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	ff 75 08             	pushl  0x8(%ebp)
  8014de:	e8 30 0e 00 00       	call   802313 <alloc_block_FF>
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e9:	e9 8a 01 00 00       	jmp    801678 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014ee:	e8 02 09 00 00       	call   801df5 <sys_isUHeapPlacementStrategyBESTFIT>
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	0f 84 7d 01 00 00    	je     801678 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014fb:	83 ec 0c             	sub    $0xc,%esp
  8014fe:	ff 75 08             	pushl  0x8(%ebp)
  801501:	e8 c9 12 00 00       	call   8027cf <alloc_block_BF>
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
  801667:	e8 0b 09 00 00       	call   801f77 <sys_allocate_user_mem>
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
  8016af:	e8 df 08 00 00       	call   801f93 <get_block_size>
  8016b4:	83 c4 10             	add    $0x10,%esp
  8016b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016ba:	83 ec 0c             	sub    $0xc,%esp
  8016bd:	ff 75 08             	pushl  0x8(%ebp)
  8016c0:	e8 12 1b 00 00       	call   8031d7 <free_block>
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
  801757:	e8 ff 07 00 00       	call   801f5b <sys_free_user_mem>
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
  801765:	68 f8 43 80 00       	push   $0x8043f8
  80176a:	68 85 00 00 00       	push   $0x85
  80176f:	68 22 44 80 00       	push   $0x804422
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
  8017da:	e8 83 03 00 00       	call   801b62 <sys_createSharedObject>
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
  8017fe:	68 2e 44 80 00       	push   $0x80442e
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
  801842:	e8 45 03 00 00       	call   801b8c <sys_getSizeOfSharedObject>
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80184d:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801851:	75 07                	jne    80185a <sget+0x27>
  801853:	b8 00 00 00 00       	mov    $0x0,%eax
  801858:	eb 5c                	jmp    8018b6 <sget+0x83>
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
  80188d:	eb 27                	jmp    8018b6 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80188f:	83 ec 04             	sub    $0x4,%esp
  801892:	ff 75 e8             	pushl  -0x18(%ebp)
  801895:	ff 75 0c             	pushl  0xc(%ebp)
  801898:	ff 75 08             	pushl  0x8(%ebp)
  80189b:	e8 09 03 00 00       	call   801ba9 <sys_getSharedObject>
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8018a6:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018aa:	75 07                	jne    8018b3 <sget+0x80>
  8018ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b1:	eb 03                	jmp    8018b6 <sget+0x83>
	return ptr;
  8018b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8018be:	8b 55 08             	mov    0x8(%ebp),%edx
  8018c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8018c6:	8b 40 78             	mov    0x78(%eax),%eax
  8018c9:	29 c2                	sub    %eax,%edx
  8018cb:	89 d0                	mov    %edx,%eax
  8018cd:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018d2:	c1 e8 0c             	shr    $0xc,%eax
  8018d5:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8018dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8018df:	83 ec 08             	sub    $0x8,%esp
  8018e2:	ff 75 08             	pushl  0x8(%ebp)
  8018e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e8:	e8 db 02 00 00       	call   801bc8 <sys_freeSharedObject>
  8018ed:	83 c4 10             	add    $0x10,%esp
  8018f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8018f3:	90                   	nop
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018fc:	83 ec 04             	sub    $0x4,%esp
  8018ff:	68 40 44 80 00       	push   $0x804440
  801904:	68 dd 00 00 00       	push   $0xdd
  801909:	68 22 44 80 00       	push   $0x804422
  80190e:	e8 de ea ff ff       	call   8003f1 <_panic>

00801913 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801919:	83 ec 04             	sub    $0x4,%esp
  80191c:	68 66 44 80 00       	push   $0x804466
  801921:	68 e9 00 00 00       	push   $0xe9
  801926:	68 22 44 80 00       	push   $0x804422
  80192b:	e8 c1 ea ff ff       	call   8003f1 <_panic>

00801930 <shrink>:

}
void shrink(uint32 newSize)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801936:	83 ec 04             	sub    $0x4,%esp
  801939:	68 66 44 80 00       	push   $0x804466
  80193e:	68 ee 00 00 00       	push   $0xee
  801943:	68 22 44 80 00       	push   $0x804422
  801948:	e8 a4 ea ff ff       	call   8003f1 <_panic>

0080194d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801953:	83 ec 04             	sub    $0x4,%esp
  801956:	68 66 44 80 00       	push   $0x804466
  80195b:	68 f3 00 00 00       	push   $0xf3
  801960:	68 22 44 80 00       	push   $0x804422
  801965:	e8 87 ea ff ff       	call   8003f1 <_panic>

0080196a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	57                   	push   %edi
  80196e:	56                   	push   %esi
  80196f:	53                   	push   %ebx
  801970:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	8b 55 0c             	mov    0xc(%ebp),%edx
  801979:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80197f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801982:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801985:	cd 30                	int    $0x30
  801987:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80198a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80198d:	83 c4 10             	add    $0x10,%esp
  801990:	5b                   	pop    %ebx
  801991:	5e                   	pop    %esi
  801992:	5f                   	pop    %edi
  801993:	5d                   	pop    %ebp
  801994:	c3                   	ret    

00801995 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	83 ec 04             	sub    $0x4,%esp
  80199b:	8b 45 10             	mov    0x10(%ebp),%eax
  80199e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019a1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	52                   	push   %edx
  8019ad:	ff 75 0c             	pushl  0xc(%ebp)
  8019b0:	50                   	push   %eax
  8019b1:	6a 00                	push   $0x0
  8019b3:	e8 b2 ff ff ff       	call   80196a <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	90                   	nop
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_cgetc>:

int
sys_cgetc(void)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 02                	push   $0x2
  8019cd:	e8 98 ff ff ff       	call   80196a <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 03                	push   $0x3
  8019e6:	e8 7f ff ff ff       	call   80196a <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	90                   	nop
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 04                	push   $0x4
  801a00:	e8 65 ff ff ff       	call   80196a <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	90                   	nop
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	52                   	push   %edx
  801a1b:	50                   	push   %eax
  801a1c:	6a 08                	push   $0x8
  801a1e:	e8 47 ff ff ff       	call   80196a <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	56                   	push   %esi
  801a2c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a2d:	8b 75 18             	mov    0x18(%ebp),%esi
  801a30:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a33:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3c:	56                   	push   %esi
  801a3d:	53                   	push   %ebx
  801a3e:	51                   	push   %ecx
  801a3f:	52                   	push   %edx
  801a40:	50                   	push   %eax
  801a41:	6a 09                	push   $0x9
  801a43:	e8 22 ff ff ff       	call   80196a <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4e:	5b                   	pop    %ebx
  801a4f:	5e                   	pop    %esi
  801a50:	5d                   	pop    %ebp
  801a51:	c3                   	ret    

00801a52 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	52                   	push   %edx
  801a62:	50                   	push   %eax
  801a63:	6a 0a                	push   $0xa
  801a65:	e8 00 ff ff ff       	call   80196a <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	ff 75 0c             	pushl  0xc(%ebp)
  801a7b:	ff 75 08             	pushl  0x8(%ebp)
  801a7e:	6a 0b                	push   $0xb
  801a80:	e8 e5 fe ff ff       	call   80196a <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 0c                	push   $0xc
  801a99:	e8 cc fe ff ff       	call   80196a <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 0d                	push   $0xd
  801ab2:	e8 b3 fe ff ff       	call   80196a <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 0e                	push   $0xe
  801acb:	e8 9a fe ff ff       	call   80196a <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 0f                	push   $0xf
  801ae4:	e8 81 fe ff ff       	call   80196a <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	ff 75 08             	pushl  0x8(%ebp)
  801afc:	6a 10                	push   $0x10
  801afe:	e8 67 fe ff ff       	call   80196a <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 11                	push   $0x11
  801b17:	e8 4e fe ff ff       	call   80196a <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	90                   	nop
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	83 ec 04             	sub    $0x4,%esp
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b2e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	50                   	push   %eax
  801b3b:	6a 01                	push   $0x1
  801b3d:	e8 28 fe ff ff       	call   80196a <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	90                   	nop
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 14                	push   $0x14
  801b57:	e8 0e fe ff ff       	call   80196a <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	90                   	nop
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	83 ec 04             	sub    $0x4,%esp
  801b68:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b6e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b71:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	6a 00                	push   $0x0
  801b7a:	51                   	push   %ecx
  801b7b:	52                   	push   %edx
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	50                   	push   %eax
  801b80:	6a 15                	push   $0x15
  801b82:	e8 e3 fd ff ff       	call   80196a <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	52                   	push   %edx
  801b9c:	50                   	push   %eax
  801b9d:	6a 16                	push   $0x16
  801b9f:	e8 c6 fd ff ff       	call   80196a <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801baf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	51                   	push   %ecx
  801bba:	52                   	push   %edx
  801bbb:	50                   	push   %eax
  801bbc:	6a 17                	push   $0x17
  801bbe:	e8 a7 fd ff ff       	call   80196a <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	52                   	push   %edx
  801bd8:	50                   	push   %eax
  801bd9:	6a 18                	push   $0x18
  801bdb:	e8 8a fd ff ff       	call   80196a <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	6a 00                	push   $0x0
  801bed:	ff 75 14             	pushl  0x14(%ebp)
  801bf0:	ff 75 10             	pushl  0x10(%ebp)
  801bf3:	ff 75 0c             	pushl  0xc(%ebp)
  801bf6:	50                   	push   %eax
  801bf7:	6a 19                	push   $0x19
  801bf9:	e8 6c fd ff ff       	call   80196a <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	50                   	push   %eax
  801c12:	6a 1a                	push   $0x1a
  801c14:	e8 51 fd ff ff       	call   80196a <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
}
  801c1c:	90                   	nop
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	50                   	push   %eax
  801c2e:	6a 1b                	push   $0x1b
  801c30:	e8 35 fd ff ff       	call   80196a <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 05                	push   $0x5
  801c49:	e8 1c fd ff ff       	call   80196a <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 06                	push   $0x6
  801c62:	e8 03 fd ff ff       	call   80196a <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 07                	push   $0x7
  801c7b:	e8 ea fc ff ff       	call   80196a <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_exit_env>:


void sys_exit_env(void)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 1c                	push   $0x1c
  801c94:	e8 d1 fc ff ff       	call   80196a <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	90                   	nop
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ca5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca8:	8d 50 04             	lea    0x4(%eax),%edx
  801cab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	52                   	push   %edx
  801cb5:	50                   	push   %eax
  801cb6:	6a 1d                	push   $0x1d
  801cb8:	e8 ad fc ff ff       	call   80196a <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
	return result;
  801cc0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cc6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cc9:	89 01                	mov    %eax,(%ecx)
  801ccb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	c9                   	leave  
  801cd2:	c2 04 00             	ret    $0x4

00801cd5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	ff 75 10             	pushl  0x10(%ebp)
  801cdf:	ff 75 0c             	pushl  0xc(%ebp)
  801ce2:	ff 75 08             	pushl  0x8(%ebp)
  801ce5:	6a 13                	push   $0x13
  801ce7:	e8 7e fc ff ff       	call   80196a <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
	return ;
  801cef:	90                   	nop
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 1e                	push   $0x1e
  801d01:	e8 64 fc ff ff       	call   80196a <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	83 ec 04             	sub    $0x4,%esp
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d17:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	50                   	push   %eax
  801d24:	6a 1f                	push   $0x1f
  801d26:	e8 3f fc ff ff       	call   80196a <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2e:	90                   	nop
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <rsttst>:
void rsttst()
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 21                	push   $0x21
  801d40:	e8 25 fc ff ff       	call   80196a <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
	return ;
  801d48:	90                   	nop
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 04             	sub    $0x4,%esp
  801d51:	8b 45 14             	mov    0x14(%ebp),%eax
  801d54:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d57:	8b 55 18             	mov    0x18(%ebp),%edx
  801d5a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d5e:	52                   	push   %edx
  801d5f:	50                   	push   %eax
  801d60:	ff 75 10             	pushl  0x10(%ebp)
  801d63:	ff 75 0c             	pushl  0xc(%ebp)
  801d66:	ff 75 08             	pushl  0x8(%ebp)
  801d69:	6a 20                	push   $0x20
  801d6b:	e8 fa fb ff ff       	call   80196a <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
	return ;
  801d73:	90                   	nop
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <chktst>:
void chktst(uint32 n)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	ff 75 08             	pushl  0x8(%ebp)
  801d84:	6a 22                	push   $0x22
  801d86:	e8 df fb ff ff       	call   80196a <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8e:	90                   	nop
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <inctst>:

void inctst()
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 23                	push   $0x23
  801da0:	e8 c5 fb ff ff       	call   80196a <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
	return ;
  801da8:	90                   	nop
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <gettst>:
uint32 gettst()
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 24                	push   $0x24
  801dba:	e8 ab fb ff ff       	call   80196a <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 25                	push   $0x25
  801dd6:	e8 8f fb ff ff       	call   80196a <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
  801dde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801de1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801de5:	75 07                	jne    801dee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801de7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dec:	eb 05                	jmp    801df3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 25                	push   $0x25
  801e07:	e8 5e fb ff ff       	call   80196a <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
  801e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e12:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e16:	75 07                	jne    801e1f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e18:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1d:	eb 05                	jmp    801e24 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 25                	push   $0x25
  801e38:	e8 2d fb ff ff       	call   80196a <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
  801e40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e43:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e47:	75 07                	jne    801e50 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e49:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4e:	eb 05                	jmp    801e55 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 25                	push   $0x25
  801e69:	e8 fc fa ff ff       	call   80196a <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
  801e71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e74:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e78:	75 07                	jne    801e81 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7f:	eb 05                	jmp    801e86 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	ff 75 08             	pushl  0x8(%ebp)
  801e96:	6a 26                	push   $0x26
  801e98:	e8 cd fa ff ff       	call   80196a <syscall>
  801e9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea0:	90                   	nop
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ea7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eaa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	6a 00                	push   $0x0
  801eb5:	53                   	push   %ebx
  801eb6:	51                   	push   %ecx
  801eb7:	52                   	push   %edx
  801eb8:	50                   	push   %eax
  801eb9:	6a 27                	push   $0x27
  801ebb:	e8 aa fa ff ff       	call   80196a <syscall>
  801ec0:	83 c4 18             	add    $0x18,%esp
}
  801ec3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ece:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	52                   	push   %edx
  801ed8:	50                   	push   %eax
  801ed9:	6a 28                	push   $0x28
  801edb:	e8 8a fa ff ff       	call   80196a <syscall>
  801ee0:	83 c4 18             	add    $0x18,%esp
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ee8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	6a 00                	push   $0x0
  801ef3:	51                   	push   %ecx
  801ef4:	ff 75 10             	pushl  0x10(%ebp)
  801ef7:	52                   	push   %edx
  801ef8:	50                   	push   %eax
  801ef9:	6a 29                	push   $0x29
  801efb:	e8 6a fa ff ff       	call   80196a <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	ff 75 10             	pushl  0x10(%ebp)
  801f0f:	ff 75 0c             	pushl  0xc(%ebp)
  801f12:	ff 75 08             	pushl  0x8(%ebp)
  801f15:	6a 12                	push   $0x12
  801f17:	e8 4e fa ff ff       	call   80196a <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1f:	90                   	nop
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	52                   	push   %edx
  801f32:	50                   	push   %eax
  801f33:	6a 2a                	push   $0x2a
  801f35:	e8 30 fa ff ff       	call   80196a <syscall>
  801f3a:	83 c4 18             	add    $0x18,%esp
	return;
  801f3d:	90                   	nop
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	50                   	push   %eax
  801f4f:	6a 2b                	push   $0x2b
  801f51:	e8 14 fa ff ff       	call   80196a <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	ff 75 0c             	pushl  0xc(%ebp)
  801f67:	ff 75 08             	pushl  0x8(%ebp)
  801f6a:	6a 2c                	push   $0x2c
  801f6c:	e8 f9 f9 ff ff       	call   80196a <syscall>
  801f71:	83 c4 18             	add    $0x18,%esp
	return;
  801f74:	90                   	nop
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	ff 75 0c             	pushl  0xc(%ebp)
  801f83:	ff 75 08             	pushl  0x8(%ebp)
  801f86:	6a 2d                	push   $0x2d
  801f88:	e8 dd f9 ff ff       	call   80196a <syscall>
  801f8d:	83 c4 18             	add    $0x18,%esp
	return;
  801f90:	90                   	nop
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	83 e8 04             	sub    $0x4,%eax
  801f9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801fa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa5:	8b 00                	mov    (%eax),%eax
  801fa7:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	83 e8 04             	sub    $0x4,%eax
  801fb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fbe:	8b 00                	mov    (%eax),%eax
  801fc0:	83 e0 01             	and    $0x1,%eax
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	0f 94 c0             	sete   %al
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801fd0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fda:	83 f8 02             	cmp    $0x2,%eax
  801fdd:	74 2b                	je     80200a <alloc_block+0x40>
  801fdf:	83 f8 02             	cmp    $0x2,%eax
  801fe2:	7f 07                	jg     801feb <alloc_block+0x21>
  801fe4:	83 f8 01             	cmp    $0x1,%eax
  801fe7:	74 0e                	je     801ff7 <alloc_block+0x2d>
  801fe9:	eb 58                	jmp    802043 <alloc_block+0x79>
  801feb:	83 f8 03             	cmp    $0x3,%eax
  801fee:	74 2d                	je     80201d <alloc_block+0x53>
  801ff0:	83 f8 04             	cmp    $0x4,%eax
  801ff3:	74 3b                	je     802030 <alloc_block+0x66>
  801ff5:	eb 4c                	jmp    802043 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801ff7:	83 ec 0c             	sub    $0xc,%esp
  801ffa:	ff 75 08             	pushl  0x8(%ebp)
  801ffd:	e8 11 03 00 00       	call   802313 <alloc_block_FF>
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802008:	eb 4a                	jmp    802054 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80200a:	83 ec 0c             	sub    $0xc,%esp
  80200d:	ff 75 08             	pushl  0x8(%ebp)
  802010:	e8 fa 19 00 00       	call   803a0f <alloc_block_NF>
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80201b:	eb 37                	jmp    802054 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80201d:	83 ec 0c             	sub    $0xc,%esp
  802020:	ff 75 08             	pushl  0x8(%ebp)
  802023:	e8 a7 07 00 00       	call   8027cf <alloc_block_BF>
  802028:	83 c4 10             	add    $0x10,%esp
  80202b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80202e:	eb 24                	jmp    802054 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802030:	83 ec 0c             	sub    $0xc,%esp
  802033:	ff 75 08             	pushl  0x8(%ebp)
  802036:	e8 b7 19 00 00       	call   8039f2 <alloc_block_WF>
  80203b:	83 c4 10             	add    $0x10,%esp
  80203e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802041:	eb 11                	jmp    802054 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802043:	83 ec 0c             	sub    $0xc,%esp
  802046:	68 78 44 80 00       	push   $0x804478
  80204b:	e8 5e e6 ff ff       	call   8006ae <cprintf>
  802050:	83 c4 10             	add    $0x10,%esp
		break;
  802053:	90                   	nop
	}
	return va;
  802054:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	53                   	push   %ebx
  80205d:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802060:	83 ec 0c             	sub    $0xc,%esp
  802063:	68 98 44 80 00       	push   $0x804498
  802068:	e8 41 e6 ff ff       	call   8006ae <cprintf>
  80206d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802070:	83 ec 0c             	sub    $0xc,%esp
  802073:	68 c3 44 80 00       	push   $0x8044c3
  802078:	e8 31 e6 ff ff       	call   8006ae <cprintf>
  80207d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802086:	eb 37                	jmp    8020bf <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802088:	83 ec 0c             	sub    $0xc,%esp
  80208b:	ff 75 f4             	pushl  -0xc(%ebp)
  80208e:	e8 19 ff ff ff       	call   801fac <is_free_block>
  802093:	83 c4 10             	add    $0x10,%esp
  802096:	0f be d8             	movsbl %al,%ebx
  802099:	83 ec 0c             	sub    $0xc,%esp
  80209c:	ff 75 f4             	pushl  -0xc(%ebp)
  80209f:	e8 ef fe ff ff       	call   801f93 <get_block_size>
  8020a4:	83 c4 10             	add    $0x10,%esp
  8020a7:	83 ec 04             	sub    $0x4,%esp
  8020aa:	53                   	push   %ebx
  8020ab:	50                   	push   %eax
  8020ac:	68 db 44 80 00       	push   $0x8044db
  8020b1:	e8 f8 e5 ff ff       	call   8006ae <cprintf>
  8020b6:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8020b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c3:	74 07                	je     8020cc <print_blocks_list+0x73>
  8020c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c8:	8b 00                	mov    (%eax),%eax
  8020ca:	eb 05                	jmp    8020d1 <print_blocks_list+0x78>
  8020cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d1:	89 45 10             	mov    %eax,0x10(%ebp)
  8020d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	75 ad                	jne    802088 <print_blocks_list+0x2f>
  8020db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020df:	75 a7                	jne    802088 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020e1:	83 ec 0c             	sub    $0xc,%esp
  8020e4:	68 98 44 80 00       	push   $0x804498
  8020e9:	e8 c0 e5 ff ff       	call   8006ae <cprintf>
  8020ee:	83 c4 10             	add    $0x10,%esp

}
  8020f1:	90                   	nop
  8020f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802100:	83 e0 01             	and    $0x1,%eax
  802103:	85 c0                	test   %eax,%eax
  802105:	74 03                	je     80210a <initialize_dynamic_allocator+0x13>
  802107:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80210a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80210e:	0f 84 c7 01 00 00    	je     8022db <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802114:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80211b:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80211e:	8b 55 08             	mov    0x8(%ebp),%edx
  802121:	8b 45 0c             	mov    0xc(%ebp),%eax
  802124:	01 d0                	add    %edx,%eax
  802126:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80212b:	0f 87 ad 01 00 00    	ja     8022de <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	85 c0                	test   %eax,%eax
  802136:	0f 89 a5 01 00 00    	jns    8022e1 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80213c:	8b 55 08             	mov    0x8(%ebp),%edx
  80213f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802142:	01 d0                	add    %edx,%eax
  802144:	83 e8 04             	sub    $0x4,%eax
  802147:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80214c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802153:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802158:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80215b:	e9 87 00 00 00       	jmp    8021e7 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802160:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802164:	75 14                	jne    80217a <initialize_dynamic_allocator+0x83>
  802166:	83 ec 04             	sub    $0x4,%esp
  802169:	68 f3 44 80 00       	push   $0x8044f3
  80216e:	6a 79                	push   $0x79
  802170:	68 11 45 80 00       	push   $0x804511
  802175:	e8 77 e2 ff ff       	call   8003f1 <_panic>
  80217a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217d:	8b 00                	mov    (%eax),%eax
  80217f:	85 c0                	test   %eax,%eax
  802181:	74 10                	je     802193 <initialize_dynamic_allocator+0x9c>
  802183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802186:	8b 00                	mov    (%eax),%eax
  802188:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218b:	8b 52 04             	mov    0x4(%edx),%edx
  80218e:	89 50 04             	mov    %edx,0x4(%eax)
  802191:	eb 0b                	jmp    80219e <initialize_dynamic_allocator+0xa7>
  802193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802196:	8b 40 04             	mov    0x4(%eax),%eax
  802199:	a3 30 50 80 00       	mov    %eax,0x805030
  80219e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a1:	8b 40 04             	mov    0x4(%eax),%eax
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	74 0f                	je     8021b7 <initialize_dynamic_allocator+0xc0>
  8021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ab:	8b 40 04             	mov    0x4(%eax),%eax
  8021ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b1:	8b 12                	mov    (%edx),%edx
  8021b3:	89 10                	mov    %edx,(%eax)
  8021b5:	eb 0a                	jmp    8021c1 <initialize_dynamic_allocator+0xca>
  8021b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ba:	8b 00                	mov    (%eax),%eax
  8021bc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8021d9:	48                   	dec    %eax
  8021da:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021df:	a1 34 50 80 00       	mov    0x805034,%eax
  8021e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021eb:	74 07                	je     8021f4 <initialize_dynamic_allocator+0xfd>
  8021ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f0:	8b 00                	mov    (%eax),%eax
  8021f2:	eb 05                	jmp    8021f9 <initialize_dynamic_allocator+0x102>
  8021f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f9:	a3 34 50 80 00       	mov    %eax,0x805034
  8021fe:	a1 34 50 80 00       	mov    0x805034,%eax
  802203:	85 c0                	test   %eax,%eax
  802205:	0f 85 55 ff ff ff    	jne    802160 <initialize_dynamic_allocator+0x69>
  80220b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220f:	0f 85 4b ff ff ff    	jne    802160 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80221b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802224:	a1 44 50 80 00       	mov    0x805044,%eax
  802229:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80222e:	a1 40 50 80 00       	mov    0x805040,%eax
  802233:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	83 c0 08             	add    $0x8,%eax
  80223f:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	83 c0 04             	add    $0x4,%eax
  802248:	8b 55 0c             	mov    0xc(%ebp),%edx
  80224b:	83 ea 08             	sub    $0x8,%edx
  80224e:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802250:	8b 55 0c             	mov    0xc(%ebp),%edx
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	01 d0                	add    %edx,%eax
  802258:	83 e8 08             	sub    $0x8,%eax
  80225b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225e:	83 ea 08             	sub    $0x8,%edx
  802261:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802266:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80226c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802276:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80227a:	75 17                	jne    802293 <initialize_dynamic_allocator+0x19c>
  80227c:	83 ec 04             	sub    $0x4,%esp
  80227f:	68 2c 45 80 00       	push   $0x80452c
  802284:	68 90 00 00 00       	push   $0x90
  802289:	68 11 45 80 00       	push   $0x804511
  80228e:	e8 5e e1 ff ff       	call   8003f1 <_panic>
  802293:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802299:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229c:	89 10                	mov    %edx,(%eax)
  80229e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a1:	8b 00                	mov    (%eax),%eax
  8022a3:	85 c0                	test   %eax,%eax
  8022a5:	74 0d                	je     8022b4 <initialize_dynamic_allocator+0x1bd>
  8022a7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022af:	89 50 04             	mov    %edx,0x4(%eax)
  8022b2:	eb 08                	jmp    8022bc <initialize_dynamic_allocator+0x1c5>
  8022b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8022bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022bf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ce:	a1 38 50 80 00       	mov    0x805038,%eax
  8022d3:	40                   	inc    %eax
  8022d4:	a3 38 50 80 00       	mov    %eax,0x805038
  8022d9:	eb 07                	jmp    8022e2 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022db:	90                   	nop
  8022dc:	eb 04                	jmp    8022e2 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022de:	90                   	nop
  8022df:	eb 01                	jmp    8022e2 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022e1:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ea:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f0:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f6:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	83 e8 04             	sub    $0x4,%eax
  8022fe:	8b 00                	mov    (%eax),%eax
  802300:	83 e0 fe             	and    $0xfffffffe,%eax
  802303:	8d 50 f8             	lea    -0x8(%eax),%edx
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	01 c2                	add    %eax,%edx
  80230b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230e:	89 02                	mov    %eax,(%edx)
}
  802310:	90                   	nop
  802311:	5d                   	pop    %ebp
  802312:	c3                   	ret    

00802313 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
  802316:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	83 e0 01             	and    $0x1,%eax
  80231f:	85 c0                	test   %eax,%eax
  802321:	74 03                	je     802326 <alloc_block_FF+0x13>
  802323:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802326:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80232a:	77 07                	ja     802333 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80232c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802333:	a1 24 50 80 00       	mov    0x805024,%eax
  802338:	85 c0                	test   %eax,%eax
  80233a:	75 73                	jne    8023af <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80233c:	8b 45 08             	mov    0x8(%ebp),%eax
  80233f:	83 c0 10             	add    $0x10,%eax
  802342:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802345:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80234c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80234f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802352:	01 d0                	add    %edx,%eax
  802354:	48                   	dec    %eax
  802355:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802358:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80235b:	ba 00 00 00 00       	mov    $0x0,%edx
  802360:	f7 75 ec             	divl   -0x14(%ebp)
  802363:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802366:	29 d0                	sub    %edx,%eax
  802368:	c1 e8 0c             	shr    $0xc,%eax
  80236b:	83 ec 0c             	sub    $0xc,%esp
  80236e:	50                   	push   %eax
  80236f:	e8 d4 f0 ff ff       	call   801448 <sbrk>
  802374:	83 c4 10             	add    $0x10,%esp
  802377:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80237a:	83 ec 0c             	sub    $0xc,%esp
  80237d:	6a 00                	push   $0x0
  80237f:	e8 c4 f0 ff ff       	call   801448 <sbrk>
  802384:	83 c4 10             	add    $0x10,%esp
  802387:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80238a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80238d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802390:	83 ec 08             	sub    $0x8,%esp
  802393:	50                   	push   %eax
  802394:	ff 75 e4             	pushl  -0x1c(%ebp)
  802397:	e8 5b fd ff ff       	call   8020f7 <initialize_dynamic_allocator>
  80239c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80239f:	83 ec 0c             	sub    $0xc,%esp
  8023a2:	68 4f 45 80 00       	push   $0x80454f
  8023a7:	e8 02 e3 ff ff       	call   8006ae <cprintf>
  8023ac:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8023af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023b3:	75 0a                	jne    8023bf <alloc_block_FF+0xac>
	        return NULL;
  8023b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ba:	e9 0e 04 00 00       	jmp    8027cd <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8023bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023c6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ce:	e9 f3 02 00 00       	jmp    8026c6 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023d9:	83 ec 0c             	sub    $0xc,%esp
  8023dc:	ff 75 bc             	pushl  -0x44(%ebp)
  8023df:	e8 af fb ff ff       	call   801f93 <get_block_size>
  8023e4:	83 c4 10             	add    $0x10,%esp
  8023e7:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	83 c0 08             	add    $0x8,%eax
  8023f0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023f3:	0f 87 c5 02 00 00    	ja     8026be <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	83 c0 18             	add    $0x18,%eax
  8023ff:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802402:	0f 87 19 02 00 00    	ja     802621 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802408:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80240b:	2b 45 08             	sub    0x8(%ebp),%eax
  80240e:	83 e8 08             	sub    $0x8,%eax
  802411:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	8d 50 08             	lea    0x8(%eax),%edx
  80241a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80241d:	01 d0                	add    %edx,%eax
  80241f:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	83 c0 08             	add    $0x8,%eax
  802428:	83 ec 04             	sub    $0x4,%esp
  80242b:	6a 01                	push   $0x1
  80242d:	50                   	push   %eax
  80242e:	ff 75 bc             	pushl  -0x44(%ebp)
  802431:	e8 ae fe ff ff       	call   8022e4 <set_block_data>
  802436:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	8b 40 04             	mov    0x4(%eax),%eax
  80243f:	85 c0                	test   %eax,%eax
  802441:	75 68                	jne    8024ab <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802443:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802447:	75 17                	jne    802460 <alloc_block_FF+0x14d>
  802449:	83 ec 04             	sub    $0x4,%esp
  80244c:	68 2c 45 80 00       	push   $0x80452c
  802451:	68 d7 00 00 00       	push   $0xd7
  802456:	68 11 45 80 00       	push   $0x804511
  80245b:	e8 91 df ff ff       	call   8003f1 <_panic>
  802460:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802466:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802469:	89 10                	mov    %edx,(%eax)
  80246b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	85 c0                	test   %eax,%eax
  802472:	74 0d                	je     802481 <alloc_block_FF+0x16e>
  802474:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802479:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80247c:	89 50 04             	mov    %edx,0x4(%eax)
  80247f:	eb 08                	jmp    802489 <alloc_block_FF+0x176>
  802481:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802484:	a3 30 50 80 00       	mov    %eax,0x805030
  802489:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80248c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802491:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802494:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80249b:	a1 38 50 80 00       	mov    0x805038,%eax
  8024a0:	40                   	inc    %eax
  8024a1:	a3 38 50 80 00       	mov    %eax,0x805038
  8024a6:	e9 dc 00 00 00       	jmp    802587 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 00                	mov    (%eax),%eax
  8024b0:	85 c0                	test   %eax,%eax
  8024b2:	75 65                	jne    802519 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024b4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024b8:	75 17                	jne    8024d1 <alloc_block_FF+0x1be>
  8024ba:	83 ec 04             	sub    $0x4,%esp
  8024bd:	68 60 45 80 00       	push   $0x804560
  8024c2:	68 db 00 00 00       	push   $0xdb
  8024c7:	68 11 45 80 00       	push   $0x804511
  8024cc:	e8 20 df ff ff       	call   8003f1 <_panic>
  8024d1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024d7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024da:	89 50 04             	mov    %edx,0x4(%eax)
  8024dd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e0:	8b 40 04             	mov    0x4(%eax),%eax
  8024e3:	85 c0                	test   %eax,%eax
  8024e5:	74 0c                	je     8024f3 <alloc_block_FF+0x1e0>
  8024e7:	a1 30 50 80 00       	mov    0x805030,%eax
  8024ec:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024ef:	89 10                	mov    %edx,(%eax)
  8024f1:	eb 08                	jmp    8024fb <alloc_block_FF+0x1e8>
  8024f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024fe:	a3 30 50 80 00       	mov    %eax,0x805030
  802503:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802506:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80250c:	a1 38 50 80 00       	mov    0x805038,%eax
  802511:	40                   	inc    %eax
  802512:	a3 38 50 80 00       	mov    %eax,0x805038
  802517:	eb 6e                	jmp    802587 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802519:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251d:	74 06                	je     802525 <alloc_block_FF+0x212>
  80251f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802523:	75 17                	jne    80253c <alloc_block_FF+0x229>
  802525:	83 ec 04             	sub    $0x4,%esp
  802528:	68 84 45 80 00       	push   $0x804584
  80252d:	68 df 00 00 00       	push   $0xdf
  802532:	68 11 45 80 00       	push   $0x804511
  802537:	e8 b5 de ff ff       	call   8003f1 <_panic>
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 10                	mov    (%eax),%edx
  802541:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802544:	89 10                	mov    %edx,(%eax)
  802546:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802549:	8b 00                	mov    (%eax),%eax
  80254b:	85 c0                	test   %eax,%eax
  80254d:	74 0b                	je     80255a <alloc_block_FF+0x247>
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 00                	mov    (%eax),%eax
  802554:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802557:	89 50 04             	mov    %edx,0x4(%eax)
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802560:	89 10                	mov    %edx,(%eax)
  802562:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802565:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802568:	89 50 04             	mov    %edx,0x4(%eax)
  80256b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80256e:	8b 00                	mov    (%eax),%eax
  802570:	85 c0                	test   %eax,%eax
  802572:	75 08                	jne    80257c <alloc_block_FF+0x269>
  802574:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802577:	a3 30 50 80 00       	mov    %eax,0x805030
  80257c:	a1 38 50 80 00       	mov    0x805038,%eax
  802581:	40                   	inc    %eax
  802582:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258b:	75 17                	jne    8025a4 <alloc_block_FF+0x291>
  80258d:	83 ec 04             	sub    $0x4,%esp
  802590:	68 f3 44 80 00       	push   $0x8044f3
  802595:	68 e1 00 00 00       	push   $0xe1
  80259a:	68 11 45 80 00       	push   $0x804511
  80259f:	e8 4d de ff ff       	call   8003f1 <_panic>
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 00                	mov    (%eax),%eax
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	74 10                	je     8025bd <alloc_block_FF+0x2aa>
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	8b 00                	mov    (%eax),%eax
  8025b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b5:	8b 52 04             	mov    0x4(%edx),%edx
  8025b8:	89 50 04             	mov    %edx,0x4(%eax)
  8025bb:	eb 0b                	jmp    8025c8 <alloc_block_FF+0x2b5>
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	8b 40 04             	mov    0x4(%eax),%eax
  8025c3:	a3 30 50 80 00       	mov    %eax,0x805030
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	8b 40 04             	mov    0x4(%eax),%eax
  8025ce:	85 c0                	test   %eax,%eax
  8025d0:	74 0f                	je     8025e1 <alloc_block_FF+0x2ce>
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 40 04             	mov    0x4(%eax),%eax
  8025d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025db:	8b 12                	mov    (%edx),%edx
  8025dd:	89 10                	mov    %edx,(%eax)
  8025df:	eb 0a                	jmp    8025eb <alloc_block_FF+0x2d8>
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 00                	mov    (%eax),%eax
  8025e6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025fe:	a1 38 50 80 00       	mov    0x805038,%eax
  802603:	48                   	dec    %eax
  802604:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802609:	83 ec 04             	sub    $0x4,%esp
  80260c:	6a 00                	push   $0x0
  80260e:	ff 75 b4             	pushl  -0x4c(%ebp)
  802611:	ff 75 b0             	pushl  -0x50(%ebp)
  802614:	e8 cb fc ff ff       	call   8022e4 <set_block_data>
  802619:	83 c4 10             	add    $0x10,%esp
  80261c:	e9 95 00 00 00       	jmp    8026b6 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802621:	83 ec 04             	sub    $0x4,%esp
  802624:	6a 01                	push   $0x1
  802626:	ff 75 b8             	pushl  -0x48(%ebp)
  802629:	ff 75 bc             	pushl  -0x44(%ebp)
  80262c:	e8 b3 fc ff ff       	call   8022e4 <set_block_data>
  802631:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802634:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802638:	75 17                	jne    802651 <alloc_block_FF+0x33e>
  80263a:	83 ec 04             	sub    $0x4,%esp
  80263d:	68 f3 44 80 00       	push   $0x8044f3
  802642:	68 e8 00 00 00       	push   $0xe8
  802647:	68 11 45 80 00       	push   $0x804511
  80264c:	e8 a0 dd ff ff       	call   8003f1 <_panic>
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 00                	mov    (%eax),%eax
  802656:	85 c0                	test   %eax,%eax
  802658:	74 10                	je     80266a <alloc_block_FF+0x357>
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 00                	mov    (%eax),%eax
  80265f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802662:	8b 52 04             	mov    0x4(%edx),%edx
  802665:	89 50 04             	mov    %edx,0x4(%eax)
  802668:	eb 0b                	jmp    802675 <alloc_block_FF+0x362>
  80266a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266d:	8b 40 04             	mov    0x4(%eax),%eax
  802670:	a3 30 50 80 00       	mov    %eax,0x805030
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 40 04             	mov    0x4(%eax),%eax
  80267b:	85 c0                	test   %eax,%eax
  80267d:	74 0f                	je     80268e <alloc_block_FF+0x37b>
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 40 04             	mov    0x4(%eax),%eax
  802685:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802688:	8b 12                	mov    (%edx),%edx
  80268a:	89 10                	mov    %edx,(%eax)
  80268c:	eb 0a                	jmp    802698 <alloc_block_FF+0x385>
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	8b 00                	mov    (%eax),%eax
  802693:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ab:	a1 38 50 80 00       	mov    0x805038,%eax
  8026b0:	48                   	dec    %eax
  8026b1:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8026b6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026b9:	e9 0f 01 00 00       	jmp    8027cd <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8026be:	a1 34 50 80 00       	mov    0x805034,%eax
  8026c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ca:	74 07                	je     8026d3 <alloc_block_FF+0x3c0>
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	8b 00                	mov    (%eax),%eax
  8026d1:	eb 05                	jmp    8026d8 <alloc_block_FF+0x3c5>
  8026d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d8:	a3 34 50 80 00       	mov    %eax,0x805034
  8026dd:	a1 34 50 80 00       	mov    0x805034,%eax
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	0f 85 e9 fc ff ff    	jne    8023d3 <alloc_block_FF+0xc0>
  8026ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ee:	0f 85 df fc ff ff    	jne    8023d3 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f7:	83 c0 08             	add    $0x8,%eax
  8026fa:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026fd:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802704:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802707:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80270a:	01 d0                	add    %edx,%eax
  80270c:	48                   	dec    %eax
  80270d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802710:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802713:	ba 00 00 00 00       	mov    $0x0,%edx
  802718:	f7 75 d8             	divl   -0x28(%ebp)
  80271b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80271e:	29 d0                	sub    %edx,%eax
  802720:	c1 e8 0c             	shr    $0xc,%eax
  802723:	83 ec 0c             	sub    $0xc,%esp
  802726:	50                   	push   %eax
  802727:	e8 1c ed ff ff       	call   801448 <sbrk>
  80272c:	83 c4 10             	add    $0x10,%esp
  80272f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802732:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802736:	75 0a                	jne    802742 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802738:	b8 00 00 00 00       	mov    $0x0,%eax
  80273d:	e9 8b 00 00 00       	jmp    8027cd <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802742:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802749:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80274c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80274f:	01 d0                	add    %edx,%eax
  802751:	48                   	dec    %eax
  802752:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802755:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802758:	ba 00 00 00 00       	mov    $0x0,%edx
  80275d:	f7 75 cc             	divl   -0x34(%ebp)
  802760:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802763:	29 d0                	sub    %edx,%eax
  802765:	8d 50 fc             	lea    -0x4(%eax),%edx
  802768:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80276b:	01 d0                	add    %edx,%eax
  80276d:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802772:	a1 40 50 80 00       	mov    0x805040,%eax
  802777:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80277d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802784:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802787:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80278a:	01 d0                	add    %edx,%eax
  80278c:	48                   	dec    %eax
  80278d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802790:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802793:	ba 00 00 00 00       	mov    $0x0,%edx
  802798:	f7 75 c4             	divl   -0x3c(%ebp)
  80279b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80279e:	29 d0                	sub    %edx,%eax
  8027a0:	83 ec 04             	sub    $0x4,%esp
  8027a3:	6a 01                	push   $0x1
  8027a5:	50                   	push   %eax
  8027a6:	ff 75 d0             	pushl  -0x30(%ebp)
  8027a9:	e8 36 fb ff ff       	call   8022e4 <set_block_data>
  8027ae:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8027b1:	83 ec 0c             	sub    $0xc,%esp
  8027b4:	ff 75 d0             	pushl  -0x30(%ebp)
  8027b7:	e8 1b 0a 00 00       	call   8031d7 <free_block>
  8027bc:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8027bf:	83 ec 0c             	sub    $0xc,%esp
  8027c2:	ff 75 08             	pushl  0x8(%ebp)
  8027c5:	e8 49 fb ff ff       	call   802313 <alloc_block_FF>
  8027ca:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027cd:	c9                   	leave  
  8027ce:	c3                   	ret    

008027cf <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027cf:	55                   	push   %ebp
  8027d0:	89 e5                	mov    %esp,%ebp
  8027d2:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d8:	83 e0 01             	and    $0x1,%eax
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	74 03                	je     8027e2 <alloc_block_BF+0x13>
  8027df:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027e2:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027e6:	77 07                	ja     8027ef <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027e8:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027ef:	a1 24 50 80 00       	mov    0x805024,%eax
  8027f4:	85 c0                	test   %eax,%eax
  8027f6:	75 73                	jne    80286b <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fb:	83 c0 10             	add    $0x10,%eax
  8027fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802801:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802808:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80280b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80280e:	01 d0                	add    %edx,%eax
  802810:	48                   	dec    %eax
  802811:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802814:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802817:	ba 00 00 00 00       	mov    $0x0,%edx
  80281c:	f7 75 e0             	divl   -0x20(%ebp)
  80281f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802822:	29 d0                	sub    %edx,%eax
  802824:	c1 e8 0c             	shr    $0xc,%eax
  802827:	83 ec 0c             	sub    $0xc,%esp
  80282a:	50                   	push   %eax
  80282b:	e8 18 ec ff ff       	call   801448 <sbrk>
  802830:	83 c4 10             	add    $0x10,%esp
  802833:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802836:	83 ec 0c             	sub    $0xc,%esp
  802839:	6a 00                	push   $0x0
  80283b:	e8 08 ec ff ff       	call   801448 <sbrk>
  802840:	83 c4 10             	add    $0x10,%esp
  802843:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802846:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802849:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80284c:	83 ec 08             	sub    $0x8,%esp
  80284f:	50                   	push   %eax
  802850:	ff 75 d8             	pushl  -0x28(%ebp)
  802853:	e8 9f f8 ff ff       	call   8020f7 <initialize_dynamic_allocator>
  802858:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80285b:	83 ec 0c             	sub    $0xc,%esp
  80285e:	68 4f 45 80 00       	push   $0x80454f
  802863:	e8 46 de ff ff       	call   8006ae <cprintf>
  802868:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80286b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802872:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802879:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802880:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802887:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80288c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288f:	e9 1d 01 00 00       	jmp    8029b1 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80289a:	83 ec 0c             	sub    $0xc,%esp
  80289d:	ff 75 a8             	pushl  -0x58(%ebp)
  8028a0:	e8 ee f6 ff ff       	call   801f93 <get_block_size>
  8028a5:	83 c4 10             	add    $0x10,%esp
  8028a8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	83 c0 08             	add    $0x8,%eax
  8028b1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028b4:	0f 87 ef 00 00 00    	ja     8029a9 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bd:	83 c0 18             	add    $0x18,%eax
  8028c0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028c3:	77 1d                	ja     8028e2 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8028c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028cb:	0f 86 d8 00 00 00    	jbe    8029a9 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028d1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028dd:	e9 c7 00 00 00       	jmp    8029a9 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e5:	83 c0 08             	add    $0x8,%eax
  8028e8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028eb:	0f 85 9d 00 00 00    	jne    80298e <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028f1:	83 ec 04             	sub    $0x4,%esp
  8028f4:	6a 01                	push   $0x1
  8028f6:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028f9:	ff 75 a8             	pushl  -0x58(%ebp)
  8028fc:	e8 e3 f9 ff ff       	call   8022e4 <set_block_data>
  802901:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802904:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802908:	75 17                	jne    802921 <alloc_block_BF+0x152>
  80290a:	83 ec 04             	sub    $0x4,%esp
  80290d:	68 f3 44 80 00       	push   $0x8044f3
  802912:	68 2c 01 00 00       	push   $0x12c
  802917:	68 11 45 80 00       	push   $0x804511
  80291c:	e8 d0 da ff ff       	call   8003f1 <_panic>
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 00                	mov    (%eax),%eax
  802926:	85 c0                	test   %eax,%eax
  802928:	74 10                	je     80293a <alloc_block_BF+0x16b>
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 00                	mov    (%eax),%eax
  80292f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802932:	8b 52 04             	mov    0x4(%edx),%edx
  802935:	89 50 04             	mov    %edx,0x4(%eax)
  802938:	eb 0b                	jmp    802945 <alloc_block_BF+0x176>
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	8b 40 04             	mov    0x4(%eax),%eax
  802940:	a3 30 50 80 00       	mov    %eax,0x805030
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 40 04             	mov    0x4(%eax),%eax
  80294b:	85 c0                	test   %eax,%eax
  80294d:	74 0f                	je     80295e <alloc_block_BF+0x18f>
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	8b 40 04             	mov    0x4(%eax),%eax
  802955:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802958:	8b 12                	mov    (%edx),%edx
  80295a:	89 10                	mov    %edx,(%eax)
  80295c:	eb 0a                	jmp    802968 <alloc_block_BF+0x199>
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	8b 00                	mov    (%eax),%eax
  802963:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297b:	a1 38 50 80 00       	mov    0x805038,%eax
  802980:	48                   	dec    %eax
  802981:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802986:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802989:	e9 24 04 00 00       	jmp    802db2 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80298e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802991:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802994:	76 13                	jbe    8029a9 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802996:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80299d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8029a3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029a6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8029a9:	a1 34 50 80 00       	mov    0x805034,%eax
  8029ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b5:	74 07                	je     8029be <alloc_block_BF+0x1ef>
  8029b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ba:	8b 00                	mov    (%eax),%eax
  8029bc:	eb 05                	jmp    8029c3 <alloc_block_BF+0x1f4>
  8029be:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c3:	a3 34 50 80 00       	mov    %eax,0x805034
  8029c8:	a1 34 50 80 00       	mov    0x805034,%eax
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	0f 85 bf fe ff ff    	jne    802894 <alloc_block_BF+0xc5>
  8029d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d9:	0f 85 b5 fe ff ff    	jne    802894 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029e3:	0f 84 26 02 00 00    	je     802c0f <alloc_block_BF+0x440>
  8029e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029ed:	0f 85 1c 02 00 00    	jne    802c0f <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f6:	2b 45 08             	sub    0x8(%ebp),%eax
  8029f9:	83 e8 08             	sub    $0x8,%eax
  8029fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802a02:	8d 50 08             	lea    0x8(%eax),%edx
  802a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a08:	01 d0                	add    %edx,%eax
  802a0a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a10:	83 c0 08             	add    $0x8,%eax
  802a13:	83 ec 04             	sub    $0x4,%esp
  802a16:	6a 01                	push   $0x1
  802a18:	50                   	push   %eax
  802a19:	ff 75 f0             	pushl  -0x10(%ebp)
  802a1c:	e8 c3 f8 ff ff       	call   8022e4 <set_block_data>
  802a21:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a27:	8b 40 04             	mov    0x4(%eax),%eax
  802a2a:	85 c0                	test   %eax,%eax
  802a2c:	75 68                	jne    802a96 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a2e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a32:	75 17                	jne    802a4b <alloc_block_BF+0x27c>
  802a34:	83 ec 04             	sub    $0x4,%esp
  802a37:	68 2c 45 80 00       	push   $0x80452c
  802a3c:	68 45 01 00 00       	push   $0x145
  802a41:	68 11 45 80 00       	push   $0x804511
  802a46:	e8 a6 d9 ff ff       	call   8003f1 <_panic>
  802a4b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a51:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a54:	89 10                	mov    %edx,(%eax)
  802a56:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a59:	8b 00                	mov    (%eax),%eax
  802a5b:	85 c0                	test   %eax,%eax
  802a5d:	74 0d                	je     802a6c <alloc_block_BF+0x29d>
  802a5f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a64:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a67:	89 50 04             	mov    %edx,0x4(%eax)
  802a6a:	eb 08                	jmp    802a74 <alloc_block_BF+0x2a5>
  802a6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a6f:	a3 30 50 80 00       	mov    %eax,0x805030
  802a74:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a77:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a7c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a86:	a1 38 50 80 00       	mov    0x805038,%eax
  802a8b:	40                   	inc    %eax
  802a8c:	a3 38 50 80 00       	mov    %eax,0x805038
  802a91:	e9 dc 00 00 00       	jmp    802b72 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a99:	8b 00                	mov    (%eax),%eax
  802a9b:	85 c0                	test   %eax,%eax
  802a9d:	75 65                	jne    802b04 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a9f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802aa3:	75 17                	jne    802abc <alloc_block_BF+0x2ed>
  802aa5:	83 ec 04             	sub    $0x4,%esp
  802aa8:	68 60 45 80 00       	push   $0x804560
  802aad:	68 4a 01 00 00       	push   $0x14a
  802ab2:	68 11 45 80 00       	push   $0x804511
  802ab7:	e8 35 d9 ff ff       	call   8003f1 <_panic>
  802abc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ac2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac5:	89 50 04             	mov    %edx,0x4(%eax)
  802ac8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802acb:	8b 40 04             	mov    0x4(%eax),%eax
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	74 0c                	je     802ade <alloc_block_BF+0x30f>
  802ad2:	a1 30 50 80 00       	mov    0x805030,%eax
  802ad7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ada:	89 10                	mov    %edx,(%eax)
  802adc:	eb 08                	jmp    802ae6 <alloc_block_BF+0x317>
  802ade:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ae6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae9:	a3 30 50 80 00       	mov    %eax,0x805030
  802aee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af7:	a1 38 50 80 00       	mov    0x805038,%eax
  802afc:	40                   	inc    %eax
  802afd:	a3 38 50 80 00       	mov    %eax,0x805038
  802b02:	eb 6e                	jmp    802b72 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802b04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b08:	74 06                	je     802b10 <alloc_block_BF+0x341>
  802b0a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b0e:	75 17                	jne    802b27 <alloc_block_BF+0x358>
  802b10:	83 ec 04             	sub    $0x4,%esp
  802b13:	68 84 45 80 00       	push   $0x804584
  802b18:	68 4f 01 00 00       	push   $0x14f
  802b1d:	68 11 45 80 00       	push   $0x804511
  802b22:	e8 ca d8 ff ff       	call   8003f1 <_panic>
  802b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2a:	8b 10                	mov    (%eax),%edx
  802b2c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b2f:	89 10                	mov    %edx,(%eax)
  802b31:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b34:	8b 00                	mov    (%eax),%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	74 0b                	je     802b45 <alloc_block_BF+0x376>
  802b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3d:	8b 00                	mov    (%eax),%eax
  802b3f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b42:	89 50 04             	mov    %edx,0x4(%eax)
  802b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b48:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b4b:	89 10                	mov    %edx,(%eax)
  802b4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b50:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b53:	89 50 04             	mov    %edx,0x4(%eax)
  802b56:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b59:	8b 00                	mov    (%eax),%eax
  802b5b:	85 c0                	test   %eax,%eax
  802b5d:	75 08                	jne    802b67 <alloc_block_BF+0x398>
  802b5f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b62:	a3 30 50 80 00       	mov    %eax,0x805030
  802b67:	a1 38 50 80 00       	mov    0x805038,%eax
  802b6c:	40                   	inc    %eax
  802b6d:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b76:	75 17                	jne    802b8f <alloc_block_BF+0x3c0>
  802b78:	83 ec 04             	sub    $0x4,%esp
  802b7b:	68 f3 44 80 00       	push   $0x8044f3
  802b80:	68 51 01 00 00       	push   $0x151
  802b85:	68 11 45 80 00       	push   $0x804511
  802b8a:	e8 62 d8 ff ff       	call   8003f1 <_panic>
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	8b 00                	mov    (%eax),%eax
  802b94:	85 c0                	test   %eax,%eax
  802b96:	74 10                	je     802ba8 <alloc_block_BF+0x3d9>
  802b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9b:	8b 00                	mov    (%eax),%eax
  802b9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba0:	8b 52 04             	mov    0x4(%edx),%edx
  802ba3:	89 50 04             	mov    %edx,0x4(%eax)
  802ba6:	eb 0b                	jmp    802bb3 <alloc_block_BF+0x3e4>
  802ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bab:	8b 40 04             	mov    0x4(%eax),%eax
  802bae:	a3 30 50 80 00       	mov    %eax,0x805030
  802bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb6:	8b 40 04             	mov    0x4(%eax),%eax
  802bb9:	85 c0                	test   %eax,%eax
  802bbb:	74 0f                	je     802bcc <alloc_block_BF+0x3fd>
  802bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc0:	8b 40 04             	mov    0x4(%eax),%eax
  802bc3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc6:	8b 12                	mov    (%edx),%edx
  802bc8:	89 10                	mov    %edx,(%eax)
  802bca:	eb 0a                	jmp    802bd6 <alloc_block_BF+0x407>
  802bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcf:	8b 00                	mov    (%eax),%eax
  802bd1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be9:	a1 38 50 80 00       	mov    0x805038,%eax
  802bee:	48                   	dec    %eax
  802bef:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802bf4:	83 ec 04             	sub    $0x4,%esp
  802bf7:	6a 00                	push   $0x0
  802bf9:	ff 75 d0             	pushl  -0x30(%ebp)
  802bfc:	ff 75 cc             	pushl  -0x34(%ebp)
  802bff:	e8 e0 f6 ff ff       	call   8022e4 <set_block_data>
  802c04:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0a:	e9 a3 01 00 00       	jmp    802db2 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802c0f:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802c13:	0f 85 9d 00 00 00    	jne    802cb6 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c19:	83 ec 04             	sub    $0x4,%esp
  802c1c:	6a 01                	push   $0x1
  802c1e:	ff 75 ec             	pushl  -0x14(%ebp)
  802c21:	ff 75 f0             	pushl  -0x10(%ebp)
  802c24:	e8 bb f6 ff ff       	call   8022e4 <set_block_data>
  802c29:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c30:	75 17                	jne    802c49 <alloc_block_BF+0x47a>
  802c32:	83 ec 04             	sub    $0x4,%esp
  802c35:	68 f3 44 80 00       	push   $0x8044f3
  802c3a:	68 58 01 00 00       	push   $0x158
  802c3f:	68 11 45 80 00       	push   $0x804511
  802c44:	e8 a8 d7 ff ff       	call   8003f1 <_panic>
  802c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4c:	8b 00                	mov    (%eax),%eax
  802c4e:	85 c0                	test   %eax,%eax
  802c50:	74 10                	je     802c62 <alloc_block_BF+0x493>
  802c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c55:	8b 00                	mov    (%eax),%eax
  802c57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c5a:	8b 52 04             	mov    0x4(%edx),%edx
  802c5d:	89 50 04             	mov    %edx,0x4(%eax)
  802c60:	eb 0b                	jmp    802c6d <alloc_block_BF+0x49e>
  802c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c65:	8b 40 04             	mov    0x4(%eax),%eax
  802c68:	a3 30 50 80 00       	mov    %eax,0x805030
  802c6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c70:	8b 40 04             	mov    0x4(%eax),%eax
  802c73:	85 c0                	test   %eax,%eax
  802c75:	74 0f                	je     802c86 <alloc_block_BF+0x4b7>
  802c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7a:	8b 40 04             	mov    0x4(%eax),%eax
  802c7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c80:	8b 12                	mov    (%edx),%edx
  802c82:	89 10                	mov    %edx,(%eax)
  802c84:	eb 0a                	jmp    802c90 <alloc_block_BF+0x4c1>
  802c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c89:	8b 00                	mov    (%eax),%eax
  802c8b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca3:	a1 38 50 80 00       	mov    0x805038,%eax
  802ca8:	48                   	dec    %eax
  802ca9:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb1:	e9 fc 00 00 00       	jmp    802db2 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb9:	83 c0 08             	add    $0x8,%eax
  802cbc:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802cbf:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802cc6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cc9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ccc:	01 d0                	add    %edx,%eax
  802cce:	48                   	dec    %eax
  802ccf:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cd2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cd5:	ba 00 00 00 00       	mov    $0x0,%edx
  802cda:	f7 75 c4             	divl   -0x3c(%ebp)
  802cdd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ce0:	29 d0                	sub    %edx,%eax
  802ce2:	c1 e8 0c             	shr    $0xc,%eax
  802ce5:	83 ec 0c             	sub    $0xc,%esp
  802ce8:	50                   	push   %eax
  802ce9:	e8 5a e7 ff ff       	call   801448 <sbrk>
  802cee:	83 c4 10             	add    $0x10,%esp
  802cf1:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802cf4:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802cf8:	75 0a                	jne    802d04 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  802cff:	e9 ae 00 00 00       	jmp    802db2 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d04:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802d0b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d0e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d11:	01 d0                	add    %edx,%eax
  802d13:	48                   	dec    %eax
  802d14:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802d17:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d1a:	ba 00 00 00 00       	mov    $0x0,%edx
  802d1f:	f7 75 b8             	divl   -0x48(%ebp)
  802d22:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d25:	29 d0                	sub    %edx,%eax
  802d27:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d2a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d2d:	01 d0                	add    %edx,%eax
  802d2f:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d34:	a1 40 50 80 00       	mov    0x805040,%eax
  802d39:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d3f:	83 ec 0c             	sub    $0xc,%esp
  802d42:	68 b8 45 80 00       	push   $0x8045b8
  802d47:	e8 62 d9 ff ff       	call   8006ae <cprintf>
  802d4c:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d4f:	83 ec 08             	sub    $0x8,%esp
  802d52:	ff 75 bc             	pushl  -0x44(%ebp)
  802d55:	68 bd 45 80 00       	push   $0x8045bd
  802d5a:	e8 4f d9 ff ff       	call   8006ae <cprintf>
  802d5f:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d62:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d69:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d6c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d6f:	01 d0                	add    %edx,%eax
  802d71:	48                   	dec    %eax
  802d72:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d75:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d78:	ba 00 00 00 00       	mov    $0x0,%edx
  802d7d:	f7 75 b0             	divl   -0x50(%ebp)
  802d80:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d83:	29 d0                	sub    %edx,%eax
  802d85:	83 ec 04             	sub    $0x4,%esp
  802d88:	6a 01                	push   $0x1
  802d8a:	50                   	push   %eax
  802d8b:	ff 75 bc             	pushl  -0x44(%ebp)
  802d8e:	e8 51 f5 ff ff       	call   8022e4 <set_block_data>
  802d93:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d96:	83 ec 0c             	sub    $0xc,%esp
  802d99:	ff 75 bc             	pushl  -0x44(%ebp)
  802d9c:	e8 36 04 00 00       	call   8031d7 <free_block>
  802da1:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802da4:	83 ec 0c             	sub    $0xc,%esp
  802da7:	ff 75 08             	pushl  0x8(%ebp)
  802daa:	e8 20 fa ff ff       	call   8027cf <alloc_block_BF>
  802daf:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802db2:	c9                   	leave  
  802db3:	c3                   	ret    

00802db4 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802db4:	55                   	push   %ebp
  802db5:	89 e5                	mov    %esp,%ebp
  802db7:	53                   	push   %ebx
  802db8:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802dbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802dc2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802dc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dcd:	74 1e                	je     802ded <merging+0x39>
  802dcf:	ff 75 08             	pushl  0x8(%ebp)
  802dd2:	e8 bc f1 ff ff       	call   801f93 <get_block_size>
  802dd7:	83 c4 04             	add    $0x4,%esp
  802dda:	89 c2                	mov    %eax,%edx
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	01 d0                	add    %edx,%eax
  802de1:	3b 45 10             	cmp    0x10(%ebp),%eax
  802de4:	75 07                	jne    802ded <merging+0x39>
		prev_is_free = 1;
  802de6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802ded:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802df1:	74 1e                	je     802e11 <merging+0x5d>
  802df3:	ff 75 10             	pushl  0x10(%ebp)
  802df6:	e8 98 f1 ff ff       	call   801f93 <get_block_size>
  802dfb:	83 c4 04             	add    $0x4,%esp
  802dfe:	89 c2                	mov    %eax,%edx
  802e00:	8b 45 10             	mov    0x10(%ebp),%eax
  802e03:	01 d0                	add    %edx,%eax
  802e05:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e08:	75 07                	jne    802e11 <merging+0x5d>
		next_is_free = 1;
  802e0a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802e11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e15:	0f 84 cc 00 00 00    	je     802ee7 <merging+0x133>
  802e1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e1f:	0f 84 c2 00 00 00    	je     802ee7 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e25:	ff 75 08             	pushl  0x8(%ebp)
  802e28:	e8 66 f1 ff ff       	call   801f93 <get_block_size>
  802e2d:	83 c4 04             	add    $0x4,%esp
  802e30:	89 c3                	mov    %eax,%ebx
  802e32:	ff 75 10             	pushl  0x10(%ebp)
  802e35:	e8 59 f1 ff ff       	call   801f93 <get_block_size>
  802e3a:	83 c4 04             	add    $0x4,%esp
  802e3d:	01 c3                	add    %eax,%ebx
  802e3f:	ff 75 0c             	pushl  0xc(%ebp)
  802e42:	e8 4c f1 ff ff       	call   801f93 <get_block_size>
  802e47:	83 c4 04             	add    $0x4,%esp
  802e4a:	01 d8                	add    %ebx,%eax
  802e4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e4f:	6a 00                	push   $0x0
  802e51:	ff 75 ec             	pushl  -0x14(%ebp)
  802e54:	ff 75 08             	pushl  0x8(%ebp)
  802e57:	e8 88 f4 ff ff       	call   8022e4 <set_block_data>
  802e5c:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e63:	75 17                	jne    802e7c <merging+0xc8>
  802e65:	83 ec 04             	sub    $0x4,%esp
  802e68:	68 f3 44 80 00       	push   $0x8044f3
  802e6d:	68 7d 01 00 00       	push   $0x17d
  802e72:	68 11 45 80 00       	push   $0x804511
  802e77:	e8 75 d5 ff ff       	call   8003f1 <_panic>
  802e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7f:	8b 00                	mov    (%eax),%eax
  802e81:	85 c0                	test   %eax,%eax
  802e83:	74 10                	je     802e95 <merging+0xe1>
  802e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e88:	8b 00                	mov    (%eax),%eax
  802e8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e8d:	8b 52 04             	mov    0x4(%edx),%edx
  802e90:	89 50 04             	mov    %edx,0x4(%eax)
  802e93:	eb 0b                	jmp    802ea0 <merging+0xec>
  802e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e98:	8b 40 04             	mov    0x4(%eax),%eax
  802e9b:	a3 30 50 80 00       	mov    %eax,0x805030
  802ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea3:	8b 40 04             	mov    0x4(%eax),%eax
  802ea6:	85 c0                	test   %eax,%eax
  802ea8:	74 0f                	je     802eb9 <merging+0x105>
  802eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ead:	8b 40 04             	mov    0x4(%eax),%eax
  802eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb3:	8b 12                	mov    (%edx),%edx
  802eb5:	89 10                	mov    %edx,(%eax)
  802eb7:	eb 0a                	jmp    802ec3 <merging+0x10f>
  802eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ebc:	8b 00                	mov    (%eax),%eax
  802ebe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ecf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed6:	a1 38 50 80 00       	mov    0x805038,%eax
  802edb:	48                   	dec    %eax
  802edc:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802ee1:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ee2:	e9 ea 02 00 00       	jmp    8031d1 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ee7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eeb:	74 3b                	je     802f28 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802eed:	83 ec 0c             	sub    $0xc,%esp
  802ef0:	ff 75 08             	pushl  0x8(%ebp)
  802ef3:	e8 9b f0 ff ff       	call   801f93 <get_block_size>
  802ef8:	83 c4 10             	add    $0x10,%esp
  802efb:	89 c3                	mov    %eax,%ebx
  802efd:	83 ec 0c             	sub    $0xc,%esp
  802f00:	ff 75 10             	pushl  0x10(%ebp)
  802f03:	e8 8b f0 ff ff       	call   801f93 <get_block_size>
  802f08:	83 c4 10             	add    $0x10,%esp
  802f0b:	01 d8                	add    %ebx,%eax
  802f0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f10:	83 ec 04             	sub    $0x4,%esp
  802f13:	6a 00                	push   $0x0
  802f15:	ff 75 e8             	pushl  -0x18(%ebp)
  802f18:	ff 75 08             	pushl  0x8(%ebp)
  802f1b:	e8 c4 f3 ff ff       	call   8022e4 <set_block_data>
  802f20:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f23:	e9 a9 02 00 00       	jmp    8031d1 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f2c:	0f 84 2d 01 00 00    	je     80305f <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f32:	83 ec 0c             	sub    $0xc,%esp
  802f35:	ff 75 10             	pushl  0x10(%ebp)
  802f38:	e8 56 f0 ff ff       	call   801f93 <get_block_size>
  802f3d:	83 c4 10             	add    $0x10,%esp
  802f40:	89 c3                	mov    %eax,%ebx
  802f42:	83 ec 0c             	sub    $0xc,%esp
  802f45:	ff 75 0c             	pushl  0xc(%ebp)
  802f48:	e8 46 f0 ff ff       	call   801f93 <get_block_size>
  802f4d:	83 c4 10             	add    $0x10,%esp
  802f50:	01 d8                	add    %ebx,%eax
  802f52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f55:	83 ec 04             	sub    $0x4,%esp
  802f58:	6a 00                	push   $0x0
  802f5a:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f5d:	ff 75 10             	pushl  0x10(%ebp)
  802f60:	e8 7f f3 ff ff       	call   8022e4 <set_block_data>
  802f65:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f68:	8b 45 10             	mov    0x10(%ebp),%eax
  802f6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f72:	74 06                	je     802f7a <merging+0x1c6>
  802f74:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f78:	75 17                	jne    802f91 <merging+0x1dd>
  802f7a:	83 ec 04             	sub    $0x4,%esp
  802f7d:	68 cc 45 80 00       	push   $0x8045cc
  802f82:	68 8d 01 00 00       	push   $0x18d
  802f87:	68 11 45 80 00       	push   $0x804511
  802f8c:	e8 60 d4 ff ff       	call   8003f1 <_panic>
  802f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f94:	8b 50 04             	mov    0x4(%eax),%edx
  802f97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f9a:	89 50 04             	mov    %edx,0x4(%eax)
  802f9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fa3:	89 10                	mov    %edx,(%eax)
  802fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa8:	8b 40 04             	mov    0x4(%eax),%eax
  802fab:	85 c0                	test   %eax,%eax
  802fad:	74 0d                	je     802fbc <merging+0x208>
  802faf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb2:	8b 40 04             	mov    0x4(%eax),%eax
  802fb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fb8:	89 10                	mov    %edx,(%eax)
  802fba:	eb 08                	jmp    802fc4 <merging+0x210>
  802fbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fbf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fca:	89 50 04             	mov    %edx,0x4(%eax)
  802fcd:	a1 38 50 80 00       	mov    0x805038,%eax
  802fd2:	40                   	inc    %eax
  802fd3:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802fd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fdc:	75 17                	jne    802ff5 <merging+0x241>
  802fde:	83 ec 04             	sub    $0x4,%esp
  802fe1:	68 f3 44 80 00       	push   $0x8044f3
  802fe6:	68 8e 01 00 00       	push   $0x18e
  802feb:	68 11 45 80 00       	push   $0x804511
  802ff0:	e8 fc d3 ff ff       	call   8003f1 <_panic>
  802ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff8:	8b 00                	mov    (%eax),%eax
  802ffa:	85 c0                	test   %eax,%eax
  802ffc:	74 10                	je     80300e <merging+0x25a>
  802ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803001:	8b 00                	mov    (%eax),%eax
  803003:	8b 55 0c             	mov    0xc(%ebp),%edx
  803006:	8b 52 04             	mov    0x4(%edx),%edx
  803009:	89 50 04             	mov    %edx,0x4(%eax)
  80300c:	eb 0b                	jmp    803019 <merging+0x265>
  80300e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803011:	8b 40 04             	mov    0x4(%eax),%eax
  803014:	a3 30 50 80 00       	mov    %eax,0x805030
  803019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301c:	8b 40 04             	mov    0x4(%eax),%eax
  80301f:	85 c0                	test   %eax,%eax
  803021:	74 0f                	je     803032 <merging+0x27e>
  803023:	8b 45 0c             	mov    0xc(%ebp),%eax
  803026:	8b 40 04             	mov    0x4(%eax),%eax
  803029:	8b 55 0c             	mov    0xc(%ebp),%edx
  80302c:	8b 12                	mov    (%edx),%edx
  80302e:	89 10                	mov    %edx,(%eax)
  803030:	eb 0a                	jmp    80303c <merging+0x288>
  803032:	8b 45 0c             	mov    0xc(%ebp),%eax
  803035:	8b 00                	mov    (%eax),%eax
  803037:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80303c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803045:	8b 45 0c             	mov    0xc(%ebp),%eax
  803048:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304f:	a1 38 50 80 00       	mov    0x805038,%eax
  803054:	48                   	dec    %eax
  803055:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80305a:	e9 72 01 00 00       	jmp    8031d1 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80305f:	8b 45 10             	mov    0x10(%ebp),%eax
  803062:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803065:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803069:	74 79                	je     8030e4 <merging+0x330>
  80306b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80306f:	74 73                	je     8030e4 <merging+0x330>
  803071:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803075:	74 06                	je     80307d <merging+0x2c9>
  803077:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80307b:	75 17                	jne    803094 <merging+0x2e0>
  80307d:	83 ec 04             	sub    $0x4,%esp
  803080:	68 84 45 80 00       	push   $0x804584
  803085:	68 94 01 00 00       	push   $0x194
  80308a:	68 11 45 80 00       	push   $0x804511
  80308f:	e8 5d d3 ff ff       	call   8003f1 <_panic>
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	8b 10                	mov    (%eax),%edx
  803099:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80309c:	89 10                	mov    %edx,(%eax)
  80309e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a1:	8b 00                	mov    (%eax),%eax
  8030a3:	85 c0                	test   %eax,%eax
  8030a5:	74 0b                	je     8030b2 <merging+0x2fe>
  8030a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030aa:	8b 00                	mov    (%eax),%eax
  8030ac:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030af:	89 50 04             	mov    %edx,0x4(%eax)
  8030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030b8:	89 10                	mov    %edx,(%eax)
  8030ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c0:	89 50 04             	mov    %edx,0x4(%eax)
  8030c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c6:	8b 00                	mov    (%eax),%eax
  8030c8:	85 c0                	test   %eax,%eax
  8030ca:	75 08                	jne    8030d4 <merging+0x320>
  8030cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030cf:	a3 30 50 80 00       	mov    %eax,0x805030
  8030d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8030d9:	40                   	inc    %eax
  8030da:	a3 38 50 80 00       	mov    %eax,0x805038
  8030df:	e9 ce 00 00 00       	jmp    8031b2 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8030e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e8:	74 65                	je     80314f <merging+0x39b>
  8030ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030ee:	75 17                	jne    803107 <merging+0x353>
  8030f0:	83 ec 04             	sub    $0x4,%esp
  8030f3:	68 60 45 80 00       	push   $0x804560
  8030f8:	68 95 01 00 00       	push   $0x195
  8030fd:	68 11 45 80 00       	push   $0x804511
  803102:	e8 ea d2 ff ff       	call   8003f1 <_panic>
  803107:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80310d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803110:	89 50 04             	mov    %edx,0x4(%eax)
  803113:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803116:	8b 40 04             	mov    0x4(%eax),%eax
  803119:	85 c0                	test   %eax,%eax
  80311b:	74 0c                	je     803129 <merging+0x375>
  80311d:	a1 30 50 80 00       	mov    0x805030,%eax
  803122:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803125:	89 10                	mov    %edx,(%eax)
  803127:	eb 08                	jmp    803131 <merging+0x37d>
  803129:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803131:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803134:	a3 30 50 80 00       	mov    %eax,0x805030
  803139:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80313c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803142:	a1 38 50 80 00       	mov    0x805038,%eax
  803147:	40                   	inc    %eax
  803148:	a3 38 50 80 00       	mov    %eax,0x805038
  80314d:	eb 63                	jmp    8031b2 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80314f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803153:	75 17                	jne    80316c <merging+0x3b8>
  803155:	83 ec 04             	sub    $0x4,%esp
  803158:	68 2c 45 80 00       	push   $0x80452c
  80315d:	68 98 01 00 00       	push   $0x198
  803162:	68 11 45 80 00       	push   $0x804511
  803167:	e8 85 d2 ff ff       	call   8003f1 <_panic>
  80316c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803172:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803175:	89 10                	mov    %edx,(%eax)
  803177:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80317a:	8b 00                	mov    (%eax),%eax
  80317c:	85 c0                	test   %eax,%eax
  80317e:	74 0d                	je     80318d <merging+0x3d9>
  803180:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803185:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803188:	89 50 04             	mov    %edx,0x4(%eax)
  80318b:	eb 08                	jmp    803195 <merging+0x3e1>
  80318d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803190:	a3 30 50 80 00       	mov    %eax,0x805030
  803195:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803198:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80319d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a7:	a1 38 50 80 00       	mov    0x805038,%eax
  8031ac:	40                   	inc    %eax
  8031ad:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8031b2:	83 ec 0c             	sub    $0xc,%esp
  8031b5:	ff 75 10             	pushl  0x10(%ebp)
  8031b8:	e8 d6 ed ff ff       	call   801f93 <get_block_size>
  8031bd:	83 c4 10             	add    $0x10,%esp
  8031c0:	83 ec 04             	sub    $0x4,%esp
  8031c3:	6a 00                	push   $0x0
  8031c5:	50                   	push   %eax
  8031c6:	ff 75 10             	pushl  0x10(%ebp)
  8031c9:	e8 16 f1 ff ff       	call   8022e4 <set_block_data>
  8031ce:	83 c4 10             	add    $0x10,%esp
	}
}
  8031d1:	90                   	nop
  8031d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031d5:	c9                   	leave  
  8031d6:	c3                   	ret    

008031d7 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031d7:	55                   	push   %ebp
  8031d8:	89 e5                	mov    %esp,%ebp
  8031da:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031dd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031e2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8031e5:	a1 30 50 80 00       	mov    0x805030,%eax
  8031ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ed:	73 1b                	jae    80320a <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031ef:	a1 30 50 80 00       	mov    0x805030,%eax
  8031f4:	83 ec 04             	sub    $0x4,%esp
  8031f7:	ff 75 08             	pushl  0x8(%ebp)
  8031fa:	6a 00                	push   $0x0
  8031fc:	50                   	push   %eax
  8031fd:	e8 b2 fb ff ff       	call   802db4 <merging>
  803202:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803205:	e9 8b 00 00 00       	jmp    803295 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80320a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80320f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803212:	76 18                	jbe    80322c <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803214:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803219:	83 ec 04             	sub    $0x4,%esp
  80321c:	ff 75 08             	pushl  0x8(%ebp)
  80321f:	50                   	push   %eax
  803220:	6a 00                	push   $0x0
  803222:	e8 8d fb ff ff       	call   802db4 <merging>
  803227:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80322a:	eb 69                	jmp    803295 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80322c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803231:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803234:	eb 39                	jmp    80326f <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803239:	3b 45 08             	cmp    0x8(%ebp),%eax
  80323c:	73 29                	jae    803267 <free_block+0x90>
  80323e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803241:	8b 00                	mov    (%eax),%eax
  803243:	3b 45 08             	cmp    0x8(%ebp),%eax
  803246:	76 1f                	jbe    803267 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324b:	8b 00                	mov    (%eax),%eax
  80324d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803250:	83 ec 04             	sub    $0x4,%esp
  803253:	ff 75 08             	pushl  0x8(%ebp)
  803256:	ff 75 f0             	pushl  -0x10(%ebp)
  803259:	ff 75 f4             	pushl  -0xc(%ebp)
  80325c:	e8 53 fb ff ff       	call   802db4 <merging>
  803261:	83 c4 10             	add    $0x10,%esp
			break;
  803264:	90                   	nop
		}
	}
}
  803265:	eb 2e                	jmp    803295 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803267:	a1 34 50 80 00       	mov    0x805034,%eax
  80326c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80326f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803273:	74 07                	je     80327c <free_block+0xa5>
  803275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803278:	8b 00                	mov    (%eax),%eax
  80327a:	eb 05                	jmp    803281 <free_block+0xaa>
  80327c:	b8 00 00 00 00       	mov    $0x0,%eax
  803281:	a3 34 50 80 00       	mov    %eax,0x805034
  803286:	a1 34 50 80 00       	mov    0x805034,%eax
  80328b:	85 c0                	test   %eax,%eax
  80328d:	75 a7                	jne    803236 <free_block+0x5f>
  80328f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803293:	75 a1                	jne    803236 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803295:	90                   	nop
  803296:	c9                   	leave  
  803297:	c3                   	ret    

00803298 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803298:	55                   	push   %ebp
  803299:	89 e5                	mov    %esp,%ebp
  80329b:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80329e:	ff 75 08             	pushl  0x8(%ebp)
  8032a1:	e8 ed ec ff ff       	call   801f93 <get_block_size>
  8032a6:	83 c4 04             	add    $0x4,%esp
  8032a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8032ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8032b3:	eb 17                	jmp    8032cc <copy_data+0x34>
  8032b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032bb:	01 c2                	add    %eax,%edx
  8032bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c3:	01 c8                	add    %ecx,%eax
  8032c5:	8a 00                	mov    (%eax),%al
  8032c7:	88 02                	mov    %al,(%edx)
  8032c9:	ff 45 fc             	incl   -0x4(%ebp)
  8032cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032d2:	72 e1                	jb     8032b5 <copy_data+0x1d>
}
  8032d4:	90                   	nop
  8032d5:	c9                   	leave  
  8032d6:	c3                   	ret    

008032d7 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032d7:	55                   	push   %ebp
  8032d8:	89 e5                	mov    %esp,%ebp
  8032da:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e1:	75 23                	jne    803306 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8032e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032e7:	74 13                	je     8032fc <realloc_block_FF+0x25>
  8032e9:	83 ec 0c             	sub    $0xc,%esp
  8032ec:	ff 75 0c             	pushl  0xc(%ebp)
  8032ef:	e8 1f f0 ff ff       	call   802313 <alloc_block_FF>
  8032f4:	83 c4 10             	add    $0x10,%esp
  8032f7:	e9 f4 06 00 00       	jmp    8039f0 <realloc_block_FF+0x719>
		return NULL;
  8032fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803301:	e9 ea 06 00 00       	jmp    8039f0 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803306:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80330a:	75 18                	jne    803324 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80330c:	83 ec 0c             	sub    $0xc,%esp
  80330f:	ff 75 08             	pushl  0x8(%ebp)
  803312:	e8 c0 fe ff ff       	call   8031d7 <free_block>
  803317:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80331a:	b8 00 00 00 00       	mov    $0x0,%eax
  80331f:	e9 cc 06 00 00       	jmp    8039f0 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803324:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803328:	77 07                	ja     803331 <realloc_block_FF+0x5a>
  80332a:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803331:	8b 45 0c             	mov    0xc(%ebp),%eax
  803334:	83 e0 01             	and    $0x1,%eax
  803337:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80333a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80333d:	83 c0 08             	add    $0x8,%eax
  803340:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803343:	83 ec 0c             	sub    $0xc,%esp
  803346:	ff 75 08             	pushl  0x8(%ebp)
  803349:	e8 45 ec ff ff       	call   801f93 <get_block_size>
  80334e:	83 c4 10             	add    $0x10,%esp
  803351:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803357:	83 e8 08             	sub    $0x8,%eax
  80335a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80335d:	8b 45 08             	mov    0x8(%ebp),%eax
  803360:	83 e8 04             	sub    $0x4,%eax
  803363:	8b 00                	mov    (%eax),%eax
  803365:	83 e0 fe             	and    $0xfffffffe,%eax
  803368:	89 c2                	mov    %eax,%edx
  80336a:	8b 45 08             	mov    0x8(%ebp),%eax
  80336d:	01 d0                	add    %edx,%eax
  80336f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803372:	83 ec 0c             	sub    $0xc,%esp
  803375:	ff 75 e4             	pushl  -0x1c(%ebp)
  803378:	e8 16 ec ff ff       	call   801f93 <get_block_size>
  80337d:	83 c4 10             	add    $0x10,%esp
  803380:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803383:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803386:	83 e8 08             	sub    $0x8,%eax
  803389:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80338c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80338f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803392:	75 08                	jne    80339c <realloc_block_FF+0xc5>
	{
		 return va;
  803394:	8b 45 08             	mov    0x8(%ebp),%eax
  803397:	e9 54 06 00 00       	jmp    8039f0 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80339c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80339f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033a2:	0f 83 e5 03 00 00    	jae    80378d <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8033a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ab:	2b 45 0c             	sub    0xc(%ebp),%eax
  8033ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8033b1:	83 ec 0c             	sub    $0xc,%esp
  8033b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033b7:	e8 f0 eb ff ff       	call   801fac <is_free_block>
  8033bc:	83 c4 10             	add    $0x10,%esp
  8033bf:	84 c0                	test   %al,%al
  8033c1:	0f 84 3b 01 00 00    	je     803502 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8033c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033cd:	01 d0                	add    %edx,%eax
  8033cf:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8033d2:	83 ec 04             	sub    $0x4,%esp
  8033d5:	6a 01                	push   $0x1
  8033d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8033da:	ff 75 08             	pushl  0x8(%ebp)
  8033dd:	e8 02 ef ff ff       	call   8022e4 <set_block_data>
  8033e2:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8033e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e8:	83 e8 04             	sub    $0x4,%eax
  8033eb:	8b 00                	mov    (%eax),%eax
  8033ed:	83 e0 fe             	and    $0xfffffffe,%eax
  8033f0:	89 c2                	mov    %eax,%edx
  8033f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f5:	01 d0                	add    %edx,%eax
  8033f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033fa:	83 ec 04             	sub    $0x4,%esp
  8033fd:	6a 00                	push   $0x0
  8033ff:	ff 75 cc             	pushl  -0x34(%ebp)
  803402:	ff 75 c8             	pushl  -0x38(%ebp)
  803405:	e8 da ee ff ff       	call   8022e4 <set_block_data>
  80340a:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80340d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803411:	74 06                	je     803419 <realloc_block_FF+0x142>
  803413:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803417:	75 17                	jne    803430 <realloc_block_FF+0x159>
  803419:	83 ec 04             	sub    $0x4,%esp
  80341c:	68 84 45 80 00       	push   $0x804584
  803421:	68 f6 01 00 00       	push   $0x1f6
  803426:	68 11 45 80 00       	push   $0x804511
  80342b:	e8 c1 cf ff ff       	call   8003f1 <_panic>
  803430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803433:	8b 10                	mov    (%eax),%edx
  803435:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803438:	89 10                	mov    %edx,(%eax)
  80343a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80343d:	8b 00                	mov    (%eax),%eax
  80343f:	85 c0                	test   %eax,%eax
  803441:	74 0b                	je     80344e <realloc_block_FF+0x177>
  803443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803446:	8b 00                	mov    (%eax),%eax
  803448:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80344b:	89 50 04             	mov    %edx,0x4(%eax)
  80344e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803451:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803454:	89 10                	mov    %edx,(%eax)
  803456:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803459:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80345c:	89 50 04             	mov    %edx,0x4(%eax)
  80345f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803462:	8b 00                	mov    (%eax),%eax
  803464:	85 c0                	test   %eax,%eax
  803466:	75 08                	jne    803470 <realloc_block_FF+0x199>
  803468:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80346b:	a3 30 50 80 00       	mov    %eax,0x805030
  803470:	a1 38 50 80 00       	mov    0x805038,%eax
  803475:	40                   	inc    %eax
  803476:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80347b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80347f:	75 17                	jne    803498 <realloc_block_FF+0x1c1>
  803481:	83 ec 04             	sub    $0x4,%esp
  803484:	68 f3 44 80 00       	push   $0x8044f3
  803489:	68 f7 01 00 00       	push   $0x1f7
  80348e:	68 11 45 80 00       	push   $0x804511
  803493:	e8 59 cf ff ff       	call   8003f1 <_panic>
  803498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80349b:	8b 00                	mov    (%eax),%eax
  80349d:	85 c0                	test   %eax,%eax
  80349f:	74 10                	je     8034b1 <realloc_block_FF+0x1da>
  8034a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a4:	8b 00                	mov    (%eax),%eax
  8034a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034a9:	8b 52 04             	mov    0x4(%edx),%edx
  8034ac:	89 50 04             	mov    %edx,0x4(%eax)
  8034af:	eb 0b                	jmp    8034bc <realloc_block_FF+0x1e5>
  8034b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b4:	8b 40 04             	mov    0x4(%eax),%eax
  8034b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8034bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034bf:	8b 40 04             	mov    0x4(%eax),%eax
  8034c2:	85 c0                	test   %eax,%eax
  8034c4:	74 0f                	je     8034d5 <realloc_block_FF+0x1fe>
  8034c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c9:	8b 40 04             	mov    0x4(%eax),%eax
  8034cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034cf:	8b 12                	mov    (%edx),%edx
  8034d1:	89 10                	mov    %edx,(%eax)
  8034d3:	eb 0a                	jmp    8034df <realloc_block_FF+0x208>
  8034d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d8:	8b 00                	mov    (%eax),%eax
  8034da:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f2:	a1 38 50 80 00       	mov    0x805038,%eax
  8034f7:	48                   	dec    %eax
  8034f8:	a3 38 50 80 00       	mov    %eax,0x805038
  8034fd:	e9 83 02 00 00       	jmp    803785 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803502:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803506:	0f 86 69 02 00 00    	jbe    803775 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80350c:	83 ec 04             	sub    $0x4,%esp
  80350f:	6a 01                	push   $0x1
  803511:	ff 75 f0             	pushl  -0x10(%ebp)
  803514:	ff 75 08             	pushl  0x8(%ebp)
  803517:	e8 c8 ed ff ff       	call   8022e4 <set_block_data>
  80351c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80351f:	8b 45 08             	mov    0x8(%ebp),%eax
  803522:	83 e8 04             	sub    $0x4,%eax
  803525:	8b 00                	mov    (%eax),%eax
  803527:	83 e0 fe             	and    $0xfffffffe,%eax
  80352a:	89 c2                	mov    %eax,%edx
  80352c:	8b 45 08             	mov    0x8(%ebp),%eax
  80352f:	01 d0                	add    %edx,%eax
  803531:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803534:	a1 38 50 80 00       	mov    0x805038,%eax
  803539:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80353c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803540:	75 68                	jne    8035aa <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803542:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803546:	75 17                	jne    80355f <realloc_block_FF+0x288>
  803548:	83 ec 04             	sub    $0x4,%esp
  80354b:	68 2c 45 80 00       	push   $0x80452c
  803550:	68 06 02 00 00       	push   $0x206
  803555:	68 11 45 80 00       	push   $0x804511
  80355a:	e8 92 ce ff ff       	call   8003f1 <_panic>
  80355f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803565:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803568:	89 10                	mov    %edx,(%eax)
  80356a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356d:	8b 00                	mov    (%eax),%eax
  80356f:	85 c0                	test   %eax,%eax
  803571:	74 0d                	je     803580 <realloc_block_FF+0x2a9>
  803573:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803578:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80357b:	89 50 04             	mov    %edx,0x4(%eax)
  80357e:	eb 08                	jmp    803588 <realloc_block_FF+0x2b1>
  803580:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803583:	a3 30 50 80 00       	mov    %eax,0x805030
  803588:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803590:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803593:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80359a:	a1 38 50 80 00       	mov    0x805038,%eax
  80359f:	40                   	inc    %eax
  8035a0:	a3 38 50 80 00       	mov    %eax,0x805038
  8035a5:	e9 b0 01 00 00       	jmp    80375a <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8035aa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035af:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035b2:	76 68                	jbe    80361c <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035b4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035b8:	75 17                	jne    8035d1 <realloc_block_FF+0x2fa>
  8035ba:	83 ec 04             	sub    $0x4,%esp
  8035bd:	68 2c 45 80 00       	push   $0x80452c
  8035c2:	68 0b 02 00 00       	push   $0x20b
  8035c7:	68 11 45 80 00       	push   $0x804511
  8035cc:	e8 20 ce ff ff       	call   8003f1 <_panic>
  8035d1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035da:	89 10                	mov    %edx,(%eax)
  8035dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035df:	8b 00                	mov    (%eax),%eax
  8035e1:	85 c0                	test   %eax,%eax
  8035e3:	74 0d                	je     8035f2 <realloc_block_FF+0x31b>
  8035e5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035ed:	89 50 04             	mov    %edx,0x4(%eax)
  8035f0:	eb 08                	jmp    8035fa <realloc_block_FF+0x323>
  8035f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f5:	a3 30 50 80 00       	mov    %eax,0x805030
  8035fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035fd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803602:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803605:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80360c:	a1 38 50 80 00       	mov    0x805038,%eax
  803611:	40                   	inc    %eax
  803612:	a3 38 50 80 00       	mov    %eax,0x805038
  803617:	e9 3e 01 00 00       	jmp    80375a <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80361c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803621:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803624:	73 68                	jae    80368e <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803626:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80362a:	75 17                	jne    803643 <realloc_block_FF+0x36c>
  80362c:	83 ec 04             	sub    $0x4,%esp
  80362f:	68 60 45 80 00       	push   $0x804560
  803634:	68 10 02 00 00       	push   $0x210
  803639:	68 11 45 80 00       	push   $0x804511
  80363e:	e8 ae cd ff ff       	call   8003f1 <_panic>
  803643:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803649:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364c:	89 50 04             	mov    %edx,0x4(%eax)
  80364f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803652:	8b 40 04             	mov    0x4(%eax),%eax
  803655:	85 c0                	test   %eax,%eax
  803657:	74 0c                	je     803665 <realloc_block_FF+0x38e>
  803659:	a1 30 50 80 00       	mov    0x805030,%eax
  80365e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803661:	89 10                	mov    %edx,(%eax)
  803663:	eb 08                	jmp    80366d <realloc_block_FF+0x396>
  803665:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803668:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80366d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803670:	a3 30 50 80 00       	mov    %eax,0x805030
  803675:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803678:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80367e:	a1 38 50 80 00       	mov    0x805038,%eax
  803683:	40                   	inc    %eax
  803684:	a3 38 50 80 00       	mov    %eax,0x805038
  803689:	e9 cc 00 00 00       	jmp    80375a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80368e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803695:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80369a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80369d:	e9 8a 00 00 00       	jmp    80372c <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8036a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036a8:	73 7a                	jae    803724 <realloc_block_FF+0x44d>
  8036aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ad:	8b 00                	mov    (%eax),%eax
  8036af:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036b2:	73 70                	jae    803724 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8036b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b8:	74 06                	je     8036c0 <realloc_block_FF+0x3e9>
  8036ba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036be:	75 17                	jne    8036d7 <realloc_block_FF+0x400>
  8036c0:	83 ec 04             	sub    $0x4,%esp
  8036c3:	68 84 45 80 00       	push   $0x804584
  8036c8:	68 1a 02 00 00       	push   $0x21a
  8036cd:	68 11 45 80 00       	push   $0x804511
  8036d2:	e8 1a cd ff ff       	call   8003f1 <_panic>
  8036d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036da:	8b 10                	mov    (%eax),%edx
  8036dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036df:	89 10                	mov    %edx,(%eax)
  8036e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e4:	8b 00                	mov    (%eax),%eax
  8036e6:	85 c0                	test   %eax,%eax
  8036e8:	74 0b                	je     8036f5 <realloc_block_FF+0x41e>
  8036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ed:	8b 00                	mov    (%eax),%eax
  8036ef:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036f2:	89 50 04             	mov    %edx,0x4(%eax)
  8036f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036fb:	89 10                	mov    %edx,(%eax)
  8036fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803700:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803703:	89 50 04             	mov    %edx,0x4(%eax)
  803706:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803709:	8b 00                	mov    (%eax),%eax
  80370b:	85 c0                	test   %eax,%eax
  80370d:	75 08                	jne    803717 <realloc_block_FF+0x440>
  80370f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803712:	a3 30 50 80 00       	mov    %eax,0x805030
  803717:	a1 38 50 80 00       	mov    0x805038,%eax
  80371c:	40                   	inc    %eax
  80371d:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803722:	eb 36                	jmp    80375a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803724:	a1 34 50 80 00       	mov    0x805034,%eax
  803729:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80372c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803730:	74 07                	je     803739 <realloc_block_FF+0x462>
  803732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803735:	8b 00                	mov    (%eax),%eax
  803737:	eb 05                	jmp    80373e <realloc_block_FF+0x467>
  803739:	b8 00 00 00 00       	mov    $0x0,%eax
  80373e:	a3 34 50 80 00       	mov    %eax,0x805034
  803743:	a1 34 50 80 00       	mov    0x805034,%eax
  803748:	85 c0                	test   %eax,%eax
  80374a:	0f 85 52 ff ff ff    	jne    8036a2 <realloc_block_FF+0x3cb>
  803750:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803754:	0f 85 48 ff ff ff    	jne    8036a2 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80375a:	83 ec 04             	sub    $0x4,%esp
  80375d:	6a 00                	push   $0x0
  80375f:	ff 75 d8             	pushl  -0x28(%ebp)
  803762:	ff 75 d4             	pushl  -0x2c(%ebp)
  803765:	e8 7a eb ff ff       	call   8022e4 <set_block_data>
  80376a:	83 c4 10             	add    $0x10,%esp
				return va;
  80376d:	8b 45 08             	mov    0x8(%ebp),%eax
  803770:	e9 7b 02 00 00       	jmp    8039f0 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803775:	83 ec 0c             	sub    $0xc,%esp
  803778:	68 01 46 80 00       	push   $0x804601
  80377d:	e8 2c cf ff ff       	call   8006ae <cprintf>
  803782:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803785:	8b 45 08             	mov    0x8(%ebp),%eax
  803788:	e9 63 02 00 00       	jmp    8039f0 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80378d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803790:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803793:	0f 86 4d 02 00 00    	jbe    8039e6 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803799:	83 ec 0c             	sub    $0xc,%esp
  80379c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80379f:	e8 08 e8 ff ff       	call   801fac <is_free_block>
  8037a4:	83 c4 10             	add    $0x10,%esp
  8037a7:	84 c0                	test   %al,%al
  8037a9:	0f 84 37 02 00 00    	je     8039e6 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8037af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8037b5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8037b8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037bb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037be:	76 38                	jbe    8037f8 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8037c0:	83 ec 0c             	sub    $0xc,%esp
  8037c3:	ff 75 08             	pushl  0x8(%ebp)
  8037c6:	e8 0c fa ff ff       	call   8031d7 <free_block>
  8037cb:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8037ce:	83 ec 0c             	sub    $0xc,%esp
  8037d1:	ff 75 0c             	pushl  0xc(%ebp)
  8037d4:	e8 3a eb ff ff       	call   802313 <alloc_block_FF>
  8037d9:	83 c4 10             	add    $0x10,%esp
  8037dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037df:	83 ec 08             	sub    $0x8,%esp
  8037e2:	ff 75 c0             	pushl  -0x40(%ebp)
  8037e5:	ff 75 08             	pushl  0x8(%ebp)
  8037e8:	e8 ab fa ff ff       	call   803298 <copy_data>
  8037ed:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037f0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037f3:	e9 f8 01 00 00       	jmp    8039f0 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037fb:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037fe:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803801:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803805:	0f 87 a0 00 00 00    	ja     8038ab <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80380b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80380f:	75 17                	jne    803828 <realloc_block_FF+0x551>
  803811:	83 ec 04             	sub    $0x4,%esp
  803814:	68 f3 44 80 00       	push   $0x8044f3
  803819:	68 38 02 00 00       	push   $0x238
  80381e:	68 11 45 80 00       	push   $0x804511
  803823:	e8 c9 cb ff ff       	call   8003f1 <_panic>
  803828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382b:	8b 00                	mov    (%eax),%eax
  80382d:	85 c0                	test   %eax,%eax
  80382f:	74 10                	je     803841 <realloc_block_FF+0x56a>
  803831:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803834:	8b 00                	mov    (%eax),%eax
  803836:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803839:	8b 52 04             	mov    0x4(%edx),%edx
  80383c:	89 50 04             	mov    %edx,0x4(%eax)
  80383f:	eb 0b                	jmp    80384c <realloc_block_FF+0x575>
  803841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803844:	8b 40 04             	mov    0x4(%eax),%eax
  803847:	a3 30 50 80 00       	mov    %eax,0x805030
  80384c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384f:	8b 40 04             	mov    0x4(%eax),%eax
  803852:	85 c0                	test   %eax,%eax
  803854:	74 0f                	je     803865 <realloc_block_FF+0x58e>
  803856:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803859:	8b 40 04             	mov    0x4(%eax),%eax
  80385c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80385f:	8b 12                	mov    (%edx),%edx
  803861:	89 10                	mov    %edx,(%eax)
  803863:	eb 0a                	jmp    80386f <realloc_block_FF+0x598>
  803865:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803868:	8b 00                	mov    (%eax),%eax
  80386a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80386f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803872:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803882:	a1 38 50 80 00       	mov    0x805038,%eax
  803887:	48                   	dec    %eax
  803888:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80388d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803890:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803893:	01 d0                	add    %edx,%eax
  803895:	83 ec 04             	sub    $0x4,%esp
  803898:	6a 01                	push   $0x1
  80389a:	50                   	push   %eax
  80389b:	ff 75 08             	pushl  0x8(%ebp)
  80389e:	e8 41 ea ff ff       	call   8022e4 <set_block_data>
  8038a3:	83 c4 10             	add    $0x10,%esp
  8038a6:	e9 36 01 00 00       	jmp    8039e1 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8038ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038ae:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038b1:	01 d0                	add    %edx,%eax
  8038b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8038b6:	83 ec 04             	sub    $0x4,%esp
  8038b9:	6a 01                	push   $0x1
  8038bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8038be:	ff 75 08             	pushl  0x8(%ebp)
  8038c1:	e8 1e ea ff ff       	call   8022e4 <set_block_data>
  8038c6:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cc:	83 e8 04             	sub    $0x4,%eax
  8038cf:	8b 00                	mov    (%eax),%eax
  8038d1:	83 e0 fe             	and    $0xfffffffe,%eax
  8038d4:	89 c2                	mov    %eax,%edx
  8038d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d9:	01 d0                	add    %edx,%eax
  8038db:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038e2:	74 06                	je     8038ea <realloc_block_FF+0x613>
  8038e4:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8038e8:	75 17                	jne    803901 <realloc_block_FF+0x62a>
  8038ea:	83 ec 04             	sub    $0x4,%esp
  8038ed:	68 84 45 80 00       	push   $0x804584
  8038f2:	68 44 02 00 00       	push   $0x244
  8038f7:	68 11 45 80 00       	push   $0x804511
  8038fc:	e8 f0 ca ff ff       	call   8003f1 <_panic>
  803901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803904:	8b 10                	mov    (%eax),%edx
  803906:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803909:	89 10                	mov    %edx,(%eax)
  80390b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80390e:	8b 00                	mov    (%eax),%eax
  803910:	85 c0                	test   %eax,%eax
  803912:	74 0b                	je     80391f <realloc_block_FF+0x648>
  803914:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803917:	8b 00                	mov    (%eax),%eax
  803919:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80391c:	89 50 04             	mov    %edx,0x4(%eax)
  80391f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803922:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803925:	89 10                	mov    %edx,(%eax)
  803927:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80392a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80392d:	89 50 04             	mov    %edx,0x4(%eax)
  803930:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803933:	8b 00                	mov    (%eax),%eax
  803935:	85 c0                	test   %eax,%eax
  803937:	75 08                	jne    803941 <realloc_block_FF+0x66a>
  803939:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80393c:	a3 30 50 80 00       	mov    %eax,0x805030
  803941:	a1 38 50 80 00       	mov    0x805038,%eax
  803946:	40                   	inc    %eax
  803947:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80394c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803950:	75 17                	jne    803969 <realloc_block_FF+0x692>
  803952:	83 ec 04             	sub    $0x4,%esp
  803955:	68 f3 44 80 00       	push   $0x8044f3
  80395a:	68 45 02 00 00       	push   $0x245
  80395f:	68 11 45 80 00       	push   $0x804511
  803964:	e8 88 ca ff ff       	call   8003f1 <_panic>
  803969:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80396c:	8b 00                	mov    (%eax),%eax
  80396e:	85 c0                	test   %eax,%eax
  803970:	74 10                	je     803982 <realloc_block_FF+0x6ab>
  803972:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803975:	8b 00                	mov    (%eax),%eax
  803977:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80397a:	8b 52 04             	mov    0x4(%edx),%edx
  80397d:	89 50 04             	mov    %edx,0x4(%eax)
  803980:	eb 0b                	jmp    80398d <realloc_block_FF+0x6b6>
  803982:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803985:	8b 40 04             	mov    0x4(%eax),%eax
  803988:	a3 30 50 80 00       	mov    %eax,0x805030
  80398d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803990:	8b 40 04             	mov    0x4(%eax),%eax
  803993:	85 c0                	test   %eax,%eax
  803995:	74 0f                	je     8039a6 <realloc_block_FF+0x6cf>
  803997:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399a:	8b 40 04             	mov    0x4(%eax),%eax
  80399d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039a0:	8b 12                	mov    (%edx),%edx
  8039a2:	89 10                	mov    %edx,(%eax)
  8039a4:	eb 0a                	jmp    8039b0 <realloc_block_FF+0x6d9>
  8039a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a9:	8b 00                	mov    (%eax),%eax
  8039ab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8039c8:	48                   	dec    %eax
  8039c9:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8039ce:	83 ec 04             	sub    $0x4,%esp
  8039d1:	6a 00                	push   $0x0
  8039d3:	ff 75 bc             	pushl  -0x44(%ebp)
  8039d6:	ff 75 b8             	pushl  -0x48(%ebp)
  8039d9:	e8 06 e9 ff ff       	call   8022e4 <set_block_data>
  8039de:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8039e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e4:	eb 0a                	jmp    8039f0 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8039e6:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039f0:	c9                   	leave  
  8039f1:	c3                   	ret    

008039f2 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039f2:	55                   	push   %ebp
  8039f3:	89 e5                	mov    %esp,%ebp
  8039f5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039f8:	83 ec 04             	sub    $0x4,%esp
  8039fb:	68 08 46 80 00       	push   $0x804608
  803a00:	68 58 02 00 00       	push   $0x258
  803a05:	68 11 45 80 00       	push   $0x804511
  803a0a:	e8 e2 c9 ff ff       	call   8003f1 <_panic>

00803a0f <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803a0f:	55                   	push   %ebp
  803a10:	89 e5                	mov    %esp,%ebp
  803a12:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803a15:	83 ec 04             	sub    $0x4,%esp
  803a18:	68 30 46 80 00       	push   $0x804630
  803a1d:	68 61 02 00 00       	push   $0x261
  803a22:	68 11 45 80 00       	push   $0x804511
  803a27:	e8 c5 c9 ff ff       	call   8003f1 <_panic>

00803a2c <__udivdi3>:
  803a2c:	55                   	push   %ebp
  803a2d:	57                   	push   %edi
  803a2e:	56                   	push   %esi
  803a2f:	53                   	push   %ebx
  803a30:	83 ec 1c             	sub    $0x1c,%esp
  803a33:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a37:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a3f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a43:	89 ca                	mov    %ecx,%edx
  803a45:	89 f8                	mov    %edi,%eax
  803a47:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a4b:	85 f6                	test   %esi,%esi
  803a4d:	75 2d                	jne    803a7c <__udivdi3+0x50>
  803a4f:	39 cf                	cmp    %ecx,%edi
  803a51:	77 65                	ja     803ab8 <__udivdi3+0x8c>
  803a53:	89 fd                	mov    %edi,%ebp
  803a55:	85 ff                	test   %edi,%edi
  803a57:	75 0b                	jne    803a64 <__udivdi3+0x38>
  803a59:	b8 01 00 00 00       	mov    $0x1,%eax
  803a5e:	31 d2                	xor    %edx,%edx
  803a60:	f7 f7                	div    %edi
  803a62:	89 c5                	mov    %eax,%ebp
  803a64:	31 d2                	xor    %edx,%edx
  803a66:	89 c8                	mov    %ecx,%eax
  803a68:	f7 f5                	div    %ebp
  803a6a:	89 c1                	mov    %eax,%ecx
  803a6c:	89 d8                	mov    %ebx,%eax
  803a6e:	f7 f5                	div    %ebp
  803a70:	89 cf                	mov    %ecx,%edi
  803a72:	89 fa                	mov    %edi,%edx
  803a74:	83 c4 1c             	add    $0x1c,%esp
  803a77:	5b                   	pop    %ebx
  803a78:	5e                   	pop    %esi
  803a79:	5f                   	pop    %edi
  803a7a:	5d                   	pop    %ebp
  803a7b:	c3                   	ret    
  803a7c:	39 ce                	cmp    %ecx,%esi
  803a7e:	77 28                	ja     803aa8 <__udivdi3+0x7c>
  803a80:	0f bd fe             	bsr    %esi,%edi
  803a83:	83 f7 1f             	xor    $0x1f,%edi
  803a86:	75 40                	jne    803ac8 <__udivdi3+0x9c>
  803a88:	39 ce                	cmp    %ecx,%esi
  803a8a:	72 0a                	jb     803a96 <__udivdi3+0x6a>
  803a8c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a90:	0f 87 9e 00 00 00    	ja     803b34 <__udivdi3+0x108>
  803a96:	b8 01 00 00 00       	mov    $0x1,%eax
  803a9b:	89 fa                	mov    %edi,%edx
  803a9d:	83 c4 1c             	add    $0x1c,%esp
  803aa0:	5b                   	pop    %ebx
  803aa1:	5e                   	pop    %esi
  803aa2:	5f                   	pop    %edi
  803aa3:	5d                   	pop    %ebp
  803aa4:	c3                   	ret    
  803aa5:	8d 76 00             	lea    0x0(%esi),%esi
  803aa8:	31 ff                	xor    %edi,%edi
  803aaa:	31 c0                	xor    %eax,%eax
  803aac:	89 fa                	mov    %edi,%edx
  803aae:	83 c4 1c             	add    $0x1c,%esp
  803ab1:	5b                   	pop    %ebx
  803ab2:	5e                   	pop    %esi
  803ab3:	5f                   	pop    %edi
  803ab4:	5d                   	pop    %ebp
  803ab5:	c3                   	ret    
  803ab6:	66 90                	xchg   %ax,%ax
  803ab8:	89 d8                	mov    %ebx,%eax
  803aba:	f7 f7                	div    %edi
  803abc:	31 ff                	xor    %edi,%edi
  803abe:	89 fa                	mov    %edi,%edx
  803ac0:	83 c4 1c             	add    $0x1c,%esp
  803ac3:	5b                   	pop    %ebx
  803ac4:	5e                   	pop    %esi
  803ac5:	5f                   	pop    %edi
  803ac6:	5d                   	pop    %ebp
  803ac7:	c3                   	ret    
  803ac8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803acd:	89 eb                	mov    %ebp,%ebx
  803acf:	29 fb                	sub    %edi,%ebx
  803ad1:	89 f9                	mov    %edi,%ecx
  803ad3:	d3 e6                	shl    %cl,%esi
  803ad5:	89 c5                	mov    %eax,%ebp
  803ad7:	88 d9                	mov    %bl,%cl
  803ad9:	d3 ed                	shr    %cl,%ebp
  803adb:	89 e9                	mov    %ebp,%ecx
  803add:	09 f1                	or     %esi,%ecx
  803adf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ae3:	89 f9                	mov    %edi,%ecx
  803ae5:	d3 e0                	shl    %cl,%eax
  803ae7:	89 c5                	mov    %eax,%ebp
  803ae9:	89 d6                	mov    %edx,%esi
  803aeb:	88 d9                	mov    %bl,%cl
  803aed:	d3 ee                	shr    %cl,%esi
  803aef:	89 f9                	mov    %edi,%ecx
  803af1:	d3 e2                	shl    %cl,%edx
  803af3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803af7:	88 d9                	mov    %bl,%cl
  803af9:	d3 e8                	shr    %cl,%eax
  803afb:	09 c2                	or     %eax,%edx
  803afd:	89 d0                	mov    %edx,%eax
  803aff:	89 f2                	mov    %esi,%edx
  803b01:	f7 74 24 0c          	divl   0xc(%esp)
  803b05:	89 d6                	mov    %edx,%esi
  803b07:	89 c3                	mov    %eax,%ebx
  803b09:	f7 e5                	mul    %ebp
  803b0b:	39 d6                	cmp    %edx,%esi
  803b0d:	72 19                	jb     803b28 <__udivdi3+0xfc>
  803b0f:	74 0b                	je     803b1c <__udivdi3+0xf0>
  803b11:	89 d8                	mov    %ebx,%eax
  803b13:	31 ff                	xor    %edi,%edi
  803b15:	e9 58 ff ff ff       	jmp    803a72 <__udivdi3+0x46>
  803b1a:	66 90                	xchg   %ax,%ax
  803b1c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b20:	89 f9                	mov    %edi,%ecx
  803b22:	d3 e2                	shl    %cl,%edx
  803b24:	39 c2                	cmp    %eax,%edx
  803b26:	73 e9                	jae    803b11 <__udivdi3+0xe5>
  803b28:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b2b:	31 ff                	xor    %edi,%edi
  803b2d:	e9 40 ff ff ff       	jmp    803a72 <__udivdi3+0x46>
  803b32:	66 90                	xchg   %ax,%ax
  803b34:	31 c0                	xor    %eax,%eax
  803b36:	e9 37 ff ff ff       	jmp    803a72 <__udivdi3+0x46>
  803b3b:	90                   	nop

00803b3c <__umoddi3>:
  803b3c:	55                   	push   %ebp
  803b3d:	57                   	push   %edi
  803b3e:	56                   	push   %esi
  803b3f:	53                   	push   %ebx
  803b40:	83 ec 1c             	sub    $0x1c,%esp
  803b43:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b47:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b4f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b5b:	89 f3                	mov    %esi,%ebx
  803b5d:	89 fa                	mov    %edi,%edx
  803b5f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b63:	89 34 24             	mov    %esi,(%esp)
  803b66:	85 c0                	test   %eax,%eax
  803b68:	75 1a                	jne    803b84 <__umoddi3+0x48>
  803b6a:	39 f7                	cmp    %esi,%edi
  803b6c:	0f 86 a2 00 00 00    	jbe    803c14 <__umoddi3+0xd8>
  803b72:	89 c8                	mov    %ecx,%eax
  803b74:	89 f2                	mov    %esi,%edx
  803b76:	f7 f7                	div    %edi
  803b78:	89 d0                	mov    %edx,%eax
  803b7a:	31 d2                	xor    %edx,%edx
  803b7c:	83 c4 1c             	add    $0x1c,%esp
  803b7f:	5b                   	pop    %ebx
  803b80:	5e                   	pop    %esi
  803b81:	5f                   	pop    %edi
  803b82:	5d                   	pop    %ebp
  803b83:	c3                   	ret    
  803b84:	39 f0                	cmp    %esi,%eax
  803b86:	0f 87 ac 00 00 00    	ja     803c38 <__umoddi3+0xfc>
  803b8c:	0f bd e8             	bsr    %eax,%ebp
  803b8f:	83 f5 1f             	xor    $0x1f,%ebp
  803b92:	0f 84 ac 00 00 00    	je     803c44 <__umoddi3+0x108>
  803b98:	bf 20 00 00 00       	mov    $0x20,%edi
  803b9d:	29 ef                	sub    %ebp,%edi
  803b9f:	89 fe                	mov    %edi,%esi
  803ba1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ba5:	89 e9                	mov    %ebp,%ecx
  803ba7:	d3 e0                	shl    %cl,%eax
  803ba9:	89 d7                	mov    %edx,%edi
  803bab:	89 f1                	mov    %esi,%ecx
  803bad:	d3 ef                	shr    %cl,%edi
  803baf:	09 c7                	or     %eax,%edi
  803bb1:	89 e9                	mov    %ebp,%ecx
  803bb3:	d3 e2                	shl    %cl,%edx
  803bb5:	89 14 24             	mov    %edx,(%esp)
  803bb8:	89 d8                	mov    %ebx,%eax
  803bba:	d3 e0                	shl    %cl,%eax
  803bbc:	89 c2                	mov    %eax,%edx
  803bbe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bc2:	d3 e0                	shl    %cl,%eax
  803bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bc8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bcc:	89 f1                	mov    %esi,%ecx
  803bce:	d3 e8                	shr    %cl,%eax
  803bd0:	09 d0                	or     %edx,%eax
  803bd2:	d3 eb                	shr    %cl,%ebx
  803bd4:	89 da                	mov    %ebx,%edx
  803bd6:	f7 f7                	div    %edi
  803bd8:	89 d3                	mov    %edx,%ebx
  803bda:	f7 24 24             	mull   (%esp)
  803bdd:	89 c6                	mov    %eax,%esi
  803bdf:	89 d1                	mov    %edx,%ecx
  803be1:	39 d3                	cmp    %edx,%ebx
  803be3:	0f 82 87 00 00 00    	jb     803c70 <__umoddi3+0x134>
  803be9:	0f 84 91 00 00 00    	je     803c80 <__umoddi3+0x144>
  803bef:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bf3:	29 f2                	sub    %esi,%edx
  803bf5:	19 cb                	sbb    %ecx,%ebx
  803bf7:	89 d8                	mov    %ebx,%eax
  803bf9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bfd:	d3 e0                	shl    %cl,%eax
  803bff:	89 e9                	mov    %ebp,%ecx
  803c01:	d3 ea                	shr    %cl,%edx
  803c03:	09 d0                	or     %edx,%eax
  803c05:	89 e9                	mov    %ebp,%ecx
  803c07:	d3 eb                	shr    %cl,%ebx
  803c09:	89 da                	mov    %ebx,%edx
  803c0b:	83 c4 1c             	add    $0x1c,%esp
  803c0e:	5b                   	pop    %ebx
  803c0f:	5e                   	pop    %esi
  803c10:	5f                   	pop    %edi
  803c11:	5d                   	pop    %ebp
  803c12:	c3                   	ret    
  803c13:	90                   	nop
  803c14:	89 fd                	mov    %edi,%ebp
  803c16:	85 ff                	test   %edi,%edi
  803c18:	75 0b                	jne    803c25 <__umoddi3+0xe9>
  803c1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c1f:	31 d2                	xor    %edx,%edx
  803c21:	f7 f7                	div    %edi
  803c23:	89 c5                	mov    %eax,%ebp
  803c25:	89 f0                	mov    %esi,%eax
  803c27:	31 d2                	xor    %edx,%edx
  803c29:	f7 f5                	div    %ebp
  803c2b:	89 c8                	mov    %ecx,%eax
  803c2d:	f7 f5                	div    %ebp
  803c2f:	89 d0                	mov    %edx,%eax
  803c31:	e9 44 ff ff ff       	jmp    803b7a <__umoddi3+0x3e>
  803c36:	66 90                	xchg   %ax,%ax
  803c38:	89 c8                	mov    %ecx,%eax
  803c3a:	89 f2                	mov    %esi,%edx
  803c3c:	83 c4 1c             	add    $0x1c,%esp
  803c3f:	5b                   	pop    %ebx
  803c40:	5e                   	pop    %esi
  803c41:	5f                   	pop    %edi
  803c42:	5d                   	pop    %ebp
  803c43:	c3                   	ret    
  803c44:	3b 04 24             	cmp    (%esp),%eax
  803c47:	72 06                	jb     803c4f <__umoddi3+0x113>
  803c49:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c4d:	77 0f                	ja     803c5e <__umoddi3+0x122>
  803c4f:	89 f2                	mov    %esi,%edx
  803c51:	29 f9                	sub    %edi,%ecx
  803c53:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c57:	89 14 24             	mov    %edx,(%esp)
  803c5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c5e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c62:	8b 14 24             	mov    (%esp),%edx
  803c65:	83 c4 1c             	add    $0x1c,%esp
  803c68:	5b                   	pop    %ebx
  803c69:	5e                   	pop    %esi
  803c6a:	5f                   	pop    %edi
  803c6b:	5d                   	pop    %ebp
  803c6c:	c3                   	ret    
  803c6d:	8d 76 00             	lea    0x0(%esi),%esi
  803c70:	2b 04 24             	sub    (%esp),%eax
  803c73:	19 fa                	sbb    %edi,%edx
  803c75:	89 d1                	mov    %edx,%ecx
  803c77:	89 c6                	mov    %eax,%esi
  803c79:	e9 71 ff ff ff       	jmp    803bef <__umoddi3+0xb3>
  803c7e:	66 90                	xchg   %ax,%ax
  803c80:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c84:	72 ea                	jb     803c70 <__umoddi3+0x134>
  803c86:	89 d9                	mov    %ebx,%ecx
  803c88:	e9 62 ff ff ff       	jmp    803bef <__umoddi3+0xb3>
