
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
  800041:	e8 03 1c 00 00       	call   801c49 <sys_lock_cons>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 80 24 80 00       	push   $0x802480
  80004e:	e8 bd 0a 00 00       	call   800b10 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 82 24 80 00       	push   $0x802482
  80005e:	e8 ad 0a 00 00       	call   800b10 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 a0 24 80 00       	push   $0x8024a0
  80006e:	e8 9d 0a 00 00       	call   800b10 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 82 24 80 00       	push   $0x802482
  80007e:	e8 8d 0a 00 00       	call   800b10 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 80 24 80 00       	push   $0x802480
  80008e:	e8 7d 0a 00 00       	call   800b10 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 c0 24 80 00       	push   $0x8024c0
  8000a2:	e8 fd 10 00 00       	call   8011a4 <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 df 24 80 00       	push   $0x8024df
  8000b6:	e8 50 1a 00 00       	call   801b0b <smalloc>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 0a                	push   $0xa
  8000c6:	6a 00                	push   $0x0
  8000c8:	8d 45 82             	lea    -0x7e(%ebp),%eax
  8000cb:	50                   	push   %eax
  8000cc:	e8 3b 16 00 00       	call   80170c <strtol>
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
  8000ef:	68 e7 24 80 00       	push   $0x8024e7
  8000f4:	e8 12 1a 00 00       	call   801b0b <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 ec 24 80 00       	push   $0x8024ec
  800107:	e8 04 0a 00 00       	call   800b10 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 0e 25 80 00       	push   $0x80250e
  800117:	e8 f4 09 00 00       	call   800b10 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 1c 25 80 00       	push   $0x80251c
  800127:	e8 e4 09 00 00       	call   800b10 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 2b 25 80 00       	push   $0x80252b
  800137:	e8 d4 09 00 00       	call   800b10 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 3b 25 80 00       	push   $0x80253b
  800147:	e8 c4 09 00 00       	call   800b10 <cprintf>
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
  800186:	e8 d8 1a 00 00       	call   801c63 <sys_unlock_cons>
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
  8001f6:	68 44 25 80 00       	push   $0x802544
  8001fb:	e8 0b 19 00 00       	call   801b0b <smalloc>
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  800206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[2] RUN THE SLAVES PROGRAMS*/
	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  80020f:	a1 04 30 80 00       	mov    0x803004,%eax
  800214:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  80021a:	a1 04 30 80 00       	mov    0x803004,%eax
  80021f:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800225:	89 c1                	mov    %eax,%ecx
  800227:	a1 04 30 80 00       	mov    0x803004,%eax
  80022c:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800232:	52                   	push   %edx
  800233:	51                   	push   %ecx
  800234:	50                   	push   %eax
  800235:	68 52 25 80 00       	push   $0x802552
  80023a:	e8 18 1c 00 00       	call   801e57 <sys_create_env>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800245:	a1 04 30 80 00       	mov    0x803004,%eax
  80024a:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800250:	a1 04 30 80 00       	mov    0x803004,%eax
  800255:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  80025b:	89 c1                	mov    %eax,%ecx
  80025d:	a1 04 30 80 00       	mov    0x803004,%eax
  800262:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800268:	52                   	push   %edx
  800269:	51                   	push   %ecx
  80026a:	50                   	push   %eax
  80026b:	68 5b 25 80 00       	push   $0x80255b
  800270:	e8 e2 1b 00 00       	call   801e57 <sys_create_env>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80027b:	a1 04 30 80 00       	mov    0x803004,%eax
  800280:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800286:	a1 04 30 80 00       	mov    0x803004,%eax
  80028b:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800291:	89 c1                	mov    %eax,%ecx
  800293:	a1 04 30 80 00       	mov    0x803004,%eax
  800298:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80029e:	52                   	push   %edx
  80029f:	51                   	push   %ecx
  8002a0:	50                   	push   %eax
  8002a1:	68 64 25 80 00       	push   $0x802564
  8002a6:	e8 ac 1b 00 00       	call   801e57 <sys_create_env>
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
  8002c6:	68 70 25 80 00       	push   $0x802570
  8002cb:	6a 4e                	push   $0x4e
  8002cd:	68 85 25 80 00       	push   $0x802585
  8002d2:	e8 7c 05 00 00       	call   800853 <_panic>

	sys_run_env(envIdQuickSort);
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	ff 75 dc             	pushl  -0x24(%ebp)
  8002dd:	e8 93 1b 00 00       	call   801e75 <sys_run_env>
  8002e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002eb:	e8 85 1b 00 00       	call   801e75 <sys_run_env>
  8002f0:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f9:	e8 77 1b 00 00       	call   801e75 <sys_run_env>
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
  800340:	68 a3 25 80 00       	push   $0x8025a3
  800345:	ff 75 dc             	pushl  -0x24(%ebp)
  800348:	e8 ed 17 00 00       	call   801b3a <sget>
  80034d:	83 c4 10             	add    $0x10,%esp
  800350:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  800353:	83 ec 08             	sub    $0x8,%esp
  800356:	68 b2 25 80 00       	push   $0x8025b2
  80035b:	ff 75 d8             	pushl  -0x28(%ebp)
  80035e:	e8 d7 17 00 00       	call   801b3a <sget>
  800363:	83 c4 10             	add    $0x10,%esp
  800366:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800369:	83 ec 08             	sub    $0x8,%esp
  80036c:	68 c1 25 80 00       	push   $0x8025c1
  800371:	ff 75 d4             	pushl  -0x2c(%ebp)
  800374:	e8 c1 17 00 00       	call   801b3a <sget>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	68 c6 25 80 00       	push   $0x8025c6
  800387:	ff 75 d4             	pushl  -0x2c(%ebp)
  80038a:	e8 ab 17 00 00       	call   801b3a <sget>
  80038f:	83 c4 10             	add    $0x10,%esp
  800392:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  800395:	83 ec 08             	sub    $0x8,%esp
  800398:	68 ca 25 80 00       	push   $0x8025ca
  80039d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003a0:	e8 95 17 00 00       	call   801b3a <sget>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003ab:	83 ec 08             	sub    $0x8,%esp
  8003ae:	68 ce 25 80 00       	push   $0x8025ce
  8003b3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003b6:	e8 7f 17 00 00       	call   801b3a <sget>
  8003bb:	83 c4 10             	add    $0x10,%esp
  8003be:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	68 d2 25 80 00       	push   $0x8025d2
  8003c9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003cc:	e8 69 17 00 00       	call   801b3a <sget>
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
  8003f4:	68 d8 25 80 00       	push   $0x8025d8
  8003f9:	6a 69                	push   $0x69
  8003fb:	68 85 25 80 00       	push   $0x802585
  800400:	e8 4e 04 00 00       	call   800853 <_panic>
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
  800422:	68 00 26 80 00       	push   $0x802600
  800427:	6a 6b                	push   $0x6b
  800429:	68 85 25 80 00       	push   $0x802585
  80042e:	e8 20 04 00 00       	call   800853 <_panic>
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
  8004d5:	68 28 26 80 00       	push   $0x802628
  8004da:	6a 78                	push   $0x78
  8004dc:	68 85 25 80 00       	push   $0x802585
  8004e1:	e8 6d 03 00 00       	call   800853 <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004e6:	83 ec 0c             	sub    $0xc,%esp
  8004e9:	68 58 26 80 00       	push   $0x802658
  8004ee:	e8 1d 06 00 00       	call   800b10 <cprintf>
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
  8006de:	e8 b1 16 00 00       	call   801d94 <sys_cputc>
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
  8006ef:	e8 3c 15 00 00       	call   801c30 <sys_cgetc>
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
  80070c:	e8 b4 17 00 00       	call   801ec5 <sys_getenvindex>
  800711:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800717:	89 d0                	mov    %edx,%eax
  800719:	c1 e0 06             	shl    $0x6,%eax
  80071c:	29 d0                	sub    %edx,%eax
  80071e:	c1 e0 02             	shl    $0x2,%eax
  800721:	01 d0                	add    %edx,%eax
  800723:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80072a:	01 c8                	add    %ecx,%eax
  80072c:	c1 e0 03             	shl    $0x3,%eax
  80072f:	01 d0                	add    %edx,%eax
  800731:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800738:	29 c2                	sub    %eax,%edx
  80073a:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800741:	89 c2                	mov    %eax,%edx
  800743:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800749:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80074e:	a1 04 30 80 00       	mov    0x803004,%eax
  800753:	8a 40 20             	mov    0x20(%eax),%al
  800756:	84 c0                	test   %al,%al
  800758:	74 0d                	je     800767 <libmain+0x61>
		binaryname = myEnv->prog_name;
  80075a:	a1 04 30 80 00       	mov    0x803004,%eax
  80075f:	83 c0 20             	add    $0x20,%eax
  800762:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800767:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80076b:	7e 0a                	jle    800777 <libmain+0x71>
		binaryname = argv[0];
  80076d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	ff 75 0c             	pushl  0xc(%ebp)
  80077d:	ff 75 08             	pushl  0x8(%ebp)
  800780:	e8 b3 f8 ff ff       	call   800038 <_main>
  800785:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800788:	e8 bc 14 00 00       	call   801c49 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80078d:	83 ec 0c             	sub    $0xc,%esp
  800790:	68 d4 26 80 00       	push   $0x8026d4
  800795:	e8 76 03 00 00       	call   800b10 <cprintf>
  80079a:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80079d:	a1 04 30 80 00       	mov    0x803004,%eax
  8007a2:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8007a8:	a1 04 30 80 00       	mov    0x803004,%eax
  8007ad:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8007b3:	83 ec 04             	sub    $0x4,%esp
  8007b6:	52                   	push   %edx
  8007b7:	50                   	push   %eax
  8007b8:	68 fc 26 80 00       	push   $0x8026fc
  8007bd:	e8 4e 03 00 00       	call   800b10 <cprintf>
  8007c2:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8007c5:	a1 04 30 80 00       	mov    0x803004,%eax
  8007ca:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8007d0:	a1 04 30 80 00       	mov    0x803004,%eax
  8007d5:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8007db:	a1 04 30 80 00       	mov    0x803004,%eax
  8007e0:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8007e6:	51                   	push   %ecx
  8007e7:	52                   	push   %edx
  8007e8:	50                   	push   %eax
  8007e9:	68 24 27 80 00       	push   $0x802724
  8007ee:	e8 1d 03 00 00       	call   800b10 <cprintf>
  8007f3:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007f6:	a1 04 30 80 00       	mov    0x803004,%eax
  8007fb:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	50                   	push   %eax
  800805:	68 7c 27 80 00       	push   $0x80277c
  80080a:	e8 01 03 00 00       	call   800b10 <cprintf>
  80080f:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800812:	83 ec 0c             	sub    $0xc,%esp
  800815:	68 d4 26 80 00       	push   $0x8026d4
  80081a:	e8 f1 02 00 00       	call   800b10 <cprintf>
  80081f:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800822:	e8 3c 14 00 00       	call   801c63 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800827:	e8 19 00 00 00       	call   800845 <exit>
}
  80082c:	90                   	nop
  80082d:	c9                   	leave  
  80082e:	c3                   	ret    

0080082f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800835:	83 ec 0c             	sub    $0xc,%esp
  800838:	6a 00                	push   $0x0
  80083a:	e8 52 16 00 00       	call   801e91 <sys_destroy_env>
  80083f:	83 c4 10             	add    $0x10,%esp
}
  800842:	90                   	nop
  800843:	c9                   	leave  
  800844:	c3                   	ret    

00800845 <exit>:

void
exit(void)
{
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80084b:	e8 a7 16 00 00       	call   801ef7 <sys_exit_env>
}
  800850:	90                   	nop
  800851:	c9                   	leave  
  800852:	c3                   	ret    

00800853 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800859:	8d 45 10             	lea    0x10(%ebp),%eax
  80085c:	83 c0 04             	add    $0x4,%eax
  80085f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800862:	a1 24 30 80 00       	mov    0x803024,%eax
  800867:	85 c0                	test   %eax,%eax
  800869:	74 16                	je     800881 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80086b:	a1 24 30 80 00       	mov    0x803024,%eax
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	50                   	push   %eax
  800874:	68 90 27 80 00       	push   $0x802790
  800879:	e8 92 02 00 00       	call   800b10 <cprintf>
  80087e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800881:	a1 00 30 80 00       	mov    0x803000,%eax
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	ff 75 08             	pushl  0x8(%ebp)
  80088c:	50                   	push   %eax
  80088d:	68 95 27 80 00       	push   $0x802795
  800892:	e8 79 02 00 00       	call   800b10 <cprintf>
  800897:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80089a:	8b 45 10             	mov    0x10(%ebp),%eax
  80089d:	83 ec 08             	sub    $0x8,%esp
  8008a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a3:	50                   	push   %eax
  8008a4:	e8 fc 01 00 00       	call   800aa5 <vcprintf>
  8008a9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	6a 00                	push   $0x0
  8008b1:	68 b1 27 80 00       	push   $0x8027b1
  8008b6:	e8 ea 01 00 00       	call   800aa5 <vcprintf>
  8008bb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008be:	e8 82 ff ff ff       	call   800845 <exit>

	// should not return here
	while (1) ;
  8008c3:	eb fe                	jmp    8008c3 <_panic+0x70>

