
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
  80005c:	68 a0 3d 80 00       	push   $0x803da0
  800061:	6a 0d                	push   $0xd
  800063:	68 bc 3d 80 00       	push   $0x803dbc
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
  800074:	e8 f1 1c 00 00       	call   801d6a <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 54 1a 00 00       	call   801ad5 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 02 1b 00 00       	call   801b88 <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 d7 3d 80 00       	push   $0x803dd7
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 ed 17 00 00       	call   801886 <sget>
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
  8000b6:	68 dc 3d 80 00       	push   $0x803ddc
  8000bb:	6a 21                	push   $0x21
  8000bd:	68 bc 3d 80 00       	push   $0x803dbc
  8000c2:	e8 2a 03 00 00       	call   8003f1 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 b2 1a 00 00       	call   801b88 <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 9b 1a 00 00       	call   801b88 <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 58 3e 80 00       	push   $0x803e58
  8000fd:	6a 24                	push   $0x24
  8000ff:	68 bc 3d 80 00       	push   $0x803dbc
  800104:	e8 e8 02 00 00       	call   8003f1 <_panic>

	}
	sys_unlock_cons();
  800109:	e8 e1 19 00 00       	call   801aef <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 c2 19 00 00       	call   801ad5 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 70 1a 00 00       	call   801b88 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = sget(parentenvID,"y");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 f0 3e 80 00       	push   $0x803ef0
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 5b 17 00 00       	call   801886 <sget>
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
  80014d:	68 dc 3d 80 00       	push   $0x803ddc
  800152:	6a 30                	push   $0x30
  800154:	68 bc 3d 80 00       	push   $0x803dbc
  800159:	e8 93 02 00 00       	call   8003f1 <_panic>
		expected = 0 ;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 1b 1a 00 00       	call   801b88 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 04 1a 00 00       	call   801b88 <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 58 3e 80 00       	push   $0x803e58
  800194:	6a 33                	push   $0x33
  800196:	68 bc 3d 80 00       	push   $0x803dbc
  80019b:	e8 51 02 00 00       	call   8003f1 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 4a 19 00 00       	call   801aef <sys_unlock_cons>
	//sys_unlock_cons();
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 14             	cmp    $0x14,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 f4 3e 80 00       	push   $0x803ef4
  8001b7:	6a 37                	push   $0x37
  8001b9:	68 bc 3d 80 00       	push   $0x803dbc
  8001be:	e8 2e 02 00 00       	call   8003f1 <_panic>
	//sys_lock_cons();
	sys_lock_cons();
  8001c3:	e8 0d 19 00 00       	call   801ad5 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  8001c8:	e8 bb 19 00 00       	call   801b88 <sys_calculate_free_frames>
  8001cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	68 2b 3f 80 00       	push   $0x803f2b
  8001d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8001db:	e8 a6 16 00 00       	call   801886 <sget>
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
  800202:	68 dc 3d 80 00       	push   $0x803ddc
  800207:	6a 3e                	push   $0x3e
  800209:	68 bc 3d 80 00       	push   $0x803dbc
  80020e:	e8 de 01 00 00       	call   8003f1 <_panic>
		expected = 0 ;
  800213:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80021a:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80021d:	e8 66 19 00 00       	call   801b88 <sys_calculate_free_frames>
  800222:	29 c3                	sub    %eax,%ebx
  800224:	89 d8                	mov    %ebx,%eax
  800226:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800229:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022f:	74 24                	je     800255 <_main+0x21d>
  800231:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800234:	e8 4f 19 00 00       	call   801b88 <sys_calculate_free_frames>
  800239:	29 c3                	sub    %eax,%ebx
  80023b:	89 d8                	mov    %ebx,%eax
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	ff 75 e0             	pushl  -0x20(%ebp)
  800243:	50                   	push   %eax
  800244:	68 58 3e 80 00       	push   $0x803e58
  800249:	6a 41                	push   $0x41
  80024b:	68 bc 3d 80 00       	push   $0x803dbc
  800250:	e8 9c 01 00 00       	call   8003f1 <_panic>
	}
	sys_unlock_cons();
  800255:	e8 95 18 00 00       	call   801aef <sys_unlock_cons>
	//sys_unlock_cons();
	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  80025a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80025d:	8b 00                	mov    (%eax),%eax
  80025f:	83 f8 0a             	cmp    $0xa,%eax
  800262:	74 14                	je     800278 <_main+0x240>
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	68 f4 3e 80 00       	push   $0x803ef4
  80026c:	6a 45                	push   $0x45
  80026e:	68 bc 3d 80 00       	push   $0x803dbc
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
  800296:	68 f4 3e 80 00       	push   $0x803ef4
  80029b:	6a 48                	push   $0x48
  80029d:	68 bc 3d 80 00       	push   $0x803dbc
  8002a2:	e8 4a 01 00 00       	call   8003f1 <_panic>

	//To indicate that it's completed successfully
	inctst();
  8002a7:	e8 e3 1b 00 00       	call   801e8f <inctst>

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
  8002b8:	e8 94 1a 00 00       	call   801d51 <sys_getenvindex>
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
  800326:	e8 aa 17 00 00       	call   801ad5 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80032b:	83 ec 0c             	sub    $0xc,%esp
  80032e:	68 48 3f 80 00       	push   $0x803f48
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
  800356:	68 70 3f 80 00       	push   $0x803f70
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
  800387:	68 98 3f 80 00       	push   $0x803f98
  80038c:	e8 1d 03 00 00       	call   8006ae <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800394:	a1 20 50 80 00       	mov    0x805020,%eax
  800399:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80039f:	83 ec 08             	sub    $0x8,%esp
  8003a2:	50                   	push   %eax
  8003a3:	68 f0 3f 80 00       	push   $0x803ff0
  8003a8:	e8 01 03 00 00       	call   8006ae <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003b0:	83 ec 0c             	sub    $0xc,%esp
  8003b3:	68 48 3f 80 00       	push   $0x803f48
  8003b8:	e8 f1 02 00 00       	call   8006ae <cprintf>
  8003bd:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003c0:	e8 2a 17 00 00       	call   801aef <sys_unlock_cons>
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
  8003d8:	e8 40 19 00 00       	call   801d1d <sys_destroy_env>
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
  8003e9:	e8 95 19 00 00       	call   801d83 <sys_exit_env>
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
  800400:	a1 50 50 80 00       	mov    0x805050,%eax
  800405:	85 c0                	test   %eax,%eax
  800407:	74 16                	je     80041f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800409:	a1 50 50 80 00       	mov    0x805050,%eax
  80040e:	83 ec 08             	sub    $0x8,%esp
  800411:	50                   	push   %eax
  800412:	68 04 40 80 00       	push   $0x804004
  800417:	e8 92 02 00 00       	call   8006ae <cprintf>
  80041c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80041f:	a1 00 50 80 00       	mov    0x805000,%eax
  800424:	ff 75 0c             	pushl  0xc(%ebp)
  800427:	ff 75 08             	pushl  0x8(%ebp)
  80042a:	50                   	push   %eax
  80042b:	68 09 40 80 00       	push   $0x804009
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
  80044f:	68 25 40 80 00       	push   $0x804025
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
  80047e:	68 28 40 80 00       	push   $0x804028
  800483:	6a 26                	push   $0x26
  800485:	68 74 40 80 00       	push   $0x804074
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
  800553:	68 80 40 80 00       	push   $0x804080
  800558:	6a 3a                	push   $0x3a
  80055a:	68 74 40 80 00       	push   $0x804074
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
  8005c6:	68 d4 40 80 00       	push   $0x8040d4
  8005cb:	6a 44                	push   $0x44
  8005cd:	68 74 40 80 00       	push   $0x804074
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
  800605:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  800620:	e8 6e 14 00 00       	call   801a93 <sys_cputs>
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
  80067a:	a0 2c 50 80 00       	mov    0x80502c,%al
  80067f:	0f b6 c0             	movzbl %al,%eax
  800682:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	50                   	push   %eax
  80068c:	52                   	push   %edx
  80068d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800693:	83 c0 08             	add    $0x8,%eax
  800696:	50                   	push   %eax
  800697:	e8 f7 13 00 00       	call   801a93 <sys_cputs>
  80069c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80069f:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  8006b4:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  8006e1:	e8 ef 13 00 00       	call   801ad5 <sys_lock_cons>
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
  800701:	e8 e9 13 00 00       	call   801aef <sys_unlock_cons>
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
  80074b:	e8 dc 33 00 00       	call   803b2c <__udivdi3>
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
  80079b:	e8 9c 34 00 00       	call   803c3c <__umoddi3>
  8007a0:	83 c4 10             	add    $0x10,%esp
  8007a3:	05 34 43 80 00       	add    $0x804334,%eax
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
  8008f6:	8b 04 85 58 43 80 00 	mov    0x804358(,%eax,4),%eax
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
  8009d7:	8b 34 9d a0 41 80 00 	mov    0x8041a0(,%ebx,4),%esi
  8009de:	85 f6                	test   %esi,%esi
  8009e0:	75 19                	jne    8009fb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e2:	53                   	push   %ebx
  8009e3:	68 45 43 80 00       	push   $0x804345
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
  8009fc:	68 4e 43 80 00       	push   $0x80434e
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
  800a29:	be 51 43 80 00       	mov    $0x804351,%esi
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
  800c21:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800c28:	eb 2c                	jmp    800c56 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c2a:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  801434:	68 c8 44 80 00       	push   $0x8044c8
  801439:	68 3f 01 00 00       	push   $0x13f
  80143e:	68 ea 44 80 00       	push   $0x8044ea
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
  801454:	e8 e5 0b 00 00       	call   80203e <sys_sbrk>
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
  8014cf:	e8 ee 09 00 00       	call   801ec2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	74 16                	je     8014ee <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	ff 75 08             	pushl  0x8(%ebp)
  8014de:	e8 2e 0f 00 00       	call   802411 <alloc_block_FF>
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e9:	e9 8a 01 00 00       	jmp    801678 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014ee:	e8 00 0a 00 00       	call   801ef3 <sys_isUHeapPlacementStrategyBESTFIT>
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	0f 84 7d 01 00 00    	je     801678 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014fb:	83 ec 0c             	sub    $0xc,%esp
  8014fe:	ff 75 08             	pushl  0x8(%ebp)
  801501:	e8 c7 13 00 00       	call   8028cd <alloc_block_BF>
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
  801551:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  80159e:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  8015f5:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  801657:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  80165e:	83 ec 08             	sub    $0x8,%esp
  801661:	ff 75 08             	pushl  0x8(%ebp)
  801664:	ff 75 f0             	pushl  -0x10(%ebp)
  801667:	e8 09 0a 00 00       	call   802075 <sys_allocate_user_mem>
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
  8016af:	e8 dd 09 00 00       	call   802091 <get_block_size>
  8016b4:	83 c4 10             	add    $0x10,%esp
  8016b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016ba:	83 ec 0c             	sub    $0xc,%esp
  8016bd:	ff 75 08             	pushl  0x8(%ebp)
  8016c0:	e8 10 1c 00 00       	call   8032d5 <free_block>
  8016c5:	83 c4 10             	add    $0x10,%esp
		}

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
  8016fa:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
  801701:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801704:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801707:	c1 e0 0c             	shl    $0xc,%eax
  80170a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  80170d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801714:	eb 42                	jmp    801758 <free+0xdb>
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
  801737:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  80173e:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801742:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	83 ec 08             	sub    $0x8,%esp
  80174b:	52                   	push   %edx
  80174c:	50                   	push   %eax
  80174d:	e8 07 09 00 00       	call   802059 <sys_free_user_mem>
  801752:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801755:	ff 45 f4             	incl   -0xc(%ebp)
  801758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80175e:	72 b6                	jb     801716 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801760:	eb 17                	jmp    801779 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801762:	83 ec 04             	sub    $0x4,%esp
  801765:	68 f8 44 80 00       	push   $0x8044f8
  80176a:	68 88 00 00 00       	push   $0x88
  80176f:	68 22 45 80 00       	push   $0x804522
  801774:	e8 78 ec ff ff       	call   8003f1 <_panic>
	}
}
  801779:	90                   	nop
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	83 ec 28             	sub    $0x28,%esp
  801782:	8b 45 10             	mov    0x10(%ebp),%eax
  801785:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801788:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80178c:	75 0a                	jne    801798 <smalloc+0x1c>
  80178e:	b8 00 00 00 00       	mov    $0x0,%eax
  801793:	e9 ec 00 00 00       	jmp    801884 <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80179e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ab:	39 d0                	cmp    %edx,%eax
  8017ad:	73 02                	jae    8017b1 <smalloc+0x35>
  8017af:	89 d0                	mov    %edx,%eax
  8017b1:	83 ec 0c             	sub    $0xc,%esp
  8017b4:	50                   	push   %eax
  8017b5:	e8 a4 fc ff ff       	call   80145e <malloc>
  8017ba:	83 c4 10             	add    $0x10,%esp
  8017bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8017c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017c4:	75 0a                	jne    8017d0 <smalloc+0x54>
  8017c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cb:	e9 b4 00 00 00       	jmp    801884 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017d0:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8017d7:	50                   	push   %eax
  8017d8:	ff 75 0c             	pushl  0xc(%ebp)
  8017db:	ff 75 08             	pushl  0x8(%ebp)
  8017de:	e8 7d 04 00 00       	call   801c60 <sys_createSharedObject>
  8017e3:	83 c4 10             	add    $0x10,%esp
  8017e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017e9:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017ed:	74 06                	je     8017f5 <smalloc+0x79>
  8017ef:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017f3:	75 0a                	jne    8017ff <smalloc+0x83>
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fa:	e9 85 00 00 00       	jmp    801884 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  8017ff:	83 ec 08             	sub    $0x8,%esp
  801802:	ff 75 ec             	pushl  -0x14(%ebp)
  801805:	68 2e 45 80 00       	push   $0x80452e
  80180a:	e8 9f ee ff ff       	call   8006ae <cprintf>
  80180f:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801812:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801815:	a1 20 50 80 00       	mov    0x805020,%eax
  80181a:	8b 40 78             	mov    0x78(%eax),%eax
  80181d:	29 c2                	sub    %eax,%edx
  80181f:	89 d0                	mov    %edx,%eax
  801821:	2d 00 10 00 00       	sub    $0x1000,%eax
  801826:	c1 e8 0c             	shr    $0xc,%eax
  801829:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80182f:	42                   	inc    %edx
  801830:	89 15 24 50 80 00    	mov    %edx,0x805024
  801836:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80183c:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801843:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801846:	a1 20 50 80 00       	mov    0x805020,%eax
  80184b:	8b 40 78             	mov    0x78(%eax),%eax
  80184e:	29 c2                	sub    %eax,%edx
  801850:	89 d0                	mov    %edx,%eax
  801852:	2d 00 10 00 00       	sub    $0x1000,%eax
  801857:	c1 e8 0c             	shr    $0xc,%eax
  80185a:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801861:	a1 20 50 80 00       	mov    0x805020,%eax
  801866:	8b 50 10             	mov    0x10(%eax),%edx
  801869:	89 c8                	mov    %ecx,%eax
  80186b:	c1 e0 02             	shl    $0x2,%eax
  80186e:	89 c1                	mov    %eax,%ecx
  801870:	c1 e1 09             	shl    $0x9,%ecx
  801873:	01 c8                	add    %ecx,%eax
  801875:	01 c2                	add    %eax,%edx
  801877:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80187a:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801881:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80188c:	83 ec 08             	sub    $0x8,%esp
  80188f:	ff 75 0c             	pushl  0xc(%ebp)
  801892:	ff 75 08             	pushl  0x8(%ebp)
  801895:	e8 f0 03 00 00       	call   801c8a <sys_getSizeOfSharedObject>
  80189a:	83 c4 10             	add    $0x10,%esp
  80189d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8018a0:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8018a4:	75 0a                	jne    8018b0 <sget+0x2a>
  8018a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ab:	e9 e7 00 00 00       	jmp    801997 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8018b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018b6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8018bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c3:	39 d0                	cmp    %edx,%eax
  8018c5:	73 02                	jae    8018c9 <sget+0x43>
  8018c7:	89 d0                	mov    %edx,%eax
  8018c9:	83 ec 0c             	sub    $0xc,%esp
  8018cc:	50                   	push   %eax
  8018cd:	e8 8c fb ff ff       	call   80145e <malloc>
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8018d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018dc:	75 0a                	jne    8018e8 <sget+0x62>
  8018de:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e3:	e9 af 00 00 00       	jmp    801997 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8018e8:	83 ec 04             	sub    $0x4,%esp
  8018eb:	ff 75 e8             	pushl  -0x18(%ebp)
  8018ee:	ff 75 0c             	pushl  0xc(%ebp)
  8018f1:	ff 75 08             	pushl  0x8(%ebp)
  8018f4:	e8 ae 03 00 00       	call   801ca7 <sys_getSharedObject>
  8018f9:	83 c4 10             	add    $0x10,%esp
  8018fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8018ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801902:	a1 20 50 80 00       	mov    0x805020,%eax
  801907:	8b 40 78             	mov    0x78(%eax),%eax
  80190a:	29 c2                	sub    %eax,%edx
  80190c:	89 d0                	mov    %edx,%eax
  80190e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801913:	c1 e8 0c             	shr    $0xc,%eax
  801916:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80191c:	42                   	inc    %edx
  80191d:	89 15 24 50 80 00    	mov    %edx,0x805024
  801923:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801929:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801930:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801933:	a1 20 50 80 00       	mov    0x805020,%eax
  801938:	8b 40 78             	mov    0x78(%eax),%eax
  80193b:	29 c2                	sub    %eax,%edx
  80193d:	89 d0                	mov    %edx,%eax
  80193f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801944:	c1 e8 0c             	shr    $0xc,%eax
  801947:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  80194e:	a1 20 50 80 00       	mov    0x805020,%eax
  801953:	8b 50 10             	mov    0x10(%eax),%edx
  801956:	89 c8                	mov    %ecx,%eax
  801958:	c1 e0 02             	shl    $0x2,%eax
  80195b:	89 c1                	mov    %eax,%ecx
  80195d:	c1 e1 09             	shl    $0x9,%ecx
  801960:	01 c8                	add    %ecx,%eax
  801962:	01 c2                	add    %eax,%edx
  801964:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801967:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  80196e:	a1 20 50 80 00       	mov    0x805020,%eax
  801973:	8b 40 10             	mov    0x10(%eax),%eax
  801976:	83 ec 08             	sub    $0x8,%esp
  801979:	50                   	push   %eax
  80197a:	68 3d 45 80 00       	push   $0x80453d
  80197f:	e8 2a ed ff ff       	call   8006ae <cprintf>
  801984:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801987:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80198b:	75 07                	jne    801994 <sget+0x10e>
  80198d:	b8 00 00 00 00       	mov    $0x0,%eax
  801992:	eb 03                	jmp    801997 <sget+0x111>
	return ptr;
  801994:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  80199f:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8019a7:	8b 40 78             	mov    0x78(%eax),%eax
  8019aa:	29 c2                	sub    %eax,%edx
  8019ac:	89 d0                	mov    %edx,%eax
  8019ae:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019b3:	c1 e8 0c             	shr    $0xc,%eax
  8019b6:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8019bd:	a1 20 50 80 00       	mov    0x805020,%eax
  8019c2:	8b 50 10             	mov    0x10(%eax),%edx
  8019c5:	89 c8                	mov    %ecx,%eax
  8019c7:	c1 e0 02             	shl    $0x2,%eax
  8019ca:	89 c1                	mov    %eax,%ecx
  8019cc:	c1 e1 09             	shl    $0x9,%ecx
  8019cf:	01 c8                	add    %ecx,%eax
  8019d1:	01 d0                	add    %edx,%eax
  8019d3:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8019da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8019dd:	83 ec 08             	sub    $0x8,%esp
  8019e0:	ff 75 08             	pushl  0x8(%ebp)
  8019e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e6:	e8 db 02 00 00       	call   801cc6 <sys_freeSharedObject>
  8019eb:	83 c4 10             	add    $0x10,%esp
  8019ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8019f1:	90                   	nop
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019fa:	83 ec 04             	sub    $0x4,%esp
  8019fd:	68 4c 45 80 00       	push   $0x80454c
  801a02:	68 e5 00 00 00       	push   $0xe5
  801a07:	68 22 45 80 00       	push   $0x804522
  801a0c:	e8 e0 e9 ff ff       	call   8003f1 <_panic>

