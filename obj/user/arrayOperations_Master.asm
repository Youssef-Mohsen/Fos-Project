
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
  800041:	e8 ed 1f 00 00       	call   802033 <sys_lock_cons>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 43 80 00       	push   $0x804300
  80004e:	e8 af 0a 00 00       	call   800b02 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 43 80 00       	push   $0x804302
  80005e:	e8 9f 0a 00 00       	call   800b02 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 20 43 80 00       	push   $0x804320
  80006e:	e8 8f 0a 00 00       	call   800b02 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 43 80 00       	push   $0x804302
  80007e:	e8 7f 0a 00 00       	call   800b02 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 43 80 00       	push   $0x804300
  80008e:	e8 6f 0a 00 00       	call   800b02 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 40 43 80 00       	push   $0x804340
  8000a2:	e8 ef 10 00 00       	call   801196 <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 5f 43 80 00       	push   $0x80435f
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
  8000ef:	68 67 43 80 00       	push   $0x804367
  8000f4:	e8 de 1c 00 00       	call   801dd7 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 6c 43 80 00       	push   $0x80436c
  800107:	e8 f6 09 00 00       	call   800b02 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 8e 43 80 00       	push   $0x80438e
  800117:	e8 e6 09 00 00       	call   800b02 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 9c 43 80 00       	push   $0x80439c
  800127:	e8 d6 09 00 00       	call   800b02 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 ab 43 80 00       	push   $0x8043ab
  800137:	e8 c6 09 00 00       	call   800b02 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 bb 43 80 00       	push   $0x8043bb
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
  800186:	e8 c2 1e 00 00       	call   80204d <sys_unlock_cons>
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
  8001f6:	68 c4 43 80 00       	push   $0x8043c4
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
  800235:	68 d2 43 80 00       	push   $0x8043d2
  80023a:	e8 02 20 00 00       	call   802241 <sys_create_env>
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
  80026b:	68 db 43 80 00       	push   $0x8043db
  800270:	e8 cc 1f 00 00       	call   802241 <sys_create_env>
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
  8002a1:	68 e4 43 80 00       	push   $0x8043e4
  8002a6:	e8 96 1f 00 00       	call   802241 <sys_create_env>
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
  8002c6:	68 f0 43 80 00       	push   $0x8043f0
  8002cb:	6a 4e                	push   $0x4e
  8002cd:	68 05 44 80 00       	push   $0x804405
  8002d2:	e8 6e 05 00 00       	call   800845 <_panic>

	sys_run_env(envIdQuickSort);
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	ff 75 dc             	pushl  -0x24(%ebp)
  8002dd:	e8 7d 1f 00 00       	call   80225f <sys_run_env>
  8002e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002eb:	e8 6f 1f 00 00       	call   80225f <sys_run_env>
  8002f0:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f9:	e8 61 1f 00 00       	call   80225f <sys_run_env>
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
  800340:	68 23 44 80 00       	push   $0x804423
  800345:	ff 75 dc             	pushl  -0x24(%ebp)
  800348:	e8 42 1b 00 00       	call   801e8f <sget>
  80034d:	83 c4 10             	add    $0x10,%esp
  800350:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  800353:	83 ec 08             	sub    $0x8,%esp
  800356:	68 32 44 80 00       	push   $0x804432
  80035b:	ff 75 d8             	pushl  -0x28(%ebp)
  80035e:	e8 2c 1b 00 00       	call   801e8f <sget>
  800363:	83 c4 10             	add    $0x10,%esp
  800366:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800369:	83 ec 08             	sub    $0x8,%esp
  80036c:	68 41 44 80 00       	push   $0x804441
  800371:	ff 75 d4             	pushl  -0x2c(%ebp)
  800374:	e8 16 1b 00 00       	call   801e8f <sget>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	68 46 44 80 00       	push   $0x804446
  800387:	ff 75 d4             	pushl  -0x2c(%ebp)
  80038a:	e8 00 1b 00 00       	call   801e8f <sget>
  80038f:	83 c4 10             	add    $0x10,%esp
  800392:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  800395:	83 ec 08             	sub    $0x8,%esp
  800398:	68 4a 44 80 00       	push   $0x80444a
  80039d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003a0:	e8 ea 1a 00 00       	call   801e8f <sget>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003ab:	83 ec 08             	sub    $0x8,%esp
  8003ae:	68 4e 44 80 00       	push   $0x80444e
  8003b3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003b6:	e8 d4 1a 00 00       	call   801e8f <sget>
  8003bb:	83 c4 10             	add    $0x10,%esp
  8003be:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	68 52 44 80 00       	push   $0x804452
  8003c9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003cc:	e8 be 1a 00 00       	call   801e8f <sget>
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
  8003f4:	68 58 44 80 00       	push   $0x804458
  8003f9:	6a 69                	push   $0x69
  8003fb:	68 05 44 80 00       	push   $0x804405
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
  800422:	68 80 44 80 00       	push   $0x804480
  800427:	6a 6b                	push   $0x6b
  800429:	68 05 44 80 00       	push   $0x804405
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
  8004d5:	68 a8 44 80 00       	push   $0x8044a8
  8004da:	6a 78                	push   $0x78
  8004dc:	68 05 44 80 00       	push   $0x804405
  8004e1:	e8 5f 03 00 00       	call   800845 <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004e6:	83 ec 0c             	sub    $0xc,%esp
  8004e9:	68 d8 44 80 00       	push   $0x8044d8
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
  8006de:	e8 9b 1a 00 00       	call   80217e <sys_cputc>
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
  8006ef:	e8 26 19 00 00       	call   80201a <sys_cgetc>
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
  80070c:	e8 9e 1b 00 00       	call   8022af <sys_getenvindex>
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
  80077a:	e8 b4 18 00 00       	call   802033 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80077f:	83 ec 0c             	sub    $0xc,%esp
  800782:	68 54 45 80 00       	push   $0x804554
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
  8007aa:	68 7c 45 80 00       	push   $0x80457c
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
  8007db:	68 a4 45 80 00       	push   $0x8045a4
  8007e0:	e8 1d 03 00 00       	call   800b02 <cprintf>
  8007e5:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8007ed:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	50                   	push   %eax
  8007f7:	68 fc 45 80 00       	push   $0x8045fc
  8007fc:	e8 01 03 00 00       	call   800b02 <cprintf>
  800801:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800804:	83 ec 0c             	sub    $0xc,%esp
  800807:	68 54 45 80 00       	push   $0x804554
  80080c:	e8 f1 02 00 00       	call   800b02 <cprintf>
  800811:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800814:	e8 34 18 00 00       	call   80204d <sys_unlock_cons>
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
  80082c:	e8 4a 1a 00 00       	call   80227b <sys_destroy_env>
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
  80083d:	e8 9f 1a 00 00       	call   8022e1 <sys_exit_env>
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
  800866:	68 10 46 80 00       	push   $0x804610
  80086b:	e8 92 02 00 00       	call   800b02 <cprintf>
  800870:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800873:	a1 00 50 80 00       	mov    0x805000,%eax
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	50                   	push   %eax
  80087f:	68 15 46 80 00       	push   $0x804615
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
  8008a3:	68 31 46 80 00       	push   $0x804631
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
  8008d2:	68 34 46 80 00       	push   $0x804634
  8008d7:	6a 26                	push   $0x26
  8008d9:	68 80 46 80 00       	push   $0x804680
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
  8009a7:	68 8c 46 80 00       	push   $0x80468c
  8009ac:	6a 3a                	push   $0x3a
  8009ae:	68 80 46 80 00       	push   $0x804680
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
  800a1a:	68 e0 46 80 00       	push   $0x8046e0
  800a1f:	6a 44                	push   $0x44
  800a21:	68 80 46 80 00       	push   $0x804680
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
  800a74:	e8 78 15 00 00       	call   801ff1 <sys_cputs>
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
  800aeb:	e8 01 15 00 00       	call   801ff1 <sys_cputs>
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
  800b35:	e8 f9 14 00 00       	call   802033 <sys_lock_cons>
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
  800b55:	e8 f3 14 00 00       	call   80204d <sys_unlock_cons>
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
  800b9f:	e8 e4 34 00 00       	call   804088 <__udivdi3>
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
  800bef:	e8 a4 35 00 00       	call   804198 <__umoddi3>
  800bf4:	83 c4 10             	add    $0x10,%esp
  800bf7:	05 54 49 80 00       	add    $0x804954,%eax
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
  800d4a:	8b 04 85 78 49 80 00 	mov    0x804978(,%eax,4),%eax
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
  800e2b:	8b 34 9d c0 47 80 00 	mov    0x8047c0(,%ebx,4),%esi
  800e32:	85 f6                	test   %esi,%esi
  800e34:	75 19                	jne    800e4f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e36:	53                   	push   %ebx
  800e37:	68 65 49 80 00       	push   $0x804965
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
  800e50:	68 6e 49 80 00       	push   $0x80496e
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
  800e7d:	be 71 49 80 00       	mov    $0x804971,%esi
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
  8011a8:	68 e8 4a 80 00       	push   $0x804ae8
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
  8011ea:	68 eb 4a 80 00       	push   $0x804aeb
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
  80129b:	e8 93 0d 00 00       	call   802033 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012a4:	74 13                	je     8012b9 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012a6:	83 ec 08             	sub    $0x8,%esp
  8012a9:	ff 75 08             	pushl  0x8(%ebp)
  8012ac:	68 e8 4a 80 00       	push   $0x804ae8
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
  8012ee:	68 eb 4a 80 00       	push   $0x804aeb
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
  801396:	e8 b2 0c 00 00       	call   80204d <sys_unlock_cons>
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
  801a90:	68 fc 4a 80 00       	push   $0x804afc
  801a95:	68 3f 01 00 00       	push   $0x13f
  801a9a:	68 1e 4b 80 00       	push   $0x804b1e
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
  801ab0:	e8 e7 0a 00 00       	call   80259c <sys_sbrk>
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
  801b2b:	e8 f0 08 00 00       	call   802420 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b30:	85 c0                	test   %eax,%eax
  801b32:	74 16                	je     801b4a <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801b34:	83 ec 0c             	sub    $0xc,%esp
  801b37:	ff 75 08             	pushl  0x8(%ebp)
  801b3a:	e8 30 0e 00 00       	call   80296f <alloc_block_FF>
  801b3f:	83 c4 10             	add    $0x10,%esp
  801b42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b45:	e9 8a 01 00 00       	jmp    801cd4 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b4a:	e8 02 09 00 00       	call   802451 <sys_isUHeapPlacementStrategyBESTFIT>
  801b4f:	85 c0                	test   %eax,%eax
  801b51:	0f 84 7d 01 00 00    	je     801cd4 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801b57:	83 ec 0c             	sub    $0xc,%esp
  801b5a:	ff 75 08             	pushl  0x8(%ebp)
  801b5d:	e8 c9 12 00 00       	call   802e2b <alloc_block_BF>
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
  801bad:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801bfa:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801c51:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
  801cb3:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801cba:	83 ec 08             	sub    $0x8,%esp
  801cbd:	ff 75 08             	pushl  0x8(%ebp)
  801cc0:	ff 75 f0             	pushl  -0x10(%ebp)
  801cc3:	e8 0b 09 00 00       	call   8025d3 <sys_allocate_user_mem>
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
  801d0b:	e8 df 08 00 00       	call   8025ef <get_block_size>
  801d10:	83 c4 10             	add    $0x10,%esp
  801d13:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d16:	83 ec 0c             	sub    $0xc,%esp
  801d19:	ff 75 08             	pushl  0x8(%ebp)
  801d1c:	e8 12 1b 00 00       	call   803833 <free_block>
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
  801d56:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  801d93:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  801db3:	e8 ff 07 00 00       	call   8025b7 <sys_free_user_mem>
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
  801dc1:	68 2c 4b 80 00       	push   $0x804b2c
  801dc6:	68 85 00 00 00       	push   $0x85
  801dcb:	68 56 4b 80 00       	push   $0x804b56
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
  801de7:	75 0a                	jne    801df3 <smalloc+0x1c>
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dee:	e9 9a 00 00 00       	jmp    801e8d <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801df9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e00:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e06:	39 d0                	cmp    %edx,%eax
  801e08:	73 02                	jae    801e0c <smalloc+0x35>
  801e0a:	89 d0                	mov    %edx,%eax
  801e0c:	83 ec 0c             	sub    $0xc,%esp
  801e0f:	50                   	push   %eax
  801e10:	e8 a5 fc ff ff       	call   801aba <malloc>
  801e15:	83 c4 10             	add    $0x10,%esp
  801e18:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801e1b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e1f:	75 07                	jne    801e28 <smalloc+0x51>
  801e21:	b8 00 00 00 00       	mov    $0x0,%eax
  801e26:	eb 65                	jmp    801e8d <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e28:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e2c:	ff 75 ec             	pushl  -0x14(%ebp)
  801e2f:	50                   	push   %eax
  801e30:	ff 75 0c             	pushl  0xc(%ebp)
  801e33:	ff 75 08             	pushl  0x8(%ebp)
  801e36:	e8 83 03 00 00       	call   8021be <sys_createSharedObject>
  801e3b:	83 c4 10             	add    $0x10,%esp
  801e3e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e41:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e45:	74 06                	je     801e4d <smalloc+0x76>
  801e47:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e4b:	75 07                	jne    801e54 <smalloc+0x7d>
  801e4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e52:	eb 39                	jmp    801e8d <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801e54:	83 ec 08             	sub    $0x8,%esp
  801e57:	ff 75 ec             	pushl  -0x14(%ebp)
  801e5a:	68 62 4b 80 00       	push   $0x804b62
  801e5f:	e8 9e ec ff ff       	call   800b02 <cprintf>
  801e64:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801e67:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e6a:	a1 20 50 80 00       	mov    0x805020,%eax
  801e6f:	8b 40 78             	mov    0x78(%eax),%eax
  801e72:	29 c2                	sub    %eax,%edx
  801e74:	89 d0                	mov    %edx,%eax
  801e76:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e7b:	c1 e8 0c             	shr    $0xc,%eax
  801e7e:	89 c2                	mov    %eax,%edx
  801e80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e83:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801e8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e95:	83 ec 08             	sub    $0x8,%esp
  801e98:	ff 75 0c             	pushl  0xc(%ebp)
  801e9b:	ff 75 08             	pushl  0x8(%ebp)
  801e9e:	e8 45 03 00 00       	call   8021e8 <sys_getSizeOfSharedObject>
  801ea3:	83 c4 10             	add    $0x10,%esp
  801ea6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801ea9:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801ead:	75 07                	jne    801eb6 <sget+0x27>
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb4:	eb 5c                	jmp    801f12 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ebc:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801ec3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec9:	39 d0                	cmp    %edx,%eax
  801ecb:	7d 02                	jge    801ecf <sget+0x40>
  801ecd:	89 d0                	mov    %edx,%eax
  801ecf:	83 ec 0c             	sub    $0xc,%esp
  801ed2:	50                   	push   %eax
  801ed3:	e8 e2 fb ff ff       	call   801aba <malloc>
  801ed8:	83 c4 10             	add    $0x10,%esp
  801edb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801ede:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ee2:	75 07                	jne    801eeb <sget+0x5c>
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee9:	eb 27                	jmp    801f12 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801eeb:	83 ec 04             	sub    $0x4,%esp
  801eee:	ff 75 e8             	pushl  -0x18(%ebp)
  801ef1:	ff 75 0c             	pushl  0xc(%ebp)
  801ef4:	ff 75 08             	pushl  0x8(%ebp)
  801ef7:	e8 09 03 00 00       	call   802205 <sys_getSharedObject>
  801efc:	83 c4 10             	add    $0x10,%esp
  801eff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801f02:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801f06:	75 07                	jne    801f0f <sget+0x80>
  801f08:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0d:	eb 03                	jmp    801f12 <sget+0x83>
	return ptr;
  801f0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  801f1d:	a1 20 50 80 00       	mov    0x805020,%eax
  801f22:	8b 40 78             	mov    0x78(%eax),%eax
  801f25:	29 c2                	sub    %eax,%edx
  801f27:	89 d0                	mov    %edx,%eax
  801f29:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f2e:	c1 e8 0c             	shr    $0xc,%eax
  801f31:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801f3b:	83 ec 08             	sub    $0x8,%esp
  801f3e:	ff 75 08             	pushl  0x8(%ebp)
  801f41:	ff 75 f4             	pushl  -0xc(%ebp)
  801f44:	e8 db 02 00 00       	call   802224 <sys_freeSharedObject>
  801f49:	83 c4 10             	add    $0x10,%esp
  801f4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801f4f:	90                   	nop
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f58:	83 ec 04             	sub    $0x4,%esp
  801f5b:	68 74 4b 80 00       	push   $0x804b74
  801f60:	68 dd 00 00 00       	push   $0xdd
  801f65:	68 56 4b 80 00       	push   $0x804b56
  801f6a:	e8 d6 e8 ff ff       	call   800845 <_panic>

00801f6f <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f75:	83 ec 04             	sub    $0x4,%esp
  801f78:	68 9a 4b 80 00       	push   $0x804b9a
  801f7d:	68 e9 00 00 00       	push   $0xe9
  801f82:	68 56 4b 80 00       	push   $0x804b56
  801f87:	e8 b9 e8 ff ff       	call   800845 <_panic>

00801f8c <shrink>:

}
void shrink(uint32 newSize)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f92:	83 ec 04             	sub    $0x4,%esp
  801f95:	68 9a 4b 80 00       	push   $0x804b9a
  801f9a:	68 ee 00 00 00       	push   $0xee
  801f9f:	68 56 4b 80 00       	push   $0x804b56
  801fa4:	e8 9c e8 ff ff       	call   800845 <_panic>