008008c5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008cb:	a1 04 30 80 00       	mov    0x803004,%eax
  8008d0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d9:	39 c2                	cmp    %eax,%edx
  8008db:	74 14                	je     8008f1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008dd:	83 ec 04             	sub    $0x4,%esp
  8008e0:	68 b4 27 80 00       	push   $0x8027b4
  8008e5:	6a 26                	push   $0x26
  8008e7:	68 00 28 80 00       	push   $0x802800
  8008ec:	e8 62 ff ff ff       	call   800853 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008ff:	e9 c5 00 00 00       	jmp    8009c9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800907:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	01 d0                	add    %edx,%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	85 c0                	test   %eax,%eax
  800917:	75 08                	jne    800921 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800919:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80091c:	e9 a5 00 00 00       	jmp    8009c6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800921:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800928:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80092f:	eb 69                	jmp    80099a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800931:	a1 04 30 80 00       	mov    0x803004,%eax
  800936:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80093c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80093f:	89 d0                	mov    %edx,%eax
  800941:	01 c0                	add    %eax,%eax
  800943:	01 d0                	add    %edx,%eax
  800945:	c1 e0 03             	shl    $0x3,%eax
  800948:	01 c8                	add    %ecx,%eax
  80094a:	8a 40 04             	mov    0x4(%eax),%al
  80094d:	84 c0                	test   %al,%al
  80094f:	75 46                	jne    800997 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800951:	a1 04 30 80 00       	mov    0x803004,%eax
  800956:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80095c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80095f:	89 d0                	mov    %edx,%eax
  800961:	01 c0                	add    %eax,%eax
  800963:	01 d0                	add    %edx,%eax
  800965:	c1 e0 03             	shl    $0x3,%eax
  800968:	01 c8                	add    %ecx,%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80096f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800972:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800977:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800979:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	01 c8                	add    %ecx,%eax
  800988:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80098a:	39 c2                	cmp    %eax,%edx
  80098c:	75 09                	jne    800997 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80098e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800995:	eb 15                	jmp    8009ac <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800997:	ff 45 e8             	incl   -0x18(%ebp)
  80099a:	a1 04 30 80 00       	mov    0x803004,%eax
  80099f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009a8:	39 c2                	cmp    %eax,%edx
  8009aa:	77 85                	ja     800931 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009b0:	75 14                	jne    8009c6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8009b2:	83 ec 04             	sub    $0x4,%esp
  8009b5:	68 0c 28 80 00       	push   $0x80280c
  8009ba:	6a 3a                	push   $0x3a
  8009bc:	68 00 28 80 00       	push   $0x802800
  8009c1:	e8 8d fe ff ff       	call   800853 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009c6:	ff 45 f0             	incl   -0x10(%ebp)
  8009c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009cf:	0f 8c 2f ff ff ff    	jl     800904 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009dc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009e3:	eb 26                	jmp    800a0b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009e5:	a1 04 30 80 00       	mov    0x803004,%eax
  8009ea:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8009f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f3:	89 d0                	mov    %edx,%eax
  8009f5:	01 c0                	add    %eax,%eax
  8009f7:	01 d0                	add    %edx,%eax
  8009f9:	c1 e0 03             	shl    $0x3,%eax
  8009fc:	01 c8                	add    %ecx,%eax
  8009fe:	8a 40 04             	mov    0x4(%eax),%al
  800a01:	3c 01                	cmp    $0x1,%al
  800a03:	75 03                	jne    800a08 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a05:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a08:	ff 45 e0             	incl   -0x20(%ebp)
  800a0b:	a1 04 30 80 00       	mov    0x803004,%eax
  800a10:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a19:	39 c2                	cmp    %eax,%edx
  800a1b:	77 c8                	ja     8009e5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a20:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a23:	74 14                	je     800a39 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a25:	83 ec 04             	sub    $0x4,%esp
  800a28:	68 60 28 80 00       	push   $0x802860
  800a2d:	6a 44                	push   $0x44
  800a2f:	68 00 28 80 00       	push   $0x802800
  800a34:	e8 1a fe ff ff       	call   800853 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a39:	90                   	nop
  800a3a:	c9                   	leave  
  800a3b:	c3                   	ret    

00800a3c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a45:	8b 00                	mov    (%eax),%eax
  800a47:	8d 48 01             	lea    0x1(%eax),%ecx
  800a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4d:	89 0a                	mov    %ecx,(%edx)
  800a4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800a52:	88 d1                	mov    %dl,%cl
  800a54:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a57:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5e:	8b 00                	mov    (%eax),%eax
  800a60:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a65:	75 2c                	jne    800a93 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a67:	a0 08 30 80 00       	mov    0x803008,%al
  800a6c:	0f b6 c0             	movzbl %al,%eax
  800a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a72:	8b 12                	mov    (%edx),%edx
  800a74:	89 d1                	mov    %edx,%ecx
  800a76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a79:	83 c2 08             	add    $0x8,%edx
  800a7c:	83 ec 04             	sub    $0x4,%esp
  800a7f:	50                   	push   %eax
  800a80:	51                   	push   %ecx
  800a81:	52                   	push   %edx
  800a82:	e8 80 11 00 00       	call   801c07 <sys_cputs>
  800a87:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a96:	8b 40 04             	mov    0x4(%eax),%eax
  800a99:	8d 50 01             	lea    0x1(%eax),%edx
  800a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800aa2:	90                   	nop
  800aa3:	c9                   	leave  
  800aa4:	c3                   	ret    

00800aa5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aae:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ab5:	00 00 00 
	b.cnt = 0;
  800ab8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800abf:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	ff 75 08             	pushl  0x8(%ebp)
  800ac8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ace:	50                   	push   %eax
  800acf:	68 3c 0a 80 00       	push   $0x800a3c
  800ad4:	e8 11 02 00 00       	call   800cea <vprintfmt>
  800ad9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800adc:	a0 08 30 80 00       	mov    0x803008,%al
  800ae1:	0f b6 c0             	movzbl %al,%eax
  800ae4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	50                   	push   %eax
  800aee:	52                   	push   %edx
  800aef:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800af5:	83 c0 08             	add    $0x8,%eax
  800af8:	50                   	push   %eax
  800af9:	e8 09 11 00 00       	call   801c07 <sys_cputs>
  800afe:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b01:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800b08:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b0e:	c9                   	leave  
  800b0f:	c3                   	ret    

00800b10 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b16:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800b1d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	ff 75 f4             	pushl  -0xc(%ebp)
  800b2c:	50                   	push   %eax
  800b2d:	e8 73 ff ff ff       	call   800aa5 <vcprintf>
  800b32:	83 c4 10             	add    $0x10,%esp
  800b35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b3b:	c9                   	leave  
  800b3c:	c3                   	ret    

00800b3d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b43:	e8 01 11 00 00       	call   801c49 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b48:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	83 ec 08             	sub    $0x8,%esp
  800b54:	ff 75 f4             	pushl  -0xc(%ebp)
  800b57:	50                   	push   %eax
  800b58:	e8 48 ff ff ff       	call   800aa5 <vcprintf>
  800b5d:	83 c4 10             	add    $0x10,%esp
  800b60:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b63:	e8 fb 10 00 00       	call   801c63 <sys_unlock_cons>
	return cnt;
  800b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b6b:	c9                   	leave  
  800b6c:	c3                   	ret    

00800b6d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	53                   	push   %ebx
  800b71:	83 ec 14             	sub    $0x14,%esp
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b80:	8b 45 18             	mov    0x18(%ebp),%eax
  800b83:	ba 00 00 00 00       	mov    $0x0,%edx
  800b88:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b8b:	77 55                	ja     800be2 <printnum+0x75>
  800b8d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b90:	72 05                	jb     800b97 <printnum+0x2a>
  800b92:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b95:	77 4b                	ja     800be2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b97:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b9a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b9d:	8b 45 18             	mov    0x18(%ebp),%eax
  800ba0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba5:	52                   	push   %edx
  800ba6:	50                   	push   %eax
  800ba7:	ff 75 f4             	pushl  -0xc(%ebp)
  800baa:	ff 75 f0             	pushl  -0x10(%ebp)
  800bad:	e8 5a 16 00 00       	call   80220c <__udivdi3>
  800bb2:	83 c4 10             	add    $0x10,%esp
  800bb5:	83 ec 04             	sub    $0x4,%esp
  800bb8:	ff 75 20             	pushl  0x20(%ebp)
  800bbb:	53                   	push   %ebx
  800bbc:	ff 75 18             	pushl  0x18(%ebp)
  800bbf:	52                   	push   %edx
  800bc0:	50                   	push   %eax
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	ff 75 08             	pushl  0x8(%ebp)
  800bc7:	e8 a1 ff ff ff       	call   800b6d <printnum>
  800bcc:	83 c4 20             	add    $0x20,%esp
  800bcf:	eb 1a                	jmp    800beb <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bd1:	83 ec 08             	sub    $0x8,%esp
  800bd4:	ff 75 0c             	pushl  0xc(%ebp)
  800bd7:	ff 75 20             	pushl  0x20(%ebp)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	ff d0                	call   *%eax
  800bdf:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800be2:	ff 4d 1c             	decl   0x1c(%ebp)
  800be5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800be9:	7f e6                	jg     800bd1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800beb:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bee:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf9:	53                   	push   %ebx
  800bfa:	51                   	push   %ecx
  800bfb:	52                   	push   %edx
  800bfc:	50                   	push   %eax
  800bfd:	e8 1a 17 00 00       	call   80231c <__umoddi3>
  800c02:	83 c4 10             	add    $0x10,%esp
  800c05:	05 d4 2a 80 00       	add    $0x802ad4,%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	0f be c0             	movsbl %al,%eax
  800c0f:	83 ec 08             	sub    $0x8,%esp
  800c12:	ff 75 0c             	pushl  0xc(%ebp)
  800c15:	50                   	push   %eax
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	ff d0                	call   *%eax
  800c1b:	83 c4 10             	add    $0x10,%esp
}
  800c1e:	90                   	nop
  800c1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c27:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c2b:	7e 1c                	jle    800c49 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8b 00                	mov    (%eax),%eax
  800c32:	8d 50 08             	lea    0x8(%eax),%edx
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	89 10                	mov    %edx,(%eax)
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8b 00                	mov    (%eax),%eax
  800c3f:	83 e8 08             	sub    $0x8,%eax
  800c42:	8b 50 04             	mov    0x4(%eax),%edx
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	eb 40                	jmp    800c89 <getuint+0x65>
	else if (lflag)
  800c49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4d:	74 1e                	je     800c6d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8b 00                	mov    (%eax),%eax
  800c54:	8d 50 04             	lea    0x4(%eax),%edx
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	89 10                	mov    %edx,(%eax)
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	8b 00                	mov    (%eax),%eax
  800c61:	83 e8 04             	sub    $0x4,%eax
  800c64:	8b 00                	mov    (%eax),%eax
  800c66:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6b:	eb 1c                	jmp    800c89 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8b 00                	mov    (%eax),%eax
  800c72:	8d 50 04             	lea    0x4(%eax),%edx
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	89 10                	mov    %edx,(%eax)
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8b 00                	mov    (%eax),%eax
  800c7f:	83 e8 04             	sub    $0x4,%eax
  800c82:	8b 00                	mov    (%eax),%eax
  800c84:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    

