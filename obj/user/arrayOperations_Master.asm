
obj/user/arrayOperations_Master:     file format elf32-i386


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
  800031:	e8 d0 06 00 00       	call   800706 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 88 00 00 00    	sub    $0x88,%esp
	int ret;
	char Chose;
	char Line[30];
	//2012: lock the interrupt
//	sys_lock_cons();
	sys_lock_cons();
  800041:	e8 3b 1f 00 00       	call   801f81 <sys_lock_cons>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 40 42 80 00       	push   $0x804240
  80004e:	e8 af 0a 00 00       	call   800b02 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 42 42 80 00       	push   $0x804242
  80005e:	e8 9f 0a 00 00       	call   800b02 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 60 42 80 00       	push   $0x804260
  80006e:	e8 8f 0a 00 00       	call   800b02 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 42 42 80 00       	push   $0x804242
  80007e:	e8 7f 0a 00 00       	call   800b02 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 42 80 00       	push   $0x804240
  80008e:	e8 6f 0a 00 00       	call   800b02 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 80 42 80 00       	push   $0x804280
  8000a2:	e8 ef 10 00 00       	call   801196 <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 9f 42 80 00       	push   $0x80429f
  8000b6:	e8 1c 1d 00 00       	call   801dd7 <smalloc>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 0a                	push   $0xa
  8000c6:	6a 00                	push   $0x0
  8000c8:	8d 45 82             	lea    -0x7e(%ebp),%eax
  8000cb:	50                   	push   %eax
  8000cc:	e8 2d 16 00 00       	call   8016fe <strtol>
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	89 c2                	mov    %eax,%edx
  8000d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d9:	89 10                	mov    %edx,(%eax)
		int NumOfElements = *arrSize;
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8b 00                	mov    (%eax),%eax
  8000e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  8000e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e6:	c1 e0 02             	shl    $0x2,%eax
  8000e9:	83 ec 04             	sub    $0x4,%esp
  8000ec:	6a 00                	push   $0x0
  8000ee:	50                   	push   %eax
  8000ef:	68 a7 42 80 00       	push   $0x8042a7
  8000f4:	e8 de 1c 00 00       	call   801dd7 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 ac 42 80 00       	push   $0x8042ac
  800107:	e8 f6 09 00 00       	call   800b02 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 ce 42 80 00       	push   $0x8042ce
  800117:	e8 e6 09 00 00       	call   800b02 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 dc 42 80 00       	push   $0x8042dc
  800127:	e8 d6 09 00 00       	call   800b02 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 eb 42 80 00       	push   $0x8042eb
  800137:	e8 c6 09 00 00       	call   800b02 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 fb 42 80 00       	push   $0x8042fb
  800147:	e8 b6 09 00 00       	call   800b02 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80014f:	e8 95 05 00 00       	call   8006e9 <getchar>
  800154:	88 45 eb             	mov    %al,-0x15(%ebp)
			cputchar(Chose);
  800157:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	50                   	push   %eax
  80015f:	e8 66 05 00 00       	call   8006ca <cputchar>
  800164:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	6a 0a                	push   $0xa
  80016c:	e8 59 05 00 00       	call   8006ca <cputchar>
  800171:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800174:	80 7d eb 61          	cmpb   $0x61,-0x15(%ebp)
  800178:	74 0c                	je     800186 <_main+0x14e>
  80017a:	80 7d eb 62          	cmpb   $0x62,-0x15(%ebp)
  80017e:	74 06                	je     800186 <_main+0x14e>
  800180:	80 7d eb 63          	cmpb   $0x63,-0x15(%ebp)
  800184:	75 b9                	jne    80013f <_main+0x107>

	sys_unlock_cons();
  800186:	e8 10 1e 00 00       	call   801f9b <sys_unlock_cons>