00801fa9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801faf:	83 ec 04             	sub    $0x4,%esp
  801fb2:	68 9a 4b 80 00       	push   $0x804b9a
  801fb7:	68 f3 00 00 00       	push   $0xf3
  801fbc:	68 56 4b 80 00       	push   $0x804b56
  801fc1:	e8 7f e8 ff ff       	call   800845 <_panic>

00801fc6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	57                   	push   %edi
  801fca:	56                   	push   %esi
  801fcb:	53                   	push   %ebx
  801fcc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fd8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fdb:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fde:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fe1:	cd 30                	int    $0x30
  801fe3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fe9:	83 c4 10             	add    $0x10,%esp
  801fec:	5b                   	pop    %ebx
  801fed:	5e                   	pop    %esi
  801fee:	5f                   	pop    %edi
  801fef:	5d                   	pop    %ebp
  801ff0:	c3                   	ret    

00801ff1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 04             	sub    $0x4,%esp
  801ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  801ffa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ffd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802001:	8b 45 08             	mov    0x8(%ebp),%eax
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	52                   	push   %edx
  802009:	ff 75 0c             	pushl  0xc(%ebp)
  80200c:	50                   	push   %eax
  80200d:	6a 00                	push   $0x0
  80200f:	e8 b2 ff ff ff       	call   801fc6 <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
}
  802017:	90                   	nop
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_cgetc>:

int
sys_cgetc(void)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 02                	push   $0x2
  802029:	e8 98 ff ff ff       	call   801fc6 <syscall>
  80202e:	83 c4 18             	add    $0x18,%esp
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 03                	push   $0x3
  802042:	e8 7f ff ff ff       	call   801fc6 <syscall>
  802047:	83 c4 18             	add    $0x18,%esp
}
  80204a:	90                   	nop
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 04                	push   $0x4
  80205c:	e8 65 ff ff ff       	call   801fc6 <syscall>
  802061:	83 c4 18             	add    $0x18,%esp
}
  802064:	90                   	nop
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80206a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	52                   	push   %edx
  802077:	50                   	push   %eax
  802078:	6a 08                	push   $0x8
  80207a:	e8 47 ff ff ff       	call   801fc6 <syscall>
  80207f:	83 c4 18             	add    $0x18,%esp
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	56                   	push   %esi
  802088:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802089:	8b 75 18             	mov    0x18(%ebp),%esi
  80208c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80208f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802092:	8b 55 0c             	mov    0xc(%ebp),%edx
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	56                   	push   %esi
  802099:	53                   	push   %ebx
  80209a:	51                   	push   %ecx
  80209b:	52                   	push   %edx
  80209c:	50                   	push   %eax
  80209d:	6a 09                	push   $0x9
  80209f:	e8 22 ff ff ff       	call   801fc6 <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
}
  8020a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020aa:	5b                   	pop    %ebx
  8020ab:	5e                   	pop    %esi
  8020ac:	5d                   	pop    %ebp
  8020ad:	c3                   	ret    

008020ae <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	52                   	push   %edx
  8020be:	50                   	push   %eax
  8020bf:	6a 0a                	push   $0xa
  8020c1:	e8 00 ff ff ff       	call   801fc6 <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	ff 75 0c             	pushl  0xc(%ebp)
  8020d7:	ff 75 08             	pushl  0x8(%ebp)
  8020da:	6a 0b                	push   $0xb
  8020dc:	e8 e5 fe ff ff       	call   801fc6 <syscall>
  8020e1:	83 c4 18             	add    $0x18,%esp
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 0c                	push   $0xc
  8020f5:	e8 cc fe ff ff       	call   801fc6 <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 0d                	push   $0xd
  80210e:	e8 b3 fe ff ff       	call   801fc6 <syscall>
  802113:	83 c4 18             	add    $0x18,%esp
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 0e                	push   $0xe
  802127:	e8 9a fe ff ff       	call   801fc6 <syscall>
  80212c:	83 c4 18             	add    $0x18,%esp
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 0f                	push   $0xf
  802140:	e8 81 fe ff ff       	call   801fc6 <syscall>
  802145:	83 c4 18             	add    $0x18,%esp
}
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	ff 75 08             	pushl  0x8(%ebp)
  802158:	6a 10                	push   $0x10
  80215a:	e8 67 fe ff ff       	call   801fc6 <syscall>
  80215f:	83 c4 18             	add    $0x18,%esp
}
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 11                	push   $0x11
  802173:	e8 4e fe ff ff       	call   801fc6 <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
}
  80217b:	90                   	nop
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <sys_cputc>:

void
sys_cputc(const char c)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 04             	sub    $0x4,%esp
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80218a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	50                   	push   %eax
  802197:	6a 01                	push   $0x1
  802199:	e8 28 fe ff ff       	call   801fc6 <syscall>
  80219e:	83 c4 18             	add    $0x18,%esp
}
  8021a1:	90                   	nop
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 14                	push   $0x14
  8021b3:	e8 0e fe ff ff       	call   801fc6 <syscall>
  8021b8:	83 c4 18             	add    $0x18,%esp
}
  8021bb:	90                   	nop
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	83 ec 04             	sub    $0x4,%esp
  8021c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021ca:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021cd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	6a 00                	push   $0x0
  8021d6:	51                   	push   %ecx
  8021d7:	52                   	push   %edx
  8021d8:	ff 75 0c             	pushl  0xc(%ebp)
  8021db:	50                   	push   %eax
  8021dc:	6a 15                	push   $0x15
  8021de:	e8 e3 fd ff ff       	call   801fc6 <syscall>
  8021e3:	83 c4 18             	add    $0x18,%esp
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	52                   	push   %edx
  8021f8:	50                   	push   %eax
  8021f9:	6a 16                	push   $0x16
  8021fb:	e8 c6 fd ff ff       	call   801fc6 <syscall>
  802200:	83 c4 18             	add    $0x18,%esp
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802208:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80220b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	51                   	push   %ecx
  802216:	52                   	push   %edx
  802217:	50                   	push   %eax
  802218:	6a 17                	push   $0x17
  80221a:	e8 a7 fd ff ff       	call   801fc6 <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802227:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	52                   	push   %edx
  802234:	50                   	push   %eax
  802235:	6a 18                	push   $0x18
  802237:	e8 8a fd ff ff       	call   801fc6 <syscall>
  80223c:	83 c4 18             	add    $0x18,%esp
}
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	6a 00                	push   $0x0
  802249:	ff 75 14             	pushl  0x14(%ebp)
  80224c:	ff 75 10             	pushl  0x10(%ebp)
  80224f:	ff 75 0c             	pushl  0xc(%ebp)
  802252:	50                   	push   %eax
  802253:	6a 19                	push   $0x19
  802255:	e8 6c fd ff ff       	call   801fc6 <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <sys_run_env>:

void sys_run_env(int32 envId)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	50                   	push   %eax
  80226e:	6a 1a                	push   $0x1a
  802270:	e8 51 fd ff ff       	call   801fc6 <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
}
  802278:	90                   	nop
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	50                   	push   %eax
  80228a:	6a 1b                	push   $0x1b
  80228c:	e8 35 fd ff ff       	call   801fc6 <syscall>
  802291:	83 c4 18             	add    $0x18,%esp
}
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 05                	push   $0x5
  8022a5:	e8 1c fd ff ff       	call   801fc6 <syscall>
  8022aa:	83 c4 18             	add    $0x18,%esp
}
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 06                	push   $0x6
  8022be:	e8 03 fd ff ff       	call   801fc6 <syscall>
  8022c3:	83 c4 18             	add    $0x18,%esp
}
  8022c6:	c9                   	leave  
  8022c7:	c3                   	ret    

008022c8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 07                	push   $0x7
  8022d7:	e8 ea fc ff ff       	call   801fc6 <syscall>
  8022dc:	83 c4 18             	add    $0x18,%esp
}
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <sys_exit_env>:


void sys_exit_env(void)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 1c                	push   $0x1c
  8022f0:	e8 d1 fc ff ff       	call   801fc6 <syscall>
  8022f5:	83 c4 18             	add    $0x18,%esp
}
  8022f8:	90                   	nop
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    

008022fb <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802301:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802304:	8d 50 04             	lea    0x4(%eax),%edx
  802307:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	52                   	push   %edx
  802311:	50                   	push   %eax
  802312:	6a 1d                	push   $0x1d
  802314:	e8 ad fc ff ff       	call   801fc6 <syscall>
  802319:	83 c4 18             	add    $0x18,%esp
	return result;
  80231c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80231f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802322:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802325:	89 01                	mov    %eax,(%ecx)
  802327:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80232a:	8b 45 08             	mov    0x8(%ebp),%eax
  80232d:	c9                   	leave  
  80232e:	c2 04 00             	ret    $0x4

00802331 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	ff 75 10             	pushl  0x10(%ebp)
  80233b:	ff 75 0c             	pushl  0xc(%ebp)
  80233e:	ff 75 08             	pushl  0x8(%ebp)
  802341:	6a 13                	push   $0x13
  802343:	e8 7e fc ff ff       	call   801fc6 <syscall>
  802348:	83 c4 18             	add    $0x18,%esp
	return ;
  80234b:	90                   	nop
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <sys_rcr2>:
uint32 sys_rcr2()
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 1e                	push   $0x1e
  80235d:	e8 64 fc ff ff       	call   801fc6 <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
}
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
  80236a:	83 ec 04             	sub    $0x4,%esp
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802373:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	50                   	push   %eax
  802380:	6a 1f                	push   $0x1f
  802382:	e8 3f fc ff ff       	call   801fc6 <syscall>
  802387:	83 c4 18             	add    $0x18,%esp
	return ;
  80238a:	90                   	nop
}
  80238b:	c9                   	leave  
  80238c:	c3                   	ret    

0080238d <rsttst>:
void rsttst()
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 21                	push   $0x21
  80239c:	e8 25 fc ff ff       	call   801fc6 <syscall>
  8023a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a4:	90                   	nop
}
  8023a5:	c9                   	leave  
  8023a6:	c3                   	ret    

008023a7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
  8023aa:	83 ec 04             	sub    $0x4,%esp
  8023ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8023b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023b3:	8b 55 18             	mov    0x18(%ebp),%edx
  8023b6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023ba:	52                   	push   %edx
  8023bb:	50                   	push   %eax
  8023bc:	ff 75 10             	pushl  0x10(%ebp)
  8023bf:	ff 75 0c             	pushl  0xc(%ebp)
  8023c2:	ff 75 08             	pushl  0x8(%ebp)
  8023c5:	6a 20                	push   $0x20
  8023c7:	e8 fa fb ff ff       	call   801fc6 <syscall>
  8023cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8023cf:	90                   	nop
}
  8023d0:	c9                   	leave  
  8023d1:	c3                   	ret    

008023d2 <chktst>:
void chktst(uint32 n)
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	ff 75 08             	pushl  0x8(%ebp)
  8023e0:	6a 22                	push   $0x22
  8023e2:	e8 df fb ff ff       	call   801fc6 <syscall>
  8023e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ea:	90                   	nop
}
  8023eb:	c9                   	leave  
  8023ec:	c3                   	ret    

008023ed <inctst>:

void inctst()
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 23                	push   $0x23
  8023fc:	e8 c5 fb ff ff       	call   801fc6 <syscall>
  802401:	83 c4 18             	add    $0x18,%esp
	return ;
  802404:	90                   	nop
}
  802405:	c9                   	leave  
  802406:	c3                   	ret    

00802407 <gettst>:
uint32 gettst()
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 24                	push   $0x24
  802416:	e8 ab fb ff ff       	call   801fc6 <syscall>
  80241b:	83 c4 18             	add    $0x18,%esp
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 25                	push   $0x25
  802432:	e8 8f fb ff ff       	call   801fc6 <syscall>
  802437:	83 c4 18             	add    $0x18,%esp
  80243a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80243d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802441:	75 07                	jne    80244a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802443:	b8 01 00 00 00       	mov    $0x1,%eax
  802448:	eb 05                	jmp    80244f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80244a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244f:	c9                   	leave  
  802450:	c3                   	ret    

00802451 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
  802454:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	6a 25                	push   $0x25
  802463:	e8 5e fb ff ff       	call   801fc6 <syscall>
  802468:	83 c4 18             	add    $0x18,%esp
  80246b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80246e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802472:	75 07                	jne    80247b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802474:	b8 01 00 00 00       	mov    $0x1,%eax
  802479:	eb 05                	jmp    802480 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80247b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 25                	push   $0x25
  802494:	e8 2d fb ff ff       	call   801fc6 <syscall>
  802499:	83 c4 18             	add    $0x18,%esp
  80249c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80249f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024a3:	75 07                	jne    8024ac <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8024aa:	eb 05                	jmp    8024b1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
  8024b6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 25                	push   $0x25
  8024c5:	e8 fc fa ff ff       	call   801fc6 <syscall>
  8024ca:	83 c4 18             	add    $0x18,%esp
  8024cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024d0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024d4:	75 07                	jne    8024dd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8024db:	eb 05                	jmp    8024e2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e2:	c9                   	leave  
  8024e3:	c3                   	ret    

008024e4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	6a 00                	push   $0x0
  8024ef:	ff 75 08             	pushl  0x8(%ebp)
  8024f2:	6a 26                	push   $0x26
  8024f4:	e8 cd fa ff ff       	call   801fc6 <syscall>
  8024f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024fc:	90                   	nop
}
  8024fd:	c9                   	leave  
  8024fe:	c3                   	ret    

008024ff <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024ff:	55                   	push   %ebp
  802500:	89 e5                	mov    %esp,%ebp
  802502:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802503:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802506:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802509:	8b 55 0c             	mov    0xc(%ebp),%edx
  80250c:	8b 45 08             	mov    0x8(%ebp),%eax
  80250f:	6a 00                	push   $0x0
  802511:	53                   	push   %ebx
  802512:	51                   	push   %ecx
  802513:	52                   	push   %edx
  802514:	50                   	push   %eax
  802515:	6a 27                	push   $0x27
  802517:	e8 aa fa ff ff       	call   801fc6 <syscall>
  80251c:	83 c4 18             	add    $0x18,%esp
}
  80251f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802527:	8b 55 0c             	mov    0xc(%ebp),%edx
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	52                   	push   %edx
  802534:	50                   	push   %eax
  802535:	6a 28                	push   $0x28
  802537:	e8 8a fa ff ff       	call   801fc6 <syscall>
  80253c:	83 c4 18             	add    $0x18,%esp
}
  80253f:	c9                   	leave  
  802540:	c3                   	ret    

00802541 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802541:	55                   	push   %ebp
  802542:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802544:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802547:	8b 55 0c             	mov    0xc(%ebp),%edx
  80254a:	8b 45 08             	mov    0x8(%ebp),%eax
  80254d:	6a 00                	push   $0x0
  80254f:	51                   	push   %ecx
  802550:	ff 75 10             	pushl  0x10(%ebp)
  802553:	52                   	push   %edx
  802554:	50                   	push   %eax
  802555:	6a 29                	push   $0x29
  802557:	e8 6a fa ff ff       	call   801fc6 <syscall>
  80255c:	83 c4 18             	add    $0x18,%esp
}
  80255f:	c9                   	leave  
  802560:	c3                   	ret    

00802561 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	ff 75 10             	pushl  0x10(%ebp)
  80256b:	ff 75 0c             	pushl  0xc(%ebp)
  80256e:	ff 75 08             	pushl  0x8(%ebp)
  802571:	6a 12                	push   $0x12
  802573:	e8 4e fa ff ff       	call   801fc6 <syscall>
  802578:	83 c4 18             	add    $0x18,%esp
	return ;
  80257b:	90                   	nop
}
  80257c:	c9                   	leave  
  80257d:	c3                   	ret    

0080257e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802581:	8b 55 0c             	mov    0xc(%ebp),%edx
  802584:	8b 45 08             	mov    0x8(%ebp),%eax
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	52                   	push   %edx
  80258e:	50                   	push   %eax
  80258f:	6a 2a                	push   $0x2a
  802591:	e8 30 fa ff ff       	call   801fc6 <syscall>
  802596:	83 c4 18             	add    $0x18,%esp
	return;
  802599:	90                   	nop
}
  80259a:	c9                   	leave  
  80259b:	c3                   	ret    

0080259c <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80259c:	55                   	push   %ebp
  80259d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80259f:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	50                   	push   %eax
  8025ab:	6a 2b                	push   $0x2b
  8025ad:	e8 14 fa ff ff       	call   801fc6 <syscall>
  8025b2:	83 c4 18             	add    $0x18,%esp
}
  8025b5:	c9                   	leave  
  8025b6:	c3                   	ret    

008025b7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8025b7:	55                   	push   %ebp
  8025b8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	ff 75 0c             	pushl  0xc(%ebp)
  8025c3:	ff 75 08             	pushl  0x8(%ebp)
  8025c6:	6a 2c                	push   $0x2c
  8025c8:	e8 f9 f9 ff ff       	call   801fc6 <syscall>
  8025cd:	83 c4 18             	add    $0x18,%esp
	return;
  8025d0:	90                   	nop
}
  8025d1:	c9                   	leave  
  8025d2:	c3                   	ret    

008025d3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8025d3:	55                   	push   %ebp
  8025d4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	ff 75 0c             	pushl  0xc(%ebp)
  8025df:	ff 75 08             	pushl  0x8(%ebp)
  8025e2:	6a 2d                	push   $0x2d
  8025e4:	e8 dd f9 ff ff       	call   801fc6 <syscall>
  8025e9:	83 c4 18             	add    $0x18,%esp
	return;
  8025ec:	90                   	nop
}
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
  8025f2:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f8:	83 e8 04             	sub    $0x4,%eax
  8025fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8025fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802601:	8b 00                	mov    (%eax),%eax
  802603:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802606:	c9                   	leave  
  802607:	c3                   	ret    