00800c8b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c8e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c92:	7e 1c                	jle    800cb0 <getint+0x25>
		return va_arg(*ap, long long);
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	8b 00                	mov    (%eax),%eax
  800c99:	8d 50 08             	lea    0x8(%eax),%edx
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	89 10                	mov    %edx,(%eax)
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	8b 00                	mov    (%eax),%eax
  800ca6:	83 e8 08             	sub    $0x8,%eax
  800ca9:	8b 50 04             	mov    0x4(%eax),%edx
  800cac:	8b 00                	mov    (%eax),%eax
  800cae:	eb 38                	jmp    800ce8 <getint+0x5d>
	else if (lflag)
  800cb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb4:	74 1a                	je     800cd0 <getint+0x45>
		return va_arg(*ap, long);
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8b 00                	mov    (%eax),%eax
  800cbb:	8d 50 04             	lea    0x4(%eax),%edx
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	89 10                	mov    %edx,(%eax)
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8b 00                	mov    (%eax),%eax
  800cc8:	83 e8 04             	sub    $0x4,%eax
  800ccb:	8b 00                	mov    (%eax),%eax
  800ccd:	99                   	cltd   
  800cce:	eb 18                	jmp    800ce8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8b 00                	mov    (%eax),%eax
  800cd5:	8d 50 04             	lea    0x4(%eax),%edx
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	89 10                	mov    %edx,(%eax)
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	83 e8 04             	sub    $0x4,%eax
  800ce5:	8b 00                	mov    (%eax),%eax
  800ce7:	99                   	cltd   
}
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	56                   	push   %esi
  800cee:	53                   	push   %ebx
  800cef:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cf2:	eb 17                	jmp    800d0b <vprintfmt+0x21>
			if (ch == '\0')
  800cf4:	85 db                	test   %ebx,%ebx
  800cf6:	0f 84 c1 03 00 00    	je     8010bd <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800cfc:	83 ec 08             	sub    $0x8,%esp
  800cff:	ff 75 0c             	pushl  0xc(%ebp)
  800d02:	53                   	push   %ebx
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	ff d0                	call   *%eax
  800d08:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0e:	8d 50 01             	lea    0x1(%eax),%edx
  800d11:	89 55 10             	mov    %edx,0x10(%ebp)
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	0f b6 d8             	movzbl %al,%ebx
  800d19:	83 fb 25             	cmp    $0x25,%ebx
  800d1c:	75 d6                	jne    800cf4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d1e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d22:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d29:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d30:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d37:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d41:	8d 50 01             	lea    0x1(%eax),%edx
  800d44:	89 55 10             	mov    %edx,0x10(%ebp)
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	0f b6 d8             	movzbl %al,%ebx
  800d4c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d4f:	83 f8 5b             	cmp    $0x5b,%eax
  800d52:	0f 87 3d 03 00 00    	ja     801095 <vprintfmt+0x3ab>
  800d58:	8b 04 85 f8 2a 80 00 	mov    0x802af8(,%eax,4),%eax
  800d5f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d61:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d65:	eb d7                	jmp    800d3e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d67:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d6b:	eb d1                	jmp    800d3e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d6d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d74:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d77:	89 d0                	mov    %edx,%eax
  800d79:	c1 e0 02             	shl    $0x2,%eax
  800d7c:	01 d0                	add    %edx,%eax
  800d7e:	01 c0                	add    %eax,%eax
  800d80:	01 d8                	add    %ebx,%eax
  800d82:	83 e8 30             	sub    $0x30,%eax
  800d85:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d88:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d90:	83 fb 2f             	cmp    $0x2f,%ebx
  800d93:	7e 3e                	jle    800dd3 <vprintfmt+0xe9>
  800d95:	83 fb 39             	cmp    $0x39,%ebx
  800d98:	7f 39                	jg     800dd3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d9a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d9d:	eb d5                	jmp    800d74 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800da2:	83 c0 04             	add    $0x4,%eax
  800da5:	89 45 14             	mov    %eax,0x14(%ebp)
  800da8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dab:	83 e8 04             	sub    $0x4,%eax
  800dae:	8b 00                	mov    (%eax),%eax
  800db0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800db3:	eb 1f                	jmp    800dd4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800db5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db9:	79 83                	jns    800d3e <vprintfmt+0x54>
				width = 0;
  800dbb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800dc2:	e9 77 ff ff ff       	jmp    800d3e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800dc7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800dce:	e9 6b ff ff ff       	jmp    800d3e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800dd3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800dd4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dd8:	0f 89 60 ff ff ff    	jns    800d3e <vprintfmt+0x54>
				width = precision, precision = -1;
  800dde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800de1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800de4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800deb:	e9 4e ff ff ff       	jmp    800d3e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800df0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800df3:	e9 46 ff ff ff       	jmp    800d3e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800df8:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfb:	83 c0 04             	add    $0x4,%eax
  800dfe:	89 45 14             	mov    %eax,0x14(%ebp)
  800e01:	8b 45 14             	mov    0x14(%ebp),%eax
  800e04:	83 e8 04             	sub    $0x4,%eax
  800e07:	8b 00                	mov    (%eax),%eax
  800e09:	83 ec 08             	sub    $0x8,%esp
  800e0c:	ff 75 0c             	pushl  0xc(%ebp)
  800e0f:	50                   	push   %eax
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	ff d0                	call   *%eax
  800e15:	83 c4 10             	add    $0x10,%esp
			break;
  800e18:	e9 9b 02 00 00       	jmp    8010b8 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e20:	83 c0 04             	add    $0x4,%eax
  800e23:	89 45 14             	mov    %eax,0x14(%ebp)
  800e26:	8b 45 14             	mov    0x14(%ebp),%eax
  800e29:	83 e8 04             	sub    $0x4,%eax
  800e2c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e2e:	85 db                	test   %ebx,%ebx
  800e30:	79 02                	jns    800e34 <vprintfmt+0x14a>
				err = -err;
  800e32:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e34:	83 fb 64             	cmp    $0x64,%ebx
  800e37:	7f 0b                	jg     800e44 <vprintfmt+0x15a>
  800e39:	8b 34 9d 40 29 80 00 	mov    0x802940(,%ebx,4),%esi
  800e40:	85 f6                	test   %esi,%esi
  800e42:	75 19                	jne    800e5d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e44:	53                   	push   %ebx
  800e45:	68 e5 2a 80 00       	push   $0x802ae5
  800e4a:	ff 75 0c             	pushl  0xc(%ebp)
  800e4d:	ff 75 08             	pushl  0x8(%ebp)
  800e50:	e8 70 02 00 00       	call   8010c5 <printfmt>
  800e55:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e58:	e9 5b 02 00 00       	jmp    8010b8 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e5d:	56                   	push   %esi
  800e5e:	68 ee 2a 80 00       	push   $0x802aee
  800e63:	ff 75 0c             	pushl  0xc(%ebp)
  800e66:	ff 75 08             	pushl  0x8(%ebp)
  800e69:	e8 57 02 00 00       	call   8010c5 <printfmt>
  800e6e:	83 c4 10             	add    $0x10,%esp
			break;
  800e71:	e9 42 02 00 00       	jmp    8010b8 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e76:	8b 45 14             	mov    0x14(%ebp),%eax
  800e79:	83 c0 04             	add    $0x4,%eax
  800e7c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e82:	83 e8 04             	sub    $0x4,%eax
  800e85:	8b 30                	mov    (%eax),%esi
  800e87:	85 f6                	test   %esi,%esi
  800e89:	75 05                	jne    800e90 <vprintfmt+0x1a6>
				p = "(null)";
  800e8b:	be f1 2a 80 00       	mov    $0x802af1,%esi
			if (width > 0 && padc != '-')
  800e90:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e94:	7e 6d                	jle    800f03 <vprintfmt+0x219>
  800e96:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e9a:	74 67                	je     800f03 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e9f:	83 ec 08             	sub    $0x8,%esp
  800ea2:	50                   	push   %eax
  800ea3:	56                   	push   %esi
  800ea4:	e8 26 05 00 00       	call   8013cf <strnlen>
  800ea9:	83 c4 10             	add    $0x10,%esp
  800eac:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800eaf:	eb 16                	jmp    800ec7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800eb1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800eb5:	83 ec 08             	sub    $0x8,%esp
  800eb8:	ff 75 0c             	pushl  0xc(%ebp)
  800ebb:	50                   	push   %eax
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	ff d0                	call   *%eax
  800ec1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ec4:	ff 4d e4             	decl   -0x1c(%ebp)
  800ec7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ecb:	7f e4                	jg     800eb1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ecd:	eb 34                	jmp    800f03 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ecf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ed3:	74 1c                	je     800ef1 <vprintfmt+0x207>
  800ed5:	83 fb 1f             	cmp    $0x1f,%ebx
  800ed8:	7e 05                	jle    800edf <vprintfmt+0x1f5>
  800eda:	83 fb 7e             	cmp    $0x7e,%ebx
  800edd:	7e 12                	jle    800ef1 <vprintfmt+0x207>
					putch('?', putdat);
  800edf:	83 ec 08             	sub    $0x8,%esp
  800ee2:	ff 75 0c             	pushl  0xc(%ebp)
  800ee5:	6a 3f                	push   $0x3f
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	ff d0                	call   *%eax
  800eec:	83 c4 10             	add    $0x10,%esp
  800eef:	eb 0f                	jmp    800f00 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	ff 75 0c             	pushl  0xc(%ebp)
  800ef7:	53                   	push   %ebx
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	ff d0                	call   *%eax
  800efd:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f00:	ff 4d e4             	decl   -0x1c(%ebp)
  800f03:	89 f0                	mov    %esi,%eax
  800f05:	8d 70 01             	lea    0x1(%eax),%esi
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	0f be d8             	movsbl %al,%ebx
  800f0d:	85 db                	test   %ebx,%ebx
  800f0f:	74 24                	je     800f35 <vprintfmt+0x24b>
  800f11:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f15:	78 b8                	js     800ecf <vprintfmt+0x1e5>
  800f17:	ff 4d e0             	decl   -0x20(%ebp)
  800f1a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f1e:	79 af                	jns    800ecf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f20:	eb 13                	jmp    800f35 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f22:	83 ec 08             	sub    $0x8,%esp
  800f25:	ff 75 0c             	pushl  0xc(%ebp)
  800f28:	6a 20                	push   $0x20
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	ff d0                	call   *%eax
  800f2f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f32:	ff 4d e4             	decl   -0x1c(%ebp)
  800f35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f39:	7f e7                	jg     800f22 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f3b:	e9 78 01 00 00       	jmp    8010b8 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f40:	83 ec 08             	sub    $0x8,%esp
  800f43:	ff 75 e8             	pushl  -0x18(%ebp)
  800f46:	8d 45 14             	lea    0x14(%ebp),%eax
  800f49:	50                   	push   %eax
  800f4a:	e8 3c fd ff ff       	call   800c8b <getint>
  800f4f:	83 c4 10             	add    $0x10,%esp
  800f52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5e:	85 d2                	test   %edx,%edx
  800f60:	79 23                	jns    800f85 <vprintfmt+0x29b>
				putch('-', putdat);
  800f62:	83 ec 08             	sub    $0x8,%esp
  800f65:	ff 75 0c             	pushl  0xc(%ebp)
  800f68:	6a 2d                	push   $0x2d
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	ff d0                	call   *%eax
  800f6f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f78:	f7 d8                	neg    %eax
  800f7a:	83 d2 00             	adc    $0x0,%edx
  800f7d:	f7 da                	neg    %edx
  800f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f85:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f8c:	e9 bc 00 00 00       	jmp    80104d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f91:	83 ec 08             	sub    $0x8,%esp
  800f94:	ff 75 e8             	pushl  -0x18(%ebp)
  800f97:	8d 45 14             	lea    0x14(%ebp),%eax
  800f9a:	50                   	push   %eax
  800f9b:	e8 84 fc ff ff       	call   800c24 <getuint>
  800fa0:	83 c4 10             	add    $0x10,%esp
  800fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fa9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fb0:	e9 98 00 00 00       	jmp    80104d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800fb5:	83 ec 08             	sub    $0x8,%esp
  800fb8:	ff 75 0c             	pushl  0xc(%ebp)
  800fbb:	6a 58                	push   $0x58
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	ff d0                	call   *%eax
  800fc2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fc5:	83 ec 08             	sub    $0x8,%esp
  800fc8:	ff 75 0c             	pushl  0xc(%ebp)
  800fcb:	6a 58                	push   $0x58
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	ff d0                	call   *%eax
  800fd2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fd5:	83 ec 08             	sub    $0x8,%esp
  800fd8:	ff 75 0c             	pushl  0xc(%ebp)
  800fdb:	6a 58                	push   $0x58
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	ff d0                	call   *%eax
  800fe2:	83 c4 10             	add    $0x10,%esp
			break;
  800fe5:	e9 ce 00 00 00       	jmp    8010b8 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800fea:	83 ec 08             	sub    $0x8,%esp
  800fed:	ff 75 0c             	pushl  0xc(%ebp)
  800ff0:	6a 30                	push   $0x30
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	ff d0                	call   *%eax
  800ff7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ffa:	83 ec 08             	sub    $0x8,%esp
  800ffd:	ff 75 0c             	pushl  0xc(%ebp)
  801000:	6a 78                	push   $0x78
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	ff d0                	call   *%eax
  801007:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80100a:	8b 45 14             	mov    0x14(%ebp),%eax
  80100d:	83 c0 04             	add    $0x4,%eax
  801010:	89 45 14             	mov    %eax,0x14(%ebp)
  801013:	8b 45 14             	mov    0x14(%ebp),%eax
  801016:	83 e8 04             	sub    $0x4,%eax
  801019:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80101b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80101e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801025:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80102c:	eb 1f                	jmp    80104d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80102e:	83 ec 08             	sub    $0x8,%esp
  801031:	ff 75 e8             	pushl  -0x18(%ebp)
  801034:	8d 45 14             	lea    0x14(%ebp),%eax
  801037:	50                   	push   %eax
  801038:	e8 e7 fb ff ff       	call   800c24 <getuint>
  80103d:	83 c4 10             	add    $0x10,%esp
  801040:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801043:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801046:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80104d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801051:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801054:	83 ec 04             	sub    $0x4,%esp
  801057:	52                   	push   %edx
  801058:	ff 75 e4             	pushl  -0x1c(%ebp)
  80105b:	50                   	push   %eax
  80105c:	ff 75 f4             	pushl  -0xc(%ebp)
  80105f:	ff 75 f0             	pushl  -0x10(%ebp)
  801062:	ff 75 0c             	pushl  0xc(%ebp)
  801065:	ff 75 08             	pushl  0x8(%ebp)
  801068:	e8 00 fb ff ff       	call   800b6d <printnum>
  80106d:	83 c4 20             	add    $0x20,%esp
			break;
  801070:	eb 46                	jmp    8010b8 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801072:	83 ec 08             	sub    $0x8,%esp
  801075:	ff 75 0c             	pushl  0xc(%ebp)
  801078:	53                   	push   %ebx
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	ff d0                	call   *%eax
  80107e:	83 c4 10             	add    $0x10,%esp
			break;
  801081:	eb 35                	jmp    8010b8 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801083:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  80108a:	eb 2c                	jmp    8010b8 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80108c:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  801093:	eb 23                	jmp    8010b8 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801095:	83 ec 08             	sub    $0x8,%esp
  801098:	ff 75 0c             	pushl  0xc(%ebp)
  80109b:	6a 25                	push   $0x25
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	ff d0                	call   *%eax
  8010a2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010a5:	ff 4d 10             	decl   0x10(%ebp)
  8010a8:	eb 03                	jmp    8010ad <vprintfmt+0x3c3>
  8010aa:	ff 4d 10             	decl   0x10(%ebp)
  8010ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b0:	48                   	dec    %eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	3c 25                	cmp    $0x25,%al
  8010b5:	75 f3                	jne    8010aa <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010b7:	90                   	nop
		}
	}
  8010b8:	e9 35 fc ff ff       	jmp    800cf2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010bd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010c1:	5b                   	pop    %ebx
  8010c2:	5e                   	pop    %esi
  8010c3:	5d                   	pop    %ebp
  8010c4:	c3                   	ret    