//	//2012: unlock the interrupt
//	sys_unlock_cons();

	int  i ;
	switch (Chose)
  80018b:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80018f:	83 f8 62             	cmp    $0x62,%eax
  800192:	74 1d                	je     8001b1 <_main+0x179>
  800194:	83 f8 63             	cmp    $0x63,%eax
  800197:	74 2b                	je     8001c4 <_main+0x18c>
  800199:	83 f8 61             	cmp    $0x61,%eax
  80019c:	75 39                	jne    8001d7 <_main+0x19f>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	e8 a4 03 00 00       	call   800550 <InitializeAscending>
  8001ac:	83 c4 10             	add    $0x10,%esp
		break ;
  8001af:	eb 37                	jmp    8001e8 <_main+0x1b0>
	case 'b':
		InitializeIdentical(Elements, NumOfElements);
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 c2 03 00 00       	call   800581 <InitializeIdentical>
  8001bf:	83 c4 10             	add    $0x10,%esp
		break ;
  8001c2:	eb 24                	jmp    8001e8 <_main+0x1b0>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 e4 03 00 00       	call   8005b6 <InitializeSemiRandom>
  8001d2:	83 c4 10             	add    $0x10,%esp
		break ;
  8001d5:	eb 11                	jmp    8001e8 <_main+0x1b0>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	ff 75 f0             	pushl  -0x10(%ebp)
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	e8 d1 03 00 00       	call   8005b6 <InitializeSemiRandom>
  8001e5:	83 c4 10             	add    $0x10,%esp
	}

	//Create the check-finishing counter
	int numOfSlaveProgs = 3 ;
  8001e8:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	6a 04                	push   $0x4
  8001f6:	68 04 43 80 00       	push   $0x804304
  8001fb:	e8 d7 1b 00 00       	call   801dd7 <smalloc>
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  800206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[2] RUN THE SLAVES PROGRAMS*/
	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  80020f:	a1 20 50 80 00       	mov    0x805020,%eax
  800214:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800225:	89 c1                	mov    %eax,%ecx
  800227:	a1 20 50 80 00       	mov    0x805020,%eax
  80022c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800232:	52                   	push   %edx
  800233:	51                   	push   %ecx
  800234:	50                   	push   %eax
  800235:	68 12 43 80 00       	push   $0x804312
  80023a:	e8 50 1f 00 00       	call   80218f <sys_create_env>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800245:	a1 20 50 80 00       	mov    0x805020,%eax
  80024a:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800250:	a1 20 50 80 00       	mov    0x805020,%eax
  800255:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80025b:	89 c1                	mov    %eax,%ecx
  80025d:	a1 20 50 80 00       	mov    0x805020,%eax
  800262:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800268:	52                   	push   %edx
  800269:	51                   	push   %ecx
  80026a:	50                   	push   %eax
  80026b:	68 1b 43 80 00       	push   $0x80431b
  800270:	e8 1a 1f 00 00       	call   80218f <sys_create_env>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80027b:	a1 20 50 80 00       	mov    0x805020,%eax
  800280:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800286:	a1 20 50 80 00       	mov    0x805020,%eax
  80028b:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800291:	89 c1                	mov    %eax,%ecx
  800293:	a1 20 50 80 00       	mov    0x805020,%eax
  800298:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80029e:	52                   	push   %edx
  80029f:	51                   	push   %ecx
  8002a0:	50                   	push   %eax
  8002a1:	68 24 43 80 00       	push   $0x804324
  8002a6:	e8 e4 1e 00 00       	call   80218f <sys_create_env>
  8002ab:	83 c4 10             	add    $0x10,%esp
  8002ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if (envIdQuickSort == E_ENV_CREATION_ERROR || envIdMergeSort == E_ENV_CREATION_ERROR || envIdStats == E_ENV_CREATION_ERROR)
  8002b1:	83 7d dc ef          	cmpl   $0xffffffef,-0x24(%ebp)
  8002b5:	74 0c                	je     8002c3 <_main+0x28b>
  8002b7:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  8002bb:	74 06                	je     8002c3 <_main+0x28b>
  8002bd:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  8002c1:	75 14                	jne    8002d7 <_main+0x29f>
		panic("NO AVAILABLE ENVs...");
  8002c3:	83 ec 04             	sub    $0x4,%esp
  8002c6:	68 30 43 80 00       	push   $0x804330
  8002cb:	6a 4e                	push   $0x4e
  8002cd:	68 45 43 80 00       	push   $0x804345
  8002d2:	e8 6e 05 00 00       	call   800845 <_panic>

	sys_run_env(envIdQuickSort);
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	ff 75 dc             	pushl  -0x24(%ebp)
  8002dd:	e8 cb 1e 00 00       	call   8021ad <sys_run_env>
  8002e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002eb:	e8 bd 1e 00 00       	call   8021ad <sys_run_env>
  8002f0:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f9:	e8 af 1e 00 00       	call   8021ad <sys_run_env>
  8002fe:	83 c4 10             	add    $0x10,%esp

	/*[3] BUSY-WAIT TILL FINISHING THEM*/
	while (*numOfFinished != numOfSlaveProgs) ;
  800301:	90                   	nop
  800302:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800305:	8b 00                	mov    (%eax),%eax
  800307:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80030a:	75 f6                	jne    800302 <_main+0x2ca>

	/*[4] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  80030c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int *mergesortedArr = NULL;
  800313:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	int *mean = NULL;
  80031a:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	int *var = NULL;
  800321:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	int *min = NULL;
  800328:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
	int *max = NULL;
  80032f:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int *med = NULL;
  800336:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	68 63 43 80 00       	push   $0x804363
  800345:	ff 75 dc             	pushl  -0x24(%ebp)
  800348:	e8 19 1b 00 00       	call   801e66 <sget>
  80034d:	83 c4 10             	add    $0x10,%esp
  800350:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  800353:	83 ec 08             	sub    $0x8,%esp
  800356:	68 72 43 80 00       	push   $0x804372
  80035b:	ff 75 d8             	pushl  -0x28(%ebp)
  80035e:	e8 03 1b 00 00       	call   801e66 <sget>
  800363:	83 c4 10             	add    $0x10,%esp
  800366:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800369:	83 ec 08             	sub    $0x8,%esp
  80036c:	68 81 43 80 00       	push   $0x804381
  800371:	ff 75 d4             	pushl  -0x2c(%ebp)
  800374:	e8 ed 1a 00 00       	call   801e66 <sget>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	68 86 43 80 00       	push   $0x804386
  800387:	ff 75 d4             	pushl  -0x2c(%ebp)
  80038a:	e8 d7 1a 00 00       	call   801e66 <sget>
  80038f:	83 c4 10             	add    $0x10,%esp
  800392:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  800395:	83 ec 08             	sub    $0x8,%esp
  800398:	68 8a 43 80 00       	push   $0x80438a
  80039d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003a0:	e8 c1 1a 00 00       	call   801e66 <sget>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003ab:	83 ec 08             	sub    $0x8,%esp
  8003ae:	68 8e 43 80 00       	push   $0x80438e
  8003b3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003b6:	e8 ab 1a 00 00       	call   801e66 <sget>
  8003bb:	83 c4 10             	add    $0x10,%esp
  8003be:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	68 92 43 80 00       	push   $0x804392
  8003c9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003cc:	e8 95 1a 00 00       	call   801e66 <sget>
  8003d1:	83 c4 10             	add    $0x10,%esp
  8003d4:	89 45 b8             	mov    %eax,-0x48(%ebp)

	/*[5] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  8003d7:	83 ec 08             	sub    $0x8,%esp
  8003da:	ff 75 f0             	pushl  -0x10(%ebp)
  8003dd:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e0:	e8 14 01 00 00       	call   8004f9 <CheckSorted>
  8003e5:	83 c4 10             	add    $0x10,%esp
  8003e8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  8003eb:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8003ef:	75 14                	jne    800405 <_main+0x3cd>
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	68 98 43 80 00       	push   $0x804398
  8003f9:	6a 69                	push   $0x69
  8003fb:	68 45 43 80 00       	push   $0x804345
  800400:	e8 40 04 00 00       	call   800845 <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  800405:	83 ec 08             	sub    $0x8,%esp
  800408:	ff 75 f0             	pushl  -0x10(%ebp)
  80040b:	ff 75 cc             	pushl  -0x34(%ebp)
  80040e:	e8 e6 00 00 00       	call   8004f9 <CheckSorted>
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  800419:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80041d:	75 14                	jne    800433 <_main+0x3fb>
  80041f:	83 ec 04             	sub    $0x4,%esp
  800422:	68 c0 43 80 00       	push   $0x8043c0
  800427:	6a 6b                	push   $0x6b
  800429:	68 45 43 80 00       	push   $0x804345
  80042e:	e8 12 04 00 00       	call   800845 <_panic>
	int correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  800433:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  800439:	50                   	push   %eax
  80043a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800440:	50                   	push   %eax
  800441:	ff 75 f0             	pushl  -0x10(%ebp)
  800444:	ff 75 ec             	pushl  -0x14(%ebp)
  800447:	e8 b6 01 00 00       	call   800602 <ArrayStats>
  80044c:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  80044f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int last = NumOfElements-1;
  800457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045a:	48                   	dec    %eax
  80045b:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int middle = (NumOfElements-1)/2;
  80045e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800461:	48                   	dec    %eax
  800462:	89 c2                	mov    %eax,%edx
  800464:	c1 ea 1f             	shr    $0x1f,%edx
  800467:	01 d0                	add    %edx,%eax
  800469:	d1 f8                	sar    %eax
  80046b:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int correctMax = quicksortedArr[last];
  80046e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800471:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800478:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80047b:	01 d0                	add    %edx,%eax
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int correctMed = quicksortedArr[middle];
  800482:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800485:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80048f:	01 d0                	add    %edx,%eax
  800491:	8b 00                	mov    (%eax),%eax
  800493:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//cprintf("Array is correctly sorted\n");
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);

	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  800496:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800499:	8b 10                	mov    (%eax),%edx
  80049b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8004a1:	39 c2                	cmp    %eax,%edx
  8004a3:	75 2d                	jne    8004d2 <_main+0x49a>
  8004a5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004a8:	8b 10                	mov    (%eax),%edx
  8004aa:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8004b0:	39 c2                	cmp    %eax,%edx
  8004b2:	75 1e                	jne    8004d2 <_main+0x49a>
  8004b4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  8004bc:	75 14                	jne    8004d2 <_main+0x49a>
  8004be:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8004c6:	75 0a                	jne    8004d2 <_main+0x49a>
  8004c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	3b 45 a0             	cmp    -0x60(%ebp),%eax
  8004d0:	74 14                	je     8004e6 <_main+0x4ae>
		panic("The array STATS are NOT calculated correctly") ;
  8004d2:	83 ec 04             	sub    $0x4,%esp
  8004d5:	68 e8 43 80 00       	push   $0x8043e8
  8004da:	6a 78                	push   $0x78
  8004dc:	68 45 43 80 00       	push   $0x804345
  8004e1:	e8 5f 03 00 00       	call   800845 <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004e6:	83 ec 0c             	sub    $0xc,%esp
  8004e9:	68 18 44 80 00       	push   $0x804418
  8004ee:	e8 0f 06 00 00       	call   800b02 <cprintf>
  8004f3:	83 c4 10             	add    $0x10,%esp

	return;
  8004f6:	90                   	nop
}
  8004f7:	c9                   	leave  
  8004f8:	c3                   	ret    

008004f9 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8004ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800506:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80050d:	eb 33                	jmp    800542 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80050f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800512:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800519:	8b 45 08             	mov    0x8(%ebp),%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	8b 10                	mov    (%eax),%edx
  800520:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800523:	40                   	inc    %eax
  800524:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	01 c8                	add    %ecx,%eax
  800530:	8b 00                	mov    (%eax),%eax
  800532:	39 c2                	cmp    %eax,%edx
  800534:	7e 09                	jle    80053f <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800536:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80053d:	eb 0c                	jmp    80054b <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80053f:	ff 45 f8             	incl   -0x8(%ebp)
  800542:	8b 45 0c             	mov    0xc(%ebp),%eax
  800545:	48                   	dec    %eax
  800546:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800549:	7f c4                	jg     80050f <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80054b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80054e:	c9                   	leave  
  80054f:	c3                   	ret    

00800550 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
  800553:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800556:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80055d:	eb 17                	jmp    800576 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80055f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800562:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	01 c2                	add    %eax,%edx
  80056e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800571:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800573:	ff 45 fc             	incl   -0x4(%ebp)
  800576:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800579:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80057c:	7c e1                	jl     80055f <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80057e:	90                   	nop
  80057f:	c9                   	leave  
  800580:	c3                   	ret    

00800581 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  800581:	55                   	push   %ebp
  800582:	89 e5                	mov    %esp,%ebp
  800584:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800587:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80058e:	eb 1b                	jmp    8005ab <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800590:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	01 c2                	add    %eax,%edx
  80059f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a2:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8005a5:	48                   	dec    %eax
  8005a6:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8005a8:	ff 45 fc             	incl   -0x4(%ebp)
  8005ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005b1:	7c dd                	jl     800590 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8005b3:	90                   	nop
  8005b4:	c9                   	leave  
  8005b5:	c3                   	ret    

008005b6 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8005bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005bf:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8005c4:	f7 e9                	imul   %ecx
  8005c6:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c9:	89 d0                	mov    %edx,%eax
  8005cb:	29 c8                	sub    %ecx,%eax
  8005cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8005d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8005d7:	eb 1e                	jmp    8005f7 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8005d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e6:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8005e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005ec:	99                   	cltd   
  8005ed:	f7 7d f8             	idivl  -0x8(%ebp)
  8005f0:	89 d0                	mov    %edx,%eax
  8005f2:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8005f4:	ff 45 fc             	incl   -0x4(%ebp)
  8005f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005fd:	7c da                	jl     8005d9 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  8005ff:	90                   	nop
  800600:	c9                   	leave  
  800601:	c3                   	ret    

00800602 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
  800602:	55                   	push   %ebp
  800603:	89 e5                	mov    %esp,%ebp
  800605:	53                   	push   %ebx
  800606:	83 ec 10             	sub    $0x10,%esp
	int i ;
	*mean =0 ;
  800609:	8b 45 10             	mov    0x10(%ebp),%eax
  80060c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800612:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800619:	eb 20                	jmp    80063b <ArrayStats+0x39>
	{
		*mean += Elements[i];
  80061b:	8b 45 10             	mov    0x10(%ebp),%eax
  80061e:	8b 10                	mov    (%eax),%edx
  800620:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800623:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80062a:	8b 45 08             	mov    0x8(%ebp),%eax
  80062d:	01 c8                	add    %ecx,%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	01 c2                	add    %eax,%edx
  800633:	8b 45 10             	mov    0x10(%ebp),%eax
  800636:	89 10                	mov    %edx,(%eax)

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800638:	ff 45 f8             	incl   -0x8(%ebp)
  80063b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80063e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800641:	7c d8                	jl     80061b <ArrayStats+0x19>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  800643:	8b 45 10             	mov    0x10(%ebp),%eax
  800646:	8b 00                	mov    (%eax),%eax
  800648:	99                   	cltd   
  800649:	f7 7d 0c             	idivl  0xc(%ebp)
  80064c:	89 c2                	mov    %eax,%edx
  80064e:	8b 45 10             	mov    0x10(%ebp),%eax
  800651:	89 10                	mov    %edx,(%eax)
	*var = 0;
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80065c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800663:	eb 46                	jmp    8006ab <ArrayStats+0xa9>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8b 10                	mov    (%eax),%edx
  80066a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80066d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	01 c8                	add    %ecx,%eax
  800679:	8b 08                	mov    (%eax),%ecx
  80067b:	8b 45 10             	mov    0x10(%ebp),%eax
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	89 cb                	mov    %ecx,%ebx
  800682:	29 c3                	sub    %eax,%ebx
  800684:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800687:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	01 c8                	add    %ecx,%eax
  800693:	8b 08                	mov    (%eax),%ecx
  800695:	8b 45 10             	mov    0x10(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	29 c1                	sub    %eax,%ecx
  80069c:	89 c8                	mov    %ecx,%eax
  80069e:	0f af c3             	imul   %ebx,%eax
  8006a1:	01 c2                	add    %eax,%edx
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	89 10                	mov    %edx,(%eax)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8006a8:	ff 45 f8             	incl   -0x8(%ebp)
  8006ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8006ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006b1:	7c b2                	jl     800665 <ArrayStats+0x63>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
	}
	*var /= NumOfElements;
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	99                   	cltd   
  8006b9:	f7 7d 0c             	idivl  0xc(%ebp)
  8006bc:	89 c2                	mov    %eax,%edx
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	89 10                	mov    %edx,(%eax)
}
  8006c3:	90                   	nop
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	5b                   	pop    %ebx
  8006c8:	5d                   	pop    %ebp
  8006c9:	c3                   	ret    

008006ca <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006ca:	55                   	push   %ebp
  8006cb:	89 e5                	mov    %esp,%ebp
  8006cd:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006d6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	50                   	push   %eax
  8006de:	e8 e9 19 00 00       	call   8020cc <sys_cputc>
  8006e3:	83 c4 10             	add    $0x10,%esp
}
  8006e6:	90                   	nop
  8006e7:	c9                   	leave  
  8006e8:	c3                   	ret    

008006e9 <getchar>:


int
getchar(void)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8006ef:	e8 74 18 00 00       	call   801f68 <sys_cgetc>
  8006f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8006f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8006fa:	c9                   	leave  
  8006fb:	c3                   	ret    

008006fc <iscons>:

int iscons(int fdnum)
{
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8006ff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800704:	5d                   	pop    %ebp
  800705:	c3                   	ret    

00800706 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80070c:	e8 ec 1a 00 00       	call   8021fd <sys_getenvindex>
  800711:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800717:	89 d0                	mov    %edx,%eax
  800719:	c1 e0 03             	shl    $0x3,%eax
  80071c:	01 d0                	add    %edx,%eax
  80071e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800725:	01 c8                	add    %ecx,%eax
  800727:	01 c0                	add    %eax,%eax
  800729:	01 d0                	add    %edx,%eax
  80072b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800732:	01 c8                	add    %ecx,%eax
  800734:	01 d0                	add    %edx,%eax
  800736:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80073b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800740:	a1 20 50 80 00       	mov    0x805020,%eax
  800745:	8a 40 20             	mov    0x20(%eax),%al
  800748:	84 c0                	test   %al,%al
  80074a:	74 0d                	je     800759 <libmain+0x53>
		binaryname = myEnv->prog_name;
  80074c:	a1 20 50 80 00       	mov    0x805020,%eax
  800751:	83 c0 20             	add    $0x20,%eax
  800754:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800759:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80075d:	7e 0a                	jle    800769 <libmain+0x63>
		binaryname = argv[0];
  80075f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	ff 75 0c             	pushl  0xc(%ebp)
  80076f:	ff 75 08             	pushl  0x8(%ebp)
  800772:	e8 c1 f8 ff ff       	call   800038 <_main>
  800777:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80077a:	e8 02 18 00 00       	call   801f81 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80077f:	83 ec 0c             	sub    $0xc,%esp
  800782:	68 94 44 80 00       	push   $0x804494
  800787:	e8 76 03 00 00       	call   800b02 <cprintf>
  80078c:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80078f:	a1 20 50 80 00       	mov    0x805020,%eax
  800794:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80079a:	a1 20 50 80 00       	mov    0x805020,%eax
  80079f:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8007a5:	83 ec 04             	sub    $0x4,%esp
  8007a8:	52                   	push   %edx
  8007a9:	50                   	push   %eax
  8007aa:	68 bc 44 80 00       	push   $0x8044bc
  8007af:	e8 4e 03 00 00       	call   800b02 <cprintf>
  8007b4:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8007b7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007bc:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8007c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8007c7:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8007cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8007d2:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8007d8:	51                   	push   %ecx
  8007d9:	52                   	push   %edx
  8007da:	50                   	push   %eax
  8007db:	68 e4 44 80 00       	push   $0x8044e4
  8007e0:	e8 1d 03 00 00       	call   800b02 <cprintf>
  8007e5:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8007ed:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	50                   	push   %eax
  8007f7:	68 3c 45 80 00       	push   $0x80453c
  8007fc:	e8 01 03 00 00       	call   800b02 <cprintf>
  800801:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800804:	83 ec 0c             	sub    $0xc,%esp
  800807:	68 94 44 80 00       	push   $0x804494
  80080c:	e8 f1 02 00 00       	call   800b02 <cprintf>
  800811:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800814:	e8 82 17 00 00       	call   801f9b <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800819:	e8 19 00 00 00       	call   800837 <exit>
}
  80081e:	90                   	nop
  80081f:	c9                   	leave  
  800820:	c3                   	ret    

00800821 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
  800824:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800827:	83 ec 0c             	sub    $0xc,%esp
  80082a:	6a 00                	push   $0x0
  80082c:	e8 98 19 00 00       	call   8021c9 <sys_destroy_env>
  800831:	83 c4 10             	add    $0x10,%esp
}
  800834:	90                   	nop
  800835:	c9                   	leave  
  800836:	c3                   	ret    

00800837 <exit>:

void
exit(void)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
  80083a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80083d:	e8 ed 19 00 00       	call   80222f <sys_exit_env>
}
  800842:	90                   	nop
  800843:	c9                   	leave  
  800844:	c3                   	ret    

00800845 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80084b:	8d 45 10             	lea    0x10(%ebp),%eax
  80084e:	83 c0 04             	add    $0x4,%eax
  800851:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800854:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800859:	85 c0                	test   %eax,%eax
  80085b:	74 16                	je     800873 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80085d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	50                   	push   %eax
  800866:	68 50 45 80 00       	push   $0x804550
  80086b:	e8 92 02 00 00       	call   800b02 <cprintf>
  800870:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800873:	a1 00 50 80 00       	mov    0x805000,%eax
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	50                   	push   %eax
  80087f:	68 55 45 80 00       	push   $0x804555
  800884:	e8 79 02 00 00       	call   800b02 <cprintf>
  800889:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80088c:	8b 45 10             	mov    0x10(%ebp),%eax
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	ff 75 f4             	pushl  -0xc(%ebp)
  800895:	50                   	push   %eax
  800896:	e8 fc 01 00 00       	call   800a97 <vcprintf>
  80089b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	6a 00                	push   $0x0
  8008a3:	68 71 45 80 00       	push   $0x804571
  8008a8:	e8 ea 01 00 00       	call   800a97 <vcprintf>
  8008ad:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008b0:	e8 82 ff ff ff       	call   800837 <exit>

	// should not return here
	while (1) ;
  8008b5:	eb fe                	jmp    8008b5 <_panic+0x70>

008008b7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008bd:	a1 20 50 80 00       	mov    0x805020,%eax
  8008c2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8008c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cb:	39 c2                	cmp    %eax,%edx
  8008cd:	74 14                	je     8008e3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 74 45 80 00       	push   $0x804574
  8008d7:	6a 26                	push   $0x26
  8008d9:	68 c0 45 80 00       	push   $0x8045c0
  8008de:	e8 62 ff ff ff       	call   800845 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008f1:	e9 c5 00 00 00       	jmp    8009bb <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8008f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	01 d0                	add    %edx,%eax
  800905:	8b 00                	mov    (%eax),%eax
  800907:	85 c0                	test   %eax,%eax
  800909:	75 08                	jne    800913 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80090b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80090e:	e9 a5 00 00 00       	jmp    8009b8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800913:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80091a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800921:	eb 69                	jmp    80098c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800923:	a1 20 50 80 00       	mov    0x805020,%eax
  800928:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80092e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800931:	89 d0                	mov    %edx,%eax
  800933:	01 c0                	add    %eax,%eax
  800935:	01 d0                	add    %edx,%eax
  800937:	c1 e0 03             	shl    $0x3,%eax
  80093a:	01 c8                	add    %ecx,%eax
  80093c:	8a 40 04             	mov    0x4(%eax),%al
  80093f:	84 c0                	test   %al,%al
  800941:	75 46                	jne    800989 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800943:	a1 20 50 80 00       	mov    0x805020,%eax
  800948:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80094e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800951:	89 d0                	mov    %edx,%eax
  800953:	01 c0                	add    %eax,%eax
  800955:	01 d0                	add    %edx,%eax
  800957:	c1 e0 03             	shl    $0x3,%eax
  80095a:	01 c8                	add    %ecx,%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800961:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800964:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800969:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80096b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80096e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	01 c8                	add    %ecx,%eax
  80097a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80097c:	39 c2                	cmp    %eax,%edx
  80097e:	75 09                	jne    800989 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800980:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800987:	eb 15                	jmp    80099e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800989:	ff 45 e8             	incl   -0x18(%ebp)
  80098c:	a1 20 50 80 00       	mov    0x805020,%eax
  800991:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800997:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80099a:	39 c2                	cmp    %eax,%edx
  80099c:	77 85                	ja     800923 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80099e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009a2:	75 14                	jne    8009b8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8009a4:	83 ec 04             	sub    $0x4,%esp
  8009a7:	68 cc 45 80 00       	push   $0x8045cc
  8009ac:	6a 3a                	push   $0x3a
  8009ae:	68 c0 45 80 00       	push   $0x8045c0
  8009b3:	e8 8d fe ff ff       	call   800845 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009b8:	ff 45 f0             	incl   -0x10(%ebp)
  8009bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009be:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009c1:	0f 8c 2f ff ff ff    	jl     8008f6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009d5:	eb 26                	jmp    8009fd <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8009dc:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8009e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009e5:	89 d0                	mov    %edx,%eax
  8009e7:	01 c0                	add    %eax,%eax
  8009e9:	01 d0                	add    %edx,%eax
  8009eb:	c1 e0 03             	shl    $0x3,%eax
  8009ee:	01 c8                	add    %ecx,%eax
  8009f0:	8a 40 04             	mov    0x4(%eax),%al
  8009f3:	3c 01                	cmp    $0x1,%al
  8009f5:	75 03                	jne    8009fa <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8009f7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009fa:	ff 45 e0             	incl   -0x20(%ebp)
  8009fd:	a1 20 50 80 00       	mov    0x805020,%eax
  800a02:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800a08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a0b:	39 c2                	cmp    %eax,%edx
  800a0d:	77 c8                	ja     8009d7 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a12:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a15:	74 14                	je     800a2b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a17:	83 ec 04             	sub    $0x4,%esp
  800a1a:	68 20 46 80 00       	push   $0x804620
  800a1f:	6a 44                	push   $0x44
  800a21:	68 c0 45 80 00       	push   $0x8045c0
  800a26:	e8 1a fe ff ff       	call   800845 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a2b:	90                   	nop
  800a2c:	c9                   	leave  
  800a2d:	c3                   	ret    

00800a2e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a37:	8b 00                	mov    (%eax),%eax
  800a39:	8d 48 01             	lea    0x1(%eax),%ecx
  800a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3f:	89 0a                	mov    %ecx,(%edx)
  800a41:	8b 55 08             	mov    0x8(%ebp),%edx
  800a44:	88 d1                	mov    %dl,%cl
  800a46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a49:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a50:	8b 00                	mov    (%eax),%eax
  800a52:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a57:	75 2c                	jne    800a85 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a59:	a0 28 50 80 00       	mov    0x805028,%al
  800a5e:	0f b6 c0             	movzbl %al,%eax
  800a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a64:	8b 12                	mov    (%edx),%edx
  800a66:	89 d1                	mov    %edx,%ecx
  800a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6b:	83 c2 08             	add    $0x8,%edx
  800a6e:	83 ec 04             	sub    $0x4,%esp
  800a71:	50                   	push   %eax
  800a72:	51                   	push   %ecx
  800a73:	52                   	push   %edx
  800a74:	e8 c6 14 00 00       	call   801f3f <sys_cputs>
  800a79:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a88:	8b 40 04             	mov    0x4(%eax),%eax
  800a8b:	8d 50 01             	lea    0x1(%eax),%edx
  800a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a91:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a94:	90                   	nop
  800a95:	c9                   	leave  
  800a96:	c3                   	ret    

00800a97 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aa0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800aa7:	00 00 00 
	b.cnt = 0;
  800aaa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ab1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ab4:	ff 75 0c             	pushl  0xc(%ebp)
  800ab7:	ff 75 08             	pushl  0x8(%ebp)
  800aba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ac0:	50                   	push   %eax
  800ac1:	68 2e 0a 80 00       	push   $0x800a2e
  800ac6:	e8 11 02 00 00       	call   800cdc <vprintfmt>
  800acb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ace:	a0 28 50 80 00       	mov    0x805028,%al
  800ad3:	0f b6 c0             	movzbl %al,%eax
  800ad6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800adc:	83 ec 04             	sub    $0x4,%esp
  800adf:	50                   	push   %eax
  800ae0:	52                   	push   %edx
  800ae1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ae7:	83 c0 08             	add    $0x8,%eax
  800aea:	50                   	push   %eax
  800aeb:	e8 4f 14 00 00       	call   801f3f <sys_cputs>
  800af0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800af3:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800afa:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b00:	c9                   	leave  
  800b01:	c3                   	ret    

00800b02 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b08:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800b0f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	83 ec 08             	sub    $0x8,%esp
  800b1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1e:	50                   	push   %eax
  800b1f:	e8 73 ff ff ff       	call   800a97 <vcprintf>
  800b24:	83 c4 10             	add    $0x10,%esp
  800b27:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b2d:	c9                   	leave  
  800b2e:	c3                   	ret    

00800b2f <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b35:	e8 47 14 00 00       	call   801f81 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b3a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	83 ec 08             	sub    $0x8,%esp
  800b46:	ff 75 f4             	pushl  -0xc(%ebp)
  800b49:	50                   	push   %eax
  800b4a:	e8 48 ff ff ff       	call   800a97 <vcprintf>
  800b4f:	83 c4 10             	add    $0x10,%esp
  800b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b55:	e8 41 14 00 00       	call   801f9b <sys_unlock_cons>
	return cnt;
  800b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	53                   	push   %ebx
  800b63:	83 ec 14             	sub    $0x14,%esp
  800b66:	8b 45 10             	mov    0x10(%ebp),%eax
  800b69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b72:	8b 45 18             	mov    0x18(%ebp),%eax
  800b75:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b7d:	77 55                	ja     800bd4 <printnum+0x75>
  800b7f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b82:	72 05                	jb     800b89 <printnum+0x2a>
  800b84:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b87:	77 4b                	ja     800bd4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b89:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b8c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b8f:	8b 45 18             	mov    0x18(%ebp),%eax
  800b92:	ba 00 00 00 00       	mov    $0x0,%edx
  800b97:	52                   	push   %edx
  800b98:	50                   	push   %eax
  800b99:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9c:	ff 75 f0             	pushl  -0x10(%ebp)
  800b9f:	e8 34 34 00 00       	call   803fd8 <__udivdi3>
  800ba4:	83 c4 10             	add    $0x10,%esp
  800ba7:	83 ec 04             	sub    $0x4,%esp
  800baa:	ff 75 20             	pushl  0x20(%ebp)
  800bad:	53                   	push   %ebx
  800bae:	ff 75 18             	pushl  0x18(%ebp)
  800bb1:	52                   	push   %edx
  800bb2:	50                   	push   %eax
  800bb3:	ff 75 0c             	pushl  0xc(%ebp)
  800bb6:	ff 75 08             	pushl  0x8(%ebp)
  800bb9:	e8 a1 ff ff ff       	call   800b5f <printnum>
  800bbe:	83 c4 20             	add    $0x20,%esp
  800bc1:	eb 1a                	jmp    800bdd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bc3:	83 ec 08             	sub    $0x8,%esp
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	ff 75 20             	pushl  0x20(%ebp)
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	ff d0                	call   *%eax
  800bd1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bd4:	ff 4d 1c             	decl   0x1c(%ebp)
  800bd7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800bdb:	7f e6                	jg     800bc3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bdd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800be0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800beb:	53                   	push   %ebx
  800bec:	51                   	push   %ecx
  800bed:	52                   	push   %edx
  800bee:	50                   	push   %eax
  800bef:	e8 f4 34 00 00       	call   8040e8 <__umoddi3>
  800bf4:	83 c4 10             	add    $0x10,%esp
  800bf7:	05 94 48 80 00       	add    $0x804894,%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	0f be c0             	movsbl %al,%eax
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	ff 75 0c             	pushl  0xc(%ebp)
  800c07:	50                   	push   %eax
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	ff d0                	call   *%eax
  800c0d:	83 c4 10             	add    $0x10,%esp
}
  800c10:	90                   	nop
  800c11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c19:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c1d:	7e 1c                	jle    800c3b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8b 00                	mov    (%eax),%eax
  800c24:	8d 50 08             	lea    0x8(%eax),%edx
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	89 10                	mov    %edx,(%eax)
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	8b 00                	mov    (%eax),%eax
  800c31:	83 e8 08             	sub    $0x8,%eax
  800c34:	8b 50 04             	mov    0x4(%eax),%edx
  800c37:	8b 00                	mov    (%eax),%eax
  800c39:	eb 40                	jmp    800c7b <getuint+0x65>
	else if (lflag)
  800c3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3f:	74 1e                	je     800c5f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	8b 00                	mov    (%eax),%eax
  800c46:	8d 50 04             	lea    0x4(%eax),%edx
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	89 10                	mov    %edx,(%eax)
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	8b 00                	mov    (%eax),%eax
  800c53:	83 e8 04             	sub    $0x4,%eax
  800c56:	8b 00                	mov    (%eax),%eax
  800c58:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5d:	eb 1c                	jmp    800c7b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8b 00                	mov    (%eax),%eax
  800c64:	8d 50 04             	lea    0x4(%eax),%edx
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	89 10                	mov    %edx,(%eax)
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	8b 00                	mov    (%eax),%eax
  800c71:	83 e8 04             	sub    $0x4,%eax
  800c74:	8b 00                	mov    (%eax),%eax
  800c76:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c7b:	5d                   	pop    %ebp
  800c7c:	c3                   	ret    

00800c7d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c7d:	55                   	push   %ebp
  800c7e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c80:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c84:	7e 1c                	jle    800ca2 <getint+0x25>
		return va_arg(*ap, long long);
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	8b 00                	mov    (%eax),%eax
  800c8b:	8d 50 08             	lea    0x8(%eax),%edx
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	89 10                	mov    %edx,(%eax)
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	83 e8 08             	sub    $0x8,%eax
  800c9b:	8b 50 04             	mov    0x4(%eax),%edx
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	eb 38                	jmp    800cda <getint+0x5d>
	else if (lflag)
  800ca2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca6:	74 1a                	je     800cc2 <getint+0x45>
		return va_arg(*ap, long);
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	8d 50 04             	lea    0x4(%eax),%edx
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 10                	mov    %edx,(%eax)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8b 00                	mov    (%eax),%eax
  800cba:	83 e8 04             	sub    $0x4,%eax
  800cbd:	8b 00                	mov    (%eax),%eax
  800cbf:	99                   	cltd   
  800cc0:	eb 18                	jmp    800cda <getint+0x5d>
	else
		return va_arg(*ap, int);
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	8b 00                	mov    (%eax),%eax
  800cc7:	8d 50 04             	lea    0x4(%eax),%edx
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	89 10                	mov    %edx,(%eax)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8b 00                	mov    (%eax),%eax
  800cd4:	83 e8 04             	sub    $0x4,%eax
  800cd7:	8b 00                	mov    (%eax),%eax
  800cd9:	99                   	cltd   
}
  800cda:	5d                   	pop    %ebp
  800cdb:	c3                   	ret    

00800cdc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
  800cdf:	56                   	push   %esi
  800ce0:	53                   	push   %ebx
  800ce1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ce4:	eb 17                	jmp    800cfd <vprintfmt+0x21>
			if (ch == '\0')
  800ce6:	85 db                	test   %ebx,%ebx
  800ce8:	0f 84 c1 03 00 00    	je     8010af <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cee:	83 ec 08             	sub    $0x8,%esp
  800cf1:	ff 75 0c             	pushl  0xc(%ebp)
  800cf4:	53                   	push   %ebx
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	ff d0                	call   *%eax
  800cfa:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800d00:	8d 50 01             	lea    0x1(%eax),%edx
  800d03:	89 55 10             	mov    %edx,0x10(%ebp)
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	0f b6 d8             	movzbl %al,%ebx
  800d0b:	83 fb 25             	cmp    $0x25,%ebx
  800d0e:	75 d6                	jne    800ce6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d10:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d14:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d1b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d22:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d29:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d30:	8b 45 10             	mov    0x10(%ebp),%eax
  800d33:	8d 50 01             	lea    0x1(%eax),%edx
  800d36:	89 55 10             	mov    %edx,0x10(%ebp)
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	0f b6 d8             	movzbl %al,%ebx
  800d3e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d41:	83 f8 5b             	cmp    $0x5b,%eax
  800d44:	0f 87 3d 03 00 00    	ja     801087 <vprintfmt+0x3ab>
  800d4a:	8b 04 85 b8 48 80 00 	mov    0x8048b8(,%eax,4),%eax
  800d51:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d53:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d57:	eb d7                	jmp    800d30 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d59:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d5d:	eb d1                	jmp    800d30 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d5f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d66:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d69:	89 d0                	mov    %edx,%eax
  800d6b:	c1 e0 02             	shl    $0x2,%eax
  800d6e:	01 d0                	add    %edx,%eax
  800d70:	01 c0                	add    %eax,%eax
  800d72:	01 d8                	add    %ebx,%eax
  800d74:	83 e8 30             	sub    $0x30,%eax
  800d77:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7d:	8a 00                	mov    (%eax),%al
  800d7f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d82:	83 fb 2f             	cmp    $0x2f,%ebx
  800d85:	7e 3e                	jle    800dc5 <vprintfmt+0xe9>
  800d87:	83 fb 39             	cmp    $0x39,%ebx
  800d8a:	7f 39                	jg     800dc5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d8c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d8f:	eb d5                	jmp    800d66 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d91:	8b 45 14             	mov    0x14(%ebp),%eax
  800d94:	83 c0 04             	add    $0x4,%eax
  800d97:	89 45 14             	mov    %eax,0x14(%ebp)
  800d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9d:	83 e8 04             	sub    $0x4,%eax
  800da0:	8b 00                	mov    (%eax),%eax
  800da2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800da5:	eb 1f                	jmp    800dc6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800da7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dab:	79 83                	jns    800d30 <vprintfmt+0x54>
				width = 0;
  800dad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800db4:	e9 77 ff ff ff       	jmp    800d30 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800db9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800dc0:	e9 6b ff ff ff       	jmp    800d30 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800dc5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800dc6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dca:	0f 89 60 ff ff ff    	jns    800d30 <vprintfmt+0x54>
				width = precision, precision = -1;
  800dd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dd6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ddd:	e9 4e ff ff ff       	jmp    800d30 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800de2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800de5:	e9 46 ff ff ff       	jmp    800d30 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800dea:	8b 45 14             	mov    0x14(%ebp),%eax
  800ded:	83 c0 04             	add    $0x4,%eax
  800df0:	89 45 14             	mov    %eax,0x14(%ebp)
  800df3:	8b 45 14             	mov    0x14(%ebp),%eax
  800df6:	83 e8 04             	sub    $0x4,%eax
  800df9:	8b 00                	mov    (%eax),%eax
  800dfb:	83 ec 08             	sub    $0x8,%esp
  800dfe:	ff 75 0c             	pushl  0xc(%ebp)
  800e01:	50                   	push   %eax
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	ff d0                	call   *%eax
  800e07:	83 c4 10             	add    $0x10,%esp
			break;
  800e0a:	e9 9b 02 00 00       	jmp    8010aa <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e12:	83 c0 04             	add    $0x4,%eax
  800e15:	89 45 14             	mov    %eax,0x14(%ebp)
  800e18:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1b:	83 e8 04             	sub    $0x4,%eax
  800e1e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e20:	85 db                	test   %ebx,%ebx
  800e22:	79 02                	jns    800e26 <vprintfmt+0x14a>
				err = -err;
  800e24:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e26:	83 fb 64             	cmp    $0x64,%ebx
  800e29:	7f 0b                	jg     800e36 <vprintfmt+0x15a>
  800e2b:	8b 34 9d 00 47 80 00 	mov    0x804700(,%ebx,4),%esi
  800e32:	85 f6                	test   %esi,%esi
  800e34:	75 19                	jne    800e4f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e36:	53                   	push   %ebx
  800e37:	68 a5 48 80 00       	push   $0x8048a5
  800e3c:	ff 75 0c             	pushl  0xc(%ebp)
  800e3f:	ff 75 08             	pushl  0x8(%ebp)
  800e42:	e8 70 02 00 00       	call   8010b7 <printfmt>
  800e47:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e4a:	e9 5b 02 00 00       	jmp    8010aa <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e4f:	56                   	push   %esi
  800e50:	68 ae 48 80 00       	push   $0x8048ae
  800e55:	ff 75 0c             	pushl  0xc(%ebp)
  800e58:	ff 75 08             	pushl  0x8(%ebp)
  800e5b:	e8 57 02 00 00       	call   8010b7 <printfmt>
  800e60:	83 c4 10             	add    $0x10,%esp
			break;
  800e63:	e9 42 02 00 00       	jmp    8010aa <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e68:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6b:	83 c0 04             	add    $0x4,%eax
  800e6e:	89 45 14             	mov    %eax,0x14(%ebp)
  800e71:	8b 45 14             	mov    0x14(%ebp),%eax
  800e74:	83 e8 04             	sub    $0x4,%eax
  800e77:	8b 30                	mov    (%eax),%esi
  800e79:	85 f6                	test   %esi,%esi
  800e7b:	75 05                	jne    800e82 <vprintfmt+0x1a6>
				p = "(null)";
  800e7d:	be b1 48 80 00       	mov    $0x8048b1,%esi
			if (width > 0 && padc != '-')
  800e82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e86:	7e 6d                	jle    800ef5 <vprintfmt+0x219>
  800e88:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e8c:	74 67                	je     800ef5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e91:	83 ec 08             	sub    $0x8,%esp
  800e94:	50                   	push   %eax
  800e95:	56                   	push   %esi
  800e96:	e8 26 05 00 00       	call   8013c1 <strnlen>
  800e9b:	83 c4 10             	add    $0x10,%esp
  800e9e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ea1:	eb 16                	jmp    800eb9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ea3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ea7:	83 ec 08             	sub    $0x8,%esp
  800eaa:	ff 75 0c             	pushl  0xc(%ebp)
  800ead:	50                   	push   %eax
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	ff d0                	call   *%eax
  800eb3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eb6:	ff 4d e4             	decl   -0x1c(%ebp)
  800eb9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ebd:	7f e4                	jg     800ea3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ebf:	eb 34                	jmp    800ef5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ec1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ec5:	74 1c                	je     800ee3 <vprintfmt+0x207>
  800ec7:	83 fb 1f             	cmp    $0x1f,%ebx
  800eca:	7e 05                	jle    800ed1 <vprintfmt+0x1f5>
  800ecc:	83 fb 7e             	cmp    $0x7e,%ebx
  800ecf:	7e 12                	jle    800ee3 <vprintfmt+0x207>
					putch('?', putdat);
  800ed1:	83 ec 08             	sub    $0x8,%esp
  800ed4:	ff 75 0c             	pushl  0xc(%ebp)
  800ed7:	6a 3f                	push   $0x3f
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	ff d0                	call   *%eax
  800ede:	83 c4 10             	add    $0x10,%esp
  800ee1:	eb 0f                	jmp    800ef2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ee3:	83 ec 08             	sub    $0x8,%esp
  800ee6:	ff 75 0c             	pushl  0xc(%ebp)
  800ee9:	53                   	push   %ebx
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	ff d0                	call   *%eax
  800eef:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ef2:	ff 4d e4             	decl   -0x1c(%ebp)
  800ef5:	89 f0                	mov    %esi,%eax
  800ef7:	8d 70 01             	lea    0x1(%eax),%esi
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	0f be d8             	movsbl %al,%ebx
  800eff:	85 db                	test   %ebx,%ebx
  800f01:	74 24                	je     800f27 <vprintfmt+0x24b>
  800f03:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f07:	78 b8                	js     800ec1 <vprintfmt+0x1e5>
  800f09:	ff 4d e0             	decl   -0x20(%ebp)
  800f0c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f10:	79 af                	jns    800ec1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f12:	eb 13                	jmp    800f27 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f14:	83 ec 08             	sub    $0x8,%esp
  800f17:	ff 75 0c             	pushl  0xc(%ebp)
  800f1a:	6a 20                	push   $0x20
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	ff d0                	call   *%eax
  800f21:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f24:	ff 4d e4             	decl   -0x1c(%ebp)
  800f27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f2b:	7f e7                	jg     800f14 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f2d:	e9 78 01 00 00       	jmp    8010aa <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f32:	83 ec 08             	sub    $0x8,%esp
  800f35:	ff 75 e8             	pushl  -0x18(%ebp)
  800f38:	8d 45 14             	lea    0x14(%ebp),%eax
  800f3b:	50                   	push   %eax
  800f3c:	e8 3c fd ff ff       	call   800c7d <getint>
  800f41:	83 c4 10             	add    $0x10,%esp
  800f44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f47:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f50:	85 d2                	test   %edx,%edx
  800f52:	79 23                	jns    800f77 <vprintfmt+0x29b>
				putch('-', putdat);
  800f54:	83 ec 08             	sub    $0x8,%esp
  800f57:	ff 75 0c             	pushl  0xc(%ebp)
  800f5a:	6a 2d                	push   $0x2d
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	ff d0                	call   *%eax
  800f61:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f6a:	f7 d8                	neg    %eax
  800f6c:	83 d2 00             	adc    $0x0,%edx
  800f6f:	f7 da                	neg    %edx
  800f71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f74:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f77:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f7e:	e9 bc 00 00 00       	jmp    80103f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f83:	83 ec 08             	sub    $0x8,%esp
  800f86:	ff 75 e8             	pushl  -0x18(%ebp)
  800f89:	8d 45 14             	lea    0x14(%ebp),%eax
  800f8c:	50                   	push   %eax
  800f8d:	e8 84 fc ff ff       	call   800c16 <getuint>
  800f92:	83 c4 10             	add    $0x10,%esp
  800f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f98:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f9b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fa2:	e9 98 00 00 00       	jmp    80103f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	6a 58                	push   $0x58
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	ff d0                	call   *%eax
  800fb4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fb7:	83 ec 08             	sub    $0x8,%esp
  800fba:	ff 75 0c             	pushl  0xc(%ebp)
  800fbd:	6a 58                	push   $0x58
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	ff d0                	call   *%eax
  800fc4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fc7:	83 ec 08             	sub    $0x8,%esp
  800fca:	ff 75 0c             	pushl  0xc(%ebp)
  800fcd:	6a 58                	push   $0x58
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	ff d0                	call   *%eax
  800fd4:	83 c4 10             	add    $0x10,%esp
			break;
  800fd7:	e9 ce 00 00 00       	jmp    8010aa <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800fdc:	83 ec 08             	sub    $0x8,%esp
  800fdf:	ff 75 0c             	pushl  0xc(%ebp)
  800fe2:	6a 30                	push   $0x30
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	ff d0                	call   *%eax
  800fe9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fec:	83 ec 08             	sub    $0x8,%esp
  800fef:	ff 75 0c             	pushl  0xc(%ebp)
  800ff2:	6a 78                	push   $0x78
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	ff d0                	call   *%eax
  800ff9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ffc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fff:	83 c0 04             	add    $0x4,%eax
  801002:	89 45 14             	mov    %eax,0x14(%ebp)
  801005:	8b 45 14             	mov    0x14(%ebp),%eax
  801008:	83 e8 04             	sub    $0x4,%eax
  80100b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80100d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801010:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801017:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80101e:	eb 1f                	jmp    80103f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801020:	83 ec 08             	sub    $0x8,%esp
  801023:	ff 75 e8             	pushl  -0x18(%ebp)
  801026:	8d 45 14             	lea    0x14(%ebp),%eax
  801029:	50                   	push   %eax
  80102a:	e8 e7 fb ff ff       	call   800c16 <getuint>
  80102f:	83 c4 10             	add    $0x10,%esp
  801032:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801035:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801038:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80103f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801043:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801046:	83 ec 04             	sub    $0x4,%esp
  801049:	52                   	push   %edx
  80104a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80104d:	50                   	push   %eax
  80104e:	ff 75 f4             	pushl  -0xc(%ebp)
  801051:	ff 75 f0             	pushl  -0x10(%ebp)
  801054:	ff 75 0c             	pushl  0xc(%ebp)
  801057:	ff 75 08             	pushl  0x8(%ebp)
  80105a:	e8 00 fb ff ff       	call   800b5f <printnum>
  80105f:	83 c4 20             	add    $0x20,%esp
			break;
  801062:	eb 46                	jmp    8010aa <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801064:	83 ec 08             	sub    $0x8,%esp
  801067:	ff 75 0c             	pushl  0xc(%ebp)
  80106a:	53                   	push   %ebx
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	ff d0                	call   *%eax
  801070:	83 c4 10             	add    $0x10,%esp
			break;
  801073:	eb 35                	jmp    8010aa <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801075:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  80107c:	eb 2c                	jmp    8010aa <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80107e:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  801085:	eb 23                	jmp    8010aa <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801087:	83 ec 08             	sub    $0x8,%esp
  80108a:	ff 75 0c             	pushl  0xc(%ebp)
  80108d:	6a 25                	push   $0x25
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	ff d0                	call   *%eax
  801094:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801097:	ff 4d 10             	decl   0x10(%ebp)
  80109a:	eb 03                	jmp    80109f <vprintfmt+0x3c3>
  80109c:	ff 4d 10             	decl   0x10(%ebp)
  80109f:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a2:	48                   	dec    %eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 25                	cmp    $0x25,%al
  8010a7:	75 f3                	jne    80109c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010a9:	90                   	nop
		}
	}
  8010aa:	e9 35 fc ff ff       	jmp    800ce4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010af:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010b3:	5b                   	pop    %ebx
  8010b4:	5e                   	pop    %esi
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    

008010b7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010bd:	8d 45 10             	lea    0x10(%ebp),%eax
  8010c0:	83 c0 04             	add    $0x4,%eax
  8010c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8010cc:	50                   	push   %eax
  8010cd:	ff 75 0c             	pushl  0xc(%ebp)
  8010d0:	ff 75 08             	pushl  0x8(%ebp)
  8010d3:	e8 04 fc ff ff       	call   800cdc <vprintfmt>
  8010d8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010db:	90                   	nop
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    

008010de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	8b 40 08             	mov    0x8(%eax),%eax
  8010e7:	8d 50 01             	lea    0x1(%eax),%edx
  8010ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ed:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	8b 10                	mov    (%eax),%edx
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	8b 40 04             	mov    0x4(%eax),%eax
  8010fb:	39 c2                	cmp    %eax,%edx
  8010fd:	73 12                	jae    801111 <sprintputch+0x33>
		*b->buf++ = ch;
  8010ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801102:	8b 00                	mov    (%eax),%eax
  801104:	8d 48 01             	lea    0x1(%eax),%ecx
  801107:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110a:	89 0a                	mov    %ecx,(%edx)
  80110c:	8b 55 08             	mov    0x8(%ebp),%edx
  80110f:	88 10                	mov    %dl,(%eax)
}
  801111:	90                   	nop
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    

00801114 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	8d 50 ff             	lea    -0x1(%eax),%edx
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	01 d0                	add    %edx,%eax
  80112b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80112e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801135:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801139:	74 06                	je     801141 <vsnprintf+0x2d>
  80113b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80113f:	7f 07                	jg     801148 <vsnprintf+0x34>
		return -E_INVAL;
  801141:	b8 03 00 00 00       	mov    $0x3,%eax
  801146:	eb 20                	jmp    801168 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801148:	ff 75 14             	pushl  0x14(%ebp)
  80114b:	ff 75 10             	pushl  0x10(%ebp)
  80114e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801151:	50                   	push   %eax
  801152:	68 de 10 80 00       	push   $0x8010de
  801157:	e8 80 fb ff ff       	call   800cdc <vprintfmt>
  80115c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80115f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801162:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801165:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801170:	8d 45 10             	lea    0x10(%ebp),%eax
  801173:	83 c0 04             	add    $0x4,%eax
  801176:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801179:	8b 45 10             	mov    0x10(%ebp),%eax
  80117c:	ff 75 f4             	pushl  -0xc(%ebp)
  80117f:	50                   	push   %eax
  801180:	ff 75 0c             	pushl  0xc(%ebp)
  801183:	ff 75 08             	pushl  0x8(%ebp)
  801186:	e8 89 ff ff ff       	call   801114 <vsnprintf>
  80118b:	83 c4 10             	add    $0x10,%esp
  80118e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801191:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801194:	c9                   	leave  
  801195:	c3                   	ret    

00801196 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  80119c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011a0:	74 13                	je     8011b5 <readline+0x1f>
		cprintf("%s", prompt);
  8011a2:	83 ec 08             	sub    $0x8,%esp
  8011a5:	ff 75 08             	pushl  0x8(%ebp)
  8011a8:	68 28 4a 80 00       	push   $0x804a28
  8011ad:	e8 50 f9 ff ff       	call   800b02 <cprintf>
  8011b2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011bc:	83 ec 0c             	sub    $0xc,%esp
  8011bf:	6a 00                	push   $0x0
  8011c1:	e8 36 f5 ff ff       	call   8006fc <iscons>
  8011c6:	83 c4 10             	add    $0x10,%esp
  8011c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011cc:	e8 18 f5 ff ff       	call   8006e9 <getchar>
  8011d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011d8:	79 22                	jns    8011fc <readline+0x66>
			if (c != -E_EOF)
  8011da:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011de:	0f 84 ad 00 00 00    	je     801291 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8011e4:	83 ec 08             	sub    $0x8,%esp
  8011e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8011ea:	68 2b 4a 80 00       	push   $0x804a2b
  8011ef:	e8 0e f9 ff ff       	call   800b02 <cprintf>
  8011f4:	83 c4 10             	add    $0x10,%esp
			break;
  8011f7:	e9 95 00 00 00       	jmp    801291 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011fc:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801200:	7e 34                	jle    801236 <readline+0xa0>
  801202:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801209:	7f 2b                	jg     801236 <readline+0xa0>
			if (echoing)
  80120b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80120f:	74 0e                	je     80121f <readline+0x89>
				cputchar(c);
  801211:	83 ec 0c             	sub    $0xc,%esp
  801214:	ff 75 ec             	pushl  -0x14(%ebp)
  801217:	e8 ae f4 ff ff       	call   8006ca <cputchar>
  80121c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80121f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801222:	8d 50 01             	lea    0x1(%eax),%edx
  801225:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801228:	89 c2                	mov    %eax,%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 d0                	add    %edx,%eax
  80122f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801232:	88 10                	mov    %dl,(%eax)
  801234:	eb 56                	jmp    80128c <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801236:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80123a:	75 1f                	jne    80125b <readline+0xc5>
  80123c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801240:	7e 19                	jle    80125b <readline+0xc5>
			if (echoing)
  801242:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801246:	74 0e                	je     801256 <readline+0xc0>
				cputchar(c);
  801248:	83 ec 0c             	sub    $0xc,%esp
  80124b:	ff 75 ec             	pushl  -0x14(%ebp)
  80124e:	e8 77 f4 ff ff       	call   8006ca <cputchar>
  801253:	83 c4 10             	add    $0x10,%esp

			i--;
  801256:	ff 4d f4             	decl   -0xc(%ebp)
  801259:	eb 31                	jmp    80128c <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80125b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80125f:	74 0a                	je     80126b <readline+0xd5>
  801261:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801265:	0f 85 61 ff ff ff    	jne    8011cc <readline+0x36>
			if (echoing)
  80126b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126f:	74 0e                	je     80127f <readline+0xe9>
				cputchar(c);
  801271:	83 ec 0c             	sub    $0xc,%esp
  801274:	ff 75 ec             	pushl  -0x14(%ebp)
  801277:	e8 4e f4 ff ff       	call   8006ca <cputchar>
  80127c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80127f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801282:	8b 45 0c             	mov    0xc(%ebp),%eax
  801285:	01 d0                	add    %edx,%eax
  801287:	c6 00 00             	movb   $0x0,(%eax)
			break;
  80128a:	eb 06                	jmp    801292 <readline+0xfc>
		}
	}
  80128c:	e9 3b ff ff ff       	jmp    8011cc <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801291:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801292:	90                   	nop
  801293:	c9                   	leave  
  801294:	c3                   	ret    

00801295 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  80129b:	e8 e1 0c 00 00       	call   801f81 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012a4:	74 13                	je     8012b9 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012a6:	83 ec 08             	sub    $0x8,%esp
  8012a9:	ff 75 08             	pushl  0x8(%ebp)
  8012ac:	68 28 4a 80 00       	push   $0x804a28
  8012b1:	e8 4c f8 ff ff       	call   800b02 <cprintf>
  8012b6:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8012b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8012c0:	83 ec 0c             	sub    $0xc,%esp
  8012c3:	6a 00                	push   $0x0
  8012c5:	e8 32 f4 ff ff       	call   8006fc <iscons>
  8012ca:	83 c4 10             	add    $0x10,%esp
  8012cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8012d0:	e8 14 f4 ff ff       	call   8006e9 <getchar>
  8012d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8012d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012dc:	79 22                	jns    801300 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8012de:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012e2:	0f 84 ad 00 00 00    	je     801395 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8012e8:	83 ec 08             	sub    $0x8,%esp
  8012eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ee:	68 2b 4a 80 00       	push   $0x804a2b
  8012f3:	e8 0a f8 ff ff       	call   800b02 <cprintf>
  8012f8:	83 c4 10             	add    $0x10,%esp
				break;
  8012fb:	e9 95 00 00 00       	jmp    801395 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801300:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801304:	7e 34                	jle    80133a <atomic_readline+0xa5>
  801306:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80130d:	7f 2b                	jg     80133a <atomic_readline+0xa5>
				if (echoing)
  80130f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801313:	74 0e                	je     801323 <atomic_readline+0x8e>
					cputchar(c);
  801315:	83 ec 0c             	sub    $0xc,%esp
  801318:	ff 75 ec             	pushl  -0x14(%ebp)
  80131b:	e8 aa f3 ff ff       	call   8006ca <cputchar>
  801320:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801326:	8d 50 01             	lea    0x1(%eax),%edx
  801329:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80132c:	89 c2                	mov    %eax,%edx
  80132e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801331:	01 d0                	add    %edx,%eax
  801333:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801336:	88 10                	mov    %dl,(%eax)
  801338:	eb 56                	jmp    801390 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  80133a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80133e:	75 1f                	jne    80135f <atomic_readline+0xca>
  801340:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801344:	7e 19                	jle    80135f <atomic_readline+0xca>
				if (echoing)
  801346:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80134a:	74 0e                	je     80135a <atomic_readline+0xc5>
					cputchar(c);
  80134c:	83 ec 0c             	sub    $0xc,%esp
  80134f:	ff 75 ec             	pushl  -0x14(%ebp)
  801352:	e8 73 f3 ff ff       	call   8006ca <cputchar>
  801357:	83 c4 10             	add    $0x10,%esp
				i--;
  80135a:	ff 4d f4             	decl   -0xc(%ebp)
  80135d:	eb 31                	jmp    801390 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80135f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801363:	74 0a                	je     80136f <atomic_readline+0xda>
  801365:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801369:	0f 85 61 ff ff ff    	jne    8012d0 <atomic_readline+0x3b>
				if (echoing)
  80136f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801373:	74 0e                	je     801383 <atomic_readline+0xee>
					cputchar(c);
  801375:	83 ec 0c             	sub    $0xc,%esp
  801378:	ff 75 ec             	pushl  -0x14(%ebp)
  80137b:	e8 4a f3 ff ff       	call   8006ca <cputchar>
  801380:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801383:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801386:	8b 45 0c             	mov    0xc(%ebp),%eax
  801389:	01 d0                	add    %edx,%eax
  80138b:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80138e:	eb 06                	jmp    801396 <atomic_readline+0x101>
			}
		}
  801390:	e9 3b ff ff ff       	jmp    8012d0 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801395:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801396:	e8 00 0c 00 00       	call   801f9b <sys_unlock_cons>
}
  80139b:	90                   	nop
  80139c:	c9                   	leave  
  80139d:	c3                   	ret    

0080139e <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ab:	eb 06                	jmp    8013b3 <strlen+0x15>
		n++;
  8013ad:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013b0:	ff 45 08             	incl   0x8(%ebp)
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	84 c0                	test   %al,%al
  8013ba:	75 f1                	jne    8013ad <strlen+0xf>
		n++;
	return n;
  8013bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    

008013c1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ce:	eb 09                	jmp    8013d9 <strnlen+0x18>
		n++;
  8013d0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013d3:	ff 45 08             	incl   0x8(%ebp)
  8013d6:	ff 4d 0c             	decl   0xc(%ebp)
  8013d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013dd:	74 09                	je     8013e8 <strnlen+0x27>
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	84 c0                	test   %al,%al
  8013e6:	75 e8                	jne    8013d0 <strnlen+0xf>
		n++;
	return n;
  8013e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013f9:	90                   	nop
  8013fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fd:	8d 50 01             	lea    0x1(%eax),%edx
  801400:	89 55 08             	mov    %edx,0x8(%ebp)
  801403:	8b 55 0c             	mov    0xc(%ebp),%edx
  801406:	8d 4a 01             	lea    0x1(%edx),%ecx
  801409:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80140c:	8a 12                	mov    (%edx),%dl
  80140e:	88 10                	mov    %dl,(%eax)
  801410:	8a 00                	mov    (%eax),%al
  801412:	84 c0                	test   %al,%al
  801414:	75 e4                	jne    8013fa <strcpy+0xd>
		/* do nothing */;
	return ret;
  801416:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801427:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80142e:	eb 1f                	jmp    80144f <strncpy+0x34>
		*dst++ = *src;
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8d 50 01             	lea    0x1(%eax),%edx
  801436:	89 55 08             	mov    %edx,0x8(%ebp)
  801439:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143c:	8a 12                	mov    (%edx),%dl
  80143e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	84 c0                	test   %al,%al
  801447:	74 03                	je     80144c <strncpy+0x31>
			src++;
  801449:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80144c:	ff 45 fc             	incl   -0x4(%ebp)
  80144f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801452:	3b 45 10             	cmp    0x10(%ebp),%eax
  801455:	72 d9                	jb     801430 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801457:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801468:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80146c:	74 30                	je     80149e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80146e:	eb 16                	jmp    801486 <strlcpy+0x2a>
			*dst++ = *src++;
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	8d 50 01             	lea    0x1(%eax),%edx
  801476:	89 55 08             	mov    %edx,0x8(%ebp)
  801479:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80147f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801482:	8a 12                	mov    (%edx),%dl
  801484:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801486:	ff 4d 10             	decl   0x10(%ebp)
  801489:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80148d:	74 09                	je     801498 <strlcpy+0x3c>
  80148f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	84 c0                	test   %al,%al
  801496:	75 d8                	jne    801470 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80149e:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a4:	29 c2                	sub    %eax,%edx
  8014a6:	89 d0                	mov    %edx,%eax
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014ad:	eb 06                	jmp    8014b5 <strcmp+0xb>
		p++, q++;
  8014af:	ff 45 08             	incl   0x8(%ebp)
  8014b2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 0e                	je     8014cc <strcmp+0x22>
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	38 c2                	cmp    %al,%dl
  8014ca:	74 e3                	je     8014af <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	0f b6 d0             	movzbl %al,%edx
  8014d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d7:	8a 00                	mov    (%eax),%al
  8014d9:	0f b6 c0             	movzbl %al,%eax
  8014dc:	29 c2                	sub    %eax,%edx
  8014de:	89 d0                	mov    %edx,%eax
}
  8014e0:	5d                   	pop    %ebp
  8014e1:	c3                   	ret    

