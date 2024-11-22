
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
  80005c:	68 e0 3b 80 00       	push   $0x803be0
  800061:	6a 0d                	push   $0xd
  800063:	68 fc 3b 80 00       	push   $0x803bfc
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
  800074:	e8 41 1b 00 00       	call   801bba <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 a4 18 00 00       	call   801925 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 52 19 00 00       	call   8019d8 <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 17 3c 80 00       	push   $0x803c17
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	e8 71 17 00 00       	call   80180a <sget>
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
  8000b6:	68 1c 3c 80 00       	push   $0x803c1c
  8000bb:	6a 21                	push   $0x21
  8000bd:	68 fc 3b 80 00       	push   $0x803bfc
  8000c2:	e8 2a 03 00 00       	call   8003f1 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 02 19 00 00       	call   8019d8 <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 eb 18 00 00       	call   8019d8 <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 98 3c 80 00       	push   $0x803c98
  8000fd:	6a 24                	push   $0x24
  8000ff:	68 fc 3b 80 00       	push   $0x803bfc
  800104:	e8 e8 02 00 00       	call   8003f1 <_panic>
	}
	sys_unlock_cons();
  800109:	e8 31 18 00 00       	call   80193f <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 12 18 00 00       	call   801925 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 c0 18 00 00       	call   8019d8 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = sget(parentenvID,"y");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 30 3d 80 00       	push   $0x803d30
  800123:	ff 75 f0             	pushl  -0x10(%ebp)
  800126:	e8 df 16 00 00       	call   80180a <sget>
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
  80014d:	68 1c 3c 80 00       	push   $0x803c1c
  800152:	6a 2f                	push   $0x2f
  800154:	68 fc 3b 80 00       	push   $0x803bfc
  800159:	e8 93 02 00 00       	call   8003f1 <_panic>
		expected = 0 ;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 6b 18 00 00       	call   8019d8 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 54 18 00 00       	call   8019d8 <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 98 3c 80 00       	push   $0x803c98
  800194:	6a 32                	push   $0x32
  800196:	68 fc 3b 80 00       	push   $0x803bfc
  80019b:	e8 51 02 00 00       	call   8003f1 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 9a 17 00 00       	call   80193f <sys_unlock_cons>
	//sys_unlock_cons();

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 14             	cmp    $0x14,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 34 3d 80 00       	push   $0x803d34
  8001b7:	6a 37                	push   $0x37
  8001b9:	68 fc 3b 80 00       	push   $0x803bfc
  8001be:	e8 2e 02 00 00       	call   8003f1 <_panic>

	//sys_lock_cons();
	sys_lock_cons();
  8001c3:	e8 5d 17 00 00       	call   801925 <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  8001c8:	e8 0b 18 00 00       	call   8019d8 <sys_calculate_free_frames>
  8001cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	68 6b 3d 80 00       	push   $0x803d6b
  8001d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8001db:	e8 2a 16 00 00       	call   80180a <sget>
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
  800202:	68 1c 3c 80 00       	push   $0x803c1c
  800207:	6a 3f                	push   $0x3f
  800209:	68 fc 3b 80 00       	push   $0x803bfc
  80020e:	e8 de 01 00 00       	call   8003f1 <_panic>
		expected = 0 ;
  800213:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80021a:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80021d:	e8 b6 17 00 00       	call   8019d8 <sys_calculate_free_frames>
  800222:	29 c3                	sub    %eax,%ebx
  800224:	89 d8                	mov    %ebx,%eax
  800226:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800229:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022f:	74 24                	je     800255 <_main+0x21d>
  800231:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800234:	e8 9f 17 00 00       	call   8019d8 <sys_calculate_free_frames>
  800239:	29 c3                	sub    %eax,%ebx
  80023b:	89 d8                	mov    %ebx,%eax
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	ff 75 e0             	pushl  -0x20(%ebp)
  800243:	50                   	push   %eax
  800244:	68 98 3c 80 00       	push   $0x803c98
  800249:	6a 42                	push   $0x42
  80024b:	68 fc 3b 80 00       	push   $0x803bfc
  800250:	e8 9c 01 00 00       	call   8003f1 <_panic>
	}
	sys_unlock_cons();
  800255:	e8 e5 16 00 00       	call   80193f <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  80025a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80025d:	8b 00                	mov    (%eax),%eax
  80025f:	83 f8 0a             	cmp    $0xa,%eax
  800262:	74 14                	je     800278 <_main+0x240>
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	68 34 3d 80 00       	push   $0x803d34
  80026c:	6a 47                	push   $0x47
  80026e:	68 fc 3b 80 00       	push   $0x803bfc
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
  800296:	68 34 3d 80 00       	push   $0x803d34
  80029b:	6a 4a                	push   $0x4a
  80029d:	68 fc 3b 80 00       	push   $0x803bfc
  8002a2:	e8 4a 01 00 00       	call   8003f1 <_panic>

	//To indicate that it's completed successfully
	inctst();
  8002a7:	e8 33 1a 00 00       	call   801cdf <inctst>

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
  8002b8:	e8 e4 18 00 00       	call   801ba1 <sys_getenvindex>
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
  800326:	e8 fa 15 00 00       	call   801925 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80032b:	83 ec 0c             	sub    $0xc,%esp
  80032e:	68 88 3d 80 00       	push   $0x803d88
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
  800356:	68 b0 3d 80 00       	push   $0x803db0
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
  800387:	68 d8 3d 80 00       	push   $0x803dd8
  80038c:	e8 1d 03 00 00       	call   8006ae <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800394:	a1 20 50 80 00       	mov    0x805020,%eax
  800399:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80039f:	83 ec 08             	sub    $0x8,%esp
  8003a2:	50                   	push   %eax
  8003a3:	68 30 3e 80 00       	push   $0x803e30
  8003a8:	e8 01 03 00 00       	call   8006ae <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003b0:	83 ec 0c             	sub    $0xc,%esp
  8003b3:	68 88 3d 80 00       	push   $0x803d88
  8003b8:	e8 f1 02 00 00       	call   8006ae <cprintf>
  8003bd:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003c0:	e8 7a 15 00 00       	call   80193f <sys_unlock_cons>
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
  8003d8:	e8 90 17 00 00       	call   801b6d <sys_destroy_env>
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
  8003e9:	e8 e5 17 00 00       	call   801bd3 <sys_exit_env>
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
  800412:	68 44 3e 80 00       	push   $0x803e44
  800417:	e8 92 02 00 00       	call   8006ae <cprintf>
  80041c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80041f:	a1 00 50 80 00       	mov    0x805000,%eax
  800424:	ff 75 0c             	pushl  0xc(%ebp)
  800427:	ff 75 08             	pushl  0x8(%ebp)
  80042a:	50                   	push   %eax
  80042b:	68 49 3e 80 00       	push   $0x803e49
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
  80044f:	68 65 3e 80 00       	push   $0x803e65
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
  80047e:	68 68 3e 80 00       	push   $0x803e68
  800483:	6a 26                	push   $0x26
  800485:	68 b4 3e 80 00       	push   $0x803eb4
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
  800553:	68 c0 3e 80 00       	push   $0x803ec0
  800558:	6a 3a                	push   $0x3a
  80055a:	68 b4 3e 80 00       	push   $0x803eb4
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
  8005c6:	68 14 3f 80 00       	push   $0x803f14
  8005cb:	6a 44                	push   $0x44
  8005cd:	68 b4 3e 80 00       	push   $0x803eb4
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
  800620:	e8 be 12 00 00       	call   8018e3 <sys_cputs>
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
  800697:	e8 47 12 00 00       	call   8018e3 <sys_cputs>
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
  8006e1:	e8 3f 12 00 00       	call   801925 <sys_lock_cons>
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
  800701:	e8 39 12 00 00       	call   80193f <sys_unlock_cons>
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
  80074b:	e8 2c 32 00 00       	call   80397c <__udivdi3>
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
  80079b:	e8 ec 32 00 00       	call   803a8c <__umoddi3>
  8007a0:	83 c4 10             	add    $0x10,%esp
  8007a3:	05 74 41 80 00       	add    $0x804174,%eax
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
  8008f6:	8b 04 85 98 41 80 00 	mov    0x804198(,%eax,4),%eax
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
  8009d7:	8b 34 9d e0 3f 80 00 	mov    0x803fe0(,%ebx,4),%esi
  8009de:	85 f6                	test   %esi,%esi
  8009e0:	75 19                	jne    8009fb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e2:	53                   	push   %ebx
  8009e3:	68 85 41 80 00       	push   $0x804185
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
  8009fc:	68 8e 41 80 00       	push   $0x80418e
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
  800a29:	be 91 41 80 00       	mov    $0x804191,%esi
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
  801434:	68 08 43 80 00       	push   $0x804308
  801439:	68 3f 01 00 00       	push   $0x13f
  80143e:	68 2a 43 80 00       	push   $0x80432a
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
  801454:	e8 35 0a 00 00       	call   801e8e <sys_sbrk>
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
  8014cf:	e8 3e 08 00 00       	call   801d12 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	74 16                	je     8014ee <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	ff 75 08             	pushl  0x8(%ebp)
  8014de:	e8 7e 0d 00 00       	call   802261 <alloc_block_FF>
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e9:	e9 8a 01 00 00       	jmp    801678 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014ee:	e8 50 08 00 00       	call   801d43 <sys_isUHeapPlacementStrategyBESTFIT>
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	0f 84 7d 01 00 00    	je     801678 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014fb:	83 ec 0c             	sub    $0xc,%esp
  8014fe:	ff 75 08             	pushl  0x8(%ebp)
  801501:	e8 17 12 00 00       	call   80271d <alloc_block_BF>
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
  801667:	e8 59 08 00 00       	call   801ec5 <sys_allocate_user_mem>
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
  8016af:	e8 2d 08 00 00       	call   801ee1 <get_block_size>
  8016b4:	83 c4 10             	add    $0x10,%esp
  8016b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016ba:	83 ec 0c             	sub    $0xc,%esp
  8016bd:	ff 75 08             	pushl  0x8(%ebp)
  8016c0:	e8 60 1a 00 00       	call   803125 <free_block>
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
  801757:	e8 4d 07 00 00       	call   801ea9 <sys_free_user_mem>
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
  801765:	68 38 43 80 00       	push   $0x804338
  80176a:	68 84 00 00 00       	push   $0x84
  80176f:	68 62 43 80 00       	push   $0x804362
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
  801792:	eb 74                	jmp    801808 <smalloc+0x8d>
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
  8017c7:	eb 3f                	jmp    801808 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8017c9:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017cd:	ff 75 ec             	pushl  -0x14(%ebp)
  8017d0:	50                   	push   %eax
  8017d1:	ff 75 0c             	pushl  0xc(%ebp)
  8017d4:	ff 75 08             	pushl  0x8(%ebp)
  8017d7:	e8 d4 02 00 00       	call   801ab0 <sys_createSharedObject>
  8017dc:	83 c4 10             	add    $0x10,%esp
  8017df:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8017e2:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017e6:	74 06                	je     8017ee <smalloc+0x73>
  8017e8:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017ec:	75 07                	jne    8017f5 <smalloc+0x7a>
  8017ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f3:	eb 13                	jmp    801808 <smalloc+0x8d>
	 cprintf("153\n");
  8017f5:	83 ec 0c             	sub    $0xc,%esp
  8017f8:	68 6e 43 80 00       	push   $0x80436e
  8017fd:	e8 ac ee ff ff       	call   8006ae <cprintf>
  801802:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801805:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801810:	83 ec 04             	sub    $0x4,%esp
  801813:	68 74 43 80 00       	push   $0x804374
  801818:	68 a4 00 00 00       	push   $0xa4
  80181d:	68 62 43 80 00       	push   $0x804362
  801822:	e8 ca eb ff ff       	call   8003f1 <_panic>

00801827 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80182d:	83 ec 04             	sub    $0x4,%esp
  801830:	68 98 43 80 00       	push   $0x804398
  801835:	68 bc 00 00 00       	push   $0xbc
  80183a:	68 62 43 80 00       	push   $0x804362
  80183f:	e8 ad eb ff ff       	call   8003f1 <_panic>

00801844 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80184a:	83 ec 04             	sub    $0x4,%esp
  80184d:	68 bc 43 80 00       	push   $0x8043bc
  801852:	68 d3 00 00 00       	push   $0xd3
  801857:	68 62 43 80 00       	push   $0x804362
  80185c:	e8 90 eb ff ff       	call   8003f1 <_panic>

00801861 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801867:	83 ec 04             	sub    $0x4,%esp
  80186a:	68 e2 43 80 00       	push   $0x8043e2
  80186f:	68 df 00 00 00       	push   $0xdf
  801874:	68 62 43 80 00       	push   $0x804362
  801879:	e8 73 eb ff ff       	call   8003f1 <_panic>

0080187e <shrink>:

}
void shrink(uint32 newSize)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
  801881:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801884:	83 ec 04             	sub    $0x4,%esp
  801887:	68 e2 43 80 00       	push   $0x8043e2
  80188c:	68 e4 00 00 00       	push   $0xe4
  801891:	68 62 43 80 00       	push   $0x804362
  801896:	e8 56 eb ff ff       	call   8003f1 <_panic>

0080189b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a1:	83 ec 04             	sub    $0x4,%esp
  8018a4:	68 e2 43 80 00       	push   $0x8043e2
  8018a9:	68 e9 00 00 00       	push   $0xe9
  8018ae:	68 62 43 80 00       	push   $0x804362
  8018b3:	e8 39 eb ff ff       	call   8003f1 <_panic>

008018b8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	57                   	push   %edi
  8018bc:	56                   	push   %esi
  8018bd:	53                   	push   %ebx
  8018be:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018d0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018d3:	cd 30                	int    $0x30
  8018d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018db:	83 c4 10             	add    $0x10,%esp
  8018de:	5b                   	pop    %ebx
  8018df:	5e                   	pop    %esi
  8018e0:	5f                   	pop    %edi
  8018e1:	5d                   	pop    %ebp
  8018e2:	c3                   	ret    

008018e3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 04             	sub    $0x4,%esp
  8018e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018ef:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	52                   	push   %edx
  8018fb:	ff 75 0c             	pushl  0xc(%ebp)
  8018fe:	50                   	push   %eax
  8018ff:	6a 00                	push   $0x0
  801901:	e8 b2 ff ff ff       	call   8018b8 <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	90                   	nop
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <sys_cgetc>:

int
sys_cgetc(void)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 02                	push   $0x2
  80191b:	e8 98 ff ff ff       	call   8018b8 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 03                	push   $0x3
  801934:	e8 7f ff ff ff       	call   8018b8 <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	90                   	nop
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 04                	push   $0x4
  80194e:	e8 65 ff ff ff       	call   8018b8 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	90                   	nop
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80195c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	52                   	push   %edx
  801969:	50                   	push   %eax
  80196a:	6a 08                	push   $0x8
  80196c:	e8 47 ff ff ff       	call   8018b8 <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	56                   	push   %esi
  80197a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80197b:	8b 75 18             	mov    0x18(%ebp),%esi
  80197e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801981:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801984:	8b 55 0c             	mov    0xc(%ebp),%edx
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	56                   	push   %esi
  80198b:	53                   	push   %ebx
  80198c:	51                   	push   %ecx
  80198d:	52                   	push   %edx
  80198e:	50                   	push   %eax
  80198f:	6a 09                	push   $0x9
  801991:	e8 22 ff ff ff       	call   8018b8 <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
}
  801999:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199c:	5b                   	pop    %ebx
  80199d:	5e                   	pop    %esi
  80199e:	5d                   	pop    %ebp
  80199f:	c3                   	ret    