00801a11 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a17:	83 ec 04             	sub    $0x4,%esp
  801a1a:	68 72 45 80 00       	push   $0x804572
  801a1f:	68 f1 00 00 00       	push   $0xf1
  801a24:	68 22 45 80 00       	push   $0x804522
  801a29:	e8 c3 e9 ff ff       	call   8003f1 <_panic>

00801a2e <shrink>:

}
void shrink(uint32 newSize)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a34:	83 ec 04             	sub    $0x4,%esp
  801a37:	68 72 45 80 00       	push   $0x804572
  801a3c:	68 f6 00 00 00       	push   $0xf6
  801a41:	68 22 45 80 00       	push   $0x804522
  801a46:	e8 a6 e9 ff ff       	call   8003f1 <_panic>

00801a4b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a51:	83 ec 04             	sub    $0x4,%esp
  801a54:	68 72 45 80 00       	push   $0x804572
  801a59:	68 fb 00 00 00       	push   $0xfb
  801a5e:	68 22 45 80 00       	push   $0x804522
  801a63:	e8 89 e9 ff ff       	call   8003f1 <_panic>

00801a68 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	57                   	push   %edi
  801a6c:	56                   	push   %esi
  801a6d:	53                   	push   %ebx
  801a6e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a77:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a7a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a7d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a80:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a83:	cd 30                	int    $0x30
  801a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a8b:	83 c4 10             	add    $0x10,%esp
  801a8e:	5b                   	pop    %ebx
  801a8f:	5e                   	pop    %esi
  801a90:	5f                   	pop    %edi
  801a91:	5d                   	pop    %ebp
  801a92:	c3                   	ret    

00801a93 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	83 ec 04             	sub    $0x4,%esp
  801a99:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a9f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	52                   	push   %edx
  801aab:	ff 75 0c             	pushl  0xc(%ebp)
  801aae:	50                   	push   %eax
  801aaf:	6a 00                	push   $0x0
  801ab1:	e8 b2 ff ff ff       	call   801a68 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	90                   	nop
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_cgetc>:

int
sys_cgetc(void)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 02                	push   $0x2
  801acb:	e8 98 ff ff ff       	call   801a68 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 03                	push   $0x3
  801ae4:	e8 7f ff ff ff       	call   801a68 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	90                   	nop
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 04                	push   $0x4
  801afe:	e8 65 ff ff ff       	call   801a68 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	90                   	nop
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	52                   	push   %edx
  801b19:	50                   	push   %eax
  801b1a:	6a 08                	push   $0x8
  801b1c:	e8 47 ff ff ff       	call   801a68 <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	56                   	push   %esi
  801b2a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b2b:	8b 75 18             	mov    0x18(%ebp),%esi
  801b2e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b31:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	56                   	push   %esi
  801b3b:	53                   	push   %ebx
  801b3c:	51                   	push   %ecx
  801b3d:	52                   	push   %edx
  801b3e:	50                   	push   %eax
  801b3f:	6a 09                	push   $0x9
  801b41:	e8 22 ff ff ff       	call   801a68 <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b4c:	5b                   	pop    %ebx
  801b4d:	5e                   	pop    %esi
  801b4e:	5d                   	pop    %ebp
  801b4f:	c3                   	ret    

00801b50 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	52                   	push   %edx
  801b60:	50                   	push   %eax
  801b61:	6a 0a                	push   $0xa
  801b63:	e8 00 ff ff ff       	call   801a68 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	ff 75 0c             	pushl  0xc(%ebp)
  801b79:	ff 75 08             	pushl  0x8(%ebp)
  801b7c:	6a 0b                	push   $0xb
  801b7e:	e8 e5 fe ff ff       	call   801a68 <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 0c                	push   $0xc
  801b97:	e8 cc fe ff ff       	call   801a68 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 0d                	push   $0xd
  801bb0:	e8 b3 fe ff ff       	call   801a68 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 0e                	push   $0xe
  801bc9:	e8 9a fe ff ff       	call   801a68 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 0f                	push   $0xf
  801be2:	e8 81 fe ff ff       	call   801a68 <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	ff 75 08             	pushl  0x8(%ebp)
  801bfa:	6a 10                	push   $0x10
  801bfc:	e8 67 fe ff ff       	call   801a68 <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 11                	push   $0x11
  801c15:	e8 4e fe ff ff       	call   801a68 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
}
  801c1d:	90                   	nop
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_cputc>:

void
sys_cputc(const char c)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	83 ec 04             	sub    $0x4,%esp
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c2c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	50                   	push   %eax
  801c39:	6a 01                	push   $0x1
  801c3b:	e8 28 fe ff ff       	call   801a68 <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	90                   	nop
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 14                	push   $0x14
  801c55:	e8 0e fe ff ff       	call   801a68 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	90                   	nop
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 04             	sub    $0x4,%esp
  801c66:	8b 45 10             	mov    0x10(%ebp),%eax
  801c69:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c6c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c6f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	6a 00                	push   $0x0
  801c78:	51                   	push   %ecx
  801c79:	52                   	push   %edx
  801c7a:	ff 75 0c             	pushl  0xc(%ebp)
  801c7d:	50                   	push   %eax
  801c7e:	6a 15                	push   $0x15
  801c80:	e8 e3 fd ff ff       	call   801a68 <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	52                   	push   %edx
  801c9a:	50                   	push   %eax
  801c9b:	6a 16                	push   $0x16
  801c9d:	e8 c6 fd ff ff       	call   801a68 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801caa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	51                   	push   %ecx
  801cb8:	52                   	push   %edx
  801cb9:	50                   	push   %eax
  801cba:	6a 17                	push   $0x17
  801cbc:	e8 a7 fd ff ff       	call   801a68 <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	52                   	push   %edx
  801cd6:	50                   	push   %eax
  801cd7:	6a 18                	push   $0x18
  801cd9:	e8 8a fd ff ff       	call   801a68 <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	6a 00                	push   $0x0
  801ceb:	ff 75 14             	pushl  0x14(%ebp)
  801cee:	ff 75 10             	pushl  0x10(%ebp)
  801cf1:	ff 75 0c             	pushl  0xc(%ebp)
  801cf4:	50                   	push   %eax
  801cf5:	6a 19                	push   $0x19
  801cf7:	e8 6c fd ff ff       	call   801a68 <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	50                   	push   %eax
  801d10:	6a 1a                	push   $0x1a
  801d12:	e8 51 fd ff ff       	call   801a68 <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
}
  801d1a:	90                   	nop
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	50                   	push   %eax
  801d2c:	6a 1b                	push   $0x1b
  801d2e:	e8 35 fd ff ff       	call   801a68 <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 05                	push   $0x5
  801d47:	e8 1c fd ff ff       	call   801a68 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 06                	push   $0x6
  801d60:	e8 03 fd ff ff       	call   801a68 <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 07                	push   $0x7
  801d79:	e8 ea fc ff ff       	call   801a68 <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <sys_exit_env>:


void sys_exit_env(void)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 1c                	push   $0x1c
  801d92:	e8 d1 fc ff ff       	call   801a68 <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
}
  801d9a:	90                   	nop
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801da3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801da6:	8d 50 04             	lea    0x4(%eax),%edx
  801da9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	52                   	push   %edx
  801db3:	50                   	push   %eax
  801db4:	6a 1d                	push   $0x1d
  801db6:	e8 ad fc ff ff       	call   801a68 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
	return result;
  801dbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dc7:	89 01                	mov    %eax,(%ecx)
  801dc9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	c9                   	leave  
  801dd0:	c2 04 00             	ret    $0x4

00801dd3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	ff 75 10             	pushl  0x10(%ebp)
  801ddd:	ff 75 0c             	pushl  0xc(%ebp)
  801de0:	ff 75 08             	pushl  0x8(%ebp)
  801de3:	6a 13                	push   $0x13
  801de5:	e8 7e fc ff ff       	call   801a68 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ded:	90                   	nop
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_rcr2>:
uint32 sys_rcr2()
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 1e                	push   $0x1e
  801dff:	e8 64 fc ff ff       	call   801a68 <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 04             	sub    $0x4,%esp
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e15:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	50                   	push   %eax
  801e22:	6a 1f                	push   $0x1f
  801e24:	e8 3f fc ff ff       	call   801a68 <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2c:	90                   	nop
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <rsttst>:
void rsttst()
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 21                	push   $0x21
  801e3e:	e8 25 fc ff ff       	call   801a68 <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
	return ;
  801e46:	90                   	nop
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 04             	sub    $0x4,%esp
  801e4f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e52:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e55:	8b 55 18             	mov    0x18(%ebp),%edx
  801e58:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e5c:	52                   	push   %edx
  801e5d:	50                   	push   %eax
  801e5e:	ff 75 10             	pushl  0x10(%ebp)
  801e61:	ff 75 0c             	pushl  0xc(%ebp)
  801e64:	ff 75 08             	pushl  0x8(%ebp)
  801e67:	6a 20                	push   $0x20
  801e69:	e8 fa fb ff ff       	call   801a68 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e71:	90                   	nop
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <chktst>:
void chktst(uint32 n)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	ff 75 08             	pushl  0x8(%ebp)
  801e82:	6a 22                	push   $0x22
  801e84:	e8 df fb ff ff       	call   801a68 <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8c:	90                   	nop
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <inctst>:

void inctst()
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 23                	push   $0x23
  801e9e:	e8 c5 fb ff ff       	call   801a68 <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea6:	90                   	nop
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <gettst>:
uint32 gettst()
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 24                	push   $0x24
  801eb8:	e8 ab fb ff ff       	call   801a68 <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
}
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 25                	push   $0x25
  801ed4:	e8 8f fb ff ff       	call   801a68 <syscall>
  801ed9:	83 c4 18             	add    $0x18,%esp
  801edc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801edf:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ee3:	75 07                	jne    801eec <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ee5:	b8 01 00 00 00       	mov    $0x1,%eax
  801eea:	eb 05                	jmp    801ef1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801eec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 25                	push   $0x25
  801f05:	e8 5e fb ff ff       	call   801a68 <syscall>
  801f0a:	83 c4 18             	add    $0x18,%esp
  801f0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f10:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f14:	75 07                	jne    801f1d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f16:	b8 01 00 00 00       	mov    $0x1,%eax
  801f1b:	eb 05                	jmp    801f22 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 25                	push   $0x25
  801f36:	e8 2d fb ff ff       	call   801a68 <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
  801f3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f41:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f45:	75 07                	jne    801f4e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f47:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4c:	eb 05                	jmp    801f53 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 25                	push   $0x25
  801f67:	e8 fc fa ff ff       	call   801a68 <syscall>
  801f6c:	83 c4 18             	add    $0x18,%esp
  801f6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f72:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f76:	75 07                	jne    801f7f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f78:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7d:	eb 05                	jmp    801f84 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f84:	c9                   	leave  
  801f85:	c3                   	ret    

