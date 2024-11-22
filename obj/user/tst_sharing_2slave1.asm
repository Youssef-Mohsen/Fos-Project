
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
  80005c:	68 60 3c 80 00       	push   $0x803c60
  800061:	6a 0d                	push   $0xd
  800063:	68 7c 3c 80 00       	push   $0x803c7c
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
  800074:	e8 a9 1b 00 00       	call   801c22 <sys_getparentenvid>
  800079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80007c:	e8 0c 19 00 00       	call   80198d <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800081:	e8 ba 19 00 00       	call   801a40 <sys_calculate_free_frames>
  800086:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	68 97 3c 80 00       	push   $0x803c97
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
  8000b6:	68 9c 3c 80 00       	push   $0x803c9c
  8000bb:	6a 21                	push   $0x21
  8000bd:	68 7c 3c 80 00       	push   $0x803c7c
  8000c2:	e8 2a 03 00 00       	call   8003f1 <_panic>
		expected = 1 ; /*1table*/
  8000c7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000ce:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000d1:	e8 6a 19 00 00       	call   801a40 <sys_calculate_free_frames>
  8000d6:	29 c3                	sub    %eax,%ebx
  8000d8:	89 d8                	mov    %ebx,%eax
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000e0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000e3:	74 24                	je     800109 <_main+0xd1>
  8000e5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000e8:	e8 53 19 00 00       	call   801a40 <sys_calculate_free_frames>
  8000ed:	29 c3                	sub    %eax,%ebx
  8000ef:	89 d8                	mov    %ebx,%eax
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f7:	50                   	push   %eax
  8000f8:	68 18 3d 80 00       	push   $0x803d18
  8000fd:	6a 24                	push   $0x24
  8000ff:	68 7c 3c 80 00       	push   $0x803c7c
  800104:	e8 e8 02 00 00       	call   8003f1 <_panic>
	}
	sys_unlock_cons();
  800109:	e8 99 18 00 00       	call   8019a7 <sys_unlock_cons>
	//sys_unlock_cons();

	//sys_lock_cons();
	sys_lock_cons();
  80010e:	e8 7a 18 00 00       	call   80198d <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800113:	e8 28 19 00 00       	call   801a40 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = sget(parentenvID,"y");
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	68 b0 3d 80 00       	push   $0x803db0
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
  80014d:	68 9c 3c 80 00       	push   $0x803c9c
  800152:	6a 2f                	push   $0x2f
  800154:	68 7c 3c 80 00       	push   $0x803c7c
  800159:	e8 93 02 00 00       	call   8003f1 <_panic>
		expected = 0 ;
  80015e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800165:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800168:	e8 d3 18 00 00       	call   801a40 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800174:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80017a:	74 24                	je     8001a0 <_main+0x168>
  80017c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80017f:	e8 bc 18 00 00       	call   801a40 <sys_calculate_free_frames>
  800184:	29 c3                	sub    %eax,%ebx
  800186:	89 d8                	mov    %ebx,%eax
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 e0             	pushl  -0x20(%ebp)
  80018e:	50                   	push   %eax
  80018f:	68 18 3d 80 00       	push   $0x803d18
  800194:	6a 32                	push   $0x32
  800196:	68 7c 3c 80 00       	push   $0x803c7c
  80019b:	e8 51 02 00 00       	call   8003f1 <_panic>
	}
	sys_unlock_cons();
  8001a0:	e8 02 18 00 00       	call   8019a7 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  8001a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001a8:	8b 00                	mov    (%eax),%eax
  8001aa:	83 f8 14             	cmp    $0x14,%eax
  8001ad:	74 14                	je     8001c3 <_main+0x18b>
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	68 b4 3d 80 00       	push   $0x803db4
  8001b7:	6a 37                	push   $0x37
  8001b9:	68 7c 3c 80 00       	push   $0x803c7c
  8001be:	e8 2e 02 00 00       	call   8003f1 <_panic>

	//sys_lock_cons();
	sys_lock_cons();
  8001c3:	e8 c5 17 00 00       	call   80198d <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  8001c8:	e8 73 18 00 00       	call   801a40 <sys_calculate_free_frames>
  8001cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	68 eb 3d 80 00       	push   $0x803deb
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
  800202:	68 9c 3c 80 00       	push   $0x803c9c
  800207:	6a 3f                	push   $0x3f
  800209:	68 7c 3c 80 00       	push   $0x803c7c
  80020e:	e8 de 01 00 00       	call   8003f1 <_panic>
		expected = 0 ;
  800213:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80021a:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80021d:	e8 1e 18 00 00       	call   801a40 <sys_calculate_free_frames>
  800222:	29 c3                	sub    %eax,%ebx
  800224:	89 d8                	mov    %ebx,%eax
  800226:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800229:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022f:	74 24                	je     800255 <_main+0x21d>
  800231:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800234:	e8 07 18 00 00       	call   801a40 <sys_calculate_free_frames>
  800239:	29 c3                	sub    %eax,%ebx
  80023b:	89 d8                	mov    %ebx,%eax
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	ff 75 e0             	pushl  -0x20(%ebp)
  800243:	50                   	push   %eax
  800244:	68 18 3d 80 00       	push   $0x803d18
  800249:	6a 42                	push   $0x42
  80024b:	68 7c 3c 80 00       	push   $0x803c7c
  800250:	e8 9c 01 00 00       	call   8003f1 <_panic>
	}
	sys_unlock_cons();
  800255:	e8 4d 17 00 00       	call   8019a7 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  80025a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80025d:	8b 00                	mov    (%eax),%eax
  80025f:	83 f8 0a             	cmp    $0xa,%eax
  800262:	74 14                	je     800278 <_main+0x240>
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	68 b4 3d 80 00       	push   $0x803db4
  80026c:	6a 47                	push   $0x47
  80026e:	68 7c 3c 80 00       	push   $0x803c7c
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
  800296:	68 b4 3d 80 00       	push   $0x803db4
  80029b:	6a 4a                	push   $0x4a
  80029d:	68 7c 3c 80 00       	push   $0x803c7c
  8002a2:	e8 4a 01 00 00       	call   8003f1 <_panic>

	//To indicate that it's completed successfully
	inctst();
  8002a7:	e8 9b 1a 00 00       	call   801d47 <inctst>

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
  8002b8:	e8 4c 19 00 00       	call   801c09 <sys_getenvindex>
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
  800326:	e8 62 16 00 00       	call   80198d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80032b:	83 ec 0c             	sub    $0xc,%esp
  80032e:	68 08 3e 80 00       	push   $0x803e08
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
  800356:	68 30 3e 80 00       	push   $0x803e30
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
  800387:	68 58 3e 80 00       	push   $0x803e58
  80038c:	e8 1d 03 00 00       	call   8006ae <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800394:	a1 20 50 80 00       	mov    0x805020,%eax
  800399:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80039f:	83 ec 08             	sub    $0x8,%esp
  8003a2:	50                   	push   %eax
  8003a3:	68 b0 3e 80 00       	push   $0x803eb0
  8003a8:	e8 01 03 00 00       	call   8006ae <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003b0:	83 ec 0c             	sub    $0xc,%esp
  8003b3:	68 08 3e 80 00       	push   $0x803e08
  8003b8:	e8 f1 02 00 00       	call   8006ae <cprintf>
  8003bd:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003c0:	e8 e2 15 00 00       	call   8019a7 <sys_unlock_cons>
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
  8003d8:	e8 f8 17 00 00       	call   801bd5 <sys_destroy_env>
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
  8003e9:	e8 4d 18 00 00       	call   801c3b <sys_exit_env>
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
  800412:	68 c4 3e 80 00       	push   $0x803ec4
  800417:	e8 92 02 00 00       	call   8006ae <cprintf>
  80041c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80041f:	a1 00 50 80 00       	mov    0x805000,%eax
  800424:	ff 75 0c             	pushl  0xc(%ebp)
  800427:	ff 75 08             	pushl  0x8(%ebp)
  80042a:	50                   	push   %eax
  80042b:	68 c9 3e 80 00       	push   $0x803ec9
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
  80044f:	68 e5 3e 80 00       	push   $0x803ee5
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
  80047e:	68 e8 3e 80 00       	push   $0x803ee8
  800483:	6a 26                	push   $0x26
  800485:	68 34 3f 80 00       	push   $0x803f34
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
  800553:	68 40 3f 80 00       	push   $0x803f40
  800558:	6a 3a                	push   $0x3a
  80055a:	68 34 3f 80 00       	push   $0x803f34
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
  8005c6:	68 94 3f 80 00       	push   $0x803f94
  8005cb:	6a 44                	push   $0x44
  8005cd:	68 34 3f 80 00       	push   $0x803f34
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
  800620:	e8 26 13 00 00       	call   80194b <sys_cputs>
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
  800697:	e8 af 12 00 00       	call   80194b <sys_cputs>
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
  8006e1:	e8 a7 12 00 00       	call   80198d <sys_lock_cons>
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
  800701:	e8 a1 12 00 00       	call   8019a7 <sys_unlock_cons>
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
  80074b:	e8 94 32 00 00       	call   8039e4 <__udivdi3>
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
  80079b:	e8 54 33 00 00       	call   803af4 <__umoddi3>
  8007a0:	83 c4 10             	add    $0x10,%esp
  8007a3:	05 f4 41 80 00       	add    $0x8041f4,%eax
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
  8008f6:	8b 04 85 18 42 80 00 	mov    0x804218(,%eax,4),%eax
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
  8009d7:	8b 34 9d 60 40 80 00 	mov    0x804060(,%ebx,4),%esi
  8009de:	85 f6                	test   %esi,%esi
  8009e0:	75 19                	jne    8009fb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e2:	53                   	push   %ebx
  8009e3:	68 05 42 80 00       	push   $0x804205
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
  8009fc:	68 0e 42 80 00       	push   $0x80420e
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
  800a29:	be 11 42 80 00       	mov    $0x804211,%esi
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
  801434:	68 88 43 80 00       	push   $0x804388
  801439:	68 3f 01 00 00       	push   $0x13f
  80143e:	68 aa 43 80 00       	push   $0x8043aa
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
  801454:	e8 9d 0a 00 00       	call   801ef6 <sys_sbrk>
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
  8014cf:	e8 a6 08 00 00       	call   801d7a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	74 16                	je     8014ee <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	ff 75 08             	pushl  0x8(%ebp)
  8014de:	e8 e6 0d 00 00       	call   8022c9 <alloc_block_FF>
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e9:	e9 8a 01 00 00       	jmp    801678 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8014ee:	e8 b8 08 00 00       	call   801dab <sys_isUHeapPlacementStrategyBESTFIT>
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	0f 84 7d 01 00 00    	je     801678 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8014fb:	83 ec 0c             	sub    $0xc,%esp
  8014fe:	ff 75 08             	pushl  0x8(%ebp)
  801501:	e8 7f 12 00 00       	call   802785 <alloc_block_BF>
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
  801667:	e8 c1 08 00 00       	call   801f2d <sys_allocate_user_mem>
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
  8016af:	e8 95 08 00 00       	call   801f49 <get_block_size>
  8016b4:	83 c4 10             	add    $0x10,%esp
  8016b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8016ba:	83 ec 0c             	sub    $0xc,%esp
  8016bd:	ff 75 08             	pushl  0x8(%ebp)
  8016c0:	e8 c8 1a 00 00       	call   80318d <free_block>
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
  801757:	e8 b5 07 00 00       	call   801f11 <sys_free_user_mem>
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
  801765:	68 b8 43 80 00       	push   $0x8043b8
  80176a:	68 84 00 00 00       	push   $0x84
  80176f:	68 e2 43 80 00       	push   $0x8043e2
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
  8017d7:	e8 3c 03 00 00       	call   801b18 <sys_createSharedObject>
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
  8017f8:	68 ee 43 80 00       	push   $0x8043ee
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
  80180d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801810:	83 ec 08             	sub    $0x8,%esp
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	ff 75 08             	pushl  0x8(%ebp)
  801819:	e8 24 03 00 00       	call   801b42 <sys_getSizeOfSharedObject>
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801824:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801828:	75 07                	jne    801831 <sget+0x27>
  80182a:	b8 00 00 00 00       	mov    $0x0,%eax
  80182f:	eb 5c                	jmp    80188d <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801834:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801837:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80183e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801844:	39 d0                	cmp    %edx,%eax
  801846:	7d 02                	jge    80184a <sget+0x40>
  801848:	89 d0                	mov    %edx,%eax
  80184a:	83 ec 0c             	sub    $0xc,%esp
  80184d:	50                   	push   %eax
  80184e:	e8 0b fc ff ff       	call   80145e <malloc>
  801853:	83 c4 10             	add    $0x10,%esp
  801856:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801859:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80185d:	75 07                	jne    801866 <sget+0x5c>
  80185f:	b8 00 00 00 00       	mov    $0x0,%eax
  801864:	eb 27                	jmp    80188d <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801866:	83 ec 04             	sub    $0x4,%esp
  801869:	ff 75 e8             	pushl  -0x18(%ebp)
  80186c:	ff 75 0c             	pushl  0xc(%ebp)
  80186f:	ff 75 08             	pushl  0x8(%ebp)
  801872:	e8 e8 02 00 00       	call   801b5f <sys_getSharedObject>
  801877:	83 c4 10             	add    $0x10,%esp
  80187a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80187d:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801881:	75 07                	jne    80188a <sget+0x80>
  801883:	b8 00 00 00 00       	mov    $0x0,%eax
  801888:	eb 03                	jmp    80188d <sget+0x83>
	return ptr;
  80188a:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801895:	83 ec 04             	sub    $0x4,%esp
  801898:	68 f4 43 80 00       	push   $0x8043f4
  80189d:	68 c2 00 00 00       	push   $0xc2
  8018a2:	68 e2 43 80 00       	push   $0x8043e2
  8018a7:	e8 45 eb ff ff       	call   8003f1 <_panic>

008018ac <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018b2:	83 ec 04             	sub    $0x4,%esp
  8018b5:	68 18 44 80 00       	push   $0x804418
  8018ba:	68 d9 00 00 00       	push   $0xd9
  8018bf:	68 e2 43 80 00       	push   $0x8043e2
  8018c4:	e8 28 eb ff ff       	call   8003f1 <_panic>

008018c9 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018cf:	83 ec 04             	sub    $0x4,%esp
  8018d2:	68 3e 44 80 00       	push   $0x80443e
  8018d7:	68 e5 00 00 00       	push   $0xe5
  8018dc:	68 e2 43 80 00       	push   $0x8043e2
  8018e1:	e8 0b eb ff ff       	call   8003f1 <_panic>

008018e6 <shrink>:

}
void shrink(uint32 newSize)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ec:	83 ec 04             	sub    $0x4,%esp
  8018ef:	68 3e 44 80 00       	push   $0x80443e
  8018f4:	68 ea 00 00 00       	push   $0xea
  8018f9:	68 e2 43 80 00       	push   $0x8043e2
  8018fe:	e8 ee ea ff ff       	call   8003f1 <_panic>

00801903 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801909:	83 ec 04             	sub    $0x4,%esp
  80190c:	68 3e 44 80 00       	push   $0x80443e
  801911:	68 ef 00 00 00       	push   $0xef
  801916:	68 e2 43 80 00       	push   $0x8043e2
  80191b:	e8 d1 ea ff ff       	call   8003f1 <_panic>

00801920 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	57                   	push   %edi
  801924:	56                   	push   %esi
  801925:	53                   	push   %ebx
  801926:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801932:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801935:	8b 7d 18             	mov    0x18(%ebp),%edi
  801938:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80193b:	cd 30                	int    $0x30
  80193d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801940:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	5b                   	pop    %ebx
  801947:	5e                   	pop    %esi
  801948:	5f                   	pop    %edi
  801949:	5d                   	pop    %ebp
  80194a:	c3                   	ret    

0080194b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	83 ec 04             	sub    $0x4,%esp
  801951:	8b 45 10             	mov    0x10(%ebp),%eax
  801954:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801957:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	52                   	push   %edx
  801963:	ff 75 0c             	pushl  0xc(%ebp)
  801966:	50                   	push   %eax
  801967:	6a 00                	push   $0x0
  801969:	e8 b2 ff ff ff       	call   801920 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	90                   	nop
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_cgetc>:

int
sys_cgetc(void)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 02                	push   $0x2
  801983:	e8 98 ff ff ff       	call   801920 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 03                	push   $0x3
  80199c:	e8 7f ff ff ff       	call   801920 <syscall>
  8019a1:	83 c4 18             	add    $0x18,%esp
}
  8019a4:	90                   	nop
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 04                	push   $0x4
  8019b6:	e8 65 ff ff ff       	call   801920 <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	90                   	nop
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	52                   	push   %edx
  8019d1:	50                   	push   %eax
  8019d2:	6a 08                	push   $0x8
  8019d4:	e8 47 ff ff ff       	call   801920 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	56                   	push   %esi
  8019e2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019e3:	8b 75 18             	mov    0x18(%ebp),%esi
  8019e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	56                   	push   %esi
  8019f3:	53                   	push   %ebx
  8019f4:	51                   	push   %ecx
  8019f5:	52                   	push   %edx
  8019f6:	50                   	push   %eax
  8019f7:	6a 09                	push   $0x9
  8019f9:	e8 22 ff ff ff       	call   801920 <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a04:	5b                   	pop    %ebx
  801a05:	5e                   	pop    %esi
  801a06:	5d                   	pop    %ebp
  801a07:	c3                   	ret    

00801a08 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	52                   	push   %edx
  801a18:	50                   	push   %eax
  801a19:	6a 0a                	push   $0xa
  801a1b:	e8 00 ff ff ff       	call   801920 <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	ff 75 0c             	pushl  0xc(%ebp)
  801a31:	ff 75 08             	pushl  0x8(%ebp)
  801a34:	6a 0b                	push   $0xb
  801a36:	e8 e5 fe ff ff       	call   801920 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 0c                	push   $0xc
  801a4f:	e8 cc fe ff ff       	call   801920 <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 0d                	push   $0xd
  801a68:	e8 b3 fe ff ff       	call   801920 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 0e                	push   $0xe
  801a81:	e8 9a fe ff ff       	call   801920 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 0f                	push   $0xf
  801a9a:	e8 81 fe ff ff       	call   801920 <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	ff 75 08             	pushl  0x8(%ebp)
  801ab2:	6a 10                	push   $0x10
  801ab4:	e8 67 fe ff ff       	call   801920 <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_scarce_memory>:

void sys_scarce_memory()
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 11                	push   $0x11
  801acd:	e8 4e fe ff ff       	call   801920 <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
}
  801ad5:	90                   	nop
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_cputc>:

void
sys_cputc(const char c)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	83 ec 04             	sub    $0x4,%esp
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ae4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	50                   	push   %eax
  801af1:	6a 01                	push   $0x1
  801af3:	e8 28 fe ff ff       	call   801920 <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	90                   	nop
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 14                	push   $0x14
  801b0d:	e8 0e fe ff ff       	call   801920 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	90                   	nop
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 04             	sub    $0x4,%esp
  801b1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b21:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b24:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b27:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	6a 00                	push   $0x0
  801b30:	51                   	push   %ecx
  801b31:	52                   	push   %edx
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	50                   	push   %eax
  801b36:	6a 15                	push   $0x15
  801b38:	e8 e3 fd ff ff       	call   801920 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	52                   	push   %edx
  801b52:	50                   	push   %eax
  801b53:	6a 16                	push   $0x16
  801b55:	e8 c6 fd ff ff       	call   801920 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b62:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	51                   	push   %ecx
  801b70:	52                   	push   %edx
  801b71:	50                   	push   %eax
  801b72:	6a 17                	push   $0x17
  801b74:	e8 a7 fd ff ff       	call   801920 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	52                   	push   %edx
  801b8e:	50                   	push   %eax
  801b8f:	6a 18                	push   $0x18
  801b91:	e8 8a fd ff ff       	call   801920 <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	6a 00                	push   $0x0
  801ba3:	ff 75 14             	pushl  0x14(%ebp)
  801ba6:	ff 75 10             	pushl  0x10(%ebp)
  801ba9:	ff 75 0c             	pushl  0xc(%ebp)
  801bac:	50                   	push   %eax
  801bad:	6a 19                	push   $0x19
  801baf:	e8 6c fd ff ff       	call   801920 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	50                   	push   %eax
  801bc8:	6a 1a                	push   $0x1a
  801bca:	e8 51 fd ff ff       	call   801920 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	90                   	nop
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	50                   	push   %eax
  801be4:	6a 1b                	push   $0x1b
  801be6:	e8 35 fd ff ff       	call   801920 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 05                	push   $0x5
  801bff:	e8 1c fd ff ff       	call   801920 <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 06                	push   $0x6
  801c18:	e8 03 fd ff ff       	call   801920 <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 07                	push   $0x7
  801c31:	e8 ea fc ff ff       	call   801920 <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_exit_env>:


void sys_exit_env(void)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 1c                	push   $0x1c
  801c4a:	e8 d1 fc ff ff       	call   801920 <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
}
  801c52:	90                   	nop
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c5b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c5e:	8d 50 04             	lea    0x4(%eax),%edx
  801c61:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	52                   	push   %edx
  801c6b:	50                   	push   %eax
  801c6c:	6a 1d                	push   $0x1d
  801c6e:	e8 ad fc ff ff       	call   801920 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
	return result;
  801c76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c7f:	89 01                	mov    %eax,(%ecx)
  801c81:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	c9                   	leave  
  801c88:	c2 04 00             	ret    $0x4

00801c8b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	ff 75 10             	pushl  0x10(%ebp)
  801c95:	ff 75 0c             	pushl  0xc(%ebp)
  801c98:	ff 75 08             	pushl  0x8(%ebp)
  801c9b:	6a 13                	push   $0x13
  801c9d:	e8 7e fc ff ff       	call   801920 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca5:	90                   	nop
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 1e                	push   $0x1e
  801cb7:	e8 64 fc ff ff       	call   801920 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	83 ec 04             	sub    $0x4,%esp
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ccd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	50                   	push   %eax
  801cda:	6a 1f                	push   $0x1f
  801cdc:	e8 3f fc ff ff       	call   801920 <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce4:	90                   	nop
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <rsttst>:
void rsttst()
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 21                	push   $0x21
  801cf6:	e8 25 fc ff ff       	call   801920 <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfe:	90                   	nop
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	83 ec 04             	sub    $0x4,%esp
  801d07:	8b 45 14             	mov    0x14(%ebp),%eax
  801d0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d0d:	8b 55 18             	mov    0x18(%ebp),%edx
  801d10:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d14:	52                   	push   %edx
  801d15:	50                   	push   %eax
  801d16:	ff 75 10             	pushl  0x10(%ebp)
  801d19:	ff 75 0c             	pushl  0xc(%ebp)
  801d1c:	ff 75 08             	pushl  0x8(%ebp)
  801d1f:	6a 20                	push   $0x20
  801d21:	e8 fa fb ff ff       	call   801920 <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
	return ;
  801d29:	90                   	nop
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <chktst>:
void chktst(uint32 n)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	ff 75 08             	pushl  0x8(%ebp)
  801d3a:	6a 22                	push   $0x22
  801d3c:	e8 df fb ff ff       	call   801920 <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
	return ;
  801d44:	90                   	nop
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <inctst>:

void inctst()
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 23                	push   $0x23
  801d56:	e8 c5 fb ff ff       	call   801920 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5e:	90                   	nop
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <gettst>:
uint32 gettst()
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 24                	push   $0x24
  801d70:	e8 ab fb ff ff       	call   801920 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 25                	push   $0x25
  801d8c:	e8 8f fb ff ff       	call   801920 <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
  801d94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d97:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d9b:	75 07                	jne    801da4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801da2:	eb 05                	jmp    801da9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801da4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 25                	push   $0x25
  801dbd:	e8 5e fb ff ff       	call   801920 <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
  801dc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dc8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dcc:	75 07                	jne    801dd5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dce:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd3:	eb 05                	jmp    801dda <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 25                	push   $0x25
  801dee:	e8 2d fb ff ff       	call   801920 <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
  801df6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801df9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dfd:	75 07                	jne    801e06 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dff:	b8 01 00 00 00       	mov    $0x1,%eax
  801e04:	eb 05                	jmp    801e0b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 25                	push   $0x25
  801e1f:	e8 fc fa ff ff       	call   801920 <syscall>
  801e24:	83 c4 18             	add    $0x18,%esp
  801e27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e2a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e2e:	75 07                	jne    801e37 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e30:	b8 01 00 00 00       	mov    $0x1,%eax
  801e35:	eb 05                	jmp    801e3c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	ff 75 08             	pushl  0x8(%ebp)
  801e4c:	6a 26                	push   $0x26
  801e4e:	e8 cd fa ff ff       	call   801920 <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
	return ;
  801e56:	90                   	nop
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e5d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e60:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	6a 00                	push   $0x0
  801e6b:	53                   	push   %ebx
  801e6c:	51                   	push   %ecx
  801e6d:	52                   	push   %edx
  801e6e:	50                   	push   %eax
  801e6f:	6a 27                	push   $0x27
  801e71:	e8 aa fa ff ff       	call   801920 <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
}
  801e79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e84:	8b 45 08             	mov    0x8(%ebp),%eax
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	52                   	push   %edx
  801e8e:	50                   	push   %eax
  801e8f:	6a 28                	push   $0x28
  801e91:	e8 8a fa ff ff       	call   801920 <syscall>
  801e96:	83 c4 18             	add    $0x18,%esp
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e9e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea7:	6a 00                	push   $0x0
  801ea9:	51                   	push   %ecx
  801eaa:	ff 75 10             	pushl  0x10(%ebp)
  801ead:	52                   	push   %edx
  801eae:	50                   	push   %eax
  801eaf:	6a 29                	push   $0x29
  801eb1:	e8 6a fa ff ff       	call   801920 <syscall>
  801eb6:	83 c4 18             	add    $0x18,%esp
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	ff 75 10             	pushl  0x10(%ebp)
  801ec5:	ff 75 0c             	pushl  0xc(%ebp)
  801ec8:	ff 75 08             	pushl  0x8(%ebp)
  801ecb:	6a 12                	push   $0x12
  801ecd:	e8 4e fa ff ff       	call   801920 <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed5:	90                   	nop
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	52                   	push   %edx
  801ee8:	50                   	push   %eax
  801ee9:	6a 2a                	push   $0x2a
  801eeb:	e8 30 fa ff ff       	call   801920 <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
	return;
  801ef3:	90                   	nop
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	50                   	push   %eax
  801f05:	6a 2b                	push   $0x2b
  801f07:	e8 14 fa ff ff       	call   801920 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	ff 75 0c             	pushl  0xc(%ebp)
  801f1d:	ff 75 08             	pushl  0x8(%ebp)
  801f20:	6a 2c                	push   $0x2c
  801f22:	e8 f9 f9 ff ff       	call   801920 <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
	return;
  801f2a:	90                   	nop
}
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	ff 75 0c             	pushl  0xc(%ebp)
  801f39:	ff 75 08             	pushl  0x8(%ebp)
  801f3c:	6a 2d                	push   $0x2d
  801f3e:	e8 dd f9 ff ff       	call   801920 <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
	return;
  801f46:	90                   	nop
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	83 e8 04             	sub    $0x4,%eax
  801f55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f5b:	8b 00                	mov    (%eax),%eax
  801f5d:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f68:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6b:	83 e8 04             	sub    $0x4,%eax
  801f6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f74:	8b 00                	mov    (%eax),%eax
  801f76:	83 e0 01             	and    $0x1,%eax
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	0f 94 c0             	sete   %al
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f90:	83 f8 02             	cmp    $0x2,%eax
  801f93:	74 2b                	je     801fc0 <alloc_block+0x40>
  801f95:	83 f8 02             	cmp    $0x2,%eax
  801f98:	7f 07                	jg     801fa1 <alloc_block+0x21>
  801f9a:	83 f8 01             	cmp    $0x1,%eax
  801f9d:	74 0e                	je     801fad <alloc_block+0x2d>
  801f9f:	eb 58                	jmp    801ff9 <alloc_block+0x79>
  801fa1:	83 f8 03             	cmp    $0x3,%eax
  801fa4:	74 2d                	je     801fd3 <alloc_block+0x53>
  801fa6:	83 f8 04             	cmp    $0x4,%eax
  801fa9:	74 3b                	je     801fe6 <alloc_block+0x66>
  801fab:	eb 4c                	jmp    801ff9 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801fad:	83 ec 0c             	sub    $0xc,%esp
  801fb0:	ff 75 08             	pushl  0x8(%ebp)
  801fb3:	e8 11 03 00 00       	call   8022c9 <alloc_block_FF>
  801fb8:	83 c4 10             	add    $0x10,%esp
  801fbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fbe:	eb 4a                	jmp    80200a <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801fc0:	83 ec 0c             	sub    $0xc,%esp
  801fc3:	ff 75 08             	pushl  0x8(%ebp)
  801fc6:	e8 fa 19 00 00       	call   8039c5 <alloc_block_NF>
  801fcb:	83 c4 10             	add    $0x10,%esp
  801fce:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fd1:	eb 37                	jmp    80200a <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fd3:	83 ec 0c             	sub    $0xc,%esp
  801fd6:	ff 75 08             	pushl  0x8(%ebp)
  801fd9:	e8 a7 07 00 00       	call   802785 <alloc_block_BF>
  801fde:	83 c4 10             	add    $0x10,%esp
  801fe1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fe4:	eb 24                	jmp    80200a <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801fe6:	83 ec 0c             	sub    $0xc,%esp
  801fe9:	ff 75 08             	pushl  0x8(%ebp)
  801fec:	e8 b7 19 00 00       	call   8039a8 <alloc_block_WF>
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ff7:	eb 11                	jmp    80200a <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801ff9:	83 ec 0c             	sub    $0xc,%esp
  801ffc:	68 50 44 80 00       	push   $0x804450
  802001:	e8 a8 e6 ff ff       	call   8006ae <cprintf>
  802006:	83 c4 10             	add    $0x10,%esp
		break;
  802009:	90                   	nop
	}
	return va;
  80200a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    