008019a0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	52                   	push   %edx
  8019b0:	50                   	push   %eax
  8019b1:	6a 0a                	push   $0xa
  8019b3:	e8 00 ff ff ff       	call   8018b8 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	ff 75 08             	pushl  0x8(%ebp)
  8019cc:	6a 0b                	push   $0xb
  8019ce:	e8 e5 fe ff ff       	call   8018b8 <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 0c                	push   $0xc
  8019e7:	e8 cc fe ff ff       	call   8018b8 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 0d                	push   $0xd
  801a00:	e8 b3 fe ff ff       	call   8018b8 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 0e                	push   $0xe
  801a19:	e8 9a fe ff ff       	call   8018b8 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 0f                	push   $0xf
  801a32:	e8 81 fe ff ff       	call   8018b8 <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	ff 75 08             	pushl  0x8(%ebp)
  801a4a:	6a 10                	push   $0x10
  801a4c:	e8 67 fe ff ff       	call   8018b8 <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 11                	push   $0x11
  801a65:	e8 4e fe ff ff       	call   8018b8 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	90                   	nop
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	83 ec 04             	sub    $0x4,%esp
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a7c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	50                   	push   %eax
  801a89:	6a 01                	push   $0x1
  801a8b:	e8 28 fe ff ff       	call   8018b8 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	90                   	nop
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 14                	push   $0x14
  801aa5:	e8 0e fe ff ff       	call   8018b8 <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	90                   	nop
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	83 ec 04             	sub    $0x4,%esp
  801ab6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801abc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801abf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	6a 00                	push   $0x0
  801ac8:	51                   	push   %ecx
  801ac9:	52                   	push   %edx
  801aca:	ff 75 0c             	pushl  0xc(%ebp)
  801acd:	50                   	push   %eax
  801ace:	6a 15                	push   $0x15
  801ad0:	e8 e3 fd ff ff       	call   8018b8 <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801add:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	52                   	push   %edx
  801aea:	50                   	push   %eax
  801aeb:	6a 16                	push   $0x16
  801aed:	e8 c6 fd ff ff       	call   8018b8 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801afa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	51                   	push   %ecx
  801b08:	52                   	push   %edx
  801b09:	50                   	push   %eax
  801b0a:	6a 17                	push   $0x17
  801b0c:	e8 a7 fd ff ff       	call   8018b8 <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	52                   	push   %edx
  801b26:	50                   	push   %eax
  801b27:	6a 18                	push   $0x18
  801b29:	e8 8a fd ff ff       	call   8018b8 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	6a 00                	push   $0x0
  801b3b:	ff 75 14             	pushl  0x14(%ebp)
  801b3e:	ff 75 10             	pushl  0x10(%ebp)
  801b41:	ff 75 0c             	pushl  0xc(%ebp)
  801b44:	50                   	push   %eax
  801b45:	6a 19                	push   $0x19
  801b47:	e8 6c fd ff ff       	call   8018b8 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	50                   	push   %eax
  801b60:	6a 1a                	push   $0x1a
  801b62:	e8 51 fd ff ff       	call   8018b8 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	90                   	nop
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	50                   	push   %eax
  801b7c:	6a 1b                	push   $0x1b
  801b7e:	e8 35 fd ff ff       	call   8018b8 <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 05                	push   $0x5
  801b97:	e8 1c fd ff ff       	call   8018b8 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 06                	push   $0x6
  801bb0:	e8 03 fd ff ff       	call   8018b8 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 07                	push   $0x7
  801bc9:	e8 ea fc ff ff       	call   8018b8 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_exit_env>:


void sys_exit_env(void)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 1c                	push   $0x1c
  801be2:	e8 d1 fc ff ff       	call   8018b8 <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
}
  801bea:	90                   	nop
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bf3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bf6:	8d 50 04             	lea    0x4(%eax),%edx
  801bf9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	52                   	push   %edx
  801c03:	50                   	push   %eax
  801c04:	6a 1d                	push   $0x1d
  801c06:	e8 ad fc ff ff       	call   8018b8 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
	return result;
  801c0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c17:	89 01                	mov    %eax,(%ecx)
  801c19:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	c9                   	leave  
  801c20:	c2 04 00             	ret    $0x4

00801c23 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	ff 75 10             	pushl  0x10(%ebp)
  801c2d:	ff 75 0c             	pushl  0xc(%ebp)
  801c30:	ff 75 08             	pushl  0x8(%ebp)
  801c33:	6a 13                	push   $0x13
  801c35:	e8 7e fc ff ff       	call   8018b8 <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3d:	90                   	nop
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 1e                	push   $0x1e
  801c4f:	e8 64 fc ff ff       	call   8018b8 <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c65:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	50                   	push   %eax
  801c72:	6a 1f                	push   $0x1f
  801c74:	e8 3f fc ff ff       	call   8018b8 <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7c:	90                   	nop
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <rsttst>:
void rsttst()
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 21                	push   $0x21
  801c8e:	e8 25 fc ff ff       	call   8018b8 <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
	return ;
  801c96:	90                   	nop
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	83 ec 04             	sub    $0x4,%esp
  801c9f:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ca5:	8b 55 18             	mov    0x18(%ebp),%edx
  801ca8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cac:	52                   	push   %edx
  801cad:	50                   	push   %eax
  801cae:	ff 75 10             	pushl  0x10(%ebp)
  801cb1:	ff 75 0c             	pushl  0xc(%ebp)
  801cb4:	ff 75 08             	pushl  0x8(%ebp)
  801cb7:	6a 20                	push   $0x20
  801cb9:	e8 fa fb ff ff       	call   8018b8 <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc1:	90                   	nop
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <chktst>:
void chktst(uint32 n)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	ff 75 08             	pushl  0x8(%ebp)
  801cd2:	6a 22                	push   $0x22
  801cd4:	e8 df fb ff ff       	call   8018b8 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdc:	90                   	nop
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <inctst>:

void inctst()
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 23                	push   $0x23
  801cee:	e8 c5 fb ff ff       	call   8018b8 <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf6:	90                   	nop
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <gettst>:
uint32 gettst()
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 24                	push   $0x24
  801d08:	e8 ab fb ff ff       	call   8018b8 <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 25                	push   $0x25
  801d24:	e8 8f fb ff ff       	call   8018b8 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
  801d2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d2f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d33:	75 07                	jne    801d3c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d35:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3a:	eb 05                	jmp    801d41 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 25                	push   $0x25
  801d55:	e8 5e fb ff ff       	call   8018b8 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
  801d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d60:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d64:	75 07                	jne    801d6d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d66:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6b:	eb 05                	jmp    801d72 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 25                	push   $0x25
  801d86:	e8 2d fb ff ff       	call   8018b8 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
  801d8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d91:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d95:	75 07                	jne    801d9e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d97:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9c:	eb 05                	jmp    801da3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 25                	push   $0x25
  801db7:	e8 fc fa ff ff       	call   8018b8 <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
  801dbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dc2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dc6:	75 07                	jne    801dcf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dc8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcd:	eb 05                	jmp    801dd4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	ff 75 08             	pushl  0x8(%ebp)
  801de4:	6a 26                	push   $0x26
  801de6:	e8 cd fa ff ff       	call   8018b8 <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dee:	90                   	nop
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801df5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801df8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	6a 00                	push   $0x0
  801e03:	53                   	push   %ebx
  801e04:	51                   	push   %ecx
  801e05:	52                   	push   %edx
  801e06:	50                   	push   %eax
  801e07:	6a 27                	push   $0x27
  801e09:	e8 aa fa ff ff       	call   8018b8 <syscall>
  801e0e:	83 c4 18             	add    $0x18,%esp
}
  801e11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	52                   	push   %edx
  801e26:	50                   	push   %eax
  801e27:	6a 28                	push   $0x28
  801e29:	e8 8a fa ff ff       	call   8018b8 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e36:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3f:	6a 00                	push   $0x0
  801e41:	51                   	push   %ecx
  801e42:	ff 75 10             	pushl  0x10(%ebp)
  801e45:	52                   	push   %edx
  801e46:	50                   	push   %eax
  801e47:	6a 29                	push   $0x29
  801e49:	e8 6a fa ff ff       	call   8018b8 <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	ff 75 10             	pushl  0x10(%ebp)
  801e5d:	ff 75 0c             	pushl  0xc(%ebp)
  801e60:	ff 75 08             	pushl  0x8(%ebp)
  801e63:	6a 12                	push   $0x12
  801e65:	e8 4e fa ff ff       	call   8018b8 <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6d:	90                   	nop
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	52                   	push   %edx
  801e80:	50                   	push   %eax
  801e81:	6a 2a                	push   $0x2a
  801e83:	e8 30 fa ff ff       	call   8018b8 <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
	return;
  801e8b:	90                   	nop
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	50                   	push   %eax
  801e9d:	6a 2b                	push   $0x2b
  801e9f:	e8 14 fa ff ff       	call   8018b8 <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	ff 75 0c             	pushl  0xc(%ebp)
  801eb5:	ff 75 08             	pushl  0x8(%ebp)
  801eb8:	6a 2c                	push   $0x2c
  801eba:	e8 f9 f9 ff ff       	call   8018b8 <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
	return;
  801ec2:	90                   	nop
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	ff 75 0c             	pushl  0xc(%ebp)
  801ed1:	ff 75 08             	pushl  0x8(%ebp)
  801ed4:	6a 2d                	push   $0x2d
  801ed6:	e8 dd f9 ff ff       	call   8018b8 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
	return;
  801ede:	90                   	nop
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	83 e8 04             	sub    $0x4,%eax
  801eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801ef0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ef3:	8b 00                	mov    (%eax),%eax
  801ef5:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
  801f03:	83 e8 04             	sub    $0x4,%eax
  801f06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f0c:	8b 00                	mov    (%eax),%eax
  801f0e:	83 e0 01             	and    $0x1,%eax
  801f11:	85 c0                	test   %eax,%eax
  801f13:	0f 94 c0             	sete   %al
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f28:	83 f8 02             	cmp    $0x2,%eax
  801f2b:	74 2b                	je     801f58 <alloc_block+0x40>
  801f2d:	83 f8 02             	cmp    $0x2,%eax
  801f30:	7f 07                	jg     801f39 <alloc_block+0x21>
  801f32:	83 f8 01             	cmp    $0x1,%eax
  801f35:	74 0e                	je     801f45 <alloc_block+0x2d>
  801f37:	eb 58                	jmp    801f91 <alloc_block+0x79>
  801f39:	83 f8 03             	cmp    $0x3,%eax
  801f3c:	74 2d                	je     801f6b <alloc_block+0x53>
  801f3e:	83 f8 04             	cmp    $0x4,%eax
  801f41:	74 3b                	je     801f7e <alloc_block+0x66>
  801f43:	eb 4c                	jmp    801f91 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f45:	83 ec 0c             	sub    $0xc,%esp
  801f48:	ff 75 08             	pushl  0x8(%ebp)
  801f4b:	e8 11 03 00 00       	call   802261 <alloc_block_FF>
  801f50:	83 c4 10             	add    $0x10,%esp
  801f53:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f56:	eb 4a                	jmp    801fa2 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f58:	83 ec 0c             	sub    $0xc,%esp
  801f5b:	ff 75 08             	pushl  0x8(%ebp)
  801f5e:	e8 fa 19 00 00       	call   80395d <alloc_block_NF>
  801f63:	83 c4 10             	add    $0x10,%esp
  801f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f69:	eb 37                	jmp    801fa2 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f6b:	83 ec 0c             	sub    $0xc,%esp
  801f6e:	ff 75 08             	pushl  0x8(%ebp)
  801f71:	e8 a7 07 00 00       	call   80271d <alloc_block_BF>
  801f76:	83 c4 10             	add    $0x10,%esp
  801f79:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f7c:	eb 24                	jmp    801fa2 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f7e:	83 ec 0c             	sub    $0xc,%esp
  801f81:	ff 75 08             	pushl  0x8(%ebp)
  801f84:	e8 b7 19 00 00       	call   803940 <alloc_block_WF>
  801f89:	83 c4 10             	add    $0x10,%esp
  801f8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f8f:	eb 11                	jmp    801fa2 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f91:	83 ec 0c             	sub    $0xc,%esp
  801f94:	68 f4 43 80 00       	push   $0x8043f4
  801f99:	e8 10 e7 ff ff       	call   8006ae <cprintf>
  801f9e:	83 c4 10             	add    $0x10,%esp
		break;
  801fa1:	90                   	nop
	}
	return va;
  801fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	53                   	push   %ebx
  801fab:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801fae:	83 ec 0c             	sub    $0xc,%esp
  801fb1:	68 14 44 80 00       	push   $0x804414
  801fb6:	e8 f3 e6 ff ff       	call   8006ae <cprintf>
  801fbb:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801fbe:	83 ec 0c             	sub    $0xc,%esp
  801fc1:	68 3f 44 80 00       	push   $0x80443f
  801fc6:	e8 e3 e6 ff ff       	call   8006ae <cprintf>
  801fcb:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd4:	eb 37                	jmp    80200d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801fd6:	83 ec 0c             	sub    $0xc,%esp
  801fd9:	ff 75 f4             	pushl  -0xc(%ebp)
  801fdc:	e8 19 ff ff ff       	call   801efa <is_free_block>
  801fe1:	83 c4 10             	add    $0x10,%esp
  801fe4:	0f be d8             	movsbl %al,%ebx
  801fe7:	83 ec 0c             	sub    $0xc,%esp
  801fea:	ff 75 f4             	pushl  -0xc(%ebp)
  801fed:	e8 ef fe ff ff       	call   801ee1 <get_block_size>
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	83 ec 04             	sub    $0x4,%esp
  801ff8:	53                   	push   %ebx
  801ff9:	50                   	push   %eax
  801ffa:	68 57 44 80 00       	push   $0x804457
  801fff:	e8 aa e6 ff ff       	call   8006ae <cprintf>
  802004:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802007:	8b 45 10             	mov    0x10(%ebp),%eax
  80200a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80200d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802011:	74 07                	je     80201a <print_blocks_list+0x73>
  802013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802016:	8b 00                	mov    (%eax),%eax
  802018:	eb 05                	jmp    80201f <print_blocks_list+0x78>
  80201a:	b8 00 00 00 00       	mov    $0x0,%eax
  80201f:	89 45 10             	mov    %eax,0x10(%ebp)
  802022:	8b 45 10             	mov    0x10(%ebp),%eax
  802025:	85 c0                	test   %eax,%eax
  802027:	75 ad                	jne    801fd6 <print_blocks_list+0x2f>
  802029:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202d:	75 a7                	jne    801fd6 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80202f:	83 ec 0c             	sub    $0xc,%esp
  802032:	68 14 44 80 00       	push   $0x804414
  802037:	e8 72 e6 ff ff       	call   8006ae <cprintf>
  80203c:	83 c4 10             	add    $0x10,%esp

}
  80203f:	90                   	nop
  802040:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80204b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204e:	83 e0 01             	and    $0x1,%eax
  802051:	85 c0                	test   %eax,%eax
  802053:	74 03                	je     802058 <initialize_dynamic_allocator+0x13>
  802055:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802058:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80205c:	0f 84 c7 01 00 00    	je     802229 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802062:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802069:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80206c:	8b 55 08             	mov    0x8(%ebp),%edx
  80206f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802072:	01 d0                	add    %edx,%eax
  802074:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802079:	0f 87 ad 01 00 00    	ja     80222c <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	85 c0                	test   %eax,%eax
  802084:	0f 89 a5 01 00 00    	jns    80222f <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80208a:	8b 55 08             	mov    0x8(%ebp),%edx
  80208d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802090:	01 d0                	add    %edx,%eax
  802092:	83 e8 04             	sub    $0x4,%eax
  802095:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80209a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8020a1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a9:	e9 87 00 00 00       	jmp    802135 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8020ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b2:	75 14                	jne    8020c8 <initialize_dynamic_allocator+0x83>
  8020b4:	83 ec 04             	sub    $0x4,%esp
  8020b7:	68 6f 44 80 00       	push   $0x80446f
  8020bc:	6a 79                	push   $0x79
  8020be:	68 8d 44 80 00       	push   $0x80448d
  8020c3:	e8 29 e3 ff ff       	call   8003f1 <_panic>
  8020c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cb:	8b 00                	mov    (%eax),%eax
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	74 10                	je     8020e1 <initialize_dynamic_allocator+0x9c>
  8020d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d4:	8b 00                	mov    (%eax),%eax
  8020d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d9:	8b 52 04             	mov    0x4(%edx),%edx
  8020dc:	89 50 04             	mov    %edx,0x4(%eax)
  8020df:	eb 0b                	jmp    8020ec <initialize_dynamic_allocator+0xa7>
  8020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e4:	8b 40 04             	mov    0x4(%eax),%eax
  8020e7:	a3 30 50 80 00       	mov    %eax,0x805030
  8020ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ef:	8b 40 04             	mov    0x4(%eax),%eax
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	74 0f                	je     802105 <initialize_dynamic_allocator+0xc0>
  8020f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f9:	8b 40 04             	mov    0x4(%eax),%eax
  8020fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ff:	8b 12                	mov    (%edx),%edx
  802101:	89 10                	mov    %edx,(%eax)
  802103:	eb 0a                	jmp    80210f <initialize_dynamic_allocator+0xca>
  802105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802108:	8b 00                	mov    (%eax),%eax
  80210a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80210f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802112:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802122:	a1 38 50 80 00       	mov    0x805038,%eax
  802127:	48                   	dec    %eax
  802128:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80212d:	a1 34 50 80 00       	mov    0x805034,%eax
  802132:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802135:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802139:	74 07                	je     802142 <initialize_dynamic_allocator+0xfd>
  80213b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213e:	8b 00                	mov    (%eax),%eax
  802140:	eb 05                	jmp    802147 <initialize_dynamic_allocator+0x102>
  802142:	b8 00 00 00 00       	mov    $0x0,%eax
  802147:	a3 34 50 80 00       	mov    %eax,0x805034
  80214c:	a1 34 50 80 00       	mov    0x805034,%eax
  802151:	85 c0                	test   %eax,%eax
  802153:	0f 85 55 ff ff ff    	jne    8020ae <initialize_dynamic_allocator+0x69>
  802159:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80215d:	0f 85 4b ff ff ff    	jne    8020ae <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802169:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802172:	a1 44 50 80 00       	mov    0x805044,%eax
  802177:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80217c:	a1 40 50 80 00       	mov    0x805040,%eax
  802181:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	83 c0 08             	add    $0x8,%eax
  80218d:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	83 c0 04             	add    $0x4,%eax
  802196:	8b 55 0c             	mov    0xc(%ebp),%edx
  802199:	83 ea 08             	sub    $0x8,%edx
  80219c:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80219e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	01 d0                	add    %edx,%eax
  8021a6:	83 e8 08             	sub    $0x8,%eax
  8021a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ac:	83 ea 08             	sub    $0x8,%edx
  8021af:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8021b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8021ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8021c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021c8:	75 17                	jne    8021e1 <initialize_dynamic_allocator+0x19c>
  8021ca:	83 ec 04             	sub    $0x4,%esp
  8021cd:	68 a8 44 80 00       	push   $0x8044a8
  8021d2:	68 90 00 00 00       	push   $0x90
  8021d7:	68 8d 44 80 00       	push   $0x80448d
  8021dc:	e8 10 e2 ff ff       	call   8003f1 <_panic>
  8021e1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ea:	89 10                	mov    %edx,(%eax)
  8021ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ef:	8b 00                	mov    (%eax),%eax
  8021f1:	85 c0                	test   %eax,%eax
  8021f3:	74 0d                	je     802202 <initialize_dynamic_allocator+0x1bd>
  8021f5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021fd:	89 50 04             	mov    %edx,0x4(%eax)
  802200:	eb 08                	jmp    80220a <initialize_dynamic_allocator+0x1c5>
  802202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802205:	a3 30 50 80 00       	mov    %eax,0x805030
  80220a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802212:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802215:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80221c:	a1 38 50 80 00       	mov    0x805038,%eax
  802221:	40                   	inc    %eax
  802222:	a3 38 50 80 00       	mov    %eax,0x805038
  802227:	eb 07                	jmp    802230 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802229:	90                   	nop
  80222a:	eb 04                	jmp    802230 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80222c:	90                   	nop
  80222d:	eb 01                	jmp    802230 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80222f:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802235:	8b 45 10             	mov    0x10(%ebp),%eax
  802238:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802241:	8b 45 0c             	mov    0xc(%ebp),%eax
  802244:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	83 e8 04             	sub    $0x4,%eax
  80224c:	8b 00                	mov    (%eax),%eax
  80224e:	83 e0 fe             	and    $0xfffffffe,%eax
  802251:	8d 50 f8             	lea    -0x8(%eax),%edx
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	01 c2                	add    %eax,%edx
  802259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225c:	89 02                	mov    %eax,(%edx)
}
  80225e:	90                   	nop
  80225f:	5d                   	pop    %ebp
  802260:	c3                   	ret    