00801f86 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	ff 75 08             	pushl  0x8(%ebp)
  801f94:	6a 26                	push   $0x26
  801f96:	e8 cd fa ff ff       	call   801a68 <syscall>
  801f9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9e:	90                   	nop
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fa5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fa8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	6a 00                	push   $0x0
  801fb3:	53                   	push   %ebx
  801fb4:	51                   	push   %ecx
  801fb5:	52                   	push   %edx
  801fb6:	50                   	push   %eax
  801fb7:	6a 27                	push   $0x27
  801fb9:	e8 aa fa ff ff       	call   801a68 <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
}
  801fc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	52                   	push   %edx
  801fd6:	50                   	push   %eax
  801fd7:	6a 28                	push   $0x28
  801fd9:	e8 8a fa ff ff       	call   801a68 <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801fe6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fe9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fec:	8b 45 08             	mov    0x8(%ebp),%eax
  801fef:	6a 00                	push   $0x0
  801ff1:	51                   	push   %ecx
  801ff2:	ff 75 10             	pushl  0x10(%ebp)
  801ff5:	52                   	push   %edx
  801ff6:	50                   	push   %eax
  801ff7:	6a 29                	push   $0x29
  801ff9:	e8 6a fa ff ff       	call   801a68 <syscall>
  801ffe:	83 c4 18             	add    $0x18,%esp
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	ff 75 10             	pushl  0x10(%ebp)
  80200d:	ff 75 0c             	pushl  0xc(%ebp)
  802010:	ff 75 08             	pushl  0x8(%ebp)
  802013:	6a 12                	push   $0x12
  802015:	e8 4e fa ff ff       	call   801a68 <syscall>
  80201a:	83 c4 18             	add    $0x18,%esp
	return ;
  80201d:	90                   	nop
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802023:	8b 55 0c             	mov    0xc(%ebp),%edx
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	52                   	push   %edx
  802030:	50                   	push   %eax
  802031:	6a 2a                	push   $0x2a
  802033:	e8 30 fa ff ff       	call   801a68 <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
	return;
  80203b:	90                   	nop
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	50                   	push   %eax
  80204d:	6a 2b                	push   $0x2b
  80204f:	e8 14 fa ff ff       	call   801a68 <syscall>
  802054:	83 c4 18             	add    $0x18,%esp
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	ff 75 0c             	pushl  0xc(%ebp)
  802065:	ff 75 08             	pushl  0x8(%ebp)
  802068:	6a 2c                	push   $0x2c
  80206a:	e8 f9 f9 ff ff       	call   801a68 <syscall>
  80206f:	83 c4 18             	add    $0x18,%esp
	return;
  802072:	90                   	nop
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	ff 75 0c             	pushl  0xc(%ebp)
  802081:	ff 75 08             	pushl  0x8(%ebp)
  802084:	6a 2d                	push   $0x2d
  802086:	e8 dd f9 ff ff       	call   801a68 <syscall>
  80208b:	83 c4 18             	add    $0x18,%esp
	return;
  80208e:	90                   	nop
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
  802094:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	83 e8 04             	sub    $0x4,%eax
  80209d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8020a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a3:	8b 00                	mov    (%eax),%eax
  8020a5:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	83 e8 04             	sub    $0x4,%eax
  8020b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8020b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020bc:	8b 00                	mov    (%eax),%eax
  8020be:	83 e0 01             	and    $0x1,%eax
  8020c1:	85 c0                	test   %eax,%eax
  8020c3:	0f 94 c0             	sete   %al
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8020ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8020d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d8:	83 f8 02             	cmp    $0x2,%eax
  8020db:	74 2b                	je     802108 <alloc_block+0x40>
  8020dd:	83 f8 02             	cmp    $0x2,%eax
  8020e0:	7f 07                	jg     8020e9 <alloc_block+0x21>
  8020e2:	83 f8 01             	cmp    $0x1,%eax
  8020e5:	74 0e                	je     8020f5 <alloc_block+0x2d>
  8020e7:	eb 58                	jmp    802141 <alloc_block+0x79>
  8020e9:	83 f8 03             	cmp    $0x3,%eax
  8020ec:	74 2d                	je     80211b <alloc_block+0x53>
  8020ee:	83 f8 04             	cmp    $0x4,%eax
  8020f1:	74 3b                	je     80212e <alloc_block+0x66>
  8020f3:	eb 4c                	jmp    802141 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020f5:	83 ec 0c             	sub    $0xc,%esp
  8020f8:	ff 75 08             	pushl  0x8(%ebp)
  8020fb:	e8 11 03 00 00       	call   802411 <alloc_block_FF>
  802100:	83 c4 10             	add    $0x10,%esp
  802103:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802106:	eb 4a                	jmp    802152 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802108:	83 ec 0c             	sub    $0xc,%esp
  80210b:	ff 75 08             	pushl  0x8(%ebp)
  80210e:	e8 fa 19 00 00       	call   803b0d <alloc_block_NF>
  802113:	83 c4 10             	add    $0x10,%esp
  802116:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802119:	eb 37                	jmp    802152 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80211b:	83 ec 0c             	sub    $0xc,%esp
  80211e:	ff 75 08             	pushl  0x8(%ebp)
  802121:	e8 a7 07 00 00       	call   8028cd <alloc_block_BF>
  802126:	83 c4 10             	add    $0x10,%esp
  802129:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80212c:	eb 24                	jmp    802152 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80212e:	83 ec 0c             	sub    $0xc,%esp
  802131:	ff 75 08             	pushl  0x8(%ebp)
  802134:	e8 b7 19 00 00       	call   803af0 <alloc_block_WF>
  802139:	83 c4 10             	add    $0x10,%esp
  80213c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80213f:	eb 11                	jmp    802152 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802141:	83 ec 0c             	sub    $0xc,%esp
  802144:	68 84 45 80 00       	push   $0x804584
  802149:	e8 60 e5 ff ff       	call   8006ae <cprintf>
  80214e:	83 c4 10             	add    $0x10,%esp
		break;
  802151:	90                   	nop
	}
	return va;
  802152:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	53                   	push   %ebx
  80215b:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80215e:	83 ec 0c             	sub    $0xc,%esp
  802161:	68 a4 45 80 00       	push   $0x8045a4
  802166:	e8 43 e5 ff ff       	call   8006ae <cprintf>
  80216b:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80216e:	83 ec 0c             	sub    $0xc,%esp
  802171:	68 cf 45 80 00       	push   $0x8045cf
  802176:	e8 33 e5 ff ff       	call   8006ae <cprintf>
  80217b:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802184:	eb 37                	jmp    8021bd <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802186:	83 ec 0c             	sub    $0xc,%esp
  802189:	ff 75 f4             	pushl  -0xc(%ebp)
  80218c:	e8 19 ff ff ff       	call   8020aa <is_free_block>
  802191:	83 c4 10             	add    $0x10,%esp
  802194:	0f be d8             	movsbl %al,%ebx
  802197:	83 ec 0c             	sub    $0xc,%esp
  80219a:	ff 75 f4             	pushl  -0xc(%ebp)
  80219d:	e8 ef fe ff ff       	call   802091 <get_block_size>
  8021a2:	83 c4 10             	add    $0x10,%esp
  8021a5:	83 ec 04             	sub    $0x4,%esp
  8021a8:	53                   	push   %ebx
  8021a9:	50                   	push   %eax
  8021aa:	68 e7 45 80 00       	push   $0x8045e7
  8021af:	e8 fa e4 ff ff       	call   8006ae <cprintf>
  8021b4:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8021b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c1:	74 07                	je     8021ca <print_blocks_list+0x73>
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	8b 00                	mov    (%eax),%eax
  8021c8:	eb 05                	jmp    8021cf <print_blocks_list+0x78>
  8021ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cf:	89 45 10             	mov    %eax,0x10(%ebp)
  8021d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	75 ad                	jne    802186 <print_blocks_list+0x2f>
  8021d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021dd:	75 a7                	jne    802186 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8021df:	83 ec 0c             	sub    $0xc,%esp
  8021e2:	68 a4 45 80 00       	push   $0x8045a4
  8021e7:	e8 c2 e4 ff ff       	call   8006ae <cprintf>
  8021ec:	83 c4 10             	add    $0x10,%esp

}
  8021ef:	90                   	nop
  8021f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fe:	83 e0 01             	and    $0x1,%eax
  802201:	85 c0                	test   %eax,%eax
  802203:	74 03                	je     802208 <initialize_dynamic_allocator+0x13>
  802205:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802208:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80220c:	0f 84 c7 01 00 00    	je     8023d9 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802212:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802219:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80221c:	8b 55 08             	mov    0x8(%ebp),%edx
  80221f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802222:	01 d0                	add    %edx,%eax
  802224:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802229:	0f 87 ad 01 00 00    	ja     8023dc <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	85 c0                	test   %eax,%eax
  802234:	0f 89 a5 01 00 00    	jns    8023df <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80223a:	8b 55 08             	mov    0x8(%ebp),%edx
  80223d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802240:	01 d0                	add    %edx,%eax
  802242:	83 e8 04             	sub    $0x4,%eax
  802245:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  80224a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802251:	a1 30 50 80 00       	mov    0x805030,%eax
  802256:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802259:	e9 87 00 00 00       	jmp    8022e5 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80225e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802262:	75 14                	jne    802278 <initialize_dynamic_allocator+0x83>
  802264:	83 ec 04             	sub    $0x4,%esp
  802267:	68 ff 45 80 00       	push   $0x8045ff
  80226c:	6a 79                	push   $0x79
  80226e:	68 1d 46 80 00       	push   $0x80461d
  802273:	e8 79 e1 ff ff       	call   8003f1 <_panic>
  802278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227b:	8b 00                	mov    (%eax),%eax
  80227d:	85 c0                	test   %eax,%eax
  80227f:	74 10                	je     802291 <initialize_dynamic_allocator+0x9c>
  802281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802284:	8b 00                	mov    (%eax),%eax
  802286:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802289:	8b 52 04             	mov    0x4(%edx),%edx
  80228c:	89 50 04             	mov    %edx,0x4(%eax)
  80228f:	eb 0b                	jmp    80229c <initialize_dynamic_allocator+0xa7>
  802291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802294:	8b 40 04             	mov    0x4(%eax),%eax
  802297:	a3 34 50 80 00       	mov    %eax,0x805034
  80229c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229f:	8b 40 04             	mov    0x4(%eax),%eax
  8022a2:	85 c0                	test   %eax,%eax
  8022a4:	74 0f                	je     8022b5 <initialize_dynamic_allocator+0xc0>
  8022a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a9:	8b 40 04             	mov    0x4(%eax),%eax
  8022ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022af:	8b 12                	mov    (%edx),%edx
  8022b1:	89 10                	mov    %edx,(%eax)
  8022b3:	eb 0a                	jmp    8022bf <initialize_dynamic_allocator+0xca>
  8022b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b8:	8b 00                	mov    (%eax),%eax
  8022ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022d2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8022d7:	48                   	dec    %eax
  8022d8:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8022dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8022e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e9:	74 07                	je     8022f2 <initialize_dynamic_allocator+0xfd>
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	8b 00                	mov    (%eax),%eax
  8022f0:	eb 05                	jmp    8022f7 <initialize_dynamic_allocator+0x102>
  8022f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f7:	a3 38 50 80 00       	mov    %eax,0x805038
  8022fc:	a1 38 50 80 00       	mov    0x805038,%eax
  802301:	85 c0                	test   %eax,%eax
  802303:	0f 85 55 ff ff ff    	jne    80225e <initialize_dynamic_allocator+0x69>
  802309:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230d:	0f 85 4b ff ff ff    	jne    80225e <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802322:	a1 48 50 80 00       	mov    0x805048,%eax
  802327:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  80232c:	a1 44 50 80 00       	mov    0x805044,%eax
  802331:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	83 c0 08             	add    $0x8,%eax
  80233d:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	83 c0 04             	add    $0x4,%eax
  802346:	8b 55 0c             	mov    0xc(%ebp),%edx
  802349:	83 ea 08             	sub    $0x8,%edx
  80234c:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80234e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	01 d0                	add    %edx,%eax
  802356:	83 e8 08             	sub    $0x8,%eax
  802359:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235c:	83 ea 08             	sub    $0x8,%edx
  80235f:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802361:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80236a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802374:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802378:	75 17                	jne    802391 <initialize_dynamic_allocator+0x19c>
  80237a:	83 ec 04             	sub    $0x4,%esp
  80237d:	68 38 46 80 00       	push   $0x804638
  802382:	68 90 00 00 00       	push   $0x90
  802387:	68 1d 46 80 00       	push   $0x80461d
  80238c:	e8 60 e0 ff ff       	call   8003f1 <_panic>
  802391:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802397:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239a:	89 10                	mov    %edx,(%eax)
  80239c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239f:	8b 00                	mov    (%eax),%eax
  8023a1:	85 c0                	test   %eax,%eax
  8023a3:	74 0d                	je     8023b2 <initialize_dynamic_allocator+0x1bd>
  8023a5:	a1 30 50 80 00       	mov    0x805030,%eax
  8023aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023ad:	89 50 04             	mov    %edx,0x4(%eax)
  8023b0:	eb 08                	jmp    8023ba <initialize_dynamic_allocator+0x1c5>
  8023b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b5:	a3 34 50 80 00       	mov    %eax,0x805034
  8023ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8023c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023cc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8023d1:	40                   	inc    %eax
  8023d2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8023d7:	eb 07                	jmp    8023e0 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8023d9:	90                   	nop
  8023da:	eb 04                	jmp    8023e0 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8023dc:	90                   	nop
  8023dd:	eb 01                	jmp    8023e0 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8023df:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8023e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e8:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	8d 50 fc             	lea    -0x4(%eax),%edx
  8023f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f4:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	83 e8 04             	sub    $0x4,%eax
  8023fc:	8b 00                	mov    (%eax),%eax
  8023fe:	83 e0 fe             	and    $0xfffffffe,%eax
  802401:	8d 50 f8             	lea    -0x8(%eax),%edx
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	01 c2                	add    %eax,%edx
  802409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240c:	89 02                	mov    %eax,(%edx)
}
  80240e:	90                   	nop
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    