00802608 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
  80260b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80260e:	8b 45 08             	mov    0x8(%ebp),%eax
  802611:	83 e8 04             	sub    $0x4,%eax
  802614:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802617:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80261a:	8b 00                	mov    (%eax),%eax
  80261c:	83 e0 01             	and    $0x1,%eax
  80261f:	85 c0                	test   %eax,%eax
  802621:	0f 94 c0             	sete   %al
}
  802624:	c9                   	leave  
  802625:	c3                   	ret    

00802626 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
  802629:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80262c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802633:	8b 45 0c             	mov    0xc(%ebp),%eax
  802636:	83 f8 02             	cmp    $0x2,%eax
  802639:	74 2b                	je     802666 <alloc_block+0x40>
  80263b:	83 f8 02             	cmp    $0x2,%eax
  80263e:	7f 07                	jg     802647 <alloc_block+0x21>
  802640:	83 f8 01             	cmp    $0x1,%eax
  802643:	74 0e                	je     802653 <alloc_block+0x2d>
  802645:	eb 58                	jmp    80269f <alloc_block+0x79>
  802647:	83 f8 03             	cmp    $0x3,%eax
  80264a:	74 2d                	je     802679 <alloc_block+0x53>
  80264c:	83 f8 04             	cmp    $0x4,%eax
  80264f:	74 3b                	je     80268c <alloc_block+0x66>
  802651:	eb 4c                	jmp    80269f <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802653:	83 ec 0c             	sub    $0xc,%esp
  802656:	ff 75 08             	pushl  0x8(%ebp)
  802659:	e8 11 03 00 00       	call   80296f <alloc_block_FF>
  80265e:	83 c4 10             	add    $0x10,%esp
  802661:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802664:	eb 4a                	jmp    8026b0 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802666:	83 ec 0c             	sub    $0xc,%esp
  802669:	ff 75 08             	pushl  0x8(%ebp)
  80266c:	e8 fa 19 00 00       	call   80406b <alloc_block_NF>
  802671:	83 c4 10             	add    $0x10,%esp
  802674:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802677:	eb 37                	jmp    8026b0 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802679:	83 ec 0c             	sub    $0xc,%esp
  80267c:	ff 75 08             	pushl  0x8(%ebp)
  80267f:	e8 a7 07 00 00       	call   802e2b <alloc_block_BF>
  802684:	83 c4 10             	add    $0x10,%esp
  802687:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80268a:	eb 24                	jmp    8026b0 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80268c:	83 ec 0c             	sub    $0xc,%esp
  80268f:	ff 75 08             	pushl  0x8(%ebp)
  802692:	e8 b7 19 00 00       	call   80404e <alloc_block_WF>
  802697:	83 c4 10             	add    $0x10,%esp
  80269a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80269d:	eb 11                	jmp    8026b0 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80269f:	83 ec 0c             	sub    $0xc,%esp
  8026a2:	68 ac 4b 80 00       	push   $0x804bac
  8026a7:	e8 56 e4 ff ff       	call   800b02 <cprintf>
  8026ac:	83 c4 10             	add    $0x10,%esp
		break;
  8026af:	90                   	nop
	}
	return va;
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8026b3:	c9                   	leave  
  8026b4:	c3                   	ret    

008026b5 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
  8026b8:	53                   	push   %ebx
  8026b9:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8026bc:	83 ec 0c             	sub    $0xc,%esp
  8026bf:	68 cc 4b 80 00       	push   $0x804bcc
  8026c4:	e8 39 e4 ff ff       	call   800b02 <cprintf>
  8026c9:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8026cc:	83 ec 0c             	sub    $0xc,%esp
  8026cf:	68 f7 4b 80 00       	push   $0x804bf7
  8026d4:	e8 29 e4 ff ff       	call   800b02 <cprintf>
  8026d9:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8026dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e2:	eb 37                	jmp    80271b <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8026e4:	83 ec 0c             	sub    $0xc,%esp
  8026e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8026ea:	e8 19 ff ff ff       	call   802608 <is_free_block>
  8026ef:	83 c4 10             	add    $0x10,%esp
  8026f2:	0f be d8             	movsbl %al,%ebx
  8026f5:	83 ec 0c             	sub    $0xc,%esp
  8026f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8026fb:	e8 ef fe ff ff       	call   8025ef <get_block_size>
  802700:	83 c4 10             	add    $0x10,%esp
  802703:	83 ec 04             	sub    $0x4,%esp
  802706:	53                   	push   %ebx
  802707:	50                   	push   %eax
  802708:	68 0f 4c 80 00       	push   $0x804c0f
  80270d:	e8 f0 e3 ff ff       	call   800b02 <cprintf>
  802712:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802715:	8b 45 10             	mov    0x10(%ebp),%eax
  802718:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271f:	74 07                	je     802728 <print_blocks_list+0x73>
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 00                	mov    (%eax),%eax
  802726:	eb 05                	jmp    80272d <print_blocks_list+0x78>
  802728:	b8 00 00 00 00       	mov    $0x0,%eax
  80272d:	89 45 10             	mov    %eax,0x10(%ebp)
  802730:	8b 45 10             	mov    0x10(%ebp),%eax
  802733:	85 c0                	test   %eax,%eax
  802735:	75 ad                	jne    8026e4 <print_blocks_list+0x2f>
  802737:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273b:	75 a7                	jne    8026e4 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80273d:	83 ec 0c             	sub    $0xc,%esp
  802740:	68 cc 4b 80 00       	push   $0x804bcc
  802745:	e8 b8 e3 ff ff       	call   800b02 <cprintf>
  80274a:	83 c4 10             	add    $0x10,%esp

}
  80274d:	90                   	nop
  80274e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802751:	c9                   	leave  
  802752:	c3                   	ret    

00802753 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802753:	55                   	push   %ebp
  802754:	89 e5                	mov    %esp,%ebp
  802756:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802759:	8b 45 0c             	mov    0xc(%ebp),%eax
  80275c:	83 e0 01             	and    $0x1,%eax
  80275f:	85 c0                	test   %eax,%eax
  802761:	74 03                	je     802766 <initialize_dynamic_allocator+0x13>
  802763:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802766:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80276a:	0f 84 c7 01 00 00    	je     802937 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802770:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802777:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80277a:	8b 55 08             	mov    0x8(%ebp),%edx
  80277d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802780:	01 d0                	add    %edx,%eax
  802782:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802787:	0f 87 ad 01 00 00    	ja     80293a <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80278d:	8b 45 08             	mov    0x8(%ebp),%eax
  802790:	85 c0                	test   %eax,%eax
  802792:	0f 89 a5 01 00 00    	jns    80293d <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802798:	8b 55 08             	mov    0x8(%ebp),%edx
  80279b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80279e:	01 d0                	add    %edx,%eax
  8027a0:	83 e8 04             	sub    $0x4,%eax
  8027a3:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8027a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8027af:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b7:	e9 87 00 00 00       	jmp    802843 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8027bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c0:	75 14                	jne    8027d6 <initialize_dynamic_allocator+0x83>
  8027c2:	83 ec 04             	sub    $0x4,%esp
  8027c5:	68 27 4c 80 00       	push   $0x804c27
  8027ca:	6a 79                	push   $0x79
  8027cc:	68 45 4c 80 00       	push   $0x804c45
  8027d1:	e8 6f e0 ff ff       	call   800845 <_panic>
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 00                	mov    (%eax),%eax
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	74 10                	je     8027ef <initialize_dynamic_allocator+0x9c>
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e7:	8b 52 04             	mov    0x4(%edx),%edx
  8027ea:	89 50 04             	mov    %edx,0x4(%eax)
  8027ed:	eb 0b                	jmp    8027fa <initialize_dynamic_allocator+0xa7>
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 40 04             	mov    0x4(%eax),%eax
  8027f5:	a3 30 50 80 00       	mov    %eax,0x805030
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	8b 40 04             	mov    0x4(%eax),%eax
  802800:	85 c0                	test   %eax,%eax
  802802:	74 0f                	je     802813 <initialize_dynamic_allocator+0xc0>
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 40 04             	mov    0x4(%eax),%eax
  80280a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80280d:	8b 12                	mov    (%edx),%edx
  80280f:	89 10                	mov    %edx,(%eax)
  802811:	eb 0a                	jmp    80281d <initialize_dynamic_allocator+0xca>
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	8b 00                	mov    (%eax),%eax
  802818:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802830:	a1 38 50 80 00       	mov    0x805038,%eax
  802835:	48                   	dec    %eax
  802836:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80283b:	a1 34 50 80 00       	mov    0x805034,%eax
  802840:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802843:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802847:	74 07                	je     802850 <initialize_dynamic_allocator+0xfd>
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 00                	mov    (%eax),%eax
  80284e:	eb 05                	jmp    802855 <initialize_dynamic_allocator+0x102>
  802850:	b8 00 00 00 00       	mov    $0x0,%eax
  802855:	a3 34 50 80 00       	mov    %eax,0x805034
  80285a:	a1 34 50 80 00       	mov    0x805034,%eax
  80285f:	85 c0                	test   %eax,%eax
  802861:	0f 85 55 ff ff ff    	jne    8027bc <initialize_dynamic_allocator+0x69>
  802867:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286b:	0f 85 4b ff ff ff    	jne    8027bc <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802871:	8b 45 08             	mov    0x8(%ebp),%eax
  802874:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802880:	a1 44 50 80 00       	mov    0x805044,%eax
  802885:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80288a:	a1 40 50 80 00       	mov    0x805040,%eax
  80288f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802895:	8b 45 08             	mov    0x8(%ebp),%eax
  802898:	83 c0 08             	add    $0x8,%eax
  80289b:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80289e:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a1:	83 c0 04             	add    $0x4,%eax
  8028a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028a7:	83 ea 08             	sub    $0x8,%edx
  8028aa:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8028ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028af:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b2:	01 d0                	add    %edx,%eax
  8028b4:	83 e8 08             	sub    $0x8,%eax
  8028b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ba:	83 ea 08             	sub    $0x8,%edx
  8028bd:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8028bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8028c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8028d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028d6:	75 17                	jne    8028ef <initialize_dynamic_allocator+0x19c>
  8028d8:	83 ec 04             	sub    $0x4,%esp
  8028db:	68 60 4c 80 00       	push   $0x804c60
  8028e0:	68 90 00 00 00       	push   $0x90
  8028e5:	68 45 4c 80 00       	push   $0x804c45
  8028ea:	e8 56 df ff ff       	call   800845 <_panic>
  8028ef:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8028f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f8:	89 10                	mov    %edx,(%eax)
  8028fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fd:	8b 00                	mov    (%eax),%eax
  8028ff:	85 c0                	test   %eax,%eax
  802901:	74 0d                	je     802910 <initialize_dynamic_allocator+0x1bd>
  802903:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802908:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80290b:	89 50 04             	mov    %edx,0x4(%eax)
  80290e:	eb 08                	jmp    802918 <initialize_dynamic_allocator+0x1c5>
  802910:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802913:	a3 30 50 80 00       	mov    %eax,0x805030
  802918:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802920:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802923:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292a:	a1 38 50 80 00       	mov    0x805038,%eax
  80292f:	40                   	inc    %eax
  802930:	a3 38 50 80 00       	mov    %eax,0x805038
  802935:	eb 07                	jmp    80293e <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802937:	90                   	nop
  802938:	eb 04                	jmp    80293e <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80293a:	90                   	nop
  80293b:	eb 01                	jmp    80293e <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80293d:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80293e:	c9                   	leave  
  80293f:	c3                   	ret    

00802940 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802940:	55                   	push   %ebp
  802941:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802943:	8b 45 10             	mov    0x10(%ebp),%eax
  802946:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802949:	8b 45 08             	mov    0x8(%ebp),%eax
  80294c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80294f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802952:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	83 e8 04             	sub    $0x4,%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	83 e0 fe             	and    $0xfffffffe,%eax
  80295f:	8d 50 f8             	lea    -0x8(%eax),%edx
  802962:	8b 45 08             	mov    0x8(%ebp),%eax
  802965:	01 c2                	add    %eax,%edx
  802967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80296a:	89 02                	mov    %eax,(%edx)
}
  80296c:	90                   	nop
  80296d:	5d                   	pop    %ebp
  80296e:	c3                   	ret    