00802261 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
  802264:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	83 e0 01             	and    $0x1,%eax
  80226d:	85 c0                	test   %eax,%eax
  80226f:	74 03                	je     802274 <alloc_block_FF+0x13>
  802271:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802274:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802278:	77 07                	ja     802281 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80227a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802281:	a1 24 50 80 00       	mov    0x805024,%eax
  802286:	85 c0                	test   %eax,%eax
  802288:	75 73                	jne    8022fd <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	83 c0 10             	add    $0x10,%eax
  802290:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802293:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80229a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80229d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a0:	01 d0                	add    %edx,%eax
  8022a2:	48                   	dec    %eax
  8022a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8022ae:	f7 75 ec             	divl   -0x14(%ebp)
  8022b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b4:	29 d0                	sub    %edx,%eax
  8022b6:	c1 e8 0c             	shr    $0xc,%eax
  8022b9:	83 ec 0c             	sub    $0xc,%esp
  8022bc:	50                   	push   %eax
  8022bd:	e8 86 f1 ff ff       	call   801448 <sbrk>
  8022c2:	83 c4 10             	add    $0x10,%esp
  8022c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8022c8:	83 ec 0c             	sub    $0xc,%esp
  8022cb:	6a 00                	push   $0x0
  8022cd:	e8 76 f1 ff ff       	call   801448 <sbrk>
  8022d2:	83 c4 10             	add    $0x10,%esp
  8022d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8022d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022db:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8022de:	83 ec 08             	sub    $0x8,%esp
  8022e1:	50                   	push   %eax
  8022e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022e5:	e8 5b fd ff ff       	call   802045 <initialize_dynamic_allocator>
  8022ea:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8022ed:	83 ec 0c             	sub    $0xc,%esp
  8022f0:	68 cb 44 80 00       	push   $0x8044cb
  8022f5:	e8 b4 e3 ff ff       	call   8006ae <cprintf>
  8022fa:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8022fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802301:	75 0a                	jne    80230d <alloc_block_FF+0xac>
	        return NULL;
  802303:	b8 00 00 00 00       	mov    $0x0,%eax
  802308:	e9 0e 04 00 00       	jmp    80271b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80230d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802314:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802319:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231c:	e9 f3 02 00 00       	jmp    802614 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802327:	83 ec 0c             	sub    $0xc,%esp
  80232a:	ff 75 bc             	pushl  -0x44(%ebp)
  80232d:	e8 af fb ff ff       	call   801ee1 <get_block_size>
  802332:	83 c4 10             	add    $0x10,%esp
  802335:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	83 c0 08             	add    $0x8,%eax
  80233e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802341:	0f 87 c5 02 00 00    	ja     80260c <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	83 c0 18             	add    $0x18,%eax
  80234d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802350:	0f 87 19 02 00 00    	ja     80256f <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802356:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802359:	2b 45 08             	sub    0x8(%ebp),%eax
  80235c:	83 e8 08             	sub    $0x8,%eax
  80235f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	8d 50 08             	lea    0x8(%eax),%edx
  802368:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80236b:	01 d0                	add    %edx,%eax
  80236d:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802370:	8b 45 08             	mov    0x8(%ebp),%eax
  802373:	83 c0 08             	add    $0x8,%eax
  802376:	83 ec 04             	sub    $0x4,%esp
  802379:	6a 01                	push   $0x1
  80237b:	50                   	push   %eax
  80237c:	ff 75 bc             	pushl  -0x44(%ebp)
  80237f:	e8 ae fe ff ff       	call   802232 <set_block_data>
  802384:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238a:	8b 40 04             	mov    0x4(%eax),%eax
  80238d:	85 c0                	test   %eax,%eax
  80238f:	75 68                	jne    8023f9 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802391:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802395:	75 17                	jne    8023ae <alloc_block_FF+0x14d>
  802397:	83 ec 04             	sub    $0x4,%esp
  80239a:	68 a8 44 80 00       	push   $0x8044a8
  80239f:	68 d7 00 00 00       	push   $0xd7
  8023a4:	68 8d 44 80 00       	push   $0x80448d
  8023a9:	e8 43 e0 ff ff       	call   8003f1 <_panic>
  8023ae:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023b4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b7:	89 10                	mov    %edx,(%eax)
  8023b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023bc:	8b 00                	mov    (%eax),%eax
  8023be:	85 c0                	test   %eax,%eax
  8023c0:	74 0d                	je     8023cf <alloc_block_FF+0x16e>
  8023c2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023c7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023ca:	89 50 04             	mov    %edx,0x4(%eax)
  8023cd:	eb 08                	jmp    8023d7 <alloc_block_FF+0x176>
  8023cf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d2:	a3 30 50 80 00       	mov    %eax,0x805030
  8023d7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023da:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e9:	a1 38 50 80 00       	mov    0x805038,%eax
  8023ee:	40                   	inc    %eax
  8023ef:	a3 38 50 80 00       	mov    %eax,0x805038
  8023f4:	e9 dc 00 00 00       	jmp    8024d5 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	8b 00                	mov    (%eax),%eax
  8023fe:	85 c0                	test   %eax,%eax
  802400:	75 65                	jne    802467 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802402:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802406:	75 17                	jne    80241f <alloc_block_FF+0x1be>
  802408:	83 ec 04             	sub    $0x4,%esp
  80240b:	68 dc 44 80 00       	push   $0x8044dc
  802410:	68 db 00 00 00       	push   $0xdb
  802415:	68 8d 44 80 00       	push   $0x80448d
  80241a:	e8 d2 df ff ff       	call   8003f1 <_panic>
  80241f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802425:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802428:	89 50 04             	mov    %edx,0x4(%eax)
  80242b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80242e:	8b 40 04             	mov    0x4(%eax),%eax
  802431:	85 c0                	test   %eax,%eax
  802433:	74 0c                	je     802441 <alloc_block_FF+0x1e0>
  802435:	a1 30 50 80 00       	mov    0x805030,%eax
  80243a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80243d:	89 10                	mov    %edx,(%eax)
  80243f:	eb 08                	jmp    802449 <alloc_block_FF+0x1e8>
  802441:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802444:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802449:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244c:	a3 30 50 80 00       	mov    %eax,0x805030
  802451:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802454:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80245a:	a1 38 50 80 00       	mov    0x805038,%eax
  80245f:	40                   	inc    %eax
  802460:	a3 38 50 80 00       	mov    %eax,0x805038
  802465:	eb 6e                	jmp    8024d5 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802467:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246b:	74 06                	je     802473 <alloc_block_FF+0x212>
  80246d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802471:	75 17                	jne    80248a <alloc_block_FF+0x229>
  802473:	83 ec 04             	sub    $0x4,%esp
  802476:	68 00 45 80 00       	push   $0x804500
  80247b:	68 df 00 00 00       	push   $0xdf
  802480:	68 8d 44 80 00       	push   $0x80448d
  802485:	e8 67 df ff ff       	call   8003f1 <_panic>
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 10                	mov    (%eax),%edx
  80248f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802492:	89 10                	mov    %edx,(%eax)
  802494:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802497:	8b 00                	mov    (%eax),%eax
  802499:	85 c0                	test   %eax,%eax
  80249b:	74 0b                	je     8024a8 <alloc_block_FF+0x247>
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 00                	mov    (%eax),%eax
  8024a2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024a5:	89 50 04             	mov    %edx,0x4(%eax)
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024ae:	89 10                	mov    %edx,(%eax)
  8024b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b6:	89 50 04             	mov    %edx,0x4(%eax)
  8024b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024bc:	8b 00                	mov    (%eax),%eax
  8024be:	85 c0                	test   %eax,%eax
  8024c0:	75 08                	jne    8024ca <alloc_block_FF+0x269>
  8024c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c5:	a3 30 50 80 00       	mov    %eax,0x805030
  8024ca:	a1 38 50 80 00       	mov    0x805038,%eax
  8024cf:	40                   	inc    %eax
  8024d0:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8024d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d9:	75 17                	jne    8024f2 <alloc_block_FF+0x291>
  8024db:	83 ec 04             	sub    $0x4,%esp
  8024de:	68 6f 44 80 00       	push   $0x80446f
  8024e3:	68 e1 00 00 00       	push   $0xe1
  8024e8:	68 8d 44 80 00       	push   $0x80448d
  8024ed:	e8 ff de ff ff       	call   8003f1 <_panic>
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	8b 00                	mov    (%eax),%eax
  8024f7:	85 c0                	test   %eax,%eax
  8024f9:	74 10                	je     80250b <alloc_block_FF+0x2aa>
  8024fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fe:	8b 00                	mov    (%eax),%eax
  802500:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802503:	8b 52 04             	mov    0x4(%edx),%edx
  802506:	89 50 04             	mov    %edx,0x4(%eax)
  802509:	eb 0b                	jmp    802516 <alloc_block_FF+0x2b5>
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	8b 40 04             	mov    0x4(%eax),%eax
  802511:	a3 30 50 80 00       	mov    %eax,0x805030
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	8b 40 04             	mov    0x4(%eax),%eax
  80251c:	85 c0                	test   %eax,%eax
  80251e:	74 0f                	je     80252f <alloc_block_FF+0x2ce>
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 40 04             	mov    0x4(%eax),%eax
  802526:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802529:	8b 12                	mov    (%edx),%edx
  80252b:	89 10                	mov    %edx,(%eax)
  80252d:	eb 0a                	jmp    802539 <alloc_block_FF+0x2d8>
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	8b 00                	mov    (%eax),%eax
  802534:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80254c:	a1 38 50 80 00       	mov    0x805038,%eax
  802551:	48                   	dec    %eax
  802552:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	6a 00                	push   $0x0
  80255c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80255f:	ff 75 b0             	pushl  -0x50(%ebp)
  802562:	e8 cb fc ff ff       	call   802232 <set_block_data>
  802567:	83 c4 10             	add    $0x10,%esp
  80256a:	e9 95 00 00 00       	jmp    802604 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80256f:	83 ec 04             	sub    $0x4,%esp
  802572:	6a 01                	push   $0x1
  802574:	ff 75 b8             	pushl  -0x48(%ebp)
  802577:	ff 75 bc             	pushl  -0x44(%ebp)
  80257a:	e8 b3 fc ff ff       	call   802232 <set_block_data>
  80257f:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802582:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802586:	75 17                	jne    80259f <alloc_block_FF+0x33e>
  802588:	83 ec 04             	sub    $0x4,%esp
  80258b:	68 6f 44 80 00       	push   $0x80446f
  802590:	68 e8 00 00 00       	push   $0xe8
  802595:	68 8d 44 80 00       	push   $0x80448d
  80259a:	e8 52 de ff ff       	call   8003f1 <_panic>
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	8b 00                	mov    (%eax),%eax
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	74 10                	je     8025b8 <alloc_block_FF+0x357>
  8025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ab:	8b 00                	mov    (%eax),%eax
  8025ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b0:	8b 52 04             	mov    0x4(%edx),%edx
  8025b3:	89 50 04             	mov    %edx,0x4(%eax)
  8025b6:	eb 0b                	jmp    8025c3 <alloc_block_FF+0x362>
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 40 04             	mov    0x4(%eax),%eax
  8025be:	a3 30 50 80 00       	mov    %eax,0x805030
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	8b 40 04             	mov    0x4(%eax),%eax
  8025c9:	85 c0                	test   %eax,%eax
  8025cb:	74 0f                	je     8025dc <alloc_block_FF+0x37b>
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 40 04             	mov    0x4(%eax),%eax
  8025d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d6:	8b 12                	mov    (%edx),%edx
  8025d8:	89 10                	mov    %edx,(%eax)
  8025da:	eb 0a                	jmp    8025e6 <alloc_block_FF+0x385>
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	8b 00                	mov    (%eax),%eax
  8025e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8025fe:	48                   	dec    %eax
  8025ff:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802604:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802607:	e9 0f 01 00 00       	jmp    80271b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80260c:	a1 34 50 80 00       	mov    0x805034,%eax
  802611:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802618:	74 07                	je     802621 <alloc_block_FF+0x3c0>
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	8b 00                	mov    (%eax),%eax
  80261f:	eb 05                	jmp    802626 <alloc_block_FF+0x3c5>
  802621:	b8 00 00 00 00       	mov    $0x0,%eax
  802626:	a3 34 50 80 00       	mov    %eax,0x805034
  80262b:	a1 34 50 80 00       	mov    0x805034,%eax
  802630:	85 c0                	test   %eax,%eax
  802632:	0f 85 e9 fc ff ff    	jne    802321 <alloc_block_FF+0xc0>
  802638:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263c:	0f 85 df fc ff ff    	jne    802321 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802642:	8b 45 08             	mov    0x8(%ebp),%eax
  802645:	83 c0 08             	add    $0x8,%eax
  802648:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80264b:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802652:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802655:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802658:	01 d0                	add    %edx,%eax
  80265a:	48                   	dec    %eax
  80265b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80265e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802661:	ba 00 00 00 00       	mov    $0x0,%edx
  802666:	f7 75 d8             	divl   -0x28(%ebp)
  802669:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80266c:	29 d0                	sub    %edx,%eax
  80266e:	c1 e8 0c             	shr    $0xc,%eax
  802671:	83 ec 0c             	sub    $0xc,%esp
  802674:	50                   	push   %eax
  802675:	e8 ce ed ff ff       	call   801448 <sbrk>
  80267a:	83 c4 10             	add    $0x10,%esp
  80267d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802680:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802684:	75 0a                	jne    802690 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802686:	b8 00 00 00 00       	mov    $0x0,%eax
  80268b:	e9 8b 00 00 00       	jmp    80271b <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802690:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802697:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80269a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80269d:	01 d0                	add    %edx,%eax
  80269f:	48                   	dec    %eax
  8026a0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ab:	f7 75 cc             	divl   -0x34(%ebp)
  8026ae:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026b1:	29 d0                	sub    %edx,%eax
  8026b3:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026b9:	01 d0                	add    %edx,%eax
  8026bb:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8026c0:	a1 40 50 80 00       	mov    0x805040,%eax
  8026c5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8026cb:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8026d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026d8:	01 d0                	add    %edx,%eax
  8026da:	48                   	dec    %eax
  8026db:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8026de:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e6:	f7 75 c4             	divl   -0x3c(%ebp)
  8026e9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026ec:	29 d0                	sub    %edx,%eax
  8026ee:	83 ec 04             	sub    $0x4,%esp
  8026f1:	6a 01                	push   $0x1
  8026f3:	50                   	push   %eax
  8026f4:	ff 75 d0             	pushl  -0x30(%ebp)
  8026f7:	e8 36 fb ff ff       	call   802232 <set_block_data>
  8026fc:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8026ff:	83 ec 0c             	sub    $0xc,%esp
  802702:	ff 75 d0             	pushl  -0x30(%ebp)
  802705:	e8 1b 0a 00 00       	call   803125 <free_block>
  80270a:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80270d:	83 ec 0c             	sub    $0xc,%esp
  802710:	ff 75 08             	pushl  0x8(%ebp)
  802713:	e8 49 fb ff ff       	call   802261 <alloc_block_FF>
  802718:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80271b:	c9                   	leave  
  80271c:	c3                   	ret    