00802411 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
  802414:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	83 e0 01             	and    $0x1,%eax
  80241d:	85 c0                	test   %eax,%eax
  80241f:	74 03                	je     802424 <alloc_block_FF+0x13>
  802421:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802424:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802428:	77 07                	ja     802431 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80242a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802431:	a1 28 50 80 00       	mov    0x805028,%eax
  802436:	85 c0                	test   %eax,%eax
  802438:	75 73                	jne    8024ad <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	83 c0 10             	add    $0x10,%eax
  802440:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802443:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80244a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80244d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802450:	01 d0                	add    %edx,%eax
  802452:	48                   	dec    %eax
  802453:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802456:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802459:	ba 00 00 00 00       	mov    $0x0,%edx
  80245e:	f7 75 ec             	divl   -0x14(%ebp)
  802461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802464:	29 d0                	sub    %edx,%eax
  802466:	c1 e8 0c             	shr    $0xc,%eax
  802469:	83 ec 0c             	sub    $0xc,%esp
  80246c:	50                   	push   %eax
  80246d:	e8 d6 ef ff ff       	call   801448 <sbrk>
  802472:	83 c4 10             	add    $0x10,%esp
  802475:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802478:	83 ec 0c             	sub    $0xc,%esp
  80247b:	6a 00                	push   $0x0
  80247d:	e8 c6 ef ff ff       	call   801448 <sbrk>
  802482:	83 c4 10             	add    $0x10,%esp
  802485:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802488:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80248b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80248e:	83 ec 08             	sub    $0x8,%esp
  802491:	50                   	push   %eax
  802492:	ff 75 e4             	pushl  -0x1c(%ebp)
  802495:	e8 5b fd ff ff       	call   8021f5 <initialize_dynamic_allocator>
  80249a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80249d:	83 ec 0c             	sub    $0xc,%esp
  8024a0:	68 5b 46 80 00       	push   $0x80465b
  8024a5:	e8 04 e2 ff ff       	call   8006ae <cprintf>
  8024aa:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8024ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024b1:	75 0a                	jne    8024bd <alloc_block_FF+0xac>
	        return NULL;
  8024b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b8:	e9 0e 04 00 00       	jmp    8028cb <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8024bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024c4:	a1 30 50 80 00       	mov    0x805030,%eax
  8024c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cc:	e9 f3 02 00 00       	jmp    8027c4 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8024d7:	83 ec 0c             	sub    $0xc,%esp
  8024da:	ff 75 bc             	pushl  -0x44(%ebp)
  8024dd:	e8 af fb ff ff       	call   802091 <get_block_size>
  8024e2:	83 c4 10             	add    $0x10,%esp
  8024e5:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8024e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024eb:	83 c0 08             	add    $0x8,%eax
  8024ee:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024f1:	0f 87 c5 02 00 00    	ja     8027bc <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fa:	83 c0 18             	add    $0x18,%eax
  8024fd:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802500:	0f 87 19 02 00 00    	ja     80271f <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802506:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802509:	2b 45 08             	sub    0x8(%ebp),%eax
  80250c:	83 e8 08             	sub    $0x8,%eax
  80250f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802512:	8b 45 08             	mov    0x8(%ebp),%eax
  802515:	8d 50 08             	lea    0x8(%eax),%edx
  802518:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80251b:	01 d0                	add    %edx,%eax
  80251d:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802520:	8b 45 08             	mov    0x8(%ebp),%eax
  802523:	83 c0 08             	add    $0x8,%eax
  802526:	83 ec 04             	sub    $0x4,%esp
  802529:	6a 01                	push   $0x1
  80252b:	50                   	push   %eax
  80252c:	ff 75 bc             	pushl  -0x44(%ebp)
  80252f:	e8 ae fe ff ff       	call   8023e2 <set_block_data>
  802534:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 40 04             	mov    0x4(%eax),%eax
  80253d:	85 c0                	test   %eax,%eax
  80253f:	75 68                	jne    8025a9 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802541:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802545:	75 17                	jne    80255e <alloc_block_FF+0x14d>
  802547:	83 ec 04             	sub    $0x4,%esp
  80254a:	68 38 46 80 00       	push   $0x804638
  80254f:	68 d7 00 00 00       	push   $0xd7
  802554:	68 1d 46 80 00       	push   $0x80461d
  802559:	e8 93 de ff ff       	call   8003f1 <_panic>
  80255e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802564:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802567:	89 10                	mov    %edx,(%eax)
  802569:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80256c:	8b 00                	mov    (%eax),%eax
  80256e:	85 c0                	test   %eax,%eax
  802570:	74 0d                	je     80257f <alloc_block_FF+0x16e>
  802572:	a1 30 50 80 00       	mov    0x805030,%eax
  802577:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80257a:	89 50 04             	mov    %edx,0x4(%eax)
  80257d:	eb 08                	jmp    802587 <alloc_block_FF+0x176>
  80257f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802582:	a3 34 50 80 00       	mov    %eax,0x805034
  802587:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80258a:	a3 30 50 80 00       	mov    %eax,0x805030
  80258f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802592:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802599:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80259e:	40                   	inc    %eax
  80259f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8025a4:	e9 dc 00 00 00       	jmp    802685 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	8b 00                	mov    (%eax),%eax
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	75 65                	jne    802617 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025b2:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025b6:	75 17                	jne    8025cf <alloc_block_FF+0x1be>
  8025b8:	83 ec 04             	sub    $0x4,%esp
  8025bb:	68 6c 46 80 00       	push   $0x80466c
  8025c0:	68 db 00 00 00       	push   $0xdb
  8025c5:	68 1d 46 80 00       	push   $0x80461d
  8025ca:	e8 22 de ff ff       	call   8003f1 <_panic>
  8025cf:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8025d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025d8:	89 50 04             	mov    %edx,0x4(%eax)
  8025db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025de:	8b 40 04             	mov    0x4(%eax),%eax
  8025e1:	85 c0                	test   %eax,%eax
  8025e3:	74 0c                	je     8025f1 <alloc_block_FF+0x1e0>
  8025e5:	a1 34 50 80 00       	mov    0x805034,%eax
  8025ea:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025ed:	89 10                	mov    %edx,(%eax)
  8025ef:	eb 08                	jmp    8025f9 <alloc_block_FF+0x1e8>
  8025f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8025f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025fc:	a3 34 50 80 00       	mov    %eax,0x805034
  802601:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802604:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80260a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80260f:	40                   	inc    %eax
  802610:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802615:	eb 6e                	jmp    802685 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802617:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261b:	74 06                	je     802623 <alloc_block_FF+0x212>
  80261d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802621:	75 17                	jne    80263a <alloc_block_FF+0x229>
  802623:	83 ec 04             	sub    $0x4,%esp
  802626:	68 90 46 80 00       	push   $0x804690
  80262b:	68 df 00 00 00       	push   $0xdf
  802630:	68 1d 46 80 00       	push   $0x80461d
  802635:	e8 b7 dd ff ff       	call   8003f1 <_panic>
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	8b 10                	mov    (%eax),%edx
  80263f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802642:	89 10                	mov    %edx,(%eax)
  802644:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802647:	8b 00                	mov    (%eax),%eax
  802649:	85 c0                	test   %eax,%eax
  80264b:	74 0b                	je     802658 <alloc_block_FF+0x247>
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	8b 00                	mov    (%eax),%eax
  802652:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802655:	89 50 04             	mov    %edx,0x4(%eax)
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80265e:	89 10                	mov    %edx,(%eax)
  802660:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802666:	89 50 04             	mov    %edx,0x4(%eax)
  802669:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80266c:	8b 00                	mov    (%eax),%eax
  80266e:	85 c0                	test   %eax,%eax
  802670:	75 08                	jne    80267a <alloc_block_FF+0x269>
  802672:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802675:	a3 34 50 80 00       	mov    %eax,0x805034
  80267a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80267f:	40                   	inc    %eax
  802680:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802685:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802689:	75 17                	jne    8026a2 <alloc_block_FF+0x291>
  80268b:	83 ec 04             	sub    $0x4,%esp
  80268e:	68 ff 45 80 00       	push   $0x8045ff
  802693:	68 e1 00 00 00       	push   $0xe1
  802698:	68 1d 46 80 00       	push   $0x80461d
  80269d:	e8 4f dd ff ff       	call   8003f1 <_panic>
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	8b 00                	mov    (%eax),%eax
  8026a7:	85 c0                	test   %eax,%eax
  8026a9:	74 10                	je     8026bb <alloc_block_FF+0x2aa>
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 00                	mov    (%eax),%eax
  8026b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b3:	8b 52 04             	mov    0x4(%edx),%edx
  8026b6:	89 50 04             	mov    %edx,0x4(%eax)
  8026b9:	eb 0b                	jmp    8026c6 <alloc_block_FF+0x2b5>
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	8b 40 04             	mov    0x4(%eax),%eax
  8026c1:	a3 34 50 80 00       	mov    %eax,0x805034
  8026c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c9:	8b 40 04             	mov    0x4(%eax),%eax
  8026cc:	85 c0                	test   %eax,%eax
  8026ce:	74 0f                	je     8026df <alloc_block_FF+0x2ce>
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 40 04             	mov    0x4(%eax),%eax
  8026d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d9:	8b 12                	mov    (%edx),%edx
  8026db:	89 10                	mov    %edx,(%eax)
  8026dd:	eb 0a                	jmp    8026e9 <alloc_block_FF+0x2d8>
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 00                	mov    (%eax),%eax
  8026e4:	a3 30 50 80 00       	mov    %eax,0x805030
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026fc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802701:	48                   	dec    %eax
  802702:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802707:	83 ec 04             	sub    $0x4,%esp
  80270a:	6a 00                	push   $0x0
  80270c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80270f:	ff 75 b0             	pushl  -0x50(%ebp)
  802712:	e8 cb fc ff ff       	call   8023e2 <set_block_data>
  802717:	83 c4 10             	add    $0x10,%esp
  80271a:	e9 95 00 00 00       	jmp    8027b4 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80271f:	83 ec 04             	sub    $0x4,%esp
  802722:	6a 01                	push   $0x1
  802724:	ff 75 b8             	pushl  -0x48(%ebp)
  802727:	ff 75 bc             	pushl  -0x44(%ebp)
  80272a:	e8 b3 fc ff ff       	call   8023e2 <set_block_data>
  80272f:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802732:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802736:	75 17                	jne    80274f <alloc_block_FF+0x33e>
  802738:	83 ec 04             	sub    $0x4,%esp
  80273b:	68 ff 45 80 00       	push   $0x8045ff
  802740:	68 e8 00 00 00       	push   $0xe8
  802745:	68 1d 46 80 00       	push   $0x80461d
  80274a:	e8 a2 dc ff ff       	call   8003f1 <_panic>
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	8b 00                	mov    (%eax),%eax
  802754:	85 c0                	test   %eax,%eax
  802756:	74 10                	je     802768 <alloc_block_FF+0x357>
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	8b 00                	mov    (%eax),%eax
  80275d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802760:	8b 52 04             	mov    0x4(%edx),%edx
  802763:	89 50 04             	mov    %edx,0x4(%eax)
  802766:	eb 0b                	jmp    802773 <alloc_block_FF+0x362>
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 04             	mov    0x4(%eax),%eax
  80276e:	a3 34 50 80 00       	mov    %eax,0x805034
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	8b 40 04             	mov    0x4(%eax),%eax
  802779:	85 c0                	test   %eax,%eax
  80277b:	74 0f                	je     80278c <alloc_block_FF+0x37b>
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 40 04             	mov    0x4(%eax),%eax
  802783:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802786:	8b 12                	mov    (%edx),%edx
  802788:	89 10                	mov    %edx,(%eax)
  80278a:	eb 0a                	jmp    802796 <alloc_block_FF+0x385>
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	8b 00                	mov    (%eax),%eax
  802791:	a3 30 50 80 00       	mov    %eax,0x805030
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027ae:	48                   	dec    %eax
  8027af:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  8027b4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027b7:	e9 0f 01 00 00       	jmp    8028cb <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8027bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8027c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c8:	74 07                	je     8027d1 <alloc_block_FF+0x3c0>
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 00                	mov    (%eax),%eax
  8027cf:	eb 05                	jmp    8027d6 <alloc_block_FF+0x3c5>
  8027d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d6:	a3 38 50 80 00       	mov    %eax,0x805038
  8027db:	a1 38 50 80 00       	mov    0x805038,%eax
  8027e0:	85 c0                	test   %eax,%eax
  8027e2:	0f 85 e9 fc ff ff    	jne    8024d1 <alloc_block_FF+0xc0>
  8027e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ec:	0f 85 df fc ff ff    	jne    8024d1 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8027f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f5:	83 c0 08             	add    $0x8,%eax
  8027f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8027fb:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802802:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802805:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802808:	01 d0                	add    %edx,%eax
  80280a:	48                   	dec    %eax
  80280b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80280e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802811:	ba 00 00 00 00       	mov    $0x0,%edx
  802816:	f7 75 d8             	divl   -0x28(%ebp)
  802819:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80281c:	29 d0                	sub    %edx,%eax
  80281e:	c1 e8 0c             	shr    $0xc,%eax
  802821:	83 ec 0c             	sub    $0xc,%esp
  802824:	50                   	push   %eax
  802825:	e8 1e ec ff ff       	call   801448 <sbrk>
  80282a:	83 c4 10             	add    $0x10,%esp
  80282d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802830:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802834:	75 0a                	jne    802840 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802836:	b8 00 00 00 00       	mov    $0x0,%eax
  80283b:	e9 8b 00 00 00       	jmp    8028cb <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802840:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802847:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80284a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80284d:	01 d0                	add    %edx,%eax
  80284f:	48                   	dec    %eax
  802850:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802853:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802856:	ba 00 00 00 00       	mov    $0x0,%edx
  80285b:	f7 75 cc             	divl   -0x34(%ebp)
  80285e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802861:	29 d0                	sub    %edx,%eax
  802863:	8d 50 fc             	lea    -0x4(%eax),%edx
  802866:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802869:	01 d0                	add    %edx,%eax
  80286b:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802870:	a1 44 50 80 00       	mov    0x805044,%eax
  802875:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80287b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802882:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802885:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802888:	01 d0                	add    %edx,%eax
  80288a:	48                   	dec    %eax
  80288b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80288e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802891:	ba 00 00 00 00       	mov    $0x0,%edx
  802896:	f7 75 c4             	divl   -0x3c(%ebp)
  802899:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80289c:	29 d0                	sub    %edx,%eax
  80289e:	83 ec 04             	sub    $0x4,%esp
  8028a1:	6a 01                	push   $0x1
  8028a3:	50                   	push   %eax
  8028a4:	ff 75 d0             	pushl  -0x30(%ebp)
  8028a7:	e8 36 fb ff ff       	call   8023e2 <set_block_data>
  8028ac:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8028af:	83 ec 0c             	sub    $0xc,%esp
  8028b2:	ff 75 d0             	pushl  -0x30(%ebp)
  8028b5:	e8 1b 0a 00 00       	call   8032d5 <free_block>
  8028ba:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8028bd:	83 ec 0c             	sub    $0xc,%esp
  8028c0:	ff 75 08             	pushl  0x8(%ebp)
  8028c3:	e8 49 fb ff ff       	call   802411 <alloc_block_FF>
  8028c8:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8028cb:	c9                   	leave  
  8028cc:	c3                   	ret    