008014e2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014e5:	eb 09                	jmp    8014f0 <strncmp+0xe>
		n--, p++, q++;
  8014e7:	ff 4d 10             	decl   0x10(%ebp)
  8014ea:	ff 45 08             	incl   0x8(%ebp)
  8014ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014f4:	74 17                	je     80150d <strncmp+0x2b>
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	8a 00                	mov    (%eax),%al
  8014fb:	84 c0                	test   %al,%al
  8014fd:	74 0e                	je     80150d <strncmp+0x2b>
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	8a 10                	mov    (%eax),%dl
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	38 c2                	cmp    %al,%dl
  80150b:	74 da                	je     8014e7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80150d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801511:	75 07                	jne    80151a <strncmp+0x38>
		return 0;
  801513:	b8 00 00 00 00       	mov    $0x0,%eax
  801518:	eb 14                	jmp    80152e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	8a 00                	mov    (%eax),%al
  80151f:	0f b6 d0             	movzbl %al,%edx
  801522:	8b 45 0c             	mov    0xc(%ebp),%eax
  801525:	8a 00                	mov    (%eax),%al
  801527:	0f b6 c0             	movzbl %al,%eax
  80152a:	29 c2                	sub    %eax,%edx
  80152c:	89 d0                	mov    %edx,%eax
}
  80152e:	5d                   	pop    %ebp
  80152f:	c3                   	ret    

00801530 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 04             	sub    $0x4,%esp
  801536:	8b 45 0c             	mov    0xc(%ebp),%eax
  801539:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80153c:	eb 12                	jmp    801550 <strchr+0x20>
		if (*s == c)
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	8a 00                	mov    (%eax),%al
  801543:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801546:	75 05                	jne    80154d <strchr+0x1d>
			return (char *) s;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	eb 11                	jmp    80155e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80154d:	ff 45 08             	incl   0x8(%ebp)
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	8a 00                	mov    (%eax),%al
  801555:	84 c0                	test   %al,%al
  801557:	75 e5                	jne    80153e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 04             	sub    $0x4,%esp
  801566:	8b 45 0c             	mov    0xc(%ebp),%eax
  801569:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80156c:	eb 0d                	jmp    80157b <strfind+0x1b>
		if (*s == c)
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	8a 00                	mov    (%eax),%al
  801573:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801576:	74 0e                	je     801586 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801578:	ff 45 08             	incl   0x8(%ebp)
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	8a 00                	mov    (%eax),%al
  801580:	84 c0                	test   %al,%al
  801582:	75 ea                	jne    80156e <strfind+0xe>
  801584:	eb 01                	jmp    801587 <strfind+0x27>
		if (*s == c)
			break;
  801586:	90                   	nop
	return (char *) s;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801598:	8b 45 10             	mov    0x10(%ebp),%eax
  80159b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80159e:	eb 0e                	jmp    8015ae <memset+0x22>
		*p++ = c;
  8015a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a3:	8d 50 01             	lea    0x1(%eax),%edx
  8015a6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ac:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015ae:	ff 4d f8             	decl   -0x8(%ebp)
  8015b1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015b5:	79 e9                	jns    8015a0 <memset+0x14>
		*p++ = c;

	return v;
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8015ce:	eb 16                	jmp    8015e6 <memcpy+0x2a>
		*d++ = *s++;
  8015d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d3:	8d 50 01             	lea    0x1(%eax),%edx
  8015d6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015dc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015df:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015e2:	8a 12                	mov    (%edx),%dl
  8015e4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8015e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ec:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	75 dd                	jne    8015d0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801601:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80160a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80160d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801610:	73 50                	jae    801662 <memmove+0x6a>
  801612:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801615:	8b 45 10             	mov    0x10(%ebp),%eax
  801618:	01 d0                	add    %edx,%eax
  80161a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80161d:	76 43                	jbe    801662 <memmove+0x6a>
		s += n;
  80161f:	8b 45 10             	mov    0x10(%ebp),%eax
  801622:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801625:	8b 45 10             	mov    0x10(%ebp),%eax
  801628:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80162b:	eb 10                	jmp    80163d <memmove+0x45>
			*--d = *--s;
  80162d:	ff 4d f8             	decl   -0x8(%ebp)
  801630:	ff 4d fc             	decl   -0x4(%ebp)
  801633:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801636:	8a 10                	mov    (%eax),%dl
  801638:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80163d:	8b 45 10             	mov    0x10(%ebp),%eax
  801640:	8d 50 ff             	lea    -0x1(%eax),%edx
  801643:	89 55 10             	mov    %edx,0x10(%ebp)
  801646:	85 c0                	test   %eax,%eax
  801648:	75 e3                	jne    80162d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80164a:	eb 23                	jmp    80166f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80164c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164f:	8d 50 01             	lea    0x1(%eax),%edx
  801652:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801655:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801658:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80165e:	8a 12                	mov    (%edx),%dl
  801660:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	8d 50 ff             	lea    -0x1(%eax),%edx
  801668:	89 55 10             	mov    %edx,0x10(%ebp)
  80166b:	85 c0                	test   %eax,%eax
  80166d:	75 dd                	jne    80164c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801680:	8b 45 0c             	mov    0xc(%ebp),%eax
  801683:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801686:	eb 2a                	jmp    8016b2 <memcmp+0x3e>
		if (*s1 != *s2)
  801688:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80168b:	8a 10                	mov    (%eax),%dl
  80168d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	38 c2                	cmp    %al,%dl
  801694:	74 16                	je     8016ac <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801696:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801699:	8a 00                	mov    (%eax),%al
  80169b:	0f b6 d0             	movzbl %al,%edx
  80169e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a1:	8a 00                	mov    (%eax),%al
  8016a3:	0f b6 c0             	movzbl %al,%eax
  8016a6:	29 c2                	sub    %eax,%edx
  8016a8:	89 d0                	mov    %edx,%eax
  8016aa:	eb 18                	jmp    8016c4 <memcmp+0x50>
		s1++, s2++;
  8016ac:	ff 45 fc             	incl   -0x4(%ebp)
  8016af:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	75 c9                	jne    801688 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8016cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d2:	01 d0                	add    %edx,%eax
  8016d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016d7:	eb 15                	jmp    8016ee <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	8a 00                	mov    (%eax),%al
  8016de:	0f b6 d0             	movzbl %al,%edx
  8016e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e4:	0f b6 c0             	movzbl %al,%eax
  8016e7:	39 c2                	cmp    %eax,%edx
  8016e9:	74 0d                	je     8016f8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016eb:	ff 45 08             	incl   0x8(%ebp)
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016f4:	72 e3                	jb     8016d9 <memfind+0x13>
  8016f6:	eb 01                	jmp    8016f9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016f8:	90                   	nop
	return (void *) s;
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801704:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80170b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801712:	eb 03                	jmp    801717 <strtol+0x19>
		s++;
  801714:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	3c 20                	cmp    $0x20,%al
  80171e:	74 f4                	je     801714 <strtol+0x16>
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	8a 00                	mov    (%eax),%al
  801725:	3c 09                	cmp    $0x9,%al
  801727:	74 eb                	je     801714 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	8a 00                	mov    (%eax),%al
  80172e:	3c 2b                	cmp    $0x2b,%al
  801730:	75 05                	jne    801737 <strtol+0x39>
		s++;
  801732:	ff 45 08             	incl   0x8(%ebp)
  801735:	eb 13                	jmp    80174a <strtol+0x4c>
	else if (*s == '-')
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	8a 00                	mov    (%eax),%al
  80173c:	3c 2d                	cmp    $0x2d,%al
  80173e:	75 0a                	jne    80174a <strtol+0x4c>
		s++, neg = 1;
  801740:	ff 45 08             	incl   0x8(%ebp)
  801743:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80174a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80174e:	74 06                	je     801756 <strtol+0x58>
  801750:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801754:	75 20                	jne    801776 <strtol+0x78>
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	8a 00                	mov    (%eax),%al
  80175b:	3c 30                	cmp    $0x30,%al
  80175d:	75 17                	jne    801776 <strtol+0x78>
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	40                   	inc    %eax
  801763:	8a 00                	mov    (%eax),%al
  801765:	3c 78                	cmp    $0x78,%al
  801767:	75 0d                	jne    801776 <strtol+0x78>
		s += 2, base = 16;
  801769:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80176d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801774:	eb 28                	jmp    80179e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801776:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80177a:	75 15                	jne    801791 <strtol+0x93>
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	8a 00                	mov    (%eax),%al
  801781:	3c 30                	cmp    $0x30,%al
  801783:	75 0c                	jne    801791 <strtol+0x93>
		s++, base = 8;
  801785:	ff 45 08             	incl   0x8(%ebp)
  801788:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80178f:	eb 0d                	jmp    80179e <strtol+0xa0>
	else if (base == 0)
  801791:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801795:	75 07                	jne    80179e <strtol+0xa0>
		base = 10;
  801797:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	8a 00                	mov    (%eax),%al
  8017a3:	3c 2f                	cmp    $0x2f,%al
  8017a5:	7e 19                	jle    8017c0 <strtol+0xc2>
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	8a 00                	mov    (%eax),%al
  8017ac:	3c 39                	cmp    $0x39,%al
  8017ae:	7f 10                	jg     8017c0 <strtol+0xc2>
			dig = *s - '0';
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	0f be c0             	movsbl %al,%eax
  8017b8:	83 e8 30             	sub    $0x30,%eax
  8017bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017be:	eb 42                	jmp    801802 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	8a 00                	mov    (%eax),%al
  8017c5:	3c 60                	cmp    $0x60,%al
  8017c7:	7e 19                	jle    8017e2 <strtol+0xe4>
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	3c 7a                	cmp    $0x7a,%al
  8017d0:	7f 10                	jg     8017e2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	8a 00                	mov    (%eax),%al
  8017d7:	0f be c0             	movsbl %al,%eax
  8017da:	83 e8 57             	sub    $0x57,%eax
  8017dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017e0:	eb 20                	jmp    801802 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	3c 40                	cmp    $0x40,%al
  8017e9:	7e 39                	jle    801824 <strtol+0x126>
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	3c 5a                	cmp    $0x5a,%al
  8017f2:	7f 30                	jg     801824 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	8a 00                	mov    (%eax),%al
  8017f9:	0f be c0             	movsbl %al,%eax
  8017fc:	83 e8 37             	sub    $0x37,%eax
  8017ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801805:	3b 45 10             	cmp    0x10(%ebp),%eax
  801808:	7d 19                	jge    801823 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80180a:	ff 45 08             	incl   0x8(%ebp)
  80180d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801810:	0f af 45 10          	imul   0x10(%ebp),%eax
  801814:	89 c2                	mov    %eax,%edx
  801816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801819:	01 d0                	add    %edx,%eax
  80181b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80181e:	e9 7b ff ff ff       	jmp    80179e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801823:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801824:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801828:	74 08                	je     801832 <strtol+0x134>
		*endptr = (char *) s;
  80182a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182d:	8b 55 08             	mov    0x8(%ebp),%edx
  801830:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801832:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801836:	74 07                	je     80183f <strtol+0x141>
  801838:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80183b:	f7 d8                	neg    %eax
  80183d:	eb 03                	jmp    801842 <strtol+0x144>
  80183f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <ltostr>:

void
ltostr(long value, char *str)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80184a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801851:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801858:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80185c:	79 13                	jns    801871 <ltostr+0x2d>
	{
		neg = 1;
  80185e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801865:	8b 45 0c             	mov    0xc(%ebp),%eax
  801868:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80186b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80186e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801879:	99                   	cltd   
  80187a:	f7 f9                	idiv   %ecx
  80187c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80187f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801882:	8d 50 01             	lea    0x1(%eax),%edx
  801885:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801888:	89 c2                	mov    %eax,%edx
  80188a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188d:	01 d0                	add    %edx,%eax
  80188f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801892:	83 c2 30             	add    $0x30,%edx
  801895:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801897:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80189a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80189f:	f7 e9                	imul   %ecx
  8018a1:	c1 fa 02             	sar    $0x2,%edx
  8018a4:	89 c8                	mov    %ecx,%eax
  8018a6:	c1 f8 1f             	sar    $0x1f,%eax
  8018a9:	29 c2                	sub    %eax,%edx
  8018ab:	89 d0                	mov    %edx,%eax
  8018ad:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018b4:	75 bb                	jne    801871 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c0:	48                   	dec    %eax
  8018c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018c8:	74 3d                	je     801907 <ltostr+0xc3>
		start = 1 ;
  8018ca:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018d1:	eb 34                	jmp    801907 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d9:	01 d0                	add    %edx,%eax
  8018db:	8a 00                	mov    (%eax),%al
  8018dd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e6:	01 c2                	add    %eax,%edx
  8018e8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ee:	01 c8                	add    %ecx,%eax
  8018f0:	8a 00                	mov    (%eax),%al
  8018f2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fa:	01 c2                	add    %eax,%edx
  8018fc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018ff:	88 02                	mov    %al,(%edx)
		start++ ;
  801901:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801904:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80190d:	7c c4                	jl     8018d3 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80190f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801912:	8b 45 0c             	mov    0xc(%ebp),%eax
  801915:	01 d0                	add    %edx,%eax
  801917:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80191a:	90                   	nop
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801923:	ff 75 08             	pushl  0x8(%ebp)
  801926:	e8 73 fa ff ff       	call   80139e <strlen>
  80192b:	83 c4 04             	add    $0x4,%esp
  80192e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801931:	ff 75 0c             	pushl  0xc(%ebp)
  801934:	e8 65 fa ff ff       	call   80139e <strlen>
  801939:	83 c4 04             	add    $0x4,%esp
  80193c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80193f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801946:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80194d:	eb 17                	jmp    801966 <strcconcat+0x49>
		final[s] = str1[s] ;
  80194f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801952:	8b 45 10             	mov    0x10(%ebp),%eax
  801955:	01 c2                	add    %eax,%edx
  801957:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	01 c8                	add    %ecx,%eax
  80195f:	8a 00                	mov    (%eax),%al
  801961:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801963:	ff 45 fc             	incl   -0x4(%ebp)
  801966:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801969:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80196c:	7c e1                	jl     80194f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80196e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801975:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80197c:	eb 1f                	jmp    80199d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80197e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801981:	8d 50 01             	lea    0x1(%eax),%edx
  801984:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801987:	89 c2                	mov    %eax,%edx
  801989:	8b 45 10             	mov    0x10(%ebp),%eax
  80198c:	01 c2                	add    %eax,%edx
  80198e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801991:	8b 45 0c             	mov    0xc(%ebp),%eax
  801994:	01 c8                	add    %ecx,%eax
  801996:	8a 00                	mov    (%eax),%al
  801998:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80199a:	ff 45 f8             	incl   -0x8(%ebp)
  80199d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019a3:	7c d9                	jl     80197e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ab:	01 d0                	add    %edx,%eax
  8019ad:	c6 00 00             	movb   $0x0,(%eax)
}
  8019b0:	90                   	nop
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c2:	8b 00                	mov    (%eax),%eax
  8019c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ce:	01 d0                	add    %edx,%eax
  8019d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019d6:	eb 0c                	jmp    8019e4 <strsplit+0x31>
			*string++ = 0;
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	8d 50 01             	lea    0x1(%eax),%edx
  8019de:	89 55 08             	mov    %edx,0x8(%ebp)
  8019e1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	8a 00                	mov    (%eax),%al
  8019e9:	84 c0                	test   %al,%al
  8019eb:	74 18                	je     801a05 <strsplit+0x52>
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	8a 00                	mov    (%eax),%al
  8019f2:	0f be c0             	movsbl %al,%eax
  8019f5:	50                   	push   %eax
  8019f6:	ff 75 0c             	pushl  0xc(%ebp)
  8019f9:	e8 32 fb ff ff       	call   801530 <strchr>
  8019fe:	83 c4 08             	add    $0x8,%esp
  801a01:	85 c0                	test   %eax,%eax
  801a03:	75 d3                	jne    8019d8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	8a 00                	mov    (%eax),%al
  801a0a:	84 c0                	test   %al,%al
  801a0c:	74 5a                	je     801a68 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a11:	8b 00                	mov    (%eax),%eax
  801a13:	83 f8 0f             	cmp    $0xf,%eax
  801a16:	75 07                	jne    801a1f <strsplit+0x6c>
		{
			return 0;
  801a18:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1d:	eb 66                	jmp    801a85 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a22:	8b 00                	mov    (%eax),%eax
  801a24:	8d 48 01             	lea    0x1(%eax),%ecx
  801a27:	8b 55 14             	mov    0x14(%ebp),%edx
  801a2a:	89 0a                	mov    %ecx,(%edx)
  801a2c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a33:	8b 45 10             	mov    0x10(%ebp),%eax
  801a36:	01 c2                	add    %eax,%edx
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a3d:	eb 03                	jmp    801a42 <strsplit+0x8f>
			string++;
  801a3f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	8a 00                	mov    (%eax),%al
  801a47:	84 c0                	test   %al,%al
  801a49:	74 8b                	je     8019d6 <strsplit+0x23>
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	8a 00                	mov    (%eax),%al
  801a50:	0f be c0             	movsbl %al,%eax
  801a53:	50                   	push   %eax
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	e8 d4 fa ff ff       	call   801530 <strchr>
  801a5c:	83 c4 08             	add    $0x8,%esp
  801a5f:	85 c0                	test   %eax,%eax
  801a61:	74 dc                	je     801a3f <strsplit+0x8c>
			string++;
	}
  801a63:	e9 6e ff ff ff       	jmp    8019d6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a68:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a69:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6c:	8b 00                	mov    (%eax),%eax
  801a6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a75:	8b 45 10             	mov    0x10(%ebp),%eax
  801a78:	01 d0                	add    %edx,%eax
  801a7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a80:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801a8d:	83 ec 04             	sub    $0x4,%esp
  801a90:	68 3c 4a 80 00       	push   $0x804a3c
  801a95:	68 3f 01 00 00       	push   $0x13f
  801a9a:	68 5e 4a 80 00       	push   $0x804a5e
  801a9f:	e8 a1 ed ff ff       	call   800845 <_panic>