008010c5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010cb:	8d 45 10             	lea    0x10(%ebp),%eax
  8010ce:	83 c0 04             	add    $0x4,%eax
  8010d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010da:	50                   	push   %eax
  8010db:	ff 75 0c             	pushl  0xc(%ebp)
  8010de:	ff 75 08             	pushl  0x8(%ebp)
  8010e1:	e8 04 fc ff ff       	call   800cea <vprintfmt>
  8010e6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010e9:	90                   	nop
  8010ea:	c9                   	leave  
  8010eb:	c3                   	ret    

008010ec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f2:	8b 40 08             	mov    0x8(%eax),%eax
  8010f5:	8d 50 01             	lea    0x1(%eax),%edx
  8010f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	8b 10                	mov    (%eax),%edx
  801103:	8b 45 0c             	mov    0xc(%ebp),%eax
  801106:	8b 40 04             	mov    0x4(%eax),%eax
  801109:	39 c2                	cmp    %eax,%edx
  80110b:	73 12                	jae    80111f <sprintputch+0x33>
		*b->buf++ = ch;
  80110d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801110:	8b 00                	mov    (%eax),%eax
  801112:	8d 48 01             	lea    0x1(%eax),%ecx
  801115:	8b 55 0c             	mov    0xc(%ebp),%edx
  801118:	89 0a                	mov    %ecx,(%edx)
  80111a:	8b 55 08             	mov    0x8(%ebp),%edx
  80111d:	88 10                	mov    %dl,(%eax)
}
  80111f:	90                   	nop
  801120:	5d                   	pop    %ebp
  801121:	c3                   	ret    

00801122 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
  801125:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80112e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801131:	8d 50 ff             	lea    -0x1(%eax),%edx
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	01 d0                	add    %edx,%eax
  801139:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80113c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801143:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801147:	74 06                	je     80114f <vsnprintf+0x2d>
  801149:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80114d:	7f 07                	jg     801156 <vsnprintf+0x34>
		return -E_INVAL;
  80114f:	b8 03 00 00 00       	mov    $0x3,%eax
  801154:	eb 20                	jmp    801176 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801156:	ff 75 14             	pushl  0x14(%ebp)
  801159:	ff 75 10             	pushl  0x10(%ebp)
  80115c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80115f:	50                   	push   %eax
  801160:	68 ec 10 80 00       	push   $0x8010ec
  801165:	e8 80 fb ff ff       	call   800cea <vprintfmt>
  80116a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80116d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801170:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801173:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80117e:	8d 45 10             	lea    0x10(%ebp),%eax
  801181:	83 c0 04             	add    $0x4,%eax
  801184:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801187:	8b 45 10             	mov    0x10(%ebp),%eax
  80118a:	ff 75 f4             	pushl  -0xc(%ebp)
  80118d:	50                   	push   %eax
  80118e:	ff 75 0c             	pushl  0xc(%ebp)
  801191:	ff 75 08             	pushl  0x8(%ebp)
  801194:	e8 89 ff ff ff       	call   801122 <vsnprintf>
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80119f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011a2:	c9                   	leave  
  8011a3:	c3                   	ret    

008011a4 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8011aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011ae:	74 13                	je     8011c3 <readline+0x1f>
		cprintf("%s", prompt);
  8011b0:	83 ec 08             	sub    $0x8,%esp
  8011b3:	ff 75 08             	pushl  0x8(%ebp)
  8011b6:	68 68 2c 80 00       	push   $0x802c68
  8011bb:	e8 50 f9 ff ff       	call   800b10 <cprintf>
  8011c0:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011ca:	83 ec 0c             	sub    $0xc,%esp
  8011cd:	6a 00                	push   $0x0
  8011cf:	e8 28 f5 ff ff       	call   8006fc <iscons>
  8011d4:	83 c4 10             	add    $0x10,%esp
  8011d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011da:	e8 0a f5 ff ff       	call   8006e9 <getchar>
  8011df:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011e6:	79 22                	jns    80120a <readline+0x66>
			if (c != -E_EOF)
  8011e8:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011ec:	0f 84 ad 00 00 00    	je     80129f <readline+0xfb>
				cprintf("read error: %e\n", c);
  8011f2:	83 ec 08             	sub    $0x8,%esp
  8011f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8011f8:	68 6b 2c 80 00       	push   $0x802c6b
  8011fd:	e8 0e f9 ff ff       	call   800b10 <cprintf>
  801202:	83 c4 10             	add    $0x10,%esp
			break;
  801205:	e9 95 00 00 00       	jmp    80129f <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80120a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80120e:	7e 34                	jle    801244 <readline+0xa0>
  801210:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801217:	7f 2b                	jg     801244 <readline+0xa0>
			if (echoing)
  801219:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80121d:	74 0e                	je     80122d <readline+0x89>
				cputchar(c);
  80121f:	83 ec 0c             	sub    $0xc,%esp
  801222:	ff 75 ec             	pushl  -0x14(%ebp)
  801225:	e8 a0 f4 ff ff       	call   8006ca <cputchar>
  80122a:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80122d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801230:	8d 50 01             	lea    0x1(%eax),%edx
  801233:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801236:	89 c2                	mov    %eax,%edx
  801238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123b:	01 d0                	add    %edx,%eax
  80123d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801240:	88 10                	mov    %dl,(%eax)
  801242:	eb 56                	jmp    80129a <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801244:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801248:	75 1f                	jne    801269 <readline+0xc5>
  80124a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80124e:	7e 19                	jle    801269 <readline+0xc5>
			if (echoing)
  801250:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801254:	74 0e                	je     801264 <readline+0xc0>
				cputchar(c);
  801256:	83 ec 0c             	sub    $0xc,%esp
  801259:	ff 75 ec             	pushl  -0x14(%ebp)
  80125c:	e8 69 f4 ff ff       	call   8006ca <cputchar>
  801261:	83 c4 10             	add    $0x10,%esp

			i--;
  801264:	ff 4d f4             	decl   -0xc(%ebp)
  801267:	eb 31                	jmp    80129a <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801269:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80126d:	74 0a                	je     801279 <readline+0xd5>
  80126f:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801273:	0f 85 61 ff ff ff    	jne    8011da <readline+0x36>
			if (echoing)
  801279:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80127d:	74 0e                	je     80128d <readline+0xe9>
				cputchar(c);
  80127f:	83 ec 0c             	sub    $0xc,%esp
  801282:	ff 75 ec             	pushl  -0x14(%ebp)
  801285:	e8 40 f4 ff ff       	call   8006ca <cputchar>
  80128a:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80128d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801290:	8b 45 0c             	mov    0xc(%ebp),%eax
  801293:	01 d0                	add    %edx,%eax
  801295:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801298:	eb 06                	jmp    8012a0 <readline+0xfc>
		}
	}
  80129a:	e9 3b ff ff ff       	jmp    8011da <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80129f:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8012a0:	90                   	nop
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8012a9:	e8 9b 09 00 00       	call   801c49 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b2:	74 13                	je     8012c7 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012b4:	83 ec 08             	sub    $0x8,%esp
  8012b7:	ff 75 08             	pushl  0x8(%ebp)
  8012ba:	68 68 2c 80 00       	push   $0x802c68
  8012bf:	e8 4c f8 ff ff       	call   800b10 <cprintf>
  8012c4:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8012c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8012ce:	83 ec 0c             	sub    $0xc,%esp
  8012d1:	6a 00                	push   $0x0
  8012d3:	e8 24 f4 ff ff       	call   8006fc <iscons>
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8012de:	e8 06 f4 ff ff       	call   8006e9 <getchar>
  8012e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8012e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012ea:	79 22                	jns    80130e <atomic_readline+0x6b>
				if (c != -E_EOF)
  8012ec:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012f0:	0f 84 ad 00 00 00    	je     8013a3 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8012f6:	83 ec 08             	sub    $0x8,%esp
  8012f9:	ff 75 ec             	pushl  -0x14(%ebp)
  8012fc:	68 6b 2c 80 00       	push   $0x802c6b
  801301:	e8 0a f8 ff ff       	call   800b10 <cprintf>
  801306:	83 c4 10             	add    $0x10,%esp
				break;
  801309:	e9 95 00 00 00       	jmp    8013a3 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  80130e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801312:	7e 34                	jle    801348 <atomic_readline+0xa5>
  801314:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80131b:	7f 2b                	jg     801348 <atomic_readline+0xa5>
				if (echoing)
  80131d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801321:	74 0e                	je     801331 <atomic_readline+0x8e>
					cputchar(c);
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	ff 75 ec             	pushl  -0x14(%ebp)
  801329:	e8 9c f3 ff ff       	call   8006ca <cputchar>
  80132e:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801334:	8d 50 01             	lea    0x1(%eax),%edx
  801337:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80133a:	89 c2                	mov    %eax,%edx
  80133c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133f:	01 d0                	add    %edx,%eax
  801341:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801344:	88 10                	mov    %dl,(%eax)
  801346:	eb 56                	jmp    80139e <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801348:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80134c:	75 1f                	jne    80136d <atomic_readline+0xca>
  80134e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801352:	7e 19                	jle    80136d <atomic_readline+0xca>
				if (echoing)
  801354:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801358:	74 0e                	je     801368 <atomic_readline+0xc5>
					cputchar(c);
  80135a:	83 ec 0c             	sub    $0xc,%esp
  80135d:	ff 75 ec             	pushl  -0x14(%ebp)
  801360:	e8 65 f3 ff ff       	call   8006ca <cputchar>
  801365:	83 c4 10             	add    $0x10,%esp
				i--;
  801368:	ff 4d f4             	decl   -0xc(%ebp)
  80136b:	eb 31                	jmp    80139e <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80136d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801371:	74 0a                	je     80137d <atomic_readline+0xda>
  801373:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801377:	0f 85 61 ff ff ff    	jne    8012de <atomic_readline+0x3b>
				if (echoing)
  80137d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801381:	74 0e                	je     801391 <atomic_readline+0xee>
					cputchar(c);
  801383:	83 ec 0c             	sub    $0xc,%esp
  801386:	ff 75 ec             	pushl  -0x14(%ebp)
  801389:	e8 3c f3 ff ff       	call   8006ca <cputchar>
  80138e:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801391:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801394:	8b 45 0c             	mov    0xc(%ebp),%eax
  801397:	01 d0                	add    %edx,%eax
  801399:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80139c:	eb 06                	jmp    8013a4 <atomic_readline+0x101>
			}
		}
  80139e:	e9 3b ff ff ff       	jmp    8012de <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8013a3:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8013a4:	e8 ba 08 00 00       	call   801c63 <sys_unlock_cons>
}
  8013a9:	90                   	nop
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013b9:	eb 06                	jmp    8013c1 <strlen+0x15>
		n++;
  8013bb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013be:	ff 45 08             	incl   0x8(%ebp)
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	84 c0                	test   %al,%al
  8013c8:	75 f1                	jne    8013bb <strlen+0xf>
		n++;
	return n;
  8013ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013dc:	eb 09                	jmp    8013e7 <strnlen+0x18>
		n++;
  8013de:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013e1:	ff 45 08             	incl   0x8(%ebp)
  8013e4:	ff 4d 0c             	decl   0xc(%ebp)
  8013e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013eb:	74 09                	je     8013f6 <strnlen+0x27>
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	84 c0                	test   %al,%al
  8013f4:	75 e8                	jne    8013de <strnlen+0xf>
		n++;
	return n;
  8013f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    