0080200f <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	53                   	push   %ebx
  802013:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802016:	83 ec 0c             	sub    $0xc,%esp
  802019:	68 70 44 80 00       	push   $0x804470
  80201e:	e8 8b e6 ff ff       	call   8006ae <cprintf>
  802023:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802026:	83 ec 0c             	sub    $0xc,%esp
  802029:	68 9b 44 80 00       	push   $0x80449b
  80202e:	e8 7b e6 ff ff       	call   8006ae <cprintf>
  802033:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203c:	eb 37                	jmp    802075 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80203e:	83 ec 0c             	sub    $0xc,%esp
  802041:	ff 75 f4             	pushl  -0xc(%ebp)
  802044:	e8 19 ff ff ff       	call   801f62 <is_free_block>
  802049:	83 c4 10             	add    $0x10,%esp
  80204c:	0f be d8             	movsbl %al,%ebx
  80204f:	83 ec 0c             	sub    $0xc,%esp
  802052:	ff 75 f4             	pushl  -0xc(%ebp)
  802055:	e8 ef fe ff ff       	call   801f49 <get_block_size>
  80205a:	83 c4 10             	add    $0x10,%esp
  80205d:	83 ec 04             	sub    $0x4,%esp
  802060:	53                   	push   %ebx
  802061:	50                   	push   %eax
  802062:	68 b3 44 80 00       	push   $0x8044b3
  802067:	e8 42 e6 ff ff       	call   8006ae <cprintf>
  80206c:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80206f:	8b 45 10             	mov    0x10(%ebp),%eax
  802072:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802075:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802079:	74 07                	je     802082 <print_blocks_list+0x73>
  80207b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207e:	8b 00                	mov    (%eax),%eax
  802080:	eb 05                	jmp    802087 <print_blocks_list+0x78>
  802082:	b8 00 00 00 00       	mov    $0x0,%eax
  802087:	89 45 10             	mov    %eax,0x10(%ebp)
  80208a:	8b 45 10             	mov    0x10(%ebp),%eax
  80208d:	85 c0                	test   %eax,%eax
  80208f:	75 ad                	jne    80203e <print_blocks_list+0x2f>
  802091:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802095:	75 a7                	jne    80203e <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802097:	83 ec 0c             	sub    $0xc,%esp
  80209a:	68 70 44 80 00       	push   $0x804470
  80209f:	e8 0a e6 ff ff       	call   8006ae <cprintf>
  8020a4:	83 c4 10             	add    $0x10,%esp

}
  8020a7:	90                   	nop
  8020a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b6:	83 e0 01             	and    $0x1,%eax
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	74 03                	je     8020c0 <initialize_dynamic_allocator+0x13>
  8020bd:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020c4:	0f 84 c7 01 00 00    	je     802291 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020ca:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020d1:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020da:	01 d0                	add    %edx,%eax
  8020dc:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020e1:	0f 87 ad 01 00 00    	ja     802294 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	0f 89 a5 01 00 00    	jns    802297 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8020f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f8:	01 d0                	add    %edx,%eax
  8020fa:	83 e8 04             	sub    $0x4,%eax
  8020fd:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802102:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802109:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80210e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802111:	e9 87 00 00 00       	jmp    80219d <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802116:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211a:	75 14                	jne    802130 <initialize_dynamic_allocator+0x83>
  80211c:	83 ec 04             	sub    $0x4,%esp
  80211f:	68 cb 44 80 00       	push   $0x8044cb
  802124:	6a 79                	push   $0x79
  802126:	68 e9 44 80 00       	push   $0x8044e9
  80212b:	e8 c1 e2 ff ff       	call   8003f1 <_panic>
  802130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802133:	8b 00                	mov    (%eax),%eax
  802135:	85 c0                	test   %eax,%eax
  802137:	74 10                	je     802149 <initialize_dynamic_allocator+0x9c>
  802139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213c:	8b 00                	mov    (%eax),%eax
  80213e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802141:	8b 52 04             	mov    0x4(%edx),%edx
  802144:	89 50 04             	mov    %edx,0x4(%eax)
  802147:	eb 0b                	jmp    802154 <initialize_dynamic_allocator+0xa7>
  802149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214c:	8b 40 04             	mov    0x4(%eax),%eax
  80214f:	a3 30 50 80 00       	mov    %eax,0x805030
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	8b 40 04             	mov    0x4(%eax),%eax
  80215a:	85 c0                	test   %eax,%eax
  80215c:	74 0f                	je     80216d <initialize_dynamic_allocator+0xc0>
  80215e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802161:	8b 40 04             	mov    0x4(%eax),%eax
  802164:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802167:	8b 12                	mov    (%edx),%edx
  802169:	89 10                	mov    %edx,(%eax)
  80216b:	eb 0a                	jmp    802177 <initialize_dynamic_allocator+0xca>
  80216d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802170:	8b 00                	mov    (%eax),%eax
  802172:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80218a:	a1 38 50 80 00       	mov    0x805038,%eax
  80218f:	48                   	dec    %eax
  802190:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802195:	a1 34 50 80 00       	mov    0x805034,%eax
  80219a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a1:	74 07                	je     8021aa <initialize_dynamic_allocator+0xfd>
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	8b 00                	mov    (%eax),%eax
  8021a8:	eb 05                	jmp    8021af <initialize_dynamic_allocator+0x102>
  8021aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8021af:	a3 34 50 80 00       	mov    %eax,0x805034
  8021b4:	a1 34 50 80 00       	mov    0x805034,%eax
  8021b9:	85 c0                	test   %eax,%eax
  8021bb:	0f 85 55 ff ff ff    	jne    802116 <initialize_dynamic_allocator+0x69>
  8021c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c5:	0f 85 4b ff ff ff    	jne    802116 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021da:	a1 44 50 80 00       	mov    0x805044,%eax
  8021df:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8021e4:	a1 40 50 80 00       	mov    0x805040,%eax
  8021e9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	83 c0 08             	add    $0x8,%eax
  8021f5:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	83 c0 04             	add    $0x4,%eax
  8021fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802201:	83 ea 08             	sub    $0x8,%edx
  802204:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802206:	8b 55 0c             	mov    0xc(%ebp),%edx
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	01 d0                	add    %edx,%eax
  80220e:	83 e8 08             	sub    $0x8,%eax
  802211:	8b 55 0c             	mov    0xc(%ebp),%edx
  802214:	83 ea 08             	sub    $0x8,%edx
  802217:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802219:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802222:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802225:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80222c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802230:	75 17                	jne    802249 <initialize_dynamic_allocator+0x19c>
  802232:	83 ec 04             	sub    $0x4,%esp
  802235:	68 04 45 80 00       	push   $0x804504
  80223a:	68 90 00 00 00       	push   $0x90
  80223f:	68 e9 44 80 00       	push   $0x8044e9
  802244:	e8 a8 e1 ff ff       	call   8003f1 <_panic>
  802249:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80224f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802252:	89 10                	mov    %edx,(%eax)
  802254:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802257:	8b 00                	mov    (%eax),%eax
  802259:	85 c0                	test   %eax,%eax
  80225b:	74 0d                	je     80226a <initialize_dynamic_allocator+0x1bd>
  80225d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802262:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802265:	89 50 04             	mov    %edx,0x4(%eax)
  802268:	eb 08                	jmp    802272 <initialize_dynamic_allocator+0x1c5>
  80226a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226d:	a3 30 50 80 00       	mov    %eax,0x805030
  802272:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802275:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80227a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802284:	a1 38 50 80 00       	mov    0x805038,%eax
  802289:	40                   	inc    %eax
  80228a:	a3 38 50 80 00       	mov    %eax,0x805038
  80228f:	eb 07                	jmp    802298 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802291:	90                   	nop
  802292:	eb 04                	jmp    802298 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802294:	90                   	nop
  802295:	eb 01                	jmp    802298 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802297:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80229d:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a0:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ac:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	83 e8 04             	sub    $0x4,%eax
  8022b4:	8b 00                	mov    (%eax),%eax
  8022b6:	83 e0 fe             	and    $0xfffffffe,%eax
  8022b9:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	01 c2                	add    %eax,%edx
  8022c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c4:	89 02                	mov    %eax,(%edx)
}
  8022c6:	90                   	nop
  8022c7:	5d                   	pop    %ebp
  8022c8:	c3                   	ret    

008022c9 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	83 e0 01             	and    $0x1,%eax
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	74 03                	je     8022dc <alloc_block_FF+0x13>
  8022d9:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022dc:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022e0:	77 07                	ja     8022e9 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022e2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022e9:	a1 24 50 80 00       	mov    0x805024,%eax
  8022ee:	85 c0                	test   %eax,%eax
  8022f0:	75 73                	jne    802365 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	83 c0 10             	add    $0x10,%eax
  8022f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022fb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802302:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802305:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802308:	01 d0                	add    %edx,%eax
  80230a:	48                   	dec    %eax
  80230b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80230e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802311:	ba 00 00 00 00       	mov    $0x0,%edx
  802316:	f7 75 ec             	divl   -0x14(%ebp)
  802319:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80231c:	29 d0                	sub    %edx,%eax
  80231e:	c1 e8 0c             	shr    $0xc,%eax
  802321:	83 ec 0c             	sub    $0xc,%esp
  802324:	50                   	push   %eax
  802325:	e8 1e f1 ff ff       	call   801448 <sbrk>
  80232a:	83 c4 10             	add    $0x10,%esp
  80232d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802330:	83 ec 0c             	sub    $0xc,%esp
  802333:	6a 00                	push   $0x0
  802335:	e8 0e f1 ff ff       	call   801448 <sbrk>
  80233a:	83 c4 10             	add    $0x10,%esp
  80233d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802340:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802343:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802346:	83 ec 08             	sub    $0x8,%esp
  802349:	50                   	push   %eax
  80234a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80234d:	e8 5b fd ff ff       	call   8020ad <initialize_dynamic_allocator>
  802352:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802355:	83 ec 0c             	sub    $0xc,%esp
  802358:	68 27 45 80 00       	push   $0x804527
  80235d:	e8 4c e3 ff ff       	call   8006ae <cprintf>
  802362:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802365:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802369:	75 0a                	jne    802375 <alloc_block_FF+0xac>
	        return NULL;
  80236b:	b8 00 00 00 00       	mov    $0x0,%eax
  802370:	e9 0e 04 00 00       	jmp    802783 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802375:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80237c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802381:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802384:	e9 f3 02 00 00       	jmp    80267c <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80238f:	83 ec 0c             	sub    $0xc,%esp
  802392:	ff 75 bc             	pushl  -0x44(%ebp)
  802395:	e8 af fb ff ff       	call   801f49 <get_block_size>
  80239a:	83 c4 10             	add    $0x10,%esp
  80239d:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	83 c0 08             	add    $0x8,%eax
  8023a6:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023a9:	0f 87 c5 02 00 00    	ja     802674 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	83 c0 18             	add    $0x18,%eax
  8023b5:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023b8:	0f 87 19 02 00 00    	ja     8025d7 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023be:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023c1:	2b 45 08             	sub    0x8(%ebp),%eax
  8023c4:	83 e8 08             	sub    $0x8,%eax
  8023c7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	8d 50 08             	lea    0x8(%eax),%edx
  8023d0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023d3:	01 d0                	add    %edx,%eax
  8023d5:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	83 c0 08             	add    $0x8,%eax
  8023de:	83 ec 04             	sub    $0x4,%esp
  8023e1:	6a 01                	push   $0x1
  8023e3:	50                   	push   %eax
  8023e4:	ff 75 bc             	pushl  -0x44(%ebp)
  8023e7:	e8 ae fe ff ff       	call   80229a <set_block_data>
  8023ec:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	8b 40 04             	mov    0x4(%eax),%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	75 68                	jne    802461 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023f9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023fd:	75 17                	jne    802416 <alloc_block_FF+0x14d>
  8023ff:	83 ec 04             	sub    $0x4,%esp
  802402:	68 04 45 80 00       	push   $0x804504
  802407:	68 d7 00 00 00       	push   $0xd7
  80240c:	68 e9 44 80 00       	push   $0x8044e9
  802411:	e8 db df ff ff       	call   8003f1 <_panic>
  802416:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80241c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80241f:	89 10                	mov    %edx,(%eax)
  802421:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802424:	8b 00                	mov    (%eax),%eax
  802426:	85 c0                	test   %eax,%eax
  802428:	74 0d                	je     802437 <alloc_block_FF+0x16e>
  80242a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80242f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802432:	89 50 04             	mov    %edx,0x4(%eax)
  802435:	eb 08                	jmp    80243f <alloc_block_FF+0x176>
  802437:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80243a:	a3 30 50 80 00       	mov    %eax,0x805030
  80243f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802442:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802447:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802451:	a1 38 50 80 00       	mov    0x805038,%eax
  802456:	40                   	inc    %eax
  802457:	a3 38 50 80 00       	mov    %eax,0x805038
  80245c:	e9 dc 00 00 00       	jmp    80253d <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	8b 00                	mov    (%eax),%eax
  802466:	85 c0                	test   %eax,%eax
  802468:	75 65                	jne    8024cf <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80246a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80246e:	75 17                	jne    802487 <alloc_block_FF+0x1be>
  802470:	83 ec 04             	sub    $0x4,%esp
  802473:	68 38 45 80 00       	push   $0x804538
  802478:	68 db 00 00 00       	push   $0xdb
  80247d:	68 e9 44 80 00       	push   $0x8044e9
  802482:	e8 6a df ff ff       	call   8003f1 <_panic>
  802487:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80248d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802490:	89 50 04             	mov    %edx,0x4(%eax)
  802493:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802496:	8b 40 04             	mov    0x4(%eax),%eax
  802499:	85 c0                	test   %eax,%eax
  80249b:	74 0c                	je     8024a9 <alloc_block_FF+0x1e0>
  80249d:	a1 30 50 80 00       	mov    0x805030,%eax
  8024a2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024a5:	89 10                	mov    %edx,(%eax)
  8024a7:	eb 08                	jmp    8024b1 <alloc_block_FF+0x1e8>
  8024a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ac:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024b1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8024b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c2:	a1 38 50 80 00       	mov    0x805038,%eax
  8024c7:	40                   	inc    %eax
  8024c8:	a3 38 50 80 00       	mov    %eax,0x805038
  8024cd:	eb 6e                	jmp    80253d <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d3:	74 06                	je     8024db <alloc_block_FF+0x212>
  8024d5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024d9:	75 17                	jne    8024f2 <alloc_block_FF+0x229>
  8024db:	83 ec 04             	sub    $0x4,%esp
  8024de:	68 5c 45 80 00       	push   $0x80455c
  8024e3:	68 df 00 00 00       	push   $0xdf
  8024e8:	68 e9 44 80 00       	push   $0x8044e9
  8024ed:	e8 ff de ff ff       	call   8003f1 <_panic>
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	8b 10                	mov    (%eax),%edx
  8024f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024fa:	89 10                	mov    %edx,(%eax)
  8024fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ff:	8b 00                	mov    (%eax),%eax
  802501:	85 c0                	test   %eax,%eax
  802503:	74 0b                	je     802510 <alloc_block_FF+0x247>
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 00                	mov    (%eax),%eax
  80250a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80250d:	89 50 04             	mov    %edx,0x4(%eax)
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802516:	89 10                	mov    %edx,(%eax)
  802518:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80251b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251e:	89 50 04             	mov    %edx,0x4(%eax)
  802521:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802524:	8b 00                	mov    (%eax),%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	75 08                	jne    802532 <alloc_block_FF+0x269>
  80252a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80252d:	a3 30 50 80 00       	mov    %eax,0x805030
  802532:	a1 38 50 80 00       	mov    0x805038,%eax
  802537:	40                   	inc    %eax
  802538:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80253d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802541:	75 17                	jne    80255a <alloc_block_FF+0x291>
  802543:	83 ec 04             	sub    $0x4,%esp
  802546:	68 cb 44 80 00       	push   $0x8044cb
  80254b:	68 e1 00 00 00       	push   $0xe1
  802550:	68 e9 44 80 00       	push   $0x8044e9
  802555:	e8 97 de ff ff       	call   8003f1 <_panic>
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 00                	mov    (%eax),%eax
  80255f:	85 c0                	test   %eax,%eax
  802561:	74 10                	je     802573 <alloc_block_FF+0x2aa>
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 00                	mov    (%eax),%eax
  802568:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256b:	8b 52 04             	mov    0x4(%edx),%edx
  80256e:	89 50 04             	mov    %edx,0x4(%eax)
  802571:	eb 0b                	jmp    80257e <alloc_block_FF+0x2b5>
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 40 04             	mov    0x4(%eax),%eax
  802579:	a3 30 50 80 00       	mov    %eax,0x805030
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	8b 40 04             	mov    0x4(%eax),%eax
  802584:	85 c0                	test   %eax,%eax
  802586:	74 0f                	je     802597 <alloc_block_FF+0x2ce>
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 40 04             	mov    0x4(%eax),%eax
  80258e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802591:	8b 12                	mov    (%edx),%edx
  802593:	89 10                	mov    %edx,(%eax)
  802595:	eb 0a                	jmp    8025a1 <alloc_block_FF+0x2d8>
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 00                	mov    (%eax),%eax
  80259c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b4:	a1 38 50 80 00       	mov    0x805038,%eax
  8025b9:	48                   	dec    %eax
  8025ba:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025bf:	83 ec 04             	sub    $0x4,%esp
  8025c2:	6a 00                	push   $0x0
  8025c4:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025c7:	ff 75 b0             	pushl  -0x50(%ebp)
  8025ca:	e8 cb fc ff ff       	call   80229a <set_block_data>
  8025cf:	83 c4 10             	add    $0x10,%esp
  8025d2:	e9 95 00 00 00       	jmp    80266c <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025d7:	83 ec 04             	sub    $0x4,%esp
  8025da:	6a 01                	push   $0x1
  8025dc:	ff 75 b8             	pushl  -0x48(%ebp)
  8025df:	ff 75 bc             	pushl  -0x44(%ebp)
  8025e2:	e8 b3 fc ff ff       	call   80229a <set_block_data>
  8025e7:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ee:	75 17                	jne    802607 <alloc_block_FF+0x33e>
  8025f0:	83 ec 04             	sub    $0x4,%esp
  8025f3:	68 cb 44 80 00       	push   $0x8044cb
  8025f8:	68 e8 00 00 00       	push   $0xe8
  8025fd:	68 e9 44 80 00       	push   $0x8044e9
  802602:	e8 ea dd ff ff       	call   8003f1 <_panic>
  802607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260a:	8b 00                	mov    (%eax),%eax
  80260c:	85 c0                	test   %eax,%eax
  80260e:	74 10                	je     802620 <alloc_block_FF+0x357>
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	8b 00                	mov    (%eax),%eax
  802615:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802618:	8b 52 04             	mov    0x4(%edx),%edx
  80261b:	89 50 04             	mov    %edx,0x4(%eax)
  80261e:	eb 0b                	jmp    80262b <alloc_block_FF+0x362>
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 40 04             	mov    0x4(%eax),%eax
  802626:	a3 30 50 80 00       	mov    %eax,0x805030
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	8b 40 04             	mov    0x4(%eax),%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	74 0f                	je     802644 <alloc_block_FF+0x37b>
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 40 04             	mov    0x4(%eax),%eax
  80263b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263e:	8b 12                	mov    (%edx),%edx
  802640:	89 10                	mov    %edx,(%eax)
  802642:	eb 0a                	jmp    80264e <alloc_block_FF+0x385>
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 00                	mov    (%eax),%eax
  802649:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802661:	a1 38 50 80 00       	mov    0x805038,%eax
  802666:	48                   	dec    %eax
  802667:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80266c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80266f:	e9 0f 01 00 00       	jmp    802783 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802674:	a1 34 50 80 00       	mov    0x805034,%eax
  802679:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802680:	74 07                	je     802689 <alloc_block_FF+0x3c0>
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	8b 00                	mov    (%eax),%eax
  802687:	eb 05                	jmp    80268e <alloc_block_FF+0x3c5>
  802689:	b8 00 00 00 00       	mov    $0x0,%eax
  80268e:	a3 34 50 80 00       	mov    %eax,0x805034
  802693:	a1 34 50 80 00       	mov    0x805034,%eax
  802698:	85 c0                	test   %eax,%eax
  80269a:	0f 85 e9 fc ff ff    	jne    802389 <alloc_block_FF+0xc0>
  8026a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a4:	0f 85 df fc ff ff    	jne    802389 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ad:	83 c0 08             	add    $0x8,%eax
  8026b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026b3:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026ba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026c0:	01 d0                	add    %edx,%eax
  8026c2:	48                   	dec    %eax
  8026c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ce:	f7 75 d8             	divl   -0x28(%ebp)
  8026d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026d4:	29 d0                	sub    %edx,%eax
  8026d6:	c1 e8 0c             	shr    $0xc,%eax
  8026d9:	83 ec 0c             	sub    $0xc,%esp
  8026dc:	50                   	push   %eax
  8026dd:	e8 66 ed ff ff       	call   801448 <sbrk>
  8026e2:	83 c4 10             	add    $0x10,%esp
  8026e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026e8:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026ec:	75 0a                	jne    8026f8 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8026ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f3:	e9 8b 00 00 00       	jmp    802783 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8026f8:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026ff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802702:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802705:	01 d0                	add    %edx,%eax
  802707:	48                   	dec    %eax
  802708:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80270b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80270e:	ba 00 00 00 00       	mov    $0x0,%edx
  802713:	f7 75 cc             	divl   -0x34(%ebp)
  802716:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802719:	29 d0                	sub    %edx,%eax
  80271b:	8d 50 fc             	lea    -0x4(%eax),%edx
  80271e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802721:	01 d0                	add    %edx,%eax
  802723:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802728:	a1 40 50 80 00       	mov    0x805040,%eax
  80272d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802733:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80273a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80273d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802740:	01 d0                	add    %edx,%eax
  802742:	48                   	dec    %eax
  802743:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802746:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802749:	ba 00 00 00 00       	mov    $0x0,%edx
  80274e:	f7 75 c4             	divl   -0x3c(%ebp)
  802751:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802754:	29 d0                	sub    %edx,%eax
  802756:	83 ec 04             	sub    $0x4,%esp
  802759:	6a 01                	push   $0x1
  80275b:	50                   	push   %eax
  80275c:	ff 75 d0             	pushl  -0x30(%ebp)
  80275f:	e8 36 fb ff ff       	call   80229a <set_block_data>
  802764:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802767:	83 ec 0c             	sub    $0xc,%esp
  80276a:	ff 75 d0             	pushl  -0x30(%ebp)
  80276d:	e8 1b 0a 00 00       	call   80318d <free_block>
  802772:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802775:	83 ec 0c             	sub    $0xc,%esp
  802778:	ff 75 08             	pushl  0x8(%ebp)
  80277b:	e8 49 fb ff ff       	call   8022c9 <alloc_block_FF>
  802780:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802783:	c9                   	leave  
  802784:	c3                   	ret    