00801aa4 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801aaa:	83 ec 0c             	sub    $0xc,%esp
  801aad:	ff 75 08             	pushl  0x8(%ebp)
  801ab0:	e8 35 0a 00 00       	call   8024ea <sys_sbrk>
  801ab5:	83 c4 10             	add    $0x10,%esp
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801ac0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ac4:	75 0a                	jne    801ad0 <malloc+0x16>
  801ac6:	b8 00 00 00 00       	mov    $0x0,%eax
  801acb:	e9 07 02 00 00       	jmp    801cd7 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801ad0:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801ad7:	8b 55 08             	mov    0x8(%ebp),%edx
  801ada:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801add:	01 d0                	add    %edx,%eax
  801adf:	48                   	dec    %eax
  801ae0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ae3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ae6:	ba 00 00 00 00       	mov    $0x0,%edx
  801aeb:	f7 75 dc             	divl   -0x24(%ebp)
  801aee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801af1:	29 d0                	sub    %edx,%eax
  801af3:	c1 e8 0c             	shr    $0xc,%eax
  801af6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801af9:	a1 20 50 80 00       	mov    0x805020,%eax
  801afe:	8b 40 78             	mov    0x78(%eax),%eax
  801b01:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801b06:	29 c2                	sub    %eax,%edx
  801b08:	89 d0                	mov    %edx,%eax
  801b0a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b15:	c1 e8 0c             	shr    $0xc,%eax
  801b18:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801b1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801b22:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801b29:	77 42                	ja     801b6d <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801b2b:	e8 3e 08 00 00       	call   80236e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b30:	85 c0                	test   %eax,%eax
  801b32:	74 16                	je     801b4a <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801b34:	83 ec 0c             	sub    $0xc,%esp
  801b37:	ff 75 08             	pushl  0x8(%ebp)
  801b3a:	e8 7e 0d 00 00       	call   8028bd <alloc_block_FF>
  801b3f:	83 c4 10             	add    $0x10,%esp
  801b42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b45:	e9 8a 01 00 00       	jmp    801cd4 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b4a:	e8 50 08 00 00       	call   80239f <sys_isUHeapPlacementStrategyBESTFIT>
  801b4f:	85 c0                	test   %eax,%eax
  801b51:	0f 84 7d 01 00 00    	je     801cd4 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801b57:	83 ec 0c             	sub    $0xc,%esp
  801b5a:	ff 75 08             	pushl  0x8(%ebp)
  801b5d:	e8 17 12 00 00       	call   802d79 <alloc_block_BF>
  801b62:	83 c4 10             	add    $0x10,%esp
  801b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b68:	e9 67 01 00 00       	jmp    801cd4 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801b6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b70:	48                   	dec    %eax
  801b71:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801b74:	0f 86 53 01 00 00    	jbe    801ccd <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801b7a:	a1 20 50 80 00       	mov    0x805020,%eax
  801b7f:	8b 40 78             	mov    0x78(%eax),%eax
  801b82:	05 00 10 00 00       	add    $0x1000,%eax
  801b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801b8a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801b91:	e9 de 00 00 00       	jmp    801c74 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801b96:	a1 20 50 80 00       	mov    0x805020,%eax
  801b9b:	8b 40 78             	mov    0x78(%eax),%eax
  801b9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ba1:	29 c2                	sub    %eax,%edx
  801ba3:	89 d0                	mov    %edx,%eax
  801ba5:	2d 00 10 00 00       	sub    $0x1000,%eax
  801baa:	c1 e8 0c             	shr    $0xc,%eax
  801bad:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801bb4:	85 c0                	test   %eax,%eax
  801bb6:	0f 85 ab 00 00 00    	jne    801c67 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bbf:	05 00 10 00 00       	add    $0x1000,%eax
  801bc4:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801bc7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801bce:	eb 47                	jmp    801c17 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801bd0:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801bd7:	76 0a                	jbe    801be3 <malloc+0x129>
  801bd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bde:	e9 f4 00 00 00       	jmp    801cd7 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801be3:	a1 20 50 80 00       	mov    0x805020,%eax
  801be8:	8b 40 78             	mov    0x78(%eax),%eax
  801beb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bee:	29 c2                	sub    %eax,%edx
  801bf0:	89 d0                	mov    %edx,%eax
  801bf2:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bf7:	c1 e8 0c             	shr    $0xc,%eax
  801bfa:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801c01:	85 c0                	test   %eax,%eax
  801c03:	74 08                	je     801c0d <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  801c05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c08:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801c0b:	eb 5a                	jmp    801c67 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801c0d:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801c14:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801c17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c1a:	48                   	dec    %eax
  801c1b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c1e:	77 b0                	ja     801bd0 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801c20:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801c27:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c2e:	eb 2f                	jmp    801c5f <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801c30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c33:	c1 e0 0c             	shl    $0xc,%eax
  801c36:	89 c2                	mov    %eax,%edx
  801c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3b:	01 c2                	add    %eax,%edx
  801c3d:	a1 20 50 80 00       	mov    0x805020,%eax
  801c42:	8b 40 78             	mov    0x78(%eax),%eax
  801c45:	29 c2                	sub    %eax,%edx
  801c47:	89 d0                	mov    %edx,%eax
  801c49:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c4e:	c1 e8 0c             	shr    $0xc,%eax
  801c51:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
  801c58:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801c5c:	ff 45 e0             	incl   -0x20(%ebp)
  801c5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c62:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801c65:	72 c9                	jb     801c30 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801c67:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c6b:	75 16                	jne    801c83 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801c6d:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801c74:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801c7b:	0f 86 15 ff ff ff    	jbe    801b96 <malloc+0xdc>
  801c81:	eb 01                	jmp    801c84 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801c83:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801c84:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c88:	75 07                	jne    801c91 <malloc+0x1d7>
  801c8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8f:	eb 46                	jmp    801cd7 <malloc+0x21d>
		ptr = (void*)i;
  801c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801c97:	a1 20 50 80 00       	mov    0x805020,%eax
  801c9c:	8b 40 78             	mov    0x78(%eax),%eax
  801c9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ca2:	29 c2                	sub    %eax,%edx
  801ca4:	89 d0                	mov    %edx,%eax
  801ca6:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cab:	c1 e8 0c             	shr    $0xc,%eax
  801cae:	89 c2                	mov    %eax,%edx
  801cb0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cb3:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801cba:	83 ec 08             	sub    $0x8,%esp
  801cbd:	ff 75 08             	pushl  0x8(%ebp)
  801cc0:	ff 75 f0             	pushl  -0x10(%ebp)
  801cc3:	e8 59 08 00 00       	call   802521 <sys_allocate_user_mem>
  801cc8:	83 c4 10             	add    $0x10,%esp
  801ccb:	eb 07                	jmp    801cd4 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801ccd:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd2:	eb 03                	jmp    801cd7 <malloc+0x21d>
	}
	return ptr;
  801cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801cdf:	a1 20 50 80 00       	mov    0x805020,%eax
  801ce4:	8b 40 78             	mov    0x78(%eax),%eax
  801ce7:	05 00 10 00 00       	add    $0x1000,%eax
  801cec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801cef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801cf6:	a1 20 50 80 00       	mov    0x805020,%eax
  801cfb:	8b 50 78             	mov    0x78(%eax),%edx
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	39 c2                	cmp    %eax,%edx
  801d03:	76 24                	jbe    801d29 <free+0x50>
		size = get_block_size(va);
  801d05:	83 ec 0c             	sub    $0xc,%esp
  801d08:	ff 75 08             	pushl  0x8(%ebp)
  801d0b:	e8 2d 08 00 00       	call   80253d <get_block_size>
  801d10:	83 c4 10             	add    $0x10,%esp
  801d13:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d16:	83 ec 0c             	sub    $0xc,%esp
  801d19:	ff 75 08             	pushl  0x8(%ebp)
  801d1c:	e8 60 1a 00 00       	call   803781 <free_block>
  801d21:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801d24:	e9 ac 00 00 00       	jmp    801dd5 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d2f:	0f 82 89 00 00 00    	jb     801dbe <free+0xe5>
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801d3d:	77 7f                	ja     801dbe <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801d3f:	8b 55 08             	mov    0x8(%ebp),%edx
  801d42:	a1 20 50 80 00       	mov    0x805020,%eax
  801d47:	8b 40 78             	mov    0x78(%eax),%eax
  801d4a:	29 c2                	sub    %eax,%edx
  801d4c:	89 d0                	mov    %edx,%eax
  801d4e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d53:	c1 e8 0c             	shr    $0xc,%eax
  801d56:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801d5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801d60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d63:	c1 e0 0c             	shl    $0xc,%eax
  801d66:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801d69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d70:	eb 2f                	jmp    801da1 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d75:	c1 e0 0c             	shl    $0xc,%eax
  801d78:	89 c2                	mov    %eax,%edx
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	01 c2                	add    %eax,%edx
  801d7f:	a1 20 50 80 00       	mov    0x805020,%eax
  801d84:	8b 40 78             	mov    0x78(%eax),%eax
  801d87:	29 c2                	sub    %eax,%edx
  801d89:	89 d0                	mov    %edx,%eax
  801d8b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d90:	c1 e8 0c             	shr    $0xc,%eax
  801d93:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  801d9a:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801d9e:	ff 45 f4             	incl   -0xc(%ebp)
  801da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801da7:	72 c9                	jb     801d72 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	83 ec 08             	sub    $0x8,%esp
  801daf:	ff 75 ec             	pushl  -0x14(%ebp)
  801db2:	50                   	push   %eax
  801db3:	e8 4d 07 00 00       	call   802505 <sys_free_user_mem>
  801db8:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801dbb:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801dbc:	eb 17                	jmp    801dd5 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801dbe:	83 ec 04             	sub    $0x4,%esp
  801dc1:	68 6c 4a 80 00       	push   $0x804a6c
  801dc6:	68 84 00 00 00       	push   $0x84
  801dcb:	68 96 4a 80 00       	push   $0x804a96
  801dd0:	e8 70 ea ff ff       	call   800845 <_panic>
	}
}
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
  801dda:	83 ec 28             	sub    $0x28,%esp
  801ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  801de0:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801de3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801de7:	75 07                	jne    801df0 <smalloc+0x19>
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dee:	eb 74                	jmp    801e64 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801df6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801dfd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e03:	39 d0                	cmp    %edx,%eax
  801e05:	73 02                	jae    801e09 <smalloc+0x32>
  801e07:	89 d0                	mov    %edx,%eax
  801e09:	83 ec 0c             	sub    $0xc,%esp
  801e0c:	50                   	push   %eax
  801e0d:	e8 a8 fc ff ff       	call   801aba <malloc>
  801e12:	83 c4 10             	add    $0x10,%esp
  801e15:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801e18:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e1c:	75 07                	jne    801e25 <smalloc+0x4e>
  801e1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e23:	eb 3f                	jmp    801e64 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e25:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e29:	ff 75 ec             	pushl  -0x14(%ebp)
  801e2c:	50                   	push   %eax
  801e2d:	ff 75 0c             	pushl  0xc(%ebp)
  801e30:	ff 75 08             	pushl  0x8(%ebp)
  801e33:	e8 d4 02 00 00       	call   80210c <sys_createSharedObject>
  801e38:	83 c4 10             	add    $0x10,%esp
  801e3b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e3e:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e42:	74 06                	je     801e4a <smalloc+0x73>
  801e44:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e48:	75 07                	jne    801e51 <smalloc+0x7a>
  801e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4f:	eb 13                	jmp    801e64 <smalloc+0x8d>
	 cprintf("153\n");
  801e51:	83 ec 0c             	sub    $0xc,%esp
  801e54:	68 a2 4a 80 00       	push   $0x804aa2
  801e59:	e8 a4 ec ff ff       	call   800b02 <cprintf>
  801e5e:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e6c:	83 ec 04             	sub    $0x4,%esp
  801e6f:	68 a8 4a 80 00       	push   $0x804aa8
  801e74:	68 a4 00 00 00       	push   $0xa4
  801e79:	68 96 4a 80 00       	push   $0x804a96
  801e7e:	e8 c2 e9 ff ff       	call   800845 <_panic>

00801e83 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e89:	83 ec 04             	sub    $0x4,%esp
  801e8c:	68 cc 4a 80 00       	push   $0x804acc
  801e91:	68 bc 00 00 00       	push   $0xbc
  801e96:	68 96 4a 80 00       	push   $0x804a96
  801e9b:	e8 a5 e9 ff ff       	call   800845 <_panic>

00801ea0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ea6:	83 ec 04             	sub    $0x4,%esp
  801ea9:	68 f0 4a 80 00       	push   $0x804af0
  801eae:	68 d3 00 00 00       	push   $0xd3
  801eb3:	68 96 4a 80 00       	push   $0x804a96
  801eb8:	e8 88 e9 ff ff       	call   800845 <_panic>

00801ebd <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec3:	83 ec 04             	sub    $0x4,%esp
  801ec6:	68 16 4b 80 00       	push   $0x804b16
  801ecb:	68 df 00 00 00       	push   $0xdf
  801ed0:	68 96 4a 80 00       	push   $0x804a96
  801ed5:	e8 6b e9 ff ff       	call   800845 <_panic>

00801eda <shrink>:

}
void shrink(uint32 newSize)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ee0:	83 ec 04             	sub    $0x4,%esp
  801ee3:	68 16 4b 80 00       	push   $0x804b16
  801ee8:	68 e4 00 00 00       	push   $0xe4
  801eed:	68 96 4a 80 00       	push   $0x804a96
  801ef2:	e8 4e e9 ff ff       	call   800845 <_panic>

00801ef7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801efd:	83 ec 04             	sub    $0x4,%esp
  801f00:	68 16 4b 80 00       	push   $0x804b16
  801f05:	68 e9 00 00 00       	push   $0xe9
  801f0a:	68 96 4a 80 00       	push   $0x804a96
  801f0f:	e8 31 e9 ff ff       	call   800845 <_panic>

00801f14 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	57                   	push   %edi
  801f18:	56                   	push   %esi
  801f19:	53                   	push   %ebx
  801f1a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f26:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f29:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f2c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f2f:	cd 30                	int    $0x30
  801f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f37:	83 c4 10             	add    $0x10,%esp
  801f3a:	5b                   	pop    %ebx
  801f3b:	5e                   	pop    %esi
  801f3c:	5f                   	pop    %edi
  801f3d:	5d                   	pop    %ebp
  801f3e:	c3                   	ret    

00801f3f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	83 ec 04             	sub    $0x4,%esp
  801f45:	8b 45 10             	mov    0x10(%ebp),%eax
  801f48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f4b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	52                   	push   %edx
  801f57:	ff 75 0c             	pushl  0xc(%ebp)
  801f5a:	50                   	push   %eax
  801f5b:	6a 00                	push   $0x0
  801f5d:	e8 b2 ff ff ff       	call   801f14 <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
}
  801f65:	90                   	nop
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 02                	push   $0x2
  801f77:	e8 98 ff ff ff       	call   801f14 <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
}
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 03                	push   $0x3
  801f90:	e8 7f ff ff ff       	call   801f14 <syscall>
  801f95:	83 c4 18             	add    $0x18,%esp
}
  801f98:	90                   	nop
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 04                	push   $0x4
  801faa:	e8 65 ff ff ff       	call   801f14 <syscall>
  801faf:	83 c4 18             	add    $0x18,%esp
}
  801fb2:	90                   	nop
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801fb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	52                   	push   %edx
  801fc5:	50                   	push   %eax
  801fc6:	6a 08                	push   $0x8
  801fc8:	e8 47 ff ff ff       	call   801f14 <syscall>
  801fcd:	83 c4 18             	add    $0x18,%esp
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	56                   	push   %esi
  801fd6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fd7:	8b 75 18             	mov    0x18(%ebp),%esi
  801fda:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fdd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fe0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	56                   	push   %esi
  801fe7:	53                   	push   %ebx
  801fe8:	51                   	push   %ecx
  801fe9:	52                   	push   %edx
  801fea:	50                   	push   %eax
  801feb:	6a 09                	push   $0x9
  801fed:	e8 22 ff ff ff       	call   801f14 <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
}
  801ff5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff8:	5b                   	pop    %ebx
  801ff9:	5e                   	pop    %esi
  801ffa:	5d                   	pop    %ebp
  801ffb:	c3                   	ret    

00801ffc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	52                   	push   %edx
  80200c:	50                   	push   %eax
  80200d:	6a 0a                	push   $0xa
  80200f:	e8 00 ff ff ff       	call   801f14 <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	ff 75 0c             	pushl  0xc(%ebp)
  802025:	ff 75 08             	pushl  0x8(%ebp)
  802028:	6a 0b                	push   $0xb
  80202a:	e8 e5 fe ff ff       	call   801f14 <syscall>
  80202f:	83 c4 18             	add    $0x18,%esp
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 0c                	push   $0xc
  802043:	e8 cc fe ff ff       	call   801f14 <syscall>
  802048:	83 c4 18             	add    $0x18,%esp
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 0d                	push   $0xd
  80205c:	e8 b3 fe ff ff       	call   801f14 <syscall>
  802061:	83 c4 18             	add    $0x18,%esp
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 0e                	push   $0xe
  802075:	e8 9a fe ff ff       	call   801f14 <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 0f                	push   $0xf
  80208e:	e8 81 fe ff ff       	call   801f14 <syscall>
  802093:	83 c4 18             	add    $0x18,%esp
}
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	ff 75 08             	pushl  0x8(%ebp)
  8020a6:	6a 10                	push   $0x10
  8020a8:	e8 67 fe ff ff       	call   801f14 <syscall>
  8020ad:	83 c4 18             	add    $0x18,%esp
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 11                	push   $0x11
  8020c1:	e8 4e fe ff ff       	call   801f14 <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
}
  8020c9:	90                   	nop
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <sys_cputc>:

void
sys_cputc(const char c)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	83 ec 04             	sub    $0x4,%esp
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020d8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	50                   	push   %eax
  8020e5:	6a 01                	push   $0x1
  8020e7:	e8 28 fe ff ff       	call   801f14 <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
}
  8020ef:	90                   	nop
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 14                	push   $0x14
  802101:	e8 0e fe ff ff       	call   801f14 <syscall>
  802106:	83 c4 18             	add    $0x18,%esp
}
  802109:	90                   	nop
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	83 ec 04             	sub    $0x4,%esp
  802112:	8b 45 10             	mov    0x10(%ebp),%eax
  802115:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802118:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80211b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	6a 00                	push   $0x0
  802124:	51                   	push   %ecx
  802125:	52                   	push   %edx
  802126:	ff 75 0c             	pushl  0xc(%ebp)
  802129:	50                   	push   %eax
  80212a:	6a 15                	push   $0x15
  80212c:	e8 e3 fd ff ff       	call   801f14 <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802139:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	52                   	push   %edx
  802146:	50                   	push   %eax
  802147:	6a 16                	push   $0x16
  802149:	e8 c6 fd ff ff       	call   801f14 <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802156:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802159:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	51                   	push   %ecx
  802164:	52                   	push   %edx
  802165:	50                   	push   %eax
  802166:	6a 17                	push   $0x17
  802168:	e8 a7 fd ff ff       	call   801f14 <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802175:	8b 55 0c             	mov    0xc(%ebp),%edx
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	52                   	push   %edx
  802182:	50                   	push   %eax
  802183:	6a 18                	push   $0x18
  802185:	e8 8a fd ff ff       	call   801f14 <syscall>
  80218a:	83 c4 18             	add    $0x18,%esp
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	6a 00                	push   $0x0
  802197:	ff 75 14             	pushl  0x14(%ebp)
  80219a:	ff 75 10             	pushl  0x10(%ebp)
  80219d:	ff 75 0c             	pushl  0xc(%ebp)
  8021a0:	50                   	push   %eax
  8021a1:	6a 19                	push   $0x19
  8021a3:	e8 6c fd ff ff       	call   801f14 <syscall>
  8021a8:	83 c4 18             	add    $0x18,%esp
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <sys_run_env>:

void sys_run_env(int32 envId)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	50                   	push   %eax
  8021bc:	6a 1a                	push   $0x1a
  8021be:	e8 51 fd ff ff       	call   801f14 <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	90                   	nop
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	50                   	push   %eax
  8021d8:	6a 1b                	push   $0x1b
  8021da:	e8 35 fd ff ff       	call   801f14 <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
}
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 05                	push   $0x5
  8021f3:	e8 1c fd ff ff       	call   801f14 <syscall>
  8021f8:	83 c4 18             	add    $0x18,%esp
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 06                	push   $0x6
  80220c:	e8 03 fd ff ff       	call   801f14 <syscall>
  802211:	83 c4 18             	add    $0x18,%esp
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 07                	push   $0x7
  802225:	e8 ea fc ff ff       	call   801f14 <syscall>
  80222a:	83 c4 18             	add    $0x18,%esp
}
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <sys_exit_env>:


void sys_exit_env(void)
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 1c                	push   $0x1c
  80223e:	e8 d1 fc ff ff       	call   801f14 <syscall>
  802243:	83 c4 18             	add    $0x18,%esp
}
  802246:	90                   	nop
  802247:	c9                   	leave  
  802248:	c3                   	ret    

00802249 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
  80224c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80224f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802252:	8d 50 04             	lea    0x4(%eax),%edx
  802255:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	52                   	push   %edx
  80225f:	50                   	push   %eax
  802260:	6a 1d                	push   $0x1d
  802262:	e8 ad fc ff ff       	call   801f14 <syscall>
  802267:	83 c4 18             	add    $0x18,%esp
	return result;
  80226a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80226d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802270:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802273:	89 01                	mov    %eax,(%ecx)
  802275:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	c9                   	leave  
  80227c:	c2 04 00             	ret    $0x4

0080227f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	ff 75 10             	pushl  0x10(%ebp)
  802289:	ff 75 0c             	pushl  0xc(%ebp)
  80228c:	ff 75 08             	pushl  0x8(%ebp)
  80228f:	6a 13                	push   $0x13
  802291:	e8 7e fc ff ff       	call   801f14 <syscall>
  802296:	83 c4 18             	add    $0x18,%esp
	return ;
  802299:	90                   	nop
}
  80229a:	c9                   	leave  
  80229b:	c3                   	ret    

0080229c <sys_rcr2>:
uint32 sys_rcr2()
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 1e                	push   $0x1e
  8022ab:	e8 64 fc ff ff       	call   801f14 <syscall>
  8022b0:	83 c4 18             	add    $0x18,%esp
}
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
  8022b8:	83 ec 04             	sub    $0x4,%esp
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022c1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	50                   	push   %eax
  8022ce:	6a 1f                	push   $0x1f
  8022d0:	e8 3f fc ff ff       	call   801f14 <syscall>
  8022d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d8:	90                   	nop
}
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <rsttst>:
void rsttst()
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 21                	push   $0x21
  8022ea:	e8 25 fc ff ff       	call   801f14 <syscall>
  8022ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f2:	90                   	nop
}
  8022f3:	c9                   	leave  
  8022f4:	c3                   	ret    

008022f5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8022f5:	55                   	push   %ebp
  8022f6:	89 e5                	mov    %esp,%ebp
  8022f8:	83 ec 04             	sub    $0x4,%esp
  8022fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8022fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802301:	8b 55 18             	mov    0x18(%ebp),%edx
  802304:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802308:	52                   	push   %edx
  802309:	50                   	push   %eax
  80230a:	ff 75 10             	pushl  0x10(%ebp)
  80230d:	ff 75 0c             	pushl  0xc(%ebp)
  802310:	ff 75 08             	pushl  0x8(%ebp)
  802313:	6a 20                	push   $0x20
  802315:	e8 fa fb ff ff       	call   801f14 <syscall>
  80231a:	83 c4 18             	add    $0x18,%esp
	return ;
  80231d:	90                   	nop
}
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <chktst>:
void chktst(uint32 n)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	ff 75 08             	pushl  0x8(%ebp)
  80232e:	6a 22                	push   $0x22
  802330:	e8 df fb ff ff       	call   801f14 <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
	return ;
  802338:	90                   	nop
}
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <inctst>:

void inctst()
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 23                	push   $0x23
  80234a:	e8 c5 fb ff ff       	call   801f14 <syscall>
  80234f:	83 c4 18             	add    $0x18,%esp
	return ;
  802352:	90                   	nop
}
  802353:	c9                   	leave  
  802354:	c3                   	ret    

00802355 <gettst>:
uint32 gettst()
{
  802355:	55                   	push   %ebp
  802356:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802358:	6a 00                	push   $0x0
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 24                	push   $0x24
  802364:	e8 ab fb ff ff       	call   801f14 <syscall>
  802369:	83 c4 18             	add    $0x18,%esp
}
  80236c:	c9                   	leave  
  80236d:	c3                   	ret    