008028cd <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8028cd:	55                   	push   %ebp
  8028ce:	89 e5                	mov    %esp,%ebp
  8028d0:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	83 e0 01             	and    $0x1,%eax
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	74 03                	je     8028e0 <alloc_block_BF+0x13>
  8028dd:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028e0:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028e4:	77 07                	ja     8028ed <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028e6:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028ed:	a1 28 50 80 00       	mov    0x805028,%eax
  8028f2:	85 c0                	test   %eax,%eax
  8028f4:	75 73                	jne    802969 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f9:	83 c0 10             	add    $0x10,%eax
  8028fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028ff:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802906:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802909:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290c:	01 d0                	add    %edx,%eax
  80290e:	48                   	dec    %eax
  80290f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802912:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802915:	ba 00 00 00 00       	mov    $0x0,%edx
  80291a:	f7 75 e0             	divl   -0x20(%ebp)
  80291d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802920:	29 d0                	sub    %edx,%eax
  802922:	c1 e8 0c             	shr    $0xc,%eax
  802925:	83 ec 0c             	sub    $0xc,%esp
  802928:	50                   	push   %eax
  802929:	e8 1a eb ff ff       	call   801448 <sbrk>
  80292e:	83 c4 10             	add    $0x10,%esp
  802931:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802934:	83 ec 0c             	sub    $0xc,%esp
  802937:	6a 00                	push   $0x0
  802939:	e8 0a eb ff ff       	call   801448 <sbrk>
  80293e:	83 c4 10             	add    $0x10,%esp
  802941:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802944:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802947:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80294a:	83 ec 08             	sub    $0x8,%esp
  80294d:	50                   	push   %eax
  80294e:	ff 75 d8             	pushl  -0x28(%ebp)
  802951:	e8 9f f8 ff ff       	call   8021f5 <initialize_dynamic_allocator>
  802956:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802959:	83 ec 0c             	sub    $0xc,%esp
  80295c:	68 5b 46 80 00       	push   $0x80465b
  802961:	e8 48 dd ff ff       	call   8006ae <cprintf>
  802966:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802969:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802970:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802977:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80297e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802985:	a1 30 50 80 00       	mov    0x805030,%eax
  80298a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80298d:	e9 1d 01 00 00       	jmp    802aaf <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802998:	83 ec 0c             	sub    $0xc,%esp
  80299b:	ff 75 a8             	pushl  -0x58(%ebp)
  80299e:	e8 ee f6 ff ff       	call   802091 <get_block_size>
  8029a3:	83 c4 10             	add    $0x10,%esp
  8029a6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	83 c0 08             	add    $0x8,%eax
  8029af:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029b2:	0f 87 ef 00 00 00    	ja     802aa7 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	83 c0 18             	add    $0x18,%eax
  8029be:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029c1:	77 1d                	ja     8029e0 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8029c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029c9:	0f 86 d8 00 00 00    	jbe    802aa7 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8029cf:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8029d5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029db:	e9 c7 00 00 00       	jmp    802aa7 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	83 c0 08             	add    $0x8,%eax
  8029e6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029e9:	0f 85 9d 00 00 00    	jne    802a8c <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8029ef:	83 ec 04             	sub    $0x4,%esp
  8029f2:	6a 01                	push   $0x1
  8029f4:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029f7:	ff 75 a8             	pushl  -0x58(%ebp)
  8029fa:	e8 e3 f9 ff ff       	call   8023e2 <set_block_data>
  8029ff:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a06:	75 17                	jne    802a1f <alloc_block_BF+0x152>
  802a08:	83 ec 04             	sub    $0x4,%esp
  802a0b:	68 ff 45 80 00       	push   $0x8045ff
  802a10:	68 2c 01 00 00       	push   $0x12c
  802a15:	68 1d 46 80 00       	push   $0x80461d
  802a1a:	e8 d2 d9 ff ff       	call   8003f1 <_panic>
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	8b 00                	mov    (%eax),%eax
  802a24:	85 c0                	test   %eax,%eax
  802a26:	74 10                	je     802a38 <alloc_block_BF+0x16b>
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 00                	mov    (%eax),%eax
  802a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a30:	8b 52 04             	mov    0x4(%edx),%edx
  802a33:	89 50 04             	mov    %edx,0x4(%eax)
  802a36:	eb 0b                	jmp    802a43 <alloc_block_BF+0x176>
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 40 04             	mov    0x4(%eax),%eax
  802a3e:	a3 34 50 80 00       	mov    %eax,0x805034
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 40 04             	mov    0x4(%eax),%eax
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	74 0f                	je     802a5c <alloc_block_BF+0x18f>
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 40 04             	mov    0x4(%eax),%eax
  802a53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a56:	8b 12                	mov    (%edx),%edx
  802a58:	89 10                	mov    %edx,(%eax)
  802a5a:	eb 0a                	jmp    802a66 <alloc_block_BF+0x199>
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	a3 30 50 80 00       	mov    %eax,0x805030
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a79:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a7e:	48                   	dec    %eax
  802a7f:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802a84:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a87:	e9 24 04 00 00       	jmp    802eb0 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a92:	76 13                	jbe    802aa7 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a94:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a9b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802aa1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802aa4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802aa7:	a1 38 50 80 00       	mov    0x805038,%eax
  802aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab3:	74 07                	je     802abc <alloc_block_BF+0x1ef>
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 00                	mov    (%eax),%eax
  802aba:	eb 05                	jmp    802ac1 <alloc_block_BF+0x1f4>
  802abc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac1:	a3 38 50 80 00       	mov    %eax,0x805038
  802ac6:	a1 38 50 80 00       	mov    0x805038,%eax
  802acb:	85 c0                	test   %eax,%eax
  802acd:	0f 85 bf fe ff ff    	jne    802992 <alloc_block_BF+0xc5>
  802ad3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad7:	0f 85 b5 fe ff ff    	jne    802992 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802add:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ae1:	0f 84 26 02 00 00    	je     802d0d <alloc_block_BF+0x440>
  802ae7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aeb:	0f 85 1c 02 00 00    	jne    802d0d <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af4:	2b 45 08             	sub    0x8(%ebp),%eax
  802af7:	83 e8 08             	sub    $0x8,%eax
  802afa:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	8d 50 08             	lea    0x8(%eax),%edx
  802b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b06:	01 d0                	add    %edx,%eax
  802b08:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0e:	83 c0 08             	add    $0x8,%eax
  802b11:	83 ec 04             	sub    $0x4,%esp
  802b14:	6a 01                	push   $0x1
  802b16:	50                   	push   %eax
  802b17:	ff 75 f0             	pushl  -0x10(%ebp)
  802b1a:	e8 c3 f8 ff ff       	call   8023e2 <set_block_data>
  802b1f:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b25:	8b 40 04             	mov    0x4(%eax),%eax
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	75 68                	jne    802b94 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b2c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b30:	75 17                	jne    802b49 <alloc_block_BF+0x27c>
  802b32:	83 ec 04             	sub    $0x4,%esp
  802b35:	68 38 46 80 00       	push   $0x804638
  802b3a:	68 45 01 00 00       	push   $0x145
  802b3f:	68 1d 46 80 00       	push   $0x80461d
  802b44:	e8 a8 d8 ff ff       	call   8003f1 <_panic>
  802b49:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b4f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b52:	89 10                	mov    %edx,(%eax)
  802b54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b57:	8b 00                	mov    (%eax),%eax
  802b59:	85 c0                	test   %eax,%eax
  802b5b:	74 0d                	je     802b6a <alloc_block_BF+0x29d>
  802b5d:	a1 30 50 80 00       	mov    0x805030,%eax
  802b62:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b65:	89 50 04             	mov    %edx,0x4(%eax)
  802b68:	eb 08                	jmp    802b72 <alloc_block_BF+0x2a5>
  802b6a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b6d:	a3 34 50 80 00       	mov    %eax,0x805034
  802b72:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b75:	a3 30 50 80 00       	mov    %eax,0x805030
  802b7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b84:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b89:	40                   	inc    %eax
  802b8a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802b8f:	e9 dc 00 00 00       	jmp    802c70 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b97:	8b 00                	mov    (%eax),%eax
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	75 65                	jne    802c02 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b9d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ba1:	75 17                	jne    802bba <alloc_block_BF+0x2ed>
  802ba3:	83 ec 04             	sub    $0x4,%esp
  802ba6:	68 6c 46 80 00       	push   $0x80466c
  802bab:	68 4a 01 00 00       	push   $0x14a
  802bb0:	68 1d 46 80 00       	push   $0x80461d
  802bb5:	e8 37 d8 ff ff       	call   8003f1 <_panic>
  802bba:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802bc0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc3:	89 50 04             	mov    %edx,0x4(%eax)
  802bc6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc9:	8b 40 04             	mov    0x4(%eax),%eax
  802bcc:	85 c0                	test   %eax,%eax
  802bce:	74 0c                	je     802bdc <alloc_block_BF+0x30f>
  802bd0:	a1 34 50 80 00       	mov    0x805034,%eax
  802bd5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bd8:	89 10                	mov    %edx,(%eax)
  802bda:	eb 08                	jmp    802be4 <alloc_block_BF+0x317>
  802bdc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bdf:	a3 30 50 80 00       	mov    %eax,0x805030
  802be4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802be7:	a3 34 50 80 00       	mov    %eax,0x805034
  802bec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bfa:	40                   	inc    %eax
  802bfb:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802c00:	eb 6e                	jmp    802c70 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c06:	74 06                	je     802c0e <alloc_block_BF+0x341>
  802c08:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c0c:	75 17                	jne    802c25 <alloc_block_BF+0x358>
  802c0e:	83 ec 04             	sub    $0x4,%esp
  802c11:	68 90 46 80 00       	push   $0x804690
  802c16:	68 4f 01 00 00       	push   $0x14f
  802c1b:	68 1d 46 80 00       	push   $0x80461d
  802c20:	e8 cc d7 ff ff       	call   8003f1 <_panic>
  802c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c28:	8b 10                	mov    (%eax),%edx
  802c2a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c2d:	89 10                	mov    %edx,(%eax)
  802c2f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	85 c0                	test   %eax,%eax
  802c36:	74 0b                	je     802c43 <alloc_block_BF+0x376>
  802c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3b:	8b 00                	mov    (%eax),%eax
  802c3d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c40:	89 50 04             	mov    %edx,0x4(%eax)
  802c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c46:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c49:	89 10                	mov    %edx,(%eax)
  802c4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c51:	89 50 04             	mov    %edx,0x4(%eax)
  802c54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c57:	8b 00                	mov    (%eax),%eax
  802c59:	85 c0                	test   %eax,%eax
  802c5b:	75 08                	jne    802c65 <alloc_block_BF+0x398>
  802c5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c60:	a3 34 50 80 00       	mov    %eax,0x805034
  802c65:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c6a:	40                   	inc    %eax
  802c6b:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c74:	75 17                	jne    802c8d <alloc_block_BF+0x3c0>
  802c76:	83 ec 04             	sub    $0x4,%esp
  802c79:	68 ff 45 80 00       	push   $0x8045ff
  802c7e:	68 51 01 00 00       	push   $0x151
  802c83:	68 1d 46 80 00       	push   $0x80461d
  802c88:	e8 64 d7 ff ff       	call   8003f1 <_panic>
  802c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	85 c0                	test   %eax,%eax
  802c94:	74 10                	je     802ca6 <alloc_block_BF+0x3d9>
  802c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c99:	8b 00                	mov    (%eax),%eax
  802c9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c9e:	8b 52 04             	mov    0x4(%edx),%edx
  802ca1:	89 50 04             	mov    %edx,0x4(%eax)
  802ca4:	eb 0b                	jmp    802cb1 <alloc_block_BF+0x3e4>
  802ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca9:	8b 40 04             	mov    0x4(%eax),%eax
  802cac:	a3 34 50 80 00       	mov    %eax,0x805034
  802cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb4:	8b 40 04             	mov    0x4(%eax),%eax
  802cb7:	85 c0                	test   %eax,%eax
  802cb9:	74 0f                	je     802cca <alloc_block_BF+0x3fd>
  802cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbe:	8b 40 04             	mov    0x4(%eax),%eax
  802cc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cc4:	8b 12                	mov    (%edx),%edx
  802cc6:	89 10                	mov    %edx,(%eax)
  802cc8:	eb 0a                	jmp    802cd4 <alloc_block_BF+0x407>
  802cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccd:	8b 00                	mov    (%eax),%eax
  802ccf:	a3 30 50 80 00       	mov    %eax,0x805030
  802cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802cec:	48                   	dec    %eax
  802ced:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802cf2:	83 ec 04             	sub    $0x4,%esp
  802cf5:	6a 00                	push   $0x0
  802cf7:	ff 75 d0             	pushl  -0x30(%ebp)
  802cfa:	ff 75 cc             	pushl  -0x34(%ebp)
  802cfd:	e8 e0 f6 ff ff       	call   8023e2 <set_block_data>
  802d02:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d08:	e9 a3 01 00 00       	jmp    802eb0 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802d0d:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d11:	0f 85 9d 00 00 00    	jne    802db4 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d17:	83 ec 04             	sub    $0x4,%esp
  802d1a:	6a 01                	push   $0x1
  802d1c:	ff 75 ec             	pushl  -0x14(%ebp)
  802d1f:	ff 75 f0             	pushl  -0x10(%ebp)
  802d22:	e8 bb f6 ff ff       	call   8023e2 <set_block_data>
  802d27:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d2e:	75 17                	jne    802d47 <alloc_block_BF+0x47a>
  802d30:	83 ec 04             	sub    $0x4,%esp
  802d33:	68 ff 45 80 00       	push   $0x8045ff
  802d38:	68 58 01 00 00       	push   $0x158
  802d3d:	68 1d 46 80 00       	push   $0x80461d
  802d42:	e8 aa d6 ff ff       	call   8003f1 <_panic>
  802d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4a:	8b 00                	mov    (%eax),%eax
  802d4c:	85 c0                	test   %eax,%eax
  802d4e:	74 10                	je     802d60 <alloc_block_BF+0x493>
  802d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d53:	8b 00                	mov    (%eax),%eax
  802d55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d58:	8b 52 04             	mov    0x4(%edx),%edx
  802d5b:	89 50 04             	mov    %edx,0x4(%eax)
  802d5e:	eb 0b                	jmp    802d6b <alloc_block_BF+0x49e>
  802d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d63:	8b 40 04             	mov    0x4(%eax),%eax
  802d66:	a3 34 50 80 00       	mov    %eax,0x805034
  802d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6e:	8b 40 04             	mov    0x4(%eax),%eax
  802d71:	85 c0                	test   %eax,%eax
  802d73:	74 0f                	je     802d84 <alloc_block_BF+0x4b7>
  802d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d78:	8b 40 04             	mov    0x4(%eax),%eax
  802d7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d7e:	8b 12                	mov    (%edx),%edx
  802d80:	89 10                	mov    %edx,(%eax)
  802d82:	eb 0a                	jmp    802d8e <alloc_block_BF+0x4c1>
  802d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d87:	8b 00                	mov    (%eax),%eax
  802d89:	a3 30 50 80 00       	mov    %eax,0x805030
  802d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802da6:	48                   	dec    %eax
  802da7:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daf:	e9 fc 00 00 00       	jmp    802eb0 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802db4:	8b 45 08             	mov    0x8(%ebp),%eax
  802db7:	83 c0 08             	add    $0x8,%eax
  802dba:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802dbd:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802dc4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dc7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802dca:	01 d0                	add    %edx,%eax
  802dcc:	48                   	dec    %eax
  802dcd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802dd0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dd3:	ba 00 00 00 00       	mov    $0x0,%edx
  802dd8:	f7 75 c4             	divl   -0x3c(%ebp)
  802ddb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dde:	29 d0                	sub    %edx,%eax
  802de0:	c1 e8 0c             	shr    $0xc,%eax
  802de3:	83 ec 0c             	sub    $0xc,%esp
  802de6:	50                   	push   %eax
  802de7:	e8 5c e6 ff ff       	call   801448 <sbrk>
  802dec:	83 c4 10             	add    $0x10,%esp
  802def:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802df2:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802df6:	75 0a                	jne    802e02 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802df8:	b8 00 00 00 00       	mov    $0x0,%eax
  802dfd:	e9 ae 00 00 00       	jmp    802eb0 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e02:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e09:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e0c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e0f:	01 d0                	add    %edx,%eax
  802e11:	48                   	dec    %eax
  802e12:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e15:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e18:	ba 00 00 00 00       	mov    $0x0,%edx
  802e1d:	f7 75 b8             	divl   -0x48(%ebp)
  802e20:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e23:	29 d0                	sub    %edx,%eax
  802e25:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e28:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e2b:	01 d0                	add    %edx,%eax
  802e2d:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802e32:	a1 44 50 80 00       	mov    0x805044,%eax
  802e37:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802e3d:	83 ec 0c             	sub    $0xc,%esp
  802e40:	68 c4 46 80 00       	push   $0x8046c4
  802e45:	e8 64 d8 ff ff       	call   8006ae <cprintf>
  802e4a:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802e4d:	83 ec 08             	sub    $0x8,%esp
  802e50:	ff 75 bc             	pushl  -0x44(%ebp)
  802e53:	68 c9 46 80 00       	push   $0x8046c9
  802e58:	e8 51 d8 ff ff       	call   8006ae <cprintf>
  802e5d:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e60:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e67:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e6a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e6d:	01 d0                	add    %edx,%eax
  802e6f:	48                   	dec    %eax
  802e70:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e73:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e76:	ba 00 00 00 00       	mov    $0x0,%edx
  802e7b:	f7 75 b0             	divl   -0x50(%ebp)
  802e7e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e81:	29 d0                	sub    %edx,%eax
  802e83:	83 ec 04             	sub    $0x4,%esp
  802e86:	6a 01                	push   $0x1
  802e88:	50                   	push   %eax
  802e89:	ff 75 bc             	pushl  -0x44(%ebp)
  802e8c:	e8 51 f5 ff ff       	call   8023e2 <set_block_data>
  802e91:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e94:	83 ec 0c             	sub    $0xc,%esp
  802e97:	ff 75 bc             	pushl  -0x44(%ebp)
  802e9a:	e8 36 04 00 00       	call   8032d5 <free_block>
  802e9f:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802ea2:	83 ec 0c             	sub    $0xc,%esp
  802ea5:	ff 75 08             	pushl  0x8(%ebp)
  802ea8:	e8 20 fa ff ff       	call   8028cd <alloc_block_BF>
  802ead:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802eb0:	c9                   	leave  
  802eb1:	c3                   	ret    