00802785 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802785:	55                   	push   %ebp
  802786:	89 e5                	mov    %esp,%ebp
  802788:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80278b:	8b 45 08             	mov    0x8(%ebp),%eax
  80278e:	83 e0 01             	and    $0x1,%eax
  802791:	85 c0                	test   %eax,%eax
  802793:	74 03                	je     802798 <alloc_block_BF+0x13>
  802795:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802798:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80279c:	77 07                	ja     8027a5 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80279e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027a5:	a1 24 50 80 00       	mov    0x805024,%eax
  8027aa:	85 c0                	test   %eax,%eax
  8027ac:	75 73                	jne    802821 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b1:	83 c0 10             	add    $0x10,%eax
  8027b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027b7:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c4:	01 d0                	add    %edx,%eax
  8027c6:	48                   	dec    %eax
  8027c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d2:	f7 75 e0             	divl   -0x20(%ebp)
  8027d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027d8:	29 d0                	sub    %edx,%eax
  8027da:	c1 e8 0c             	shr    $0xc,%eax
  8027dd:	83 ec 0c             	sub    $0xc,%esp
  8027e0:	50                   	push   %eax
  8027e1:	e8 62 ec ff ff       	call   801448 <sbrk>
  8027e6:	83 c4 10             	add    $0x10,%esp
  8027e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027ec:	83 ec 0c             	sub    $0xc,%esp
  8027ef:	6a 00                	push   $0x0
  8027f1:	e8 52 ec ff ff       	call   801448 <sbrk>
  8027f6:	83 c4 10             	add    $0x10,%esp
  8027f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027ff:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802802:	83 ec 08             	sub    $0x8,%esp
  802805:	50                   	push   %eax
  802806:	ff 75 d8             	pushl  -0x28(%ebp)
  802809:	e8 9f f8 ff ff       	call   8020ad <initialize_dynamic_allocator>
  80280e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802811:	83 ec 0c             	sub    $0xc,%esp
  802814:	68 27 45 80 00       	push   $0x804527
  802819:	e8 90 de ff ff       	call   8006ae <cprintf>
  80281e:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802821:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802828:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80282f:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802836:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80283d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802842:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802845:	e9 1d 01 00 00       	jmp    802967 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802850:	83 ec 0c             	sub    $0xc,%esp
  802853:	ff 75 a8             	pushl  -0x58(%ebp)
  802856:	e8 ee f6 ff ff       	call   801f49 <get_block_size>
  80285b:	83 c4 10             	add    $0x10,%esp
  80285e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802861:	8b 45 08             	mov    0x8(%ebp),%eax
  802864:	83 c0 08             	add    $0x8,%eax
  802867:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80286a:	0f 87 ef 00 00 00    	ja     80295f <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802870:	8b 45 08             	mov    0x8(%ebp),%eax
  802873:	83 c0 18             	add    $0x18,%eax
  802876:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802879:	77 1d                	ja     802898 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80287b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802881:	0f 86 d8 00 00 00    	jbe    80295f <alloc_block_BF+0x1da>
				{
					best_va = va;
  802887:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80288a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80288d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802890:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802893:	e9 c7 00 00 00       	jmp    80295f <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	83 c0 08             	add    $0x8,%eax
  80289e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028a1:	0f 85 9d 00 00 00    	jne    802944 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028a7:	83 ec 04             	sub    $0x4,%esp
  8028aa:	6a 01                	push   $0x1
  8028ac:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028af:	ff 75 a8             	pushl  -0x58(%ebp)
  8028b2:	e8 e3 f9 ff ff       	call   80229a <set_block_data>
  8028b7:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028be:	75 17                	jne    8028d7 <alloc_block_BF+0x152>
  8028c0:	83 ec 04             	sub    $0x4,%esp
  8028c3:	68 cb 44 80 00       	push   $0x8044cb
  8028c8:	68 2c 01 00 00       	push   $0x12c
  8028cd:	68 e9 44 80 00       	push   $0x8044e9
  8028d2:	e8 1a db ff ff       	call   8003f1 <_panic>
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	8b 00                	mov    (%eax),%eax
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	74 10                	je     8028f0 <alloc_block_BF+0x16b>
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e8:	8b 52 04             	mov    0x4(%edx),%edx
  8028eb:	89 50 04             	mov    %edx,0x4(%eax)
  8028ee:	eb 0b                	jmp    8028fb <alloc_block_BF+0x176>
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	8b 40 04             	mov    0x4(%eax),%eax
  8028f6:	a3 30 50 80 00       	mov    %eax,0x805030
  8028fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fe:	8b 40 04             	mov    0x4(%eax),%eax
  802901:	85 c0                	test   %eax,%eax
  802903:	74 0f                	je     802914 <alloc_block_BF+0x18f>
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 40 04             	mov    0x4(%eax),%eax
  80290b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290e:	8b 12                	mov    (%edx),%edx
  802910:	89 10                	mov    %edx,(%eax)
  802912:	eb 0a                	jmp    80291e <alloc_block_BF+0x199>
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 00                	mov    (%eax),%eax
  802919:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802931:	a1 38 50 80 00       	mov    0x805038,%eax
  802936:	48                   	dec    %eax
  802937:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80293c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80293f:	e9 24 04 00 00       	jmp    802d68 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802944:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802947:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80294a:	76 13                	jbe    80295f <alloc_block_BF+0x1da>
					{
						internal = 1;
  80294c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802953:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802956:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802959:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80295c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80295f:	a1 34 50 80 00       	mov    0x805034,%eax
  802964:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802967:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296b:	74 07                	je     802974 <alloc_block_BF+0x1ef>
  80296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802970:	8b 00                	mov    (%eax),%eax
  802972:	eb 05                	jmp    802979 <alloc_block_BF+0x1f4>
  802974:	b8 00 00 00 00       	mov    $0x0,%eax
  802979:	a3 34 50 80 00       	mov    %eax,0x805034
  80297e:	a1 34 50 80 00       	mov    0x805034,%eax
  802983:	85 c0                	test   %eax,%eax
  802985:	0f 85 bf fe ff ff    	jne    80284a <alloc_block_BF+0xc5>
  80298b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298f:	0f 85 b5 fe ff ff    	jne    80284a <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802995:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802999:	0f 84 26 02 00 00    	je     802bc5 <alloc_block_BF+0x440>
  80299f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029a3:	0f 85 1c 02 00 00    	jne    802bc5 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ac:	2b 45 08             	sub    0x8(%ebp),%eax
  8029af:	83 e8 08             	sub    $0x8,%eax
  8029b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b8:	8d 50 08             	lea    0x8(%eax),%edx
  8029bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029be:	01 d0                	add    %edx,%eax
  8029c0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c6:	83 c0 08             	add    $0x8,%eax
  8029c9:	83 ec 04             	sub    $0x4,%esp
  8029cc:	6a 01                	push   $0x1
  8029ce:	50                   	push   %eax
  8029cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8029d2:	e8 c3 f8 ff ff       	call   80229a <set_block_data>
  8029d7:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dd:	8b 40 04             	mov    0x4(%eax),%eax
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	75 68                	jne    802a4c <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029e4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029e8:	75 17                	jne    802a01 <alloc_block_BF+0x27c>
  8029ea:	83 ec 04             	sub    $0x4,%esp
  8029ed:	68 04 45 80 00       	push   $0x804504
  8029f2:	68 45 01 00 00       	push   $0x145
  8029f7:	68 e9 44 80 00       	push   $0x8044e9
  8029fc:	e8 f0 d9 ff ff       	call   8003f1 <_panic>
  802a01:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a07:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0a:	89 10                	mov    %edx,(%eax)
  802a0c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0f:	8b 00                	mov    (%eax),%eax
  802a11:	85 c0                	test   %eax,%eax
  802a13:	74 0d                	je     802a22 <alloc_block_BF+0x29d>
  802a15:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a1a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a1d:	89 50 04             	mov    %edx,0x4(%eax)
  802a20:	eb 08                	jmp    802a2a <alloc_block_BF+0x2a5>
  802a22:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a25:	a3 30 50 80 00       	mov    %eax,0x805030
  802a2a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a2d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a32:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3c:	a1 38 50 80 00       	mov    0x805038,%eax
  802a41:	40                   	inc    %eax
  802a42:	a3 38 50 80 00       	mov    %eax,0x805038
  802a47:	e9 dc 00 00 00       	jmp    802b28 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4f:	8b 00                	mov    (%eax),%eax
  802a51:	85 c0                	test   %eax,%eax
  802a53:	75 65                	jne    802aba <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a55:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a59:	75 17                	jne    802a72 <alloc_block_BF+0x2ed>
  802a5b:	83 ec 04             	sub    $0x4,%esp
  802a5e:	68 38 45 80 00       	push   $0x804538
  802a63:	68 4a 01 00 00       	push   $0x14a
  802a68:	68 e9 44 80 00       	push   $0x8044e9
  802a6d:	e8 7f d9 ff ff       	call   8003f1 <_panic>
  802a72:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7b:	89 50 04             	mov    %edx,0x4(%eax)
  802a7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a81:	8b 40 04             	mov    0x4(%eax),%eax
  802a84:	85 c0                	test   %eax,%eax
  802a86:	74 0c                	je     802a94 <alloc_block_BF+0x30f>
  802a88:	a1 30 50 80 00       	mov    0x805030,%eax
  802a8d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a90:	89 10                	mov    %edx,(%eax)
  802a92:	eb 08                	jmp    802a9c <alloc_block_BF+0x317>
  802a94:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a97:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a9c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a9f:	a3 30 50 80 00       	mov    %eax,0x805030
  802aa4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aad:	a1 38 50 80 00       	mov    0x805038,%eax
  802ab2:	40                   	inc    %eax
  802ab3:	a3 38 50 80 00       	mov    %eax,0x805038
  802ab8:	eb 6e                	jmp    802b28 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802aba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802abe:	74 06                	je     802ac6 <alloc_block_BF+0x341>
  802ac0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ac4:	75 17                	jne    802add <alloc_block_BF+0x358>
  802ac6:	83 ec 04             	sub    $0x4,%esp
  802ac9:	68 5c 45 80 00       	push   $0x80455c
  802ace:	68 4f 01 00 00       	push   $0x14f
  802ad3:	68 e9 44 80 00       	push   $0x8044e9
  802ad8:	e8 14 d9 ff ff       	call   8003f1 <_panic>
  802add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae0:	8b 10                	mov    (%eax),%edx
  802ae2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae5:	89 10                	mov    %edx,(%eax)
  802ae7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aea:	8b 00                	mov    (%eax),%eax
  802aec:	85 c0                	test   %eax,%eax
  802aee:	74 0b                	je     802afb <alloc_block_BF+0x376>
  802af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af3:	8b 00                	mov    (%eax),%eax
  802af5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802af8:	89 50 04             	mov    %edx,0x4(%eax)
  802afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afe:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b01:	89 10                	mov    %edx,(%eax)
  802b03:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b06:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b09:	89 50 04             	mov    %edx,0x4(%eax)
  802b0c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	85 c0                	test   %eax,%eax
  802b13:	75 08                	jne    802b1d <alloc_block_BF+0x398>
  802b15:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b18:	a3 30 50 80 00       	mov    %eax,0x805030
  802b1d:	a1 38 50 80 00       	mov    0x805038,%eax
  802b22:	40                   	inc    %eax
  802b23:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b2c:	75 17                	jne    802b45 <alloc_block_BF+0x3c0>
  802b2e:	83 ec 04             	sub    $0x4,%esp
  802b31:	68 cb 44 80 00       	push   $0x8044cb
  802b36:	68 51 01 00 00       	push   $0x151
  802b3b:	68 e9 44 80 00       	push   $0x8044e9
  802b40:	e8 ac d8 ff ff       	call   8003f1 <_panic>
  802b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b48:	8b 00                	mov    (%eax),%eax
  802b4a:	85 c0                	test   %eax,%eax
  802b4c:	74 10                	je     802b5e <alloc_block_BF+0x3d9>
  802b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b51:	8b 00                	mov    (%eax),%eax
  802b53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b56:	8b 52 04             	mov    0x4(%edx),%edx
  802b59:	89 50 04             	mov    %edx,0x4(%eax)
  802b5c:	eb 0b                	jmp    802b69 <alloc_block_BF+0x3e4>
  802b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b61:	8b 40 04             	mov    0x4(%eax),%eax
  802b64:	a3 30 50 80 00       	mov    %eax,0x805030
  802b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6c:	8b 40 04             	mov    0x4(%eax),%eax
  802b6f:	85 c0                	test   %eax,%eax
  802b71:	74 0f                	je     802b82 <alloc_block_BF+0x3fd>
  802b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b76:	8b 40 04             	mov    0x4(%eax),%eax
  802b79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b7c:	8b 12                	mov    (%edx),%edx
  802b7e:	89 10                	mov    %edx,(%eax)
  802b80:	eb 0a                	jmp    802b8c <alloc_block_BF+0x407>
  802b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9f:	a1 38 50 80 00       	mov    0x805038,%eax
  802ba4:	48                   	dec    %eax
  802ba5:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802baa:	83 ec 04             	sub    $0x4,%esp
  802bad:	6a 00                	push   $0x0
  802baf:	ff 75 d0             	pushl  -0x30(%ebp)
  802bb2:	ff 75 cc             	pushl  -0x34(%ebp)
  802bb5:	e8 e0 f6 ff ff       	call   80229a <set_block_data>
  802bba:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc0:	e9 a3 01 00 00       	jmp    802d68 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802bc5:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bc9:	0f 85 9d 00 00 00    	jne    802c6c <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802bcf:	83 ec 04             	sub    $0x4,%esp
  802bd2:	6a 01                	push   $0x1
  802bd4:	ff 75 ec             	pushl  -0x14(%ebp)
  802bd7:	ff 75 f0             	pushl  -0x10(%ebp)
  802bda:	e8 bb f6 ff ff       	call   80229a <set_block_data>
  802bdf:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802be2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802be6:	75 17                	jne    802bff <alloc_block_BF+0x47a>
  802be8:	83 ec 04             	sub    $0x4,%esp
  802beb:	68 cb 44 80 00       	push   $0x8044cb
  802bf0:	68 58 01 00 00       	push   $0x158
  802bf5:	68 e9 44 80 00       	push   $0x8044e9
  802bfa:	e8 f2 d7 ff ff       	call   8003f1 <_panic>
  802bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c02:	8b 00                	mov    (%eax),%eax
  802c04:	85 c0                	test   %eax,%eax
  802c06:	74 10                	je     802c18 <alloc_block_BF+0x493>
  802c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0b:	8b 00                	mov    (%eax),%eax
  802c0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c10:	8b 52 04             	mov    0x4(%edx),%edx
  802c13:	89 50 04             	mov    %edx,0x4(%eax)
  802c16:	eb 0b                	jmp    802c23 <alloc_block_BF+0x49e>
  802c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1b:	8b 40 04             	mov    0x4(%eax),%eax
  802c1e:	a3 30 50 80 00       	mov    %eax,0x805030
  802c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c26:	8b 40 04             	mov    0x4(%eax),%eax
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	74 0f                	je     802c3c <alloc_block_BF+0x4b7>
  802c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c30:	8b 40 04             	mov    0x4(%eax),%eax
  802c33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c36:	8b 12                	mov    (%edx),%edx
  802c38:	89 10                	mov    %edx,(%eax)
  802c3a:	eb 0a                	jmp    802c46 <alloc_block_BF+0x4c1>
  802c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3f:	8b 00                	mov    (%eax),%eax
  802c41:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c59:	a1 38 50 80 00       	mov    0x805038,%eax
  802c5e:	48                   	dec    %eax
  802c5f:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c67:	e9 fc 00 00 00       	jmp    802d68 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6f:	83 c0 08             	add    $0x8,%eax
  802c72:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c75:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c7c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c7f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c82:	01 d0                	add    %edx,%eax
  802c84:	48                   	dec    %eax
  802c85:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c88:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c8b:	ba 00 00 00 00       	mov    $0x0,%edx
  802c90:	f7 75 c4             	divl   -0x3c(%ebp)
  802c93:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c96:	29 d0                	sub    %edx,%eax
  802c98:	c1 e8 0c             	shr    $0xc,%eax
  802c9b:	83 ec 0c             	sub    $0xc,%esp
  802c9e:	50                   	push   %eax
  802c9f:	e8 a4 e7 ff ff       	call   801448 <sbrk>
  802ca4:	83 c4 10             	add    $0x10,%esp
  802ca7:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802caa:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802cae:	75 0a                	jne    802cba <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb5:	e9 ae 00 00 00       	jmp    802d68 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cba:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802cc1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cc4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cc7:	01 d0                	add    %edx,%eax
  802cc9:	48                   	dec    %eax
  802cca:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802ccd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cd0:	ba 00 00 00 00       	mov    $0x0,%edx
  802cd5:	f7 75 b8             	divl   -0x48(%ebp)
  802cd8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cdb:	29 d0                	sub    %edx,%eax
  802cdd:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ce0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ce3:	01 d0                	add    %edx,%eax
  802ce5:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802cea:	a1 40 50 80 00       	mov    0x805040,%eax
  802cef:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802cf5:	83 ec 0c             	sub    $0xc,%esp
  802cf8:	68 90 45 80 00       	push   $0x804590
  802cfd:	e8 ac d9 ff ff       	call   8006ae <cprintf>
  802d02:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d05:	83 ec 08             	sub    $0x8,%esp
  802d08:	ff 75 bc             	pushl  -0x44(%ebp)
  802d0b:	68 95 45 80 00       	push   $0x804595
  802d10:	e8 99 d9 ff ff       	call   8006ae <cprintf>
  802d15:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d18:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d1f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d22:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d25:	01 d0                	add    %edx,%eax
  802d27:	48                   	dec    %eax
  802d28:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d2b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d2e:	ba 00 00 00 00       	mov    $0x0,%edx
  802d33:	f7 75 b0             	divl   -0x50(%ebp)
  802d36:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d39:	29 d0                	sub    %edx,%eax
  802d3b:	83 ec 04             	sub    $0x4,%esp
  802d3e:	6a 01                	push   $0x1
  802d40:	50                   	push   %eax
  802d41:	ff 75 bc             	pushl  -0x44(%ebp)
  802d44:	e8 51 f5 ff ff       	call   80229a <set_block_data>
  802d49:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d4c:	83 ec 0c             	sub    $0xc,%esp
  802d4f:	ff 75 bc             	pushl  -0x44(%ebp)
  802d52:	e8 36 04 00 00       	call   80318d <free_block>
  802d57:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d5a:	83 ec 0c             	sub    $0xc,%esp
  802d5d:	ff 75 08             	pushl  0x8(%ebp)
  802d60:	e8 20 fa ff ff       	call   802785 <alloc_block_BF>
  802d65:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d68:	c9                   	leave  
  802d69:	c3                   	ret    

00802d6a <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d6a:	55                   	push   %ebp
  802d6b:	89 e5                	mov    %esp,%ebp
  802d6d:	53                   	push   %ebx
  802d6e:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d78:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d83:	74 1e                	je     802da3 <merging+0x39>
  802d85:	ff 75 08             	pushl  0x8(%ebp)
  802d88:	e8 bc f1 ff ff       	call   801f49 <get_block_size>
  802d8d:	83 c4 04             	add    $0x4,%esp
  802d90:	89 c2                	mov    %eax,%edx
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	01 d0                	add    %edx,%eax
  802d97:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d9a:	75 07                	jne    802da3 <merging+0x39>
		prev_is_free = 1;
  802d9c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802da3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802da7:	74 1e                	je     802dc7 <merging+0x5d>
  802da9:	ff 75 10             	pushl  0x10(%ebp)
  802dac:	e8 98 f1 ff ff       	call   801f49 <get_block_size>
  802db1:	83 c4 04             	add    $0x4,%esp
  802db4:	89 c2                	mov    %eax,%edx
  802db6:	8b 45 10             	mov    0x10(%ebp),%eax
  802db9:	01 d0                	add    %edx,%eax
  802dbb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802dbe:	75 07                	jne    802dc7 <merging+0x5d>
		next_is_free = 1;
  802dc0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802dc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dcb:	0f 84 cc 00 00 00    	je     802e9d <merging+0x133>
  802dd1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dd5:	0f 84 c2 00 00 00    	je     802e9d <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802ddb:	ff 75 08             	pushl  0x8(%ebp)
  802dde:	e8 66 f1 ff ff       	call   801f49 <get_block_size>
  802de3:	83 c4 04             	add    $0x4,%esp
  802de6:	89 c3                	mov    %eax,%ebx
  802de8:	ff 75 10             	pushl  0x10(%ebp)
  802deb:	e8 59 f1 ff ff       	call   801f49 <get_block_size>
  802df0:	83 c4 04             	add    $0x4,%esp
  802df3:	01 c3                	add    %eax,%ebx
  802df5:	ff 75 0c             	pushl  0xc(%ebp)
  802df8:	e8 4c f1 ff ff       	call   801f49 <get_block_size>
  802dfd:	83 c4 04             	add    $0x4,%esp
  802e00:	01 d8                	add    %ebx,%eax
  802e02:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e05:	6a 00                	push   $0x0
  802e07:	ff 75 ec             	pushl  -0x14(%ebp)
  802e0a:	ff 75 08             	pushl  0x8(%ebp)
  802e0d:	e8 88 f4 ff ff       	call   80229a <set_block_data>
  802e12:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e19:	75 17                	jne    802e32 <merging+0xc8>
  802e1b:	83 ec 04             	sub    $0x4,%esp
  802e1e:	68 cb 44 80 00       	push   $0x8044cb
  802e23:	68 7d 01 00 00       	push   $0x17d
  802e28:	68 e9 44 80 00       	push   $0x8044e9
  802e2d:	e8 bf d5 ff ff       	call   8003f1 <_panic>
  802e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e35:	8b 00                	mov    (%eax),%eax
  802e37:	85 c0                	test   %eax,%eax
  802e39:	74 10                	je     802e4b <merging+0xe1>
  802e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3e:	8b 00                	mov    (%eax),%eax
  802e40:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e43:	8b 52 04             	mov    0x4(%edx),%edx
  802e46:	89 50 04             	mov    %edx,0x4(%eax)
  802e49:	eb 0b                	jmp    802e56 <merging+0xec>
  802e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4e:	8b 40 04             	mov    0x4(%eax),%eax
  802e51:	a3 30 50 80 00       	mov    %eax,0x805030
  802e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e59:	8b 40 04             	mov    0x4(%eax),%eax
  802e5c:	85 c0                	test   %eax,%eax
  802e5e:	74 0f                	je     802e6f <merging+0x105>
  802e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e63:	8b 40 04             	mov    0x4(%eax),%eax
  802e66:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e69:	8b 12                	mov    (%edx),%edx
  802e6b:	89 10                	mov    %edx,(%eax)
  802e6d:	eb 0a                	jmp    802e79 <merging+0x10f>
  802e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e72:	8b 00                	mov    (%eax),%eax
  802e74:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e79:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8c:	a1 38 50 80 00       	mov    0x805038,%eax
  802e91:	48                   	dec    %eax
  802e92:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e97:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e98:	e9 ea 02 00 00       	jmp    803187 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea1:	74 3b                	je     802ede <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ea3:	83 ec 0c             	sub    $0xc,%esp
  802ea6:	ff 75 08             	pushl  0x8(%ebp)
  802ea9:	e8 9b f0 ff ff       	call   801f49 <get_block_size>
  802eae:	83 c4 10             	add    $0x10,%esp
  802eb1:	89 c3                	mov    %eax,%ebx
  802eb3:	83 ec 0c             	sub    $0xc,%esp
  802eb6:	ff 75 10             	pushl  0x10(%ebp)
  802eb9:	e8 8b f0 ff ff       	call   801f49 <get_block_size>
  802ebe:	83 c4 10             	add    $0x10,%esp
  802ec1:	01 d8                	add    %ebx,%eax
  802ec3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ec6:	83 ec 04             	sub    $0x4,%esp
  802ec9:	6a 00                	push   $0x0
  802ecb:	ff 75 e8             	pushl  -0x18(%ebp)
  802ece:	ff 75 08             	pushl  0x8(%ebp)
  802ed1:	e8 c4 f3 ff ff       	call   80229a <set_block_data>
  802ed6:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ed9:	e9 a9 02 00 00       	jmp    803187 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802ede:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee2:	0f 84 2d 01 00 00    	je     803015 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ee8:	83 ec 0c             	sub    $0xc,%esp
  802eeb:	ff 75 10             	pushl  0x10(%ebp)
  802eee:	e8 56 f0 ff ff       	call   801f49 <get_block_size>
  802ef3:	83 c4 10             	add    $0x10,%esp
  802ef6:	89 c3                	mov    %eax,%ebx
  802ef8:	83 ec 0c             	sub    $0xc,%esp
  802efb:	ff 75 0c             	pushl  0xc(%ebp)
  802efe:	e8 46 f0 ff ff       	call   801f49 <get_block_size>
  802f03:	83 c4 10             	add    $0x10,%esp
  802f06:	01 d8                	add    %ebx,%eax
  802f08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f0b:	83 ec 04             	sub    $0x4,%esp
  802f0e:	6a 00                	push   $0x0
  802f10:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f13:	ff 75 10             	pushl  0x10(%ebp)
  802f16:	e8 7f f3 ff ff       	call   80229a <set_block_data>
  802f1b:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f1e:	8b 45 10             	mov    0x10(%ebp),%eax
  802f21:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f28:	74 06                	je     802f30 <merging+0x1c6>
  802f2a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f2e:	75 17                	jne    802f47 <merging+0x1dd>
  802f30:	83 ec 04             	sub    $0x4,%esp
  802f33:	68 a4 45 80 00       	push   $0x8045a4
  802f38:	68 8d 01 00 00       	push   $0x18d
  802f3d:	68 e9 44 80 00       	push   $0x8044e9
  802f42:	e8 aa d4 ff ff       	call   8003f1 <_panic>
  802f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4a:	8b 50 04             	mov    0x4(%eax),%edx
  802f4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f50:	89 50 04             	mov    %edx,0x4(%eax)
  802f53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f56:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f59:	89 10                	mov    %edx,(%eax)
  802f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5e:	8b 40 04             	mov    0x4(%eax),%eax
  802f61:	85 c0                	test   %eax,%eax
  802f63:	74 0d                	je     802f72 <merging+0x208>
  802f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f68:	8b 40 04             	mov    0x4(%eax),%eax
  802f6b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f6e:	89 10                	mov    %edx,(%eax)
  802f70:	eb 08                	jmp    802f7a <merging+0x210>
  802f72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f75:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f80:	89 50 04             	mov    %edx,0x4(%eax)
  802f83:	a1 38 50 80 00       	mov    0x805038,%eax
  802f88:	40                   	inc    %eax
  802f89:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f92:	75 17                	jne    802fab <merging+0x241>
  802f94:	83 ec 04             	sub    $0x4,%esp
  802f97:	68 cb 44 80 00       	push   $0x8044cb
  802f9c:	68 8e 01 00 00       	push   $0x18e
  802fa1:	68 e9 44 80 00       	push   $0x8044e9
  802fa6:	e8 46 d4 ff ff       	call   8003f1 <_panic>
  802fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fae:	8b 00                	mov    (%eax),%eax
  802fb0:	85 c0                	test   %eax,%eax
  802fb2:	74 10                	je     802fc4 <merging+0x25a>
  802fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb7:	8b 00                	mov    (%eax),%eax
  802fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fbc:	8b 52 04             	mov    0x4(%edx),%edx
  802fbf:	89 50 04             	mov    %edx,0x4(%eax)
  802fc2:	eb 0b                	jmp    802fcf <merging+0x265>
  802fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc7:	8b 40 04             	mov    0x4(%eax),%eax
  802fca:	a3 30 50 80 00       	mov    %eax,0x805030
  802fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd2:	8b 40 04             	mov    0x4(%eax),%eax
  802fd5:	85 c0                	test   %eax,%eax
  802fd7:	74 0f                	je     802fe8 <merging+0x27e>
  802fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdc:	8b 40 04             	mov    0x4(%eax),%eax
  802fdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe2:	8b 12                	mov    (%edx),%edx
  802fe4:	89 10                	mov    %edx,(%eax)
  802fe6:	eb 0a                	jmp    802ff2 <merging+0x288>
  802fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802feb:	8b 00                	mov    (%eax),%eax
  802fed:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803005:	a1 38 50 80 00       	mov    0x805038,%eax
  80300a:	48                   	dec    %eax
  80300b:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803010:	e9 72 01 00 00       	jmp    803187 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803015:	8b 45 10             	mov    0x10(%ebp),%eax
  803018:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80301b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80301f:	74 79                	je     80309a <merging+0x330>
  803021:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803025:	74 73                	je     80309a <merging+0x330>
  803027:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302b:	74 06                	je     803033 <merging+0x2c9>
  80302d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803031:	75 17                	jne    80304a <merging+0x2e0>
  803033:	83 ec 04             	sub    $0x4,%esp
  803036:	68 5c 45 80 00       	push   $0x80455c
  80303b:	68 94 01 00 00       	push   $0x194
  803040:	68 e9 44 80 00       	push   $0x8044e9
  803045:	e8 a7 d3 ff ff       	call   8003f1 <_panic>
  80304a:	8b 45 08             	mov    0x8(%ebp),%eax
  80304d:	8b 10                	mov    (%eax),%edx
  80304f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803052:	89 10                	mov    %edx,(%eax)
  803054:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803057:	8b 00                	mov    (%eax),%eax
  803059:	85 c0                	test   %eax,%eax
  80305b:	74 0b                	je     803068 <merging+0x2fe>
  80305d:	8b 45 08             	mov    0x8(%ebp),%eax
  803060:	8b 00                	mov    (%eax),%eax
  803062:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803065:	89 50 04             	mov    %edx,0x4(%eax)
  803068:	8b 45 08             	mov    0x8(%ebp),%eax
  80306b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80306e:	89 10                	mov    %edx,(%eax)
  803070:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803073:	8b 55 08             	mov    0x8(%ebp),%edx
  803076:	89 50 04             	mov    %edx,0x4(%eax)
  803079:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307c:	8b 00                	mov    (%eax),%eax
  80307e:	85 c0                	test   %eax,%eax
  803080:	75 08                	jne    80308a <merging+0x320>
  803082:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803085:	a3 30 50 80 00       	mov    %eax,0x805030
  80308a:	a1 38 50 80 00       	mov    0x805038,%eax
  80308f:	40                   	inc    %eax
  803090:	a3 38 50 80 00       	mov    %eax,0x805038
  803095:	e9 ce 00 00 00       	jmp    803168 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80309a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80309e:	74 65                	je     803105 <merging+0x39b>
  8030a0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030a4:	75 17                	jne    8030bd <merging+0x353>
  8030a6:	83 ec 04             	sub    $0x4,%esp
  8030a9:	68 38 45 80 00       	push   $0x804538
  8030ae:	68 95 01 00 00       	push   $0x195
  8030b3:	68 e9 44 80 00       	push   $0x8044e9
  8030b8:	e8 34 d3 ff ff       	call   8003f1 <_panic>
  8030bd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c6:	89 50 04             	mov    %edx,0x4(%eax)
  8030c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030cc:	8b 40 04             	mov    0x4(%eax),%eax
  8030cf:	85 c0                	test   %eax,%eax
  8030d1:	74 0c                	je     8030df <merging+0x375>
  8030d3:	a1 30 50 80 00       	mov    0x805030,%eax
  8030d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030db:	89 10                	mov    %edx,(%eax)
  8030dd:	eb 08                	jmp    8030e7 <merging+0x37d>
  8030df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ea:	a3 30 50 80 00       	mov    %eax,0x805030
  8030ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8030fd:	40                   	inc    %eax
  8030fe:	a3 38 50 80 00       	mov    %eax,0x805038
  803103:	eb 63                	jmp    803168 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803105:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803109:	75 17                	jne    803122 <merging+0x3b8>
  80310b:	83 ec 04             	sub    $0x4,%esp
  80310e:	68 04 45 80 00       	push   $0x804504
  803113:	68 98 01 00 00       	push   $0x198
  803118:	68 e9 44 80 00       	push   $0x8044e9
  80311d:	e8 cf d2 ff ff       	call   8003f1 <_panic>
  803122:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803128:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80312b:	89 10                	mov    %edx,(%eax)
  80312d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803130:	8b 00                	mov    (%eax),%eax
  803132:	85 c0                	test   %eax,%eax
  803134:	74 0d                	je     803143 <merging+0x3d9>
  803136:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80313b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80313e:	89 50 04             	mov    %edx,0x4(%eax)
  803141:	eb 08                	jmp    80314b <merging+0x3e1>
  803143:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803146:	a3 30 50 80 00       	mov    %eax,0x805030
  80314b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80314e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803153:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803156:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315d:	a1 38 50 80 00       	mov    0x805038,%eax
  803162:	40                   	inc    %eax
  803163:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803168:	83 ec 0c             	sub    $0xc,%esp
  80316b:	ff 75 10             	pushl  0x10(%ebp)
  80316e:	e8 d6 ed ff ff       	call   801f49 <get_block_size>
  803173:	83 c4 10             	add    $0x10,%esp
  803176:	83 ec 04             	sub    $0x4,%esp
  803179:	6a 00                	push   $0x0
  80317b:	50                   	push   %eax
  80317c:	ff 75 10             	pushl  0x10(%ebp)
  80317f:	e8 16 f1 ff ff       	call   80229a <set_block_data>
  803184:	83 c4 10             	add    $0x10,%esp
	}
}
  803187:	90                   	nop
  803188:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80318b:	c9                   	leave  
  80318c:	c3                   	ret    