0080236e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 25                	push   $0x25
  802380:	e8 8f fb ff ff       	call   801f14 <syscall>
  802385:	83 c4 18             	add    $0x18,%esp
  802388:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80238b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80238f:	75 07                	jne    802398 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802391:	b8 01 00 00 00       	mov    $0x1,%eax
  802396:	eb 05                	jmp    80239d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802398:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
  8023a2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 25                	push   $0x25
  8023b1:	e8 5e fb ff ff       	call   801f14 <syscall>
  8023b6:	83 c4 18             	add    $0x18,%esp
  8023b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023bc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023c0:	75 07                	jne    8023c9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c7:	eb 05                	jmp    8023ce <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 25                	push   $0x25
  8023e2:	e8 2d fb ff ff       	call   801f14 <syscall>
  8023e7:	83 c4 18             	add    $0x18,%esp
  8023ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023ed:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023f1:	75 07                	jne    8023fa <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f8:	eb 05                	jmp    8023ff <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8023fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
  802404:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 25                	push   $0x25
  802413:	e8 fc fa ff ff       	call   801f14 <syscall>
  802418:	83 c4 18             	add    $0x18,%esp
  80241b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80241e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802422:	75 07                	jne    80242b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802424:	b8 01 00 00 00       	mov    $0x1,%eax
  802429:	eb 05                	jmp    802430 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80242b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802430:	c9                   	leave  
  802431:	c3                   	ret    

00802432 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	ff 75 08             	pushl  0x8(%ebp)
  802440:	6a 26                	push   $0x26
  802442:	e8 cd fa ff ff       	call   801f14 <syscall>
  802447:	83 c4 18             	add    $0x18,%esp
	return ;
  80244a:	90                   	nop
}
  80244b:	c9                   	leave  
  80244c:	c3                   	ret    

0080244d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
  802450:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802451:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802454:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802457:	8b 55 0c             	mov    0xc(%ebp),%edx
  80245a:	8b 45 08             	mov    0x8(%ebp),%eax
  80245d:	6a 00                	push   $0x0
  80245f:	53                   	push   %ebx
  802460:	51                   	push   %ecx
  802461:	52                   	push   %edx
  802462:	50                   	push   %eax
  802463:	6a 27                	push   $0x27
  802465:	e8 aa fa ff ff       	call   801f14 <syscall>
  80246a:	83 c4 18             	add    $0x18,%esp
}
  80246d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802470:	c9                   	leave  
  802471:	c3                   	ret    

00802472 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802475:	8b 55 0c             	mov    0xc(%ebp),%edx
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	52                   	push   %edx
  802482:	50                   	push   %eax
  802483:	6a 28                	push   $0x28
  802485:	e8 8a fa ff ff       	call   801f14 <syscall>
  80248a:	83 c4 18             	add    $0x18,%esp
}
  80248d:	c9                   	leave  
  80248e:	c3                   	ret    

0080248f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802492:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802495:	8b 55 0c             	mov    0xc(%ebp),%edx
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	6a 00                	push   $0x0
  80249d:	51                   	push   %ecx
  80249e:	ff 75 10             	pushl  0x10(%ebp)
  8024a1:	52                   	push   %edx
  8024a2:	50                   	push   %eax
  8024a3:	6a 29                	push   $0x29
  8024a5:	e8 6a fa ff ff       	call   801f14 <syscall>
  8024aa:	83 c4 18             	add    $0x18,%esp
}
  8024ad:	c9                   	leave  
  8024ae:	c3                   	ret    

008024af <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	ff 75 10             	pushl  0x10(%ebp)
  8024b9:	ff 75 0c             	pushl  0xc(%ebp)
  8024bc:	ff 75 08             	pushl  0x8(%ebp)
  8024bf:	6a 12                	push   $0x12
  8024c1:	e8 4e fa ff ff       	call   801f14 <syscall>
  8024c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c9:	90                   	nop
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8024cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	52                   	push   %edx
  8024dc:	50                   	push   %eax
  8024dd:	6a 2a                	push   $0x2a
  8024df:	e8 30 fa ff ff       	call   801f14 <syscall>
  8024e4:	83 c4 18             	add    $0x18,%esp
	return;
  8024e7:	90                   	nop
}
  8024e8:	c9                   	leave  
  8024e9:	c3                   	ret    

008024ea <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8024ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	50                   	push   %eax
  8024f9:	6a 2b                	push   $0x2b
  8024fb:	e8 14 fa ff ff       	call   801f14 <syscall>
  802500:	83 c4 18             	add    $0x18,%esp
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	ff 75 0c             	pushl  0xc(%ebp)
  802511:	ff 75 08             	pushl  0x8(%ebp)
  802514:	6a 2c                	push   $0x2c
  802516:	e8 f9 f9 ff ff       	call   801f14 <syscall>
  80251b:	83 c4 18             	add    $0x18,%esp
	return;
  80251e:	90                   	nop
}
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	ff 75 0c             	pushl  0xc(%ebp)
  80252d:	ff 75 08             	pushl  0x8(%ebp)
  802530:	6a 2d                	push   $0x2d
  802532:	e8 dd f9 ff ff       	call   801f14 <syscall>
  802537:	83 c4 18             	add    $0x18,%esp
	return;
  80253a:	90                   	nop
}
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    

0080253d <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
  802540:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802543:	8b 45 08             	mov    0x8(%ebp),%eax
  802546:	83 e8 04             	sub    $0x4,%eax
  802549:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80254c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
  802559:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80255c:	8b 45 08             	mov    0x8(%ebp),%eax
  80255f:	83 e8 04             	sub    $0x4,%eax
  802562:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802565:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802568:	8b 00                	mov    (%eax),%eax
  80256a:	83 e0 01             	and    $0x1,%eax
  80256d:	85 c0                	test   %eax,%eax
  80256f:	0f 94 c0             	sete   %al
}
  802572:	c9                   	leave  
  802573:	c3                   	ret    

00802574 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
  802577:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80257a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802581:	8b 45 0c             	mov    0xc(%ebp),%eax
  802584:	83 f8 02             	cmp    $0x2,%eax
  802587:	74 2b                	je     8025b4 <alloc_block+0x40>
  802589:	83 f8 02             	cmp    $0x2,%eax
  80258c:	7f 07                	jg     802595 <alloc_block+0x21>
  80258e:	83 f8 01             	cmp    $0x1,%eax
  802591:	74 0e                	je     8025a1 <alloc_block+0x2d>
  802593:	eb 58                	jmp    8025ed <alloc_block+0x79>
  802595:	83 f8 03             	cmp    $0x3,%eax
  802598:	74 2d                	je     8025c7 <alloc_block+0x53>
  80259a:	83 f8 04             	cmp    $0x4,%eax
  80259d:	74 3b                	je     8025da <alloc_block+0x66>
  80259f:	eb 4c                	jmp    8025ed <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8025a1:	83 ec 0c             	sub    $0xc,%esp
  8025a4:	ff 75 08             	pushl  0x8(%ebp)
  8025a7:	e8 11 03 00 00       	call   8028bd <alloc_block_FF>
  8025ac:	83 c4 10             	add    $0x10,%esp
  8025af:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025b2:	eb 4a                	jmp    8025fe <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8025b4:	83 ec 0c             	sub    $0xc,%esp
  8025b7:	ff 75 08             	pushl  0x8(%ebp)
  8025ba:	e8 fa 19 00 00       	call   803fb9 <alloc_block_NF>
  8025bf:	83 c4 10             	add    $0x10,%esp
  8025c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025c5:	eb 37                	jmp    8025fe <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8025c7:	83 ec 0c             	sub    $0xc,%esp
  8025ca:	ff 75 08             	pushl  0x8(%ebp)
  8025cd:	e8 a7 07 00 00       	call   802d79 <alloc_block_BF>
  8025d2:	83 c4 10             	add    $0x10,%esp
  8025d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025d8:	eb 24                	jmp    8025fe <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8025da:	83 ec 0c             	sub    $0xc,%esp
  8025dd:	ff 75 08             	pushl  0x8(%ebp)
  8025e0:	e8 b7 19 00 00       	call   803f9c <alloc_block_WF>
  8025e5:	83 c4 10             	add    $0x10,%esp
  8025e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025eb:	eb 11                	jmp    8025fe <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8025ed:	83 ec 0c             	sub    $0xc,%esp
  8025f0:	68 28 4b 80 00       	push   $0x804b28
  8025f5:	e8 08 e5 ff ff       	call   800b02 <cprintf>
  8025fa:	83 c4 10             	add    $0x10,%esp
		break;
  8025fd:	90                   	nop
	}
	return va;
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802601:	c9                   	leave  
  802602:	c3                   	ret    

00802603 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
  802606:	53                   	push   %ebx
  802607:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80260a:	83 ec 0c             	sub    $0xc,%esp
  80260d:	68 48 4b 80 00       	push   $0x804b48
  802612:	e8 eb e4 ff ff       	call   800b02 <cprintf>
  802617:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80261a:	83 ec 0c             	sub    $0xc,%esp
  80261d:	68 73 4b 80 00       	push   $0x804b73
  802622:	e8 db e4 ff ff       	call   800b02 <cprintf>
  802627:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80262a:	8b 45 08             	mov    0x8(%ebp),%eax
  80262d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802630:	eb 37                	jmp    802669 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802632:	83 ec 0c             	sub    $0xc,%esp
  802635:	ff 75 f4             	pushl  -0xc(%ebp)
  802638:	e8 19 ff ff ff       	call   802556 <is_free_block>
  80263d:	83 c4 10             	add    $0x10,%esp
  802640:	0f be d8             	movsbl %al,%ebx
  802643:	83 ec 0c             	sub    $0xc,%esp
  802646:	ff 75 f4             	pushl  -0xc(%ebp)
  802649:	e8 ef fe ff ff       	call   80253d <get_block_size>
  80264e:	83 c4 10             	add    $0x10,%esp
  802651:	83 ec 04             	sub    $0x4,%esp
  802654:	53                   	push   %ebx
  802655:	50                   	push   %eax
  802656:	68 8b 4b 80 00       	push   $0x804b8b
  80265b:	e8 a2 e4 ff ff       	call   800b02 <cprintf>
  802660:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802663:	8b 45 10             	mov    0x10(%ebp),%eax
  802666:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266d:	74 07                	je     802676 <print_blocks_list+0x73>
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 00                	mov    (%eax),%eax
  802674:	eb 05                	jmp    80267b <print_blocks_list+0x78>
  802676:	b8 00 00 00 00       	mov    $0x0,%eax
  80267b:	89 45 10             	mov    %eax,0x10(%ebp)
  80267e:	8b 45 10             	mov    0x10(%ebp),%eax
  802681:	85 c0                	test   %eax,%eax
  802683:	75 ad                	jne    802632 <print_blocks_list+0x2f>
  802685:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802689:	75 a7                	jne    802632 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80268b:	83 ec 0c             	sub    $0xc,%esp
  80268e:	68 48 4b 80 00       	push   $0x804b48
  802693:	e8 6a e4 ff ff       	call   800b02 <cprintf>
  802698:	83 c4 10             	add    $0x10,%esp

}
  80269b:	90                   	nop
  80269c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80269f:	c9                   	leave  
  8026a0:	c3                   	ret    

008026a1 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8026a1:	55                   	push   %ebp
  8026a2:	89 e5                	mov    %esp,%ebp
  8026a4:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8026a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026aa:	83 e0 01             	and    $0x1,%eax
  8026ad:	85 c0                	test   %eax,%eax
  8026af:	74 03                	je     8026b4 <initialize_dynamic_allocator+0x13>
  8026b1:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8026b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026b8:	0f 84 c7 01 00 00    	je     802885 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8026be:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8026c5:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8026c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8026cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ce:	01 d0                	add    %edx,%eax
  8026d0:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8026d5:	0f 87 ad 01 00 00    	ja     802888 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	0f 89 a5 01 00 00    	jns    80288b <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8026e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ec:	01 d0                	add    %edx,%eax
  8026ee:	83 e8 04             	sub    $0x4,%eax
  8026f1:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8026f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8026fd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802702:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802705:	e9 87 00 00 00       	jmp    802791 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80270a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270e:	75 14                	jne    802724 <initialize_dynamic_allocator+0x83>
  802710:	83 ec 04             	sub    $0x4,%esp
  802713:	68 a3 4b 80 00       	push   $0x804ba3
  802718:	6a 79                	push   $0x79
  80271a:	68 c1 4b 80 00       	push   $0x804bc1
  80271f:	e8 21 e1 ff ff       	call   800845 <_panic>
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 00                	mov    (%eax),%eax
  802729:	85 c0                	test   %eax,%eax
  80272b:	74 10                	je     80273d <initialize_dynamic_allocator+0x9c>
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	8b 00                	mov    (%eax),%eax
  802732:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802735:	8b 52 04             	mov    0x4(%edx),%edx
  802738:	89 50 04             	mov    %edx,0x4(%eax)
  80273b:	eb 0b                	jmp    802748 <initialize_dynamic_allocator+0xa7>
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 40 04             	mov    0x4(%eax),%eax
  802743:	a3 30 50 80 00       	mov    %eax,0x805030
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 40 04             	mov    0x4(%eax),%eax
  80274e:	85 c0                	test   %eax,%eax
  802750:	74 0f                	je     802761 <initialize_dynamic_allocator+0xc0>
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 40 04             	mov    0x4(%eax),%eax
  802758:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275b:	8b 12                	mov    (%edx),%edx
  80275d:	89 10                	mov    %edx,(%eax)
  80275f:	eb 0a                	jmp    80276b <initialize_dynamic_allocator+0xca>
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 00                	mov    (%eax),%eax
  802766:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277e:	a1 38 50 80 00       	mov    0x805038,%eax
  802783:	48                   	dec    %eax
  802784:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802789:	a1 34 50 80 00       	mov    0x805034,%eax
  80278e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802791:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802795:	74 07                	je     80279e <initialize_dynamic_allocator+0xfd>
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 00                	mov    (%eax),%eax
  80279c:	eb 05                	jmp    8027a3 <initialize_dynamic_allocator+0x102>
  80279e:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a3:	a3 34 50 80 00       	mov    %eax,0x805034
  8027a8:	a1 34 50 80 00       	mov    0x805034,%eax
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	0f 85 55 ff ff ff    	jne    80270a <initialize_dynamic_allocator+0x69>
  8027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b9:	0f 85 4b ff ff ff    	jne    80270a <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8027bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8027c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8027ce:	a1 44 50 80 00       	mov    0x805044,%eax
  8027d3:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8027d8:	a1 40 50 80 00       	mov    0x805040,%eax
  8027dd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8027e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e6:	83 c0 08             	add    $0x8,%eax
  8027e9:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8027ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ef:	83 c0 04             	add    $0x4,%eax
  8027f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f5:	83 ea 08             	sub    $0x8,%edx
  8027f8:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8027fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802800:	01 d0                	add    %edx,%eax
  802802:	83 e8 08             	sub    $0x8,%eax
  802805:	8b 55 0c             	mov    0xc(%ebp),%edx
  802808:	83 ea 08             	sub    $0x8,%edx
  80280b:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80280d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802810:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802819:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802820:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802824:	75 17                	jne    80283d <initialize_dynamic_allocator+0x19c>
  802826:	83 ec 04             	sub    $0x4,%esp
  802829:	68 dc 4b 80 00       	push   $0x804bdc
  80282e:	68 90 00 00 00       	push   $0x90
  802833:	68 c1 4b 80 00       	push   $0x804bc1
  802838:	e8 08 e0 ff ff       	call   800845 <_panic>
  80283d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802843:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802846:	89 10                	mov    %edx,(%eax)
  802848:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284b:	8b 00                	mov    (%eax),%eax
  80284d:	85 c0                	test   %eax,%eax
  80284f:	74 0d                	je     80285e <initialize_dynamic_allocator+0x1bd>
  802851:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802856:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802859:	89 50 04             	mov    %edx,0x4(%eax)
  80285c:	eb 08                	jmp    802866 <initialize_dynamic_allocator+0x1c5>
  80285e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802861:	a3 30 50 80 00       	mov    %eax,0x805030
  802866:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802869:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80286e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802871:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802878:	a1 38 50 80 00       	mov    0x805038,%eax
  80287d:	40                   	inc    %eax
  80287e:	a3 38 50 80 00       	mov    %eax,0x805038
  802883:	eb 07                	jmp    80288c <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802885:	90                   	nop
  802886:	eb 04                	jmp    80288c <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802888:	90                   	nop
  802889:	eb 01                	jmp    80288c <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80288b:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80288c:	c9                   	leave  
  80288d:	c3                   	ret    

0080288e <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80288e:	55                   	push   %ebp
  80288f:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802891:	8b 45 10             	mov    0x10(%ebp),%eax
  802894:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80289d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028a0:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8028a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a5:	83 e8 04             	sub    $0x4,%eax
  8028a8:	8b 00                	mov    (%eax),%eax
  8028aa:	83 e0 fe             	and    $0xfffffffe,%eax
  8028ad:	8d 50 f8             	lea    -0x8(%eax),%edx
  8028b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b3:	01 c2                	add    %eax,%edx
  8028b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028b8:	89 02                	mov    %eax,(%edx)
}
  8028ba:	90                   	nop
  8028bb:	5d                   	pop    %ebp
  8028bc:	c3                   	ret    

008028bd <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8028bd:	55                   	push   %ebp
  8028be:	89 e5                	mov    %esp,%ebp
  8028c0:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8028c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c6:	83 e0 01             	and    $0x1,%eax
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	74 03                	je     8028d0 <alloc_block_FF+0x13>
  8028cd:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028d0:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028d4:	77 07                	ja     8028dd <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028d6:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028dd:	a1 24 50 80 00       	mov    0x805024,%eax
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	75 73                	jne    802959 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e9:	83 c0 10             	add    $0x10,%eax
  8028ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028ef:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8028f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fc:	01 d0                	add    %edx,%eax
  8028fe:	48                   	dec    %eax
  8028ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802902:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802905:	ba 00 00 00 00       	mov    $0x0,%edx
  80290a:	f7 75 ec             	divl   -0x14(%ebp)
  80290d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802910:	29 d0                	sub    %edx,%eax
  802912:	c1 e8 0c             	shr    $0xc,%eax
  802915:	83 ec 0c             	sub    $0xc,%esp
  802918:	50                   	push   %eax
  802919:	e8 86 f1 ff ff       	call   801aa4 <sbrk>
  80291e:	83 c4 10             	add    $0x10,%esp
  802921:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802924:	83 ec 0c             	sub    $0xc,%esp
  802927:	6a 00                	push   $0x0
  802929:	e8 76 f1 ff ff       	call   801aa4 <sbrk>
  80292e:	83 c4 10             	add    $0x10,%esp
  802931:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802934:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802937:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80293a:	83 ec 08             	sub    $0x8,%esp
  80293d:	50                   	push   %eax
  80293e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802941:	e8 5b fd ff ff       	call   8026a1 <initialize_dynamic_allocator>
  802946:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802949:	83 ec 0c             	sub    $0xc,%esp
  80294c:	68 ff 4b 80 00       	push   $0x804bff
  802951:	e8 ac e1 ff ff       	call   800b02 <cprintf>
  802956:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802959:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80295d:	75 0a                	jne    802969 <alloc_block_FF+0xac>
	        return NULL;
  80295f:	b8 00 00 00 00       	mov    $0x0,%eax
  802964:	e9 0e 04 00 00       	jmp    802d77 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802969:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802970:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802975:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802978:	e9 f3 02 00 00       	jmp    802c70 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802983:	83 ec 0c             	sub    $0xc,%esp
  802986:	ff 75 bc             	pushl  -0x44(%ebp)
  802989:	e8 af fb ff ff       	call   80253d <get_block_size>
  80298e:	83 c4 10             	add    $0x10,%esp
  802991:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802994:	8b 45 08             	mov    0x8(%ebp),%eax
  802997:	83 c0 08             	add    $0x8,%eax
  80299a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80299d:	0f 87 c5 02 00 00    	ja     802c68 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a6:	83 c0 18             	add    $0x18,%eax
  8029a9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8029ac:	0f 87 19 02 00 00    	ja     802bcb <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8029b2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029b5:	2b 45 08             	sub    0x8(%ebp),%eax
  8029b8:	83 e8 08             	sub    $0x8,%eax
  8029bb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	8d 50 08             	lea    0x8(%eax),%edx
  8029c4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029c7:	01 d0                	add    %edx,%eax
  8029c9:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	83 c0 08             	add    $0x8,%eax
  8029d2:	83 ec 04             	sub    $0x4,%esp
  8029d5:	6a 01                	push   $0x1
  8029d7:	50                   	push   %eax
  8029d8:	ff 75 bc             	pushl  -0x44(%ebp)
  8029db:	e8 ae fe ff ff       	call   80288e <set_block_data>
  8029e0:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e6:	8b 40 04             	mov    0x4(%eax),%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	75 68                	jne    802a55 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029ed:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029f1:	75 17                	jne    802a0a <alloc_block_FF+0x14d>
  8029f3:	83 ec 04             	sub    $0x4,%esp
  8029f6:	68 dc 4b 80 00       	push   $0x804bdc
  8029fb:	68 d7 00 00 00       	push   $0xd7
  802a00:	68 c1 4b 80 00       	push   $0x804bc1
  802a05:	e8 3b de ff ff       	call   800845 <_panic>
  802a0a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a10:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a13:	89 10                	mov    %edx,(%eax)
  802a15:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a18:	8b 00                	mov    (%eax),%eax
  802a1a:	85 c0                	test   %eax,%eax
  802a1c:	74 0d                	je     802a2b <alloc_block_FF+0x16e>
  802a1e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a23:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a26:	89 50 04             	mov    %edx,0x4(%eax)
  802a29:	eb 08                	jmp    802a33 <alloc_block_FF+0x176>
  802a2b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a2e:	a3 30 50 80 00       	mov    %eax,0x805030
  802a33:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a36:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a3b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a45:	a1 38 50 80 00       	mov    0x805038,%eax
  802a4a:	40                   	inc    %eax
  802a4b:	a3 38 50 80 00       	mov    %eax,0x805038
  802a50:	e9 dc 00 00 00       	jmp    802b31 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	8b 00                	mov    (%eax),%eax
  802a5a:	85 c0                	test   %eax,%eax
  802a5c:	75 65                	jne    802ac3 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a5e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a62:	75 17                	jne    802a7b <alloc_block_FF+0x1be>
  802a64:	83 ec 04             	sub    $0x4,%esp
  802a67:	68 10 4c 80 00       	push   $0x804c10
  802a6c:	68 db 00 00 00       	push   $0xdb
  802a71:	68 c1 4b 80 00       	push   $0x804bc1
  802a76:	e8 ca dd ff ff       	call   800845 <_panic>
  802a7b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a81:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a84:	89 50 04             	mov    %edx,0x4(%eax)
  802a87:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a8a:	8b 40 04             	mov    0x4(%eax),%eax
  802a8d:	85 c0                	test   %eax,%eax
  802a8f:	74 0c                	je     802a9d <alloc_block_FF+0x1e0>
  802a91:	a1 30 50 80 00       	mov    0x805030,%eax
  802a96:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a99:	89 10                	mov    %edx,(%eax)
  802a9b:	eb 08                	jmp    802aa5 <alloc_block_FF+0x1e8>
  802a9d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aa0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802aa5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aa8:	a3 30 50 80 00       	mov    %eax,0x805030
  802aad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ab0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab6:	a1 38 50 80 00       	mov    0x805038,%eax
  802abb:	40                   	inc    %eax
  802abc:	a3 38 50 80 00       	mov    %eax,0x805038
  802ac1:	eb 6e                	jmp    802b31 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802ac3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac7:	74 06                	je     802acf <alloc_block_FF+0x212>
  802ac9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802acd:	75 17                	jne    802ae6 <alloc_block_FF+0x229>
  802acf:	83 ec 04             	sub    $0x4,%esp
  802ad2:	68 34 4c 80 00       	push   $0x804c34
  802ad7:	68 df 00 00 00       	push   $0xdf
  802adc:	68 c1 4b 80 00       	push   $0x804bc1
  802ae1:	e8 5f dd ff ff       	call   800845 <_panic>
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 10                	mov    (%eax),%edx
  802aeb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aee:	89 10                	mov    %edx,(%eax)
  802af0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802af3:	8b 00                	mov    (%eax),%eax
  802af5:	85 c0                	test   %eax,%eax
  802af7:	74 0b                	je     802b04 <alloc_block_FF+0x247>
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 00                	mov    (%eax),%eax
  802afe:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b01:	89 50 04             	mov    %edx,0x4(%eax)
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b0a:	89 10                	mov    %edx,(%eax)
  802b0c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b12:	89 50 04             	mov    %edx,0x4(%eax)
  802b15:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b18:	8b 00                	mov    (%eax),%eax
  802b1a:	85 c0                	test   %eax,%eax
  802b1c:	75 08                	jne    802b26 <alloc_block_FF+0x269>
  802b1e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b21:	a3 30 50 80 00       	mov    %eax,0x805030
  802b26:	a1 38 50 80 00       	mov    0x805038,%eax
  802b2b:	40                   	inc    %eax
  802b2c:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802b31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b35:	75 17                	jne    802b4e <alloc_block_FF+0x291>
  802b37:	83 ec 04             	sub    $0x4,%esp
  802b3a:	68 a3 4b 80 00       	push   $0x804ba3
  802b3f:	68 e1 00 00 00       	push   $0xe1
  802b44:	68 c1 4b 80 00       	push   $0x804bc1
  802b49:	e8 f7 dc ff ff       	call   800845 <_panic>
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	8b 00                	mov    (%eax),%eax
  802b53:	85 c0                	test   %eax,%eax
  802b55:	74 10                	je     802b67 <alloc_block_FF+0x2aa>
  802b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5a:	8b 00                	mov    (%eax),%eax
  802b5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b5f:	8b 52 04             	mov    0x4(%edx),%edx
  802b62:	89 50 04             	mov    %edx,0x4(%eax)
  802b65:	eb 0b                	jmp    802b72 <alloc_block_FF+0x2b5>
  802b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6a:	8b 40 04             	mov    0x4(%eax),%eax
  802b6d:	a3 30 50 80 00       	mov    %eax,0x805030
  802b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b75:	8b 40 04             	mov    0x4(%eax),%eax
  802b78:	85 c0                	test   %eax,%eax
  802b7a:	74 0f                	je     802b8b <alloc_block_FF+0x2ce>
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	8b 40 04             	mov    0x4(%eax),%eax
  802b82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b85:	8b 12                	mov    (%edx),%edx
  802b87:	89 10                	mov    %edx,(%eax)
  802b89:	eb 0a                	jmp    802b95 <alloc_block_FF+0x2d8>
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba8:	a1 38 50 80 00       	mov    0x805038,%eax
  802bad:	48                   	dec    %eax
  802bae:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802bb3:	83 ec 04             	sub    $0x4,%esp
  802bb6:	6a 00                	push   $0x0
  802bb8:	ff 75 b4             	pushl  -0x4c(%ebp)
  802bbb:	ff 75 b0             	pushl  -0x50(%ebp)
  802bbe:	e8 cb fc ff ff       	call   80288e <set_block_data>
  802bc3:	83 c4 10             	add    $0x10,%esp
  802bc6:	e9 95 00 00 00       	jmp    802c60 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802bcb:	83 ec 04             	sub    $0x4,%esp
  802bce:	6a 01                	push   $0x1
  802bd0:	ff 75 b8             	pushl  -0x48(%ebp)
  802bd3:	ff 75 bc             	pushl  -0x44(%ebp)
  802bd6:	e8 b3 fc ff ff       	call   80288e <set_block_data>
  802bdb:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802bde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be2:	75 17                	jne    802bfb <alloc_block_FF+0x33e>
  802be4:	83 ec 04             	sub    $0x4,%esp
  802be7:	68 a3 4b 80 00       	push   $0x804ba3
  802bec:	68 e8 00 00 00       	push   $0xe8
  802bf1:	68 c1 4b 80 00       	push   $0x804bc1
  802bf6:	e8 4a dc ff ff       	call   800845 <_panic>
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	8b 00                	mov    (%eax),%eax
  802c00:	85 c0                	test   %eax,%eax
  802c02:	74 10                	je     802c14 <alloc_block_FF+0x357>
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	8b 00                	mov    (%eax),%eax
  802c09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0c:	8b 52 04             	mov    0x4(%edx),%edx
  802c0f:	89 50 04             	mov    %edx,0x4(%eax)
  802c12:	eb 0b                	jmp    802c1f <alloc_block_FF+0x362>
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 40 04             	mov    0x4(%eax),%eax
  802c1a:	a3 30 50 80 00       	mov    %eax,0x805030
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	8b 40 04             	mov    0x4(%eax),%eax
  802c25:	85 c0                	test   %eax,%eax
  802c27:	74 0f                	je     802c38 <alloc_block_FF+0x37b>
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	8b 40 04             	mov    0x4(%eax),%eax
  802c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c32:	8b 12                	mov    (%edx),%edx
  802c34:	89 10                	mov    %edx,(%eax)
  802c36:	eb 0a                	jmp    802c42 <alloc_block_FF+0x385>
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	8b 00                	mov    (%eax),%eax
  802c3d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c55:	a1 38 50 80 00       	mov    0x805038,%eax
  802c5a:	48                   	dec    %eax
  802c5b:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802c60:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c63:	e9 0f 01 00 00       	jmp    802d77 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c68:	a1 34 50 80 00       	mov    0x805034,%eax
  802c6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c74:	74 07                	je     802c7d <alloc_block_FF+0x3c0>
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	8b 00                	mov    (%eax),%eax
  802c7b:	eb 05                	jmp    802c82 <alloc_block_FF+0x3c5>
  802c7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c82:	a3 34 50 80 00       	mov    %eax,0x805034
  802c87:	a1 34 50 80 00       	mov    0x805034,%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	0f 85 e9 fc ff ff    	jne    80297d <alloc_block_FF+0xc0>
  802c94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c98:	0f 85 df fc ff ff    	jne    80297d <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	83 c0 08             	add    $0x8,%eax
  802ca4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ca7:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802cae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cb1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cb4:	01 d0                	add    %edx,%eax
  802cb6:	48                   	dec    %eax
  802cb7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802cba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cbd:	ba 00 00 00 00       	mov    $0x0,%edx
  802cc2:	f7 75 d8             	divl   -0x28(%ebp)
  802cc5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cc8:	29 d0                	sub    %edx,%eax
  802cca:	c1 e8 0c             	shr    $0xc,%eax
  802ccd:	83 ec 0c             	sub    $0xc,%esp
  802cd0:	50                   	push   %eax
  802cd1:	e8 ce ed ff ff       	call   801aa4 <sbrk>
  802cd6:	83 c4 10             	add    $0x10,%esp
  802cd9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802cdc:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802ce0:	75 0a                	jne    802cec <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce7:	e9 8b 00 00 00       	jmp    802d77 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cec:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802cf3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cf6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cf9:	01 d0                	add    %edx,%eax
  802cfb:	48                   	dec    %eax
  802cfc:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802cff:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d02:	ba 00 00 00 00       	mov    $0x0,%edx
  802d07:	f7 75 cc             	divl   -0x34(%ebp)
  802d0a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d0d:	29 d0                	sub    %edx,%eax
  802d0f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d12:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d15:	01 d0                	add    %edx,%eax
  802d17:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802d1c:	a1 40 50 80 00       	mov    0x805040,%eax
  802d21:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d27:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d2e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d31:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d34:	01 d0                	add    %edx,%eax
  802d36:	48                   	dec    %eax
  802d37:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d3a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d3d:	ba 00 00 00 00       	mov    $0x0,%edx
  802d42:	f7 75 c4             	divl   -0x3c(%ebp)
  802d45:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d48:	29 d0                	sub    %edx,%eax
  802d4a:	83 ec 04             	sub    $0x4,%esp
  802d4d:	6a 01                	push   $0x1
  802d4f:	50                   	push   %eax
  802d50:	ff 75 d0             	pushl  -0x30(%ebp)
  802d53:	e8 36 fb ff ff       	call   80288e <set_block_data>
  802d58:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802d5b:	83 ec 0c             	sub    $0xc,%esp
  802d5e:	ff 75 d0             	pushl  -0x30(%ebp)
  802d61:	e8 1b 0a 00 00       	call   803781 <free_block>
  802d66:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802d69:	83 ec 0c             	sub    $0xc,%esp
  802d6c:	ff 75 08             	pushl  0x8(%ebp)
  802d6f:	e8 49 fb ff ff       	call   8028bd <alloc_block_FF>
  802d74:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802d77:	c9                   	leave  
  802d78:	c3                   	ret    