0080271d <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80271d:	55                   	push   %ebp
  80271e:	89 e5                	mov    %esp,%ebp
  802720:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802723:	8b 45 08             	mov    0x8(%ebp),%eax
  802726:	83 e0 01             	and    $0x1,%eax
  802729:	85 c0                	test   %eax,%eax
  80272b:	74 03                	je     802730 <alloc_block_BF+0x13>
  80272d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802730:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802734:	77 07                	ja     80273d <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802736:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80273d:	a1 24 50 80 00       	mov    0x805024,%eax
  802742:	85 c0                	test   %eax,%eax
  802744:	75 73                	jne    8027b9 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802746:	8b 45 08             	mov    0x8(%ebp),%eax
  802749:	83 c0 10             	add    $0x10,%eax
  80274c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80274f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802756:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802759:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80275c:	01 d0                	add    %edx,%eax
  80275e:	48                   	dec    %eax
  80275f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802762:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802765:	ba 00 00 00 00       	mov    $0x0,%edx
  80276a:	f7 75 e0             	divl   -0x20(%ebp)
  80276d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802770:	29 d0                	sub    %edx,%eax
  802772:	c1 e8 0c             	shr    $0xc,%eax
  802775:	83 ec 0c             	sub    $0xc,%esp
  802778:	50                   	push   %eax
  802779:	e8 ca ec ff ff       	call   801448 <sbrk>
  80277e:	83 c4 10             	add    $0x10,%esp
  802781:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802784:	83 ec 0c             	sub    $0xc,%esp
  802787:	6a 00                	push   $0x0
  802789:	e8 ba ec ff ff       	call   801448 <sbrk>
  80278e:	83 c4 10             	add    $0x10,%esp
  802791:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802794:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802797:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80279a:	83 ec 08             	sub    $0x8,%esp
  80279d:	50                   	push   %eax
  80279e:	ff 75 d8             	pushl  -0x28(%ebp)
  8027a1:	e8 9f f8 ff ff       	call   802045 <initialize_dynamic_allocator>
  8027a6:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027a9:	83 ec 0c             	sub    $0xc,%esp
  8027ac:	68 cb 44 80 00       	push   $0x8044cb
  8027b1:	e8 f8 de ff ff       	call   8006ae <cprintf>
  8027b6:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8027b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8027c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8027c7:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8027ce:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8027d5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027dd:	e9 1d 01 00 00       	jmp    8028ff <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8027e8:	83 ec 0c             	sub    $0xc,%esp
  8027eb:	ff 75 a8             	pushl  -0x58(%ebp)
  8027ee:	e8 ee f6 ff ff       	call   801ee1 <get_block_size>
  8027f3:	83 c4 10             	add    $0x10,%esp
  8027f6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	83 c0 08             	add    $0x8,%eax
  8027ff:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802802:	0f 87 ef 00 00 00    	ja     8028f7 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	83 c0 18             	add    $0x18,%eax
  80280e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802811:	77 1d                	ja     802830 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802813:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802816:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802819:	0f 86 d8 00 00 00    	jbe    8028f7 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80281f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802822:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802825:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802828:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80282b:	e9 c7 00 00 00       	jmp    8028f7 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802830:	8b 45 08             	mov    0x8(%ebp),%eax
  802833:	83 c0 08             	add    $0x8,%eax
  802836:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802839:	0f 85 9d 00 00 00    	jne    8028dc <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80283f:	83 ec 04             	sub    $0x4,%esp
  802842:	6a 01                	push   $0x1
  802844:	ff 75 a4             	pushl  -0x5c(%ebp)
  802847:	ff 75 a8             	pushl  -0x58(%ebp)
  80284a:	e8 e3 f9 ff ff       	call   802232 <set_block_data>
  80284f:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802852:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802856:	75 17                	jne    80286f <alloc_block_BF+0x152>
  802858:	83 ec 04             	sub    $0x4,%esp
  80285b:	68 6f 44 80 00       	push   $0x80446f
  802860:	68 2c 01 00 00       	push   $0x12c
  802865:	68 8d 44 80 00       	push   $0x80448d
  80286a:	e8 82 db ff ff       	call   8003f1 <_panic>
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	8b 00                	mov    (%eax),%eax
  802874:	85 c0                	test   %eax,%eax
  802876:	74 10                	je     802888 <alloc_block_BF+0x16b>
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	8b 00                	mov    (%eax),%eax
  80287d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802880:	8b 52 04             	mov    0x4(%edx),%edx
  802883:	89 50 04             	mov    %edx,0x4(%eax)
  802886:	eb 0b                	jmp    802893 <alloc_block_BF+0x176>
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 40 04             	mov    0x4(%eax),%eax
  80288e:	a3 30 50 80 00       	mov    %eax,0x805030
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	8b 40 04             	mov    0x4(%eax),%eax
  802899:	85 c0                	test   %eax,%eax
  80289b:	74 0f                	je     8028ac <alloc_block_BF+0x18f>
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 40 04             	mov    0x4(%eax),%eax
  8028a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a6:	8b 12                	mov    (%edx),%edx
  8028a8:	89 10                	mov    %edx,(%eax)
  8028aa:	eb 0a                	jmp    8028b6 <alloc_block_BF+0x199>
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	8b 00                	mov    (%eax),%eax
  8028b1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8028ce:	48                   	dec    %eax
  8028cf:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8028d4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028d7:	e9 24 04 00 00       	jmp    802d00 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8028dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028df:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028e2:	76 13                	jbe    8028f7 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8028e4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8028eb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8028f1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028f4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8028f7:	a1 34 50 80 00       	mov    0x805034,%eax
  8028fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802903:	74 07                	je     80290c <alloc_block_BF+0x1ef>
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 00                	mov    (%eax),%eax
  80290a:	eb 05                	jmp    802911 <alloc_block_BF+0x1f4>
  80290c:	b8 00 00 00 00       	mov    $0x0,%eax
  802911:	a3 34 50 80 00       	mov    %eax,0x805034
  802916:	a1 34 50 80 00       	mov    0x805034,%eax
  80291b:	85 c0                	test   %eax,%eax
  80291d:	0f 85 bf fe ff ff    	jne    8027e2 <alloc_block_BF+0xc5>
  802923:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802927:	0f 85 b5 fe ff ff    	jne    8027e2 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80292d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802931:	0f 84 26 02 00 00    	je     802b5d <alloc_block_BF+0x440>
  802937:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80293b:	0f 85 1c 02 00 00    	jne    802b5d <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802944:	2b 45 08             	sub    0x8(%ebp),%eax
  802947:	83 e8 08             	sub    $0x8,%eax
  80294a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80294d:	8b 45 08             	mov    0x8(%ebp),%eax
  802950:	8d 50 08             	lea    0x8(%eax),%edx
  802953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802956:	01 d0                	add    %edx,%eax
  802958:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80295b:	8b 45 08             	mov    0x8(%ebp),%eax
  80295e:	83 c0 08             	add    $0x8,%eax
  802961:	83 ec 04             	sub    $0x4,%esp
  802964:	6a 01                	push   $0x1
  802966:	50                   	push   %eax
  802967:	ff 75 f0             	pushl  -0x10(%ebp)
  80296a:	e8 c3 f8 ff ff       	call   802232 <set_block_data>
  80296f:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802975:	8b 40 04             	mov    0x4(%eax),%eax
  802978:	85 c0                	test   %eax,%eax
  80297a:	75 68                	jne    8029e4 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80297c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802980:	75 17                	jne    802999 <alloc_block_BF+0x27c>
  802982:	83 ec 04             	sub    $0x4,%esp
  802985:	68 a8 44 80 00       	push   $0x8044a8
  80298a:	68 45 01 00 00       	push   $0x145
  80298f:	68 8d 44 80 00       	push   $0x80448d
  802994:	e8 58 da ff ff       	call   8003f1 <_panic>
  802999:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80299f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a2:	89 10                	mov    %edx,(%eax)
  8029a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a7:	8b 00                	mov    (%eax),%eax
  8029a9:	85 c0                	test   %eax,%eax
  8029ab:	74 0d                	je     8029ba <alloc_block_BF+0x29d>
  8029ad:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029b2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029b5:	89 50 04             	mov    %edx,0x4(%eax)
  8029b8:	eb 08                	jmp    8029c2 <alloc_block_BF+0x2a5>
  8029ba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8029c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8029d9:	40                   	inc    %eax
  8029da:	a3 38 50 80 00       	mov    %eax,0x805038
  8029df:	e9 dc 00 00 00       	jmp    802ac0 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8029e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	75 65                	jne    802a52 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029ed:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029f1:	75 17                	jne    802a0a <alloc_block_BF+0x2ed>
  8029f3:	83 ec 04             	sub    $0x4,%esp
  8029f6:	68 dc 44 80 00       	push   $0x8044dc
  8029fb:	68 4a 01 00 00       	push   $0x14a
  802a00:	68 8d 44 80 00       	push   $0x80448d
  802a05:	e8 e7 d9 ff ff       	call   8003f1 <_panic>
  802a0a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a10:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a13:	89 50 04             	mov    %edx,0x4(%eax)
  802a16:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a19:	8b 40 04             	mov    0x4(%eax),%eax
  802a1c:	85 c0                	test   %eax,%eax
  802a1e:	74 0c                	je     802a2c <alloc_block_BF+0x30f>
  802a20:	a1 30 50 80 00       	mov    0x805030,%eax
  802a25:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a28:	89 10                	mov    %edx,(%eax)
  802a2a:	eb 08                	jmp    802a34 <alloc_block_BF+0x317>
  802a2c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a2f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a37:	a3 30 50 80 00       	mov    %eax,0x805030
  802a3c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a45:	a1 38 50 80 00       	mov    0x805038,%eax
  802a4a:	40                   	inc    %eax
  802a4b:	a3 38 50 80 00       	mov    %eax,0x805038
  802a50:	eb 6e                	jmp    802ac0 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a56:	74 06                	je     802a5e <alloc_block_BF+0x341>
  802a58:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a5c:	75 17                	jne    802a75 <alloc_block_BF+0x358>
  802a5e:	83 ec 04             	sub    $0x4,%esp
  802a61:	68 00 45 80 00       	push   $0x804500
  802a66:	68 4f 01 00 00       	push   $0x14f
  802a6b:	68 8d 44 80 00       	push   $0x80448d
  802a70:	e8 7c d9 ff ff       	call   8003f1 <_panic>
  802a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a78:	8b 10                	mov    (%eax),%edx
  802a7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7d:	89 10                	mov    %edx,(%eax)
  802a7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a82:	8b 00                	mov    (%eax),%eax
  802a84:	85 c0                	test   %eax,%eax
  802a86:	74 0b                	je     802a93 <alloc_block_BF+0x376>
  802a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8b:	8b 00                	mov    (%eax),%eax
  802a8d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a90:	89 50 04             	mov    %edx,0x4(%eax)
  802a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a96:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a99:	89 10                	mov    %edx,(%eax)
  802a9b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa1:	89 50 04             	mov    %edx,0x4(%eax)
  802aa4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa7:	8b 00                	mov    (%eax),%eax
  802aa9:	85 c0                	test   %eax,%eax
  802aab:	75 08                	jne    802ab5 <alloc_block_BF+0x398>
  802aad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab0:	a3 30 50 80 00       	mov    %eax,0x805030
  802ab5:	a1 38 50 80 00       	mov    0x805038,%eax
  802aba:	40                   	inc    %eax
  802abb:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802ac0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac4:	75 17                	jne    802add <alloc_block_BF+0x3c0>
  802ac6:	83 ec 04             	sub    $0x4,%esp
  802ac9:	68 6f 44 80 00       	push   $0x80446f
  802ace:	68 51 01 00 00       	push   $0x151
  802ad3:	68 8d 44 80 00       	push   $0x80448d
  802ad8:	e8 14 d9 ff ff       	call   8003f1 <_panic>
  802add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae0:	8b 00                	mov    (%eax),%eax
  802ae2:	85 c0                	test   %eax,%eax
  802ae4:	74 10                	je     802af6 <alloc_block_BF+0x3d9>
  802ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aee:	8b 52 04             	mov    0x4(%edx),%edx
  802af1:	89 50 04             	mov    %edx,0x4(%eax)
  802af4:	eb 0b                	jmp    802b01 <alloc_block_BF+0x3e4>
  802af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af9:	8b 40 04             	mov    0x4(%eax),%eax
  802afc:	a3 30 50 80 00       	mov    %eax,0x805030
  802b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b04:	8b 40 04             	mov    0x4(%eax),%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	74 0f                	je     802b1a <alloc_block_BF+0x3fd>
  802b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0e:	8b 40 04             	mov    0x4(%eax),%eax
  802b11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b14:	8b 12                	mov    (%edx),%edx
  802b16:	89 10                	mov    %edx,(%eax)
  802b18:	eb 0a                	jmp    802b24 <alloc_block_BF+0x407>
  802b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1d:	8b 00                	mov    (%eax),%eax
  802b1f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b37:	a1 38 50 80 00       	mov    0x805038,%eax
  802b3c:	48                   	dec    %eax
  802b3d:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b42:	83 ec 04             	sub    $0x4,%esp
  802b45:	6a 00                	push   $0x0
  802b47:	ff 75 d0             	pushl  -0x30(%ebp)
  802b4a:	ff 75 cc             	pushl  -0x34(%ebp)
  802b4d:	e8 e0 f6 ff ff       	call   802232 <set_block_data>
  802b52:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b58:	e9 a3 01 00 00       	jmp    802d00 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802b5d:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b61:	0f 85 9d 00 00 00    	jne    802c04 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b67:	83 ec 04             	sub    $0x4,%esp
  802b6a:	6a 01                	push   $0x1
  802b6c:	ff 75 ec             	pushl  -0x14(%ebp)
  802b6f:	ff 75 f0             	pushl  -0x10(%ebp)
  802b72:	e8 bb f6 ff ff       	call   802232 <set_block_data>
  802b77:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7e:	75 17                	jne    802b97 <alloc_block_BF+0x47a>
  802b80:	83 ec 04             	sub    $0x4,%esp
  802b83:	68 6f 44 80 00       	push   $0x80446f
  802b88:	68 58 01 00 00       	push   $0x158
  802b8d:	68 8d 44 80 00       	push   $0x80448d
  802b92:	e8 5a d8 ff ff       	call   8003f1 <_panic>
  802b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	85 c0                	test   %eax,%eax
  802b9e:	74 10                	je     802bb0 <alloc_block_BF+0x493>
  802ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba3:	8b 00                	mov    (%eax),%eax
  802ba5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba8:	8b 52 04             	mov    0x4(%edx),%edx
  802bab:	89 50 04             	mov    %edx,0x4(%eax)
  802bae:	eb 0b                	jmp    802bbb <alloc_block_BF+0x49e>
  802bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb3:	8b 40 04             	mov    0x4(%eax),%eax
  802bb6:	a3 30 50 80 00       	mov    %eax,0x805030
  802bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbe:	8b 40 04             	mov    0x4(%eax),%eax
  802bc1:	85 c0                	test   %eax,%eax
  802bc3:	74 0f                	je     802bd4 <alloc_block_BF+0x4b7>
  802bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc8:	8b 40 04             	mov    0x4(%eax),%eax
  802bcb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bce:	8b 12                	mov    (%edx),%edx
  802bd0:	89 10                	mov    %edx,(%eax)
  802bd2:	eb 0a                	jmp    802bde <alloc_block_BF+0x4c1>
  802bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd7:	8b 00                	mov    (%eax),%eax
  802bd9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf1:	a1 38 50 80 00       	mov    0x805038,%eax
  802bf6:	48                   	dec    %eax
  802bf7:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bff:	e9 fc 00 00 00       	jmp    802d00 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c04:	8b 45 08             	mov    0x8(%ebp),%eax
  802c07:	83 c0 08             	add    $0x8,%eax
  802c0a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c0d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c14:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c17:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c1a:	01 d0                	add    %edx,%eax
  802c1c:	48                   	dec    %eax
  802c1d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c20:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c23:	ba 00 00 00 00       	mov    $0x0,%edx
  802c28:	f7 75 c4             	divl   -0x3c(%ebp)
  802c2b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c2e:	29 d0                	sub    %edx,%eax
  802c30:	c1 e8 0c             	shr    $0xc,%eax
  802c33:	83 ec 0c             	sub    $0xc,%esp
  802c36:	50                   	push   %eax
  802c37:	e8 0c e8 ff ff       	call   801448 <sbrk>
  802c3c:	83 c4 10             	add    $0x10,%esp
  802c3f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c42:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c46:	75 0a                	jne    802c52 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c48:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4d:	e9 ae 00 00 00       	jmp    802d00 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c52:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c59:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c5c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c5f:	01 d0                	add    %edx,%eax
  802c61:	48                   	dec    %eax
  802c62:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c65:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c68:	ba 00 00 00 00       	mov    $0x0,%edx
  802c6d:	f7 75 b8             	divl   -0x48(%ebp)
  802c70:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c73:	29 d0                	sub    %edx,%eax
  802c75:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c78:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c7b:	01 d0                	add    %edx,%eax
  802c7d:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c82:	a1 40 50 80 00       	mov    0x805040,%eax
  802c87:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802c8d:	83 ec 0c             	sub    $0xc,%esp
  802c90:	68 34 45 80 00       	push   $0x804534
  802c95:	e8 14 da ff ff       	call   8006ae <cprintf>
  802c9a:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802c9d:	83 ec 08             	sub    $0x8,%esp
  802ca0:	ff 75 bc             	pushl  -0x44(%ebp)
  802ca3:	68 39 45 80 00       	push   $0x804539
  802ca8:	e8 01 da ff ff       	call   8006ae <cprintf>
  802cad:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802cb0:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802cb7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cbd:	01 d0                	add    %edx,%eax
  802cbf:	48                   	dec    %eax
  802cc0:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802cc3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cc6:	ba 00 00 00 00       	mov    $0x0,%edx
  802ccb:	f7 75 b0             	divl   -0x50(%ebp)
  802cce:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cd1:	29 d0                	sub    %edx,%eax
  802cd3:	83 ec 04             	sub    $0x4,%esp
  802cd6:	6a 01                	push   $0x1
  802cd8:	50                   	push   %eax
  802cd9:	ff 75 bc             	pushl  -0x44(%ebp)
  802cdc:	e8 51 f5 ff ff       	call   802232 <set_block_data>
  802ce1:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802ce4:	83 ec 0c             	sub    $0xc,%esp
  802ce7:	ff 75 bc             	pushl  -0x44(%ebp)
  802cea:	e8 36 04 00 00       	call   803125 <free_block>
  802cef:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802cf2:	83 ec 0c             	sub    $0xc,%esp
  802cf5:	ff 75 08             	pushl  0x8(%ebp)
  802cf8:	e8 20 fa ff ff       	call   80271d <alloc_block_BF>
  802cfd:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d00:	c9                   	leave  
  802d01:	c3                   	ret    