008013fb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801407:	90                   	nop
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8d 50 01             	lea    0x1(%eax),%edx
  80140e:	89 55 08             	mov    %edx,0x8(%ebp)
  801411:	8b 55 0c             	mov    0xc(%ebp),%edx
  801414:	8d 4a 01             	lea    0x1(%edx),%ecx
  801417:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80141a:	8a 12                	mov    (%edx),%dl
  80141c:	88 10                	mov    %dl,(%eax)
  80141e:	8a 00                	mov    (%eax),%al
  801420:	84 c0                	test   %al,%al
  801422:	75 e4                	jne    801408 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801424:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801435:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80143c:	eb 1f                	jmp    80145d <strncpy+0x34>
		*dst++ = *src;
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	8d 50 01             	lea    0x1(%eax),%edx
  801444:	89 55 08             	mov    %edx,0x8(%ebp)
  801447:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144a:	8a 12                	mov    (%edx),%dl
  80144c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	84 c0                	test   %al,%al
  801455:	74 03                	je     80145a <strncpy+0x31>
			src++;
  801457:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80145a:	ff 45 fc             	incl   -0x4(%ebp)
  80145d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801460:	3b 45 10             	cmp    0x10(%ebp),%eax
  801463:	72 d9                	jb     80143e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801465:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801468:	c9                   	leave  
  801469:	c3                   	ret    

0080146a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801476:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80147a:	74 30                	je     8014ac <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80147c:	eb 16                	jmp    801494 <strlcpy+0x2a>
			*dst++ = *src++;
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8d 50 01             	lea    0x1(%eax),%edx
  801484:	89 55 08             	mov    %edx,0x8(%ebp)
  801487:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80148d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801490:	8a 12                	mov    (%edx),%dl
  801492:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801494:	ff 4d 10             	decl   0x10(%ebp)
  801497:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80149b:	74 09                	je     8014a6 <strlcpy+0x3c>
  80149d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	84 c0                	test   %al,%al
  8014a4:	75 d8                	jne    80147e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8014af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b2:	29 c2                	sub    %eax,%edx
  8014b4:	89 d0                	mov    %edx,%eax
}
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014bb:	eb 06                	jmp    8014c3 <strcmp+0xb>
		p++, q++;
  8014bd:	ff 45 08             	incl   0x8(%ebp)
  8014c0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	84 c0                	test   %al,%al
  8014ca:	74 0e                	je     8014da <strcmp+0x22>
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8a 10                	mov    (%eax),%dl
  8014d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	38 c2                	cmp    %al,%dl
  8014d8:	74 e3                	je     8014bd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8a 00                	mov    (%eax),%al
  8014df:	0f b6 d0             	movzbl %al,%edx
  8014e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e5:	8a 00                	mov    (%eax),%al
  8014e7:	0f b6 c0             	movzbl %al,%eax
  8014ea:	29 c2                	sub    %eax,%edx
  8014ec:	89 d0                	mov    %edx,%eax
}
  8014ee:	5d                   	pop    %ebp
  8014ef:	c3                   	ret    

008014f0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014f3:	eb 09                	jmp    8014fe <strncmp+0xe>
		n--, p++, q++;
  8014f5:	ff 4d 10             	decl   0x10(%ebp)
  8014f8:	ff 45 08             	incl   0x8(%ebp)
  8014fb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801502:	74 17                	je     80151b <strncmp+0x2b>
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	84 c0                	test   %al,%al
  80150b:	74 0e                	je     80151b <strncmp+0x2b>
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	8a 10                	mov    (%eax),%dl
  801512:	8b 45 0c             	mov    0xc(%ebp),%eax
  801515:	8a 00                	mov    (%eax),%al
  801517:	38 c2                	cmp    %al,%dl
  801519:	74 da                	je     8014f5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80151b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80151f:	75 07                	jne    801528 <strncmp+0x38>
		return 0;
  801521:	b8 00 00 00 00       	mov    $0x0,%eax
  801526:	eb 14                	jmp    80153c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	8a 00                	mov    (%eax),%al
  80152d:	0f b6 d0             	movzbl %al,%edx
  801530:	8b 45 0c             	mov    0xc(%ebp),%eax
  801533:	8a 00                	mov    (%eax),%al
  801535:	0f b6 c0             	movzbl %al,%eax
  801538:	29 c2                	sub    %eax,%edx
  80153a:	89 d0                	mov    %edx,%eax
}
  80153c:	5d                   	pop    %ebp
  80153d:	c3                   	ret    

0080153e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	83 ec 04             	sub    $0x4,%esp
  801544:	8b 45 0c             	mov    0xc(%ebp),%eax
  801547:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80154a:	eb 12                	jmp    80155e <strchr+0x20>
		if (*s == c)
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801554:	75 05                	jne    80155b <strchr+0x1d>
			return (char *) s;
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	eb 11                	jmp    80156c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80155b:	ff 45 08             	incl   0x8(%ebp)
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	8a 00                	mov    (%eax),%al
  801563:	84 c0                	test   %al,%al
  801565:	75 e5                	jne    80154c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801567:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 04             	sub    $0x4,%esp
  801574:	8b 45 0c             	mov    0xc(%ebp),%eax
  801577:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80157a:	eb 0d                	jmp    801589 <strfind+0x1b>
		if (*s == c)
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	8a 00                	mov    (%eax),%al
  801581:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801584:	74 0e                	je     801594 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801586:	ff 45 08             	incl   0x8(%ebp)
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	8a 00                	mov    (%eax),%al
  80158e:	84 c0                	test   %al,%al
  801590:	75 ea                	jne    80157c <strfind+0xe>
  801592:	eb 01                	jmp    801595 <strfind+0x27>
		if (*s == c)
			break;
  801594:	90                   	nop
	return (char *) s;
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015ac:	eb 0e                	jmp    8015bc <memset+0x22>
		*p++ = c;
  8015ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b1:	8d 50 01             	lea    0x1(%eax),%edx
  8015b4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ba:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015bc:	ff 4d f8             	decl   -0x8(%ebp)
  8015bf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015c3:	79 e9                	jns    8015ae <memset+0x14>
		*p++ = c;

	return v;
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8015dc:	eb 16                	jmp    8015f4 <memcpy+0x2a>
		*d++ = *s++;
  8015de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e1:	8d 50 01             	lea    0x1(%eax),%edx
  8015e4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015ed:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015f0:	8a 12                	mov    (%edx),%dl
  8015f2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8015f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	75 dd                	jne    8015de <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80160c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801618:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80161b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80161e:	73 50                	jae    801670 <memmove+0x6a>
  801620:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801623:	8b 45 10             	mov    0x10(%ebp),%eax
  801626:	01 d0                	add    %edx,%eax
  801628:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80162b:	76 43                	jbe    801670 <memmove+0x6a>
		s += n;
  80162d:	8b 45 10             	mov    0x10(%ebp),%eax
  801630:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801633:	8b 45 10             	mov    0x10(%ebp),%eax
  801636:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801639:	eb 10                	jmp    80164b <memmove+0x45>
			*--d = *--s;
  80163b:	ff 4d f8             	decl   -0x8(%ebp)
  80163e:	ff 4d fc             	decl   -0x4(%ebp)
  801641:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801644:	8a 10                	mov    (%eax),%dl
  801646:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801649:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80164b:	8b 45 10             	mov    0x10(%ebp),%eax
  80164e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801651:	89 55 10             	mov    %edx,0x10(%ebp)
  801654:	85 c0                	test   %eax,%eax
  801656:	75 e3                	jne    80163b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801658:	eb 23                	jmp    80167d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80165a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165d:	8d 50 01             	lea    0x1(%eax),%edx
  801660:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801663:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801666:	8d 4a 01             	lea    0x1(%edx),%ecx
  801669:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80166c:	8a 12                	mov    (%edx),%dl
  80166e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801670:	8b 45 10             	mov    0x10(%ebp),%eax
  801673:	8d 50 ff             	lea    -0x1(%eax),%edx
  801676:	89 55 10             	mov    %edx,0x10(%ebp)
  801679:	85 c0                	test   %eax,%eax
  80167b:	75 dd                	jne    80165a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80168e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801691:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801694:	eb 2a                	jmp    8016c0 <memcmp+0x3e>
		if (*s1 != *s2)
  801696:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801699:	8a 10                	mov    (%eax),%dl
  80169b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169e:	8a 00                	mov    (%eax),%al
  8016a0:	38 c2                	cmp    %al,%dl
  8016a2:	74 16                	je     8016ba <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a7:	8a 00                	mov    (%eax),%al
  8016a9:	0f b6 d0             	movzbl %al,%edx
  8016ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016af:	8a 00                	mov    (%eax),%al
  8016b1:	0f b6 c0             	movzbl %al,%eax
  8016b4:	29 c2                	sub    %eax,%edx
  8016b6:	89 d0                	mov    %edx,%eax
  8016b8:	eb 18                	jmp    8016d2 <memcmp+0x50>
		s1++, s2++;
  8016ba:	ff 45 fc             	incl   -0x4(%ebp)
  8016bd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016c6:	89 55 10             	mov    %edx,0x10(%ebp)
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	75 c9                	jne    801696 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016da:	8b 55 08             	mov    0x8(%ebp),%edx
  8016dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e0:	01 d0                	add    %edx,%eax
  8016e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016e5:	eb 15                	jmp    8016fc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8a 00                	mov    (%eax),%al
  8016ec:	0f b6 d0             	movzbl %al,%edx
  8016ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f2:	0f b6 c0             	movzbl %al,%eax
  8016f5:	39 c2                	cmp    %eax,%edx
  8016f7:	74 0d                	je     801706 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016f9:	ff 45 08             	incl   0x8(%ebp)
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801702:	72 e3                	jb     8016e7 <memfind+0x13>
  801704:	eb 01                	jmp    801707 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801706:	90                   	nop
	return (void *) s;
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801712:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801719:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801720:	eb 03                	jmp    801725 <strtol+0x19>
		s++;
  801722:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	8a 00                	mov    (%eax),%al
  80172a:	3c 20                	cmp    $0x20,%al
  80172c:	74 f4                	je     801722 <strtol+0x16>
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
  801731:	8a 00                	mov    (%eax),%al
  801733:	3c 09                	cmp    $0x9,%al
  801735:	74 eb                	je     801722 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	8a 00                	mov    (%eax),%al
  80173c:	3c 2b                	cmp    $0x2b,%al
  80173e:	75 05                	jne    801745 <strtol+0x39>
		s++;
  801740:	ff 45 08             	incl   0x8(%ebp)
  801743:	eb 13                	jmp    801758 <strtol+0x4c>
	else if (*s == '-')
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	8a 00                	mov    (%eax),%al
  80174a:	3c 2d                	cmp    $0x2d,%al
  80174c:	75 0a                	jne    801758 <strtol+0x4c>
		s++, neg = 1;
  80174e:	ff 45 08             	incl   0x8(%ebp)
  801751:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801758:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80175c:	74 06                	je     801764 <strtol+0x58>
  80175e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801762:	75 20                	jne    801784 <strtol+0x78>
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 30                	cmp    $0x30,%al
  80176b:	75 17                	jne    801784 <strtol+0x78>
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	40                   	inc    %eax
  801771:	8a 00                	mov    (%eax),%al
  801773:	3c 78                	cmp    $0x78,%al
  801775:	75 0d                	jne    801784 <strtol+0x78>
		s += 2, base = 16;
  801777:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80177b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801782:	eb 28                	jmp    8017ac <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801784:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801788:	75 15                	jne    80179f <strtol+0x93>
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	8a 00                	mov    (%eax),%al
  80178f:	3c 30                	cmp    $0x30,%al
  801791:	75 0c                	jne    80179f <strtol+0x93>
		s++, base = 8;
  801793:	ff 45 08             	incl   0x8(%ebp)
  801796:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80179d:	eb 0d                	jmp    8017ac <strtol+0xa0>
	else if (base == 0)
  80179f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017a3:	75 07                	jne    8017ac <strtol+0xa0>
		base = 10;
  8017a5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	8a 00                	mov    (%eax),%al
  8017b1:	3c 2f                	cmp    $0x2f,%al
  8017b3:	7e 19                	jle    8017ce <strtol+0xc2>
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8a 00                	mov    (%eax),%al
  8017ba:	3c 39                	cmp    $0x39,%al
  8017bc:	7f 10                	jg     8017ce <strtol+0xc2>
			dig = *s - '0';
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	8a 00                	mov    (%eax),%al
  8017c3:	0f be c0             	movsbl %al,%eax
  8017c6:	83 e8 30             	sub    $0x30,%eax
  8017c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017cc:	eb 42                	jmp    801810 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	8a 00                	mov    (%eax),%al
  8017d3:	3c 60                	cmp    $0x60,%al
  8017d5:	7e 19                	jle    8017f0 <strtol+0xe4>
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	8a 00                	mov    (%eax),%al
  8017dc:	3c 7a                	cmp    $0x7a,%al
  8017de:	7f 10                	jg     8017f0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	8a 00                	mov    (%eax),%al
  8017e5:	0f be c0             	movsbl %al,%eax
  8017e8:	83 e8 57             	sub    $0x57,%eax
  8017eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017ee:	eb 20                	jmp    801810 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	8a 00                	mov    (%eax),%al
  8017f5:	3c 40                	cmp    $0x40,%al
  8017f7:	7e 39                	jle    801832 <strtol+0x126>
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	8a 00                	mov    (%eax),%al
  8017fe:	3c 5a                	cmp    $0x5a,%al
  801800:	7f 30                	jg     801832 <strtol+0x126>
			dig = *s - 'A' + 10;
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	8a 00                	mov    (%eax),%al
  801807:	0f be c0             	movsbl %al,%eax
  80180a:	83 e8 37             	sub    $0x37,%eax
  80180d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801813:	3b 45 10             	cmp    0x10(%ebp),%eax
  801816:	7d 19                	jge    801831 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801818:	ff 45 08             	incl   0x8(%ebp)
  80181b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80181e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801822:	89 c2                	mov    %eax,%edx
  801824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801827:	01 d0                	add    %edx,%eax
  801829:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80182c:	e9 7b ff ff ff       	jmp    8017ac <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801831:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801832:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801836:	74 08                	je     801840 <strtol+0x134>
		*endptr = (char *) s;
  801838:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183b:	8b 55 08             	mov    0x8(%ebp),%edx
  80183e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801840:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801844:	74 07                	je     80184d <strtol+0x141>
  801846:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801849:	f7 d8                	neg    %eax
  80184b:	eb 03                	jmp    801850 <strtol+0x144>
  80184d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <ltostr>:

void
ltostr(long value, char *str)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801858:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80185f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801866:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80186a:	79 13                	jns    80187f <ltostr+0x2d>
	{
		neg = 1;
  80186c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801873:	8b 45 0c             	mov    0xc(%ebp),%eax
  801876:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801879:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80187c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801887:	99                   	cltd   
  801888:	f7 f9                	idiv   %ecx
  80188a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80188d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801890:	8d 50 01             	lea    0x1(%eax),%edx
  801893:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801896:	89 c2                	mov    %eax,%edx
  801898:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189b:	01 d0                	add    %edx,%eax
  80189d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018a0:	83 c2 30             	add    $0x30,%edx
  8018a3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018a8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018ad:	f7 e9                	imul   %ecx
  8018af:	c1 fa 02             	sar    $0x2,%edx
  8018b2:	89 c8                	mov    %ecx,%eax
  8018b4:	c1 f8 1f             	sar    $0x1f,%eax
  8018b7:	29 c2                	sub    %eax,%edx
  8018b9:	89 d0                	mov    %edx,%eax
  8018bb:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018c2:	75 bb                	jne    80187f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ce:	48                   	dec    %eax
  8018cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018d6:	74 3d                	je     801915 <ltostr+0xc3>
		start = 1 ;
  8018d8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018df:	eb 34                	jmp    801915 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e7:	01 d0                	add    %edx,%eax
  8018e9:	8a 00                	mov    (%eax),%al
  8018eb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f4:	01 c2                	add    %eax,%edx
  8018f6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fc:	01 c8                	add    %ecx,%eax
  8018fe:	8a 00                	mov    (%eax),%al
  801900:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801902:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801905:	8b 45 0c             	mov    0xc(%ebp),%eax
  801908:	01 c2                	add    %eax,%edx
  80190a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80190d:	88 02                	mov    %al,(%edx)
		start++ ;
  80190f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801912:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801918:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80191b:	7c c4                	jl     8018e1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80191d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801920:	8b 45 0c             	mov    0xc(%ebp),%eax
  801923:	01 d0                	add    %edx,%eax
  801925:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801928:	90                   	nop
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801931:	ff 75 08             	pushl  0x8(%ebp)
  801934:	e8 73 fa ff ff       	call   8013ac <strlen>
  801939:	83 c4 04             	add    $0x4,%esp
  80193c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80193f:	ff 75 0c             	pushl  0xc(%ebp)
  801942:	e8 65 fa ff ff       	call   8013ac <strlen>
  801947:	83 c4 04             	add    $0x4,%esp
  80194a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80194d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801954:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80195b:	eb 17                	jmp    801974 <strcconcat+0x49>
		final[s] = str1[s] ;
  80195d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801960:	8b 45 10             	mov    0x10(%ebp),%eax
  801963:	01 c2                	add    %eax,%edx
  801965:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	01 c8                	add    %ecx,%eax
  80196d:	8a 00                	mov    (%eax),%al
  80196f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801971:	ff 45 fc             	incl   -0x4(%ebp)
  801974:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801977:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80197a:	7c e1                	jl     80195d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80197c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801983:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80198a:	eb 1f                	jmp    8019ab <strcconcat+0x80>
		final[s++] = str2[i] ;
  80198c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80198f:	8d 50 01             	lea    0x1(%eax),%edx
  801992:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801995:	89 c2                	mov    %eax,%edx
  801997:	8b 45 10             	mov    0x10(%ebp),%eax
  80199a:	01 c2                	add    %eax,%edx
  80199c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80199f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a2:	01 c8                	add    %ecx,%eax
  8019a4:	8a 00                	mov    (%eax),%al
  8019a6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019a8:	ff 45 f8             	incl   -0x8(%ebp)
  8019ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019b1:	7c d9                	jl     80198c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b9:	01 d0                	add    %edx,%eax
  8019bb:	c6 00 00             	movb   $0x0,(%eax)
}
  8019be:	90                   	nop
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d0:	8b 00                	mov    (%eax),%eax
  8019d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019dc:	01 d0                	add    %edx,%eax
  8019de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019e4:	eb 0c                	jmp    8019f2 <strsplit+0x31>
			*string++ = 0;
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	8d 50 01             	lea    0x1(%eax),%edx
  8019ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8019ef:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	8a 00                	mov    (%eax),%al
  8019f7:	84 c0                	test   %al,%al
  8019f9:	74 18                	je     801a13 <strsplit+0x52>
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	8a 00                	mov    (%eax),%al
  801a00:	0f be c0             	movsbl %al,%eax
  801a03:	50                   	push   %eax
  801a04:	ff 75 0c             	pushl  0xc(%ebp)
  801a07:	e8 32 fb ff ff       	call   80153e <strchr>
  801a0c:	83 c4 08             	add    $0x8,%esp
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	75 d3                	jne    8019e6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	8a 00                	mov    (%eax),%al
  801a18:	84 c0                	test   %al,%al
  801a1a:	74 5a                	je     801a76 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1f:	8b 00                	mov    (%eax),%eax
  801a21:	83 f8 0f             	cmp    $0xf,%eax
  801a24:	75 07                	jne    801a2d <strsplit+0x6c>
		{
			return 0;
  801a26:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2b:	eb 66                	jmp    801a93 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a30:	8b 00                	mov    (%eax),%eax
  801a32:	8d 48 01             	lea    0x1(%eax),%ecx
  801a35:	8b 55 14             	mov    0x14(%ebp),%edx
  801a38:	89 0a                	mov    %ecx,(%edx)
  801a3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a41:	8b 45 10             	mov    0x10(%ebp),%eax
  801a44:	01 c2                	add    %eax,%edx
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a4b:	eb 03                	jmp    801a50 <strsplit+0x8f>
			string++;
  801a4d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	74 8b                	je     8019e4 <strsplit+0x23>
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	8a 00                	mov    (%eax),%al
  801a5e:	0f be c0             	movsbl %al,%eax
  801a61:	50                   	push   %eax
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	e8 d4 fa ff ff       	call   80153e <strchr>
  801a6a:	83 c4 08             	add    $0x8,%esp
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	74 dc                	je     801a4d <strsplit+0x8c>
			string++;
	}
  801a71:	e9 6e ff ff ff       	jmp    8019e4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a76:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a77:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7a:	8b 00                	mov    (%eax),%eax
  801a7c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a83:	8b 45 10             	mov    0x10(%ebp),%eax
  801a86:	01 d0                	add    %edx,%eax
  801a88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a8e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801a9b:	83 ec 04             	sub    $0x4,%esp
  801a9e:	68 7c 2c 80 00       	push   $0x802c7c
  801aa3:	68 3f 01 00 00       	push   $0x13f
  801aa8:	68 9e 2c 80 00       	push   $0x802c9e
  801aad:	e8 a1 ed ff ff       	call   800853 <_panic>

00801ab2 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801ab8:	83 ec 0c             	sub    $0xc,%esp
  801abb:	ff 75 08             	pushl  0x8(%ebp)
  801abe:	e8 ef 06 00 00       	call   8021b2 <sys_sbrk>
  801ac3:	83 c4 10             	add    $0x10,%esp
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801ace:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ad2:	75 07                	jne    801adb <malloc+0x13>
  801ad4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad9:	eb 14                	jmp    801aef <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801adb:	83 ec 04             	sub    $0x4,%esp
  801ade:	68 ac 2c 80 00       	push   $0x802cac
  801ae3:	6a 1b                	push   $0x1b
  801ae5:	68 d1 2c 80 00       	push   $0x802cd1
  801aea:	e8 64 ed ff ff       	call   800853 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801af7:	83 ec 04             	sub    $0x4,%esp
  801afa:	68 e0 2c 80 00       	push   $0x802ce0
  801aff:	6a 29                	push   $0x29
  801b01:	68 d1 2c 80 00       	push   $0x802cd1
  801b06:	e8 48 ed ff ff       	call   800853 <_panic>

00801b0b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 18             	sub    $0x18,%esp
  801b11:	8b 45 10             	mov    0x10(%ebp),%eax
  801b14:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801b17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b1b:	75 07                	jne    801b24 <smalloc+0x19>
  801b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b22:	eb 14                	jmp    801b38 <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801b24:	83 ec 04             	sub    $0x4,%esp
  801b27:	68 04 2d 80 00       	push   $0x802d04
  801b2c:	6a 38                	push   $0x38
  801b2e:	68 d1 2c 80 00       	push   $0x802cd1
  801b33:	e8 1b ed ff ff       	call   800853 <_panic>
	return NULL;
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801b40:	83 ec 04             	sub    $0x4,%esp
  801b43:	68 2c 2d 80 00       	push   $0x802d2c
  801b48:	6a 43                	push   $0x43
  801b4a:	68 d1 2c 80 00       	push   $0x802cd1
  801b4f:	e8 ff ec ff ff       	call   800853 <_panic>

00801b54 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b5a:	83 ec 04             	sub    $0x4,%esp
  801b5d:	68 50 2d 80 00       	push   $0x802d50
  801b62:	6a 5b                	push   $0x5b
  801b64:	68 d1 2c 80 00       	push   $0x802cd1
  801b69:	e8 e5 ec ff ff       	call   800853 <_panic>

00801b6e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b74:	83 ec 04             	sub    $0x4,%esp
  801b77:	68 74 2d 80 00       	push   $0x802d74
  801b7c:	6a 72                	push   $0x72
  801b7e:	68 d1 2c 80 00       	push   $0x802cd1
  801b83:	e8 cb ec ff ff       	call   800853 <_panic>

00801b88 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b8e:	83 ec 04             	sub    $0x4,%esp
  801b91:	68 9a 2d 80 00       	push   $0x802d9a
  801b96:	6a 7e                	push   $0x7e
  801b98:	68 d1 2c 80 00       	push   $0x802cd1
  801b9d:	e8 b1 ec ff ff       	call   800853 <_panic>

00801ba2 <shrink>:

}
void shrink(uint32 newSize)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ba8:	83 ec 04             	sub    $0x4,%esp
  801bab:	68 9a 2d 80 00       	push   $0x802d9a
  801bb0:	68 83 00 00 00       	push   $0x83
  801bb5:	68 d1 2c 80 00       	push   $0x802cd1
  801bba:	e8 94 ec ff ff       	call   800853 <_panic>

00801bbf <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bc5:	83 ec 04             	sub    $0x4,%esp
  801bc8:	68 9a 2d 80 00       	push   $0x802d9a
  801bcd:	68 88 00 00 00       	push   $0x88
  801bd2:	68 d1 2c 80 00       	push   $0x802cd1
  801bd7:	e8 77 ec ff ff       	call   800853 <_panic>

00801bdc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	57                   	push   %edi
  801be0:	56                   	push   %esi
  801be1:	53                   	push   %ebx
  801be2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801beb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bf1:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bf4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801bf7:	cd 30                	int    $0x30
  801bf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bff:	83 c4 10             	add    $0x10,%esp
  801c02:	5b                   	pop    %ebx
  801c03:	5e                   	pop    %esi
  801c04:	5f                   	pop    %edi
  801c05:	5d                   	pop    %ebp
  801c06:	c3                   	ret    

00801c07 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	83 ec 04             	sub    $0x4,%esp
  801c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c10:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c13:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	52                   	push   %edx
  801c1f:	ff 75 0c             	pushl  0xc(%ebp)
  801c22:	50                   	push   %eax
  801c23:	6a 00                	push   $0x0
  801c25:	e8 b2 ff ff ff       	call   801bdc <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
}
  801c2d:	90                   	nop
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 02                	push   $0x2
  801c3f:	e8 98 ff ff ff       	call   801bdc <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 03                	push   $0x3
  801c58:	e8 7f ff ff ff       	call   801bdc <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
}
  801c60:	90                   	nop
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 04                	push   $0x4
  801c72:	e8 65 ff ff ff       	call   801bdc <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
}
  801c7a:	90                   	nop
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	52                   	push   %edx
  801c8d:	50                   	push   %eax
  801c8e:	6a 08                	push   $0x8
  801c90:	e8 47 ff ff ff       	call   801bdc <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	56                   	push   %esi
  801c9e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c9f:	8b 75 18             	mov    0x18(%ebp),%esi
  801ca2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ca5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	56                   	push   %esi
  801caf:	53                   	push   %ebx
  801cb0:	51                   	push   %ecx
  801cb1:	52                   	push   %edx
  801cb2:	50                   	push   %eax
  801cb3:	6a 09                	push   $0x9
  801cb5:	e8 22 ff ff ff       	call   801bdc <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
}
  801cbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc0:	5b                   	pop    %ebx
  801cc1:	5e                   	pop    %esi
  801cc2:	5d                   	pop    %ebp
  801cc3:	c3                   	ret    