00802d79 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802d79:	55                   	push   %ebp
  802d7a:	89 e5                	mov    %esp,%ebp
  802d7c:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d82:	83 e0 01             	and    $0x1,%eax
  802d85:	85 c0                	test   %eax,%eax
  802d87:	74 03                	je     802d8c <alloc_block_BF+0x13>
  802d89:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802d8c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802d90:	77 07                	ja     802d99 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802d92:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802d99:	a1 24 50 80 00       	mov    0x805024,%eax
  802d9e:	85 c0                	test   %eax,%eax
  802da0:	75 73                	jne    802e15 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	83 c0 10             	add    $0x10,%eax
  802da8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802dab:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802db2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802db5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db8:	01 d0                	add    %edx,%eax
  802dba:	48                   	dec    %eax
  802dbb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802dbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc1:	ba 00 00 00 00       	mov    $0x0,%edx
  802dc6:	f7 75 e0             	divl   -0x20(%ebp)
  802dc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dcc:	29 d0                	sub    %edx,%eax
  802dce:	c1 e8 0c             	shr    $0xc,%eax
  802dd1:	83 ec 0c             	sub    $0xc,%esp
  802dd4:	50                   	push   %eax
  802dd5:	e8 ca ec ff ff       	call   801aa4 <sbrk>
  802dda:	83 c4 10             	add    $0x10,%esp
  802ddd:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802de0:	83 ec 0c             	sub    $0xc,%esp
  802de3:	6a 00                	push   $0x0
  802de5:	e8 ba ec ff ff       	call   801aa4 <sbrk>
  802dea:	83 c4 10             	add    $0x10,%esp
  802ded:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802df0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802df3:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802df6:	83 ec 08             	sub    $0x8,%esp
  802df9:	50                   	push   %eax
  802dfa:	ff 75 d8             	pushl  -0x28(%ebp)
  802dfd:	e8 9f f8 ff ff       	call   8026a1 <initialize_dynamic_allocator>
  802e02:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802e05:	83 ec 0c             	sub    $0xc,%esp
  802e08:	68 ff 4b 80 00       	push   $0x804bff
  802e0d:	e8 f0 dc ff ff       	call   800b02 <cprintf>
  802e12:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802e15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802e1c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802e23:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802e2a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802e31:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e39:	e9 1d 01 00 00       	jmp    802f5b <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802e44:	83 ec 0c             	sub    $0xc,%esp
  802e47:	ff 75 a8             	pushl  -0x58(%ebp)
  802e4a:	e8 ee f6 ff ff       	call   80253d <get_block_size>
  802e4f:	83 c4 10             	add    $0x10,%esp
  802e52:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802e55:	8b 45 08             	mov    0x8(%ebp),%eax
  802e58:	83 c0 08             	add    $0x8,%eax
  802e5b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e5e:	0f 87 ef 00 00 00    	ja     802f53 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	83 c0 18             	add    $0x18,%eax
  802e6a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e6d:	77 1d                	ja     802e8c <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802e6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e72:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e75:	0f 86 d8 00 00 00    	jbe    802f53 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802e7b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802e81:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802e84:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e87:	e9 c7 00 00 00       	jmp    802f53 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8f:	83 c0 08             	add    $0x8,%eax
  802e92:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e95:	0f 85 9d 00 00 00    	jne    802f38 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802e9b:	83 ec 04             	sub    $0x4,%esp
  802e9e:	6a 01                	push   $0x1
  802ea0:	ff 75 a4             	pushl  -0x5c(%ebp)
  802ea3:	ff 75 a8             	pushl  -0x58(%ebp)
  802ea6:	e8 e3 f9 ff ff       	call   80288e <set_block_data>
  802eab:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802eae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb2:	75 17                	jne    802ecb <alloc_block_BF+0x152>
  802eb4:	83 ec 04             	sub    $0x4,%esp
  802eb7:	68 a3 4b 80 00       	push   $0x804ba3
  802ebc:	68 2c 01 00 00       	push   $0x12c
  802ec1:	68 c1 4b 80 00       	push   $0x804bc1
  802ec6:	e8 7a d9 ff ff       	call   800845 <_panic>
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	8b 00                	mov    (%eax),%eax
  802ed0:	85 c0                	test   %eax,%eax
  802ed2:	74 10                	je     802ee4 <alloc_block_BF+0x16b>
  802ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed7:	8b 00                	mov    (%eax),%eax
  802ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802edc:	8b 52 04             	mov    0x4(%edx),%edx
  802edf:	89 50 04             	mov    %edx,0x4(%eax)
  802ee2:	eb 0b                	jmp    802eef <alloc_block_BF+0x176>
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	8b 40 04             	mov    0x4(%eax),%eax
  802eea:	a3 30 50 80 00       	mov    %eax,0x805030
  802eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef2:	8b 40 04             	mov    0x4(%eax),%eax
  802ef5:	85 c0                	test   %eax,%eax
  802ef7:	74 0f                	je     802f08 <alloc_block_BF+0x18f>
  802ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efc:	8b 40 04             	mov    0x4(%eax),%eax
  802eff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f02:	8b 12                	mov    (%edx),%edx
  802f04:	89 10                	mov    %edx,(%eax)
  802f06:	eb 0a                	jmp    802f12 <alloc_block_BF+0x199>
  802f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0b:	8b 00                	mov    (%eax),%eax
  802f0d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f25:	a1 38 50 80 00       	mov    0x805038,%eax
  802f2a:	48                   	dec    %eax
  802f2b:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802f30:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f33:	e9 24 04 00 00       	jmp    80335c <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802f38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f3e:	76 13                	jbe    802f53 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802f40:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802f47:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802f4d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f50:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802f53:	a1 34 50 80 00       	mov    0x805034,%eax
  802f58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f5f:	74 07                	je     802f68 <alloc_block_BF+0x1ef>
  802f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	eb 05                	jmp    802f6d <alloc_block_BF+0x1f4>
  802f68:	b8 00 00 00 00       	mov    $0x0,%eax
  802f6d:	a3 34 50 80 00       	mov    %eax,0x805034
  802f72:	a1 34 50 80 00       	mov    0x805034,%eax
  802f77:	85 c0                	test   %eax,%eax
  802f79:	0f 85 bf fe ff ff    	jne    802e3e <alloc_block_BF+0xc5>
  802f7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f83:	0f 85 b5 fe ff ff    	jne    802e3e <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802f89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f8d:	0f 84 26 02 00 00    	je     8031b9 <alloc_block_BF+0x440>
  802f93:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f97:	0f 85 1c 02 00 00    	jne    8031b9 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa0:	2b 45 08             	sub    0x8(%ebp),%eax
  802fa3:	83 e8 08             	sub    $0x8,%eax
  802fa6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fac:	8d 50 08             	lea    0x8(%eax),%edx
  802faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb2:	01 d0                	add    %edx,%eax
  802fb4:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	83 c0 08             	add    $0x8,%eax
  802fbd:	83 ec 04             	sub    $0x4,%esp
  802fc0:	6a 01                	push   $0x1
  802fc2:	50                   	push   %eax
  802fc3:	ff 75 f0             	pushl  -0x10(%ebp)
  802fc6:	e8 c3 f8 ff ff       	call   80288e <set_block_data>
  802fcb:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd1:	8b 40 04             	mov    0x4(%eax),%eax
  802fd4:	85 c0                	test   %eax,%eax
  802fd6:	75 68                	jne    803040 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802fd8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fdc:	75 17                	jne    802ff5 <alloc_block_BF+0x27c>
  802fde:	83 ec 04             	sub    $0x4,%esp
  802fe1:	68 dc 4b 80 00       	push   $0x804bdc
  802fe6:	68 45 01 00 00       	push   $0x145
  802feb:	68 c1 4b 80 00       	push   $0x804bc1
  802ff0:	e8 50 d8 ff ff       	call   800845 <_panic>
  802ff5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802ffb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ffe:	89 10                	mov    %edx,(%eax)
  803000:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803003:	8b 00                	mov    (%eax),%eax
  803005:	85 c0                	test   %eax,%eax
  803007:	74 0d                	je     803016 <alloc_block_BF+0x29d>
  803009:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80300e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803011:	89 50 04             	mov    %edx,0x4(%eax)
  803014:	eb 08                	jmp    80301e <alloc_block_BF+0x2a5>
  803016:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803019:	a3 30 50 80 00       	mov    %eax,0x805030
  80301e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803021:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803026:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803029:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803030:	a1 38 50 80 00       	mov    0x805038,%eax
  803035:	40                   	inc    %eax
  803036:	a3 38 50 80 00       	mov    %eax,0x805038
  80303b:	e9 dc 00 00 00       	jmp    80311c <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	85 c0                	test   %eax,%eax
  803047:	75 65                	jne    8030ae <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803049:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80304d:	75 17                	jne    803066 <alloc_block_BF+0x2ed>
  80304f:	83 ec 04             	sub    $0x4,%esp
  803052:	68 10 4c 80 00       	push   $0x804c10
  803057:	68 4a 01 00 00       	push   $0x14a
  80305c:	68 c1 4b 80 00       	push   $0x804bc1
  803061:	e8 df d7 ff ff       	call   800845 <_panic>
  803066:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80306c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80306f:	89 50 04             	mov    %edx,0x4(%eax)
  803072:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803075:	8b 40 04             	mov    0x4(%eax),%eax
  803078:	85 c0                	test   %eax,%eax
  80307a:	74 0c                	je     803088 <alloc_block_BF+0x30f>
  80307c:	a1 30 50 80 00       	mov    0x805030,%eax
  803081:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803084:	89 10                	mov    %edx,(%eax)
  803086:	eb 08                	jmp    803090 <alloc_block_BF+0x317>
  803088:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80308b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803090:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803093:	a3 30 50 80 00       	mov    %eax,0x805030
  803098:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80309b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8030a6:	40                   	inc    %eax
  8030a7:	a3 38 50 80 00       	mov    %eax,0x805038
  8030ac:	eb 6e                	jmp    80311c <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8030ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030b2:	74 06                	je     8030ba <alloc_block_BF+0x341>
  8030b4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030b8:	75 17                	jne    8030d1 <alloc_block_BF+0x358>
  8030ba:	83 ec 04             	sub    $0x4,%esp
  8030bd:	68 34 4c 80 00       	push   $0x804c34
  8030c2:	68 4f 01 00 00       	push   $0x14f
  8030c7:	68 c1 4b 80 00       	push   $0x804bc1
  8030cc:	e8 74 d7 ff ff       	call   800845 <_panic>
  8030d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d4:	8b 10                	mov    (%eax),%edx
  8030d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030d9:	89 10                	mov    %edx,(%eax)
  8030db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030de:	8b 00                	mov    (%eax),%eax
  8030e0:	85 c0                	test   %eax,%eax
  8030e2:	74 0b                	je     8030ef <alloc_block_BF+0x376>
  8030e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e7:	8b 00                	mov    (%eax),%eax
  8030e9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030ec:	89 50 04             	mov    %edx,0x4(%eax)
  8030ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030f5:	89 10                	mov    %edx,(%eax)
  8030f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030fd:	89 50 04             	mov    %edx,0x4(%eax)
  803100:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803103:	8b 00                	mov    (%eax),%eax
  803105:	85 c0                	test   %eax,%eax
  803107:	75 08                	jne    803111 <alloc_block_BF+0x398>
  803109:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80310c:	a3 30 50 80 00       	mov    %eax,0x805030
  803111:	a1 38 50 80 00       	mov    0x805038,%eax
  803116:	40                   	inc    %eax
  803117:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80311c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803120:	75 17                	jne    803139 <alloc_block_BF+0x3c0>
  803122:	83 ec 04             	sub    $0x4,%esp
  803125:	68 a3 4b 80 00       	push   $0x804ba3
  80312a:	68 51 01 00 00       	push   $0x151
  80312f:	68 c1 4b 80 00       	push   $0x804bc1
  803134:	e8 0c d7 ff ff       	call   800845 <_panic>
  803139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313c:	8b 00                	mov    (%eax),%eax
  80313e:	85 c0                	test   %eax,%eax
  803140:	74 10                	je     803152 <alloc_block_BF+0x3d9>
  803142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803145:	8b 00                	mov    (%eax),%eax
  803147:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80314a:	8b 52 04             	mov    0x4(%edx),%edx
  80314d:	89 50 04             	mov    %edx,0x4(%eax)
  803150:	eb 0b                	jmp    80315d <alloc_block_BF+0x3e4>
  803152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803155:	8b 40 04             	mov    0x4(%eax),%eax
  803158:	a3 30 50 80 00       	mov    %eax,0x805030
  80315d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803160:	8b 40 04             	mov    0x4(%eax),%eax
  803163:	85 c0                	test   %eax,%eax
  803165:	74 0f                	je     803176 <alloc_block_BF+0x3fd>
  803167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316a:	8b 40 04             	mov    0x4(%eax),%eax
  80316d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803170:	8b 12                	mov    (%edx),%edx
  803172:	89 10                	mov    %edx,(%eax)
  803174:	eb 0a                	jmp    803180 <alloc_block_BF+0x407>
  803176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803179:	8b 00                	mov    (%eax),%eax
  80317b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803183:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803189:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803193:	a1 38 50 80 00       	mov    0x805038,%eax
  803198:	48                   	dec    %eax
  803199:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  80319e:	83 ec 04             	sub    $0x4,%esp
  8031a1:	6a 00                	push   $0x0
  8031a3:	ff 75 d0             	pushl  -0x30(%ebp)
  8031a6:	ff 75 cc             	pushl  -0x34(%ebp)
  8031a9:	e8 e0 f6 ff ff       	call   80288e <set_block_data>
  8031ae:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8031b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b4:	e9 a3 01 00 00       	jmp    80335c <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8031b9:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8031bd:	0f 85 9d 00 00 00    	jne    803260 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8031c3:	83 ec 04             	sub    $0x4,%esp
  8031c6:	6a 01                	push   $0x1
  8031c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8031cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8031ce:	e8 bb f6 ff ff       	call   80288e <set_block_data>
  8031d3:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8031d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031da:	75 17                	jne    8031f3 <alloc_block_BF+0x47a>
  8031dc:	83 ec 04             	sub    $0x4,%esp
  8031df:	68 a3 4b 80 00       	push   $0x804ba3
  8031e4:	68 58 01 00 00       	push   $0x158
  8031e9:	68 c1 4b 80 00       	push   $0x804bc1
  8031ee:	e8 52 d6 ff ff       	call   800845 <_panic>
  8031f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f6:	8b 00                	mov    (%eax),%eax
  8031f8:	85 c0                	test   %eax,%eax
  8031fa:	74 10                	je     80320c <alloc_block_BF+0x493>
  8031fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ff:	8b 00                	mov    (%eax),%eax
  803201:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803204:	8b 52 04             	mov    0x4(%edx),%edx
  803207:	89 50 04             	mov    %edx,0x4(%eax)
  80320a:	eb 0b                	jmp    803217 <alloc_block_BF+0x49e>
  80320c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320f:	8b 40 04             	mov    0x4(%eax),%eax
  803212:	a3 30 50 80 00       	mov    %eax,0x805030
  803217:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321a:	8b 40 04             	mov    0x4(%eax),%eax
  80321d:	85 c0                	test   %eax,%eax
  80321f:	74 0f                	je     803230 <alloc_block_BF+0x4b7>
  803221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803224:	8b 40 04             	mov    0x4(%eax),%eax
  803227:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80322a:	8b 12                	mov    (%edx),%edx
  80322c:	89 10                	mov    %edx,(%eax)
  80322e:	eb 0a                	jmp    80323a <alloc_block_BF+0x4c1>
  803230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803233:	8b 00                	mov    (%eax),%eax
  803235:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80323a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803246:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324d:	a1 38 50 80 00       	mov    0x805038,%eax
  803252:	48                   	dec    %eax
  803253:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  803258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325b:	e9 fc 00 00 00       	jmp    80335c <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803260:	8b 45 08             	mov    0x8(%ebp),%eax
  803263:	83 c0 08             	add    $0x8,%eax
  803266:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803269:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803270:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803273:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803276:	01 d0                	add    %edx,%eax
  803278:	48                   	dec    %eax
  803279:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80327c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80327f:	ba 00 00 00 00       	mov    $0x0,%edx
  803284:	f7 75 c4             	divl   -0x3c(%ebp)
  803287:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80328a:	29 d0                	sub    %edx,%eax
  80328c:	c1 e8 0c             	shr    $0xc,%eax
  80328f:	83 ec 0c             	sub    $0xc,%esp
  803292:	50                   	push   %eax
  803293:	e8 0c e8 ff ff       	call   801aa4 <sbrk>
  803298:	83 c4 10             	add    $0x10,%esp
  80329b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80329e:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8032a2:	75 0a                	jne    8032ae <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8032a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a9:	e9 ae 00 00 00       	jmp    80335c <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8032ae:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8032b5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032b8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8032bb:	01 d0                	add    %edx,%eax
  8032bd:	48                   	dec    %eax
  8032be:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8032c1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8032c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8032c9:	f7 75 b8             	divl   -0x48(%ebp)
  8032cc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8032cf:	29 d0                	sub    %edx,%eax
  8032d1:	8d 50 fc             	lea    -0x4(%eax),%edx
  8032d4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8032d7:	01 d0                	add    %edx,%eax
  8032d9:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  8032de:	a1 40 50 80 00       	mov    0x805040,%eax
  8032e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8032e9:	83 ec 0c             	sub    $0xc,%esp
  8032ec:	68 68 4c 80 00       	push   $0x804c68
  8032f1:	e8 0c d8 ff ff       	call   800b02 <cprintf>
  8032f6:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8032f9:	83 ec 08             	sub    $0x8,%esp
  8032fc:	ff 75 bc             	pushl  -0x44(%ebp)
  8032ff:	68 6d 4c 80 00       	push   $0x804c6d
  803304:	e8 f9 d7 ff ff       	call   800b02 <cprintf>
  803309:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80330c:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803313:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803316:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803319:	01 d0                	add    %edx,%eax
  80331b:	48                   	dec    %eax
  80331c:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80331f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803322:	ba 00 00 00 00       	mov    $0x0,%edx
  803327:	f7 75 b0             	divl   -0x50(%ebp)
  80332a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80332d:	29 d0                	sub    %edx,%eax
  80332f:	83 ec 04             	sub    $0x4,%esp
  803332:	6a 01                	push   $0x1
  803334:	50                   	push   %eax
  803335:	ff 75 bc             	pushl  -0x44(%ebp)
  803338:	e8 51 f5 ff ff       	call   80288e <set_block_data>
  80333d:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803340:	83 ec 0c             	sub    $0xc,%esp
  803343:	ff 75 bc             	pushl  -0x44(%ebp)
  803346:	e8 36 04 00 00       	call   803781 <free_block>
  80334b:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80334e:	83 ec 0c             	sub    $0xc,%esp
  803351:	ff 75 08             	pushl  0x8(%ebp)
  803354:	e8 20 fa ff ff       	call   802d79 <alloc_block_BF>
  803359:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80335c:	c9                   	leave  
  80335d:	c3                   	ret    