00802d02 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d02:	55                   	push   %ebp
  802d03:	89 e5                	mov    %esp,%ebp
  802d05:	53                   	push   %ebx
  802d06:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d10:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d1b:	74 1e                	je     802d3b <merging+0x39>
  802d1d:	ff 75 08             	pushl  0x8(%ebp)
  802d20:	e8 bc f1 ff ff       	call   801ee1 <get_block_size>
  802d25:	83 c4 04             	add    $0x4,%esp
  802d28:	89 c2                	mov    %eax,%edx
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	01 d0                	add    %edx,%eax
  802d2f:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d32:	75 07                	jne    802d3b <merging+0x39>
		prev_is_free = 1;
  802d34:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d3f:	74 1e                	je     802d5f <merging+0x5d>
  802d41:	ff 75 10             	pushl  0x10(%ebp)
  802d44:	e8 98 f1 ff ff       	call   801ee1 <get_block_size>
  802d49:	83 c4 04             	add    $0x4,%esp
  802d4c:	89 c2                	mov    %eax,%edx
  802d4e:	8b 45 10             	mov    0x10(%ebp),%eax
  802d51:	01 d0                	add    %edx,%eax
  802d53:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d56:	75 07                	jne    802d5f <merging+0x5d>
		next_is_free = 1;
  802d58:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d63:	0f 84 cc 00 00 00    	je     802e35 <merging+0x133>
  802d69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d6d:	0f 84 c2 00 00 00    	je     802e35 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d73:	ff 75 08             	pushl  0x8(%ebp)
  802d76:	e8 66 f1 ff ff       	call   801ee1 <get_block_size>
  802d7b:	83 c4 04             	add    $0x4,%esp
  802d7e:	89 c3                	mov    %eax,%ebx
  802d80:	ff 75 10             	pushl  0x10(%ebp)
  802d83:	e8 59 f1 ff ff       	call   801ee1 <get_block_size>
  802d88:	83 c4 04             	add    $0x4,%esp
  802d8b:	01 c3                	add    %eax,%ebx
  802d8d:	ff 75 0c             	pushl  0xc(%ebp)
  802d90:	e8 4c f1 ff ff       	call   801ee1 <get_block_size>
  802d95:	83 c4 04             	add    $0x4,%esp
  802d98:	01 d8                	add    %ebx,%eax
  802d9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d9d:	6a 00                	push   $0x0
  802d9f:	ff 75 ec             	pushl  -0x14(%ebp)
  802da2:	ff 75 08             	pushl  0x8(%ebp)
  802da5:	e8 88 f4 ff ff       	call   802232 <set_block_data>
  802daa:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802dad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802db1:	75 17                	jne    802dca <merging+0xc8>
  802db3:	83 ec 04             	sub    $0x4,%esp
  802db6:	68 6f 44 80 00       	push   $0x80446f
  802dbb:	68 7d 01 00 00       	push   $0x17d
  802dc0:	68 8d 44 80 00       	push   $0x80448d
  802dc5:	e8 27 d6 ff ff       	call   8003f1 <_panic>
  802dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dcd:	8b 00                	mov    (%eax),%eax
  802dcf:	85 c0                	test   %eax,%eax
  802dd1:	74 10                	je     802de3 <merging+0xe1>
  802dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd6:	8b 00                	mov    (%eax),%eax
  802dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ddb:	8b 52 04             	mov    0x4(%edx),%edx
  802dde:	89 50 04             	mov    %edx,0x4(%eax)
  802de1:	eb 0b                	jmp    802dee <merging+0xec>
  802de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de6:	8b 40 04             	mov    0x4(%eax),%eax
  802de9:	a3 30 50 80 00       	mov    %eax,0x805030
  802dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df1:	8b 40 04             	mov    0x4(%eax),%eax
  802df4:	85 c0                	test   %eax,%eax
  802df6:	74 0f                	je     802e07 <merging+0x105>
  802df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dfb:	8b 40 04             	mov    0x4(%eax),%eax
  802dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e01:	8b 12                	mov    (%edx),%edx
  802e03:	89 10                	mov    %edx,(%eax)
  802e05:	eb 0a                	jmp    802e11 <merging+0x10f>
  802e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e0a:	8b 00                	mov    (%eax),%eax
  802e0c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e24:	a1 38 50 80 00       	mov    0x805038,%eax
  802e29:	48                   	dec    %eax
  802e2a:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e2f:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e30:	e9 ea 02 00 00       	jmp    80311f <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e39:	74 3b                	je     802e76 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e3b:	83 ec 0c             	sub    $0xc,%esp
  802e3e:	ff 75 08             	pushl  0x8(%ebp)
  802e41:	e8 9b f0 ff ff       	call   801ee1 <get_block_size>
  802e46:	83 c4 10             	add    $0x10,%esp
  802e49:	89 c3                	mov    %eax,%ebx
  802e4b:	83 ec 0c             	sub    $0xc,%esp
  802e4e:	ff 75 10             	pushl  0x10(%ebp)
  802e51:	e8 8b f0 ff ff       	call   801ee1 <get_block_size>
  802e56:	83 c4 10             	add    $0x10,%esp
  802e59:	01 d8                	add    %ebx,%eax
  802e5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e5e:	83 ec 04             	sub    $0x4,%esp
  802e61:	6a 00                	push   $0x0
  802e63:	ff 75 e8             	pushl  -0x18(%ebp)
  802e66:	ff 75 08             	pushl  0x8(%ebp)
  802e69:	e8 c4 f3 ff ff       	call   802232 <set_block_data>
  802e6e:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e71:	e9 a9 02 00 00       	jmp    80311f <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e7a:	0f 84 2d 01 00 00    	je     802fad <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e80:	83 ec 0c             	sub    $0xc,%esp
  802e83:	ff 75 10             	pushl  0x10(%ebp)
  802e86:	e8 56 f0 ff ff       	call   801ee1 <get_block_size>
  802e8b:	83 c4 10             	add    $0x10,%esp
  802e8e:	89 c3                	mov    %eax,%ebx
  802e90:	83 ec 0c             	sub    $0xc,%esp
  802e93:	ff 75 0c             	pushl  0xc(%ebp)
  802e96:	e8 46 f0 ff ff       	call   801ee1 <get_block_size>
  802e9b:	83 c4 10             	add    $0x10,%esp
  802e9e:	01 d8                	add    %ebx,%eax
  802ea0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802ea3:	83 ec 04             	sub    $0x4,%esp
  802ea6:	6a 00                	push   $0x0
  802ea8:	ff 75 e4             	pushl  -0x1c(%ebp)
  802eab:	ff 75 10             	pushl  0x10(%ebp)
  802eae:	e8 7f f3 ff ff       	call   802232 <set_block_data>
  802eb3:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802eb6:	8b 45 10             	mov    0x10(%ebp),%eax
  802eb9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802ebc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ec0:	74 06                	je     802ec8 <merging+0x1c6>
  802ec2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ec6:	75 17                	jne    802edf <merging+0x1dd>
  802ec8:	83 ec 04             	sub    $0x4,%esp
  802ecb:	68 48 45 80 00       	push   $0x804548
  802ed0:	68 8d 01 00 00       	push   $0x18d
  802ed5:	68 8d 44 80 00       	push   $0x80448d
  802eda:	e8 12 d5 ff ff       	call   8003f1 <_panic>
  802edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee2:	8b 50 04             	mov    0x4(%eax),%edx
  802ee5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee8:	89 50 04             	mov    %edx,0x4(%eax)
  802eeb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eee:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ef1:	89 10                	mov    %edx,(%eax)
  802ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef6:	8b 40 04             	mov    0x4(%eax),%eax
  802ef9:	85 c0                	test   %eax,%eax
  802efb:	74 0d                	je     802f0a <merging+0x208>
  802efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f00:	8b 40 04             	mov    0x4(%eax),%eax
  802f03:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f06:	89 10                	mov    %edx,(%eax)
  802f08:	eb 08                	jmp    802f12 <merging+0x210>
  802f0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f0d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f15:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f18:	89 50 04             	mov    %edx,0x4(%eax)
  802f1b:	a1 38 50 80 00       	mov    0x805038,%eax
  802f20:	40                   	inc    %eax
  802f21:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f2a:	75 17                	jne    802f43 <merging+0x241>
  802f2c:	83 ec 04             	sub    $0x4,%esp
  802f2f:	68 6f 44 80 00       	push   $0x80446f
  802f34:	68 8e 01 00 00       	push   $0x18e
  802f39:	68 8d 44 80 00       	push   $0x80448d
  802f3e:	e8 ae d4 ff ff       	call   8003f1 <_panic>
  802f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f46:	8b 00                	mov    (%eax),%eax
  802f48:	85 c0                	test   %eax,%eax
  802f4a:	74 10                	je     802f5c <merging+0x25a>
  802f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4f:	8b 00                	mov    (%eax),%eax
  802f51:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f54:	8b 52 04             	mov    0x4(%edx),%edx
  802f57:	89 50 04             	mov    %edx,0x4(%eax)
  802f5a:	eb 0b                	jmp    802f67 <merging+0x265>
  802f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5f:	8b 40 04             	mov    0x4(%eax),%eax
  802f62:	a3 30 50 80 00       	mov    %eax,0x805030
  802f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6a:	8b 40 04             	mov    0x4(%eax),%eax
  802f6d:	85 c0                	test   %eax,%eax
  802f6f:	74 0f                	je     802f80 <merging+0x27e>
  802f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f74:	8b 40 04             	mov    0x4(%eax),%eax
  802f77:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f7a:	8b 12                	mov    (%edx),%edx
  802f7c:	89 10                	mov    %edx,(%eax)
  802f7e:	eb 0a                	jmp    802f8a <merging+0x288>
  802f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f83:	8b 00                	mov    (%eax),%eax
  802f85:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f93:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9d:	a1 38 50 80 00       	mov    0x805038,%eax
  802fa2:	48                   	dec    %eax
  802fa3:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fa8:	e9 72 01 00 00       	jmp    80311f <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802fad:	8b 45 10             	mov    0x10(%ebp),%eax
  802fb0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802fb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb7:	74 79                	je     803032 <merging+0x330>
  802fb9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fbd:	74 73                	je     803032 <merging+0x330>
  802fbf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc3:	74 06                	je     802fcb <merging+0x2c9>
  802fc5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fc9:	75 17                	jne    802fe2 <merging+0x2e0>
  802fcb:	83 ec 04             	sub    $0x4,%esp
  802fce:	68 00 45 80 00       	push   $0x804500
  802fd3:	68 94 01 00 00       	push   $0x194
  802fd8:	68 8d 44 80 00       	push   $0x80448d
  802fdd:	e8 0f d4 ff ff       	call   8003f1 <_panic>
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	8b 10                	mov    (%eax),%edx
  802fe7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fea:	89 10                	mov    %edx,(%eax)
  802fec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fef:	8b 00                	mov    (%eax),%eax
  802ff1:	85 c0                	test   %eax,%eax
  802ff3:	74 0b                	je     803000 <merging+0x2fe>
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	8b 00                	mov    (%eax),%eax
  802ffa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ffd:	89 50 04             	mov    %edx,0x4(%eax)
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803006:	89 10                	mov    %edx,(%eax)
  803008:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300b:	8b 55 08             	mov    0x8(%ebp),%edx
  80300e:	89 50 04             	mov    %edx,0x4(%eax)
  803011:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803014:	8b 00                	mov    (%eax),%eax
  803016:	85 c0                	test   %eax,%eax
  803018:	75 08                	jne    803022 <merging+0x320>
  80301a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80301d:	a3 30 50 80 00       	mov    %eax,0x805030
  803022:	a1 38 50 80 00       	mov    0x805038,%eax
  803027:	40                   	inc    %eax
  803028:	a3 38 50 80 00       	mov    %eax,0x805038
  80302d:	e9 ce 00 00 00       	jmp    803100 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803032:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803036:	74 65                	je     80309d <merging+0x39b>
  803038:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80303c:	75 17                	jne    803055 <merging+0x353>
  80303e:	83 ec 04             	sub    $0x4,%esp
  803041:	68 dc 44 80 00       	push   $0x8044dc
  803046:	68 95 01 00 00       	push   $0x195
  80304b:	68 8d 44 80 00       	push   $0x80448d
  803050:	e8 9c d3 ff ff       	call   8003f1 <_panic>
  803055:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80305b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305e:	89 50 04             	mov    %edx,0x4(%eax)
  803061:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803064:	8b 40 04             	mov    0x4(%eax),%eax
  803067:	85 c0                	test   %eax,%eax
  803069:	74 0c                	je     803077 <merging+0x375>
  80306b:	a1 30 50 80 00       	mov    0x805030,%eax
  803070:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803073:	89 10                	mov    %edx,(%eax)
  803075:	eb 08                	jmp    80307f <merging+0x37d>
  803077:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80307f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803082:	a3 30 50 80 00       	mov    %eax,0x805030
  803087:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80308a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803090:	a1 38 50 80 00       	mov    0x805038,%eax
  803095:	40                   	inc    %eax
  803096:	a3 38 50 80 00       	mov    %eax,0x805038
  80309b:	eb 63                	jmp    803100 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80309d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030a1:	75 17                	jne    8030ba <merging+0x3b8>
  8030a3:	83 ec 04             	sub    $0x4,%esp
  8030a6:	68 a8 44 80 00       	push   $0x8044a8
  8030ab:	68 98 01 00 00       	push   $0x198
  8030b0:	68 8d 44 80 00       	push   $0x80448d
  8030b5:	e8 37 d3 ff ff       	call   8003f1 <_panic>
  8030ba:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8030c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c3:	89 10                	mov    %edx,(%eax)
  8030c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c8:	8b 00                	mov    (%eax),%eax
  8030ca:	85 c0                	test   %eax,%eax
  8030cc:	74 0d                	je     8030db <merging+0x3d9>
  8030ce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030d6:	89 50 04             	mov    %edx,0x4(%eax)
  8030d9:	eb 08                	jmp    8030e3 <merging+0x3e1>
  8030db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030de:	a3 30 50 80 00       	mov    %eax,0x805030
  8030e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f5:	a1 38 50 80 00       	mov    0x805038,%eax
  8030fa:	40                   	inc    %eax
  8030fb:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803100:	83 ec 0c             	sub    $0xc,%esp
  803103:	ff 75 10             	pushl  0x10(%ebp)
  803106:	e8 d6 ed ff ff       	call   801ee1 <get_block_size>
  80310b:	83 c4 10             	add    $0x10,%esp
  80310e:	83 ec 04             	sub    $0x4,%esp
  803111:	6a 00                	push   $0x0
  803113:	50                   	push   %eax
  803114:	ff 75 10             	pushl  0x10(%ebp)
  803117:	e8 16 f1 ff ff       	call   802232 <set_block_data>
  80311c:	83 c4 10             	add    $0x10,%esp
	}
}
  80311f:	90                   	nop
  803120:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803123:	c9                   	leave  
  803124:	c3                   	ret    