0080296f <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80296f:	55                   	push   %ebp
  802970:	89 e5                	mov    %esp,%ebp
  802972:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802975:	8b 45 08             	mov    0x8(%ebp),%eax
  802978:	83 e0 01             	and    $0x1,%eax
  80297b:	85 c0                	test   %eax,%eax
  80297d:	74 03                	je     802982 <alloc_block_FF+0x13>
  80297f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802982:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802986:	77 07                	ja     80298f <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802988:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80298f:	a1 24 50 80 00       	mov    0x805024,%eax
  802994:	85 c0                	test   %eax,%eax
  802996:	75 73                	jne    802a0b <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	83 c0 10             	add    $0x10,%eax
  80299e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8029a1:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8029a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ae:	01 d0                	add    %edx,%eax
  8029b0:	48                   	dec    %eax
  8029b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8029b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8029bc:	f7 75 ec             	divl   -0x14(%ebp)
  8029bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c2:	29 d0                	sub    %edx,%eax
  8029c4:	c1 e8 0c             	shr    $0xc,%eax
  8029c7:	83 ec 0c             	sub    $0xc,%esp
  8029ca:	50                   	push   %eax
  8029cb:	e8 d4 f0 ff ff       	call   801aa4 <sbrk>
  8029d0:	83 c4 10             	add    $0x10,%esp
  8029d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8029d6:	83 ec 0c             	sub    $0xc,%esp
  8029d9:	6a 00                	push   $0x0
  8029db:	e8 c4 f0 ff ff       	call   801aa4 <sbrk>
  8029e0:	83 c4 10             	add    $0x10,%esp
  8029e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029e9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8029ec:	83 ec 08             	sub    $0x8,%esp
  8029ef:	50                   	push   %eax
  8029f0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8029f3:	e8 5b fd ff ff       	call   802753 <initialize_dynamic_allocator>
  8029f8:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029fb:	83 ec 0c             	sub    $0xc,%esp
  8029fe:	68 83 4c 80 00       	push   $0x804c83
  802a03:	e8 fa e0 ff ff       	call   800b02 <cprintf>
  802a08:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802a0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a0f:	75 0a                	jne    802a1b <alloc_block_FF+0xac>
	        return NULL;
  802a11:	b8 00 00 00 00       	mov    $0x0,%eax
  802a16:	e9 0e 04 00 00       	jmp    802e29 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802a1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a22:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a2a:	e9 f3 02 00 00       	jmp    802d22 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802a35:	83 ec 0c             	sub    $0xc,%esp
  802a38:	ff 75 bc             	pushl  -0x44(%ebp)
  802a3b:	e8 af fb ff ff       	call   8025ef <get_block_size>
  802a40:	83 c4 10             	add    $0x10,%esp
  802a43:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	83 c0 08             	add    $0x8,%eax
  802a4c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a4f:	0f 87 c5 02 00 00    	ja     802d1a <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	83 c0 18             	add    $0x18,%eax
  802a5b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a5e:	0f 87 19 02 00 00    	ja     802c7d <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802a64:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a67:	2b 45 08             	sub    0x8(%ebp),%eax
  802a6a:	83 e8 08             	sub    $0x8,%eax
  802a6d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802a70:	8b 45 08             	mov    0x8(%ebp),%eax
  802a73:	8d 50 08             	lea    0x8(%eax),%edx
  802a76:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a79:	01 d0                	add    %edx,%eax
  802a7b:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a81:	83 c0 08             	add    $0x8,%eax
  802a84:	83 ec 04             	sub    $0x4,%esp
  802a87:	6a 01                	push   $0x1
  802a89:	50                   	push   %eax
  802a8a:	ff 75 bc             	pushl  -0x44(%ebp)
  802a8d:	e8 ae fe ff ff       	call   802940 <set_block_data>
  802a92:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 40 04             	mov    0x4(%eax),%eax
  802a9b:	85 c0                	test   %eax,%eax
  802a9d:	75 68                	jne    802b07 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a9f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802aa3:	75 17                	jne    802abc <alloc_block_FF+0x14d>
  802aa5:	83 ec 04             	sub    $0x4,%esp
  802aa8:	68 60 4c 80 00       	push   $0x804c60
  802aad:	68 d7 00 00 00       	push   $0xd7
  802ab2:	68 45 4c 80 00       	push   $0x804c45
  802ab7:	e8 89 dd ff ff       	call   800845 <_panic>
  802abc:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802ac2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ac5:	89 10                	mov    %edx,(%eax)
  802ac7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aca:	8b 00                	mov    (%eax),%eax
  802acc:	85 c0                	test   %eax,%eax
  802ace:	74 0d                	je     802add <alloc_block_FF+0x16e>
  802ad0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ad5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ad8:	89 50 04             	mov    %edx,0x4(%eax)
  802adb:	eb 08                	jmp    802ae5 <alloc_block_FF+0x176>
  802add:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ae0:	a3 30 50 80 00       	mov    %eax,0x805030
  802ae5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ae8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802aed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802af0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af7:	a1 38 50 80 00       	mov    0x805038,%eax
  802afc:	40                   	inc    %eax
  802afd:	a3 38 50 80 00       	mov    %eax,0x805038
  802b02:	e9 dc 00 00 00       	jmp    802be3 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 00                	mov    (%eax),%eax
  802b0c:	85 c0                	test   %eax,%eax
  802b0e:	75 65                	jne    802b75 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b10:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b14:	75 17                	jne    802b2d <alloc_block_FF+0x1be>
  802b16:	83 ec 04             	sub    $0x4,%esp
  802b19:	68 94 4c 80 00       	push   $0x804c94
  802b1e:	68 db 00 00 00       	push   $0xdb
  802b23:	68 45 4c 80 00       	push   $0x804c45
  802b28:	e8 18 dd ff ff       	call   800845 <_panic>
  802b2d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b33:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b36:	89 50 04             	mov    %edx,0x4(%eax)
  802b39:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b3c:	8b 40 04             	mov    0x4(%eax),%eax
  802b3f:	85 c0                	test   %eax,%eax
  802b41:	74 0c                	je     802b4f <alloc_block_FF+0x1e0>
  802b43:	a1 30 50 80 00       	mov    0x805030,%eax
  802b48:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b4b:	89 10                	mov    %edx,(%eax)
  802b4d:	eb 08                	jmp    802b57 <alloc_block_FF+0x1e8>
  802b4f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b52:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b57:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b5a:	a3 30 50 80 00       	mov    %eax,0x805030
  802b5f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b68:	a1 38 50 80 00       	mov    0x805038,%eax
  802b6d:	40                   	inc    %eax
  802b6e:	a3 38 50 80 00       	mov    %eax,0x805038
  802b73:	eb 6e                	jmp    802be3 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802b75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b79:	74 06                	je     802b81 <alloc_block_FF+0x212>
  802b7b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b7f:	75 17                	jne    802b98 <alloc_block_FF+0x229>
  802b81:	83 ec 04             	sub    $0x4,%esp
  802b84:	68 b8 4c 80 00       	push   $0x804cb8
  802b89:	68 df 00 00 00       	push   $0xdf
  802b8e:	68 45 4c 80 00       	push   $0x804c45
  802b93:	e8 ad dc ff ff       	call   800845 <_panic>
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	8b 10                	mov    (%eax),%edx
  802b9d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba0:	89 10                	mov    %edx,(%eax)
  802ba2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba5:	8b 00                	mov    (%eax),%eax
  802ba7:	85 c0                	test   %eax,%eax
  802ba9:	74 0b                	je     802bb6 <alloc_block_FF+0x247>
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 00                	mov    (%eax),%eax
  802bb0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bb3:	89 50 04             	mov    %edx,0x4(%eax)
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bbc:	89 10                	mov    %edx,(%eax)
  802bbe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc4:	89 50 04             	mov    %edx,0x4(%eax)
  802bc7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bca:	8b 00                	mov    (%eax),%eax
  802bcc:	85 c0                	test   %eax,%eax
  802bce:	75 08                	jne    802bd8 <alloc_block_FF+0x269>
  802bd0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bd3:	a3 30 50 80 00       	mov    %eax,0x805030
  802bd8:	a1 38 50 80 00       	mov    0x805038,%eax
  802bdd:	40                   	inc    %eax
  802bde:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802be3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be7:	75 17                	jne    802c00 <alloc_block_FF+0x291>
  802be9:	83 ec 04             	sub    $0x4,%esp
  802bec:	68 27 4c 80 00       	push   $0x804c27
  802bf1:	68 e1 00 00 00       	push   $0xe1
  802bf6:	68 45 4c 80 00       	push   $0x804c45
  802bfb:	e8 45 dc ff ff       	call   800845 <_panic>
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 00                	mov    (%eax),%eax
  802c05:	85 c0                	test   %eax,%eax
  802c07:	74 10                	je     802c19 <alloc_block_FF+0x2aa>
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	8b 00                	mov    (%eax),%eax
  802c0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c11:	8b 52 04             	mov    0x4(%edx),%edx
  802c14:	89 50 04             	mov    %edx,0x4(%eax)
  802c17:	eb 0b                	jmp    802c24 <alloc_block_FF+0x2b5>
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 40 04             	mov    0x4(%eax),%eax
  802c1f:	a3 30 50 80 00       	mov    %eax,0x805030
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 40 04             	mov    0x4(%eax),%eax
  802c2a:	85 c0                	test   %eax,%eax
  802c2c:	74 0f                	je     802c3d <alloc_block_FF+0x2ce>
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	8b 40 04             	mov    0x4(%eax),%eax
  802c34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c37:	8b 12                	mov    (%edx),%edx
  802c39:	89 10                	mov    %edx,(%eax)
  802c3b:	eb 0a                	jmp    802c47 <alloc_block_FF+0x2d8>
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 00                	mov    (%eax),%eax
  802c42:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5a:	a1 38 50 80 00       	mov    0x805038,%eax
  802c5f:	48                   	dec    %eax
  802c60:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802c65:	83 ec 04             	sub    $0x4,%esp
  802c68:	6a 00                	push   $0x0
  802c6a:	ff 75 b4             	pushl  -0x4c(%ebp)
  802c6d:	ff 75 b0             	pushl  -0x50(%ebp)
  802c70:	e8 cb fc ff ff       	call   802940 <set_block_data>
  802c75:	83 c4 10             	add    $0x10,%esp
  802c78:	e9 95 00 00 00       	jmp    802d12 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802c7d:	83 ec 04             	sub    $0x4,%esp
  802c80:	6a 01                	push   $0x1
  802c82:	ff 75 b8             	pushl  -0x48(%ebp)
  802c85:	ff 75 bc             	pushl  -0x44(%ebp)
  802c88:	e8 b3 fc ff ff       	call   802940 <set_block_data>
  802c8d:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802c90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c94:	75 17                	jne    802cad <alloc_block_FF+0x33e>
  802c96:	83 ec 04             	sub    $0x4,%esp
  802c99:	68 27 4c 80 00       	push   $0x804c27
  802c9e:	68 e8 00 00 00       	push   $0xe8
  802ca3:	68 45 4c 80 00       	push   $0x804c45
  802ca8:	e8 98 db ff ff       	call   800845 <_panic>
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 00                	mov    (%eax),%eax
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	74 10                	je     802cc6 <alloc_block_FF+0x357>
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cbe:	8b 52 04             	mov    0x4(%edx),%edx
  802cc1:	89 50 04             	mov    %edx,0x4(%eax)
  802cc4:	eb 0b                	jmp    802cd1 <alloc_block_FF+0x362>
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 40 04             	mov    0x4(%eax),%eax
  802ccc:	a3 30 50 80 00       	mov    %eax,0x805030
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 40 04             	mov    0x4(%eax),%eax
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	74 0f                	je     802cea <alloc_block_FF+0x37b>
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 40 04             	mov    0x4(%eax),%eax
  802ce1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce4:	8b 12                	mov    (%edx),%edx
  802ce6:	89 10                	mov    %edx,(%eax)
  802ce8:	eb 0a                	jmp    802cf4 <alloc_block_FF+0x385>
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	8b 00                	mov    (%eax),%eax
  802cef:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d07:	a1 38 50 80 00       	mov    0x805038,%eax
  802d0c:	48                   	dec    %eax
  802d0d:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802d12:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d15:	e9 0f 01 00 00       	jmp    802e29 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802d1a:	a1 34 50 80 00       	mov    0x805034,%eax
  802d1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d26:	74 07                	je     802d2f <alloc_block_FF+0x3c0>
  802d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2b:	8b 00                	mov    (%eax),%eax
  802d2d:	eb 05                	jmp    802d34 <alloc_block_FF+0x3c5>
  802d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d34:	a3 34 50 80 00       	mov    %eax,0x805034
  802d39:	a1 34 50 80 00       	mov    0x805034,%eax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	0f 85 e9 fc ff ff    	jne    802a2f <alloc_block_FF+0xc0>
  802d46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4a:	0f 85 df fc ff ff    	jne    802a2f <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	83 c0 08             	add    $0x8,%eax
  802d56:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d59:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802d60:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d63:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d66:	01 d0                	add    %edx,%eax
  802d68:	48                   	dec    %eax
  802d69:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802d6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d6f:	ba 00 00 00 00       	mov    $0x0,%edx
  802d74:	f7 75 d8             	divl   -0x28(%ebp)
  802d77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d7a:	29 d0                	sub    %edx,%eax
  802d7c:	c1 e8 0c             	shr    $0xc,%eax
  802d7f:	83 ec 0c             	sub    $0xc,%esp
  802d82:	50                   	push   %eax
  802d83:	e8 1c ed ff ff       	call   801aa4 <sbrk>
  802d88:	83 c4 10             	add    $0x10,%esp
  802d8b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802d8e:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802d92:	75 0a                	jne    802d9e <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802d94:	b8 00 00 00 00       	mov    $0x0,%eax
  802d99:	e9 8b 00 00 00       	jmp    802e29 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d9e:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802da5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802da8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dab:	01 d0                	add    %edx,%eax
  802dad:	48                   	dec    %eax
  802dae:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802db1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802db4:	ba 00 00 00 00       	mov    $0x0,%edx
  802db9:	f7 75 cc             	divl   -0x34(%ebp)
  802dbc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802dbf:	29 d0                	sub    %edx,%eax
  802dc1:	8d 50 fc             	lea    -0x4(%eax),%edx
  802dc4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dc7:	01 d0                	add    %edx,%eax
  802dc9:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802dce:	a1 40 50 80 00       	mov    0x805040,%eax
  802dd3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802dd9:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802de0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802de3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802de6:	01 d0                	add    %edx,%eax
  802de8:	48                   	dec    %eax
  802de9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802dec:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802def:	ba 00 00 00 00       	mov    $0x0,%edx
  802df4:	f7 75 c4             	divl   -0x3c(%ebp)
  802df7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dfa:	29 d0                	sub    %edx,%eax
  802dfc:	83 ec 04             	sub    $0x4,%esp
  802dff:	6a 01                	push   $0x1
  802e01:	50                   	push   %eax
  802e02:	ff 75 d0             	pushl  -0x30(%ebp)
  802e05:	e8 36 fb ff ff       	call   802940 <set_block_data>
  802e0a:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802e0d:	83 ec 0c             	sub    $0xc,%esp
  802e10:	ff 75 d0             	pushl  -0x30(%ebp)
  802e13:	e8 1b 0a 00 00       	call   803833 <free_block>
  802e18:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802e1b:	83 ec 0c             	sub    $0xc,%esp
  802e1e:	ff 75 08             	pushl  0x8(%ebp)
  802e21:	e8 49 fb ff ff       	call   80296f <alloc_block_FF>
  802e26:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802e29:	c9                   	leave  
  802e2a:	c3                   	ret    