0080335e <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80335e:	55                   	push   %ebp
  80335f:	89 e5                	mov    %esp,%ebp
  803361:	53                   	push   %ebx
  803362:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803365:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80336c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803373:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803377:	74 1e                	je     803397 <merging+0x39>
  803379:	ff 75 08             	pushl  0x8(%ebp)
  80337c:	e8 bc f1 ff ff       	call   80253d <get_block_size>
  803381:	83 c4 04             	add    $0x4,%esp
  803384:	89 c2                	mov    %eax,%edx
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	01 d0                	add    %edx,%eax
  80338b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80338e:	75 07                	jne    803397 <merging+0x39>
		prev_is_free = 1;
  803390:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803397:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80339b:	74 1e                	je     8033bb <merging+0x5d>
  80339d:	ff 75 10             	pushl  0x10(%ebp)
  8033a0:	e8 98 f1 ff ff       	call   80253d <get_block_size>
  8033a5:	83 c4 04             	add    $0x4,%esp
  8033a8:	89 c2                	mov    %eax,%edx
  8033aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8033ad:	01 d0                	add    %edx,%eax
  8033af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033b2:	75 07                	jne    8033bb <merging+0x5d>
		next_is_free = 1;
  8033b4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8033bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033bf:	0f 84 cc 00 00 00    	je     803491 <merging+0x133>
  8033c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033c9:	0f 84 c2 00 00 00    	je     803491 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8033cf:	ff 75 08             	pushl  0x8(%ebp)
  8033d2:	e8 66 f1 ff ff       	call   80253d <get_block_size>
  8033d7:	83 c4 04             	add    $0x4,%esp
  8033da:	89 c3                	mov    %eax,%ebx
  8033dc:	ff 75 10             	pushl  0x10(%ebp)
  8033df:	e8 59 f1 ff ff       	call   80253d <get_block_size>
  8033e4:	83 c4 04             	add    $0x4,%esp
  8033e7:	01 c3                	add    %eax,%ebx
  8033e9:	ff 75 0c             	pushl  0xc(%ebp)
  8033ec:	e8 4c f1 ff ff       	call   80253d <get_block_size>
  8033f1:	83 c4 04             	add    $0x4,%esp
  8033f4:	01 d8                	add    %ebx,%eax
  8033f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8033f9:	6a 00                	push   $0x0
  8033fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8033fe:	ff 75 08             	pushl  0x8(%ebp)
  803401:	e8 88 f4 ff ff       	call   80288e <set_block_data>
  803406:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803409:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80340d:	75 17                	jne    803426 <merging+0xc8>
  80340f:	83 ec 04             	sub    $0x4,%esp
  803412:	68 a3 4b 80 00       	push   $0x804ba3
  803417:	68 7d 01 00 00       	push   $0x17d
  80341c:	68 c1 4b 80 00       	push   $0x804bc1
  803421:	e8 1f d4 ff ff       	call   800845 <_panic>
  803426:	8b 45 0c             	mov    0xc(%ebp),%eax
  803429:	8b 00                	mov    (%eax),%eax
  80342b:	85 c0                	test   %eax,%eax
  80342d:	74 10                	je     80343f <merging+0xe1>
  80342f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803432:	8b 00                	mov    (%eax),%eax
  803434:	8b 55 0c             	mov    0xc(%ebp),%edx
  803437:	8b 52 04             	mov    0x4(%edx),%edx
  80343a:	89 50 04             	mov    %edx,0x4(%eax)
  80343d:	eb 0b                	jmp    80344a <merging+0xec>
  80343f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803442:	8b 40 04             	mov    0x4(%eax),%eax
  803445:	a3 30 50 80 00       	mov    %eax,0x805030
  80344a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344d:	8b 40 04             	mov    0x4(%eax),%eax
  803450:	85 c0                	test   %eax,%eax
  803452:	74 0f                	je     803463 <merging+0x105>
  803454:	8b 45 0c             	mov    0xc(%ebp),%eax
  803457:	8b 40 04             	mov    0x4(%eax),%eax
  80345a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80345d:	8b 12                	mov    (%edx),%edx
  80345f:	89 10                	mov    %edx,(%eax)
  803461:	eb 0a                	jmp    80346d <merging+0x10f>
  803463:	8b 45 0c             	mov    0xc(%ebp),%eax
  803466:	8b 00                	mov    (%eax),%eax
  803468:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80346d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803476:	8b 45 0c             	mov    0xc(%ebp),%eax
  803479:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803480:	a1 38 50 80 00       	mov    0x805038,%eax
  803485:	48                   	dec    %eax
  803486:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80348b:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80348c:	e9 ea 02 00 00       	jmp    80377b <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803491:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803495:	74 3b                	je     8034d2 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803497:	83 ec 0c             	sub    $0xc,%esp
  80349a:	ff 75 08             	pushl  0x8(%ebp)
  80349d:	e8 9b f0 ff ff       	call   80253d <get_block_size>
  8034a2:	83 c4 10             	add    $0x10,%esp
  8034a5:	89 c3                	mov    %eax,%ebx
  8034a7:	83 ec 0c             	sub    $0xc,%esp
  8034aa:	ff 75 10             	pushl  0x10(%ebp)
  8034ad:	e8 8b f0 ff ff       	call   80253d <get_block_size>
  8034b2:	83 c4 10             	add    $0x10,%esp
  8034b5:	01 d8                	add    %ebx,%eax
  8034b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8034ba:	83 ec 04             	sub    $0x4,%esp
  8034bd:	6a 00                	push   $0x0
  8034bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8034c2:	ff 75 08             	pushl  0x8(%ebp)
  8034c5:	e8 c4 f3 ff ff       	call   80288e <set_block_data>
  8034ca:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034cd:	e9 a9 02 00 00       	jmp    80377b <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8034d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034d6:	0f 84 2d 01 00 00    	je     803609 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8034dc:	83 ec 0c             	sub    $0xc,%esp
  8034df:	ff 75 10             	pushl  0x10(%ebp)
  8034e2:	e8 56 f0 ff ff       	call   80253d <get_block_size>
  8034e7:	83 c4 10             	add    $0x10,%esp
  8034ea:	89 c3                	mov    %eax,%ebx
  8034ec:	83 ec 0c             	sub    $0xc,%esp
  8034ef:	ff 75 0c             	pushl  0xc(%ebp)
  8034f2:	e8 46 f0 ff ff       	call   80253d <get_block_size>
  8034f7:	83 c4 10             	add    $0x10,%esp
  8034fa:	01 d8                	add    %ebx,%eax
  8034fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8034ff:	83 ec 04             	sub    $0x4,%esp
  803502:	6a 00                	push   $0x0
  803504:	ff 75 e4             	pushl  -0x1c(%ebp)
  803507:	ff 75 10             	pushl  0x10(%ebp)
  80350a:	e8 7f f3 ff ff       	call   80288e <set_block_data>
  80350f:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803512:	8b 45 10             	mov    0x10(%ebp),%eax
  803515:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803518:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80351c:	74 06                	je     803524 <merging+0x1c6>
  80351e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803522:	75 17                	jne    80353b <merging+0x1dd>
  803524:	83 ec 04             	sub    $0x4,%esp
  803527:	68 7c 4c 80 00       	push   $0x804c7c
  80352c:	68 8d 01 00 00       	push   $0x18d
  803531:	68 c1 4b 80 00       	push   $0x804bc1
  803536:	e8 0a d3 ff ff       	call   800845 <_panic>
  80353b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80353e:	8b 50 04             	mov    0x4(%eax),%edx
  803541:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803544:	89 50 04             	mov    %edx,0x4(%eax)
  803547:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80354a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80354d:	89 10                	mov    %edx,(%eax)
  80354f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803552:	8b 40 04             	mov    0x4(%eax),%eax
  803555:	85 c0                	test   %eax,%eax
  803557:	74 0d                	je     803566 <merging+0x208>
  803559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80355c:	8b 40 04             	mov    0x4(%eax),%eax
  80355f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803562:	89 10                	mov    %edx,(%eax)
  803564:	eb 08                	jmp    80356e <merging+0x210>
  803566:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803569:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80356e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803571:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803574:	89 50 04             	mov    %edx,0x4(%eax)
  803577:	a1 38 50 80 00       	mov    0x805038,%eax
  80357c:	40                   	inc    %eax
  80357d:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803582:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803586:	75 17                	jne    80359f <merging+0x241>
  803588:	83 ec 04             	sub    $0x4,%esp
  80358b:	68 a3 4b 80 00       	push   $0x804ba3
  803590:	68 8e 01 00 00       	push   $0x18e
  803595:	68 c1 4b 80 00       	push   $0x804bc1
  80359a:	e8 a6 d2 ff ff       	call   800845 <_panic>
  80359f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035a2:	8b 00                	mov    (%eax),%eax
  8035a4:	85 c0                	test   %eax,%eax
  8035a6:	74 10                	je     8035b8 <merging+0x25a>
  8035a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ab:	8b 00                	mov    (%eax),%eax
  8035ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035b0:	8b 52 04             	mov    0x4(%edx),%edx
  8035b3:	89 50 04             	mov    %edx,0x4(%eax)
  8035b6:	eb 0b                	jmp    8035c3 <merging+0x265>
  8035b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035bb:	8b 40 04             	mov    0x4(%eax),%eax
  8035be:	a3 30 50 80 00       	mov    %eax,0x805030
  8035c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c6:	8b 40 04             	mov    0x4(%eax),%eax
  8035c9:	85 c0                	test   %eax,%eax
  8035cb:	74 0f                	je     8035dc <merging+0x27e>
  8035cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d0:	8b 40 04             	mov    0x4(%eax),%eax
  8035d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035d6:	8b 12                	mov    (%edx),%edx
  8035d8:	89 10                	mov    %edx,(%eax)
  8035da:	eb 0a                	jmp    8035e6 <merging+0x288>
  8035dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035df:	8b 00                	mov    (%eax),%eax
  8035e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8035fe:	48                   	dec    %eax
  8035ff:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803604:	e9 72 01 00 00       	jmp    80377b <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803609:	8b 45 10             	mov    0x10(%ebp),%eax
  80360c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80360f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803613:	74 79                	je     80368e <merging+0x330>
  803615:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803619:	74 73                	je     80368e <merging+0x330>
  80361b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80361f:	74 06                	je     803627 <merging+0x2c9>
  803621:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803625:	75 17                	jne    80363e <merging+0x2e0>
  803627:	83 ec 04             	sub    $0x4,%esp
  80362a:	68 34 4c 80 00       	push   $0x804c34
  80362f:	68 94 01 00 00       	push   $0x194
  803634:	68 c1 4b 80 00       	push   $0x804bc1
  803639:	e8 07 d2 ff ff       	call   800845 <_panic>
  80363e:	8b 45 08             	mov    0x8(%ebp),%eax
  803641:	8b 10                	mov    (%eax),%edx
  803643:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803646:	89 10                	mov    %edx,(%eax)
  803648:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80364b:	8b 00                	mov    (%eax),%eax
  80364d:	85 c0                	test   %eax,%eax
  80364f:	74 0b                	je     80365c <merging+0x2fe>
  803651:	8b 45 08             	mov    0x8(%ebp),%eax
  803654:	8b 00                	mov    (%eax),%eax
  803656:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803659:	89 50 04             	mov    %edx,0x4(%eax)
  80365c:	8b 45 08             	mov    0x8(%ebp),%eax
  80365f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803662:	89 10                	mov    %edx,(%eax)
  803664:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803667:	8b 55 08             	mov    0x8(%ebp),%edx
  80366a:	89 50 04             	mov    %edx,0x4(%eax)
  80366d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803670:	8b 00                	mov    (%eax),%eax
  803672:	85 c0                	test   %eax,%eax
  803674:	75 08                	jne    80367e <merging+0x320>
  803676:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803679:	a3 30 50 80 00       	mov    %eax,0x805030
  80367e:	a1 38 50 80 00       	mov    0x805038,%eax
  803683:	40                   	inc    %eax
  803684:	a3 38 50 80 00       	mov    %eax,0x805038
  803689:	e9 ce 00 00 00       	jmp    80375c <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80368e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803692:	74 65                	je     8036f9 <merging+0x39b>
  803694:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803698:	75 17                	jne    8036b1 <merging+0x353>
  80369a:	83 ec 04             	sub    $0x4,%esp
  80369d:	68 10 4c 80 00       	push   $0x804c10
  8036a2:	68 95 01 00 00       	push   $0x195
  8036a7:	68 c1 4b 80 00       	push   $0x804bc1
  8036ac:	e8 94 d1 ff ff       	call   800845 <_panic>
  8036b1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036ba:	89 50 04             	mov    %edx,0x4(%eax)
  8036bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036c0:	8b 40 04             	mov    0x4(%eax),%eax
  8036c3:	85 c0                	test   %eax,%eax
  8036c5:	74 0c                	je     8036d3 <merging+0x375>
  8036c7:	a1 30 50 80 00       	mov    0x805030,%eax
  8036cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036cf:	89 10                	mov    %edx,(%eax)
  8036d1:	eb 08                	jmp    8036db <merging+0x37d>
  8036d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036d6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036de:	a3 30 50 80 00       	mov    %eax,0x805030
  8036e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036ec:	a1 38 50 80 00       	mov    0x805038,%eax
  8036f1:	40                   	inc    %eax
  8036f2:	a3 38 50 80 00       	mov    %eax,0x805038
  8036f7:	eb 63                	jmp    80375c <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8036f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036fd:	75 17                	jne    803716 <merging+0x3b8>
  8036ff:	83 ec 04             	sub    $0x4,%esp
  803702:	68 dc 4b 80 00       	push   $0x804bdc
  803707:	68 98 01 00 00       	push   $0x198
  80370c:	68 c1 4b 80 00       	push   $0x804bc1
  803711:	e8 2f d1 ff ff       	call   800845 <_panic>
  803716:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80371c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80371f:	89 10                	mov    %edx,(%eax)
  803721:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803724:	8b 00                	mov    (%eax),%eax
  803726:	85 c0                	test   %eax,%eax
  803728:	74 0d                	je     803737 <merging+0x3d9>
  80372a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80372f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803732:	89 50 04             	mov    %edx,0x4(%eax)
  803735:	eb 08                	jmp    80373f <merging+0x3e1>
  803737:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80373a:	a3 30 50 80 00       	mov    %eax,0x805030
  80373f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803742:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803747:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80374a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803751:	a1 38 50 80 00       	mov    0x805038,%eax
  803756:	40                   	inc    %eax
  803757:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80375c:	83 ec 0c             	sub    $0xc,%esp
  80375f:	ff 75 10             	pushl  0x10(%ebp)
  803762:	e8 d6 ed ff ff       	call   80253d <get_block_size>
  803767:	83 c4 10             	add    $0x10,%esp
  80376a:	83 ec 04             	sub    $0x4,%esp
  80376d:	6a 00                	push   $0x0
  80376f:	50                   	push   %eax
  803770:	ff 75 10             	pushl  0x10(%ebp)
  803773:	e8 16 f1 ff ff       	call   80288e <set_block_data>
  803778:	83 c4 10             	add    $0x10,%esp
	}
}
  80377b:	90                   	nop
  80377c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80377f:	c9                   	leave  
  803780:	c3                   	ret    

00803781 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803781:	55                   	push   %ebp
  803782:	89 e5                	mov    %esp,%ebp
  803784:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803787:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80378c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80378f:	a1 30 50 80 00       	mov    0x805030,%eax
  803794:	3b 45 08             	cmp    0x8(%ebp),%eax
  803797:	73 1b                	jae    8037b4 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803799:	a1 30 50 80 00       	mov    0x805030,%eax
  80379e:	83 ec 04             	sub    $0x4,%esp
  8037a1:	ff 75 08             	pushl  0x8(%ebp)
  8037a4:	6a 00                	push   $0x0
  8037a6:	50                   	push   %eax
  8037a7:	e8 b2 fb ff ff       	call   80335e <merging>
  8037ac:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037af:	e9 8b 00 00 00       	jmp    80383f <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8037b4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037bc:	76 18                	jbe    8037d6 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8037be:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037c3:	83 ec 04             	sub    $0x4,%esp
  8037c6:	ff 75 08             	pushl  0x8(%ebp)
  8037c9:	50                   	push   %eax
  8037ca:	6a 00                	push   $0x0
  8037cc:	e8 8d fb ff ff       	call   80335e <merging>
  8037d1:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037d4:	eb 69                	jmp    80383f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8037d6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037de:	eb 39                	jmp    803819 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8037e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037e6:	73 29                	jae    803811 <free_block+0x90>
  8037e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037eb:	8b 00                	mov    (%eax),%eax
  8037ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037f0:	76 1f                	jbe    803811 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8037f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f5:	8b 00                	mov    (%eax),%eax
  8037f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8037fa:	83 ec 04             	sub    $0x4,%esp
  8037fd:	ff 75 08             	pushl  0x8(%ebp)
  803800:	ff 75 f0             	pushl  -0x10(%ebp)
  803803:	ff 75 f4             	pushl  -0xc(%ebp)
  803806:	e8 53 fb ff ff       	call   80335e <merging>
  80380b:	83 c4 10             	add    $0x10,%esp
			break;
  80380e:	90                   	nop
		}
	}
}
  80380f:	eb 2e                	jmp    80383f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803811:	a1 34 50 80 00       	mov    0x805034,%eax
  803816:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803819:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80381d:	74 07                	je     803826 <free_block+0xa5>
  80381f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803822:	8b 00                	mov    (%eax),%eax
  803824:	eb 05                	jmp    80382b <free_block+0xaa>
  803826:	b8 00 00 00 00       	mov    $0x0,%eax
  80382b:	a3 34 50 80 00       	mov    %eax,0x805034
  803830:	a1 34 50 80 00       	mov    0x805034,%eax
  803835:	85 c0                	test   %eax,%eax
  803837:	75 a7                	jne    8037e0 <free_block+0x5f>
  803839:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80383d:	75 a1                	jne    8037e0 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80383f:	90                   	nop
  803840:	c9                   	leave  
  803841:	c3                   	ret    

00803842 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803842:	55                   	push   %ebp
  803843:	89 e5                	mov    %esp,%ebp
  803845:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803848:	ff 75 08             	pushl  0x8(%ebp)
  80384b:	e8 ed ec ff ff       	call   80253d <get_block_size>
  803850:	83 c4 04             	add    $0x4,%esp
  803853:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803856:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80385d:	eb 17                	jmp    803876 <copy_data+0x34>
  80385f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803862:	8b 45 0c             	mov    0xc(%ebp),%eax
  803865:	01 c2                	add    %eax,%edx
  803867:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80386a:	8b 45 08             	mov    0x8(%ebp),%eax
  80386d:	01 c8                	add    %ecx,%eax
  80386f:	8a 00                	mov    (%eax),%al
  803871:	88 02                	mov    %al,(%edx)
  803873:	ff 45 fc             	incl   -0x4(%ebp)
  803876:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803879:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80387c:	72 e1                	jb     80385f <copy_data+0x1d>
}
  80387e:	90                   	nop
  80387f:	c9                   	leave  
  803880:	c3                   	ret    