00803125 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803125:	55                   	push   %ebp
  803126:	89 e5                	mov    %esp,%ebp
  803128:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80312b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803130:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803133:	a1 30 50 80 00       	mov    0x805030,%eax
  803138:	3b 45 08             	cmp    0x8(%ebp),%eax
  80313b:	73 1b                	jae    803158 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80313d:	a1 30 50 80 00       	mov    0x805030,%eax
  803142:	83 ec 04             	sub    $0x4,%esp
  803145:	ff 75 08             	pushl  0x8(%ebp)
  803148:	6a 00                	push   $0x0
  80314a:	50                   	push   %eax
  80314b:	e8 b2 fb ff ff       	call   802d02 <merging>
  803150:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803153:	e9 8b 00 00 00       	jmp    8031e3 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803158:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80315d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803160:	76 18                	jbe    80317a <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803162:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803167:	83 ec 04             	sub    $0x4,%esp
  80316a:	ff 75 08             	pushl  0x8(%ebp)
  80316d:	50                   	push   %eax
  80316e:	6a 00                	push   $0x0
  803170:	e8 8d fb ff ff       	call   802d02 <merging>
  803175:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803178:	eb 69                	jmp    8031e3 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80317a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80317f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803182:	eb 39                	jmp    8031bd <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803187:	3b 45 08             	cmp    0x8(%ebp),%eax
  80318a:	73 29                	jae    8031b5 <free_block+0x90>
  80318c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318f:	8b 00                	mov    (%eax),%eax
  803191:	3b 45 08             	cmp    0x8(%ebp),%eax
  803194:	76 1f                	jbe    8031b5 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803199:	8b 00                	mov    (%eax),%eax
  80319b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80319e:	83 ec 04             	sub    $0x4,%esp
  8031a1:	ff 75 08             	pushl  0x8(%ebp)
  8031a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8031a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8031aa:	e8 53 fb ff ff       	call   802d02 <merging>
  8031af:	83 c4 10             	add    $0x10,%esp
			break;
  8031b2:	90                   	nop
		}
	}
}
  8031b3:	eb 2e                	jmp    8031e3 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031b5:	a1 34 50 80 00       	mov    0x805034,%eax
  8031ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c1:	74 07                	je     8031ca <free_block+0xa5>
  8031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c6:	8b 00                	mov    (%eax),%eax
  8031c8:	eb 05                	jmp    8031cf <free_block+0xaa>
  8031ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8031cf:	a3 34 50 80 00       	mov    %eax,0x805034
  8031d4:	a1 34 50 80 00       	mov    0x805034,%eax
  8031d9:	85 c0                	test   %eax,%eax
  8031db:	75 a7                	jne    803184 <free_block+0x5f>
  8031dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e1:	75 a1                	jne    803184 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031e3:	90                   	nop
  8031e4:	c9                   	leave  
  8031e5:	c3                   	ret    

008031e6 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8031e6:	55                   	push   %ebp
  8031e7:	89 e5                	mov    %esp,%ebp
  8031e9:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8031ec:	ff 75 08             	pushl  0x8(%ebp)
  8031ef:	e8 ed ec ff ff       	call   801ee1 <get_block_size>
  8031f4:	83 c4 04             	add    $0x4,%esp
  8031f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8031fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803201:	eb 17                	jmp    80321a <copy_data+0x34>
  803203:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803206:	8b 45 0c             	mov    0xc(%ebp),%eax
  803209:	01 c2                	add    %eax,%edx
  80320b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80320e:	8b 45 08             	mov    0x8(%ebp),%eax
  803211:	01 c8                	add    %ecx,%eax
  803213:	8a 00                	mov    (%eax),%al
  803215:	88 02                	mov    %al,(%edx)
  803217:	ff 45 fc             	incl   -0x4(%ebp)
  80321a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80321d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803220:	72 e1                	jb     803203 <copy_data+0x1d>
}
  803222:	90                   	nop
  803223:	c9                   	leave  
  803224:	c3                   	ret    