00802e2b <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802e2b:	55                   	push   %ebp
  802e2c:	89 e5                	mov    %esp,%ebp
  802e2e:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	83 e0 01             	and    $0x1,%eax
  802e37:	85 c0                	test   %eax,%eax
  802e39:	74 03                	je     802e3e <alloc_block_BF+0x13>
  802e3b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802e3e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802e42:	77 07                	ja     802e4b <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802e44:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802e4b:	a1 24 50 80 00       	mov    0x805024,%eax
  802e50:	85 c0                	test   %eax,%eax
  802e52:	75 73                	jne    802ec7 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	83 c0 10             	add    $0x10,%eax
  802e5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802e5d:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802e64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e6a:	01 d0                	add    %edx,%eax
  802e6c:	48                   	dec    %eax
  802e6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802e70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e73:	ba 00 00 00 00       	mov    $0x0,%edx
  802e78:	f7 75 e0             	divl   -0x20(%ebp)
  802e7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e7e:	29 d0                	sub    %edx,%eax
  802e80:	c1 e8 0c             	shr    $0xc,%eax
  802e83:	83 ec 0c             	sub    $0xc,%esp
  802e86:	50                   	push   %eax
  802e87:	e8 18 ec ff ff       	call   801aa4 <sbrk>
  802e8c:	83 c4 10             	add    $0x10,%esp
  802e8f:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802e92:	83 ec 0c             	sub    $0xc,%esp
  802e95:	6a 00                	push   $0x0
  802e97:	e8 08 ec ff ff       	call   801aa4 <sbrk>
  802e9c:	83 c4 10             	add    $0x10,%esp
  802e9f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802ea2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ea5:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802ea8:	83 ec 08             	sub    $0x8,%esp
  802eab:	50                   	push   %eax
  802eac:	ff 75 d8             	pushl  -0x28(%ebp)
  802eaf:	e8 9f f8 ff ff       	call   802753 <initialize_dynamic_allocator>
  802eb4:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802eb7:	83 ec 0c             	sub    $0xc,%esp
  802eba:	68 83 4c 80 00       	push   $0x804c83
  802ebf:	e8 3e dc ff ff       	call   800b02 <cprintf>
  802ec4:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802ec7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802ece:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802ed5:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802edc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802ee3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eeb:	e9 1d 01 00 00       	jmp    80300d <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef3:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802ef6:	83 ec 0c             	sub    $0xc,%esp
  802ef9:	ff 75 a8             	pushl  -0x58(%ebp)
  802efc:	e8 ee f6 ff ff       	call   8025ef <get_block_size>
  802f01:	83 c4 10             	add    $0x10,%esp
  802f04:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	83 c0 08             	add    $0x8,%eax
  802f0d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f10:	0f 87 ef 00 00 00    	ja     803005 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	83 c0 18             	add    $0x18,%eax
  802f1c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f1f:	77 1d                	ja     802f3e <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f24:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f27:	0f 86 d8 00 00 00    	jbe    803005 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802f2d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802f33:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f36:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802f39:	e9 c7 00 00 00       	jmp    803005 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f41:	83 c0 08             	add    $0x8,%eax
  802f44:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f47:	0f 85 9d 00 00 00    	jne    802fea <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802f4d:	83 ec 04             	sub    $0x4,%esp
  802f50:	6a 01                	push   $0x1
  802f52:	ff 75 a4             	pushl  -0x5c(%ebp)
  802f55:	ff 75 a8             	pushl  -0x58(%ebp)
  802f58:	e8 e3 f9 ff ff       	call   802940 <set_block_data>
  802f5d:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802f60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f64:	75 17                	jne    802f7d <alloc_block_BF+0x152>
  802f66:	83 ec 04             	sub    $0x4,%esp
  802f69:	68 27 4c 80 00       	push   $0x804c27
  802f6e:	68 2c 01 00 00       	push   $0x12c
  802f73:	68 45 4c 80 00       	push   $0x804c45
  802f78:	e8 c8 d8 ff ff       	call   800845 <_panic>
  802f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f80:	8b 00                	mov    (%eax),%eax
  802f82:	85 c0                	test   %eax,%eax
  802f84:	74 10                	je     802f96 <alloc_block_BF+0x16b>
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 00                	mov    (%eax),%eax
  802f8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f8e:	8b 52 04             	mov    0x4(%edx),%edx
  802f91:	89 50 04             	mov    %edx,0x4(%eax)
  802f94:	eb 0b                	jmp    802fa1 <alloc_block_BF+0x176>
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	8b 40 04             	mov    0x4(%eax),%eax
  802f9c:	a3 30 50 80 00       	mov    %eax,0x805030
  802fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa4:	8b 40 04             	mov    0x4(%eax),%eax
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	74 0f                	je     802fba <alloc_block_BF+0x18f>
  802fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fae:	8b 40 04             	mov    0x4(%eax),%eax
  802fb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb4:	8b 12                	mov    (%edx),%edx
  802fb6:	89 10                	mov    %edx,(%eax)
  802fb8:	eb 0a                	jmp    802fc4 <alloc_block_BF+0x199>
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	8b 00                	mov    (%eax),%eax
  802fbf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd7:	a1 38 50 80 00       	mov    0x805038,%eax
  802fdc:	48                   	dec    %eax
  802fdd:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802fe2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802fe5:	e9 24 04 00 00       	jmp    80340e <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802fea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fed:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ff0:	76 13                	jbe    803005 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802ff2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802ff9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ffc:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802fff:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803002:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803005:	a1 34 50 80 00       	mov    0x805034,%eax
  80300a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803011:	74 07                	je     80301a <alloc_block_BF+0x1ef>
  803013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803016:	8b 00                	mov    (%eax),%eax
  803018:	eb 05                	jmp    80301f <alloc_block_BF+0x1f4>
  80301a:	b8 00 00 00 00       	mov    $0x0,%eax
  80301f:	a3 34 50 80 00       	mov    %eax,0x805034
  803024:	a1 34 50 80 00       	mov    0x805034,%eax
  803029:	85 c0                	test   %eax,%eax
  80302b:	0f 85 bf fe ff ff    	jne    802ef0 <alloc_block_BF+0xc5>
  803031:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803035:	0f 85 b5 fe ff ff    	jne    802ef0 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80303b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80303f:	0f 84 26 02 00 00    	je     80326b <alloc_block_BF+0x440>
  803045:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803049:	0f 85 1c 02 00 00    	jne    80326b <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80304f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803052:	2b 45 08             	sub    0x8(%ebp),%eax
  803055:	83 e8 08             	sub    $0x8,%eax
  803058:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80305b:	8b 45 08             	mov    0x8(%ebp),%eax
  80305e:	8d 50 08             	lea    0x8(%eax),%edx
  803061:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803064:	01 d0                	add    %edx,%eax
  803066:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	83 c0 08             	add    $0x8,%eax
  80306f:	83 ec 04             	sub    $0x4,%esp
  803072:	6a 01                	push   $0x1
  803074:	50                   	push   %eax
  803075:	ff 75 f0             	pushl  -0x10(%ebp)
  803078:	e8 c3 f8 ff ff       	call   802940 <set_block_data>
  80307d:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803083:	8b 40 04             	mov    0x4(%eax),%eax
  803086:	85 c0                	test   %eax,%eax
  803088:	75 68                	jne    8030f2 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80308a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80308e:	75 17                	jne    8030a7 <alloc_block_BF+0x27c>
  803090:	83 ec 04             	sub    $0x4,%esp
  803093:	68 60 4c 80 00       	push   $0x804c60
  803098:	68 45 01 00 00       	push   $0x145
  80309d:	68 45 4c 80 00       	push   $0x804c45
  8030a2:	e8 9e d7 ff ff       	call   800845 <_panic>
  8030a7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8030ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b0:	89 10                	mov    %edx,(%eax)
  8030b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b5:	8b 00                	mov    (%eax),%eax
  8030b7:	85 c0                	test   %eax,%eax
  8030b9:	74 0d                	je     8030c8 <alloc_block_BF+0x29d>
  8030bb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030c0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030c3:	89 50 04             	mov    %edx,0x4(%eax)
  8030c6:	eb 08                	jmp    8030d0 <alloc_block_BF+0x2a5>
  8030c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8030d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030d3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e2:	a1 38 50 80 00       	mov    0x805038,%eax
  8030e7:	40                   	inc    %eax
  8030e8:	a3 38 50 80 00       	mov    %eax,0x805038
  8030ed:	e9 dc 00 00 00       	jmp    8031ce <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8030f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f5:	8b 00                	mov    (%eax),%eax
  8030f7:	85 c0                	test   %eax,%eax
  8030f9:	75 65                	jne    803160 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030fb:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030ff:	75 17                	jne    803118 <alloc_block_BF+0x2ed>
  803101:	83 ec 04             	sub    $0x4,%esp
  803104:	68 94 4c 80 00       	push   $0x804c94
  803109:	68 4a 01 00 00       	push   $0x14a
  80310e:	68 45 4c 80 00       	push   $0x804c45
  803113:	e8 2d d7 ff ff       	call   800845 <_panic>
  803118:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80311e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803121:	89 50 04             	mov    %edx,0x4(%eax)
  803124:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803127:	8b 40 04             	mov    0x4(%eax),%eax
  80312a:	85 c0                	test   %eax,%eax
  80312c:	74 0c                	je     80313a <alloc_block_BF+0x30f>
  80312e:	a1 30 50 80 00       	mov    0x805030,%eax
  803133:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803136:	89 10                	mov    %edx,(%eax)
  803138:	eb 08                	jmp    803142 <alloc_block_BF+0x317>
  80313a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80313d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803142:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803145:	a3 30 50 80 00       	mov    %eax,0x805030
  80314a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80314d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803153:	a1 38 50 80 00       	mov    0x805038,%eax
  803158:	40                   	inc    %eax
  803159:	a3 38 50 80 00       	mov    %eax,0x805038
  80315e:	eb 6e                	jmp    8031ce <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803160:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803164:	74 06                	je     80316c <alloc_block_BF+0x341>
  803166:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80316a:	75 17                	jne    803183 <alloc_block_BF+0x358>
  80316c:	83 ec 04             	sub    $0x4,%esp
  80316f:	68 b8 4c 80 00       	push   $0x804cb8
  803174:	68 4f 01 00 00       	push   $0x14f
  803179:	68 45 4c 80 00       	push   $0x804c45
  80317e:	e8 c2 d6 ff ff       	call   800845 <_panic>
  803183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803186:	8b 10                	mov    (%eax),%edx
  803188:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80318b:	89 10                	mov    %edx,(%eax)
  80318d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803190:	8b 00                	mov    (%eax),%eax
  803192:	85 c0                	test   %eax,%eax
  803194:	74 0b                	je     8031a1 <alloc_block_BF+0x376>
  803196:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803199:	8b 00                	mov    (%eax),%eax
  80319b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80319e:	89 50 04             	mov    %edx,0x4(%eax)
  8031a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031a7:	89 10                	mov    %edx,(%eax)
  8031a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031af:	89 50 04             	mov    %edx,0x4(%eax)
  8031b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031b5:	8b 00                	mov    (%eax),%eax
  8031b7:	85 c0                	test   %eax,%eax
  8031b9:	75 08                	jne    8031c3 <alloc_block_BF+0x398>
  8031bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031be:	a3 30 50 80 00       	mov    %eax,0x805030
  8031c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8031c8:	40                   	inc    %eax
  8031c9:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8031ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031d2:	75 17                	jne    8031eb <alloc_block_BF+0x3c0>
  8031d4:	83 ec 04             	sub    $0x4,%esp
  8031d7:	68 27 4c 80 00       	push   $0x804c27
  8031dc:	68 51 01 00 00       	push   $0x151
  8031e1:	68 45 4c 80 00       	push   $0x804c45
  8031e6:	e8 5a d6 ff ff       	call   800845 <_panic>
  8031eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ee:	8b 00                	mov    (%eax),%eax
  8031f0:	85 c0                	test   %eax,%eax
  8031f2:	74 10                	je     803204 <alloc_block_BF+0x3d9>
  8031f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f7:	8b 00                	mov    (%eax),%eax
  8031f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031fc:	8b 52 04             	mov    0x4(%edx),%edx
  8031ff:	89 50 04             	mov    %edx,0x4(%eax)
  803202:	eb 0b                	jmp    80320f <alloc_block_BF+0x3e4>
  803204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803207:	8b 40 04             	mov    0x4(%eax),%eax
  80320a:	a3 30 50 80 00       	mov    %eax,0x805030
  80320f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803212:	8b 40 04             	mov    0x4(%eax),%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	74 0f                	je     803228 <alloc_block_BF+0x3fd>
  803219:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321c:	8b 40 04             	mov    0x4(%eax),%eax
  80321f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803222:	8b 12                	mov    (%edx),%edx
  803224:	89 10                	mov    %edx,(%eax)
  803226:	eb 0a                	jmp    803232 <alloc_block_BF+0x407>
  803228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322b:	8b 00                	mov    (%eax),%eax
  80322d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803232:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803235:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803245:	a1 38 50 80 00       	mov    0x805038,%eax
  80324a:	48                   	dec    %eax
  80324b:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  803250:	83 ec 04             	sub    $0x4,%esp
  803253:	6a 00                	push   $0x0
  803255:	ff 75 d0             	pushl  -0x30(%ebp)
  803258:	ff 75 cc             	pushl  -0x34(%ebp)
  80325b:	e8 e0 f6 ff ff       	call   802940 <set_block_data>
  803260:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803266:	e9 a3 01 00 00       	jmp    80340e <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  80326b:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80326f:	0f 85 9d 00 00 00    	jne    803312 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803275:	83 ec 04             	sub    $0x4,%esp
  803278:	6a 01                	push   $0x1
  80327a:	ff 75 ec             	pushl  -0x14(%ebp)
  80327d:	ff 75 f0             	pushl  -0x10(%ebp)
  803280:	e8 bb f6 ff ff       	call   802940 <set_block_data>
  803285:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803288:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80328c:	75 17                	jne    8032a5 <alloc_block_BF+0x47a>
  80328e:	83 ec 04             	sub    $0x4,%esp
  803291:	68 27 4c 80 00       	push   $0x804c27
  803296:	68 58 01 00 00       	push   $0x158
  80329b:	68 45 4c 80 00       	push   $0x804c45
  8032a0:	e8 a0 d5 ff ff       	call   800845 <_panic>
  8032a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a8:	8b 00                	mov    (%eax),%eax
  8032aa:	85 c0                	test   %eax,%eax
  8032ac:	74 10                	je     8032be <alloc_block_BF+0x493>
  8032ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b1:	8b 00                	mov    (%eax),%eax
  8032b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032b6:	8b 52 04             	mov    0x4(%edx),%edx
  8032b9:	89 50 04             	mov    %edx,0x4(%eax)
  8032bc:	eb 0b                	jmp    8032c9 <alloc_block_BF+0x49e>
  8032be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c1:	8b 40 04             	mov    0x4(%eax),%eax
  8032c4:	a3 30 50 80 00       	mov    %eax,0x805030
  8032c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cc:	8b 40 04             	mov    0x4(%eax),%eax
  8032cf:	85 c0                	test   %eax,%eax
  8032d1:	74 0f                	je     8032e2 <alloc_block_BF+0x4b7>
  8032d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d6:	8b 40 04             	mov    0x4(%eax),%eax
  8032d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032dc:	8b 12                	mov    (%edx),%edx
  8032de:	89 10                	mov    %edx,(%eax)
  8032e0:	eb 0a                	jmp    8032ec <alloc_block_BF+0x4c1>
  8032e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e5:	8b 00                	mov    (%eax),%eax
  8032e7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ff:	a1 38 50 80 00       	mov    0x805038,%eax
  803304:	48                   	dec    %eax
  803305:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  80330a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330d:	e9 fc 00 00 00       	jmp    80340e <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803312:	8b 45 08             	mov    0x8(%ebp),%eax
  803315:	83 c0 08             	add    $0x8,%eax
  803318:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80331b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803322:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803325:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803328:	01 d0                	add    %edx,%eax
  80332a:	48                   	dec    %eax
  80332b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80332e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803331:	ba 00 00 00 00       	mov    $0x0,%edx
  803336:	f7 75 c4             	divl   -0x3c(%ebp)
  803339:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80333c:	29 d0                	sub    %edx,%eax
  80333e:	c1 e8 0c             	shr    $0xc,%eax
  803341:	83 ec 0c             	sub    $0xc,%esp
  803344:	50                   	push   %eax
  803345:	e8 5a e7 ff ff       	call   801aa4 <sbrk>
  80334a:	83 c4 10             	add    $0x10,%esp
  80334d:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803350:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803354:	75 0a                	jne    803360 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803356:	b8 00 00 00 00       	mov    $0x0,%eax
  80335b:	e9 ae 00 00 00       	jmp    80340e <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803360:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803367:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80336a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80336d:	01 d0                	add    %edx,%eax
  80336f:	48                   	dec    %eax
  803370:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803373:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803376:	ba 00 00 00 00       	mov    $0x0,%edx
  80337b:	f7 75 b8             	divl   -0x48(%ebp)
  80337e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803381:	29 d0                	sub    %edx,%eax
  803383:	8d 50 fc             	lea    -0x4(%eax),%edx
  803386:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803389:	01 d0                	add    %edx,%eax
  80338b:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  803390:	a1 40 50 80 00       	mov    0x805040,%eax
  803395:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80339b:	83 ec 0c             	sub    $0xc,%esp
  80339e:	68 ec 4c 80 00       	push   $0x804cec
  8033a3:	e8 5a d7 ff ff       	call   800b02 <cprintf>
  8033a8:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8033ab:	83 ec 08             	sub    $0x8,%esp
  8033ae:	ff 75 bc             	pushl  -0x44(%ebp)
  8033b1:	68 f1 4c 80 00       	push   $0x804cf1
  8033b6:	e8 47 d7 ff ff       	call   800b02 <cprintf>
  8033bb:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8033be:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8033c5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033cb:	01 d0                	add    %edx,%eax
  8033cd:	48                   	dec    %eax
  8033ce:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8033d1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8033d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8033d9:	f7 75 b0             	divl   -0x50(%ebp)
  8033dc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8033df:	29 d0                	sub    %edx,%eax
  8033e1:	83 ec 04             	sub    $0x4,%esp
  8033e4:	6a 01                	push   $0x1
  8033e6:	50                   	push   %eax
  8033e7:	ff 75 bc             	pushl  -0x44(%ebp)
  8033ea:	e8 51 f5 ff ff       	call   802940 <set_block_data>
  8033ef:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8033f2:	83 ec 0c             	sub    $0xc,%esp
  8033f5:	ff 75 bc             	pushl  -0x44(%ebp)
  8033f8:	e8 36 04 00 00       	call   803833 <free_block>
  8033fd:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803400:	83 ec 0c             	sub    $0xc,%esp
  803403:	ff 75 08             	pushl  0x8(%ebp)
  803406:	e8 20 fa ff ff       	call   802e2b <alloc_block_BF>
  80340b:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80340e:	c9                   	leave  
  80340f:	c3                   	ret    