00803881 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803881:	55                   	push   %ebp
  803882:	89 e5                	mov    %esp,%ebp
  803884:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803887:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80388b:	75 23                	jne    8038b0 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80388d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803891:	74 13                	je     8038a6 <realloc_block_FF+0x25>
  803893:	83 ec 0c             	sub    $0xc,%esp
  803896:	ff 75 0c             	pushl  0xc(%ebp)
  803899:	e8 1f f0 ff ff       	call   8028bd <alloc_block_FF>
  80389e:	83 c4 10             	add    $0x10,%esp
  8038a1:	e9 f4 06 00 00       	jmp    803f9a <realloc_block_FF+0x719>
		return NULL;
  8038a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ab:	e9 ea 06 00 00       	jmp    803f9a <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8038b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038b4:	75 18                	jne    8038ce <realloc_block_FF+0x4d>
	{
		free_block(va);
  8038b6:	83 ec 0c             	sub    $0xc,%esp
  8038b9:	ff 75 08             	pushl  0x8(%ebp)
  8038bc:	e8 c0 fe ff ff       	call   803781 <free_block>
  8038c1:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8038c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8038c9:	e9 cc 06 00 00       	jmp    803f9a <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8038ce:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8038d2:	77 07                	ja     8038db <realloc_block_FF+0x5a>
  8038d4:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8038db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038de:	83 e0 01             	and    $0x1,%eax
  8038e1:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8038e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e7:	83 c0 08             	add    $0x8,%eax
  8038ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8038ed:	83 ec 0c             	sub    $0xc,%esp
  8038f0:	ff 75 08             	pushl  0x8(%ebp)
  8038f3:	e8 45 ec ff ff       	call   80253d <get_block_size>
  8038f8:	83 c4 10             	add    $0x10,%esp
  8038fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8038fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803901:	83 e8 08             	sub    $0x8,%eax
  803904:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803907:	8b 45 08             	mov    0x8(%ebp),%eax
  80390a:	83 e8 04             	sub    $0x4,%eax
  80390d:	8b 00                	mov    (%eax),%eax
  80390f:	83 e0 fe             	and    $0xfffffffe,%eax
  803912:	89 c2                	mov    %eax,%edx
  803914:	8b 45 08             	mov    0x8(%ebp),%eax
  803917:	01 d0                	add    %edx,%eax
  803919:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80391c:	83 ec 0c             	sub    $0xc,%esp
  80391f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803922:	e8 16 ec ff ff       	call   80253d <get_block_size>
  803927:	83 c4 10             	add    $0x10,%esp
  80392a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80392d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803930:	83 e8 08             	sub    $0x8,%eax
  803933:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803936:	8b 45 0c             	mov    0xc(%ebp),%eax
  803939:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80393c:	75 08                	jne    803946 <realloc_block_FF+0xc5>
	{
		 return va;
  80393e:	8b 45 08             	mov    0x8(%ebp),%eax
  803941:	e9 54 06 00 00       	jmp    803f9a <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803946:	8b 45 0c             	mov    0xc(%ebp),%eax
  803949:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80394c:	0f 83 e5 03 00 00    	jae    803d37 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803952:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803955:	2b 45 0c             	sub    0xc(%ebp),%eax
  803958:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80395b:	83 ec 0c             	sub    $0xc,%esp
  80395e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803961:	e8 f0 eb ff ff       	call   802556 <is_free_block>
  803966:	83 c4 10             	add    $0x10,%esp
  803969:	84 c0                	test   %al,%al
  80396b:	0f 84 3b 01 00 00    	je     803aac <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803971:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803974:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803977:	01 d0                	add    %edx,%eax
  803979:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80397c:	83 ec 04             	sub    $0x4,%esp
  80397f:	6a 01                	push   $0x1
  803981:	ff 75 f0             	pushl  -0x10(%ebp)
  803984:	ff 75 08             	pushl  0x8(%ebp)
  803987:	e8 02 ef ff ff       	call   80288e <set_block_data>
  80398c:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80398f:	8b 45 08             	mov    0x8(%ebp),%eax
  803992:	83 e8 04             	sub    $0x4,%eax
  803995:	8b 00                	mov    (%eax),%eax
  803997:	83 e0 fe             	and    $0xfffffffe,%eax
  80399a:	89 c2                	mov    %eax,%edx
  80399c:	8b 45 08             	mov    0x8(%ebp),%eax
  80399f:	01 d0                	add    %edx,%eax
  8039a1:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8039a4:	83 ec 04             	sub    $0x4,%esp
  8039a7:	6a 00                	push   $0x0
  8039a9:	ff 75 cc             	pushl  -0x34(%ebp)
  8039ac:	ff 75 c8             	pushl  -0x38(%ebp)
  8039af:	e8 da ee ff ff       	call   80288e <set_block_data>
  8039b4:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8039b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039bb:	74 06                	je     8039c3 <realloc_block_FF+0x142>
  8039bd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8039c1:	75 17                	jne    8039da <realloc_block_FF+0x159>
  8039c3:	83 ec 04             	sub    $0x4,%esp
  8039c6:	68 34 4c 80 00       	push   $0x804c34
  8039cb:	68 f6 01 00 00       	push   $0x1f6
  8039d0:	68 c1 4b 80 00       	push   $0x804bc1
  8039d5:	e8 6b ce ff ff       	call   800845 <_panic>
  8039da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039dd:	8b 10                	mov    (%eax),%edx
  8039df:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039e2:	89 10                	mov    %edx,(%eax)
  8039e4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039e7:	8b 00                	mov    (%eax),%eax
  8039e9:	85 c0                	test   %eax,%eax
  8039eb:	74 0b                	je     8039f8 <realloc_block_FF+0x177>
  8039ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f0:	8b 00                	mov    (%eax),%eax
  8039f2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039f5:	89 50 04             	mov    %edx,0x4(%eax)
  8039f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039fb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039fe:	89 10                	mov    %edx,(%eax)
  803a00:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a03:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a06:	89 50 04             	mov    %edx,0x4(%eax)
  803a09:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a0c:	8b 00                	mov    (%eax),%eax
  803a0e:	85 c0                	test   %eax,%eax
  803a10:	75 08                	jne    803a1a <realloc_block_FF+0x199>
  803a12:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a15:	a3 30 50 80 00       	mov    %eax,0x805030
  803a1a:	a1 38 50 80 00       	mov    0x805038,%eax
  803a1f:	40                   	inc    %eax
  803a20:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a29:	75 17                	jne    803a42 <realloc_block_FF+0x1c1>
  803a2b:	83 ec 04             	sub    $0x4,%esp
  803a2e:	68 a3 4b 80 00       	push   $0x804ba3
  803a33:	68 f7 01 00 00       	push   $0x1f7
  803a38:	68 c1 4b 80 00       	push   $0x804bc1
  803a3d:	e8 03 ce ff ff       	call   800845 <_panic>
  803a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a45:	8b 00                	mov    (%eax),%eax
  803a47:	85 c0                	test   %eax,%eax
  803a49:	74 10                	je     803a5b <realloc_block_FF+0x1da>
  803a4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4e:	8b 00                	mov    (%eax),%eax
  803a50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a53:	8b 52 04             	mov    0x4(%edx),%edx
  803a56:	89 50 04             	mov    %edx,0x4(%eax)
  803a59:	eb 0b                	jmp    803a66 <realloc_block_FF+0x1e5>
  803a5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5e:	8b 40 04             	mov    0x4(%eax),%eax
  803a61:	a3 30 50 80 00       	mov    %eax,0x805030
  803a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a69:	8b 40 04             	mov    0x4(%eax),%eax
  803a6c:	85 c0                	test   %eax,%eax
  803a6e:	74 0f                	je     803a7f <realloc_block_FF+0x1fe>
  803a70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a73:	8b 40 04             	mov    0x4(%eax),%eax
  803a76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a79:	8b 12                	mov    (%edx),%edx
  803a7b:	89 10                	mov    %edx,(%eax)
  803a7d:	eb 0a                	jmp    803a89 <realloc_block_FF+0x208>
  803a7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a82:	8b 00                	mov    (%eax),%eax
  803a84:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a9c:	a1 38 50 80 00       	mov    0x805038,%eax
  803aa1:	48                   	dec    %eax
  803aa2:	a3 38 50 80 00       	mov    %eax,0x805038
  803aa7:	e9 83 02 00 00       	jmp    803d2f <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803aac:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803ab0:	0f 86 69 02 00 00    	jbe    803d1f <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803ab6:	83 ec 04             	sub    $0x4,%esp
  803ab9:	6a 01                	push   $0x1
  803abb:	ff 75 f0             	pushl  -0x10(%ebp)
  803abe:	ff 75 08             	pushl  0x8(%ebp)
  803ac1:	e8 c8 ed ff ff       	call   80288e <set_block_data>
  803ac6:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  803acc:	83 e8 04             	sub    $0x4,%eax
  803acf:	8b 00                	mov    (%eax),%eax
  803ad1:	83 e0 fe             	and    $0xfffffffe,%eax
  803ad4:	89 c2                	mov    %eax,%edx
  803ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad9:	01 d0                	add    %edx,%eax
  803adb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803ade:	a1 38 50 80 00       	mov    0x805038,%eax
  803ae3:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803ae6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803aea:	75 68                	jne    803b54 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803aec:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803af0:	75 17                	jne    803b09 <realloc_block_FF+0x288>
  803af2:	83 ec 04             	sub    $0x4,%esp
  803af5:	68 dc 4b 80 00       	push   $0x804bdc
  803afa:	68 06 02 00 00       	push   $0x206
  803aff:	68 c1 4b 80 00       	push   $0x804bc1
  803b04:	e8 3c cd ff ff       	call   800845 <_panic>
  803b09:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803b0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b12:	89 10                	mov    %edx,(%eax)
  803b14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b17:	8b 00                	mov    (%eax),%eax
  803b19:	85 c0                	test   %eax,%eax
  803b1b:	74 0d                	je     803b2a <realloc_block_FF+0x2a9>
  803b1d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803b22:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b25:	89 50 04             	mov    %edx,0x4(%eax)
  803b28:	eb 08                	jmp    803b32 <realloc_block_FF+0x2b1>
  803b2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b2d:	a3 30 50 80 00       	mov    %eax,0x805030
  803b32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b35:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803b3a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b44:	a1 38 50 80 00       	mov    0x805038,%eax
  803b49:	40                   	inc    %eax
  803b4a:	a3 38 50 80 00       	mov    %eax,0x805038
  803b4f:	e9 b0 01 00 00       	jmp    803d04 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803b54:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803b59:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b5c:	76 68                	jbe    803bc6 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b5e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b62:	75 17                	jne    803b7b <realloc_block_FF+0x2fa>
  803b64:	83 ec 04             	sub    $0x4,%esp
  803b67:	68 dc 4b 80 00       	push   $0x804bdc
  803b6c:	68 0b 02 00 00       	push   $0x20b
  803b71:	68 c1 4b 80 00       	push   $0x804bc1
  803b76:	e8 ca cc ff ff       	call   800845 <_panic>
  803b7b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803b81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b84:	89 10                	mov    %edx,(%eax)
  803b86:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b89:	8b 00                	mov    (%eax),%eax
  803b8b:	85 c0                	test   %eax,%eax
  803b8d:	74 0d                	je     803b9c <realloc_block_FF+0x31b>
  803b8f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803b94:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b97:	89 50 04             	mov    %edx,0x4(%eax)
  803b9a:	eb 08                	jmp    803ba4 <realloc_block_FF+0x323>
  803b9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b9f:	a3 30 50 80 00       	mov    %eax,0x805030
  803ba4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ba7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803bac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803baf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bb6:	a1 38 50 80 00       	mov    0x805038,%eax
  803bbb:	40                   	inc    %eax
  803bbc:	a3 38 50 80 00       	mov    %eax,0x805038
  803bc1:	e9 3e 01 00 00       	jmp    803d04 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803bc6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803bcb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bce:	73 68                	jae    803c38 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803bd0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803bd4:	75 17                	jne    803bed <realloc_block_FF+0x36c>
  803bd6:	83 ec 04             	sub    $0x4,%esp
  803bd9:	68 10 4c 80 00       	push   $0x804c10
  803bde:	68 10 02 00 00       	push   $0x210
  803be3:	68 c1 4b 80 00       	push   $0x804bc1
  803be8:	e8 58 cc ff ff       	call   800845 <_panic>
  803bed:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803bf3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bf6:	89 50 04             	mov    %edx,0x4(%eax)
  803bf9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bfc:	8b 40 04             	mov    0x4(%eax),%eax
  803bff:	85 c0                	test   %eax,%eax
  803c01:	74 0c                	je     803c0f <realloc_block_FF+0x38e>
  803c03:	a1 30 50 80 00       	mov    0x805030,%eax
  803c08:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c0b:	89 10                	mov    %edx,(%eax)
  803c0d:	eb 08                	jmp    803c17 <realloc_block_FF+0x396>
  803c0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c12:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c1a:	a3 30 50 80 00       	mov    %eax,0x805030
  803c1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c28:	a1 38 50 80 00       	mov    0x805038,%eax
  803c2d:	40                   	inc    %eax
  803c2e:	a3 38 50 80 00       	mov    %eax,0x805038
  803c33:	e9 cc 00 00 00       	jmp    803d04 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803c38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803c3f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c47:	e9 8a 00 00 00       	jmp    803cd6 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c4f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c52:	73 7a                	jae    803cce <realloc_block_FF+0x44d>
  803c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c57:	8b 00                	mov    (%eax),%eax
  803c59:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c5c:	73 70                	jae    803cce <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803c5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c62:	74 06                	je     803c6a <realloc_block_FF+0x3e9>
  803c64:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c68:	75 17                	jne    803c81 <realloc_block_FF+0x400>
  803c6a:	83 ec 04             	sub    $0x4,%esp
  803c6d:	68 34 4c 80 00       	push   $0x804c34
  803c72:	68 1a 02 00 00       	push   $0x21a
  803c77:	68 c1 4b 80 00       	push   $0x804bc1
  803c7c:	e8 c4 cb ff ff       	call   800845 <_panic>
  803c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c84:	8b 10                	mov    (%eax),%edx
  803c86:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c89:	89 10                	mov    %edx,(%eax)
  803c8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c8e:	8b 00                	mov    (%eax),%eax
  803c90:	85 c0                	test   %eax,%eax
  803c92:	74 0b                	je     803c9f <realloc_block_FF+0x41e>
  803c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c97:	8b 00                	mov    (%eax),%eax
  803c99:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c9c:	89 50 04             	mov    %edx,0x4(%eax)
  803c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ca5:	89 10                	mov    %edx,(%eax)
  803ca7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803caa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cad:	89 50 04             	mov    %edx,0x4(%eax)
  803cb0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cb3:	8b 00                	mov    (%eax),%eax
  803cb5:	85 c0                	test   %eax,%eax
  803cb7:	75 08                	jne    803cc1 <realloc_block_FF+0x440>
  803cb9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cbc:	a3 30 50 80 00       	mov    %eax,0x805030
  803cc1:	a1 38 50 80 00       	mov    0x805038,%eax
  803cc6:	40                   	inc    %eax
  803cc7:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803ccc:	eb 36                	jmp    803d04 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803cce:	a1 34 50 80 00       	mov    0x805034,%eax
  803cd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cda:	74 07                	je     803ce3 <realloc_block_FF+0x462>
  803cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cdf:	8b 00                	mov    (%eax),%eax
  803ce1:	eb 05                	jmp    803ce8 <realloc_block_FF+0x467>
  803ce3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ce8:	a3 34 50 80 00       	mov    %eax,0x805034
  803ced:	a1 34 50 80 00       	mov    0x805034,%eax
  803cf2:	85 c0                	test   %eax,%eax
  803cf4:	0f 85 52 ff ff ff    	jne    803c4c <realloc_block_FF+0x3cb>
  803cfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cfe:	0f 85 48 ff ff ff    	jne    803c4c <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803d04:	83 ec 04             	sub    $0x4,%esp
  803d07:	6a 00                	push   $0x0
  803d09:	ff 75 d8             	pushl  -0x28(%ebp)
  803d0c:	ff 75 d4             	pushl  -0x2c(%ebp)
  803d0f:	e8 7a eb ff ff       	call   80288e <set_block_data>
  803d14:	83 c4 10             	add    $0x10,%esp
				return va;
  803d17:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1a:	e9 7b 02 00 00       	jmp    803f9a <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803d1f:	83 ec 0c             	sub    $0xc,%esp
  803d22:	68 b1 4c 80 00       	push   $0x804cb1
  803d27:	e8 d6 cd ff ff       	call   800b02 <cprintf>
  803d2c:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d32:	e9 63 02 00 00       	jmp    803f9a <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d3a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d3d:	0f 86 4d 02 00 00    	jbe    803f90 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803d43:	83 ec 0c             	sub    $0xc,%esp
  803d46:	ff 75 e4             	pushl  -0x1c(%ebp)
  803d49:	e8 08 e8 ff ff       	call   802556 <is_free_block>
  803d4e:	83 c4 10             	add    $0x10,%esp
  803d51:	84 c0                	test   %al,%al
  803d53:	0f 84 37 02 00 00    	je     803f90 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d5c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803d5f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803d62:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d65:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d68:	76 38                	jbe    803da2 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803d6a:	83 ec 0c             	sub    $0xc,%esp
  803d6d:	ff 75 08             	pushl  0x8(%ebp)
  803d70:	e8 0c fa ff ff       	call   803781 <free_block>
  803d75:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803d78:	83 ec 0c             	sub    $0xc,%esp
  803d7b:	ff 75 0c             	pushl  0xc(%ebp)
  803d7e:	e8 3a eb ff ff       	call   8028bd <alloc_block_FF>
  803d83:	83 c4 10             	add    $0x10,%esp
  803d86:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803d89:	83 ec 08             	sub    $0x8,%esp
  803d8c:	ff 75 c0             	pushl  -0x40(%ebp)
  803d8f:	ff 75 08             	pushl  0x8(%ebp)
  803d92:	e8 ab fa ff ff       	call   803842 <copy_data>
  803d97:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803d9a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803d9d:	e9 f8 01 00 00       	jmp    803f9a <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803da2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803da5:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803da8:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803dab:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803daf:	0f 87 a0 00 00 00    	ja     803e55 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803db5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803db9:	75 17                	jne    803dd2 <realloc_block_FF+0x551>
  803dbb:	83 ec 04             	sub    $0x4,%esp
  803dbe:	68 a3 4b 80 00       	push   $0x804ba3
  803dc3:	68 38 02 00 00       	push   $0x238
  803dc8:	68 c1 4b 80 00       	push   $0x804bc1
  803dcd:	e8 73 ca ff ff       	call   800845 <_panic>
  803dd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd5:	8b 00                	mov    (%eax),%eax
  803dd7:	85 c0                	test   %eax,%eax
  803dd9:	74 10                	je     803deb <realloc_block_FF+0x56a>
  803ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dde:	8b 00                	mov    (%eax),%eax
  803de0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803de3:	8b 52 04             	mov    0x4(%edx),%edx
  803de6:	89 50 04             	mov    %edx,0x4(%eax)
  803de9:	eb 0b                	jmp    803df6 <realloc_block_FF+0x575>
  803deb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dee:	8b 40 04             	mov    0x4(%eax),%eax
  803df1:	a3 30 50 80 00       	mov    %eax,0x805030
  803df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df9:	8b 40 04             	mov    0x4(%eax),%eax
  803dfc:	85 c0                	test   %eax,%eax
  803dfe:	74 0f                	je     803e0f <realloc_block_FF+0x58e>
  803e00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e03:	8b 40 04             	mov    0x4(%eax),%eax
  803e06:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e09:	8b 12                	mov    (%edx),%edx
  803e0b:	89 10                	mov    %edx,(%eax)
  803e0d:	eb 0a                	jmp    803e19 <realloc_block_FF+0x598>
  803e0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e12:	8b 00                	mov    (%eax),%eax
  803e14:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803e19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e2c:	a1 38 50 80 00       	mov    0x805038,%eax
  803e31:	48                   	dec    %eax
  803e32:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803e37:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e3d:	01 d0                	add    %edx,%eax
  803e3f:	83 ec 04             	sub    $0x4,%esp
  803e42:	6a 01                	push   $0x1
  803e44:	50                   	push   %eax
  803e45:	ff 75 08             	pushl  0x8(%ebp)
  803e48:	e8 41 ea ff ff       	call   80288e <set_block_data>
  803e4d:	83 c4 10             	add    $0x10,%esp
  803e50:	e9 36 01 00 00       	jmp    803f8b <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803e55:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e58:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e5b:	01 d0                	add    %edx,%eax
  803e5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803e60:	83 ec 04             	sub    $0x4,%esp
  803e63:	6a 01                	push   $0x1
  803e65:	ff 75 f0             	pushl  -0x10(%ebp)
  803e68:	ff 75 08             	pushl  0x8(%ebp)
  803e6b:	e8 1e ea ff ff       	call   80288e <set_block_data>
  803e70:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803e73:	8b 45 08             	mov    0x8(%ebp),%eax
  803e76:	83 e8 04             	sub    $0x4,%eax
  803e79:	8b 00                	mov    (%eax),%eax
  803e7b:	83 e0 fe             	and    $0xfffffffe,%eax
  803e7e:	89 c2                	mov    %eax,%edx
  803e80:	8b 45 08             	mov    0x8(%ebp),%eax
  803e83:	01 d0                	add    %edx,%eax
  803e85:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803e88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e8c:	74 06                	je     803e94 <realloc_block_FF+0x613>
  803e8e:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803e92:	75 17                	jne    803eab <realloc_block_FF+0x62a>
  803e94:	83 ec 04             	sub    $0x4,%esp
  803e97:	68 34 4c 80 00       	push   $0x804c34
  803e9c:	68 44 02 00 00       	push   $0x244
  803ea1:	68 c1 4b 80 00       	push   $0x804bc1
  803ea6:	e8 9a c9 ff ff       	call   800845 <_panic>
  803eab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eae:	8b 10                	mov    (%eax),%edx
  803eb0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803eb3:	89 10                	mov    %edx,(%eax)
  803eb5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803eb8:	8b 00                	mov    (%eax),%eax
  803eba:	85 c0                	test   %eax,%eax
  803ebc:	74 0b                	je     803ec9 <realloc_block_FF+0x648>
  803ebe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec1:	8b 00                	mov    (%eax),%eax
  803ec3:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803ec6:	89 50 04             	mov    %edx,0x4(%eax)
  803ec9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ecc:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803ecf:	89 10                	mov    %edx,(%eax)
  803ed1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ed4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ed7:	89 50 04             	mov    %edx,0x4(%eax)
  803eda:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803edd:	8b 00                	mov    (%eax),%eax
  803edf:	85 c0                	test   %eax,%eax
  803ee1:	75 08                	jne    803eeb <realloc_block_FF+0x66a>
  803ee3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ee6:	a3 30 50 80 00       	mov    %eax,0x805030
  803eeb:	a1 38 50 80 00       	mov    0x805038,%eax
  803ef0:	40                   	inc    %eax
  803ef1:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803ef6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803efa:	75 17                	jne    803f13 <realloc_block_FF+0x692>
  803efc:	83 ec 04             	sub    $0x4,%esp
  803eff:	68 a3 4b 80 00       	push   $0x804ba3
  803f04:	68 45 02 00 00       	push   $0x245
  803f09:	68 c1 4b 80 00       	push   $0x804bc1
  803f0e:	e8 32 c9 ff ff       	call   800845 <_panic>
  803f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f16:	8b 00                	mov    (%eax),%eax
  803f18:	85 c0                	test   %eax,%eax
  803f1a:	74 10                	je     803f2c <realloc_block_FF+0x6ab>
  803f1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f1f:	8b 00                	mov    (%eax),%eax
  803f21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f24:	8b 52 04             	mov    0x4(%edx),%edx
  803f27:	89 50 04             	mov    %edx,0x4(%eax)
  803f2a:	eb 0b                	jmp    803f37 <realloc_block_FF+0x6b6>
  803f2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f2f:	8b 40 04             	mov    0x4(%eax),%eax
  803f32:	a3 30 50 80 00       	mov    %eax,0x805030
  803f37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f3a:	8b 40 04             	mov    0x4(%eax),%eax
  803f3d:	85 c0                	test   %eax,%eax
  803f3f:	74 0f                	je     803f50 <realloc_block_FF+0x6cf>
  803f41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f44:	8b 40 04             	mov    0x4(%eax),%eax
  803f47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f4a:	8b 12                	mov    (%edx),%edx
  803f4c:	89 10                	mov    %edx,(%eax)
  803f4e:	eb 0a                	jmp    803f5a <realloc_block_FF+0x6d9>
  803f50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f53:	8b 00                	mov    (%eax),%eax
  803f55:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803f5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f6d:	a1 38 50 80 00       	mov    0x805038,%eax
  803f72:	48                   	dec    %eax
  803f73:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803f78:	83 ec 04             	sub    $0x4,%esp
  803f7b:	6a 00                	push   $0x0
  803f7d:	ff 75 bc             	pushl  -0x44(%ebp)
  803f80:	ff 75 b8             	pushl  -0x48(%ebp)
  803f83:	e8 06 e9 ff ff       	call   80288e <set_block_data>
  803f88:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f8e:	eb 0a                	jmp    803f9a <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803f90:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803f97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803f9a:	c9                   	leave  
  803f9b:	c3                   	ret    

00803f9c <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803f9c:	55                   	push   %ebp
  803f9d:	89 e5                	mov    %esp,%ebp
  803f9f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803fa2:	83 ec 04             	sub    $0x4,%esp
  803fa5:	68 b8 4c 80 00       	push   $0x804cb8
  803faa:	68 58 02 00 00       	push   $0x258
  803faf:	68 c1 4b 80 00       	push   $0x804bc1
  803fb4:	e8 8c c8 ff ff       	call   800845 <_panic>

00803fb9 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803fb9:	55                   	push   %ebp
  803fba:	89 e5                	mov    %esp,%ebp
  803fbc:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803fbf:	83 ec 04             	sub    $0x4,%esp
  803fc2:	68 e0 4c 80 00       	push   $0x804ce0
  803fc7:	68 61 02 00 00       	push   $0x261
  803fcc:	68 c1 4b 80 00       	push   $0x804bc1
  803fd1:	e8 6f c8 ff ff       	call   800845 <_panic>
  803fd6:	66 90                	xchg   %ax,%ax

00803fd8 <__udivdi3>:
  803fd8:	55                   	push   %ebp
  803fd9:	57                   	push   %edi
  803fda:	56                   	push   %esi
  803fdb:	53                   	push   %ebx
  803fdc:	83 ec 1c             	sub    $0x1c,%esp
  803fdf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803fe3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803fe7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803feb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803fef:	89 ca                	mov    %ecx,%edx
  803ff1:	89 f8                	mov    %edi,%eax
  803ff3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ff7:	85 f6                	test   %esi,%esi
  803ff9:	75 2d                	jne    804028 <__udivdi3+0x50>
  803ffb:	39 cf                	cmp    %ecx,%edi
  803ffd:	77 65                	ja     804064 <__udivdi3+0x8c>
  803fff:	89 fd                	mov    %edi,%ebp
  804001:	85 ff                	test   %edi,%edi
  804003:	75 0b                	jne    804010 <__udivdi3+0x38>
  804005:	b8 01 00 00 00       	mov    $0x1,%eax
  80400a:	31 d2                	xor    %edx,%edx
  80400c:	f7 f7                	div    %edi
  80400e:	89 c5                	mov    %eax,%ebp
  804010:	31 d2                	xor    %edx,%edx
  804012:	89 c8                	mov    %ecx,%eax
  804014:	f7 f5                	div    %ebp
  804016:	89 c1                	mov    %eax,%ecx
  804018:	89 d8                	mov    %ebx,%eax
  80401a:	f7 f5                	div    %ebp
  80401c:	89 cf                	mov    %ecx,%edi
  80401e:	89 fa                	mov    %edi,%edx
  804020:	83 c4 1c             	add    $0x1c,%esp
  804023:	5b                   	pop    %ebx
  804024:	5e                   	pop    %esi
  804025:	5f                   	pop    %edi
  804026:	5d                   	pop    %ebp
  804027:	c3                   	ret    
  804028:	39 ce                	cmp    %ecx,%esi
  80402a:	77 28                	ja     804054 <__udivdi3+0x7c>
  80402c:	0f bd fe             	bsr    %esi,%edi
  80402f:	83 f7 1f             	xor    $0x1f,%edi
  804032:	75 40                	jne    804074 <__udivdi3+0x9c>
  804034:	39 ce                	cmp    %ecx,%esi
  804036:	72 0a                	jb     804042 <__udivdi3+0x6a>
  804038:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80403c:	0f 87 9e 00 00 00    	ja     8040e0 <__udivdi3+0x108>
  804042:	b8 01 00 00 00       	mov    $0x1,%eax
  804047:	89 fa                	mov    %edi,%edx
  804049:	83 c4 1c             	add    $0x1c,%esp
  80404c:	5b                   	pop    %ebx
  80404d:	5e                   	pop    %esi
  80404e:	5f                   	pop    %edi
  80404f:	5d                   	pop    %ebp
  804050:	c3                   	ret    
  804051:	8d 76 00             	lea    0x0(%esi),%esi
  804054:	31 ff                	xor    %edi,%edi
  804056:	31 c0                	xor    %eax,%eax
  804058:	89 fa                	mov    %edi,%edx
  80405a:	83 c4 1c             	add    $0x1c,%esp
  80405d:	5b                   	pop    %ebx
  80405e:	5e                   	pop    %esi
  80405f:	5f                   	pop    %edi
  804060:	5d                   	pop    %ebp
  804061:	c3                   	ret    
  804062:	66 90                	xchg   %ax,%ax
  804064:	89 d8                	mov    %ebx,%eax
  804066:	f7 f7                	div    %edi
  804068:	31 ff                	xor    %edi,%edi
  80406a:	89 fa                	mov    %edi,%edx
  80406c:	83 c4 1c             	add    $0x1c,%esp
  80406f:	5b                   	pop    %ebx
  804070:	5e                   	pop    %esi
  804071:	5f                   	pop    %edi
  804072:	5d                   	pop    %ebp
  804073:	c3                   	ret    
  804074:	bd 20 00 00 00       	mov    $0x20,%ebp
  804079:	89 eb                	mov    %ebp,%ebx
  80407b:	29 fb                	sub    %edi,%ebx
  80407d:	89 f9                	mov    %edi,%ecx
  80407f:	d3 e6                	shl    %cl,%esi
  804081:	89 c5                	mov    %eax,%ebp
  804083:	88 d9                	mov    %bl,%cl
  804085:	d3 ed                	shr    %cl,%ebp
  804087:	89 e9                	mov    %ebp,%ecx
  804089:	09 f1                	or     %esi,%ecx
  80408b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80408f:	89 f9                	mov    %edi,%ecx
  804091:	d3 e0                	shl    %cl,%eax
  804093:	89 c5                	mov    %eax,%ebp
  804095:	89 d6                	mov    %edx,%esi
  804097:	88 d9                	mov    %bl,%cl
  804099:	d3 ee                	shr    %cl,%esi
  80409b:	89 f9                	mov    %edi,%ecx
  80409d:	d3 e2                	shl    %cl,%edx
  80409f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040a3:	88 d9                	mov    %bl,%cl
  8040a5:	d3 e8                	shr    %cl,%eax
  8040a7:	09 c2                	or     %eax,%edx
  8040a9:	89 d0                	mov    %edx,%eax
  8040ab:	89 f2                	mov    %esi,%edx
  8040ad:	f7 74 24 0c          	divl   0xc(%esp)
  8040b1:	89 d6                	mov    %edx,%esi
  8040b3:	89 c3                	mov    %eax,%ebx
  8040b5:	f7 e5                	mul    %ebp
  8040b7:	39 d6                	cmp    %edx,%esi
  8040b9:	72 19                	jb     8040d4 <__udivdi3+0xfc>
  8040bb:	74 0b                	je     8040c8 <__udivdi3+0xf0>
  8040bd:	89 d8                	mov    %ebx,%eax
  8040bf:	31 ff                	xor    %edi,%edi
  8040c1:	e9 58 ff ff ff       	jmp    80401e <__udivdi3+0x46>
  8040c6:	66 90                	xchg   %ax,%ax
  8040c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8040cc:	89 f9                	mov    %edi,%ecx
  8040ce:	d3 e2                	shl    %cl,%edx
  8040d0:	39 c2                	cmp    %eax,%edx
  8040d2:	73 e9                	jae    8040bd <__udivdi3+0xe5>
  8040d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8040d7:	31 ff                	xor    %edi,%edi
  8040d9:	e9 40 ff ff ff       	jmp    80401e <__udivdi3+0x46>
  8040de:	66 90                	xchg   %ax,%ax
  8040e0:	31 c0                	xor    %eax,%eax
  8040e2:	e9 37 ff ff ff       	jmp    80401e <__udivdi3+0x46>
  8040e7:	90                   	nop

008040e8 <__umoddi3>:
  8040e8:	55                   	push   %ebp
  8040e9:	57                   	push   %edi
  8040ea:	56                   	push   %esi
  8040eb:	53                   	push   %ebx
  8040ec:	83 ec 1c             	sub    $0x1c,%esp
  8040ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8040f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8040f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8040ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804103:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804107:	89 f3                	mov    %esi,%ebx
  804109:	89 fa                	mov    %edi,%edx
  80410b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80410f:	89 34 24             	mov    %esi,(%esp)
  804112:	85 c0                	test   %eax,%eax
  804114:	75 1a                	jne    804130 <__umoddi3+0x48>
  804116:	39 f7                	cmp    %esi,%edi
  804118:	0f 86 a2 00 00 00    	jbe    8041c0 <__umoddi3+0xd8>
  80411e:	89 c8                	mov    %ecx,%eax
  804120:	89 f2                	mov    %esi,%edx
  804122:	f7 f7                	div    %edi
  804124:	89 d0                	mov    %edx,%eax
  804126:	31 d2                	xor    %edx,%edx
  804128:	83 c4 1c             	add    $0x1c,%esp
  80412b:	5b                   	pop    %ebx
  80412c:	5e                   	pop    %esi
  80412d:	5f                   	pop    %edi
  80412e:	5d                   	pop    %ebp
  80412f:	c3                   	ret    
  804130:	39 f0                	cmp    %esi,%eax
  804132:	0f 87 ac 00 00 00    	ja     8041e4 <__umoddi3+0xfc>
  804138:	0f bd e8             	bsr    %eax,%ebp
  80413b:	83 f5 1f             	xor    $0x1f,%ebp
  80413e:	0f 84 ac 00 00 00    	je     8041f0 <__umoddi3+0x108>
  804144:	bf 20 00 00 00       	mov    $0x20,%edi
  804149:	29 ef                	sub    %ebp,%edi
  80414b:	89 fe                	mov    %edi,%esi
  80414d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804151:	89 e9                	mov    %ebp,%ecx
  804153:	d3 e0                	shl    %cl,%eax
  804155:	89 d7                	mov    %edx,%edi
  804157:	89 f1                	mov    %esi,%ecx
  804159:	d3 ef                	shr    %cl,%edi
  80415b:	09 c7                	or     %eax,%edi
  80415d:	89 e9                	mov    %ebp,%ecx
  80415f:	d3 e2                	shl    %cl,%edx
  804161:	89 14 24             	mov    %edx,(%esp)
  804164:	89 d8                	mov    %ebx,%eax
  804166:	d3 e0                	shl    %cl,%eax
  804168:	89 c2                	mov    %eax,%edx
  80416a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80416e:	d3 e0                	shl    %cl,%eax
  804170:	89 44 24 04          	mov    %eax,0x4(%esp)
  804174:	8b 44 24 08          	mov    0x8(%esp),%eax
  804178:	89 f1                	mov    %esi,%ecx
  80417a:	d3 e8                	shr    %cl,%eax
  80417c:	09 d0                	or     %edx,%eax
  80417e:	d3 eb                	shr    %cl,%ebx
  804180:	89 da                	mov    %ebx,%edx
  804182:	f7 f7                	div    %edi
  804184:	89 d3                	mov    %edx,%ebx
  804186:	f7 24 24             	mull   (%esp)
  804189:	89 c6                	mov    %eax,%esi
  80418b:	89 d1                	mov    %edx,%ecx
  80418d:	39 d3                	cmp    %edx,%ebx
  80418f:	0f 82 87 00 00 00    	jb     80421c <__umoddi3+0x134>
  804195:	0f 84 91 00 00 00    	je     80422c <__umoddi3+0x144>
  80419b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80419f:	29 f2                	sub    %esi,%edx
  8041a1:	19 cb                	sbb    %ecx,%ebx
  8041a3:	89 d8                	mov    %ebx,%eax
  8041a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8041a9:	d3 e0                	shl    %cl,%eax
  8041ab:	89 e9                	mov    %ebp,%ecx
  8041ad:	d3 ea                	shr    %cl,%edx
  8041af:	09 d0                	or     %edx,%eax
  8041b1:	89 e9                	mov    %ebp,%ecx
  8041b3:	d3 eb                	shr    %cl,%ebx
  8041b5:	89 da                	mov    %ebx,%edx
  8041b7:	83 c4 1c             	add    $0x1c,%esp
  8041ba:	5b                   	pop    %ebx
  8041bb:	5e                   	pop    %esi
  8041bc:	5f                   	pop    %edi
  8041bd:	5d                   	pop    %ebp
  8041be:	c3                   	ret    
  8041bf:	90                   	nop
  8041c0:	89 fd                	mov    %edi,%ebp
  8041c2:	85 ff                	test   %edi,%edi
  8041c4:	75 0b                	jne    8041d1 <__umoddi3+0xe9>
  8041c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8041cb:	31 d2                	xor    %edx,%edx
  8041cd:	f7 f7                	div    %edi
  8041cf:	89 c5                	mov    %eax,%ebp
  8041d1:	89 f0                	mov    %esi,%eax
  8041d3:	31 d2                	xor    %edx,%edx
  8041d5:	f7 f5                	div    %ebp
  8041d7:	89 c8                	mov    %ecx,%eax
  8041d9:	f7 f5                	div    %ebp
  8041db:	89 d0                	mov    %edx,%eax
  8041dd:	e9 44 ff ff ff       	jmp    804126 <__umoddi3+0x3e>
  8041e2:	66 90                	xchg   %ax,%ax
  8041e4:	89 c8                	mov    %ecx,%eax
  8041e6:	89 f2                	mov    %esi,%edx
  8041e8:	83 c4 1c             	add    $0x1c,%esp
  8041eb:	5b                   	pop    %ebx
  8041ec:	5e                   	pop    %esi
  8041ed:	5f                   	pop    %edi
  8041ee:	5d                   	pop    %ebp
  8041ef:	c3                   	ret    
  8041f0:	3b 04 24             	cmp    (%esp),%eax
  8041f3:	72 06                	jb     8041fb <__umoddi3+0x113>
  8041f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8041f9:	77 0f                	ja     80420a <__umoddi3+0x122>
  8041fb:	89 f2                	mov    %esi,%edx
  8041fd:	29 f9                	sub    %edi,%ecx
  8041ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804203:	89 14 24             	mov    %edx,(%esp)
  804206:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80420a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80420e:	8b 14 24             	mov    (%esp),%edx
  804211:	83 c4 1c             	add    $0x1c,%esp
  804214:	5b                   	pop    %ebx
  804215:	5e                   	pop    %esi
  804216:	5f                   	pop    %edi
  804217:	5d                   	pop    %ebp
  804218:	c3                   	ret    
  804219:	8d 76 00             	lea    0x0(%esi),%esi
  80421c:	2b 04 24             	sub    (%esp),%eax
  80421f:	19 fa                	sbb    %edi,%edx
  804221:	89 d1                	mov    %edx,%ecx
  804223:	89 c6                	mov    %eax,%esi
  804225:	e9 71 ff ff ff       	jmp    80419b <__umoddi3+0xb3>
  80422a:	66 90                	xchg   %ax,%ax
  80422c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804230:	72 ea                	jb     80421c <__umoddi3+0x134>
  804232:	89 d9                	mov    %ebx,%ecx
  804234:	e9 62 ff ff ff       	jmp    80419b <__umoddi3+0xb3>