00803225 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803225:	55                   	push   %ebp
  803226:	89 e5                	mov    %esp,%ebp
  803228:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80322b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80322f:	75 23                	jne    803254 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803231:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803235:	74 13                	je     80324a <realloc_block_FF+0x25>
  803237:	83 ec 0c             	sub    $0xc,%esp
  80323a:	ff 75 0c             	pushl  0xc(%ebp)
  80323d:	e8 1f f0 ff ff       	call   802261 <alloc_block_FF>
  803242:	83 c4 10             	add    $0x10,%esp
  803245:	e9 f4 06 00 00       	jmp    80393e <realloc_block_FF+0x719>
		return NULL;
  80324a:	b8 00 00 00 00       	mov    $0x0,%eax
  80324f:	e9 ea 06 00 00       	jmp    80393e <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803254:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803258:	75 18                	jne    803272 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80325a:	83 ec 0c             	sub    $0xc,%esp
  80325d:	ff 75 08             	pushl  0x8(%ebp)
  803260:	e8 c0 fe ff ff       	call   803125 <free_block>
  803265:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803268:	b8 00 00 00 00       	mov    $0x0,%eax
  80326d:	e9 cc 06 00 00       	jmp    80393e <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803272:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803276:	77 07                	ja     80327f <realloc_block_FF+0x5a>
  803278:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80327f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803282:	83 e0 01             	and    $0x1,%eax
  803285:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80328b:	83 c0 08             	add    $0x8,%eax
  80328e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803291:	83 ec 0c             	sub    $0xc,%esp
  803294:	ff 75 08             	pushl  0x8(%ebp)
  803297:	e8 45 ec ff ff       	call   801ee1 <get_block_size>
  80329c:	83 c4 10             	add    $0x10,%esp
  80329f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a5:	83 e8 08             	sub    $0x8,%eax
  8032a8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8032ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ae:	83 e8 04             	sub    $0x4,%eax
  8032b1:	8b 00                	mov    (%eax),%eax
  8032b3:	83 e0 fe             	and    $0xfffffffe,%eax
  8032b6:	89 c2                	mov    %eax,%edx
  8032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bb:	01 d0                	add    %edx,%eax
  8032bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8032c0:	83 ec 0c             	sub    $0xc,%esp
  8032c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032c6:	e8 16 ec ff ff       	call   801ee1 <get_block_size>
  8032cb:	83 c4 10             	add    $0x10,%esp
  8032ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032d4:	83 e8 08             	sub    $0x8,%eax
  8032d7:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8032da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032dd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032e0:	75 08                	jne    8032ea <realloc_block_FF+0xc5>
	{
		 return va;
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	e9 54 06 00 00       	jmp    80393e <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8032ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ed:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032f0:	0f 83 e5 03 00 00    	jae    8036db <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8032f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f9:	2b 45 0c             	sub    0xc(%ebp),%eax
  8032fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8032ff:	83 ec 0c             	sub    $0xc,%esp
  803302:	ff 75 e4             	pushl  -0x1c(%ebp)
  803305:	e8 f0 eb ff ff       	call   801efa <is_free_block>
  80330a:	83 c4 10             	add    $0x10,%esp
  80330d:	84 c0                	test   %al,%al
  80330f:	0f 84 3b 01 00 00    	je     803450 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803315:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803318:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80331b:	01 d0                	add    %edx,%eax
  80331d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803320:	83 ec 04             	sub    $0x4,%esp
  803323:	6a 01                	push   $0x1
  803325:	ff 75 f0             	pushl  -0x10(%ebp)
  803328:	ff 75 08             	pushl  0x8(%ebp)
  80332b:	e8 02 ef ff ff       	call   802232 <set_block_data>
  803330:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	83 e8 04             	sub    $0x4,%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	83 e0 fe             	and    $0xfffffffe,%eax
  80333e:	89 c2                	mov    %eax,%edx
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	01 d0                	add    %edx,%eax
  803345:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803348:	83 ec 04             	sub    $0x4,%esp
  80334b:	6a 00                	push   $0x0
  80334d:	ff 75 cc             	pushl  -0x34(%ebp)
  803350:	ff 75 c8             	pushl  -0x38(%ebp)
  803353:	e8 da ee ff ff       	call   802232 <set_block_data>
  803358:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80335b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80335f:	74 06                	je     803367 <realloc_block_FF+0x142>
  803361:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803365:	75 17                	jne    80337e <realloc_block_FF+0x159>
  803367:	83 ec 04             	sub    $0x4,%esp
  80336a:	68 00 45 80 00       	push   $0x804500
  80336f:	68 f6 01 00 00       	push   $0x1f6
  803374:	68 8d 44 80 00       	push   $0x80448d
  803379:	e8 73 d0 ff ff       	call   8003f1 <_panic>
  80337e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803381:	8b 10                	mov    (%eax),%edx
  803383:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803386:	89 10                	mov    %edx,(%eax)
  803388:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80338b:	8b 00                	mov    (%eax),%eax
  80338d:	85 c0                	test   %eax,%eax
  80338f:	74 0b                	je     80339c <realloc_block_FF+0x177>
  803391:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803394:	8b 00                	mov    (%eax),%eax
  803396:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803399:	89 50 04             	mov    %edx,0x4(%eax)
  80339c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80339f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033a2:	89 10                	mov    %edx,(%eax)
  8033a4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033aa:	89 50 04             	mov    %edx,0x4(%eax)
  8033ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033b0:	8b 00                	mov    (%eax),%eax
  8033b2:	85 c0                	test   %eax,%eax
  8033b4:	75 08                	jne    8033be <realloc_block_FF+0x199>
  8033b6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8033be:	a1 38 50 80 00       	mov    0x805038,%eax
  8033c3:	40                   	inc    %eax
  8033c4:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8033c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033cd:	75 17                	jne    8033e6 <realloc_block_FF+0x1c1>
  8033cf:	83 ec 04             	sub    $0x4,%esp
  8033d2:	68 6f 44 80 00       	push   $0x80446f
  8033d7:	68 f7 01 00 00       	push   $0x1f7
  8033dc:	68 8d 44 80 00       	push   $0x80448d
  8033e1:	e8 0b d0 ff ff       	call   8003f1 <_panic>
  8033e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e9:	8b 00                	mov    (%eax),%eax
  8033eb:	85 c0                	test   %eax,%eax
  8033ed:	74 10                	je     8033ff <realloc_block_FF+0x1da>
  8033ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f2:	8b 00                	mov    (%eax),%eax
  8033f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033f7:	8b 52 04             	mov    0x4(%edx),%edx
  8033fa:	89 50 04             	mov    %edx,0x4(%eax)
  8033fd:	eb 0b                	jmp    80340a <realloc_block_FF+0x1e5>
  8033ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803402:	8b 40 04             	mov    0x4(%eax),%eax
  803405:	a3 30 50 80 00       	mov    %eax,0x805030
  80340a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340d:	8b 40 04             	mov    0x4(%eax),%eax
  803410:	85 c0                	test   %eax,%eax
  803412:	74 0f                	je     803423 <realloc_block_FF+0x1fe>
  803414:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803417:	8b 40 04             	mov    0x4(%eax),%eax
  80341a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80341d:	8b 12                	mov    (%edx),%edx
  80341f:	89 10                	mov    %edx,(%eax)
  803421:	eb 0a                	jmp    80342d <realloc_block_FF+0x208>
  803423:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803426:	8b 00                	mov    (%eax),%eax
  803428:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80342d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803430:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803436:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803439:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803440:	a1 38 50 80 00       	mov    0x805038,%eax
  803445:	48                   	dec    %eax
  803446:	a3 38 50 80 00       	mov    %eax,0x805038
  80344b:	e9 83 02 00 00       	jmp    8036d3 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803450:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803454:	0f 86 69 02 00 00    	jbe    8036c3 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80345a:	83 ec 04             	sub    $0x4,%esp
  80345d:	6a 01                	push   $0x1
  80345f:	ff 75 f0             	pushl  -0x10(%ebp)
  803462:	ff 75 08             	pushl  0x8(%ebp)
  803465:	e8 c8 ed ff ff       	call   802232 <set_block_data>
  80346a:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	83 e8 04             	sub    $0x4,%eax
  803473:	8b 00                	mov    (%eax),%eax
  803475:	83 e0 fe             	and    $0xfffffffe,%eax
  803478:	89 c2                	mov    %eax,%edx
  80347a:	8b 45 08             	mov    0x8(%ebp),%eax
  80347d:	01 d0                	add    %edx,%eax
  80347f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803482:	a1 38 50 80 00       	mov    0x805038,%eax
  803487:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80348a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80348e:	75 68                	jne    8034f8 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803490:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803494:	75 17                	jne    8034ad <realloc_block_FF+0x288>
  803496:	83 ec 04             	sub    $0x4,%esp
  803499:	68 a8 44 80 00       	push   $0x8044a8
  80349e:	68 06 02 00 00       	push   $0x206
  8034a3:	68 8d 44 80 00       	push   $0x80448d
  8034a8:	e8 44 cf ff ff       	call   8003f1 <_panic>
  8034ad:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b6:	89 10                	mov    %edx,(%eax)
  8034b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034bb:	8b 00                	mov    (%eax),%eax
  8034bd:	85 c0                	test   %eax,%eax
  8034bf:	74 0d                	je     8034ce <realloc_block_FF+0x2a9>
  8034c1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034c9:	89 50 04             	mov    %edx,0x4(%eax)
  8034cc:	eb 08                	jmp    8034d6 <realloc_block_FF+0x2b1>
  8034ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d1:	a3 30 50 80 00       	mov    %eax,0x805030
  8034d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e8:	a1 38 50 80 00       	mov    0x805038,%eax
  8034ed:	40                   	inc    %eax
  8034ee:	a3 38 50 80 00       	mov    %eax,0x805038
  8034f3:	e9 b0 01 00 00       	jmp    8036a8 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8034f8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034fd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803500:	76 68                	jbe    80356a <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803502:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803506:	75 17                	jne    80351f <realloc_block_FF+0x2fa>
  803508:	83 ec 04             	sub    $0x4,%esp
  80350b:	68 a8 44 80 00       	push   $0x8044a8
  803510:	68 0b 02 00 00       	push   $0x20b
  803515:	68 8d 44 80 00       	push   $0x80448d
  80351a:	e8 d2 ce ff ff       	call   8003f1 <_panic>
  80351f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803525:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803528:	89 10                	mov    %edx,(%eax)
  80352a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352d:	8b 00                	mov    (%eax),%eax
  80352f:	85 c0                	test   %eax,%eax
  803531:	74 0d                	je     803540 <realloc_block_FF+0x31b>
  803533:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803538:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80353b:	89 50 04             	mov    %edx,0x4(%eax)
  80353e:	eb 08                	jmp    803548 <realloc_block_FF+0x323>
  803540:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803543:	a3 30 50 80 00       	mov    %eax,0x805030
  803548:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803550:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803553:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80355a:	a1 38 50 80 00       	mov    0x805038,%eax
  80355f:	40                   	inc    %eax
  803560:	a3 38 50 80 00       	mov    %eax,0x805038
  803565:	e9 3e 01 00 00       	jmp    8036a8 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80356a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80356f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803572:	73 68                	jae    8035dc <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803574:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803578:	75 17                	jne    803591 <realloc_block_FF+0x36c>
  80357a:	83 ec 04             	sub    $0x4,%esp
  80357d:	68 dc 44 80 00       	push   $0x8044dc
  803582:	68 10 02 00 00       	push   $0x210
  803587:	68 8d 44 80 00       	push   $0x80448d
  80358c:	e8 60 ce ff ff       	call   8003f1 <_panic>
  803591:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803597:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359a:	89 50 04             	mov    %edx,0x4(%eax)
  80359d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a0:	8b 40 04             	mov    0x4(%eax),%eax
  8035a3:	85 c0                	test   %eax,%eax
  8035a5:	74 0c                	je     8035b3 <realloc_block_FF+0x38e>
  8035a7:	a1 30 50 80 00       	mov    0x805030,%eax
  8035ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035af:	89 10                	mov    %edx,(%eax)
  8035b1:	eb 08                	jmp    8035bb <realloc_block_FF+0x396>
  8035b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035be:	a3 30 50 80 00       	mov    %eax,0x805030
  8035c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035cc:	a1 38 50 80 00       	mov    0x805038,%eax
  8035d1:	40                   	inc    %eax
  8035d2:	a3 38 50 80 00       	mov    %eax,0x805038
  8035d7:	e9 cc 00 00 00       	jmp    8036a8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8035dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8035e3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035eb:	e9 8a 00 00 00       	jmp    80367a <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8035f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035f6:	73 7a                	jae    803672 <realloc_block_FF+0x44d>
  8035f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fb:	8b 00                	mov    (%eax),%eax
  8035fd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803600:	73 70                	jae    803672 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803606:	74 06                	je     80360e <realloc_block_FF+0x3e9>
  803608:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80360c:	75 17                	jne    803625 <realloc_block_FF+0x400>
  80360e:	83 ec 04             	sub    $0x4,%esp
  803611:	68 00 45 80 00       	push   $0x804500
  803616:	68 1a 02 00 00       	push   $0x21a
  80361b:	68 8d 44 80 00       	push   $0x80448d
  803620:	e8 cc cd ff ff       	call   8003f1 <_panic>
  803625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803628:	8b 10                	mov    (%eax),%edx
  80362a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362d:	89 10                	mov    %edx,(%eax)
  80362f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803632:	8b 00                	mov    (%eax),%eax
  803634:	85 c0                	test   %eax,%eax
  803636:	74 0b                	je     803643 <realloc_block_FF+0x41e>
  803638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363b:	8b 00                	mov    (%eax),%eax
  80363d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803640:	89 50 04             	mov    %edx,0x4(%eax)
  803643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803646:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803649:	89 10                	mov    %edx,(%eax)
  80364b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803651:	89 50 04             	mov    %edx,0x4(%eax)
  803654:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803657:	8b 00                	mov    (%eax),%eax
  803659:	85 c0                	test   %eax,%eax
  80365b:	75 08                	jne    803665 <realloc_block_FF+0x440>
  80365d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803660:	a3 30 50 80 00       	mov    %eax,0x805030
  803665:	a1 38 50 80 00       	mov    0x805038,%eax
  80366a:	40                   	inc    %eax
  80366b:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803670:	eb 36                	jmp    8036a8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803672:	a1 34 50 80 00       	mov    0x805034,%eax
  803677:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80367a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80367e:	74 07                	je     803687 <realloc_block_FF+0x462>
  803680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803683:	8b 00                	mov    (%eax),%eax
  803685:	eb 05                	jmp    80368c <realloc_block_FF+0x467>
  803687:	b8 00 00 00 00       	mov    $0x0,%eax
  80368c:	a3 34 50 80 00       	mov    %eax,0x805034
  803691:	a1 34 50 80 00       	mov    0x805034,%eax
  803696:	85 c0                	test   %eax,%eax
  803698:	0f 85 52 ff ff ff    	jne    8035f0 <realloc_block_FF+0x3cb>
  80369e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a2:	0f 85 48 ff ff ff    	jne    8035f0 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8036a8:	83 ec 04             	sub    $0x4,%esp
  8036ab:	6a 00                	push   $0x0
  8036ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8036b0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8036b3:	e8 7a eb ff ff       	call   802232 <set_block_data>
  8036b8:	83 c4 10             	add    $0x10,%esp
				return va;
  8036bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036be:	e9 7b 02 00 00       	jmp    80393e <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8036c3:	83 ec 0c             	sub    $0xc,%esp
  8036c6:	68 7d 45 80 00       	push   $0x80457d
  8036cb:	e8 de cf ff ff       	call   8006ae <cprintf>
  8036d0:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8036d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d6:	e9 63 02 00 00       	jmp    80393e <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8036db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036de:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036e1:	0f 86 4d 02 00 00    	jbe    803934 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8036e7:	83 ec 0c             	sub    $0xc,%esp
  8036ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036ed:	e8 08 e8 ff ff       	call   801efa <is_free_block>
  8036f2:	83 c4 10             	add    $0x10,%esp
  8036f5:	84 c0                	test   %al,%al
  8036f7:	0f 84 37 02 00 00    	je     803934 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8036fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803700:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803703:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803706:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803709:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80370c:	76 38                	jbe    803746 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80370e:	83 ec 0c             	sub    $0xc,%esp
  803711:	ff 75 08             	pushl  0x8(%ebp)
  803714:	e8 0c fa ff ff       	call   803125 <free_block>
  803719:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80371c:	83 ec 0c             	sub    $0xc,%esp
  80371f:	ff 75 0c             	pushl  0xc(%ebp)
  803722:	e8 3a eb ff ff       	call   802261 <alloc_block_FF>
  803727:	83 c4 10             	add    $0x10,%esp
  80372a:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80372d:	83 ec 08             	sub    $0x8,%esp
  803730:	ff 75 c0             	pushl  -0x40(%ebp)
  803733:	ff 75 08             	pushl  0x8(%ebp)
  803736:	e8 ab fa ff ff       	call   8031e6 <copy_data>
  80373b:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80373e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803741:	e9 f8 01 00 00       	jmp    80393e <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803746:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803749:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80374c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80374f:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803753:	0f 87 a0 00 00 00    	ja     8037f9 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803759:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80375d:	75 17                	jne    803776 <realloc_block_FF+0x551>
  80375f:	83 ec 04             	sub    $0x4,%esp
  803762:	68 6f 44 80 00       	push   $0x80446f
  803767:	68 38 02 00 00       	push   $0x238
  80376c:	68 8d 44 80 00       	push   $0x80448d
  803771:	e8 7b cc ff ff       	call   8003f1 <_panic>
  803776:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803779:	8b 00                	mov    (%eax),%eax
  80377b:	85 c0                	test   %eax,%eax
  80377d:	74 10                	je     80378f <realloc_block_FF+0x56a>
  80377f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803782:	8b 00                	mov    (%eax),%eax
  803784:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803787:	8b 52 04             	mov    0x4(%edx),%edx
  80378a:	89 50 04             	mov    %edx,0x4(%eax)
  80378d:	eb 0b                	jmp    80379a <realloc_block_FF+0x575>
  80378f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803792:	8b 40 04             	mov    0x4(%eax),%eax
  803795:	a3 30 50 80 00       	mov    %eax,0x805030
  80379a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379d:	8b 40 04             	mov    0x4(%eax),%eax
  8037a0:	85 c0                	test   %eax,%eax
  8037a2:	74 0f                	je     8037b3 <realloc_block_FF+0x58e>
  8037a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a7:	8b 40 04             	mov    0x4(%eax),%eax
  8037aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037ad:	8b 12                	mov    (%edx),%edx
  8037af:	89 10                	mov    %edx,(%eax)
  8037b1:	eb 0a                	jmp    8037bd <realloc_block_FF+0x598>
  8037b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b6:	8b 00                	mov    (%eax),%eax
  8037b8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8037d5:	48                   	dec    %eax
  8037d6:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8037db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e1:	01 d0                	add    %edx,%eax
  8037e3:	83 ec 04             	sub    $0x4,%esp
  8037e6:	6a 01                	push   $0x1
  8037e8:	50                   	push   %eax
  8037e9:	ff 75 08             	pushl  0x8(%ebp)
  8037ec:	e8 41 ea ff ff       	call   802232 <set_block_data>
  8037f1:	83 c4 10             	add    $0x10,%esp
  8037f4:	e9 36 01 00 00       	jmp    80392f <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8037f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037fc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037ff:	01 d0                	add    %edx,%eax
  803801:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803804:	83 ec 04             	sub    $0x4,%esp
  803807:	6a 01                	push   $0x1
  803809:	ff 75 f0             	pushl  -0x10(%ebp)
  80380c:	ff 75 08             	pushl  0x8(%ebp)
  80380f:	e8 1e ea ff ff       	call   802232 <set_block_data>
  803814:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803817:	8b 45 08             	mov    0x8(%ebp),%eax
  80381a:	83 e8 04             	sub    $0x4,%eax
  80381d:	8b 00                	mov    (%eax),%eax
  80381f:	83 e0 fe             	and    $0xfffffffe,%eax
  803822:	89 c2                	mov    %eax,%edx
  803824:	8b 45 08             	mov    0x8(%ebp),%eax
  803827:	01 d0                	add    %edx,%eax
  803829:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80382c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803830:	74 06                	je     803838 <realloc_block_FF+0x613>
  803832:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803836:	75 17                	jne    80384f <realloc_block_FF+0x62a>
  803838:	83 ec 04             	sub    $0x4,%esp
  80383b:	68 00 45 80 00       	push   $0x804500
  803840:	68 44 02 00 00       	push   $0x244
  803845:	68 8d 44 80 00       	push   $0x80448d
  80384a:	e8 a2 cb ff ff       	call   8003f1 <_panic>
  80384f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803852:	8b 10                	mov    (%eax),%edx
  803854:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803857:	89 10                	mov    %edx,(%eax)
  803859:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80385c:	8b 00                	mov    (%eax),%eax
  80385e:	85 c0                	test   %eax,%eax
  803860:	74 0b                	je     80386d <realloc_block_FF+0x648>
  803862:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803865:	8b 00                	mov    (%eax),%eax
  803867:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80386a:	89 50 04             	mov    %edx,0x4(%eax)
  80386d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803870:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803873:	89 10                	mov    %edx,(%eax)
  803875:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803878:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80387b:	89 50 04             	mov    %edx,0x4(%eax)
  80387e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803881:	8b 00                	mov    (%eax),%eax
  803883:	85 c0                	test   %eax,%eax
  803885:	75 08                	jne    80388f <realloc_block_FF+0x66a>
  803887:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80388a:	a3 30 50 80 00       	mov    %eax,0x805030
  80388f:	a1 38 50 80 00       	mov    0x805038,%eax
  803894:	40                   	inc    %eax
  803895:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80389a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80389e:	75 17                	jne    8038b7 <realloc_block_FF+0x692>
  8038a0:	83 ec 04             	sub    $0x4,%esp
  8038a3:	68 6f 44 80 00       	push   $0x80446f
  8038a8:	68 45 02 00 00       	push   $0x245
  8038ad:	68 8d 44 80 00       	push   $0x80448d
  8038b2:	e8 3a cb ff ff       	call   8003f1 <_panic>
  8038b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ba:	8b 00                	mov    (%eax),%eax
  8038bc:	85 c0                	test   %eax,%eax
  8038be:	74 10                	je     8038d0 <realloc_block_FF+0x6ab>
  8038c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c3:	8b 00                	mov    (%eax),%eax
  8038c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038c8:	8b 52 04             	mov    0x4(%edx),%edx
  8038cb:	89 50 04             	mov    %edx,0x4(%eax)
  8038ce:	eb 0b                	jmp    8038db <realloc_block_FF+0x6b6>
  8038d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d3:	8b 40 04             	mov    0x4(%eax),%eax
  8038d6:	a3 30 50 80 00       	mov    %eax,0x805030
  8038db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038de:	8b 40 04             	mov    0x4(%eax),%eax
  8038e1:	85 c0                	test   %eax,%eax
  8038e3:	74 0f                	je     8038f4 <realloc_block_FF+0x6cf>
  8038e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e8:	8b 40 04             	mov    0x4(%eax),%eax
  8038eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038ee:	8b 12                	mov    (%edx),%edx
  8038f0:	89 10                	mov    %edx,(%eax)
  8038f2:	eb 0a                	jmp    8038fe <realloc_block_FF+0x6d9>
  8038f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f7:	8b 00                	mov    (%eax),%eax
  8038f9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803901:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803907:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803911:	a1 38 50 80 00       	mov    0x805038,%eax
  803916:	48                   	dec    %eax
  803917:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80391c:	83 ec 04             	sub    $0x4,%esp
  80391f:	6a 00                	push   $0x0
  803921:	ff 75 bc             	pushl  -0x44(%ebp)
  803924:	ff 75 b8             	pushl  -0x48(%ebp)
  803927:	e8 06 e9 ff ff       	call   802232 <set_block_data>
  80392c:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80392f:	8b 45 08             	mov    0x8(%ebp),%eax
  803932:	eb 0a                	jmp    80393e <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803934:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80393b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80393e:	c9                   	leave  
  80393f:	c3                   	ret    

00803940 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803940:	55                   	push   %ebp
  803941:	89 e5                	mov    %esp,%ebp
  803943:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803946:	83 ec 04             	sub    $0x4,%esp
  803949:	68 84 45 80 00       	push   $0x804584
  80394e:	68 58 02 00 00       	push   $0x258
  803953:	68 8d 44 80 00       	push   $0x80448d
  803958:	e8 94 ca ff ff       	call   8003f1 <_panic>

0080395d <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80395d:	55                   	push   %ebp
  80395e:	89 e5                	mov    %esp,%ebp
  803960:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803963:	83 ec 04             	sub    $0x4,%esp
  803966:	68 ac 45 80 00       	push   $0x8045ac
  80396b:	68 61 02 00 00       	push   $0x261
  803970:	68 8d 44 80 00       	push   $0x80448d
  803975:	e8 77 ca ff ff       	call   8003f1 <_panic>
  80397a:	66 90                	xchg   %ax,%ax

0080397c <__udivdi3>:
  80397c:	55                   	push   %ebp
  80397d:	57                   	push   %edi
  80397e:	56                   	push   %esi
  80397f:	53                   	push   %ebx
  803980:	83 ec 1c             	sub    $0x1c,%esp
  803983:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803987:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80398b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80398f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803993:	89 ca                	mov    %ecx,%edx
  803995:	89 f8                	mov    %edi,%eax
  803997:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80399b:	85 f6                	test   %esi,%esi
  80399d:	75 2d                	jne    8039cc <__udivdi3+0x50>
  80399f:	39 cf                	cmp    %ecx,%edi
  8039a1:	77 65                	ja     803a08 <__udivdi3+0x8c>
  8039a3:	89 fd                	mov    %edi,%ebp
  8039a5:	85 ff                	test   %edi,%edi
  8039a7:	75 0b                	jne    8039b4 <__udivdi3+0x38>
  8039a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8039ae:	31 d2                	xor    %edx,%edx
  8039b0:	f7 f7                	div    %edi
  8039b2:	89 c5                	mov    %eax,%ebp
  8039b4:	31 d2                	xor    %edx,%edx
  8039b6:	89 c8                	mov    %ecx,%eax
  8039b8:	f7 f5                	div    %ebp
  8039ba:	89 c1                	mov    %eax,%ecx
  8039bc:	89 d8                	mov    %ebx,%eax
  8039be:	f7 f5                	div    %ebp
  8039c0:	89 cf                	mov    %ecx,%edi
  8039c2:	89 fa                	mov    %edi,%edx
  8039c4:	83 c4 1c             	add    $0x1c,%esp
  8039c7:	5b                   	pop    %ebx
  8039c8:	5e                   	pop    %esi
  8039c9:	5f                   	pop    %edi
  8039ca:	5d                   	pop    %ebp
  8039cb:	c3                   	ret    
  8039cc:	39 ce                	cmp    %ecx,%esi
  8039ce:	77 28                	ja     8039f8 <__udivdi3+0x7c>
  8039d0:	0f bd fe             	bsr    %esi,%edi
  8039d3:	83 f7 1f             	xor    $0x1f,%edi
  8039d6:	75 40                	jne    803a18 <__udivdi3+0x9c>
  8039d8:	39 ce                	cmp    %ecx,%esi
  8039da:	72 0a                	jb     8039e6 <__udivdi3+0x6a>
  8039dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039e0:	0f 87 9e 00 00 00    	ja     803a84 <__udivdi3+0x108>
  8039e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8039eb:	89 fa                	mov    %edi,%edx
  8039ed:	83 c4 1c             	add    $0x1c,%esp
  8039f0:	5b                   	pop    %ebx
  8039f1:	5e                   	pop    %esi
  8039f2:	5f                   	pop    %edi
  8039f3:	5d                   	pop    %ebp
  8039f4:	c3                   	ret    
  8039f5:	8d 76 00             	lea    0x0(%esi),%esi
  8039f8:	31 ff                	xor    %edi,%edi
  8039fa:	31 c0                	xor    %eax,%eax
  8039fc:	89 fa                	mov    %edi,%edx
  8039fe:	83 c4 1c             	add    $0x1c,%esp
  803a01:	5b                   	pop    %ebx
  803a02:	5e                   	pop    %esi
  803a03:	5f                   	pop    %edi
  803a04:	5d                   	pop    %ebp
  803a05:	c3                   	ret    
  803a06:	66 90                	xchg   %ax,%ax
  803a08:	89 d8                	mov    %ebx,%eax
  803a0a:	f7 f7                	div    %edi
  803a0c:	31 ff                	xor    %edi,%edi
  803a0e:	89 fa                	mov    %edi,%edx
  803a10:	83 c4 1c             	add    $0x1c,%esp
  803a13:	5b                   	pop    %ebx
  803a14:	5e                   	pop    %esi
  803a15:	5f                   	pop    %edi
  803a16:	5d                   	pop    %ebp
  803a17:	c3                   	ret    
  803a18:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a1d:	89 eb                	mov    %ebp,%ebx
  803a1f:	29 fb                	sub    %edi,%ebx
  803a21:	89 f9                	mov    %edi,%ecx
  803a23:	d3 e6                	shl    %cl,%esi
  803a25:	89 c5                	mov    %eax,%ebp
  803a27:	88 d9                	mov    %bl,%cl
  803a29:	d3 ed                	shr    %cl,%ebp
  803a2b:	89 e9                	mov    %ebp,%ecx
  803a2d:	09 f1                	or     %esi,%ecx
  803a2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a33:	89 f9                	mov    %edi,%ecx
  803a35:	d3 e0                	shl    %cl,%eax
  803a37:	89 c5                	mov    %eax,%ebp
  803a39:	89 d6                	mov    %edx,%esi
  803a3b:	88 d9                	mov    %bl,%cl
  803a3d:	d3 ee                	shr    %cl,%esi
  803a3f:	89 f9                	mov    %edi,%ecx
  803a41:	d3 e2                	shl    %cl,%edx
  803a43:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a47:	88 d9                	mov    %bl,%cl
  803a49:	d3 e8                	shr    %cl,%eax
  803a4b:	09 c2                	or     %eax,%edx
  803a4d:	89 d0                	mov    %edx,%eax
  803a4f:	89 f2                	mov    %esi,%edx
  803a51:	f7 74 24 0c          	divl   0xc(%esp)
  803a55:	89 d6                	mov    %edx,%esi
  803a57:	89 c3                	mov    %eax,%ebx
  803a59:	f7 e5                	mul    %ebp
  803a5b:	39 d6                	cmp    %edx,%esi
  803a5d:	72 19                	jb     803a78 <__udivdi3+0xfc>
  803a5f:	74 0b                	je     803a6c <__udivdi3+0xf0>
  803a61:	89 d8                	mov    %ebx,%eax
  803a63:	31 ff                	xor    %edi,%edi
  803a65:	e9 58 ff ff ff       	jmp    8039c2 <__udivdi3+0x46>
  803a6a:	66 90                	xchg   %ax,%ax
  803a6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a70:	89 f9                	mov    %edi,%ecx
  803a72:	d3 e2                	shl    %cl,%edx
  803a74:	39 c2                	cmp    %eax,%edx
  803a76:	73 e9                	jae    803a61 <__udivdi3+0xe5>
  803a78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a7b:	31 ff                	xor    %edi,%edi
  803a7d:	e9 40 ff ff ff       	jmp    8039c2 <__udivdi3+0x46>
  803a82:	66 90                	xchg   %ax,%ax
  803a84:	31 c0                	xor    %eax,%eax
  803a86:	e9 37 ff ff ff       	jmp    8039c2 <__udivdi3+0x46>
  803a8b:	90                   	nop

00803a8c <__umoddi3>:
  803a8c:	55                   	push   %ebp
  803a8d:	57                   	push   %edi
  803a8e:	56                   	push   %esi
  803a8f:	53                   	push   %ebx
  803a90:	83 ec 1c             	sub    $0x1c,%esp
  803a93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a97:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803aa3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803aa7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803aab:	89 f3                	mov    %esi,%ebx
  803aad:	89 fa                	mov    %edi,%edx
  803aaf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ab3:	89 34 24             	mov    %esi,(%esp)
  803ab6:	85 c0                	test   %eax,%eax
  803ab8:	75 1a                	jne    803ad4 <__umoddi3+0x48>
  803aba:	39 f7                	cmp    %esi,%edi
  803abc:	0f 86 a2 00 00 00    	jbe    803b64 <__umoddi3+0xd8>
  803ac2:	89 c8                	mov    %ecx,%eax
  803ac4:	89 f2                	mov    %esi,%edx
  803ac6:	f7 f7                	div    %edi
  803ac8:	89 d0                	mov    %edx,%eax
  803aca:	31 d2                	xor    %edx,%edx
  803acc:	83 c4 1c             	add    $0x1c,%esp
  803acf:	5b                   	pop    %ebx
  803ad0:	5e                   	pop    %esi
  803ad1:	5f                   	pop    %edi
  803ad2:	5d                   	pop    %ebp
  803ad3:	c3                   	ret    
  803ad4:	39 f0                	cmp    %esi,%eax
  803ad6:	0f 87 ac 00 00 00    	ja     803b88 <__umoddi3+0xfc>
  803adc:	0f bd e8             	bsr    %eax,%ebp
  803adf:	83 f5 1f             	xor    $0x1f,%ebp
  803ae2:	0f 84 ac 00 00 00    	je     803b94 <__umoddi3+0x108>
  803ae8:	bf 20 00 00 00       	mov    $0x20,%edi
  803aed:	29 ef                	sub    %ebp,%edi
  803aef:	89 fe                	mov    %edi,%esi
  803af1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803af5:	89 e9                	mov    %ebp,%ecx
  803af7:	d3 e0                	shl    %cl,%eax
  803af9:	89 d7                	mov    %edx,%edi
  803afb:	89 f1                	mov    %esi,%ecx
  803afd:	d3 ef                	shr    %cl,%edi
  803aff:	09 c7                	or     %eax,%edi
  803b01:	89 e9                	mov    %ebp,%ecx
  803b03:	d3 e2                	shl    %cl,%edx
  803b05:	89 14 24             	mov    %edx,(%esp)
  803b08:	89 d8                	mov    %ebx,%eax
  803b0a:	d3 e0                	shl    %cl,%eax
  803b0c:	89 c2                	mov    %eax,%edx
  803b0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b12:	d3 e0                	shl    %cl,%eax
  803b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b18:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b1c:	89 f1                	mov    %esi,%ecx
  803b1e:	d3 e8                	shr    %cl,%eax
  803b20:	09 d0                	or     %edx,%eax
  803b22:	d3 eb                	shr    %cl,%ebx
  803b24:	89 da                	mov    %ebx,%edx
  803b26:	f7 f7                	div    %edi
  803b28:	89 d3                	mov    %edx,%ebx
  803b2a:	f7 24 24             	mull   (%esp)
  803b2d:	89 c6                	mov    %eax,%esi
  803b2f:	89 d1                	mov    %edx,%ecx
  803b31:	39 d3                	cmp    %edx,%ebx
  803b33:	0f 82 87 00 00 00    	jb     803bc0 <__umoddi3+0x134>
  803b39:	0f 84 91 00 00 00    	je     803bd0 <__umoddi3+0x144>
  803b3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b43:	29 f2                	sub    %esi,%edx
  803b45:	19 cb                	sbb    %ecx,%ebx
  803b47:	89 d8                	mov    %ebx,%eax
  803b49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b4d:	d3 e0                	shl    %cl,%eax
  803b4f:	89 e9                	mov    %ebp,%ecx
  803b51:	d3 ea                	shr    %cl,%edx
  803b53:	09 d0                	or     %edx,%eax
  803b55:	89 e9                	mov    %ebp,%ecx
  803b57:	d3 eb                	shr    %cl,%ebx
  803b59:	89 da                	mov    %ebx,%edx
  803b5b:	83 c4 1c             	add    $0x1c,%esp
  803b5e:	5b                   	pop    %ebx
  803b5f:	5e                   	pop    %esi
  803b60:	5f                   	pop    %edi
  803b61:	5d                   	pop    %ebp
  803b62:	c3                   	ret    
  803b63:	90                   	nop
  803b64:	89 fd                	mov    %edi,%ebp
  803b66:	85 ff                	test   %edi,%edi
  803b68:	75 0b                	jne    803b75 <__umoddi3+0xe9>
  803b6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b6f:	31 d2                	xor    %edx,%edx
  803b71:	f7 f7                	div    %edi
  803b73:	89 c5                	mov    %eax,%ebp
  803b75:	89 f0                	mov    %esi,%eax
  803b77:	31 d2                	xor    %edx,%edx
  803b79:	f7 f5                	div    %ebp
  803b7b:	89 c8                	mov    %ecx,%eax
  803b7d:	f7 f5                	div    %ebp
  803b7f:	89 d0                	mov    %edx,%eax
  803b81:	e9 44 ff ff ff       	jmp    803aca <__umoddi3+0x3e>
  803b86:	66 90                	xchg   %ax,%ax
  803b88:	89 c8                	mov    %ecx,%eax
  803b8a:	89 f2                	mov    %esi,%edx
  803b8c:	83 c4 1c             	add    $0x1c,%esp
  803b8f:	5b                   	pop    %ebx
  803b90:	5e                   	pop    %esi
  803b91:	5f                   	pop    %edi
  803b92:	5d                   	pop    %ebp
  803b93:	c3                   	ret    
  803b94:	3b 04 24             	cmp    (%esp),%eax
  803b97:	72 06                	jb     803b9f <__umoddi3+0x113>
  803b99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b9d:	77 0f                	ja     803bae <__umoddi3+0x122>
  803b9f:	89 f2                	mov    %esi,%edx
  803ba1:	29 f9                	sub    %edi,%ecx
  803ba3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ba7:	89 14 24             	mov    %edx,(%esp)
  803baa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bae:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bb2:	8b 14 24             	mov    (%esp),%edx
  803bb5:	83 c4 1c             	add    $0x1c,%esp
  803bb8:	5b                   	pop    %ebx
  803bb9:	5e                   	pop    %esi
  803bba:	5f                   	pop    %edi
  803bbb:	5d                   	pop    %ebp
  803bbc:	c3                   	ret    
  803bbd:	8d 76 00             	lea    0x0(%esi),%esi
  803bc0:	2b 04 24             	sub    (%esp),%eax
  803bc3:	19 fa                	sbb    %edi,%edx
  803bc5:	89 d1                	mov    %edx,%ecx
  803bc7:	89 c6                	mov    %eax,%esi
  803bc9:	e9 71 ff ff ff       	jmp    803b3f <__umoddi3+0xb3>
  803bce:	66 90                	xchg   %ax,%ax
  803bd0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bd4:	72 ea                	jb     803bc0 <__umoddi3+0x134>
  803bd6:	89 d9                	mov    %ebx,%ecx
  803bd8:	e9 62 ff ff ff       	jmp    803b3f <__umoddi3+0xb3>