00803410 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803410:	55                   	push   %ebp
  803411:	89 e5                	mov    %esp,%ebp
  803413:	53                   	push   %ebx
  803414:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803417:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80341e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803425:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803429:	74 1e                	je     803449 <merging+0x39>
  80342b:	ff 75 08             	pushl  0x8(%ebp)
  80342e:	e8 bc f1 ff ff       	call   8025ef <get_block_size>
  803433:	83 c4 04             	add    $0x4,%esp
  803436:	89 c2                	mov    %eax,%edx
  803438:	8b 45 08             	mov    0x8(%ebp),%eax
  80343b:	01 d0                	add    %edx,%eax
  80343d:	3b 45 10             	cmp    0x10(%ebp),%eax
  803440:	75 07                	jne    803449 <merging+0x39>
		prev_is_free = 1;
  803442:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803449:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80344d:	74 1e                	je     80346d <merging+0x5d>
  80344f:	ff 75 10             	pushl  0x10(%ebp)
  803452:	e8 98 f1 ff ff       	call   8025ef <get_block_size>
  803457:	83 c4 04             	add    $0x4,%esp
  80345a:	89 c2                	mov    %eax,%edx
  80345c:	8b 45 10             	mov    0x10(%ebp),%eax
  80345f:	01 d0                	add    %edx,%eax
  803461:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803464:	75 07                	jne    80346d <merging+0x5d>
		next_is_free = 1;
  803466:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80346d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803471:	0f 84 cc 00 00 00    	je     803543 <merging+0x133>
  803477:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80347b:	0f 84 c2 00 00 00    	je     803543 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803481:	ff 75 08             	pushl  0x8(%ebp)
  803484:	e8 66 f1 ff ff       	call   8025ef <get_block_size>
  803489:	83 c4 04             	add    $0x4,%esp
  80348c:	89 c3                	mov    %eax,%ebx
  80348e:	ff 75 10             	pushl  0x10(%ebp)
  803491:	e8 59 f1 ff ff       	call   8025ef <get_block_size>
  803496:	83 c4 04             	add    $0x4,%esp
  803499:	01 c3                	add    %eax,%ebx
  80349b:	ff 75 0c             	pushl  0xc(%ebp)
  80349e:	e8 4c f1 ff ff       	call   8025ef <get_block_size>
  8034a3:	83 c4 04             	add    $0x4,%esp
  8034a6:	01 d8                	add    %ebx,%eax
  8034a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8034ab:	6a 00                	push   $0x0
  8034ad:	ff 75 ec             	pushl  -0x14(%ebp)
  8034b0:	ff 75 08             	pushl  0x8(%ebp)
  8034b3:	e8 88 f4 ff ff       	call   802940 <set_block_data>
  8034b8:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8034bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034bf:	75 17                	jne    8034d8 <merging+0xc8>
  8034c1:	83 ec 04             	sub    $0x4,%esp
  8034c4:	68 27 4c 80 00       	push   $0x804c27
  8034c9:	68 7d 01 00 00       	push   $0x17d
  8034ce:	68 45 4c 80 00       	push   $0x804c45
  8034d3:	e8 6d d3 ff ff       	call   800845 <_panic>
  8034d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034db:	8b 00                	mov    (%eax),%eax
  8034dd:	85 c0                	test   %eax,%eax
  8034df:	74 10                	je     8034f1 <merging+0xe1>
  8034e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e4:	8b 00                	mov    (%eax),%eax
  8034e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034e9:	8b 52 04             	mov    0x4(%edx),%edx
  8034ec:	89 50 04             	mov    %edx,0x4(%eax)
  8034ef:	eb 0b                	jmp    8034fc <merging+0xec>
  8034f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f4:	8b 40 04             	mov    0x4(%eax),%eax
  8034f7:	a3 30 50 80 00       	mov    %eax,0x805030
  8034fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ff:	8b 40 04             	mov    0x4(%eax),%eax
  803502:	85 c0                	test   %eax,%eax
  803504:	74 0f                	je     803515 <merging+0x105>
  803506:	8b 45 0c             	mov    0xc(%ebp),%eax
  803509:	8b 40 04             	mov    0x4(%eax),%eax
  80350c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80350f:	8b 12                	mov    (%edx),%edx
  803511:	89 10                	mov    %edx,(%eax)
  803513:	eb 0a                	jmp    80351f <merging+0x10f>
  803515:	8b 45 0c             	mov    0xc(%ebp),%eax
  803518:	8b 00                	mov    (%eax),%eax
  80351a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80351f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803522:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803528:	8b 45 0c             	mov    0xc(%ebp),%eax
  80352b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803532:	a1 38 50 80 00       	mov    0x805038,%eax
  803537:	48                   	dec    %eax
  803538:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80353d:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80353e:	e9 ea 02 00 00       	jmp    80382d <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803543:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803547:	74 3b                	je     803584 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803549:	83 ec 0c             	sub    $0xc,%esp
  80354c:	ff 75 08             	pushl  0x8(%ebp)
  80354f:	e8 9b f0 ff ff       	call   8025ef <get_block_size>
  803554:	83 c4 10             	add    $0x10,%esp
  803557:	89 c3                	mov    %eax,%ebx
  803559:	83 ec 0c             	sub    $0xc,%esp
  80355c:	ff 75 10             	pushl  0x10(%ebp)
  80355f:	e8 8b f0 ff ff       	call   8025ef <get_block_size>
  803564:	83 c4 10             	add    $0x10,%esp
  803567:	01 d8                	add    %ebx,%eax
  803569:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80356c:	83 ec 04             	sub    $0x4,%esp
  80356f:	6a 00                	push   $0x0
  803571:	ff 75 e8             	pushl  -0x18(%ebp)
  803574:	ff 75 08             	pushl  0x8(%ebp)
  803577:	e8 c4 f3 ff ff       	call   802940 <set_block_data>
  80357c:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80357f:	e9 a9 02 00 00       	jmp    80382d <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803584:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803588:	0f 84 2d 01 00 00    	je     8036bb <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80358e:	83 ec 0c             	sub    $0xc,%esp
  803591:	ff 75 10             	pushl  0x10(%ebp)
  803594:	e8 56 f0 ff ff       	call   8025ef <get_block_size>
  803599:	83 c4 10             	add    $0x10,%esp
  80359c:	89 c3                	mov    %eax,%ebx
  80359e:	83 ec 0c             	sub    $0xc,%esp
  8035a1:	ff 75 0c             	pushl  0xc(%ebp)
  8035a4:	e8 46 f0 ff ff       	call   8025ef <get_block_size>
  8035a9:	83 c4 10             	add    $0x10,%esp
  8035ac:	01 d8                	add    %ebx,%eax
  8035ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8035b1:	83 ec 04             	sub    $0x4,%esp
  8035b4:	6a 00                	push   $0x0
  8035b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035b9:	ff 75 10             	pushl  0x10(%ebp)
  8035bc:	e8 7f f3 ff ff       	call   802940 <set_block_data>
  8035c1:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8035c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8035c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8035ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035ce:	74 06                	je     8035d6 <merging+0x1c6>
  8035d0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8035d4:	75 17                	jne    8035ed <merging+0x1dd>
  8035d6:	83 ec 04             	sub    $0x4,%esp
  8035d9:	68 00 4d 80 00       	push   $0x804d00
  8035de:	68 8d 01 00 00       	push   $0x18d
  8035e3:	68 45 4c 80 00       	push   $0x804c45
  8035e8:	e8 58 d2 ff ff       	call   800845 <_panic>
  8035ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f0:	8b 50 04             	mov    0x4(%eax),%edx
  8035f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035f6:	89 50 04             	mov    %edx,0x4(%eax)
  8035f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035ff:	89 10                	mov    %edx,(%eax)
  803601:	8b 45 0c             	mov    0xc(%ebp),%eax
  803604:	8b 40 04             	mov    0x4(%eax),%eax
  803607:	85 c0                	test   %eax,%eax
  803609:	74 0d                	je     803618 <merging+0x208>
  80360b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80360e:	8b 40 04             	mov    0x4(%eax),%eax
  803611:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803614:	89 10                	mov    %edx,(%eax)
  803616:	eb 08                	jmp    803620 <merging+0x210>
  803618:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80361b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803620:	8b 45 0c             	mov    0xc(%ebp),%eax
  803623:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803626:	89 50 04             	mov    %edx,0x4(%eax)
  803629:	a1 38 50 80 00       	mov    0x805038,%eax
  80362e:	40                   	inc    %eax
  80362f:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803634:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803638:	75 17                	jne    803651 <merging+0x241>
  80363a:	83 ec 04             	sub    $0x4,%esp
  80363d:	68 27 4c 80 00       	push   $0x804c27
  803642:	68 8e 01 00 00       	push   $0x18e
  803647:	68 45 4c 80 00       	push   $0x804c45
  80364c:	e8 f4 d1 ff ff       	call   800845 <_panic>
  803651:	8b 45 0c             	mov    0xc(%ebp),%eax
  803654:	8b 00                	mov    (%eax),%eax
  803656:	85 c0                	test   %eax,%eax
  803658:	74 10                	je     80366a <merging+0x25a>
  80365a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80365d:	8b 00                	mov    (%eax),%eax
  80365f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803662:	8b 52 04             	mov    0x4(%edx),%edx
  803665:	89 50 04             	mov    %edx,0x4(%eax)
  803668:	eb 0b                	jmp    803675 <merging+0x265>
  80366a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80366d:	8b 40 04             	mov    0x4(%eax),%eax
  803670:	a3 30 50 80 00       	mov    %eax,0x805030
  803675:	8b 45 0c             	mov    0xc(%ebp),%eax
  803678:	8b 40 04             	mov    0x4(%eax),%eax
  80367b:	85 c0                	test   %eax,%eax
  80367d:	74 0f                	je     80368e <merging+0x27e>
  80367f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803682:	8b 40 04             	mov    0x4(%eax),%eax
  803685:	8b 55 0c             	mov    0xc(%ebp),%edx
  803688:	8b 12                	mov    (%edx),%edx
  80368a:	89 10                	mov    %edx,(%eax)
  80368c:	eb 0a                	jmp    803698 <merging+0x288>
  80368e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803691:	8b 00                	mov    (%eax),%eax
  803693:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80369b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ab:	a1 38 50 80 00       	mov    0x805038,%eax
  8036b0:	48                   	dec    %eax
  8036b1:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8036b6:	e9 72 01 00 00       	jmp    80382d <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8036bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8036be:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8036c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036c5:	74 79                	je     803740 <merging+0x330>
  8036c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036cb:	74 73                	je     803740 <merging+0x330>
  8036cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036d1:	74 06                	je     8036d9 <merging+0x2c9>
  8036d3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036d7:	75 17                	jne    8036f0 <merging+0x2e0>
  8036d9:	83 ec 04             	sub    $0x4,%esp
  8036dc:	68 b8 4c 80 00       	push   $0x804cb8
  8036e1:	68 94 01 00 00       	push   $0x194
  8036e6:	68 45 4c 80 00       	push   $0x804c45
  8036eb:	e8 55 d1 ff ff       	call   800845 <_panic>
  8036f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f3:	8b 10                	mov    (%eax),%edx
  8036f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036f8:	89 10                	mov    %edx,(%eax)
  8036fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036fd:	8b 00                	mov    (%eax),%eax
  8036ff:	85 c0                	test   %eax,%eax
  803701:	74 0b                	je     80370e <merging+0x2fe>
  803703:	8b 45 08             	mov    0x8(%ebp),%eax
  803706:	8b 00                	mov    (%eax),%eax
  803708:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80370b:	89 50 04             	mov    %edx,0x4(%eax)
  80370e:	8b 45 08             	mov    0x8(%ebp),%eax
  803711:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803714:	89 10                	mov    %edx,(%eax)
  803716:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803719:	8b 55 08             	mov    0x8(%ebp),%edx
  80371c:	89 50 04             	mov    %edx,0x4(%eax)
  80371f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803722:	8b 00                	mov    (%eax),%eax
  803724:	85 c0                	test   %eax,%eax
  803726:	75 08                	jne    803730 <merging+0x320>
  803728:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80372b:	a3 30 50 80 00       	mov    %eax,0x805030
  803730:	a1 38 50 80 00       	mov    0x805038,%eax
  803735:	40                   	inc    %eax
  803736:	a3 38 50 80 00       	mov    %eax,0x805038
  80373b:	e9 ce 00 00 00       	jmp    80380e <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803740:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803744:	74 65                	je     8037ab <merging+0x39b>
  803746:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80374a:	75 17                	jne    803763 <merging+0x353>
  80374c:	83 ec 04             	sub    $0x4,%esp
  80374f:	68 94 4c 80 00       	push   $0x804c94
  803754:	68 95 01 00 00       	push   $0x195
  803759:	68 45 4c 80 00       	push   $0x804c45
  80375e:	e8 e2 d0 ff ff       	call   800845 <_panic>
  803763:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803769:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80376c:	89 50 04             	mov    %edx,0x4(%eax)
  80376f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803772:	8b 40 04             	mov    0x4(%eax),%eax
  803775:	85 c0                	test   %eax,%eax
  803777:	74 0c                	je     803785 <merging+0x375>
  803779:	a1 30 50 80 00       	mov    0x805030,%eax
  80377e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803781:	89 10                	mov    %edx,(%eax)
  803783:	eb 08                	jmp    80378d <merging+0x37d>
  803785:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803788:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80378d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803790:	a3 30 50 80 00       	mov    %eax,0x805030
  803795:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803798:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80379e:	a1 38 50 80 00       	mov    0x805038,%eax
  8037a3:	40                   	inc    %eax
  8037a4:	a3 38 50 80 00       	mov    %eax,0x805038
  8037a9:	eb 63                	jmp    80380e <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8037ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037af:	75 17                	jne    8037c8 <merging+0x3b8>
  8037b1:	83 ec 04             	sub    $0x4,%esp
  8037b4:	68 60 4c 80 00       	push   $0x804c60
  8037b9:	68 98 01 00 00       	push   $0x198
  8037be:	68 45 4c 80 00       	push   $0x804c45
  8037c3:	e8 7d d0 ff ff       	call   800845 <_panic>
  8037c8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8037ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d1:	89 10                	mov    %edx,(%eax)
  8037d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d6:	8b 00                	mov    (%eax),%eax
  8037d8:	85 c0                	test   %eax,%eax
  8037da:	74 0d                	je     8037e9 <merging+0x3d9>
  8037dc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037e4:	89 50 04             	mov    %edx,0x4(%eax)
  8037e7:	eb 08                	jmp    8037f1 <merging+0x3e1>
  8037e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037ec:	a3 30 50 80 00       	mov    %eax,0x805030
  8037f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803803:	a1 38 50 80 00       	mov    0x805038,%eax
  803808:	40                   	inc    %eax
  803809:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80380e:	83 ec 0c             	sub    $0xc,%esp
  803811:	ff 75 10             	pushl  0x10(%ebp)
  803814:	e8 d6 ed ff ff       	call   8025ef <get_block_size>
  803819:	83 c4 10             	add    $0x10,%esp
  80381c:	83 ec 04             	sub    $0x4,%esp
  80381f:	6a 00                	push   $0x0
  803821:	50                   	push   %eax
  803822:	ff 75 10             	pushl  0x10(%ebp)
  803825:	e8 16 f1 ff ff       	call   802940 <set_block_data>
  80382a:	83 c4 10             	add    $0x10,%esp
	}
}
  80382d:	90                   	nop
  80382e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803831:	c9                   	leave  
  803832:	c3                   	ret    

00803833 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803833:	55                   	push   %ebp
  803834:	89 e5                	mov    %esp,%ebp
  803836:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803839:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80383e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803841:	a1 30 50 80 00       	mov    0x805030,%eax
  803846:	3b 45 08             	cmp    0x8(%ebp),%eax
  803849:	73 1b                	jae    803866 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80384b:	a1 30 50 80 00       	mov    0x805030,%eax
  803850:	83 ec 04             	sub    $0x4,%esp
  803853:	ff 75 08             	pushl  0x8(%ebp)
  803856:	6a 00                	push   $0x0
  803858:	50                   	push   %eax
  803859:	e8 b2 fb ff ff       	call   803410 <merging>
  80385e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803861:	e9 8b 00 00 00       	jmp    8038f1 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803866:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80386b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80386e:	76 18                	jbe    803888 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803870:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803875:	83 ec 04             	sub    $0x4,%esp
  803878:	ff 75 08             	pushl  0x8(%ebp)
  80387b:	50                   	push   %eax
  80387c:	6a 00                	push   $0x0
  80387e:	e8 8d fb ff ff       	call   803410 <merging>
  803883:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803886:	eb 69                	jmp    8038f1 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803888:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80388d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803890:	eb 39                	jmp    8038cb <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803895:	3b 45 08             	cmp    0x8(%ebp),%eax
  803898:	73 29                	jae    8038c3 <free_block+0x90>
  80389a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389d:	8b 00                	mov    (%eax),%eax
  80389f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038a2:	76 1f                	jbe    8038c3 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8038a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a7:	8b 00                	mov    (%eax),%eax
  8038a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8038ac:	83 ec 04             	sub    $0x4,%esp
  8038af:	ff 75 08             	pushl  0x8(%ebp)
  8038b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8038b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8038b8:	e8 53 fb ff ff       	call   803410 <merging>
  8038bd:	83 c4 10             	add    $0x10,%esp
			break;
  8038c0:	90                   	nop
		}
	}
}
  8038c1:	eb 2e                	jmp    8038f1 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8038c3:	a1 34 50 80 00       	mov    0x805034,%eax
  8038c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038cf:	74 07                	je     8038d8 <free_block+0xa5>
  8038d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d4:	8b 00                	mov    (%eax),%eax
  8038d6:	eb 05                	jmp    8038dd <free_block+0xaa>
  8038d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8038dd:	a3 34 50 80 00       	mov    %eax,0x805034
  8038e2:	a1 34 50 80 00       	mov    0x805034,%eax
  8038e7:	85 c0                	test   %eax,%eax
  8038e9:	75 a7                	jne    803892 <free_block+0x5f>
  8038eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038ef:	75 a1                	jne    803892 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038f1:	90                   	nop
  8038f2:	c9                   	leave  
  8038f3:	c3                   	ret    

008038f4 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8038f4:	55                   	push   %ebp
  8038f5:	89 e5                	mov    %esp,%ebp
  8038f7:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8038fa:	ff 75 08             	pushl  0x8(%ebp)
  8038fd:	e8 ed ec ff ff       	call   8025ef <get_block_size>
  803902:	83 c4 04             	add    $0x4,%esp
  803905:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803908:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80390f:	eb 17                	jmp    803928 <copy_data+0x34>
  803911:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803914:	8b 45 0c             	mov    0xc(%ebp),%eax
  803917:	01 c2                	add    %eax,%edx
  803919:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80391c:	8b 45 08             	mov    0x8(%ebp),%eax
  80391f:	01 c8                	add    %ecx,%eax
  803921:	8a 00                	mov    (%eax),%al
  803923:	88 02                	mov    %al,(%edx)
  803925:	ff 45 fc             	incl   -0x4(%ebp)
  803928:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80392b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80392e:	72 e1                	jb     803911 <copy_data+0x1d>
}
  803930:	90                   	nop
  803931:	c9                   	leave  
  803932:	c3                   	ret    