00801cc4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	52                   	push   %edx
  801cd4:	50                   	push   %eax
  801cd5:	6a 0a                	push   $0xa
  801cd7:	e8 00 ff ff ff       	call   801bdc <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	ff 75 0c             	pushl  0xc(%ebp)
  801ced:	ff 75 08             	pushl  0x8(%ebp)
  801cf0:	6a 0b                	push   $0xb
  801cf2:	e8 e5 fe ff ff       	call   801bdc <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 0c                	push   $0xc
  801d0b:	e8 cc fe ff ff       	call   801bdc <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 0d                	push   $0xd
  801d24:	e8 b3 fe ff ff       	call   801bdc <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 0e                	push   $0xe
  801d3d:	e8 9a fe ff ff       	call   801bdc <syscall>
  801d42:	83 c4 18             	add    $0x18,%esp
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 0f                	push   $0xf
  801d56:	e8 81 fe ff ff       	call   801bdc <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	ff 75 08             	pushl  0x8(%ebp)
  801d6e:	6a 10                	push   $0x10
  801d70:	e8 67 fe ff ff       	call   801bdc <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 11                	push   $0x11
  801d89:	e8 4e fe ff ff       	call   801bdc <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
}
  801d91:	90                   	nop
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_cputc>:

void
sys_cputc(const char c)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	83 ec 04             	sub    $0x4,%esp
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801da0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	50                   	push   %eax
  801dad:	6a 01                	push   $0x1
  801daf:	e8 28 fe ff ff       	call   801bdc <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	90                   	nop
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 14                	push   $0x14
  801dc9:	e8 0e fe ff ff       	call   801bdc <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
}
  801dd1:	90                   	nop
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
  801dd7:	83 ec 04             	sub    $0x4,%esp
  801dda:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801de0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801de3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801de7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dea:	6a 00                	push   $0x0
  801dec:	51                   	push   %ecx
  801ded:	52                   	push   %edx
  801dee:	ff 75 0c             	pushl  0xc(%ebp)
  801df1:	50                   	push   %eax
  801df2:	6a 15                	push   $0x15
  801df4:	e8 e3 fd ff ff       	call   801bdc <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	52                   	push   %edx
  801e0e:	50                   	push   %eax
  801e0f:	6a 16                	push   $0x16
  801e11:	e8 c6 fd ff ff       	call   801bdc <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	51                   	push   %ecx
  801e2c:	52                   	push   %edx
  801e2d:	50                   	push   %eax
  801e2e:	6a 17                	push   $0x17
  801e30:	e8 a7 fd ff ff       	call   801bdc <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e40:	8b 45 08             	mov    0x8(%ebp),%eax
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	52                   	push   %edx
  801e4a:	50                   	push   %eax
  801e4b:	6a 18                	push   $0x18
  801e4d:	e8 8a fd ff ff       	call   801bdc <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	6a 00                	push   $0x0
  801e5f:	ff 75 14             	pushl  0x14(%ebp)
  801e62:	ff 75 10             	pushl  0x10(%ebp)
  801e65:	ff 75 0c             	pushl  0xc(%ebp)
  801e68:	50                   	push   %eax
  801e69:	6a 19                	push   $0x19
  801e6b:	e8 6c fd ff ff       	call   801bdc <syscall>
  801e70:	83 c4 18             	add    $0x18,%esp
}
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	50                   	push   %eax
  801e84:	6a 1a                	push   $0x1a
  801e86:	e8 51 fd ff ff       	call   801bdc <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
}
  801e8e:	90                   	nop
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e94:	8b 45 08             	mov    0x8(%ebp),%eax
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	50                   	push   %eax
  801ea0:	6a 1b                	push   $0x1b
  801ea2:	e8 35 fd ff ff       	call   801bdc <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_getenvid>:

int32 sys_getenvid(void)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 05                	push   $0x5
  801ebb:	e8 1c fd ff ff       	call   801bdc <syscall>
  801ec0:	83 c4 18             	add    $0x18,%esp
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 06                	push   $0x6
  801ed4:	e8 03 fd ff ff       	call   801bdc <syscall>
  801ed9:	83 c4 18             	add    $0x18,%esp
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 07                	push   $0x7
  801eed:	e8 ea fc ff ff       	call   801bdc <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <sys_exit_env>:


void sys_exit_env(void)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 1c                	push   $0x1c
  801f06:	e8 d1 fc ff ff       	call   801bdc <syscall>
  801f0b:	83 c4 18             	add    $0x18,%esp
}
  801f0e:	90                   	nop
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f17:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f1a:	8d 50 04             	lea    0x4(%eax),%edx
  801f1d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	52                   	push   %edx
  801f27:	50                   	push   %eax
  801f28:	6a 1d                	push   $0x1d
  801f2a:	e8 ad fc ff ff       	call   801bdc <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
	return result;
  801f32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f3b:	89 01                	mov    %eax,(%ecx)
  801f3d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	c9                   	leave  
  801f44:	c2 04 00             	ret    $0x4

00801f47 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	ff 75 10             	pushl  0x10(%ebp)
  801f51:	ff 75 0c             	pushl  0xc(%ebp)
  801f54:	ff 75 08             	pushl  0x8(%ebp)
  801f57:	6a 13                	push   $0x13
  801f59:	e8 7e fc ff ff       	call   801bdc <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f61:	90                   	nop
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 1e                	push   $0x1e
  801f73:	e8 64 fc ff ff       	call   801bdc <syscall>
  801f78:	83 c4 18             	add    $0x18,%esp
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 04             	sub    $0x4,%esp
  801f83:	8b 45 08             	mov    0x8(%ebp),%eax
  801f86:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f89:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	50                   	push   %eax
  801f96:	6a 1f                	push   $0x1f
  801f98:	e8 3f fc ff ff       	call   801bdc <syscall>
  801f9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa0:	90                   	nop
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <rsttst>:
void rsttst()
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 21                	push   $0x21
  801fb2:	e8 25 fc ff ff       	call   801bdc <syscall>
  801fb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801fba:	90                   	nop
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
  801fc0:	83 ec 04             	sub    $0x4,%esp
  801fc3:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fc9:	8b 55 18             	mov    0x18(%ebp),%edx
  801fcc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fd0:	52                   	push   %edx
  801fd1:	50                   	push   %eax
  801fd2:	ff 75 10             	pushl  0x10(%ebp)
  801fd5:	ff 75 0c             	pushl  0xc(%ebp)
  801fd8:	ff 75 08             	pushl  0x8(%ebp)
  801fdb:	6a 20                	push   $0x20
  801fdd:	e8 fa fb ff ff       	call   801bdc <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe5:	90                   	nop
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <chktst>:
void chktst(uint32 n)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	ff 75 08             	pushl  0x8(%ebp)
  801ff6:	6a 22                	push   $0x22
  801ff8:	e8 df fb ff ff       	call   801bdc <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
	return ;
  802000:	90                   	nop
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <inctst>:

void inctst()
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 23                	push   $0x23
  802012:	e8 c5 fb ff ff       	call   801bdc <syscall>
  802017:	83 c4 18             	add    $0x18,%esp
	return ;
  80201a:	90                   	nop
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <gettst>:
uint32 gettst()
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 24                	push   $0x24
  80202c:	e8 ab fb ff ff       	call   801bdc <syscall>
  802031:	83 c4 18             	add    $0x18,%esp
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
  802039:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 25                	push   $0x25
  802048:	e8 8f fb ff ff       	call   801bdc <syscall>
  80204d:	83 c4 18             	add    $0x18,%esp
  802050:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802053:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802057:	75 07                	jne    802060 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802059:	b8 01 00 00 00       	mov    $0x1,%eax
  80205e:	eb 05                	jmp    802065 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802060:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
  80206a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 25                	push   $0x25
  802079:	e8 5e fb ff ff       	call   801bdc <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
  802081:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802084:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802088:	75 07                	jne    802091 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80208a:	b8 01 00 00 00       	mov    $0x1,%eax
  80208f:	eb 05                	jmp    802096 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802091:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 25                	push   $0x25
  8020aa:	e8 2d fb ff ff       	call   801bdc <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
  8020b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020b5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020b9:	75 07                	jne    8020c2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c0:	eb 05                	jmp    8020c7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 25                	push   $0x25
  8020db:	e8 fc fa ff ff       	call   801bdc <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
  8020e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020e6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020ea:	75 07                	jne    8020f3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f1:	eb 05                	jmp    8020f8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	ff 75 08             	pushl  0x8(%ebp)
  802108:	6a 26                	push   $0x26
  80210a:	e8 cd fa ff ff       	call   801bdc <syscall>
  80210f:	83 c4 18             	add    $0x18,%esp
	return ;
  802112:	90                   	nop
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802119:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80211c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80211f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	6a 00                	push   $0x0
  802127:	53                   	push   %ebx
  802128:	51                   	push   %ecx
  802129:	52                   	push   %edx
  80212a:	50                   	push   %eax
  80212b:	6a 27                	push   $0x27
  80212d:	e8 aa fa ff ff       	call   801bdc <syscall>
  802132:	83 c4 18             	add    $0x18,%esp
}
  802135:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80213d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	52                   	push   %edx
  80214a:	50                   	push   %eax
  80214b:	6a 28                	push   $0x28
  80214d:	e8 8a fa ff ff       	call   801bdc <syscall>
  802152:	83 c4 18             	add    $0x18,%esp
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80215a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80215d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	6a 00                	push   $0x0
  802165:	51                   	push   %ecx
  802166:	ff 75 10             	pushl  0x10(%ebp)
  802169:	52                   	push   %edx
  80216a:	50                   	push   %eax
  80216b:	6a 29                	push   $0x29
  80216d:	e8 6a fa ff ff       	call   801bdc <syscall>
  802172:	83 c4 18             	add    $0x18,%esp
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	ff 75 10             	pushl  0x10(%ebp)
  802181:	ff 75 0c             	pushl  0xc(%ebp)
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	6a 12                	push   $0x12
  802189:	e8 4e fa ff ff       	call   801bdc <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
	return ;
  802191:	90                   	nop
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802197:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	52                   	push   %edx
  8021a4:	50                   	push   %eax
  8021a5:	6a 2a                	push   $0x2a
  8021a7:	e8 30 fa ff ff       	call   801bdc <syscall>
  8021ac:	83 c4 18             	add    $0x18,%esp
	return;
  8021af:	90                   	nop
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
  8021b5:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8021b8:	83 ec 04             	sub    $0x4,%esp
  8021bb:	68 aa 2d 80 00       	push   $0x802daa
  8021c0:	68 2e 01 00 00       	push   $0x12e
  8021c5:	68 be 2d 80 00       	push   $0x802dbe
  8021ca:	e8 84 e6 ff ff       	call   800853 <_panic>

008021cf <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8021d5:	83 ec 04             	sub    $0x4,%esp
  8021d8:	68 aa 2d 80 00       	push   $0x802daa
  8021dd:	68 35 01 00 00       	push   $0x135
  8021e2:	68 be 2d 80 00       	push   $0x802dbe
  8021e7:	e8 67 e6 ff ff       	call   800853 <_panic>

008021ec <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8021f2:	83 ec 04             	sub    $0x4,%esp
  8021f5:	68 aa 2d 80 00       	push   $0x802daa
  8021fa:	68 3b 01 00 00       	push   $0x13b
  8021ff:	68 be 2d 80 00       	push   $0x802dbe
  802204:	e8 4a e6 ff ff       	call   800853 <_panic>
  802209:	66 90                	xchg   %ax,%ax
  80220b:	90                   	nop