00802eb2 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802eb2:	55                   	push   %ebp
  802eb3:	89 e5                	mov    %esp,%ebp
  802eb5:	53                   	push   %ebx
  802eb6:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802eb9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ec0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802ec7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ecb:	74 1e                	je     802eeb <merging+0x39>
  802ecd:	ff 75 08             	pushl  0x8(%ebp)
  802ed0:	e8 bc f1 ff ff       	call   802091 <get_block_size>
  802ed5:	83 c4 04             	add    $0x4,%esp
  802ed8:	89 c2                	mov    %eax,%edx
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	01 d0                	add    %edx,%eax
  802edf:	3b 45 10             	cmp    0x10(%ebp),%eax
  802ee2:	75 07                	jne    802eeb <merging+0x39>
		prev_is_free = 1;
  802ee4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802eeb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eef:	74 1e                	je     802f0f <merging+0x5d>
  802ef1:	ff 75 10             	pushl  0x10(%ebp)
  802ef4:	e8 98 f1 ff ff       	call   802091 <get_block_size>
  802ef9:	83 c4 04             	add    $0x4,%esp
  802efc:	89 c2                	mov    %eax,%edx
  802efe:	8b 45 10             	mov    0x10(%ebp),%eax
  802f01:	01 d0                	add    %edx,%eax
  802f03:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f06:	75 07                	jne    802f0f <merging+0x5d>
		next_is_free = 1;
  802f08:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f13:	0f 84 cc 00 00 00    	je     802fe5 <merging+0x133>
  802f19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f1d:	0f 84 c2 00 00 00    	je     802fe5 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f23:	ff 75 08             	pushl  0x8(%ebp)
  802f26:	e8 66 f1 ff ff       	call   802091 <get_block_size>
  802f2b:	83 c4 04             	add    $0x4,%esp
  802f2e:	89 c3                	mov    %eax,%ebx
  802f30:	ff 75 10             	pushl  0x10(%ebp)
  802f33:	e8 59 f1 ff ff       	call   802091 <get_block_size>
  802f38:	83 c4 04             	add    $0x4,%esp
  802f3b:	01 c3                	add    %eax,%ebx
  802f3d:	ff 75 0c             	pushl  0xc(%ebp)
  802f40:	e8 4c f1 ff ff       	call   802091 <get_block_size>
  802f45:	83 c4 04             	add    $0x4,%esp
  802f48:	01 d8                	add    %ebx,%eax
  802f4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f4d:	6a 00                	push   $0x0
  802f4f:	ff 75 ec             	pushl  -0x14(%ebp)
  802f52:	ff 75 08             	pushl  0x8(%ebp)
  802f55:	e8 88 f4 ff ff       	call   8023e2 <set_block_data>
  802f5a:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f61:	75 17                	jne    802f7a <merging+0xc8>
  802f63:	83 ec 04             	sub    $0x4,%esp
  802f66:	68 ff 45 80 00       	push   $0x8045ff
  802f6b:	68 7d 01 00 00       	push   $0x17d
  802f70:	68 1d 46 80 00       	push   $0x80461d
  802f75:	e8 77 d4 ff ff       	call   8003f1 <_panic>
  802f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7d:	8b 00                	mov    (%eax),%eax
  802f7f:	85 c0                	test   %eax,%eax
  802f81:	74 10                	je     802f93 <merging+0xe1>
  802f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f86:	8b 00                	mov    (%eax),%eax
  802f88:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f8b:	8b 52 04             	mov    0x4(%edx),%edx
  802f8e:	89 50 04             	mov    %edx,0x4(%eax)
  802f91:	eb 0b                	jmp    802f9e <merging+0xec>
  802f93:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f96:	8b 40 04             	mov    0x4(%eax),%eax
  802f99:	a3 34 50 80 00       	mov    %eax,0x805034
  802f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa1:	8b 40 04             	mov    0x4(%eax),%eax
  802fa4:	85 c0                	test   %eax,%eax
  802fa6:	74 0f                	je     802fb7 <merging+0x105>
  802fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fab:	8b 40 04             	mov    0x4(%eax),%eax
  802fae:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb1:	8b 12                	mov    (%edx),%edx
  802fb3:	89 10                	mov    %edx,(%eax)
  802fb5:	eb 0a                	jmp    802fc1 <merging+0x10f>
  802fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fba:	8b 00                	mov    (%eax),%eax
  802fbc:	a3 30 50 80 00       	mov    %eax,0x805030
  802fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fcd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802fd9:	48                   	dec    %eax
  802fda:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802fdf:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fe0:	e9 ea 02 00 00       	jmp    8032cf <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802fe5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe9:	74 3b                	je     803026 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802feb:	83 ec 0c             	sub    $0xc,%esp
  802fee:	ff 75 08             	pushl  0x8(%ebp)
  802ff1:	e8 9b f0 ff ff       	call   802091 <get_block_size>
  802ff6:	83 c4 10             	add    $0x10,%esp
  802ff9:	89 c3                	mov    %eax,%ebx
  802ffb:	83 ec 0c             	sub    $0xc,%esp
  802ffe:	ff 75 10             	pushl  0x10(%ebp)
  803001:	e8 8b f0 ff ff       	call   802091 <get_block_size>
  803006:	83 c4 10             	add    $0x10,%esp
  803009:	01 d8                	add    %ebx,%eax
  80300b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80300e:	83 ec 04             	sub    $0x4,%esp
  803011:	6a 00                	push   $0x0
  803013:	ff 75 e8             	pushl  -0x18(%ebp)
  803016:	ff 75 08             	pushl  0x8(%ebp)
  803019:	e8 c4 f3 ff ff       	call   8023e2 <set_block_data>
  80301e:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803021:	e9 a9 02 00 00       	jmp    8032cf <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803026:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80302a:	0f 84 2d 01 00 00    	je     80315d <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803030:	83 ec 0c             	sub    $0xc,%esp
  803033:	ff 75 10             	pushl  0x10(%ebp)
  803036:	e8 56 f0 ff ff       	call   802091 <get_block_size>
  80303b:	83 c4 10             	add    $0x10,%esp
  80303e:	89 c3                	mov    %eax,%ebx
  803040:	83 ec 0c             	sub    $0xc,%esp
  803043:	ff 75 0c             	pushl  0xc(%ebp)
  803046:	e8 46 f0 ff ff       	call   802091 <get_block_size>
  80304b:	83 c4 10             	add    $0x10,%esp
  80304e:	01 d8                	add    %ebx,%eax
  803050:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803053:	83 ec 04             	sub    $0x4,%esp
  803056:	6a 00                	push   $0x0
  803058:	ff 75 e4             	pushl  -0x1c(%ebp)
  80305b:	ff 75 10             	pushl  0x10(%ebp)
  80305e:	e8 7f f3 ff ff       	call   8023e2 <set_block_data>
  803063:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803066:	8b 45 10             	mov    0x10(%ebp),%eax
  803069:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80306c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803070:	74 06                	je     803078 <merging+0x1c6>
  803072:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803076:	75 17                	jne    80308f <merging+0x1dd>
  803078:	83 ec 04             	sub    $0x4,%esp
  80307b:	68 d8 46 80 00       	push   $0x8046d8
  803080:	68 8d 01 00 00       	push   $0x18d
  803085:	68 1d 46 80 00       	push   $0x80461d
  80308a:	e8 62 d3 ff ff       	call   8003f1 <_panic>
  80308f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803092:	8b 50 04             	mov    0x4(%eax),%edx
  803095:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803098:	89 50 04             	mov    %edx,0x4(%eax)
  80309b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80309e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030a1:	89 10                	mov    %edx,(%eax)
  8030a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a6:	8b 40 04             	mov    0x4(%eax),%eax
  8030a9:	85 c0                	test   %eax,%eax
  8030ab:	74 0d                	je     8030ba <merging+0x208>
  8030ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b0:	8b 40 04             	mov    0x4(%eax),%eax
  8030b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030b6:	89 10                	mov    %edx,(%eax)
  8030b8:	eb 08                	jmp    8030c2 <merging+0x210>
  8030ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8030c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030c8:	89 50 04             	mov    %edx,0x4(%eax)
  8030cb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030d0:	40                   	inc    %eax
  8030d1:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  8030d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030da:	75 17                	jne    8030f3 <merging+0x241>
  8030dc:	83 ec 04             	sub    $0x4,%esp
  8030df:	68 ff 45 80 00       	push   $0x8045ff
  8030e4:	68 8e 01 00 00       	push   $0x18e
  8030e9:	68 1d 46 80 00       	push   $0x80461d
  8030ee:	e8 fe d2 ff ff       	call   8003f1 <_panic>
  8030f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f6:	8b 00                	mov    (%eax),%eax
  8030f8:	85 c0                	test   %eax,%eax
  8030fa:	74 10                	je     80310c <merging+0x25a>
  8030fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ff:	8b 00                	mov    (%eax),%eax
  803101:	8b 55 0c             	mov    0xc(%ebp),%edx
  803104:	8b 52 04             	mov    0x4(%edx),%edx
  803107:	89 50 04             	mov    %edx,0x4(%eax)
  80310a:	eb 0b                	jmp    803117 <merging+0x265>
  80310c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310f:	8b 40 04             	mov    0x4(%eax),%eax
  803112:	a3 34 50 80 00       	mov    %eax,0x805034
  803117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311a:	8b 40 04             	mov    0x4(%eax),%eax
  80311d:	85 c0                	test   %eax,%eax
  80311f:	74 0f                	je     803130 <merging+0x27e>
  803121:	8b 45 0c             	mov    0xc(%ebp),%eax
  803124:	8b 40 04             	mov    0x4(%eax),%eax
  803127:	8b 55 0c             	mov    0xc(%ebp),%edx
  80312a:	8b 12                	mov    (%edx),%edx
  80312c:	89 10                	mov    %edx,(%eax)
  80312e:	eb 0a                	jmp    80313a <merging+0x288>
  803130:	8b 45 0c             	mov    0xc(%ebp),%eax
  803133:	8b 00                	mov    (%eax),%eax
  803135:	a3 30 50 80 00       	mov    %eax,0x805030
  80313a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803143:	8b 45 0c             	mov    0xc(%ebp),%eax
  803146:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803152:	48                   	dec    %eax
  803153:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803158:	e9 72 01 00 00       	jmp    8032cf <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80315d:	8b 45 10             	mov    0x10(%ebp),%eax
  803160:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803163:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803167:	74 79                	je     8031e2 <merging+0x330>
  803169:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80316d:	74 73                	je     8031e2 <merging+0x330>
  80316f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803173:	74 06                	je     80317b <merging+0x2c9>
  803175:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803179:	75 17                	jne    803192 <merging+0x2e0>
  80317b:	83 ec 04             	sub    $0x4,%esp
  80317e:	68 90 46 80 00       	push   $0x804690
  803183:	68 94 01 00 00       	push   $0x194
  803188:	68 1d 46 80 00       	push   $0x80461d
  80318d:	e8 5f d2 ff ff       	call   8003f1 <_panic>
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	8b 10                	mov    (%eax),%edx
  803197:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80319a:	89 10                	mov    %edx,(%eax)
  80319c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80319f:	8b 00                	mov    (%eax),%eax
  8031a1:	85 c0                	test   %eax,%eax
  8031a3:	74 0b                	je     8031b0 <merging+0x2fe>
  8031a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a8:	8b 00                	mov    (%eax),%eax
  8031aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031ad:	89 50 04             	mov    %edx,0x4(%eax)
  8031b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031b6:	89 10                	mov    %edx,(%eax)
  8031b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8031be:	89 50 04             	mov    %edx,0x4(%eax)
  8031c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c4:	8b 00                	mov    (%eax),%eax
  8031c6:	85 c0                	test   %eax,%eax
  8031c8:	75 08                	jne    8031d2 <merging+0x320>
  8031ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031cd:	a3 34 50 80 00       	mov    %eax,0x805034
  8031d2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031d7:	40                   	inc    %eax
  8031d8:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8031dd:	e9 ce 00 00 00       	jmp    8032b0 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8031e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e6:	74 65                	je     80324d <merging+0x39b>
  8031e8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031ec:	75 17                	jne    803205 <merging+0x353>
  8031ee:	83 ec 04             	sub    $0x4,%esp
  8031f1:	68 6c 46 80 00       	push   $0x80466c
  8031f6:	68 95 01 00 00       	push   $0x195
  8031fb:	68 1d 46 80 00       	push   $0x80461d
  803200:	e8 ec d1 ff ff       	call   8003f1 <_panic>
  803205:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80320b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80320e:	89 50 04             	mov    %edx,0x4(%eax)
  803211:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803214:	8b 40 04             	mov    0x4(%eax),%eax
  803217:	85 c0                	test   %eax,%eax
  803219:	74 0c                	je     803227 <merging+0x375>
  80321b:	a1 34 50 80 00       	mov    0x805034,%eax
  803220:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803223:	89 10                	mov    %edx,(%eax)
  803225:	eb 08                	jmp    80322f <merging+0x37d>
  803227:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80322a:	a3 30 50 80 00       	mov    %eax,0x805030
  80322f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803232:	a3 34 50 80 00       	mov    %eax,0x805034
  803237:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80323a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803240:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803245:	40                   	inc    %eax
  803246:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80324b:	eb 63                	jmp    8032b0 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80324d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803251:	75 17                	jne    80326a <merging+0x3b8>
  803253:	83 ec 04             	sub    $0x4,%esp
  803256:	68 38 46 80 00       	push   $0x804638
  80325b:	68 98 01 00 00       	push   $0x198
  803260:	68 1d 46 80 00       	push   $0x80461d
  803265:	e8 87 d1 ff ff       	call   8003f1 <_panic>
  80326a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803270:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803273:	89 10                	mov    %edx,(%eax)
  803275:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803278:	8b 00                	mov    (%eax),%eax
  80327a:	85 c0                	test   %eax,%eax
  80327c:	74 0d                	je     80328b <merging+0x3d9>
  80327e:	a1 30 50 80 00       	mov    0x805030,%eax
  803283:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803286:	89 50 04             	mov    %edx,0x4(%eax)
  803289:	eb 08                	jmp    803293 <merging+0x3e1>
  80328b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80328e:	a3 34 50 80 00       	mov    %eax,0x805034
  803293:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803296:	a3 30 50 80 00       	mov    %eax,0x805030
  80329b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80329e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032aa:	40                   	inc    %eax
  8032ab:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  8032b0:	83 ec 0c             	sub    $0xc,%esp
  8032b3:	ff 75 10             	pushl  0x10(%ebp)
  8032b6:	e8 d6 ed ff ff       	call   802091 <get_block_size>
  8032bb:	83 c4 10             	add    $0x10,%esp
  8032be:	83 ec 04             	sub    $0x4,%esp
  8032c1:	6a 00                	push   $0x0
  8032c3:	50                   	push   %eax
  8032c4:	ff 75 10             	pushl  0x10(%ebp)
  8032c7:	e8 16 f1 ff ff       	call   8023e2 <set_block_data>
  8032cc:	83 c4 10             	add    $0x10,%esp
	}
}
  8032cf:	90                   	nop
  8032d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032d3:	c9                   	leave  
  8032d4:	c3                   	ret    

008032d5 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8032d5:	55                   	push   %ebp
  8032d6:	89 e5                	mov    %esp,%ebp
  8032d8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8032db:	a1 30 50 80 00       	mov    0x805030,%eax
  8032e0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8032e3:	a1 34 50 80 00       	mov    0x805034,%eax
  8032e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032eb:	73 1b                	jae    803308 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8032ed:	a1 34 50 80 00       	mov    0x805034,%eax
  8032f2:	83 ec 04             	sub    $0x4,%esp
  8032f5:	ff 75 08             	pushl  0x8(%ebp)
  8032f8:	6a 00                	push   $0x0
  8032fa:	50                   	push   %eax
  8032fb:	e8 b2 fb ff ff       	call   802eb2 <merging>
  803300:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803303:	e9 8b 00 00 00       	jmp    803393 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803308:	a1 30 50 80 00       	mov    0x805030,%eax
  80330d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803310:	76 18                	jbe    80332a <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803312:	a1 30 50 80 00       	mov    0x805030,%eax
  803317:	83 ec 04             	sub    $0x4,%esp
  80331a:	ff 75 08             	pushl  0x8(%ebp)
  80331d:	50                   	push   %eax
  80331e:	6a 00                	push   $0x0
  803320:	e8 8d fb ff ff       	call   802eb2 <merging>
  803325:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803328:	eb 69                	jmp    803393 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80332a:	a1 30 50 80 00       	mov    0x805030,%eax
  80332f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803332:	eb 39                	jmp    80336d <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803337:	3b 45 08             	cmp    0x8(%ebp),%eax
  80333a:	73 29                	jae    803365 <free_block+0x90>
  80333c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333f:	8b 00                	mov    (%eax),%eax
  803341:	3b 45 08             	cmp    0x8(%ebp),%eax
  803344:	76 1f                	jbe    803365 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803349:	8b 00                	mov    (%eax),%eax
  80334b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80334e:	83 ec 04             	sub    $0x4,%esp
  803351:	ff 75 08             	pushl  0x8(%ebp)
  803354:	ff 75 f0             	pushl  -0x10(%ebp)
  803357:	ff 75 f4             	pushl  -0xc(%ebp)
  80335a:	e8 53 fb ff ff       	call   802eb2 <merging>
  80335f:	83 c4 10             	add    $0x10,%esp
			break;
  803362:	90                   	nop
		}
	}
}
  803363:	eb 2e                	jmp    803393 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803365:	a1 38 50 80 00       	mov    0x805038,%eax
  80336a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80336d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803371:	74 07                	je     80337a <free_block+0xa5>
  803373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803376:	8b 00                	mov    (%eax),%eax
  803378:	eb 05                	jmp    80337f <free_block+0xaa>
  80337a:	b8 00 00 00 00       	mov    $0x0,%eax
  80337f:	a3 38 50 80 00       	mov    %eax,0x805038
  803384:	a1 38 50 80 00       	mov    0x805038,%eax
  803389:	85 c0                	test   %eax,%eax
  80338b:	75 a7                	jne    803334 <free_block+0x5f>
  80338d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803391:	75 a1                	jne    803334 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803393:	90                   	nop
  803394:	c9                   	leave  
  803395:	c3                   	ret    

00803396 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803396:	55                   	push   %ebp
  803397:	89 e5                	mov    %esp,%ebp
  803399:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80339c:	ff 75 08             	pushl  0x8(%ebp)
  80339f:	e8 ed ec ff ff       	call   802091 <get_block_size>
  8033a4:	83 c4 04             	add    $0x4,%esp
  8033a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8033aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8033b1:	eb 17                	jmp    8033ca <copy_data+0x34>
  8033b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8033b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b9:	01 c2                	add    %eax,%edx
  8033bb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8033be:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c1:	01 c8                	add    %ecx,%eax
  8033c3:	8a 00                	mov    (%eax),%al
  8033c5:	88 02                	mov    %al,(%edx)
  8033c7:	ff 45 fc             	incl   -0x4(%ebp)
  8033ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8033d0:	72 e1                	jb     8033b3 <copy_data+0x1d>
}
  8033d2:	90                   	nop
  8033d3:	c9                   	leave  
  8033d4:	c3                   	ret    