0080318d <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80318d:	55                   	push   %ebp
  80318e:	89 e5                	mov    %esp,%ebp
  803190:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803193:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803198:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80319b:	a1 30 50 80 00       	mov    0x805030,%eax
  8031a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031a3:	73 1b                	jae    8031c0 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031a5:	a1 30 50 80 00       	mov    0x805030,%eax
  8031aa:	83 ec 04             	sub    $0x4,%esp
  8031ad:	ff 75 08             	pushl  0x8(%ebp)
  8031b0:	6a 00                	push   $0x0
  8031b2:	50                   	push   %eax
  8031b3:	e8 b2 fb ff ff       	call   802d6a <merging>
  8031b8:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031bb:	e9 8b 00 00 00       	jmp    80324b <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031c0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031c8:	76 18                	jbe    8031e2 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031ca:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031cf:	83 ec 04             	sub    $0x4,%esp
  8031d2:	ff 75 08             	pushl  0x8(%ebp)
  8031d5:	50                   	push   %eax
  8031d6:	6a 00                	push   $0x0
  8031d8:	e8 8d fb ff ff       	call   802d6a <merging>
  8031dd:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031e0:	eb 69                	jmp    80324b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031e2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ea:	eb 39                	jmp    803225 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f2:	73 29                	jae    80321d <free_block+0x90>
  8031f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f7:	8b 00                	mov    (%eax),%eax
  8031f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031fc:	76 1f                	jbe    80321d <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803201:	8b 00                	mov    (%eax),%eax
  803203:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803206:	83 ec 04             	sub    $0x4,%esp
  803209:	ff 75 08             	pushl  0x8(%ebp)
  80320c:	ff 75 f0             	pushl  -0x10(%ebp)
  80320f:	ff 75 f4             	pushl  -0xc(%ebp)
  803212:	e8 53 fb ff ff       	call   802d6a <merging>
  803217:	83 c4 10             	add    $0x10,%esp
			break;
  80321a:	90                   	nop
		}
	}
}
  80321b:	eb 2e                	jmp    80324b <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80321d:	a1 34 50 80 00       	mov    0x805034,%eax
  803222:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803225:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803229:	74 07                	je     803232 <free_block+0xa5>
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	8b 00                	mov    (%eax),%eax
  803230:	eb 05                	jmp    803237 <free_block+0xaa>
  803232:	b8 00 00 00 00       	mov    $0x0,%eax
  803237:	a3 34 50 80 00       	mov    %eax,0x805034
  80323c:	a1 34 50 80 00       	mov    0x805034,%eax
  803241:	85 c0                	test   %eax,%eax
  803243:	75 a7                	jne    8031ec <free_block+0x5f>
  803245:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803249:	75 a1                	jne    8031ec <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80324b:	90                   	nop
  80324c:	c9                   	leave  
  80324d:	c3                   	ret    