0080220c <__udivdi3>:
  80220c:	55                   	push   %ebp
  80220d:	57                   	push   %edi
  80220e:	56                   	push   %esi
  80220f:	53                   	push   %ebx
  802210:	83 ec 1c             	sub    $0x1c,%esp
  802213:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802217:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80221b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80221f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802223:	89 ca                	mov    %ecx,%edx
  802225:	89 f8                	mov    %edi,%eax
  802227:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80222b:	85 f6                	test   %esi,%esi
  80222d:	75 2d                	jne    80225c <__udivdi3+0x50>
  80222f:	39 cf                	cmp    %ecx,%edi
  802231:	77 65                	ja     802298 <__udivdi3+0x8c>
  802233:	89 fd                	mov    %edi,%ebp
  802235:	85 ff                	test   %edi,%edi
  802237:	75 0b                	jne    802244 <__udivdi3+0x38>
  802239:	b8 01 00 00 00       	mov    $0x1,%eax
  80223e:	31 d2                	xor    %edx,%edx
  802240:	f7 f7                	div    %edi
  802242:	89 c5                	mov    %eax,%ebp
  802244:	31 d2                	xor    %edx,%edx
  802246:	89 c8                	mov    %ecx,%eax
  802248:	f7 f5                	div    %ebp
  80224a:	89 c1                	mov    %eax,%ecx
  80224c:	89 d8                	mov    %ebx,%eax
  80224e:	f7 f5                	div    %ebp
  802250:	89 cf                	mov    %ecx,%edi
  802252:	89 fa                	mov    %edi,%edx
  802254:	83 c4 1c             	add    $0x1c,%esp
  802257:	5b                   	pop    %ebx
  802258:	5e                   	pop    %esi
  802259:	5f                   	pop    %edi
  80225a:	5d                   	pop    %ebp
  80225b:	c3                   	ret    
  80225c:	39 ce                	cmp    %ecx,%esi
  80225e:	77 28                	ja     802288 <__udivdi3+0x7c>
  802260:	0f bd fe             	bsr    %esi,%edi
  802263:	83 f7 1f             	xor    $0x1f,%edi
  802266:	75 40                	jne    8022a8 <__udivdi3+0x9c>
  802268:	39 ce                	cmp    %ecx,%esi
  80226a:	72 0a                	jb     802276 <__udivdi3+0x6a>
  80226c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802270:	0f 87 9e 00 00 00    	ja     802314 <__udivdi3+0x108>
  802276:	b8 01 00 00 00       	mov    $0x1,%eax
  80227b:	89 fa                	mov    %edi,%edx
  80227d:	83 c4 1c             	add    $0x1c,%esp
  802280:	5b                   	pop    %ebx
  802281:	5e                   	pop    %esi
  802282:	5f                   	pop    %edi
  802283:	5d                   	pop    %ebp
  802284:	c3                   	ret    
  802285:	8d 76 00             	lea    0x0(%esi),%esi
  802288:	31 ff                	xor    %edi,%edi
  80228a:	31 c0                	xor    %eax,%eax
  80228c:	89 fa                	mov    %edi,%edx
  80228e:	83 c4 1c             	add    $0x1c,%esp
  802291:	5b                   	pop    %ebx
  802292:	5e                   	pop    %esi
  802293:	5f                   	pop    %edi
  802294:	5d                   	pop    %ebp
  802295:	c3                   	ret    
  802296:	66 90                	xchg   %ax,%ax
  802298:	89 d8                	mov    %ebx,%eax
  80229a:	f7 f7                	div    %edi
  80229c:	31 ff                	xor    %edi,%edi
  80229e:	89 fa                	mov    %edi,%edx
  8022a0:	83 c4 1c             	add    $0x1c,%esp
  8022a3:	5b                   	pop    %ebx
  8022a4:	5e                   	pop    %esi
  8022a5:	5f                   	pop    %edi
  8022a6:	5d                   	pop    %ebp
  8022a7:	c3                   	ret    
  8022a8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8022ad:	89 eb                	mov    %ebp,%ebx
  8022af:	29 fb                	sub    %edi,%ebx
  8022b1:	89 f9                	mov    %edi,%ecx
  8022b3:	d3 e6                	shl    %cl,%esi
  8022b5:	89 c5                	mov    %eax,%ebp
  8022b7:	88 d9                	mov    %bl,%cl
  8022b9:	d3 ed                	shr    %cl,%ebp
  8022bb:	89 e9                	mov    %ebp,%ecx
  8022bd:	09 f1                	or     %esi,%ecx
  8022bf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8022c3:	89 f9                	mov    %edi,%ecx
  8022c5:	d3 e0                	shl    %cl,%eax
  8022c7:	89 c5                	mov    %eax,%ebp
  8022c9:	89 d6                	mov    %edx,%esi
  8022cb:	88 d9                	mov    %bl,%cl
  8022cd:	d3 ee                	shr    %cl,%esi
  8022cf:	89 f9                	mov    %edi,%ecx
  8022d1:	d3 e2                	shl    %cl,%edx
  8022d3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022d7:	88 d9                	mov    %bl,%cl
  8022d9:	d3 e8                	shr    %cl,%eax
  8022db:	09 c2                	or     %eax,%edx
  8022dd:	89 d0                	mov    %edx,%eax
  8022df:	89 f2                	mov    %esi,%edx
  8022e1:	f7 74 24 0c          	divl   0xc(%esp)
  8022e5:	89 d6                	mov    %edx,%esi
  8022e7:	89 c3                	mov    %eax,%ebx
  8022e9:	f7 e5                	mul    %ebp
  8022eb:	39 d6                	cmp    %edx,%esi
  8022ed:	72 19                	jb     802308 <__udivdi3+0xfc>
  8022ef:	74 0b                	je     8022fc <__udivdi3+0xf0>
  8022f1:	89 d8                	mov    %ebx,%eax
  8022f3:	31 ff                	xor    %edi,%edi
  8022f5:	e9 58 ff ff ff       	jmp    802252 <__udivdi3+0x46>
  8022fa:	66 90                	xchg   %ax,%ax
  8022fc:	8b 54 24 08          	mov    0x8(%esp),%edx
  802300:	89 f9                	mov    %edi,%ecx
  802302:	d3 e2                	shl    %cl,%edx
  802304:	39 c2                	cmp    %eax,%edx
  802306:	73 e9                	jae    8022f1 <__udivdi3+0xe5>
  802308:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80230b:	31 ff                	xor    %edi,%edi
  80230d:	e9 40 ff ff ff       	jmp    802252 <__udivdi3+0x46>
  802312:	66 90                	xchg   %ax,%ax
  802314:	31 c0                	xor    %eax,%eax
  802316:	e9 37 ff ff ff       	jmp    802252 <__udivdi3+0x46>
  80231b:	90                   	nop

0080231c <__umoddi3>:
  80231c:	55                   	push   %ebp
  80231d:	57                   	push   %edi
  80231e:	56                   	push   %esi
  80231f:	53                   	push   %ebx
  802320:	83 ec 1c             	sub    $0x1c,%esp
  802323:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802327:	8b 74 24 34          	mov    0x34(%esp),%esi
  80232b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80232f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802333:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802337:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80233b:	89 f3                	mov    %esi,%ebx
  80233d:	89 fa                	mov    %edi,%edx
  80233f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802343:	89 34 24             	mov    %esi,(%esp)
  802346:	85 c0                	test   %eax,%eax
  802348:	75 1a                	jne    802364 <__umoddi3+0x48>
  80234a:	39 f7                	cmp    %esi,%edi
  80234c:	0f 86 a2 00 00 00    	jbe    8023f4 <__umoddi3+0xd8>
  802352:	89 c8                	mov    %ecx,%eax
  802354:	89 f2                	mov    %esi,%edx
  802356:	f7 f7                	div    %edi
  802358:	89 d0                	mov    %edx,%eax
  80235a:	31 d2                	xor    %edx,%edx
  80235c:	83 c4 1c             	add    $0x1c,%esp
  80235f:	5b                   	pop    %ebx
  802360:	5e                   	pop    %esi
  802361:	5f                   	pop    %edi
  802362:	5d                   	pop    %ebp
  802363:	c3                   	ret    
  802364:	39 f0                	cmp    %esi,%eax
  802366:	0f 87 ac 00 00 00    	ja     802418 <__umoddi3+0xfc>
  80236c:	0f bd e8             	bsr    %eax,%ebp
  80236f:	83 f5 1f             	xor    $0x1f,%ebp
  802372:	0f 84 ac 00 00 00    	je     802424 <__umoddi3+0x108>
  802378:	bf 20 00 00 00       	mov    $0x20,%edi
  80237d:	29 ef                	sub    %ebp,%edi
  80237f:	89 fe                	mov    %edi,%esi
  802381:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802385:	89 e9                	mov    %ebp,%ecx
  802387:	d3 e0                	shl    %cl,%eax
  802389:	89 d7                	mov    %edx,%edi
  80238b:	89 f1                	mov    %esi,%ecx
  80238d:	d3 ef                	shr    %cl,%edi
  80238f:	09 c7                	or     %eax,%edi
  802391:	89 e9                	mov    %ebp,%ecx
  802393:	d3 e2                	shl    %cl,%edx
  802395:	89 14 24             	mov    %edx,(%esp)
  802398:	89 d8                	mov    %ebx,%eax
  80239a:	d3 e0                	shl    %cl,%eax
  80239c:	89 c2                	mov    %eax,%edx
  80239e:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023a2:	d3 e0                	shl    %cl,%eax
  8023a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023ac:	89 f1                	mov    %esi,%ecx
  8023ae:	d3 e8                	shr    %cl,%eax
  8023b0:	09 d0                	or     %edx,%eax
  8023b2:	d3 eb                	shr    %cl,%ebx
  8023b4:	89 da                	mov    %ebx,%edx
  8023b6:	f7 f7                	div    %edi
  8023b8:	89 d3                	mov    %edx,%ebx
  8023ba:	f7 24 24             	mull   (%esp)
  8023bd:	89 c6                	mov    %eax,%esi
  8023bf:	89 d1                	mov    %edx,%ecx
  8023c1:	39 d3                	cmp    %edx,%ebx
  8023c3:	0f 82 87 00 00 00    	jb     802450 <__umoddi3+0x134>
  8023c9:	0f 84 91 00 00 00    	je     802460 <__umoddi3+0x144>
  8023cf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023d3:	29 f2                	sub    %esi,%edx
  8023d5:	19 cb                	sbb    %ecx,%ebx
  8023d7:	89 d8                	mov    %ebx,%eax
  8023d9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8023dd:	d3 e0                	shl    %cl,%eax
  8023df:	89 e9                	mov    %ebp,%ecx
  8023e1:	d3 ea                	shr    %cl,%edx
  8023e3:	09 d0                	or     %edx,%eax
  8023e5:	89 e9                	mov    %ebp,%ecx
  8023e7:	d3 eb                	shr    %cl,%ebx
  8023e9:	89 da                	mov    %ebx,%edx
  8023eb:	83 c4 1c             	add    $0x1c,%esp
  8023ee:	5b                   	pop    %ebx
  8023ef:	5e                   	pop    %esi
  8023f0:	5f                   	pop    %edi
  8023f1:	5d                   	pop    %ebp
  8023f2:	c3                   	ret    
  8023f3:	90                   	nop
  8023f4:	89 fd                	mov    %edi,%ebp
  8023f6:	85 ff                	test   %edi,%edi
  8023f8:	75 0b                	jne    802405 <__umoddi3+0xe9>
  8023fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ff:	31 d2                	xor    %edx,%edx
  802401:	f7 f7                	div    %edi
  802403:	89 c5                	mov    %eax,%ebp
  802405:	89 f0                	mov    %esi,%eax
  802407:	31 d2                	xor    %edx,%edx
  802409:	f7 f5                	div    %ebp
  80240b:	89 c8                	mov    %ecx,%eax
  80240d:	f7 f5                	div    %ebp
  80240f:	89 d0                	mov    %edx,%eax
  802411:	e9 44 ff ff ff       	jmp    80235a <__umoddi3+0x3e>
  802416:	66 90                	xchg   %ax,%ax
  802418:	89 c8                	mov    %ecx,%eax
  80241a:	89 f2                	mov    %esi,%edx
  80241c:	83 c4 1c             	add    $0x1c,%esp
  80241f:	5b                   	pop    %ebx
  802420:	5e                   	pop    %esi
  802421:	5f                   	pop    %edi
  802422:	5d                   	pop    %ebp
  802423:	c3                   	ret    
  802424:	3b 04 24             	cmp    (%esp),%eax
  802427:	72 06                	jb     80242f <__umoddi3+0x113>
  802429:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80242d:	77 0f                	ja     80243e <__umoddi3+0x122>
  80242f:	89 f2                	mov    %esi,%edx
  802431:	29 f9                	sub    %edi,%ecx
  802433:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802437:	89 14 24             	mov    %edx,(%esp)
  80243a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80243e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802442:	8b 14 24             	mov    (%esp),%edx
  802445:	83 c4 1c             	add    $0x1c,%esp
  802448:	5b                   	pop    %ebx
  802449:	5e                   	pop    %esi
  80244a:	5f                   	pop    %edi
  80244b:	5d                   	pop    %ebp
  80244c:	c3                   	ret    
  80244d:	8d 76 00             	lea    0x0(%esi),%esi
  802450:	2b 04 24             	sub    (%esp),%eax
  802453:	19 fa                	sbb    %edi,%edx
  802455:	89 d1                	mov    %edx,%ecx
  802457:	89 c6                	mov    %eax,%esi
  802459:	e9 71 ff ff ff       	jmp    8023cf <__umoddi3+0xb3>
  80245e:	66 90                	xchg   %ax,%ax
  802460:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802464:	72 ea                	jb     802450 <__umoddi3+0x134>
  802466:	89 d9                	mov    %ebx,%ecx
  802468:	e9 62 ff ff ff       	jmp    8023cf <__umoddi3+0xb3>