00803933 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803933:	55                   	push   %ebp
  803934:	89 e5                	mov    %esp,%ebp
  803936:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803939:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80393d:	75 23                	jne    803962 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80393f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803943:	74 13                	je     803958 <realloc_block_FF+0x25>
  803945:	83 ec 0c             	sub    $0xc,%esp
  803948:	ff 75 0c             	pushl  0xc(%ebp)
  80394b:	e8 1f f0 ff ff       	call   80296f <alloc_block_FF>
  803950:	83 c4 10             	add    $0x10,%esp
  803953:	e9 f4 06 00 00       	jmp    80404c <realloc_block_FF+0x719>
		return NULL;
  803958:	b8 00 00 00 00       	mov    $0x0,%eax
  80395d:	e9 ea 06 00 00       	jmp    80404c <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803962:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803966:	75 18                	jne    803980 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803968:	83 ec 0c             	sub    $0xc,%esp
  80396b:	ff 75 08             	pushl  0x8(%ebp)
  80396e:	e8 c0 fe ff ff       	call   803833 <free_block>
  803973:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803976:	b8 00 00 00 00       	mov    $0x0,%eax
  80397b:	e9 cc 06 00 00       	jmp    80404c <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803980:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803984:	77 07                	ja     80398d <realloc_block_FF+0x5a>
  803986:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80398d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803990:	83 e0 01             	and    $0x1,%eax
  803993:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803996:	8b 45 0c             	mov    0xc(%ebp),%eax
  803999:	83 c0 08             	add    $0x8,%eax
  80399c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80399f:	83 ec 0c             	sub    $0xc,%esp
  8039a2:	ff 75 08             	pushl  0x8(%ebp)
  8039a5:	e8 45 ec ff ff       	call   8025ef <get_block_size>
  8039aa:	83 c4 10             	add    $0x10,%esp
  8039ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8039b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039b3:	83 e8 08             	sub    $0x8,%eax
  8039b6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8039b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bc:	83 e8 04             	sub    $0x4,%eax
  8039bf:	8b 00                	mov    (%eax),%eax
  8039c1:	83 e0 fe             	and    $0xfffffffe,%eax
  8039c4:	89 c2                	mov    %eax,%edx
  8039c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c9:	01 d0                	add    %edx,%eax
  8039cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8039ce:	83 ec 0c             	sub    $0xc,%esp
  8039d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039d4:	e8 16 ec ff ff       	call   8025ef <get_block_size>
  8039d9:	83 c4 10             	add    $0x10,%esp
  8039dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8039df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039e2:	83 e8 08             	sub    $0x8,%eax
  8039e5:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8039e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039eb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039ee:	75 08                	jne    8039f8 <realloc_block_FF+0xc5>
	{
		 return va;
  8039f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f3:	e9 54 06 00 00       	jmp    80404c <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8039f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039fb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039fe:	0f 83 e5 03 00 00    	jae    803de9 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803a04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a07:	2b 45 0c             	sub    0xc(%ebp),%eax
  803a0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803a0d:	83 ec 0c             	sub    $0xc,%esp
  803a10:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a13:	e8 f0 eb ff ff       	call   802608 <is_free_block>
  803a18:	83 c4 10             	add    $0x10,%esp
  803a1b:	84 c0                	test   %al,%al
  803a1d:	0f 84 3b 01 00 00    	je     803b5e <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803a23:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a26:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a29:	01 d0                	add    %edx,%eax
  803a2b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803a2e:	83 ec 04             	sub    $0x4,%esp
  803a31:	6a 01                	push   $0x1
  803a33:	ff 75 f0             	pushl  -0x10(%ebp)
  803a36:	ff 75 08             	pushl  0x8(%ebp)
  803a39:	e8 02 ef ff ff       	call   802940 <set_block_data>
  803a3e:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803a41:	8b 45 08             	mov    0x8(%ebp),%eax
  803a44:	83 e8 04             	sub    $0x4,%eax
  803a47:	8b 00                	mov    (%eax),%eax
  803a49:	83 e0 fe             	and    $0xfffffffe,%eax
  803a4c:	89 c2                	mov    %eax,%edx
  803a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a51:	01 d0                	add    %edx,%eax
  803a53:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803a56:	83 ec 04             	sub    $0x4,%esp
  803a59:	6a 00                	push   $0x0
  803a5b:	ff 75 cc             	pushl  -0x34(%ebp)
  803a5e:	ff 75 c8             	pushl  -0x38(%ebp)
  803a61:	e8 da ee ff ff       	call   802940 <set_block_data>
  803a66:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a6d:	74 06                	je     803a75 <realloc_block_FF+0x142>
  803a6f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803a73:	75 17                	jne    803a8c <realloc_block_FF+0x159>
  803a75:	83 ec 04             	sub    $0x4,%esp
  803a78:	68 b8 4c 80 00       	push   $0x804cb8
  803a7d:	68 f6 01 00 00       	push   $0x1f6
  803a82:	68 45 4c 80 00       	push   $0x804c45
  803a87:	e8 b9 cd ff ff       	call   800845 <_panic>
  803a8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a8f:	8b 10                	mov    (%eax),%edx
  803a91:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a94:	89 10                	mov    %edx,(%eax)
  803a96:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a99:	8b 00                	mov    (%eax),%eax
  803a9b:	85 c0                	test   %eax,%eax
  803a9d:	74 0b                	je     803aaa <realloc_block_FF+0x177>
  803a9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa2:	8b 00                	mov    (%eax),%eax
  803aa4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803aa7:	89 50 04             	mov    %edx,0x4(%eax)
  803aaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aad:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ab0:	89 10                	mov    %edx,(%eax)
  803ab2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ab5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ab8:	89 50 04             	mov    %edx,0x4(%eax)
  803abb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803abe:	8b 00                	mov    (%eax),%eax
  803ac0:	85 c0                	test   %eax,%eax
  803ac2:	75 08                	jne    803acc <realloc_block_FF+0x199>
  803ac4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ac7:	a3 30 50 80 00       	mov    %eax,0x805030
  803acc:	a1 38 50 80 00       	mov    0x805038,%eax
  803ad1:	40                   	inc    %eax
  803ad2:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803ad7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803adb:	75 17                	jne    803af4 <realloc_block_FF+0x1c1>
  803add:	83 ec 04             	sub    $0x4,%esp
  803ae0:	68 27 4c 80 00       	push   $0x804c27
  803ae5:	68 f7 01 00 00       	push   $0x1f7
  803aea:	68 45 4c 80 00       	push   $0x804c45
  803aef:	e8 51 cd ff ff       	call   800845 <_panic>
  803af4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af7:	8b 00                	mov    (%eax),%eax
  803af9:	85 c0                	test   %eax,%eax
  803afb:	74 10                	je     803b0d <realloc_block_FF+0x1da>
  803afd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b00:	8b 00                	mov    (%eax),%eax
  803b02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b05:	8b 52 04             	mov    0x4(%edx),%edx
  803b08:	89 50 04             	mov    %edx,0x4(%eax)
  803b0b:	eb 0b                	jmp    803b18 <realloc_block_FF+0x1e5>
  803b0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b10:	8b 40 04             	mov    0x4(%eax),%eax
  803b13:	a3 30 50 80 00       	mov    %eax,0x805030
  803b18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1b:	8b 40 04             	mov    0x4(%eax),%eax
  803b1e:	85 c0                	test   %eax,%eax
  803b20:	74 0f                	je     803b31 <realloc_block_FF+0x1fe>
  803b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b25:	8b 40 04             	mov    0x4(%eax),%eax
  803b28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b2b:	8b 12                	mov    (%edx),%edx
  803b2d:	89 10                	mov    %edx,(%eax)
  803b2f:	eb 0a                	jmp    803b3b <realloc_block_FF+0x208>
  803b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b34:	8b 00                	mov    (%eax),%eax
  803b36:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803b3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b4e:	a1 38 50 80 00       	mov    0x805038,%eax
  803b53:	48                   	dec    %eax
  803b54:	a3 38 50 80 00       	mov    %eax,0x805038
  803b59:	e9 83 02 00 00       	jmp    803de1 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803b5e:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803b62:	0f 86 69 02 00 00    	jbe    803dd1 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803b68:	83 ec 04             	sub    $0x4,%esp
  803b6b:	6a 01                	push   $0x1
  803b6d:	ff 75 f0             	pushl  -0x10(%ebp)
  803b70:	ff 75 08             	pushl  0x8(%ebp)
  803b73:	e8 c8 ed ff ff       	call   802940 <set_block_data>
  803b78:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7e:	83 e8 04             	sub    $0x4,%eax
  803b81:	8b 00                	mov    (%eax),%eax
  803b83:	83 e0 fe             	and    $0xfffffffe,%eax
  803b86:	89 c2                	mov    %eax,%edx
  803b88:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8b:	01 d0                	add    %edx,%eax
  803b8d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803b90:	a1 38 50 80 00       	mov    0x805038,%eax
  803b95:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803b98:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b9c:	75 68                	jne    803c06 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b9e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ba2:	75 17                	jne    803bbb <realloc_block_FF+0x288>
  803ba4:	83 ec 04             	sub    $0x4,%esp
  803ba7:	68 60 4c 80 00       	push   $0x804c60
  803bac:	68 06 02 00 00       	push   $0x206
  803bb1:	68 45 4c 80 00       	push   $0x804c45
  803bb6:	e8 8a cc ff ff       	call   800845 <_panic>
  803bbb:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803bc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc4:	89 10                	mov    %edx,(%eax)
  803bc6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc9:	8b 00                	mov    (%eax),%eax
  803bcb:	85 c0                	test   %eax,%eax
  803bcd:	74 0d                	je     803bdc <realloc_block_FF+0x2a9>
  803bcf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803bd4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bd7:	89 50 04             	mov    %edx,0x4(%eax)
  803bda:	eb 08                	jmp    803be4 <realloc_block_FF+0x2b1>
  803bdc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bdf:	a3 30 50 80 00       	mov    %eax,0x805030
  803be4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803bec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bf6:	a1 38 50 80 00       	mov    0x805038,%eax
  803bfb:	40                   	inc    %eax
  803bfc:	a3 38 50 80 00       	mov    %eax,0x805038
  803c01:	e9 b0 01 00 00       	jmp    803db6 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803c06:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803c0b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c0e:	76 68                	jbe    803c78 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c10:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c14:	75 17                	jne    803c2d <realloc_block_FF+0x2fa>
  803c16:	83 ec 04             	sub    $0x4,%esp
  803c19:	68 60 4c 80 00       	push   $0x804c60
  803c1e:	68 0b 02 00 00       	push   $0x20b
  803c23:	68 45 4c 80 00       	push   $0x804c45
  803c28:	e8 18 cc ff ff       	call   800845 <_panic>
  803c2d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803c33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c36:	89 10                	mov    %edx,(%eax)
  803c38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c3b:	8b 00                	mov    (%eax),%eax
  803c3d:	85 c0                	test   %eax,%eax
  803c3f:	74 0d                	je     803c4e <realloc_block_FF+0x31b>
  803c41:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803c46:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c49:	89 50 04             	mov    %edx,0x4(%eax)
  803c4c:	eb 08                	jmp    803c56 <realloc_block_FF+0x323>
  803c4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c51:	a3 30 50 80 00       	mov    %eax,0x805030
  803c56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c59:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c68:	a1 38 50 80 00       	mov    0x805038,%eax
  803c6d:	40                   	inc    %eax
  803c6e:	a3 38 50 80 00       	mov    %eax,0x805038
  803c73:	e9 3e 01 00 00       	jmp    803db6 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803c78:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803c7d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c80:	73 68                	jae    803cea <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c82:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c86:	75 17                	jne    803c9f <realloc_block_FF+0x36c>
  803c88:	83 ec 04             	sub    $0x4,%esp
  803c8b:	68 94 4c 80 00       	push   $0x804c94
  803c90:	68 10 02 00 00       	push   $0x210
  803c95:	68 45 4c 80 00       	push   $0x804c45
  803c9a:	e8 a6 cb ff ff       	call   800845 <_panic>
  803c9f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803ca5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca8:	89 50 04             	mov    %edx,0x4(%eax)
  803cab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cae:	8b 40 04             	mov    0x4(%eax),%eax
  803cb1:	85 c0                	test   %eax,%eax
  803cb3:	74 0c                	je     803cc1 <realloc_block_FF+0x38e>
  803cb5:	a1 30 50 80 00       	mov    0x805030,%eax
  803cba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cbd:	89 10                	mov    %edx,(%eax)
  803cbf:	eb 08                	jmp    803cc9 <realloc_block_FF+0x396>
  803cc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803cc9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ccc:	a3 30 50 80 00       	mov    %eax,0x805030
  803cd1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cda:	a1 38 50 80 00       	mov    0x805038,%eax
  803cdf:	40                   	inc    %eax
  803ce0:	a3 38 50 80 00       	mov    %eax,0x805038
  803ce5:	e9 cc 00 00 00       	jmp    803db6 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803cea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803cf1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803cf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cf9:	e9 8a 00 00 00       	jmp    803d88 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d01:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d04:	73 7a                	jae    803d80 <realloc_block_FF+0x44d>
  803d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d09:	8b 00                	mov    (%eax),%eax
  803d0b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d0e:	73 70                	jae    803d80 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803d10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d14:	74 06                	je     803d1c <realloc_block_FF+0x3e9>
  803d16:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d1a:	75 17                	jne    803d33 <realloc_block_FF+0x400>
  803d1c:	83 ec 04             	sub    $0x4,%esp
  803d1f:	68 b8 4c 80 00       	push   $0x804cb8
  803d24:	68 1a 02 00 00       	push   $0x21a
  803d29:	68 45 4c 80 00       	push   $0x804c45
  803d2e:	e8 12 cb ff ff       	call   800845 <_panic>
  803d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d36:	8b 10                	mov    (%eax),%edx
  803d38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d3b:	89 10                	mov    %edx,(%eax)
  803d3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d40:	8b 00                	mov    (%eax),%eax
  803d42:	85 c0                	test   %eax,%eax
  803d44:	74 0b                	je     803d51 <realloc_block_FF+0x41e>
  803d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d49:	8b 00                	mov    (%eax),%eax
  803d4b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d4e:	89 50 04             	mov    %edx,0x4(%eax)
  803d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d54:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d57:	89 10                	mov    %edx,(%eax)
  803d59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d5f:	89 50 04             	mov    %edx,0x4(%eax)
  803d62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d65:	8b 00                	mov    (%eax),%eax
  803d67:	85 c0                	test   %eax,%eax
  803d69:	75 08                	jne    803d73 <realloc_block_FF+0x440>
  803d6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d6e:	a3 30 50 80 00       	mov    %eax,0x805030
  803d73:	a1 38 50 80 00       	mov    0x805038,%eax
  803d78:	40                   	inc    %eax
  803d79:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803d7e:	eb 36                	jmp    803db6 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803d80:	a1 34 50 80 00       	mov    0x805034,%eax
  803d85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d8c:	74 07                	je     803d95 <realloc_block_FF+0x462>
  803d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d91:	8b 00                	mov    (%eax),%eax
  803d93:	eb 05                	jmp    803d9a <realloc_block_FF+0x467>
  803d95:	b8 00 00 00 00       	mov    $0x0,%eax
  803d9a:	a3 34 50 80 00       	mov    %eax,0x805034
  803d9f:	a1 34 50 80 00       	mov    0x805034,%eax
  803da4:	85 c0                	test   %eax,%eax
  803da6:	0f 85 52 ff ff ff    	jne    803cfe <realloc_block_FF+0x3cb>
  803dac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803db0:	0f 85 48 ff ff ff    	jne    803cfe <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803db6:	83 ec 04             	sub    $0x4,%esp
  803db9:	6a 00                	push   $0x0
  803dbb:	ff 75 d8             	pushl  -0x28(%ebp)
  803dbe:	ff 75 d4             	pushl  -0x2c(%ebp)
  803dc1:	e8 7a eb ff ff       	call   802940 <set_block_data>
  803dc6:	83 c4 10             	add    $0x10,%esp
				return va;
  803dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  803dcc:	e9 7b 02 00 00       	jmp    80404c <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803dd1:	83 ec 0c             	sub    $0xc,%esp
  803dd4:	68 35 4d 80 00       	push   $0x804d35
  803dd9:	e8 24 cd ff ff       	call   800b02 <cprintf>
  803dde:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803de1:	8b 45 08             	mov    0x8(%ebp),%eax
  803de4:	e9 63 02 00 00       	jmp    80404c <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dec:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803def:	0f 86 4d 02 00 00    	jbe    804042 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803df5:	83 ec 0c             	sub    $0xc,%esp
  803df8:	ff 75 e4             	pushl  -0x1c(%ebp)
  803dfb:	e8 08 e8 ff ff       	call   802608 <is_free_block>
  803e00:	83 c4 10             	add    $0x10,%esp
  803e03:	84 c0                	test   %al,%al
  803e05:	0f 84 37 02 00 00    	je     804042 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e0e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803e11:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803e14:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e17:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803e1a:	76 38                	jbe    803e54 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803e1c:	83 ec 0c             	sub    $0xc,%esp
  803e1f:	ff 75 08             	pushl  0x8(%ebp)
  803e22:	e8 0c fa ff ff       	call   803833 <free_block>
  803e27:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803e2a:	83 ec 0c             	sub    $0xc,%esp
  803e2d:	ff 75 0c             	pushl  0xc(%ebp)
  803e30:	e8 3a eb ff ff       	call   80296f <alloc_block_FF>
  803e35:	83 c4 10             	add    $0x10,%esp
  803e38:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803e3b:	83 ec 08             	sub    $0x8,%esp
  803e3e:	ff 75 c0             	pushl  -0x40(%ebp)
  803e41:	ff 75 08             	pushl  0x8(%ebp)
  803e44:	e8 ab fa ff ff       	call   8038f4 <copy_data>
  803e49:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803e4c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803e4f:	e9 f8 01 00 00       	jmp    80404c <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803e54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e57:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803e5a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803e5d:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803e61:	0f 87 a0 00 00 00    	ja     803f07 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803e67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e6b:	75 17                	jne    803e84 <realloc_block_FF+0x551>
  803e6d:	83 ec 04             	sub    $0x4,%esp
  803e70:	68 27 4c 80 00       	push   $0x804c27
  803e75:	68 38 02 00 00       	push   $0x238
  803e7a:	68 45 4c 80 00       	push   $0x804c45
  803e7f:	e8 c1 c9 ff ff       	call   800845 <_panic>
  803e84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e87:	8b 00                	mov    (%eax),%eax
  803e89:	85 c0                	test   %eax,%eax
  803e8b:	74 10                	je     803e9d <realloc_block_FF+0x56a>
  803e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e90:	8b 00                	mov    (%eax),%eax
  803e92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e95:	8b 52 04             	mov    0x4(%edx),%edx
  803e98:	89 50 04             	mov    %edx,0x4(%eax)
  803e9b:	eb 0b                	jmp    803ea8 <realloc_block_FF+0x575>
  803e9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ea0:	8b 40 04             	mov    0x4(%eax),%eax
  803ea3:	a3 30 50 80 00       	mov    %eax,0x805030
  803ea8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eab:	8b 40 04             	mov    0x4(%eax),%eax
  803eae:	85 c0                	test   %eax,%eax
  803eb0:	74 0f                	je     803ec1 <realloc_block_FF+0x58e>
  803eb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb5:	8b 40 04             	mov    0x4(%eax),%eax
  803eb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ebb:	8b 12                	mov    (%edx),%edx
  803ebd:	89 10                	mov    %edx,(%eax)
  803ebf:	eb 0a                	jmp    803ecb <realloc_block_FF+0x598>
  803ec1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec4:	8b 00                	mov    (%eax),%eax
  803ec6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ecb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ece:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ed4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ed7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ede:	a1 38 50 80 00       	mov    0x805038,%eax
  803ee3:	48                   	dec    %eax
  803ee4:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803ee9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803eec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803eef:	01 d0                	add    %edx,%eax
  803ef1:	83 ec 04             	sub    $0x4,%esp
  803ef4:	6a 01                	push   $0x1
  803ef6:	50                   	push   %eax
  803ef7:	ff 75 08             	pushl  0x8(%ebp)
  803efa:	e8 41 ea ff ff       	call   802940 <set_block_data>
  803eff:	83 c4 10             	add    $0x10,%esp
  803f02:	e9 36 01 00 00       	jmp    80403d <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803f07:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f0a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f0d:	01 d0                	add    %edx,%eax
  803f0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803f12:	83 ec 04             	sub    $0x4,%esp
  803f15:	6a 01                	push   $0x1
  803f17:	ff 75 f0             	pushl  -0x10(%ebp)
  803f1a:	ff 75 08             	pushl  0x8(%ebp)
  803f1d:	e8 1e ea ff ff       	call   802940 <set_block_data>
  803f22:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803f25:	8b 45 08             	mov    0x8(%ebp),%eax
  803f28:	83 e8 04             	sub    $0x4,%eax
  803f2b:	8b 00                	mov    (%eax),%eax
  803f2d:	83 e0 fe             	and    $0xfffffffe,%eax
  803f30:	89 c2                	mov    %eax,%edx
  803f32:	8b 45 08             	mov    0x8(%ebp),%eax
  803f35:	01 d0                	add    %edx,%eax
  803f37:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803f3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f3e:	74 06                	je     803f46 <realloc_block_FF+0x613>
  803f40:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803f44:	75 17                	jne    803f5d <realloc_block_FF+0x62a>
  803f46:	83 ec 04             	sub    $0x4,%esp
  803f49:	68 b8 4c 80 00       	push   $0x804cb8
  803f4e:	68 44 02 00 00       	push   $0x244
  803f53:	68 45 4c 80 00       	push   $0x804c45
  803f58:	e8 e8 c8 ff ff       	call   800845 <_panic>
  803f5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f60:	8b 10                	mov    (%eax),%edx
  803f62:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f65:	89 10                	mov    %edx,(%eax)
  803f67:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f6a:	8b 00                	mov    (%eax),%eax
  803f6c:	85 c0                	test   %eax,%eax
  803f6e:	74 0b                	je     803f7b <realloc_block_FF+0x648>
  803f70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f73:	8b 00                	mov    (%eax),%eax
  803f75:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f78:	89 50 04             	mov    %edx,0x4(%eax)
  803f7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f7e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f81:	89 10                	mov    %edx,(%eax)
  803f83:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f89:	89 50 04             	mov    %edx,0x4(%eax)
  803f8c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f8f:	8b 00                	mov    (%eax),%eax
  803f91:	85 c0                	test   %eax,%eax
  803f93:	75 08                	jne    803f9d <realloc_block_FF+0x66a>
  803f95:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f98:	a3 30 50 80 00       	mov    %eax,0x805030
  803f9d:	a1 38 50 80 00       	mov    0x805038,%eax
  803fa2:	40                   	inc    %eax
  803fa3:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803fa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fac:	75 17                	jne    803fc5 <realloc_block_FF+0x692>
  803fae:	83 ec 04             	sub    $0x4,%esp
  803fb1:	68 27 4c 80 00       	push   $0x804c27
  803fb6:	68 45 02 00 00       	push   $0x245
  803fbb:	68 45 4c 80 00       	push   $0x804c45
  803fc0:	e8 80 c8 ff ff       	call   800845 <_panic>
  803fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc8:	8b 00                	mov    (%eax),%eax
  803fca:	85 c0                	test   %eax,%eax
  803fcc:	74 10                	je     803fde <realloc_block_FF+0x6ab>
  803fce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd1:	8b 00                	mov    (%eax),%eax
  803fd3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fd6:	8b 52 04             	mov    0x4(%edx),%edx
  803fd9:	89 50 04             	mov    %edx,0x4(%eax)
  803fdc:	eb 0b                	jmp    803fe9 <realloc_block_FF+0x6b6>
  803fde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe1:	8b 40 04             	mov    0x4(%eax),%eax
  803fe4:	a3 30 50 80 00       	mov    %eax,0x805030
  803fe9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fec:	8b 40 04             	mov    0x4(%eax),%eax
  803fef:	85 c0                	test   %eax,%eax
  803ff1:	74 0f                	je     804002 <realloc_block_FF+0x6cf>
  803ff3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff6:	8b 40 04             	mov    0x4(%eax),%eax
  803ff9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ffc:	8b 12                	mov    (%edx),%edx
  803ffe:	89 10                	mov    %edx,(%eax)
  804000:	eb 0a                	jmp    80400c <realloc_block_FF+0x6d9>
  804002:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804005:	8b 00                	mov    (%eax),%eax
  804007:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80400c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80400f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804015:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804018:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80401f:	a1 38 50 80 00       	mov    0x805038,%eax
  804024:	48                   	dec    %eax
  804025:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80402a:	83 ec 04             	sub    $0x4,%esp
  80402d:	6a 00                	push   $0x0
  80402f:	ff 75 bc             	pushl  -0x44(%ebp)
  804032:	ff 75 b8             	pushl  -0x48(%ebp)
  804035:	e8 06 e9 ff ff       	call   802940 <set_block_data>
  80403a:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80403d:	8b 45 08             	mov    0x8(%ebp),%eax
  804040:	eb 0a                	jmp    80404c <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804042:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804049:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80404c:	c9                   	leave  
  80404d:	c3                   	ret    

0080404e <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80404e:	55                   	push   %ebp
  80404f:	89 e5                	mov    %esp,%ebp
  804051:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804054:	83 ec 04             	sub    $0x4,%esp
  804057:	68 3c 4d 80 00       	push   $0x804d3c
  80405c:	68 58 02 00 00       	push   $0x258
  804061:	68 45 4c 80 00       	push   $0x804c45
  804066:	e8 da c7 ff ff       	call   800845 <_panic>

0080406b <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80406b:	55                   	push   %ebp
  80406c:	89 e5                	mov    %esp,%ebp
  80406e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804071:	83 ec 04             	sub    $0x4,%esp
  804074:	68 64 4d 80 00       	push   $0x804d64
  804079:	68 61 02 00 00       	push   $0x261
  80407e:	68 45 4c 80 00       	push   $0x804c45
  804083:	e8 bd c7 ff ff       	call   800845 <_panic>

00804088 <__udivdi3>:
  804088:	55                   	push   %ebp
  804089:	57                   	push   %edi
  80408a:	56                   	push   %esi
  80408b:	53                   	push   %ebx
  80408c:	83 ec 1c             	sub    $0x1c,%esp
  80408f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804093:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804097:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80409b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80409f:	89 ca                	mov    %ecx,%edx
  8040a1:	89 f8                	mov    %edi,%eax
  8040a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8040a7:	85 f6                	test   %esi,%esi
  8040a9:	75 2d                	jne    8040d8 <__udivdi3+0x50>
  8040ab:	39 cf                	cmp    %ecx,%edi
  8040ad:	77 65                	ja     804114 <__udivdi3+0x8c>
  8040af:	89 fd                	mov    %edi,%ebp
  8040b1:	85 ff                	test   %edi,%edi
  8040b3:	75 0b                	jne    8040c0 <__udivdi3+0x38>
  8040b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8040ba:	31 d2                	xor    %edx,%edx
  8040bc:	f7 f7                	div    %edi
  8040be:	89 c5                	mov    %eax,%ebp
  8040c0:	31 d2                	xor    %edx,%edx
  8040c2:	89 c8                	mov    %ecx,%eax
  8040c4:	f7 f5                	div    %ebp
  8040c6:	89 c1                	mov    %eax,%ecx
  8040c8:	89 d8                	mov    %ebx,%eax
  8040ca:	f7 f5                	div    %ebp
  8040cc:	89 cf                	mov    %ecx,%edi
  8040ce:	89 fa                	mov    %edi,%edx
  8040d0:	83 c4 1c             	add    $0x1c,%esp
  8040d3:	5b                   	pop    %ebx
  8040d4:	5e                   	pop    %esi
  8040d5:	5f                   	pop    %edi
  8040d6:	5d                   	pop    %ebp
  8040d7:	c3                   	ret    
  8040d8:	39 ce                	cmp    %ecx,%esi
  8040da:	77 28                	ja     804104 <__udivdi3+0x7c>
  8040dc:	0f bd fe             	bsr    %esi,%edi
  8040df:	83 f7 1f             	xor    $0x1f,%edi
  8040e2:	75 40                	jne    804124 <__udivdi3+0x9c>
  8040e4:	39 ce                	cmp    %ecx,%esi
  8040e6:	72 0a                	jb     8040f2 <__udivdi3+0x6a>
  8040e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8040ec:	0f 87 9e 00 00 00    	ja     804190 <__udivdi3+0x108>
  8040f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8040f7:	89 fa                	mov    %edi,%edx
  8040f9:	83 c4 1c             	add    $0x1c,%esp
  8040fc:	5b                   	pop    %ebx
  8040fd:	5e                   	pop    %esi
  8040fe:	5f                   	pop    %edi
  8040ff:	5d                   	pop    %ebp
  804100:	c3                   	ret    
  804101:	8d 76 00             	lea    0x0(%esi),%esi
  804104:	31 ff                	xor    %edi,%edi
  804106:	31 c0                	xor    %eax,%eax
  804108:	89 fa                	mov    %edi,%edx
  80410a:	83 c4 1c             	add    $0x1c,%esp
  80410d:	5b                   	pop    %ebx
  80410e:	5e                   	pop    %esi
  80410f:	5f                   	pop    %edi
  804110:	5d                   	pop    %ebp
  804111:	c3                   	ret    
  804112:	66 90                	xchg   %ax,%ax
  804114:	89 d8                	mov    %ebx,%eax
  804116:	f7 f7                	div    %edi
  804118:	31 ff                	xor    %edi,%edi
  80411a:	89 fa                	mov    %edi,%edx
  80411c:	83 c4 1c             	add    $0x1c,%esp
  80411f:	5b                   	pop    %ebx
  804120:	5e                   	pop    %esi
  804121:	5f                   	pop    %edi
  804122:	5d                   	pop    %ebp
  804123:	c3                   	ret    
  804124:	bd 20 00 00 00       	mov    $0x20,%ebp
  804129:	89 eb                	mov    %ebp,%ebx
  80412b:	29 fb                	sub    %edi,%ebx
  80412d:	89 f9                	mov    %edi,%ecx
  80412f:	d3 e6                	shl    %cl,%esi
  804131:	89 c5                	mov    %eax,%ebp
  804133:	88 d9                	mov    %bl,%cl
  804135:	d3 ed                	shr    %cl,%ebp
  804137:	89 e9                	mov    %ebp,%ecx
  804139:	09 f1                	or     %esi,%ecx
  80413b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80413f:	89 f9                	mov    %edi,%ecx
  804141:	d3 e0                	shl    %cl,%eax
  804143:	89 c5                	mov    %eax,%ebp
  804145:	89 d6                	mov    %edx,%esi
  804147:	88 d9                	mov    %bl,%cl
  804149:	d3 ee                	shr    %cl,%esi
  80414b:	89 f9                	mov    %edi,%ecx
  80414d:	d3 e2                	shl    %cl,%edx
  80414f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804153:	88 d9                	mov    %bl,%cl
  804155:	d3 e8                	shr    %cl,%eax
  804157:	09 c2                	or     %eax,%edx
  804159:	89 d0                	mov    %edx,%eax
  80415b:	89 f2                	mov    %esi,%edx
  80415d:	f7 74 24 0c          	divl   0xc(%esp)
  804161:	89 d6                	mov    %edx,%esi
  804163:	89 c3                	mov    %eax,%ebx
  804165:	f7 e5                	mul    %ebp
  804167:	39 d6                	cmp    %edx,%esi
  804169:	72 19                	jb     804184 <__udivdi3+0xfc>
  80416b:	74 0b                	je     804178 <__udivdi3+0xf0>
  80416d:	89 d8                	mov    %ebx,%eax
  80416f:	31 ff                	xor    %edi,%edi
  804171:	e9 58 ff ff ff       	jmp    8040ce <__udivdi3+0x46>
  804176:	66 90                	xchg   %ax,%ax
  804178:	8b 54 24 08          	mov    0x8(%esp),%edx
  80417c:	89 f9                	mov    %edi,%ecx
  80417e:	d3 e2                	shl    %cl,%edx
  804180:	39 c2                	cmp    %eax,%edx
  804182:	73 e9                	jae    80416d <__udivdi3+0xe5>
  804184:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804187:	31 ff                	xor    %edi,%edi
  804189:	e9 40 ff ff ff       	jmp    8040ce <__udivdi3+0x46>
  80418e:	66 90                	xchg   %ax,%ax
  804190:	31 c0                	xor    %eax,%eax
  804192:	e9 37 ff ff ff       	jmp    8040ce <__udivdi3+0x46>
  804197:	90                   	nop

00804198 <__umoddi3>:
  804198:	55                   	push   %ebp
  804199:	57                   	push   %edi
  80419a:	56                   	push   %esi
  80419b:	53                   	push   %ebx
  80419c:	83 ec 1c             	sub    $0x1c,%esp
  80419f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8041a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8041a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8041af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8041b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8041b7:	89 f3                	mov    %esi,%ebx
  8041b9:	89 fa                	mov    %edi,%edx
  8041bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041bf:	89 34 24             	mov    %esi,(%esp)
  8041c2:	85 c0                	test   %eax,%eax
  8041c4:	75 1a                	jne    8041e0 <__umoddi3+0x48>
  8041c6:	39 f7                	cmp    %esi,%edi
  8041c8:	0f 86 a2 00 00 00    	jbe    804270 <__umoddi3+0xd8>
  8041ce:	89 c8                	mov    %ecx,%eax
  8041d0:	89 f2                	mov    %esi,%edx
  8041d2:	f7 f7                	div    %edi
  8041d4:	89 d0                	mov    %edx,%eax
  8041d6:	31 d2                	xor    %edx,%edx
  8041d8:	83 c4 1c             	add    $0x1c,%esp
  8041db:	5b                   	pop    %ebx
  8041dc:	5e                   	pop    %esi
  8041dd:	5f                   	pop    %edi
  8041de:	5d                   	pop    %ebp
  8041df:	c3                   	ret    
  8041e0:	39 f0                	cmp    %esi,%eax
  8041e2:	0f 87 ac 00 00 00    	ja     804294 <__umoddi3+0xfc>
  8041e8:	0f bd e8             	bsr    %eax,%ebp
  8041eb:	83 f5 1f             	xor    $0x1f,%ebp
  8041ee:	0f 84 ac 00 00 00    	je     8042a0 <__umoddi3+0x108>
  8041f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8041f9:	29 ef                	sub    %ebp,%edi
  8041fb:	89 fe                	mov    %edi,%esi
  8041fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804201:	89 e9                	mov    %ebp,%ecx
  804203:	d3 e0                	shl    %cl,%eax
  804205:	89 d7                	mov    %edx,%edi
  804207:	89 f1                	mov    %esi,%ecx
  804209:	d3 ef                	shr    %cl,%edi
  80420b:	09 c7                	or     %eax,%edi
  80420d:	89 e9                	mov    %ebp,%ecx
  80420f:	d3 e2                	shl    %cl,%edx
  804211:	89 14 24             	mov    %edx,(%esp)
  804214:	89 d8                	mov    %ebx,%eax
  804216:	d3 e0                	shl    %cl,%eax
  804218:	89 c2                	mov    %eax,%edx
  80421a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80421e:	d3 e0                	shl    %cl,%eax
  804220:	89 44 24 04          	mov    %eax,0x4(%esp)
  804224:	8b 44 24 08          	mov    0x8(%esp),%eax
  804228:	89 f1                	mov    %esi,%ecx
  80422a:	d3 e8                	shr    %cl,%eax
  80422c:	09 d0                	or     %edx,%eax
  80422e:	d3 eb                	shr    %cl,%ebx
  804230:	89 da                	mov    %ebx,%edx
  804232:	f7 f7                	div    %edi
  804234:	89 d3                	mov    %edx,%ebx
  804236:	f7 24 24             	mull   (%esp)
  804239:	89 c6                	mov    %eax,%esi
  80423b:	89 d1                	mov    %edx,%ecx
  80423d:	39 d3                	cmp    %edx,%ebx
  80423f:	0f 82 87 00 00 00    	jb     8042cc <__umoddi3+0x134>
  804245:	0f 84 91 00 00 00    	je     8042dc <__umoddi3+0x144>
  80424b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80424f:	29 f2                	sub    %esi,%edx
  804251:	19 cb                	sbb    %ecx,%ebx
  804253:	89 d8                	mov    %ebx,%eax
  804255:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804259:	d3 e0                	shl    %cl,%eax
  80425b:	89 e9                	mov    %ebp,%ecx
  80425d:	d3 ea                	shr    %cl,%edx
  80425f:	09 d0                	or     %edx,%eax
  804261:	89 e9                	mov    %ebp,%ecx
  804263:	d3 eb                	shr    %cl,%ebx
  804265:	89 da                	mov    %ebx,%edx
  804267:	83 c4 1c             	add    $0x1c,%esp
  80426a:	5b                   	pop    %ebx
  80426b:	5e                   	pop    %esi
  80426c:	5f                   	pop    %edi
  80426d:	5d                   	pop    %ebp
  80426e:	c3                   	ret    
  80426f:	90                   	nop
  804270:	89 fd                	mov    %edi,%ebp
  804272:	85 ff                	test   %edi,%edi
  804274:	75 0b                	jne    804281 <__umoddi3+0xe9>
  804276:	b8 01 00 00 00       	mov    $0x1,%eax
  80427b:	31 d2                	xor    %edx,%edx
  80427d:	f7 f7                	div    %edi
  80427f:	89 c5                	mov    %eax,%ebp
  804281:	89 f0                	mov    %esi,%eax
  804283:	31 d2                	xor    %edx,%edx
  804285:	f7 f5                	div    %ebp
  804287:	89 c8                	mov    %ecx,%eax
  804289:	f7 f5                	div    %ebp
  80428b:	89 d0                	mov    %edx,%eax
  80428d:	e9 44 ff ff ff       	jmp    8041d6 <__umoddi3+0x3e>
  804292:	66 90                	xchg   %ax,%ax
  804294:	89 c8                	mov    %ecx,%eax
  804296:	89 f2                	mov    %esi,%edx
  804298:	83 c4 1c             	add    $0x1c,%esp
  80429b:	5b                   	pop    %ebx
  80429c:	5e                   	pop    %esi
  80429d:	5f                   	pop    %edi
  80429e:	5d                   	pop    %ebp
  80429f:	c3                   	ret    
  8042a0:	3b 04 24             	cmp    (%esp),%eax
  8042a3:	72 06                	jb     8042ab <__umoddi3+0x113>
  8042a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8042a9:	77 0f                	ja     8042ba <__umoddi3+0x122>
  8042ab:	89 f2                	mov    %esi,%edx
  8042ad:	29 f9                	sub    %edi,%ecx
  8042af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8042b3:	89 14 24             	mov    %edx,(%esp)
  8042b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8042be:	8b 14 24             	mov    (%esp),%edx
  8042c1:	83 c4 1c             	add    $0x1c,%esp
  8042c4:	5b                   	pop    %ebx
  8042c5:	5e                   	pop    %esi
  8042c6:	5f                   	pop    %edi
  8042c7:	5d                   	pop    %ebp
  8042c8:	c3                   	ret    
  8042c9:	8d 76 00             	lea    0x0(%esi),%esi
  8042cc:	2b 04 24             	sub    (%esp),%eax
  8042cf:	19 fa                	sbb    %edi,%edx
  8042d1:	89 d1                	mov    %edx,%ecx
  8042d3:	89 c6                	mov    %eax,%esi
  8042d5:	e9 71 ff ff ff       	jmp    80424b <__umoddi3+0xb3>
  8042da:	66 90                	xchg   %ax,%ax
  8042dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8042e0:	72 ea                	jb     8042cc <__umoddi3+0x134>
  8042e2:	89 d9                	mov    %ebx,%ecx
  8042e4:	e9 62 ff ff ff       	jmp    80424b <__umoddi3+0xb3>