0080324e <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80324e:	55                   	push   %ebp
  80324f:	89 e5                	mov    %esp,%ebp
  803251:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803254:	ff 75 08             	pushl  0x8(%ebp)
  803257:	e8 ed ec ff ff       	call   801f49 <get_block_size>
  80325c:	83 c4 04             	add    $0x4,%esp
  80325f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803262:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803269:	eb 17                	jmp    803282 <copy_data+0x34>
  80326b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80326e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803271:	01 c2                	add    %eax,%edx
  803273:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803276:	8b 45 08             	mov    0x8(%ebp),%eax
  803279:	01 c8                	add    %ecx,%eax
  80327b:	8a 00                	mov    (%eax),%al
  80327d:	88 02                	mov    %al,(%edx)
  80327f:	ff 45 fc             	incl   -0x4(%ebp)
  803282:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803285:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803288:	72 e1                	jb     80326b <copy_data+0x1d>
}
  80328a:	90                   	nop
  80328b:	c9                   	leave  
  80328c:	c3                   	ret    

0080328d <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80328d:	55                   	push   %ebp
  80328e:	89 e5                	mov    %esp,%ebp
  803290:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803293:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803297:	75 23                	jne    8032bc <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803299:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80329d:	74 13                	je     8032b2 <realloc_block_FF+0x25>
  80329f:	83 ec 0c             	sub    $0xc,%esp
  8032a2:	ff 75 0c             	pushl  0xc(%ebp)
  8032a5:	e8 1f f0 ff ff       	call   8022c9 <alloc_block_FF>
  8032aa:	83 c4 10             	add    $0x10,%esp
  8032ad:	e9 f4 06 00 00       	jmp    8039a6 <realloc_block_FF+0x719>
		return NULL;
  8032b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b7:	e9 ea 06 00 00       	jmp    8039a6 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032c0:	75 18                	jne    8032da <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032c2:	83 ec 0c             	sub    $0xc,%esp
  8032c5:	ff 75 08             	pushl  0x8(%ebp)
  8032c8:	e8 c0 fe ff ff       	call   80318d <free_block>
  8032cd:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d5:	e9 cc 06 00 00       	jmp    8039a6 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8032da:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032de:	77 07                	ja     8032e7 <realloc_block_FF+0x5a>
  8032e0:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ea:	83 e0 01             	and    $0x1,%eax
  8032ed:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032f3:	83 c0 08             	add    $0x8,%eax
  8032f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032f9:	83 ec 0c             	sub    $0xc,%esp
  8032fc:	ff 75 08             	pushl  0x8(%ebp)
  8032ff:	e8 45 ec ff ff       	call   801f49 <get_block_size>
  803304:	83 c4 10             	add    $0x10,%esp
  803307:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80330a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330d:	83 e8 08             	sub    $0x8,%eax
  803310:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803313:	8b 45 08             	mov    0x8(%ebp),%eax
  803316:	83 e8 04             	sub    $0x4,%eax
  803319:	8b 00                	mov    (%eax),%eax
  80331b:	83 e0 fe             	and    $0xfffffffe,%eax
  80331e:	89 c2                	mov    %eax,%edx
  803320:	8b 45 08             	mov    0x8(%ebp),%eax
  803323:	01 d0                	add    %edx,%eax
  803325:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803328:	83 ec 0c             	sub    $0xc,%esp
  80332b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80332e:	e8 16 ec ff ff       	call   801f49 <get_block_size>
  803333:	83 c4 10             	add    $0x10,%esp
  803336:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803339:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80333c:	83 e8 08             	sub    $0x8,%eax
  80333f:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803342:	8b 45 0c             	mov    0xc(%ebp),%eax
  803345:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803348:	75 08                	jne    803352 <realloc_block_FF+0xc5>
	{
		 return va;
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	e9 54 06 00 00       	jmp    8039a6 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803352:	8b 45 0c             	mov    0xc(%ebp),%eax
  803355:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803358:	0f 83 e5 03 00 00    	jae    803743 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80335e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803361:	2b 45 0c             	sub    0xc(%ebp),%eax
  803364:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803367:	83 ec 0c             	sub    $0xc,%esp
  80336a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80336d:	e8 f0 eb ff ff       	call   801f62 <is_free_block>
  803372:	83 c4 10             	add    $0x10,%esp
  803375:	84 c0                	test   %al,%al
  803377:	0f 84 3b 01 00 00    	je     8034b8 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80337d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803380:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803383:	01 d0                	add    %edx,%eax
  803385:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803388:	83 ec 04             	sub    $0x4,%esp
  80338b:	6a 01                	push   $0x1
  80338d:	ff 75 f0             	pushl  -0x10(%ebp)
  803390:	ff 75 08             	pushl  0x8(%ebp)
  803393:	e8 02 ef ff ff       	call   80229a <set_block_data>
  803398:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80339b:	8b 45 08             	mov    0x8(%ebp),%eax
  80339e:	83 e8 04             	sub    $0x4,%eax
  8033a1:	8b 00                	mov    (%eax),%eax
  8033a3:	83 e0 fe             	and    $0xfffffffe,%eax
  8033a6:	89 c2                	mov    %eax,%edx
  8033a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ab:	01 d0                	add    %edx,%eax
  8033ad:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033b0:	83 ec 04             	sub    $0x4,%esp
  8033b3:	6a 00                	push   $0x0
  8033b5:	ff 75 cc             	pushl  -0x34(%ebp)
  8033b8:	ff 75 c8             	pushl  -0x38(%ebp)
  8033bb:	e8 da ee ff ff       	call   80229a <set_block_data>
  8033c0:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033c7:	74 06                	je     8033cf <realloc_block_FF+0x142>
  8033c9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033cd:	75 17                	jne    8033e6 <realloc_block_FF+0x159>
  8033cf:	83 ec 04             	sub    $0x4,%esp
  8033d2:	68 5c 45 80 00       	push   $0x80455c
  8033d7:	68 f6 01 00 00       	push   $0x1f6
  8033dc:	68 e9 44 80 00       	push   $0x8044e9
  8033e1:	e8 0b d0 ff ff       	call   8003f1 <_panic>
  8033e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e9:	8b 10                	mov    (%eax),%edx
  8033eb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033ee:	89 10                	mov    %edx,(%eax)
  8033f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033f3:	8b 00                	mov    (%eax),%eax
  8033f5:	85 c0                	test   %eax,%eax
  8033f7:	74 0b                	je     803404 <realloc_block_FF+0x177>
  8033f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033fc:	8b 00                	mov    (%eax),%eax
  8033fe:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803401:	89 50 04             	mov    %edx,0x4(%eax)
  803404:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803407:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80340a:	89 10                	mov    %edx,(%eax)
  80340c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80340f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803412:	89 50 04             	mov    %edx,0x4(%eax)
  803415:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803418:	8b 00                	mov    (%eax),%eax
  80341a:	85 c0                	test   %eax,%eax
  80341c:	75 08                	jne    803426 <realloc_block_FF+0x199>
  80341e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803421:	a3 30 50 80 00       	mov    %eax,0x805030
  803426:	a1 38 50 80 00       	mov    0x805038,%eax
  80342b:	40                   	inc    %eax
  80342c:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803431:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803435:	75 17                	jne    80344e <realloc_block_FF+0x1c1>
  803437:	83 ec 04             	sub    $0x4,%esp
  80343a:	68 cb 44 80 00       	push   $0x8044cb
  80343f:	68 f7 01 00 00       	push   $0x1f7
  803444:	68 e9 44 80 00       	push   $0x8044e9
  803449:	e8 a3 cf ff ff       	call   8003f1 <_panic>
  80344e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803451:	8b 00                	mov    (%eax),%eax
  803453:	85 c0                	test   %eax,%eax
  803455:	74 10                	je     803467 <realloc_block_FF+0x1da>
  803457:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345a:	8b 00                	mov    (%eax),%eax
  80345c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80345f:	8b 52 04             	mov    0x4(%edx),%edx
  803462:	89 50 04             	mov    %edx,0x4(%eax)
  803465:	eb 0b                	jmp    803472 <realloc_block_FF+0x1e5>
  803467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346a:	8b 40 04             	mov    0x4(%eax),%eax
  80346d:	a3 30 50 80 00       	mov    %eax,0x805030
  803472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803475:	8b 40 04             	mov    0x4(%eax),%eax
  803478:	85 c0                	test   %eax,%eax
  80347a:	74 0f                	je     80348b <realloc_block_FF+0x1fe>
  80347c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347f:	8b 40 04             	mov    0x4(%eax),%eax
  803482:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803485:	8b 12                	mov    (%edx),%edx
  803487:	89 10                	mov    %edx,(%eax)
  803489:	eb 0a                	jmp    803495 <realloc_block_FF+0x208>
  80348b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348e:	8b 00                	mov    (%eax),%eax
  803490:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803495:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803498:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80349e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a8:	a1 38 50 80 00       	mov    0x805038,%eax
  8034ad:	48                   	dec    %eax
  8034ae:	a3 38 50 80 00       	mov    %eax,0x805038
  8034b3:	e9 83 02 00 00       	jmp    80373b <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034b8:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034bc:	0f 86 69 02 00 00    	jbe    80372b <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034c2:	83 ec 04             	sub    $0x4,%esp
  8034c5:	6a 01                	push   $0x1
  8034c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8034ca:	ff 75 08             	pushl  0x8(%ebp)
  8034cd:	e8 c8 ed ff ff       	call   80229a <set_block_data>
  8034d2:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d8:	83 e8 04             	sub    $0x4,%eax
  8034db:	8b 00                	mov    (%eax),%eax
  8034dd:	83 e0 fe             	and    $0xfffffffe,%eax
  8034e0:	89 c2                	mov    %eax,%edx
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	01 d0                	add    %edx,%eax
  8034e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034ea:	a1 38 50 80 00       	mov    0x805038,%eax
  8034ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034f2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034f6:	75 68                	jne    803560 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034f8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034fc:	75 17                	jne    803515 <realloc_block_FF+0x288>
  8034fe:	83 ec 04             	sub    $0x4,%esp
  803501:	68 04 45 80 00       	push   $0x804504
  803506:	68 06 02 00 00       	push   $0x206
  80350b:	68 e9 44 80 00       	push   $0x8044e9
  803510:	e8 dc ce ff ff       	call   8003f1 <_panic>
  803515:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80351b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351e:	89 10                	mov    %edx,(%eax)
  803520:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803523:	8b 00                	mov    (%eax),%eax
  803525:	85 c0                	test   %eax,%eax
  803527:	74 0d                	je     803536 <realloc_block_FF+0x2a9>
  803529:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80352e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803531:	89 50 04             	mov    %edx,0x4(%eax)
  803534:	eb 08                	jmp    80353e <realloc_block_FF+0x2b1>
  803536:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803539:	a3 30 50 80 00       	mov    %eax,0x805030
  80353e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803541:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803546:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803549:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803550:	a1 38 50 80 00       	mov    0x805038,%eax
  803555:	40                   	inc    %eax
  803556:	a3 38 50 80 00       	mov    %eax,0x805038
  80355b:	e9 b0 01 00 00       	jmp    803710 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803560:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803565:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803568:	76 68                	jbe    8035d2 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80356a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80356e:	75 17                	jne    803587 <realloc_block_FF+0x2fa>
  803570:	83 ec 04             	sub    $0x4,%esp
  803573:	68 04 45 80 00       	push   $0x804504
  803578:	68 0b 02 00 00       	push   $0x20b
  80357d:	68 e9 44 80 00       	push   $0x8044e9
  803582:	e8 6a ce ff ff       	call   8003f1 <_panic>
  803587:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80358d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803590:	89 10                	mov    %edx,(%eax)
  803592:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803595:	8b 00                	mov    (%eax),%eax
  803597:	85 c0                	test   %eax,%eax
  803599:	74 0d                	je     8035a8 <realloc_block_FF+0x31b>
  80359b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035a0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035a3:	89 50 04             	mov    %edx,0x4(%eax)
  8035a6:	eb 08                	jmp    8035b0 <realloc_block_FF+0x323>
  8035a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ab:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c2:	a1 38 50 80 00       	mov    0x805038,%eax
  8035c7:	40                   	inc    %eax
  8035c8:	a3 38 50 80 00       	mov    %eax,0x805038
  8035cd:	e9 3e 01 00 00       	jmp    803710 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035d2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035d7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035da:	73 68                	jae    803644 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035dc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035e0:	75 17                	jne    8035f9 <realloc_block_FF+0x36c>
  8035e2:	83 ec 04             	sub    $0x4,%esp
  8035e5:	68 38 45 80 00       	push   $0x804538
  8035ea:	68 10 02 00 00       	push   $0x210
  8035ef:	68 e9 44 80 00       	push   $0x8044e9
  8035f4:	e8 f8 cd ff ff       	call   8003f1 <_panic>
  8035f9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803602:	89 50 04             	mov    %edx,0x4(%eax)
  803605:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803608:	8b 40 04             	mov    0x4(%eax),%eax
  80360b:	85 c0                	test   %eax,%eax
  80360d:	74 0c                	je     80361b <realloc_block_FF+0x38e>
  80360f:	a1 30 50 80 00       	mov    0x805030,%eax
  803614:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803617:	89 10                	mov    %edx,(%eax)
  803619:	eb 08                	jmp    803623 <realloc_block_FF+0x396>
  80361b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803626:	a3 30 50 80 00       	mov    %eax,0x805030
  80362b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803634:	a1 38 50 80 00       	mov    0x805038,%eax
  803639:	40                   	inc    %eax
  80363a:	a3 38 50 80 00       	mov    %eax,0x805038
  80363f:	e9 cc 00 00 00       	jmp    803710 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803644:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80364b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803650:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803653:	e9 8a 00 00 00       	jmp    8036e2 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80365e:	73 7a                	jae    8036da <realloc_block_FF+0x44d>
  803660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803663:	8b 00                	mov    (%eax),%eax
  803665:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803668:	73 70                	jae    8036da <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80366a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80366e:	74 06                	je     803676 <realloc_block_FF+0x3e9>
  803670:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803674:	75 17                	jne    80368d <realloc_block_FF+0x400>
  803676:	83 ec 04             	sub    $0x4,%esp
  803679:	68 5c 45 80 00       	push   $0x80455c
  80367e:	68 1a 02 00 00       	push   $0x21a
  803683:	68 e9 44 80 00       	push   $0x8044e9
  803688:	e8 64 cd ff ff       	call   8003f1 <_panic>
  80368d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803690:	8b 10                	mov    (%eax),%edx
  803692:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803695:	89 10                	mov    %edx,(%eax)
  803697:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369a:	8b 00                	mov    (%eax),%eax
  80369c:	85 c0                	test   %eax,%eax
  80369e:	74 0b                	je     8036ab <realloc_block_FF+0x41e>
  8036a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a3:	8b 00                	mov    (%eax),%eax
  8036a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036a8:	89 50 04             	mov    %edx,0x4(%eax)
  8036ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036b1:	89 10                	mov    %edx,(%eax)
  8036b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036b9:	89 50 04             	mov    %edx,0x4(%eax)
  8036bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036bf:	8b 00                	mov    (%eax),%eax
  8036c1:	85 c0                	test   %eax,%eax
  8036c3:	75 08                	jne    8036cd <realloc_block_FF+0x440>
  8036c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c8:	a3 30 50 80 00       	mov    %eax,0x805030
  8036cd:	a1 38 50 80 00       	mov    0x805038,%eax
  8036d2:	40                   	inc    %eax
  8036d3:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8036d8:	eb 36                	jmp    803710 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036da:	a1 34 50 80 00       	mov    0x805034,%eax
  8036df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e6:	74 07                	je     8036ef <realloc_block_FF+0x462>
  8036e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036eb:	8b 00                	mov    (%eax),%eax
  8036ed:	eb 05                	jmp    8036f4 <realloc_block_FF+0x467>
  8036ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f4:	a3 34 50 80 00       	mov    %eax,0x805034
  8036f9:	a1 34 50 80 00       	mov    0x805034,%eax
  8036fe:	85 c0                	test   %eax,%eax
  803700:	0f 85 52 ff ff ff    	jne    803658 <realloc_block_FF+0x3cb>
  803706:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80370a:	0f 85 48 ff ff ff    	jne    803658 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803710:	83 ec 04             	sub    $0x4,%esp
  803713:	6a 00                	push   $0x0
  803715:	ff 75 d8             	pushl  -0x28(%ebp)
  803718:	ff 75 d4             	pushl  -0x2c(%ebp)
  80371b:	e8 7a eb ff ff       	call   80229a <set_block_data>
  803720:	83 c4 10             	add    $0x10,%esp
				return va;
  803723:	8b 45 08             	mov    0x8(%ebp),%eax
  803726:	e9 7b 02 00 00       	jmp    8039a6 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80372b:	83 ec 0c             	sub    $0xc,%esp
  80372e:	68 d9 45 80 00       	push   $0x8045d9
  803733:	e8 76 cf ff ff       	call   8006ae <cprintf>
  803738:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80373b:	8b 45 08             	mov    0x8(%ebp),%eax
  80373e:	e9 63 02 00 00       	jmp    8039a6 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803743:	8b 45 0c             	mov    0xc(%ebp),%eax
  803746:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803749:	0f 86 4d 02 00 00    	jbe    80399c <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80374f:	83 ec 0c             	sub    $0xc,%esp
  803752:	ff 75 e4             	pushl  -0x1c(%ebp)
  803755:	e8 08 e8 ff ff       	call   801f62 <is_free_block>
  80375a:	83 c4 10             	add    $0x10,%esp
  80375d:	84 c0                	test   %al,%al
  80375f:	0f 84 37 02 00 00    	je     80399c <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803765:	8b 45 0c             	mov    0xc(%ebp),%eax
  803768:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80376b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80376e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803771:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803774:	76 38                	jbe    8037ae <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803776:	83 ec 0c             	sub    $0xc,%esp
  803779:	ff 75 08             	pushl  0x8(%ebp)
  80377c:	e8 0c fa ff ff       	call   80318d <free_block>
  803781:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803784:	83 ec 0c             	sub    $0xc,%esp
  803787:	ff 75 0c             	pushl  0xc(%ebp)
  80378a:	e8 3a eb ff ff       	call   8022c9 <alloc_block_FF>
  80378f:	83 c4 10             	add    $0x10,%esp
  803792:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803795:	83 ec 08             	sub    $0x8,%esp
  803798:	ff 75 c0             	pushl  -0x40(%ebp)
  80379b:	ff 75 08             	pushl  0x8(%ebp)
  80379e:	e8 ab fa ff ff       	call   80324e <copy_data>
  8037a3:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037a6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037a9:	e9 f8 01 00 00       	jmp    8039a6 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037b1:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037b4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037b7:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037bb:	0f 87 a0 00 00 00    	ja     803861 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037c5:	75 17                	jne    8037de <realloc_block_FF+0x551>
  8037c7:	83 ec 04             	sub    $0x4,%esp
  8037ca:	68 cb 44 80 00       	push   $0x8044cb
  8037cf:	68 38 02 00 00       	push   $0x238
  8037d4:	68 e9 44 80 00       	push   $0x8044e9
  8037d9:	e8 13 cc ff ff       	call   8003f1 <_panic>
  8037de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e1:	8b 00                	mov    (%eax),%eax
  8037e3:	85 c0                	test   %eax,%eax
  8037e5:	74 10                	je     8037f7 <realloc_block_FF+0x56a>
  8037e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ea:	8b 00                	mov    (%eax),%eax
  8037ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037ef:	8b 52 04             	mov    0x4(%edx),%edx
  8037f2:	89 50 04             	mov    %edx,0x4(%eax)
  8037f5:	eb 0b                	jmp    803802 <realloc_block_FF+0x575>
  8037f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fa:	8b 40 04             	mov    0x4(%eax),%eax
  8037fd:	a3 30 50 80 00       	mov    %eax,0x805030
  803802:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803805:	8b 40 04             	mov    0x4(%eax),%eax
  803808:	85 c0                	test   %eax,%eax
  80380a:	74 0f                	je     80381b <realloc_block_FF+0x58e>
  80380c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380f:	8b 40 04             	mov    0x4(%eax),%eax
  803812:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803815:	8b 12                	mov    (%edx),%edx
  803817:	89 10                	mov    %edx,(%eax)
  803819:	eb 0a                	jmp    803825 <realloc_block_FF+0x598>
  80381b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381e:	8b 00                	mov    (%eax),%eax
  803820:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803825:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803828:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80382e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803831:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803838:	a1 38 50 80 00       	mov    0x805038,%eax
  80383d:	48                   	dec    %eax
  80383e:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803843:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803846:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803849:	01 d0                	add    %edx,%eax
  80384b:	83 ec 04             	sub    $0x4,%esp
  80384e:	6a 01                	push   $0x1
  803850:	50                   	push   %eax
  803851:	ff 75 08             	pushl  0x8(%ebp)
  803854:	e8 41 ea ff ff       	call   80229a <set_block_data>
  803859:	83 c4 10             	add    $0x10,%esp
  80385c:	e9 36 01 00 00       	jmp    803997 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803861:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803864:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803867:	01 d0                	add    %edx,%eax
  803869:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80386c:	83 ec 04             	sub    $0x4,%esp
  80386f:	6a 01                	push   $0x1
  803871:	ff 75 f0             	pushl  -0x10(%ebp)
  803874:	ff 75 08             	pushl  0x8(%ebp)
  803877:	e8 1e ea ff ff       	call   80229a <set_block_data>
  80387c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80387f:	8b 45 08             	mov    0x8(%ebp),%eax
  803882:	83 e8 04             	sub    $0x4,%eax
  803885:	8b 00                	mov    (%eax),%eax
  803887:	83 e0 fe             	and    $0xfffffffe,%eax
  80388a:	89 c2                	mov    %eax,%edx
  80388c:	8b 45 08             	mov    0x8(%ebp),%eax
  80388f:	01 d0                	add    %edx,%eax
  803891:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803894:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803898:	74 06                	je     8038a0 <realloc_block_FF+0x613>
  80389a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80389e:	75 17                	jne    8038b7 <realloc_block_FF+0x62a>
  8038a0:	83 ec 04             	sub    $0x4,%esp
  8038a3:	68 5c 45 80 00       	push   $0x80455c
  8038a8:	68 44 02 00 00       	push   $0x244
  8038ad:	68 e9 44 80 00       	push   $0x8044e9
  8038b2:	e8 3a cb ff ff       	call   8003f1 <_panic>
  8038b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ba:	8b 10                	mov    (%eax),%edx
  8038bc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038bf:	89 10                	mov    %edx,(%eax)
  8038c1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038c4:	8b 00                	mov    (%eax),%eax
  8038c6:	85 c0                	test   %eax,%eax
  8038c8:	74 0b                	je     8038d5 <realloc_block_FF+0x648>
  8038ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038cd:	8b 00                	mov    (%eax),%eax
  8038cf:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038d2:	89 50 04             	mov    %edx,0x4(%eax)
  8038d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d8:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038db:	89 10                	mov    %edx,(%eax)
  8038dd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038e3:	89 50 04             	mov    %edx,0x4(%eax)
  8038e6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038e9:	8b 00                	mov    (%eax),%eax
  8038eb:	85 c0                	test   %eax,%eax
  8038ed:	75 08                	jne    8038f7 <realloc_block_FF+0x66a>
  8038ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8038f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8038fc:	40                   	inc    %eax
  8038fd:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803902:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803906:	75 17                	jne    80391f <realloc_block_FF+0x692>
  803908:	83 ec 04             	sub    $0x4,%esp
  80390b:	68 cb 44 80 00       	push   $0x8044cb
  803910:	68 45 02 00 00       	push   $0x245
  803915:	68 e9 44 80 00       	push   $0x8044e9
  80391a:	e8 d2 ca ff ff       	call   8003f1 <_panic>
  80391f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803922:	8b 00                	mov    (%eax),%eax
  803924:	85 c0                	test   %eax,%eax
  803926:	74 10                	je     803938 <realloc_block_FF+0x6ab>
  803928:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392b:	8b 00                	mov    (%eax),%eax
  80392d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803930:	8b 52 04             	mov    0x4(%edx),%edx
  803933:	89 50 04             	mov    %edx,0x4(%eax)
  803936:	eb 0b                	jmp    803943 <realloc_block_FF+0x6b6>
  803938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393b:	8b 40 04             	mov    0x4(%eax),%eax
  80393e:	a3 30 50 80 00       	mov    %eax,0x805030
  803943:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803946:	8b 40 04             	mov    0x4(%eax),%eax
  803949:	85 c0                	test   %eax,%eax
  80394b:	74 0f                	je     80395c <realloc_block_FF+0x6cf>
  80394d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803950:	8b 40 04             	mov    0x4(%eax),%eax
  803953:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803956:	8b 12                	mov    (%edx),%edx
  803958:	89 10                	mov    %edx,(%eax)
  80395a:	eb 0a                	jmp    803966 <realloc_block_FF+0x6d9>
  80395c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395f:	8b 00                	mov    (%eax),%eax
  803961:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803966:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803969:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80396f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803972:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803979:	a1 38 50 80 00       	mov    0x805038,%eax
  80397e:	48                   	dec    %eax
  80397f:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803984:	83 ec 04             	sub    $0x4,%esp
  803987:	6a 00                	push   $0x0
  803989:	ff 75 bc             	pushl  -0x44(%ebp)
  80398c:	ff 75 b8             	pushl  -0x48(%ebp)
  80398f:	e8 06 e9 ff ff       	call   80229a <set_block_data>
  803994:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803997:	8b 45 08             	mov    0x8(%ebp),%eax
  80399a:	eb 0a                	jmp    8039a6 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80399c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039a6:	c9                   	leave  
  8039a7:	c3                   	ret    

008039a8 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039a8:	55                   	push   %ebp
  8039a9:	89 e5                	mov    %esp,%ebp
  8039ab:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039ae:	83 ec 04             	sub    $0x4,%esp
  8039b1:	68 e0 45 80 00       	push   $0x8045e0
  8039b6:	68 58 02 00 00       	push   $0x258
  8039bb:	68 e9 44 80 00       	push   $0x8044e9
  8039c0:	e8 2c ca ff ff       	call   8003f1 <_panic>

008039c5 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039c5:	55                   	push   %ebp
  8039c6:	89 e5                	mov    %esp,%ebp
  8039c8:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039cb:	83 ec 04             	sub    $0x4,%esp
  8039ce:	68 08 46 80 00       	push   $0x804608
  8039d3:	68 61 02 00 00       	push   $0x261
  8039d8:	68 e9 44 80 00       	push   $0x8044e9
  8039dd:	e8 0f ca ff ff       	call   8003f1 <_panic>
  8039e2:	66 90                	xchg   %ax,%ax

008039e4 <__udivdi3>:
  8039e4:	55                   	push   %ebp
  8039e5:	57                   	push   %edi
  8039e6:	56                   	push   %esi
  8039e7:	53                   	push   %ebx
  8039e8:	83 ec 1c             	sub    $0x1c,%esp
  8039eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039fb:	89 ca                	mov    %ecx,%edx
  8039fd:	89 f8                	mov    %edi,%eax
  8039ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a03:	85 f6                	test   %esi,%esi
  803a05:	75 2d                	jne    803a34 <__udivdi3+0x50>
  803a07:	39 cf                	cmp    %ecx,%edi
  803a09:	77 65                	ja     803a70 <__udivdi3+0x8c>
  803a0b:	89 fd                	mov    %edi,%ebp
  803a0d:	85 ff                	test   %edi,%edi
  803a0f:	75 0b                	jne    803a1c <__udivdi3+0x38>
  803a11:	b8 01 00 00 00       	mov    $0x1,%eax
  803a16:	31 d2                	xor    %edx,%edx
  803a18:	f7 f7                	div    %edi
  803a1a:	89 c5                	mov    %eax,%ebp
  803a1c:	31 d2                	xor    %edx,%edx
  803a1e:	89 c8                	mov    %ecx,%eax
  803a20:	f7 f5                	div    %ebp
  803a22:	89 c1                	mov    %eax,%ecx
  803a24:	89 d8                	mov    %ebx,%eax
  803a26:	f7 f5                	div    %ebp
  803a28:	89 cf                	mov    %ecx,%edi
  803a2a:	89 fa                	mov    %edi,%edx
  803a2c:	83 c4 1c             	add    $0x1c,%esp
  803a2f:	5b                   	pop    %ebx
  803a30:	5e                   	pop    %esi
  803a31:	5f                   	pop    %edi
  803a32:	5d                   	pop    %ebp
  803a33:	c3                   	ret    
  803a34:	39 ce                	cmp    %ecx,%esi
  803a36:	77 28                	ja     803a60 <__udivdi3+0x7c>
  803a38:	0f bd fe             	bsr    %esi,%edi
  803a3b:	83 f7 1f             	xor    $0x1f,%edi
  803a3e:	75 40                	jne    803a80 <__udivdi3+0x9c>
  803a40:	39 ce                	cmp    %ecx,%esi
  803a42:	72 0a                	jb     803a4e <__udivdi3+0x6a>
  803a44:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a48:	0f 87 9e 00 00 00    	ja     803aec <__udivdi3+0x108>
  803a4e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a53:	89 fa                	mov    %edi,%edx
  803a55:	83 c4 1c             	add    $0x1c,%esp
  803a58:	5b                   	pop    %ebx
  803a59:	5e                   	pop    %esi
  803a5a:	5f                   	pop    %edi
  803a5b:	5d                   	pop    %ebp
  803a5c:	c3                   	ret    
  803a5d:	8d 76 00             	lea    0x0(%esi),%esi
  803a60:	31 ff                	xor    %edi,%edi
  803a62:	31 c0                	xor    %eax,%eax
  803a64:	89 fa                	mov    %edi,%edx
  803a66:	83 c4 1c             	add    $0x1c,%esp
  803a69:	5b                   	pop    %ebx
  803a6a:	5e                   	pop    %esi
  803a6b:	5f                   	pop    %edi
  803a6c:	5d                   	pop    %ebp
  803a6d:	c3                   	ret    
  803a6e:	66 90                	xchg   %ax,%ax
  803a70:	89 d8                	mov    %ebx,%eax
  803a72:	f7 f7                	div    %edi
  803a74:	31 ff                	xor    %edi,%edi
  803a76:	89 fa                	mov    %edi,%edx
  803a78:	83 c4 1c             	add    $0x1c,%esp
  803a7b:	5b                   	pop    %ebx
  803a7c:	5e                   	pop    %esi
  803a7d:	5f                   	pop    %edi
  803a7e:	5d                   	pop    %ebp
  803a7f:	c3                   	ret    
  803a80:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a85:	89 eb                	mov    %ebp,%ebx
  803a87:	29 fb                	sub    %edi,%ebx
  803a89:	89 f9                	mov    %edi,%ecx
  803a8b:	d3 e6                	shl    %cl,%esi
  803a8d:	89 c5                	mov    %eax,%ebp
  803a8f:	88 d9                	mov    %bl,%cl
  803a91:	d3 ed                	shr    %cl,%ebp
  803a93:	89 e9                	mov    %ebp,%ecx
  803a95:	09 f1                	or     %esi,%ecx
  803a97:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a9b:	89 f9                	mov    %edi,%ecx
  803a9d:	d3 e0                	shl    %cl,%eax
  803a9f:	89 c5                	mov    %eax,%ebp
  803aa1:	89 d6                	mov    %edx,%esi
  803aa3:	88 d9                	mov    %bl,%cl
  803aa5:	d3 ee                	shr    %cl,%esi
  803aa7:	89 f9                	mov    %edi,%ecx
  803aa9:	d3 e2                	shl    %cl,%edx
  803aab:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aaf:	88 d9                	mov    %bl,%cl
  803ab1:	d3 e8                	shr    %cl,%eax
  803ab3:	09 c2                	or     %eax,%edx
  803ab5:	89 d0                	mov    %edx,%eax
  803ab7:	89 f2                	mov    %esi,%edx
  803ab9:	f7 74 24 0c          	divl   0xc(%esp)
  803abd:	89 d6                	mov    %edx,%esi
  803abf:	89 c3                	mov    %eax,%ebx
  803ac1:	f7 e5                	mul    %ebp
  803ac3:	39 d6                	cmp    %edx,%esi
  803ac5:	72 19                	jb     803ae0 <__udivdi3+0xfc>
  803ac7:	74 0b                	je     803ad4 <__udivdi3+0xf0>
  803ac9:	89 d8                	mov    %ebx,%eax
  803acb:	31 ff                	xor    %edi,%edi
  803acd:	e9 58 ff ff ff       	jmp    803a2a <__udivdi3+0x46>
  803ad2:	66 90                	xchg   %ax,%ax
  803ad4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ad8:	89 f9                	mov    %edi,%ecx
  803ada:	d3 e2                	shl    %cl,%edx
  803adc:	39 c2                	cmp    %eax,%edx
  803ade:	73 e9                	jae    803ac9 <__udivdi3+0xe5>
  803ae0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ae3:	31 ff                	xor    %edi,%edi
  803ae5:	e9 40 ff ff ff       	jmp    803a2a <__udivdi3+0x46>
  803aea:	66 90                	xchg   %ax,%ax
  803aec:	31 c0                	xor    %eax,%eax
  803aee:	e9 37 ff ff ff       	jmp    803a2a <__udivdi3+0x46>
  803af3:	90                   	nop

00803af4 <__umoddi3>:
  803af4:	55                   	push   %ebp
  803af5:	57                   	push   %edi
  803af6:	56                   	push   %esi
  803af7:	53                   	push   %ebx
  803af8:	83 ec 1c             	sub    $0x1c,%esp
  803afb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803aff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b07:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b13:	89 f3                	mov    %esi,%ebx
  803b15:	89 fa                	mov    %edi,%edx
  803b17:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b1b:	89 34 24             	mov    %esi,(%esp)
  803b1e:	85 c0                	test   %eax,%eax
  803b20:	75 1a                	jne    803b3c <__umoddi3+0x48>
  803b22:	39 f7                	cmp    %esi,%edi
  803b24:	0f 86 a2 00 00 00    	jbe    803bcc <__umoddi3+0xd8>
  803b2a:	89 c8                	mov    %ecx,%eax
  803b2c:	89 f2                	mov    %esi,%edx
  803b2e:	f7 f7                	div    %edi
  803b30:	89 d0                	mov    %edx,%eax
  803b32:	31 d2                	xor    %edx,%edx
  803b34:	83 c4 1c             	add    $0x1c,%esp
  803b37:	5b                   	pop    %ebx
  803b38:	5e                   	pop    %esi
  803b39:	5f                   	pop    %edi
  803b3a:	5d                   	pop    %ebp
  803b3b:	c3                   	ret    
  803b3c:	39 f0                	cmp    %esi,%eax
  803b3e:	0f 87 ac 00 00 00    	ja     803bf0 <__umoddi3+0xfc>
  803b44:	0f bd e8             	bsr    %eax,%ebp
  803b47:	83 f5 1f             	xor    $0x1f,%ebp
  803b4a:	0f 84 ac 00 00 00    	je     803bfc <__umoddi3+0x108>
  803b50:	bf 20 00 00 00       	mov    $0x20,%edi
  803b55:	29 ef                	sub    %ebp,%edi
  803b57:	89 fe                	mov    %edi,%esi
  803b59:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b5d:	89 e9                	mov    %ebp,%ecx
  803b5f:	d3 e0                	shl    %cl,%eax
  803b61:	89 d7                	mov    %edx,%edi
  803b63:	89 f1                	mov    %esi,%ecx
  803b65:	d3 ef                	shr    %cl,%edi
  803b67:	09 c7                	or     %eax,%edi
  803b69:	89 e9                	mov    %ebp,%ecx
  803b6b:	d3 e2                	shl    %cl,%edx
  803b6d:	89 14 24             	mov    %edx,(%esp)
  803b70:	89 d8                	mov    %ebx,%eax
  803b72:	d3 e0                	shl    %cl,%eax
  803b74:	89 c2                	mov    %eax,%edx
  803b76:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b7a:	d3 e0                	shl    %cl,%eax
  803b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b80:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b84:	89 f1                	mov    %esi,%ecx
  803b86:	d3 e8                	shr    %cl,%eax
  803b88:	09 d0                	or     %edx,%eax
  803b8a:	d3 eb                	shr    %cl,%ebx
  803b8c:	89 da                	mov    %ebx,%edx
  803b8e:	f7 f7                	div    %edi
  803b90:	89 d3                	mov    %edx,%ebx
  803b92:	f7 24 24             	mull   (%esp)
  803b95:	89 c6                	mov    %eax,%esi
  803b97:	89 d1                	mov    %edx,%ecx
  803b99:	39 d3                	cmp    %edx,%ebx
  803b9b:	0f 82 87 00 00 00    	jb     803c28 <__umoddi3+0x134>
  803ba1:	0f 84 91 00 00 00    	je     803c38 <__umoddi3+0x144>
  803ba7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bab:	29 f2                	sub    %esi,%edx
  803bad:	19 cb                	sbb    %ecx,%ebx
  803baf:	89 d8                	mov    %ebx,%eax
  803bb1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bb5:	d3 e0                	shl    %cl,%eax
  803bb7:	89 e9                	mov    %ebp,%ecx
  803bb9:	d3 ea                	shr    %cl,%edx
  803bbb:	09 d0                	or     %edx,%eax
  803bbd:	89 e9                	mov    %ebp,%ecx
  803bbf:	d3 eb                	shr    %cl,%ebx
  803bc1:	89 da                	mov    %ebx,%edx
  803bc3:	83 c4 1c             	add    $0x1c,%esp
  803bc6:	5b                   	pop    %ebx
  803bc7:	5e                   	pop    %esi
  803bc8:	5f                   	pop    %edi
  803bc9:	5d                   	pop    %ebp
  803bca:	c3                   	ret    
  803bcb:	90                   	nop
  803bcc:	89 fd                	mov    %edi,%ebp
  803bce:	85 ff                	test   %edi,%edi
  803bd0:	75 0b                	jne    803bdd <__umoddi3+0xe9>
  803bd2:	b8 01 00 00 00       	mov    $0x1,%eax
  803bd7:	31 d2                	xor    %edx,%edx
  803bd9:	f7 f7                	div    %edi
  803bdb:	89 c5                	mov    %eax,%ebp
  803bdd:	89 f0                	mov    %esi,%eax
  803bdf:	31 d2                	xor    %edx,%edx
  803be1:	f7 f5                	div    %ebp
  803be3:	89 c8                	mov    %ecx,%eax
  803be5:	f7 f5                	div    %ebp
  803be7:	89 d0                	mov    %edx,%eax
  803be9:	e9 44 ff ff ff       	jmp    803b32 <__umoddi3+0x3e>
  803bee:	66 90                	xchg   %ax,%ax
  803bf0:	89 c8                	mov    %ecx,%eax
  803bf2:	89 f2                	mov    %esi,%edx
  803bf4:	83 c4 1c             	add    $0x1c,%esp
  803bf7:	5b                   	pop    %ebx
  803bf8:	5e                   	pop    %esi
  803bf9:	5f                   	pop    %edi
  803bfa:	5d                   	pop    %ebp
  803bfb:	c3                   	ret    
  803bfc:	3b 04 24             	cmp    (%esp),%eax
  803bff:	72 06                	jb     803c07 <__umoddi3+0x113>
  803c01:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c05:	77 0f                	ja     803c16 <__umoddi3+0x122>
  803c07:	89 f2                	mov    %esi,%edx
  803c09:	29 f9                	sub    %edi,%ecx
  803c0b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c0f:	89 14 24             	mov    %edx,(%esp)
  803c12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c16:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c1a:	8b 14 24             	mov    (%esp),%edx
  803c1d:	83 c4 1c             	add    $0x1c,%esp
  803c20:	5b                   	pop    %ebx
  803c21:	5e                   	pop    %esi
  803c22:	5f                   	pop    %edi
  803c23:	5d                   	pop    %ebp
  803c24:	c3                   	ret    
  803c25:	8d 76 00             	lea    0x0(%esi),%esi
  803c28:	2b 04 24             	sub    (%esp),%eax
  803c2b:	19 fa                	sbb    %edi,%edx
  803c2d:	89 d1                	mov    %edx,%ecx
  803c2f:	89 c6                	mov    %eax,%esi
  803c31:	e9 71 ff ff ff       	jmp    803ba7 <__umoddi3+0xb3>
  803c36:	66 90                	xchg   %ax,%ax
  803c38:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c3c:	72 ea                	jb     803c28 <__umoddi3+0x134>
  803c3e:	89 d9                	mov    %ebx,%ecx
  803c40:	e9 62 ff ff ff       	jmp    803ba7 <__umoddi3+0xb3>