008033d5 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8033d5:	55                   	push   %ebp
  8033d6:	89 e5                	mov    %esp,%ebp
  8033d8:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8033db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033df:	75 23                	jne    803404 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8033e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033e5:	74 13                	je     8033fa <realloc_block_FF+0x25>
  8033e7:	83 ec 0c             	sub    $0xc,%esp
  8033ea:	ff 75 0c             	pushl  0xc(%ebp)
  8033ed:	e8 1f f0 ff ff       	call   802411 <alloc_block_FF>
  8033f2:	83 c4 10             	add    $0x10,%esp
  8033f5:	e9 f4 06 00 00       	jmp    803aee <realloc_block_FF+0x719>
		return NULL;
  8033fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ff:	e9 ea 06 00 00       	jmp    803aee <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803404:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803408:	75 18                	jne    803422 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80340a:	83 ec 0c             	sub    $0xc,%esp
  80340d:	ff 75 08             	pushl  0x8(%ebp)
  803410:	e8 c0 fe ff ff       	call   8032d5 <free_block>
  803415:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803418:	b8 00 00 00 00       	mov    $0x0,%eax
  80341d:	e9 cc 06 00 00       	jmp    803aee <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803422:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803426:	77 07                	ja     80342f <realloc_block_FF+0x5a>
  803428:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80342f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803432:	83 e0 01             	and    $0x1,%eax
  803435:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803438:	8b 45 0c             	mov    0xc(%ebp),%eax
  80343b:	83 c0 08             	add    $0x8,%eax
  80343e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803441:	83 ec 0c             	sub    $0xc,%esp
  803444:	ff 75 08             	pushl  0x8(%ebp)
  803447:	e8 45 ec ff ff       	call   802091 <get_block_size>
  80344c:	83 c4 10             	add    $0x10,%esp
  80344f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803452:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803455:	83 e8 08             	sub    $0x8,%eax
  803458:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80345b:	8b 45 08             	mov    0x8(%ebp),%eax
  80345e:	83 e8 04             	sub    $0x4,%eax
  803461:	8b 00                	mov    (%eax),%eax
  803463:	83 e0 fe             	and    $0xfffffffe,%eax
  803466:	89 c2                	mov    %eax,%edx
  803468:	8b 45 08             	mov    0x8(%ebp),%eax
  80346b:	01 d0                	add    %edx,%eax
  80346d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803470:	83 ec 0c             	sub    $0xc,%esp
  803473:	ff 75 e4             	pushl  -0x1c(%ebp)
  803476:	e8 16 ec ff ff       	call   802091 <get_block_size>
  80347b:	83 c4 10             	add    $0x10,%esp
  80347e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803481:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803484:	83 e8 08             	sub    $0x8,%eax
  803487:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80348a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803490:	75 08                	jne    80349a <realloc_block_FF+0xc5>
	{
		 return va;
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	e9 54 06 00 00       	jmp    803aee <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80349a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034a0:	0f 83 e5 03 00 00    	jae    80388b <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8034a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a9:	2b 45 0c             	sub    0xc(%ebp),%eax
  8034ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8034af:	83 ec 0c             	sub    $0xc,%esp
  8034b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034b5:	e8 f0 eb ff ff       	call   8020aa <is_free_block>
  8034ba:	83 c4 10             	add    $0x10,%esp
  8034bd:	84 c0                	test   %al,%al
  8034bf:	0f 84 3b 01 00 00    	je     803600 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8034c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034cb:	01 d0                	add    %edx,%eax
  8034cd:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8034d0:	83 ec 04             	sub    $0x4,%esp
  8034d3:	6a 01                	push   $0x1
  8034d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8034d8:	ff 75 08             	pushl  0x8(%ebp)
  8034db:	e8 02 ef ff ff       	call   8023e2 <set_block_data>
  8034e0:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8034e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e6:	83 e8 04             	sub    $0x4,%eax
  8034e9:	8b 00                	mov    (%eax),%eax
  8034eb:	83 e0 fe             	and    $0xfffffffe,%eax
  8034ee:	89 c2                	mov    %eax,%edx
  8034f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f3:	01 d0                	add    %edx,%eax
  8034f5:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8034f8:	83 ec 04             	sub    $0x4,%esp
  8034fb:	6a 00                	push   $0x0
  8034fd:	ff 75 cc             	pushl  -0x34(%ebp)
  803500:	ff 75 c8             	pushl  -0x38(%ebp)
  803503:	e8 da ee ff ff       	call   8023e2 <set_block_data>
  803508:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80350b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80350f:	74 06                	je     803517 <realloc_block_FF+0x142>
  803511:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803515:	75 17                	jne    80352e <realloc_block_FF+0x159>
  803517:	83 ec 04             	sub    $0x4,%esp
  80351a:	68 90 46 80 00       	push   $0x804690
  80351f:	68 f6 01 00 00       	push   $0x1f6
  803524:	68 1d 46 80 00       	push   $0x80461d
  803529:	e8 c3 ce ff ff       	call   8003f1 <_panic>
  80352e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803531:	8b 10                	mov    (%eax),%edx
  803533:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803536:	89 10                	mov    %edx,(%eax)
  803538:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80353b:	8b 00                	mov    (%eax),%eax
  80353d:	85 c0                	test   %eax,%eax
  80353f:	74 0b                	je     80354c <realloc_block_FF+0x177>
  803541:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803544:	8b 00                	mov    (%eax),%eax
  803546:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803549:	89 50 04             	mov    %edx,0x4(%eax)
  80354c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80354f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803552:	89 10                	mov    %edx,(%eax)
  803554:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803557:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80355a:	89 50 04             	mov    %edx,0x4(%eax)
  80355d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803560:	8b 00                	mov    (%eax),%eax
  803562:	85 c0                	test   %eax,%eax
  803564:	75 08                	jne    80356e <realloc_block_FF+0x199>
  803566:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803569:	a3 34 50 80 00       	mov    %eax,0x805034
  80356e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803573:	40                   	inc    %eax
  803574:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803579:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80357d:	75 17                	jne    803596 <realloc_block_FF+0x1c1>
  80357f:	83 ec 04             	sub    $0x4,%esp
  803582:	68 ff 45 80 00       	push   $0x8045ff
  803587:	68 f7 01 00 00       	push   $0x1f7
  80358c:	68 1d 46 80 00       	push   $0x80461d
  803591:	e8 5b ce ff ff       	call   8003f1 <_panic>
  803596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803599:	8b 00                	mov    (%eax),%eax
  80359b:	85 c0                	test   %eax,%eax
  80359d:	74 10                	je     8035af <realloc_block_FF+0x1da>
  80359f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a2:	8b 00                	mov    (%eax),%eax
  8035a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035a7:	8b 52 04             	mov    0x4(%edx),%edx
  8035aa:	89 50 04             	mov    %edx,0x4(%eax)
  8035ad:	eb 0b                	jmp    8035ba <realloc_block_FF+0x1e5>
  8035af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b2:	8b 40 04             	mov    0x4(%eax),%eax
  8035b5:	a3 34 50 80 00       	mov    %eax,0x805034
  8035ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035bd:	8b 40 04             	mov    0x4(%eax),%eax
  8035c0:	85 c0                	test   %eax,%eax
  8035c2:	74 0f                	je     8035d3 <realloc_block_FF+0x1fe>
  8035c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c7:	8b 40 04             	mov    0x4(%eax),%eax
  8035ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035cd:	8b 12                	mov    (%edx),%edx
  8035cf:	89 10                	mov    %edx,(%eax)
  8035d1:	eb 0a                	jmp    8035dd <realloc_block_FF+0x208>
  8035d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d6:	8b 00                	mov    (%eax),%eax
  8035d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8035dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035f5:	48                   	dec    %eax
  8035f6:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035fb:	e9 83 02 00 00       	jmp    803883 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803600:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803604:	0f 86 69 02 00 00    	jbe    803873 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80360a:	83 ec 04             	sub    $0x4,%esp
  80360d:	6a 01                	push   $0x1
  80360f:	ff 75 f0             	pushl  -0x10(%ebp)
  803612:	ff 75 08             	pushl  0x8(%ebp)
  803615:	e8 c8 ed ff ff       	call   8023e2 <set_block_data>
  80361a:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80361d:	8b 45 08             	mov    0x8(%ebp),%eax
  803620:	83 e8 04             	sub    $0x4,%eax
  803623:	8b 00                	mov    (%eax),%eax
  803625:	83 e0 fe             	and    $0xfffffffe,%eax
  803628:	89 c2                	mov    %eax,%edx
  80362a:	8b 45 08             	mov    0x8(%ebp),%eax
  80362d:	01 d0                	add    %edx,%eax
  80362f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803632:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803637:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80363a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80363e:	75 68                	jne    8036a8 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803640:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803644:	75 17                	jne    80365d <realloc_block_FF+0x288>
  803646:	83 ec 04             	sub    $0x4,%esp
  803649:	68 38 46 80 00       	push   $0x804638
  80364e:	68 06 02 00 00       	push   $0x206
  803653:	68 1d 46 80 00       	push   $0x80461d
  803658:	e8 94 cd ff ff       	call   8003f1 <_panic>
  80365d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803663:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803666:	89 10                	mov    %edx,(%eax)
  803668:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80366b:	8b 00                	mov    (%eax),%eax
  80366d:	85 c0                	test   %eax,%eax
  80366f:	74 0d                	je     80367e <realloc_block_FF+0x2a9>
  803671:	a1 30 50 80 00       	mov    0x805030,%eax
  803676:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803679:	89 50 04             	mov    %edx,0x4(%eax)
  80367c:	eb 08                	jmp    803686 <realloc_block_FF+0x2b1>
  80367e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803681:	a3 34 50 80 00       	mov    %eax,0x805034
  803686:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803689:	a3 30 50 80 00       	mov    %eax,0x805030
  80368e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803691:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803698:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80369d:	40                   	inc    %eax
  80369e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036a3:	e9 b0 01 00 00       	jmp    803858 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8036a8:	a1 30 50 80 00       	mov    0x805030,%eax
  8036ad:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036b0:	76 68                	jbe    80371a <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036b2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036b6:	75 17                	jne    8036cf <realloc_block_FF+0x2fa>
  8036b8:	83 ec 04             	sub    $0x4,%esp
  8036bb:	68 38 46 80 00       	push   $0x804638
  8036c0:	68 0b 02 00 00       	push   $0x20b
  8036c5:	68 1d 46 80 00       	push   $0x80461d
  8036ca:	e8 22 cd ff ff       	call   8003f1 <_panic>
  8036cf:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036d8:	89 10                	mov    %edx,(%eax)
  8036da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036dd:	8b 00                	mov    (%eax),%eax
  8036df:	85 c0                	test   %eax,%eax
  8036e1:	74 0d                	je     8036f0 <realloc_block_FF+0x31b>
  8036e3:	a1 30 50 80 00       	mov    0x805030,%eax
  8036e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036eb:	89 50 04             	mov    %edx,0x4(%eax)
  8036ee:	eb 08                	jmp    8036f8 <realloc_block_FF+0x323>
  8036f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f3:	a3 34 50 80 00       	mov    %eax,0x805034
  8036f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036fb:	a3 30 50 80 00       	mov    %eax,0x805030
  803700:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803703:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80370a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80370f:	40                   	inc    %eax
  803710:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803715:	e9 3e 01 00 00       	jmp    803858 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80371a:	a1 30 50 80 00       	mov    0x805030,%eax
  80371f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803722:	73 68                	jae    80378c <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803724:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803728:	75 17                	jne    803741 <realloc_block_FF+0x36c>
  80372a:	83 ec 04             	sub    $0x4,%esp
  80372d:	68 6c 46 80 00       	push   $0x80466c
  803732:	68 10 02 00 00       	push   $0x210
  803737:	68 1d 46 80 00       	push   $0x80461d
  80373c:	e8 b0 cc ff ff       	call   8003f1 <_panic>
  803741:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803747:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80374a:	89 50 04             	mov    %edx,0x4(%eax)
  80374d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803750:	8b 40 04             	mov    0x4(%eax),%eax
  803753:	85 c0                	test   %eax,%eax
  803755:	74 0c                	je     803763 <realloc_block_FF+0x38e>
  803757:	a1 34 50 80 00       	mov    0x805034,%eax
  80375c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80375f:	89 10                	mov    %edx,(%eax)
  803761:	eb 08                	jmp    80376b <realloc_block_FF+0x396>
  803763:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803766:	a3 30 50 80 00       	mov    %eax,0x805030
  80376b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80376e:	a3 34 50 80 00       	mov    %eax,0x805034
  803773:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803776:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80377c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803781:	40                   	inc    %eax
  803782:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803787:	e9 cc 00 00 00       	jmp    803858 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80378c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803793:	a1 30 50 80 00       	mov    0x805030,%eax
  803798:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80379b:	e9 8a 00 00 00       	jmp    80382a <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8037a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037a6:	73 7a                	jae    803822 <realloc_block_FF+0x44d>
  8037a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ab:	8b 00                	mov    (%eax),%eax
  8037ad:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037b0:	73 70                	jae    803822 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8037b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b6:	74 06                	je     8037be <realloc_block_FF+0x3e9>
  8037b8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037bc:	75 17                	jne    8037d5 <realloc_block_FF+0x400>
  8037be:	83 ec 04             	sub    $0x4,%esp
  8037c1:	68 90 46 80 00       	push   $0x804690
  8037c6:	68 1a 02 00 00       	push   $0x21a
  8037cb:	68 1d 46 80 00       	push   $0x80461d
  8037d0:	e8 1c cc ff ff       	call   8003f1 <_panic>
  8037d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d8:	8b 10                	mov    (%eax),%edx
  8037da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037dd:	89 10                	mov    %edx,(%eax)
  8037df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e2:	8b 00                	mov    (%eax),%eax
  8037e4:	85 c0                	test   %eax,%eax
  8037e6:	74 0b                	je     8037f3 <realloc_block_FF+0x41e>
  8037e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037eb:	8b 00                	mov    (%eax),%eax
  8037ed:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037f0:	89 50 04             	mov    %edx,0x4(%eax)
  8037f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037f9:	89 10                	mov    %edx,(%eax)
  8037fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803801:	89 50 04             	mov    %edx,0x4(%eax)
  803804:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803807:	8b 00                	mov    (%eax),%eax
  803809:	85 c0                	test   %eax,%eax
  80380b:	75 08                	jne    803815 <realloc_block_FF+0x440>
  80380d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803810:	a3 34 50 80 00       	mov    %eax,0x805034
  803815:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80381a:	40                   	inc    %eax
  80381b:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803820:	eb 36                	jmp    803858 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803822:	a1 38 50 80 00       	mov    0x805038,%eax
  803827:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80382a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80382e:	74 07                	je     803837 <realloc_block_FF+0x462>
  803830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803833:	8b 00                	mov    (%eax),%eax
  803835:	eb 05                	jmp    80383c <realloc_block_FF+0x467>
  803837:	b8 00 00 00 00       	mov    $0x0,%eax
  80383c:	a3 38 50 80 00       	mov    %eax,0x805038
  803841:	a1 38 50 80 00       	mov    0x805038,%eax
  803846:	85 c0                	test   %eax,%eax
  803848:	0f 85 52 ff ff ff    	jne    8037a0 <realloc_block_FF+0x3cb>
  80384e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803852:	0f 85 48 ff ff ff    	jne    8037a0 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803858:	83 ec 04             	sub    $0x4,%esp
  80385b:	6a 00                	push   $0x0
  80385d:	ff 75 d8             	pushl  -0x28(%ebp)
  803860:	ff 75 d4             	pushl  -0x2c(%ebp)
  803863:	e8 7a eb ff ff       	call   8023e2 <set_block_data>
  803868:	83 c4 10             	add    $0x10,%esp
				return va;
  80386b:	8b 45 08             	mov    0x8(%ebp),%eax
  80386e:	e9 7b 02 00 00       	jmp    803aee <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803873:	83 ec 0c             	sub    $0xc,%esp
  803876:	68 0d 47 80 00       	push   $0x80470d
  80387b:	e8 2e ce ff ff       	call   8006ae <cprintf>
  803880:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803883:	8b 45 08             	mov    0x8(%ebp),%eax
  803886:	e9 63 02 00 00       	jmp    803aee <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80388b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80388e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803891:	0f 86 4d 02 00 00    	jbe    803ae4 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803897:	83 ec 0c             	sub    $0xc,%esp
  80389a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80389d:	e8 08 e8 ff ff       	call   8020aa <is_free_block>
  8038a2:	83 c4 10             	add    $0x10,%esp
  8038a5:	84 c0                	test   %al,%al
  8038a7:	0f 84 37 02 00 00    	je     803ae4 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8038ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038b0:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8038b3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8038b6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038b9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8038bc:	76 38                	jbe    8038f6 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8038be:	83 ec 0c             	sub    $0xc,%esp
  8038c1:	ff 75 08             	pushl  0x8(%ebp)
  8038c4:	e8 0c fa ff ff       	call   8032d5 <free_block>
  8038c9:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8038cc:	83 ec 0c             	sub    $0xc,%esp
  8038cf:	ff 75 0c             	pushl  0xc(%ebp)
  8038d2:	e8 3a eb ff ff       	call   802411 <alloc_block_FF>
  8038d7:	83 c4 10             	add    $0x10,%esp
  8038da:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8038dd:	83 ec 08             	sub    $0x8,%esp
  8038e0:	ff 75 c0             	pushl  -0x40(%ebp)
  8038e3:	ff 75 08             	pushl  0x8(%ebp)
  8038e6:	e8 ab fa ff ff       	call   803396 <copy_data>
  8038eb:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8038ee:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8038f1:	e9 f8 01 00 00       	jmp    803aee <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8038f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038f9:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8038fc:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8038ff:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803903:	0f 87 a0 00 00 00    	ja     8039a9 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803909:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80390d:	75 17                	jne    803926 <realloc_block_FF+0x551>
  80390f:	83 ec 04             	sub    $0x4,%esp
  803912:	68 ff 45 80 00       	push   $0x8045ff
  803917:	68 38 02 00 00       	push   $0x238
  80391c:	68 1d 46 80 00       	push   $0x80461d
  803921:	e8 cb ca ff ff       	call   8003f1 <_panic>
  803926:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803929:	8b 00                	mov    (%eax),%eax
  80392b:	85 c0                	test   %eax,%eax
  80392d:	74 10                	je     80393f <realloc_block_FF+0x56a>
  80392f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803932:	8b 00                	mov    (%eax),%eax
  803934:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803937:	8b 52 04             	mov    0x4(%edx),%edx
  80393a:	89 50 04             	mov    %edx,0x4(%eax)
  80393d:	eb 0b                	jmp    80394a <realloc_block_FF+0x575>
  80393f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803942:	8b 40 04             	mov    0x4(%eax),%eax
  803945:	a3 34 50 80 00       	mov    %eax,0x805034
  80394a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394d:	8b 40 04             	mov    0x4(%eax),%eax
  803950:	85 c0                	test   %eax,%eax
  803952:	74 0f                	je     803963 <realloc_block_FF+0x58e>
  803954:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803957:	8b 40 04             	mov    0x4(%eax),%eax
  80395a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80395d:	8b 12                	mov    (%edx),%edx
  80395f:	89 10                	mov    %edx,(%eax)
  803961:	eb 0a                	jmp    80396d <realloc_block_FF+0x598>
  803963:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803966:	8b 00                	mov    (%eax),%eax
  803968:	a3 30 50 80 00       	mov    %eax,0x805030
  80396d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803970:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803976:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803979:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803980:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803985:	48                   	dec    %eax
  803986:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80398b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80398e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803991:	01 d0                	add    %edx,%eax
  803993:	83 ec 04             	sub    $0x4,%esp
  803996:	6a 01                	push   $0x1
  803998:	50                   	push   %eax
  803999:	ff 75 08             	pushl  0x8(%ebp)
  80399c:	e8 41 ea ff ff       	call   8023e2 <set_block_data>
  8039a1:	83 c4 10             	add    $0x10,%esp
  8039a4:	e9 36 01 00 00       	jmp    803adf <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8039a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039ac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039af:	01 d0                	add    %edx,%eax
  8039b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8039b4:	83 ec 04             	sub    $0x4,%esp
  8039b7:	6a 01                	push   $0x1
  8039b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8039bc:	ff 75 08             	pushl  0x8(%ebp)
  8039bf:	e8 1e ea ff ff       	call   8023e2 <set_block_data>
  8039c4:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8039c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ca:	83 e8 04             	sub    $0x4,%eax
  8039cd:	8b 00                	mov    (%eax),%eax
  8039cf:	83 e0 fe             	and    $0xfffffffe,%eax
  8039d2:	89 c2                	mov    %eax,%edx
  8039d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d7:	01 d0                	add    %edx,%eax
  8039d9:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8039dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039e0:	74 06                	je     8039e8 <realloc_block_FF+0x613>
  8039e2:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8039e6:	75 17                	jne    8039ff <realloc_block_FF+0x62a>
  8039e8:	83 ec 04             	sub    $0x4,%esp
  8039eb:	68 90 46 80 00       	push   $0x804690
  8039f0:	68 44 02 00 00       	push   $0x244
  8039f5:	68 1d 46 80 00       	push   $0x80461d
  8039fa:	e8 f2 c9 ff ff       	call   8003f1 <_panic>
  8039ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a02:	8b 10                	mov    (%eax),%edx
  803a04:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a07:	89 10                	mov    %edx,(%eax)
  803a09:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a0c:	8b 00                	mov    (%eax),%eax
  803a0e:	85 c0                	test   %eax,%eax
  803a10:	74 0b                	je     803a1d <realloc_block_FF+0x648>
  803a12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a15:	8b 00                	mov    (%eax),%eax
  803a17:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a1a:	89 50 04             	mov    %edx,0x4(%eax)
  803a1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a20:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a23:	89 10                	mov    %edx,(%eax)
  803a25:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a2b:	89 50 04             	mov    %edx,0x4(%eax)
  803a2e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a31:	8b 00                	mov    (%eax),%eax
  803a33:	85 c0                	test   %eax,%eax
  803a35:	75 08                	jne    803a3f <realloc_block_FF+0x66a>
  803a37:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a3a:	a3 34 50 80 00       	mov    %eax,0x805034
  803a3f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a44:	40                   	inc    %eax
  803a45:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a4e:	75 17                	jne    803a67 <realloc_block_FF+0x692>
  803a50:	83 ec 04             	sub    $0x4,%esp
  803a53:	68 ff 45 80 00       	push   $0x8045ff
  803a58:	68 45 02 00 00       	push   $0x245
  803a5d:	68 1d 46 80 00       	push   $0x80461d
  803a62:	e8 8a c9 ff ff       	call   8003f1 <_panic>
  803a67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a6a:	8b 00                	mov    (%eax),%eax
  803a6c:	85 c0                	test   %eax,%eax
  803a6e:	74 10                	je     803a80 <realloc_block_FF+0x6ab>
  803a70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a73:	8b 00                	mov    (%eax),%eax
  803a75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a78:	8b 52 04             	mov    0x4(%edx),%edx
  803a7b:	89 50 04             	mov    %edx,0x4(%eax)
  803a7e:	eb 0b                	jmp    803a8b <realloc_block_FF+0x6b6>
  803a80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a83:	8b 40 04             	mov    0x4(%eax),%eax
  803a86:	a3 34 50 80 00       	mov    %eax,0x805034
  803a8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a8e:	8b 40 04             	mov    0x4(%eax),%eax
  803a91:	85 c0                	test   %eax,%eax
  803a93:	74 0f                	je     803aa4 <realloc_block_FF+0x6cf>
  803a95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a98:	8b 40 04             	mov    0x4(%eax),%eax
  803a9b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a9e:	8b 12                	mov    (%edx),%edx
  803aa0:	89 10                	mov    %edx,(%eax)
  803aa2:	eb 0a                	jmp    803aae <realloc_block_FF+0x6d9>
  803aa4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa7:	8b 00                	mov    (%eax),%eax
  803aa9:	a3 30 50 80 00       	mov    %eax,0x805030
  803aae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ab7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ac1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ac6:	48                   	dec    %eax
  803ac7:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803acc:	83 ec 04             	sub    $0x4,%esp
  803acf:	6a 00                	push   $0x0
  803ad1:	ff 75 bc             	pushl  -0x44(%ebp)
  803ad4:	ff 75 b8             	pushl  -0x48(%ebp)
  803ad7:	e8 06 e9 ff ff       	call   8023e2 <set_block_data>
  803adc:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803adf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae2:	eb 0a                	jmp    803aee <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803ae4:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803aeb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803aee:	c9                   	leave  
  803aef:	c3                   	ret    

00803af0 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803af0:	55                   	push   %ebp
  803af1:	89 e5                	mov    %esp,%ebp
  803af3:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803af6:	83 ec 04             	sub    $0x4,%esp
  803af9:	68 14 47 80 00       	push   $0x804714
  803afe:	68 58 02 00 00       	push   $0x258
  803b03:	68 1d 46 80 00       	push   $0x80461d
  803b08:	e8 e4 c8 ff ff       	call   8003f1 <_panic>

00803b0d <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b0d:	55                   	push   %ebp
  803b0e:	89 e5                	mov    %esp,%ebp
  803b10:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b13:	83 ec 04             	sub    $0x4,%esp
  803b16:	68 3c 47 80 00       	push   $0x80473c
  803b1b:	68 61 02 00 00       	push   $0x261
  803b20:	68 1d 46 80 00       	push   $0x80461d
  803b25:	e8 c7 c8 ff ff       	call   8003f1 <_panic>
  803b2a:	66 90                	xchg   %ax,%ax

00803b2c <__udivdi3>:
  803b2c:	55                   	push   %ebp
  803b2d:	57                   	push   %edi
  803b2e:	56                   	push   %esi
  803b2f:	53                   	push   %ebx
  803b30:	83 ec 1c             	sub    $0x1c,%esp
  803b33:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b37:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b3f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b43:	89 ca                	mov    %ecx,%edx
  803b45:	89 f8                	mov    %edi,%eax
  803b47:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b4b:	85 f6                	test   %esi,%esi
  803b4d:	75 2d                	jne    803b7c <__udivdi3+0x50>
  803b4f:	39 cf                	cmp    %ecx,%edi
  803b51:	77 65                	ja     803bb8 <__udivdi3+0x8c>
  803b53:	89 fd                	mov    %edi,%ebp
  803b55:	85 ff                	test   %edi,%edi
  803b57:	75 0b                	jne    803b64 <__udivdi3+0x38>
  803b59:	b8 01 00 00 00       	mov    $0x1,%eax
  803b5e:	31 d2                	xor    %edx,%edx
  803b60:	f7 f7                	div    %edi
  803b62:	89 c5                	mov    %eax,%ebp
  803b64:	31 d2                	xor    %edx,%edx
  803b66:	89 c8                	mov    %ecx,%eax
  803b68:	f7 f5                	div    %ebp
  803b6a:	89 c1                	mov    %eax,%ecx
  803b6c:	89 d8                	mov    %ebx,%eax
  803b6e:	f7 f5                	div    %ebp
  803b70:	89 cf                	mov    %ecx,%edi
  803b72:	89 fa                	mov    %edi,%edx
  803b74:	83 c4 1c             	add    $0x1c,%esp
  803b77:	5b                   	pop    %ebx
  803b78:	5e                   	pop    %esi
  803b79:	5f                   	pop    %edi
  803b7a:	5d                   	pop    %ebp
  803b7b:	c3                   	ret    
  803b7c:	39 ce                	cmp    %ecx,%esi
  803b7e:	77 28                	ja     803ba8 <__udivdi3+0x7c>
  803b80:	0f bd fe             	bsr    %esi,%edi
  803b83:	83 f7 1f             	xor    $0x1f,%edi
  803b86:	75 40                	jne    803bc8 <__udivdi3+0x9c>
  803b88:	39 ce                	cmp    %ecx,%esi
  803b8a:	72 0a                	jb     803b96 <__udivdi3+0x6a>
  803b8c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b90:	0f 87 9e 00 00 00    	ja     803c34 <__udivdi3+0x108>
  803b96:	b8 01 00 00 00       	mov    $0x1,%eax
  803b9b:	89 fa                	mov    %edi,%edx
  803b9d:	83 c4 1c             	add    $0x1c,%esp
  803ba0:	5b                   	pop    %ebx
  803ba1:	5e                   	pop    %esi
  803ba2:	5f                   	pop    %edi
  803ba3:	5d                   	pop    %ebp
  803ba4:	c3                   	ret    
  803ba5:	8d 76 00             	lea    0x0(%esi),%esi
  803ba8:	31 ff                	xor    %edi,%edi
  803baa:	31 c0                	xor    %eax,%eax
  803bac:	89 fa                	mov    %edi,%edx
  803bae:	83 c4 1c             	add    $0x1c,%esp
  803bb1:	5b                   	pop    %ebx
  803bb2:	5e                   	pop    %esi
  803bb3:	5f                   	pop    %edi
  803bb4:	5d                   	pop    %ebp
  803bb5:	c3                   	ret    
  803bb6:	66 90                	xchg   %ax,%ax
  803bb8:	89 d8                	mov    %ebx,%eax
  803bba:	f7 f7                	div    %edi
  803bbc:	31 ff                	xor    %edi,%edi
  803bbe:	89 fa                	mov    %edi,%edx
  803bc0:	83 c4 1c             	add    $0x1c,%esp
  803bc3:	5b                   	pop    %ebx
  803bc4:	5e                   	pop    %esi
  803bc5:	5f                   	pop    %edi
  803bc6:	5d                   	pop    %ebp
  803bc7:	c3                   	ret    
  803bc8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bcd:	89 eb                	mov    %ebp,%ebx
  803bcf:	29 fb                	sub    %edi,%ebx
  803bd1:	89 f9                	mov    %edi,%ecx
  803bd3:	d3 e6                	shl    %cl,%esi
  803bd5:	89 c5                	mov    %eax,%ebp
  803bd7:	88 d9                	mov    %bl,%cl
  803bd9:	d3 ed                	shr    %cl,%ebp
  803bdb:	89 e9                	mov    %ebp,%ecx
  803bdd:	09 f1                	or     %esi,%ecx
  803bdf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803be3:	89 f9                	mov    %edi,%ecx
  803be5:	d3 e0                	shl    %cl,%eax
  803be7:	89 c5                	mov    %eax,%ebp
  803be9:	89 d6                	mov    %edx,%esi
  803beb:	88 d9                	mov    %bl,%cl
  803bed:	d3 ee                	shr    %cl,%esi
  803bef:	89 f9                	mov    %edi,%ecx
  803bf1:	d3 e2                	shl    %cl,%edx
  803bf3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bf7:	88 d9                	mov    %bl,%cl
  803bf9:	d3 e8                	shr    %cl,%eax
  803bfb:	09 c2                	or     %eax,%edx
  803bfd:	89 d0                	mov    %edx,%eax
  803bff:	89 f2                	mov    %esi,%edx
  803c01:	f7 74 24 0c          	divl   0xc(%esp)
  803c05:	89 d6                	mov    %edx,%esi
  803c07:	89 c3                	mov    %eax,%ebx
  803c09:	f7 e5                	mul    %ebp
  803c0b:	39 d6                	cmp    %edx,%esi
  803c0d:	72 19                	jb     803c28 <__udivdi3+0xfc>
  803c0f:	74 0b                	je     803c1c <__udivdi3+0xf0>
  803c11:	89 d8                	mov    %ebx,%eax
  803c13:	31 ff                	xor    %edi,%edi
  803c15:	e9 58 ff ff ff       	jmp    803b72 <__udivdi3+0x46>
  803c1a:	66 90                	xchg   %ax,%ax
  803c1c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c20:	89 f9                	mov    %edi,%ecx
  803c22:	d3 e2                	shl    %cl,%edx
  803c24:	39 c2                	cmp    %eax,%edx
  803c26:	73 e9                	jae    803c11 <__udivdi3+0xe5>
  803c28:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c2b:	31 ff                	xor    %edi,%edi
  803c2d:	e9 40 ff ff ff       	jmp    803b72 <__udivdi3+0x46>
  803c32:	66 90                	xchg   %ax,%ax
  803c34:	31 c0                	xor    %eax,%eax
  803c36:	e9 37 ff ff ff       	jmp    803b72 <__udivdi3+0x46>
  803c3b:	90                   	nop

00803c3c <__umoddi3>:
  803c3c:	55                   	push   %ebp
  803c3d:	57                   	push   %edi
  803c3e:	56                   	push   %esi
  803c3f:	53                   	push   %ebx
  803c40:	83 ec 1c             	sub    $0x1c,%esp
  803c43:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c47:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c4f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c5b:	89 f3                	mov    %esi,%ebx
  803c5d:	89 fa                	mov    %edi,%edx
  803c5f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c63:	89 34 24             	mov    %esi,(%esp)
  803c66:	85 c0                	test   %eax,%eax
  803c68:	75 1a                	jne    803c84 <__umoddi3+0x48>
  803c6a:	39 f7                	cmp    %esi,%edi
  803c6c:	0f 86 a2 00 00 00    	jbe    803d14 <__umoddi3+0xd8>
  803c72:	89 c8                	mov    %ecx,%eax
  803c74:	89 f2                	mov    %esi,%edx
  803c76:	f7 f7                	div    %edi
  803c78:	89 d0                	mov    %edx,%eax
  803c7a:	31 d2                	xor    %edx,%edx
  803c7c:	83 c4 1c             	add    $0x1c,%esp
  803c7f:	5b                   	pop    %ebx
  803c80:	5e                   	pop    %esi
  803c81:	5f                   	pop    %edi
  803c82:	5d                   	pop    %ebp
  803c83:	c3                   	ret    
  803c84:	39 f0                	cmp    %esi,%eax
  803c86:	0f 87 ac 00 00 00    	ja     803d38 <__umoddi3+0xfc>
  803c8c:	0f bd e8             	bsr    %eax,%ebp
  803c8f:	83 f5 1f             	xor    $0x1f,%ebp
  803c92:	0f 84 ac 00 00 00    	je     803d44 <__umoddi3+0x108>
  803c98:	bf 20 00 00 00       	mov    $0x20,%edi
  803c9d:	29 ef                	sub    %ebp,%edi
  803c9f:	89 fe                	mov    %edi,%esi
  803ca1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ca5:	89 e9                	mov    %ebp,%ecx
  803ca7:	d3 e0                	shl    %cl,%eax
  803ca9:	89 d7                	mov    %edx,%edi
  803cab:	89 f1                	mov    %esi,%ecx
  803cad:	d3 ef                	shr    %cl,%edi
  803caf:	09 c7                	or     %eax,%edi
  803cb1:	89 e9                	mov    %ebp,%ecx
  803cb3:	d3 e2                	shl    %cl,%edx
  803cb5:	89 14 24             	mov    %edx,(%esp)
  803cb8:	89 d8                	mov    %ebx,%eax
  803cba:	d3 e0                	shl    %cl,%eax
  803cbc:	89 c2                	mov    %eax,%edx
  803cbe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cc2:	d3 e0                	shl    %cl,%eax
  803cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cc8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ccc:	89 f1                	mov    %esi,%ecx
  803cce:	d3 e8                	shr    %cl,%eax
  803cd0:	09 d0                	or     %edx,%eax
  803cd2:	d3 eb                	shr    %cl,%ebx
  803cd4:	89 da                	mov    %ebx,%edx
  803cd6:	f7 f7                	div    %edi
  803cd8:	89 d3                	mov    %edx,%ebx
  803cda:	f7 24 24             	mull   (%esp)
  803cdd:	89 c6                	mov    %eax,%esi
  803cdf:	89 d1                	mov    %edx,%ecx
  803ce1:	39 d3                	cmp    %edx,%ebx
  803ce3:	0f 82 87 00 00 00    	jb     803d70 <__umoddi3+0x134>
  803ce9:	0f 84 91 00 00 00    	je     803d80 <__umoddi3+0x144>
  803cef:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cf3:	29 f2                	sub    %esi,%edx
  803cf5:	19 cb                	sbb    %ecx,%ebx
  803cf7:	89 d8                	mov    %ebx,%eax
  803cf9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cfd:	d3 e0                	shl    %cl,%eax
  803cff:	89 e9                	mov    %ebp,%ecx
  803d01:	d3 ea                	shr    %cl,%edx
  803d03:	09 d0                	or     %edx,%eax
  803d05:	89 e9                	mov    %ebp,%ecx
  803d07:	d3 eb                	shr    %cl,%ebx
  803d09:	89 da                	mov    %ebx,%edx
  803d0b:	83 c4 1c             	add    $0x1c,%esp
  803d0e:	5b                   	pop    %ebx
  803d0f:	5e                   	pop    %esi
  803d10:	5f                   	pop    %edi
  803d11:	5d                   	pop    %ebp
  803d12:	c3                   	ret    
  803d13:	90                   	nop
  803d14:	89 fd                	mov    %edi,%ebp
  803d16:	85 ff                	test   %edi,%edi
  803d18:	75 0b                	jne    803d25 <__umoddi3+0xe9>
  803d1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d1f:	31 d2                	xor    %edx,%edx
  803d21:	f7 f7                	div    %edi
  803d23:	89 c5                	mov    %eax,%ebp
  803d25:	89 f0                	mov    %esi,%eax
  803d27:	31 d2                	xor    %edx,%edx
  803d29:	f7 f5                	div    %ebp
  803d2b:	89 c8                	mov    %ecx,%eax
  803d2d:	f7 f5                	div    %ebp
  803d2f:	89 d0                	mov    %edx,%eax
  803d31:	e9 44 ff ff ff       	jmp    803c7a <__umoddi3+0x3e>
  803d36:	66 90                	xchg   %ax,%ax
  803d38:	89 c8                	mov    %ecx,%eax
  803d3a:	89 f2                	mov    %esi,%edx
  803d3c:	83 c4 1c             	add    $0x1c,%esp
  803d3f:	5b                   	pop    %ebx
  803d40:	5e                   	pop    %esi
  803d41:	5f                   	pop    %edi
  803d42:	5d                   	pop    %ebp
  803d43:	c3                   	ret    
  803d44:	3b 04 24             	cmp    (%esp),%eax
  803d47:	72 06                	jb     803d4f <__umoddi3+0x113>
  803d49:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d4d:	77 0f                	ja     803d5e <__umoddi3+0x122>
  803d4f:	89 f2                	mov    %esi,%edx
  803d51:	29 f9                	sub    %edi,%ecx
  803d53:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d57:	89 14 24             	mov    %edx,(%esp)
  803d5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d5e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d62:	8b 14 24             	mov    (%esp),%edx
  803d65:	83 c4 1c             	add    $0x1c,%esp
  803d68:	5b                   	pop    %ebx
  803d69:	5e                   	pop    %esi
  803d6a:	5f                   	pop    %edi
  803d6b:	5d                   	pop    %ebp
  803d6c:	c3                   	ret    
  803d6d:	8d 76 00             	lea    0x0(%esi),%esi
  803d70:	2b 04 24             	sub    (%esp),%eax
  803d73:	19 fa                	sbb    %edi,%edx
  803d75:	89 d1                	mov    %edx,%ecx
  803d77:	89 c6                	mov    %eax,%esi
  803d79:	e9 71 ff ff ff       	jmp    803cef <__umoddi3+0xb3>
  803d7e:	66 90                	xchg   %ax,%ax
  803d80:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d84:	72 ea                	jb     803d70 <__umoddi3+0x134>
  803d86:	89 d9                	mov    %ebx,%ecx
  803d88:	e9 62 ff ff ff       	jmp    803cef <__umoddi3+0xb3>
