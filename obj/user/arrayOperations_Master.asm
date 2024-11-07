
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
  800041:	e8 ed 1b 00 00       	call   801c33 <sys_lock_cons>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 24 80 00       	push   $0x802460
  80004e:	e8 a7 0a 00 00       	call   800afa <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 24 80 00       	push   $0x802462
  80005e:	e8 97 0a 00 00       	call   800afa <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 80 24 80 00       	push   $0x802480
  80006e:	e8 87 0a 00 00       	call   800afa <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 24 80 00       	push   $0x802462
  80007e:	e8 77 0a 00 00       	call   800afa <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 24 80 00       	push   $0x802460
  80008e:	e8 67 0a 00 00       	call   800afa <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 a0 24 80 00       	push   $0x8024a0
  8000a2:	e8 e7 10 00 00       	call   80118e <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 bf 24 80 00       	push   $0x8024bf
  8000b6:	e8 3a 1a 00 00       	call   801af5 <smalloc>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 0a                	push   $0xa
  8000c6:	6a 00                	push   $0x0
  8000c8:	8d 45 82             	lea    -0x7e(%ebp),%eax
  8000cb:	50                   	push   %eax
  8000cc:	e8 25 16 00 00       	call   8016f6 <strtol>
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
  8000ef:	68 c7 24 80 00       	push   $0x8024c7
  8000f4:	e8 fc 19 00 00       	call   801af5 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 cc 24 80 00       	push   $0x8024cc
  800107:	e8 ee 09 00 00       	call   800afa <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 ee 24 80 00       	push   $0x8024ee
  800117:	e8 de 09 00 00       	call   800afa <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 fc 24 80 00       	push   $0x8024fc
  800127:	e8 ce 09 00 00       	call   800afa <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 0b 25 80 00       	push   $0x80250b
  800137:	e8 be 09 00 00       	call   800afa <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 1b 25 80 00       	push   $0x80251b
  800147:	e8 ae 09 00 00       	call   800afa <cprintf>
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
  800186:	e8 c2 1a 00 00       	call   801c4d <sys_unlock_cons>
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
  8001f6:	68 24 25 80 00       	push   $0x802524
  8001fb:	e8 f5 18 00 00       	call   801af5 <smalloc>
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  800206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[2] RUN THE SLAVES PROGRAMS*/
	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  80020f:	a1 04 30 80 00       	mov    0x803004,%eax
  800214:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  80021a:	a1 04 30 80 00       	mov    0x803004,%eax
  80021f:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  800225:	89 c1                	mov    %eax,%ecx
  800227:	a1 04 30 80 00       	mov    0x803004,%eax
  80022c:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800232:	52                   	push   %edx
  800233:	51                   	push   %ecx
  800234:	50                   	push   %eax
  800235:	68 32 25 80 00       	push   $0x802532
  80023a:	e8 02 1c 00 00       	call   801e41 <sys_create_env>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800245:	a1 04 30 80 00       	mov    0x803004,%eax
  80024a:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  800250:	a1 04 30 80 00       	mov    0x803004,%eax
  800255:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  80025b:	89 c1                	mov    %eax,%ecx
  80025d:	a1 04 30 80 00       	mov    0x803004,%eax
  800262:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800268:	52                   	push   %edx
  800269:	51                   	push   %ecx
  80026a:	50                   	push   %eax
  80026b:	68 3b 25 80 00       	push   $0x80253b
  800270:	e8 cc 1b 00 00       	call   801e41 <sys_create_env>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80027b:	a1 04 30 80 00       	mov    0x803004,%eax
  800280:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  800286:	a1 04 30 80 00       	mov    0x803004,%eax
  80028b:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  800291:	89 c1                	mov    %eax,%ecx
  800293:	a1 04 30 80 00       	mov    0x803004,%eax
  800298:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80029e:	52                   	push   %edx
  80029f:	51                   	push   %ecx
  8002a0:	50                   	push   %eax
  8002a1:	68 44 25 80 00       	push   $0x802544
  8002a6:	e8 96 1b 00 00       	call   801e41 <sys_create_env>
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
  8002c6:	68 50 25 80 00       	push   $0x802550
  8002cb:	6a 4e                	push   $0x4e
  8002cd:	68 65 25 80 00       	push   $0x802565
  8002d2:	e8 66 05 00 00       	call   80083d <_panic>

	sys_run_env(envIdQuickSort);
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	ff 75 dc             	pushl  -0x24(%ebp)
  8002dd:	e8 7d 1b 00 00       	call   801e5f <sys_run_env>
  8002e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002eb:	e8 6f 1b 00 00       	call   801e5f <sys_run_env>
  8002f0:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f9:	e8 61 1b 00 00       	call   801e5f <sys_run_env>
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
  800340:	68 83 25 80 00       	push   $0x802583
  800345:	ff 75 dc             	pushl  -0x24(%ebp)
  800348:	e8 d7 17 00 00       	call   801b24 <sget>
  80034d:	83 c4 10             	add    $0x10,%esp
  800350:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  800353:	83 ec 08             	sub    $0x8,%esp
  800356:	68 92 25 80 00       	push   $0x802592
  80035b:	ff 75 d8             	pushl  -0x28(%ebp)
  80035e:	e8 c1 17 00 00       	call   801b24 <sget>
  800363:	83 c4 10             	add    $0x10,%esp
  800366:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800369:	83 ec 08             	sub    $0x8,%esp
  80036c:	68 a1 25 80 00       	push   $0x8025a1
  800371:	ff 75 d4             	pushl  -0x2c(%ebp)
  800374:	e8 ab 17 00 00       	call   801b24 <sget>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	68 a6 25 80 00       	push   $0x8025a6
  800387:	ff 75 d4             	pushl  -0x2c(%ebp)
  80038a:	e8 95 17 00 00       	call   801b24 <sget>
  80038f:	83 c4 10             	add    $0x10,%esp
  800392:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  800395:	83 ec 08             	sub    $0x8,%esp
  800398:	68 aa 25 80 00       	push   $0x8025aa
  80039d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003a0:	e8 7f 17 00 00       	call   801b24 <sget>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003ab:	83 ec 08             	sub    $0x8,%esp
  8003ae:	68 ae 25 80 00       	push   $0x8025ae
  8003b3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003b6:	e8 69 17 00 00       	call   801b24 <sget>
  8003bb:	83 c4 10             	add    $0x10,%esp
  8003be:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	68 b2 25 80 00       	push   $0x8025b2
  8003c9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003cc:	e8 53 17 00 00       	call   801b24 <sget>
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
  8003f4:	68 b8 25 80 00       	push   $0x8025b8
  8003f9:	6a 69                	push   $0x69
  8003fb:	68 65 25 80 00       	push   $0x802565
  800400:	e8 38 04 00 00       	call   80083d <_panic>
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
  800422:	68 e0 25 80 00       	push   $0x8025e0
  800427:	6a 6b                	push   $0x6b
  800429:	68 65 25 80 00       	push   $0x802565
  80042e:	e8 0a 04 00 00       	call   80083d <_panic>
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
  8004d5:	68 08 26 80 00       	push   $0x802608
  8004da:	6a 78                	push   $0x78
  8004dc:	68 65 25 80 00       	push   $0x802565
  8004e1:	e8 57 03 00 00       	call   80083d <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004e6:	83 ec 0c             	sub    $0xc,%esp
  8004e9:	68 38 26 80 00       	push   $0x802638
  8004ee:	e8 07 06 00 00       	call   800afa <cprintf>
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
  8006de:	e8 9b 16 00 00       	call   801d7e <sys_cputc>
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
  8006ef:	e8 26 15 00 00       	call   801c1a <sys_cgetc>
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
  80070c:	e8 9e 17 00 00       	call   801eaf <sys_getenvindex>
  800711:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800717:	89 d0                	mov    %edx,%eax
  800719:	c1 e0 02             	shl    $0x2,%eax
  80071c:	01 d0                	add    %edx,%eax
  80071e:	01 c0                	add    %eax,%eax
  800720:	01 d0                	add    %edx,%eax
  800722:	c1 e0 02             	shl    $0x2,%eax
  800725:	01 d0                	add    %edx,%eax
  800727:	01 c0                	add    %eax,%eax
  800729:	01 d0                	add    %edx,%eax
  80072b:	c1 e0 04             	shl    $0x4,%eax
  80072e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800733:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800738:	a1 04 30 80 00       	mov    0x803004,%eax
  80073d:	8a 40 20             	mov    0x20(%eax),%al
  800740:	84 c0                	test   %al,%al
  800742:	74 0d                	je     800751 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800744:	a1 04 30 80 00       	mov    0x803004,%eax
  800749:	83 c0 20             	add    $0x20,%eax
  80074c:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800751:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800755:	7e 0a                	jle    800761 <libmain+0x5b>
		binaryname = argv[0];
  800757:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	ff 75 08             	pushl  0x8(%ebp)
  80076a:	e8 c9 f8 ff ff       	call   800038 <_main>
  80076f:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800772:	e8 bc 14 00 00       	call   801c33 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800777:	83 ec 0c             	sub    $0xc,%esp
  80077a:	68 b4 26 80 00       	push   $0x8026b4
  80077f:	e8 76 03 00 00       	call   800afa <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800787:	a1 04 30 80 00       	mov    0x803004,%eax
  80078c:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800792:	a1 04 30 80 00       	mov    0x803004,%eax
  800797:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80079d:	83 ec 04             	sub    $0x4,%esp
  8007a0:	52                   	push   %edx
  8007a1:	50                   	push   %eax
  8007a2:	68 dc 26 80 00       	push   $0x8026dc
  8007a7:	e8 4e 03 00 00       	call   800afa <cprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8007af:	a1 04 30 80 00       	mov    0x803004,%eax
  8007b4:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8007ba:	a1 04 30 80 00       	mov    0x803004,%eax
  8007bf:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8007c5:	a1 04 30 80 00       	mov    0x803004,%eax
  8007ca:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8007d0:	51                   	push   %ecx
  8007d1:	52                   	push   %edx
  8007d2:	50                   	push   %eax
  8007d3:	68 04 27 80 00       	push   $0x802704
  8007d8:	e8 1d 03 00 00       	call   800afa <cprintf>
  8007dd:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007e0:	a1 04 30 80 00       	mov    0x803004,%eax
  8007e5:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	50                   	push   %eax
  8007ef:	68 5c 27 80 00       	push   $0x80275c
  8007f4:	e8 01 03 00 00       	call   800afa <cprintf>
  8007f9:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8007fc:	83 ec 0c             	sub    $0xc,%esp
  8007ff:	68 b4 26 80 00       	push   $0x8026b4
  800804:	e8 f1 02 00 00       	call   800afa <cprintf>
  800809:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80080c:	e8 3c 14 00 00       	call   801c4d <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800811:	e8 19 00 00 00       	call   80082f <exit>
}
  800816:	90                   	nop
  800817:	c9                   	leave  
  800818:	c3                   	ret    

00800819 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800819:	55                   	push   %ebp
  80081a:	89 e5                	mov    %esp,%ebp
  80081c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80081f:	83 ec 0c             	sub    $0xc,%esp
  800822:	6a 00                	push   $0x0
  800824:	e8 52 16 00 00       	call   801e7b <sys_destroy_env>
  800829:	83 c4 10             	add    $0x10,%esp
}
  80082c:	90                   	nop
  80082d:	c9                   	leave  
  80082e:	c3                   	ret    

0080082f <exit>:

void
exit(void)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800835:	e8 a7 16 00 00       	call   801ee1 <sys_exit_env>
}
  80083a:	90                   	nop
  80083b:	c9                   	leave  
  80083c:	c3                   	ret    

0080083d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
  800840:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800843:	8d 45 10             	lea    0x10(%ebp),%eax
  800846:	83 c0 04             	add    $0x4,%eax
  800849:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80084c:	a1 24 30 80 00       	mov    0x803024,%eax
  800851:	85 c0                	test   %eax,%eax
  800853:	74 16                	je     80086b <_panic+0x2e>
		cprintf("%s: ", argv0);
  800855:	a1 24 30 80 00       	mov    0x803024,%eax
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	50                   	push   %eax
  80085e:	68 70 27 80 00       	push   $0x802770
  800863:	e8 92 02 00 00       	call   800afa <cprintf>
  800868:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80086b:	a1 00 30 80 00       	mov    0x803000,%eax
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	ff 75 08             	pushl  0x8(%ebp)
  800876:	50                   	push   %eax
  800877:	68 75 27 80 00       	push   $0x802775
  80087c:	e8 79 02 00 00       	call   800afa <cprintf>
  800881:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800884:	8b 45 10             	mov    0x10(%ebp),%eax
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	ff 75 f4             	pushl  -0xc(%ebp)
  80088d:	50                   	push   %eax
  80088e:	e8 fc 01 00 00       	call   800a8f <vcprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	6a 00                	push   $0x0
  80089b:	68 91 27 80 00       	push   $0x802791
  8008a0:	e8 ea 01 00 00       	call   800a8f <vcprintf>
  8008a5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008a8:	e8 82 ff ff ff       	call   80082f <exit>

	// should not return here
	while (1) ;
  8008ad:	eb fe                	jmp    8008ad <_panic+0x70>

008008af <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008b5:	a1 04 30 80 00       	mov    0x803004,%eax
  8008ba:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c3:	39 c2                	cmp    %eax,%edx
  8008c5:	74 14                	je     8008db <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008c7:	83 ec 04             	sub    $0x4,%esp
  8008ca:	68 94 27 80 00       	push   $0x802794
  8008cf:	6a 26                	push   $0x26
  8008d1:	68 e0 27 80 00       	push   $0x8027e0
  8008d6:	e8 62 ff ff ff       	call   80083d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008e9:	e9 c5 00 00 00       	jmp    8009b3 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8008ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	01 d0                	add    %edx,%eax
  8008fd:	8b 00                	mov    (%eax),%eax
  8008ff:	85 c0                	test   %eax,%eax
  800901:	75 08                	jne    80090b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800903:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800906:	e9 a5 00 00 00       	jmp    8009b0 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80090b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800912:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800919:	eb 69                	jmp    800984 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80091b:	a1 04 30 80 00       	mov    0x803004,%eax
  800920:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800926:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800929:	89 d0                	mov    %edx,%eax
  80092b:	01 c0                	add    %eax,%eax
  80092d:	01 d0                	add    %edx,%eax
  80092f:	c1 e0 03             	shl    $0x3,%eax
  800932:	01 c8                	add    %ecx,%eax
  800934:	8a 40 04             	mov    0x4(%eax),%al
  800937:	84 c0                	test   %al,%al
  800939:	75 46                	jne    800981 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80093b:	a1 04 30 80 00       	mov    0x803004,%eax
  800940:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800946:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800949:	89 d0                	mov    %edx,%eax
  80094b:	01 c0                	add    %eax,%eax
  80094d:	01 d0                	add    %edx,%eax
  80094f:	c1 e0 03             	shl    $0x3,%eax
  800952:	01 c8                	add    %ecx,%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800959:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80095c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800961:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800963:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800966:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	01 c8                	add    %ecx,%eax
  800972:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800974:	39 c2                	cmp    %eax,%edx
  800976:	75 09                	jne    800981 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800978:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80097f:	eb 15                	jmp    800996 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800981:	ff 45 e8             	incl   -0x18(%ebp)
  800984:	a1 04 30 80 00       	mov    0x803004,%eax
  800989:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80098f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800992:	39 c2                	cmp    %eax,%edx
  800994:	77 85                	ja     80091b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800996:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80099a:	75 14                	jne    8009b0 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80099c:	83 ec 04             	sub    $0x4,%esp
  80099f:	68 ec 27 80 00       	push   $0x8027ec
  8009a4:	6a 3a                	push   $0x3a
  8009a6:	68 e0 27 80 00       	push   $0x8027e0
  8009ab:	e8 8d fe ff ff       	call   80083d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009b0:	ff 45 f0             	incl   -0x10(%ebp)
  8009b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009b9:	0f 8c 2f ff ff ff    	jl     8008ee <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009bf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009cd:	eb 26                	jmp    8009f5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009cf:	a1 04 30 80 00       	mov    0x803004,%eax
  8009d4:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8009da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009dd:	89 d0                	mov    %edx,%eax
  8009df:	01 c0                	add    %eax,%eax
  8009e1:	01 d0                	add    %edx,%eax
  8009e3:	c1 e0 03             	shl    $0x3,%eax
  8009e6:	01 c8                	add    %ecx,%eax
  8009e8:	8a 40 04             	mov    0x4(%eax),%al
  8009eb:	3c 01                	cmp    $0x1,%al
  8009ed:	75 03                	jne    8009f2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8009ef:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009f2:	ff 45 e0             	incl   -0x20(%ebp)
  8009f5:	a1 04 30 80 00       	mov    0x803004,%eax
  8009fa:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a03:	39 c2                	cmp    %eax,%edx
  800a05:	77 c8                	ja     8009cf <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a0a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a0d:	74 14                	je     800a23 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a0f:	83 ec 04             	sub    $0x4,%esp
  800a12:	68 40 28 80 00       	push   $0x802840
  800a17:	6a 44                	push   $0x44
  800a19:	68 e0 27 80 00       	push   $0x8027e0
  800a1e:	e8 1a fe ff ff       	call   80083d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a23:	90                   	nop
  800a24:	c9                   	leave  
  800a25:	c3                   	ret    

00800a26 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2f:	8b 00                	mov    (%eax),%eax
  800a31:	8d 48 01             	lea    0x1(%eax),%ecx
  800a34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a37:	89 0a                	mov    %ecx,(%edx)
  800a39:	8b 55 08             	mov    0x8(%ebp),%edx
  800a3c:	88 d1                	mov    %dl,%cl
  800a3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a41:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a4f:	75 2c                	jne    800a7d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a51:	a0 08 30 80 00       	mov    0x803008,%al
  800a56:	0f b6 c0             	movzbl %al,%eax
  800a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5c:	8b 12                	mov    (%edx),%edx
  800a5e:	89 d1                	mov    %edx,%ecx
  800a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a63:	83 c2 08             	add    $0x8,%edx
  800a66:	83 ec 04             	sub    $0x4,%esp
  800a69:	50                   	push   %eax
  800a6a:	51                   	push   %ecx
  800a6b:	52                   	push   %edx
  800a6c:	e8 80 11 00 00       	call   801bf1 <sys_cputs>
  800a71:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a80:	8b 40 04             	mov    0x4(%eax),%eax
  800a83:	8d 50 01             	lea    0x1(%eax),%edx
  800a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a89:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a8c:	90                   	nop
  800a8d:	c9                   	leave  
  800a8e:	c3                   	ret    

00800a8f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a98:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a9f:	00 00 00 
	b.cnt = 0;
  800aa2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800aa9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	ff 75 08             	pushl  0x8(%ebp)
  800ab2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ab8:	50                   	push   %eax
  800ab9:	68 26 0a 80 00       	push   $0x800a26
  800abe:	e8 11 02 00 00       	call   800cd4 <vprintfmt>
  800ac3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ac6:	a0 08 30 80 00       	mov    0x803008,%al
  800acb:	0f b6 c0             	movzbl %al,%eax
  800ace:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ad4:	83 ec 04             	sub    $0x4,%esp
  800ad7:	50                   	push   %eax
  800ad8:	52                   	push   %edx
  800ad9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800adf:	83 c0 08             	add    $0x8,%eax
  800ae2:	50                   	push   %eax
  800ae3:	e8 09 11 00 00       	call   801bf1 <sys_cputs>
  800ae8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800aeb:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800af2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800af8:	c9                   	leave  
  800af9:	c3                   	ret    

00800afa <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b00:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800b07:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 f4             	pushl  -0xc(%ebp)
  800b16:	50                   	push   %eax
  800b17:	e8 73 ff ff ff       	call   800a8f <vcprintf>
  800b1c:	83 c4 10             	add    $0x10,%esp
  800b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b25:	c9                   	leave  
  800b26:	c3                   	ret    

00800b27 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b2d:	e8 01 11 00 00       	call   801c33 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b32:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b41:	50                   	push   %eax
  800b42:	e8 48 ff ff ff       	call   800a8f <vcprintf>
  800b47:	83 c4 10             	add    $0x10,%esp
  800b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b4d:	e8 fb 10 00 00       	call   801c4d <sys_unlock_cons>
	return cnt;
  800b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b55:	c9                   	leave  
  800b56:	c3                   	ret    

00800b57 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	53                   	push   %ebx
  800b5b:	83 ec 14             	sub    $0x14,%esp
  800b5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b64:	8b 45 14             	mov    0x14(%ebp),%eax
  800b67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b6a:	8b 45 18             	mov    0x18(%ebp),%eax
  800b6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b72:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b75:	77 55                	ja     800bcc <printnum+0x75>
  800b77:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b7a:	72 05                	jb     800b81 <printnum+0x2a>
  800b7c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b7f:	77 4b                	ja     800bcc <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b81:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b84:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b87:	8b 45 18             	mov    0x18(%ebp),%eax
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	52                   	push   %edx
  800b90:	50                   	push   %eax
  800b91:	ff 75 f4             	pushl  -0xc(%ebp)
  800b94:	ff 75 f0             	pushl  -0x10(%ebp)
  800b97:	e8 54 16 00 00       	call   8021f0 <__udivdi3>
  800b9c:	83 c4 10             	add    $0x10,%esp
  800b9f:	83 ec 04             	sub    $0x4,%esp
  800ba2:	ff 75 20             	pushl  0x20(%ebp)
  800ba5:	53                   	push   %ebx
  800ba6:	ff 75 18             	pushl  0x18(%ebp)
  800ba9:	52                   	push   %edx
  800baa:	50                   	push   %eax
  800bab:	ff 75 0c             	pushl  0xc(%ebp)
  800bae:	ff 75 08             	pushl  0x8(%ebp)
  800bb1:	e8 a1 ff ff ff       	call   800b57 <printnum>
  800bb6:	83 c4 20             	add    $0x20,%esp
  800bb9:	eb 1a                	jmp    800bd5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bbb:	83 ec 08             	sub    $0x8,%esp
  800bbe:	ff 75 0c             	pushl  0xc(%ebp)
  800bc1:	ff 75 20             	pushl  0x20(%ebp)
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	ff d0                	call   *%eax
  800bc9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bcc:	ff 4d 1c             	decl   0x1c(%ebp)
  800bcf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800bd3:	7f e6                	jg     800bbb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bd5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be3:	53                   	push   %ebx
  800be4:	51                   	push   %ecx
  800be5:	52                   	push   %edx
  800be6:	50                   	push   %eax
  800be7:	e8 14 17 00 00       	call   802300 <__umoddi3>
  800bec:	83 c4 10             	add    $0x10,%esp
  800bef:	05 b4 2a 80 00       	add    $0x802ab4,%eax
  800bf4:	8a 00                	mov    (%eax),%al
  800bf6:	0f be c0             	movsbl %al,%eax
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 0c             	pushl  0xc(%ebp)
  800bff:	50                   	push   %eax
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
}
  800c08:	90                   	nop
  800c09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c11:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c15:	7e 1c                	jle    800c33 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	8b 00                	mov    (%eax),%eax
  800c1c:	8d 50 08             	lea    0x8(%eax),%edx
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	89 10                	mov    %edx,(%eax)
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	8b 00                	mov    (%eax),%eax
  800c29:	83 e8 08             	sub    $0x8,%eax
  800c2c:	8b 50 04             	mov    0x4(%eax),%edx
  800c2f:	8b 00                	mov    (%eax),%eax
  800c31:	eb 40                	jmp    800c73 <getuint+0x65>
	else if (lflag)
  800c33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c37:	74 1e                	je     800c57 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8b 00                	mov    (%eax),%eax
  800c3e:	8d 50 04             	lea    0x4(%eax),%edx
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	89 10                	mov    %edx,(%eax)
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	8b 00                	mov    (%eax),%eax
  800c4b:	83 e8 04             	sub    $0x4,%eax
  800c4e:	8b 00                	mov    (%eax),%eax
  800c50:	ba 00 00 00 00       	mov    $0x0,%edx
  800c55:	eb 1c                	jmp    800c73 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	8b 00                	mov    (%eax),%eax
  800c5c:	8d 50 04             	lea    0x4(%eax),%edx
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	89 10                	mov    %edx,(%eax)
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	8b 00                	mov    (%eax),%eax
  800c69:	83 e8 04             	sub    $0x4,%eax
  800c6c:	8b 00                	mov    (%eax),%eax
  800c6e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c78:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c7c:	7e 1c                	jle    800c9a <getint+0x25>
		return va_arg(*ap, long long);
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8b 00                	mov    (%eax),%eax
  800c83:	8d 50 08             	lea    0x8(%eax),%edx
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	89 10                	mov    %edx,(%eax)
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8b 00                	mov    (%eax),%eax
  800c90:	83 e8 08             	sub    $0x8,%eax
  800c93:	8b 50 04             	mov    0x4(%eax),%edx
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	eb 38                	jmp    800cd2 <getint+0x5d>
	else if (lflag)
  800c9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9e:	74 1a                	je     800cba <getint+0x45>
		return va_arg(*ap, long);
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	8b 00                	mov    (%eax),%eax
  800ca5:	8d 50 04             	lea    0x4(%eax),%edx
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	89 10                	mov    %edx,(%eax)
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	8b 00                	mov    (%eax),%eax
  800cb2:	83 e8 04             	sub    $0x4,%eax
  800cb5:	8b 00                	mov    (%eax),%eax
  800cb7:	99                   	cltd   
  800cb8:	eb 18                	jmp    800cd2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8b 00                	mov    (%eax),%eax
  800cbf:	8d 50 04             	lea    0x4(%eax),%edx
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	89 10                	mov    %edx,(%eax)
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8b 00                	mov    (%eax),%eax
  800ccc:	83 e8 04             	sub    $0x4,%eax
  800ccf:	8b 00                	mov    (%eax),%eax
  800cd1:	99                   	cltd   
}
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
  800cd9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cdc:	eb 17                	jmp    800cf5 <vprintfmt+0x21>
			if (ch == '\0')
  800cde:	85 db                	test   %ebx,%ebx
  800ce0:	0f 84 c1 03 00 00    	je     8010a7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800ce6:	83 ec 08             	sub    $0x8,%esp
  800ce9:	ff 75 0c             	pushl  0xc(%ebp)
  800cec:	53                   	push   %ebx
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	ff d0                	call   *%eax
  800cf2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cf5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf8:	8d 50 01             	lea    0x1(%eax),%edx
  800cfb:	89 55 10             	mov    %edx,0x10(%ebp)
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	0f b6 d8             	movzbl %al,%ebx
  800d03:	83 fb 25             	cmp    $0x25,%ebx
  800d06:	75 d6                	jne    800cde <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d08:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d0c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d13:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d1a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d21:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d28:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2b:	8d 50 01             	lea    0x1(%eax),%edx
  800d2e:	89 55 10             	mov    %edx,0x10(%ebp)
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	0f b6 d8             	movzbl %al,%ebx
  800d36:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d39:	83 f8 5b             	cmp    $0x5b,%eax
  800d3c:	0f 87 3d 03 00 00    	ja     80107f <vprintfmt+0x3ab>
  800d42:	8b 04 85 d8 2a 80 00 	mov    0x802ad8(,%eax,4),%eax
  800d49:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d4b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d4f:	eb d7                	jmp    800d28 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d51:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d55:	eb d1                	jmp    800d28 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d57:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d61:	89 d0                	mov    %edx,%eax
  800d63:	c1 e0 02             	shl    $0x2,%eax
  800d66:	01 d0                	add    %edx,%eax
  800d68:	01 c0                	add    %eax,%eax
  800d6a:	01 d8                	add    %ebx,%eax
  800d6c:	83 e8 30             	sub    $0x30,%eax
  800d6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d72:	8b 45 10             	mov    0x10(%ebp),%eax
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d7a:	83 fb 2f             	cmp    $0x2f,%ebx
  800d7d:	7e 3e                	jle    800dbd <vprintfmt+0xe9>
  800d7f:	83 fb 39             	cmp    $0x39,%ebx
  800d82:	7f 39                	jg     800dbd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d84:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d87:	eb d5                	jmp    800d5e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d89:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8c:	83 c0 04             	add    $0x4,%eax
  800d8f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d92:	8b 45 14             	mov    0x14(%ebp),%eax
  800d95:	83 e8 04             	sub    $0x4,%eax
  800d98:	8b 00                	mov    (%eax),%eax
  800d9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d9d:	eb 1f                	jmp    800dbe <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800da3:	79 83                	jns    800d28 <vprintfmt+0x54>
				width = 0;
  800da5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800dac:	e9 77 ff ff ff       	jmp    800d28 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800db1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800db8:	e9 6b ff ff ff       	jmp    800d28 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800dbd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800dbe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc2:	0f 89 60 ff ff ff    	jns    800d28 <vprintfmt+0x54>
				width = precision, precision = -1;
  800dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dcb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800dd5:	e9 4e ff ff ff       	jmp    800d28 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dda:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ddd:	e9 46 ff ff ff       	jmp    800d28 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800de2:	8b 45 14             	mov    0x14(%ebp),%eax
  800de5:	83 c0 04             	add    $0x4,%eax
  800de8:	89 45 14             	mov    %eax,0x14(%ebp)
  800deb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dee:	83 e8 04             	sub    $0x4,%eax
  800df1:	8b 00                	mov    (%eax),%eax
  800df3:	83 ec 08             	sub    $0x8,%esp
  800df6:	ff 75 0c             	pushl  0xc(%ebp)
  800df9:	50                   	push   %eax
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	ff d0                	call   *%eax
  800dff:	83 c4 10             	add    $0x10,%esp
			break;
  800e02:	e9 9b 02 00 00       	jmp    8010a2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e07:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0a:	83 c0 04             	add    $0x4,%eax
  800e0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800e10:	8b 45 14             	mov    0x14(%ebp),%eax
  800e13:	83 e8 04             	sub    $0x4,%eax
  800e16:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e18:	85 db                	test   %ebx,%ebx
  800e1a:	79 02                	jns    800e1e <vprintfmt+0x14a>
				err = -err;
  800e1c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e1e:	83 fb 64             	cmp    $0x64,%ebx
  800e21:	7f 0b                	jg     800e2e <vprintfmt+0x15a>
  800e23:	8b 34 9d 20 29 80 00 	mov    0x802920(,%ebx,4),%esi
  800e2a:	85 f6                	test   %esi,%esi
  800e2c:	75 19                	jne    800e47 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e2e:	53                   	push   %ebx
  800e2f:	68 c5 2a 80 00       	push   $0x802ac5
  800e34:	ff 75 0c             	pushl  0xc(%ebp)
  800e37:	ff 75 08             	pushl  0x8(%ebp)
  800e3a:	e8 70 02 00 00       	call   8010af <printfmt>
  800e3f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e42:	e9 5b 02 00 00       	jmp    8010a2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e47:	56                   	push   %esi
  800e48:	68 ce 2a 80 00       	push   $0x802ace
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	ff 75 08             	pushl  0x8(%ebp)
  800e53:	e8 57 02 00 00       	call   8010af <printfmt>
  800e58:	83 c4 10             	add    $0x10,%esp
			break;
  800e5b:	e9 42 02 00 00       	jmp    8010a2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e60:	8b 45 14             	mov    0x14(%ebp),%eax
  800e63:	83 c0 04             	add    $0x4,%eax
  800e66:	89 45 14             	mov    %eax,0x14(%ebp)
  800e69:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6c:	83 e8 04             	sub    $0x4,%eax
  800e6f:	8b 30                	mov    (%eax),%esi
  800e71:	85 f6                	test   %esi,%esi
  800e73:	75 05                	jne    800e7a <vprintfmt+0x1a6>
				p = "(null)";
  800e75:	be d1 2a 80 00       	mov    $0x802ad1,%esi
			if (width > 0 && padc != '-')
  800e7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7e:	7e 6d                	jle    800eed <vprintfmt+0x219>
  800e80:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e84:	74 67                	je     800eed <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	50                   	push   %eax
  800e8d:	56                   	push   %esi
  800e8e:	e8 26 05 00 00       	call   8013b9 <strnlen>
  800e93:	83 c4 10             	add    $0x10,%esp
  800e96:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e99:	eb 16                	jmp    800eb1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e9b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e9f:	83 ec 08             	sub    $0x8,%esp
  800ea2:	ff 75 0c             	pushl  0xc(%ebp)
  800ea5:	50                   	push   %eax
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	ff d0                	call   *%eax
  800eab:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eae:	ff 4d e4             	decl   -0x1c(%ebp)
  800eb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eb5:	7f e4                	jg     800e9b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eb7:	eb 34                	jmp    800eed <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800eb9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ebd:	74 1c                	je     800edb <vprintfmt+0x207>
  800ebf:	83 fb 1f             	cmp    $0x1f,%ebx
  800ec2:	7e 05                	jle    800ec9 <vprintfmt+0x1f5>
  800ec4:	83 fb 7e             	cmp    $0x7e,%ebx
  800ec7:	7e 12                	jle    800edb <vprintfmt+0x207>
					putch('?', putdat);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	ff 75 0c             	pushl  0xc(%ebp)
  800ecf:	6a 3f                	push   $0x3f
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	ff d0                	call   *%eax
  800ed6:	83 c4 10             	add    $0x10,%esp
  800ed9:	eb 0f                	jmp    800eea <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800edb:	83 ec 08             	sub    $0x8,%esp
  800ede:	ff 75 0c             	pushl  0xc(%ebp)
  800ee1:	53                   	push   %ebx
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	ff d0                	call   *%eax
  800ee7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eea:	ff 4d e4             	decl   -0x1c(%ebp)
  800eed:	89 f0                	mov    %esi,%eax
  800eef:	8d 70 01             	lea    0x1(%eax),%esi
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	0f be d8             	movsbl %al,%ebx
  800ef7:	85 db                	test   %ebx,%ebx
  800ef9:	74 24                	je     800f1f <vprintfmt+0x24b>
  800efb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800eff:	78 b8                	js     800eb9 <vprintfmt+0x1e5>
  800f01:	ff 4d e0             	decl   -0x20(%ebp)
  800f04:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f08:	79 af                	jns    800eb9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f0a:	eb 13                	jmp    800f1f <vprintfmt+0x24b>
				putch(' ', putdat);
  800f0c:	83 ec 08             	sub    $0x8,%esp
  800f0f:	ff 75 0c             	pushl  0xc(%ebp)
  800f12:	6a 20                	push   $0x20
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	ff d0                	call   *%eax
  800f19:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f1c:	ff 4d e4             	decl   -0x1c(%ebp)
  800f1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f23:	7f e7                	jg     800f0c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f25:	e9 78 01 00 00       	jmp    8010a2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f2a:	83 ec 08             	sub    $0x8,%esp
  800f2d:	ff 75 e8             	pushl  -0x18(%ebp)
  800f30:	8d 45 14             	lea    0x14(%ebp),%eax
  800f33:	50                   	push   %eax
  800f34:	e8 3c fd ff ff       	call   800c75 <getint>
  800f39:	83 c4 10             	add    $0x10,%esp
  800f3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f3f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f48:	85 d2                	test   %edx,%edx
  800f4a:	79 23                	jns    800f6f <vprintfmt+0x29b>
				putch('-', putdat);
  800f4c:	83 ec 08             	sub    $0x8,%esp
  800f4f:	ff 75 0c             	pushl  0xc(%ebp)
  800f52:	6a 2d                	push   $0x2d
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	ff d0                	call   *%eax
  800f59:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f62:	f7 d8                	neg    %eax
  800f64:	83 d2 00             	adc    $0x0,%edx
  800f67:	f7 da                	neg    %edx
  800f69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f6c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f6f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f76:	e9 bc 00 00 00       	jmp    801037 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f7b:	83 ec 08             	sub    $0x8,%esp
  800f7e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f81:	8d 45 14             	lea    0x14(%ebp),%eax
  800f84:	50                   	push   %eax
  800f85:	e8 84 fc ff ff       	call   800c0e <getuint>
  800f8a:	83 c4 10             	add    $0x10,%esp
  800f8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f90:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f93:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f9a:	e9 98 00 00 00       	jmp    801037 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f9f:	83 ec 08             	sub    $0x8,%esp
  800fa2:	ff 75 0c             	pushl  0xc(%ebp)
  800fa5:	6a 58                	push   $0x58
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	ff d0                	call   *%eax
  800fac:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800faf:	83 ec 08             	sub    $0x8,%esp
  800fb2:	ff 75 0c             	pushl  0xc(%ebp)
  800fb5:	6a 58                	push   $0x58
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	ff d0                	call   *%eax
  800fbc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fbf:	83 ec 08             	sub    $0x8,%esp
  800fc2:	ff 75 0c             	pushl  0xc(%ebp)
  800fc5:	6a 58                	push   $0x58
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	ff d0                	call   *%eax
  800fcc:	83 c4 10             	add    $0x10,%esp
			break;
  800fcf:	e9 ce 00 00 00       	jmp    8010a2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800fd4:	83 ec 08             	sub    $0x8,%esp
  800fd7:	ff 75 0c             	pushl  0xc(%ebp)
  800fda:	6a 30                	push   $0x30
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	ff d0                	call   *%eax
  800fe1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fe4:	83 ec 08             	sub    $0x8,%esp
  800fe7:	ff 75 0c             	pushl  0xc(%ebp)
  800fea:	6a 78                	push   $0x78
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	ff d0                	call   *%eax
  800ff1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ff4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff7:	83 c0 04             	add    $0x4,%eax
  800ffa:	89 45 14             	mov    %eax,0x14(%ebp)
  800ffd:	8b 45 14             	mov    0x14(%ebp),%eax
  801000:	83 e8 04             	sub    $0x4,%eax
  801003:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801005:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801008:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80100f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801016:	eb 1f                	jmp    801037 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801018:	83 ec 08             	sub    $0x8,%esp
  80101b:	ff 75 e8             	pushl  -0x18(%ebp)
  80101e:	8d 45 14             	lea    0x14(%ebp),%eax
  801021:	50                   	push   %eax
  801022:	e8 e7 fb ff ff       	call   800c0e <getuint>
  801027:	83 c4 10             	add    $0x10,%esp
  80102a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80102d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801030:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801037:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80103b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80103e:	83 ec 04             	sub    $0x4,%esp
  801041:	52                   	push   %edx
  801042:	ff 75 e4             	pushl  -0x1c(%ebp)
  801045:	50                   	push   %eax
  801046:	ff 75 f4             	pushl  -0xc(%ebp)
  801049:	ff 75 f0             	pushl  -0x10(%ebp)
  80104c:	ff 75 0c             	pushl  0xc(%ebp)
  80104f:	ff 75 08             	pushl  0x8(%ebp)
  801052:	e8 00 fb ff ff       	call   800b57 <printnum>
  801057:	83 c4 20             	add    $0x20,%esp
			break;
  80105a:	eb 46                	jmp    8010a2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80105c:	83 ec 08             	sub    $0x8,%esp
  80105f:	ff 75 0c             	pushl  0xc(%ebp)
  801062:	53                   	push   %ebx
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	ff d0                	call   *%eax
  801068:	83 c4 10             	add    $0x10,%esp
			break;
  80106b:	eb 35                	jmp    8010a2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80106d:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  801074:	eb 2c                	jmp    8010a2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801076:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  80107d:	eb 23                	jmp    8010a2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80107f:	83 ec 08             	sub    $0x8,%esp
  801082:	ff 75 0c             	pushl  0xc(%ebp)
  801085:	6a 25                	push   $0x25
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	ff d0                	call   *%eax
  80108c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80108f:	ff 4d 10             	decl   0x10(%ebp)
  801092:	eb 03                	jmp    801097 <vprintfmt+0x3c3>
  801094:	ff 4d 10             	decl   0x10(%ebp)
  801097:	8b 45 10             	mov    0x10(%ebp),%eax
  80109a:	48                   	dec    %eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 25                	cmp    $0x25,%al
  80109f:	75 f3                	jne    801094 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010a1:	90                   	nop
		}
	}
  8010a2:	e9 35 fc ff ff       	jmp    800cdc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010a7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010ab:	5b                   	pop    %ebx
  8010ac:	5e                   	pop    %esi
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    

008010af <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010b5:	8d 45 10             	lea    0x10(%ebp),%eax
  8010b8:	83 c0 04             	add    $0x4,%eax
  8010bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010be:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8010c4:	50                   	push   %eax
  8010c5:	ff 75 0c             	pushl  0xc(%ebp)
  8010c8:	ff 75 08             	pushl  0x8(%ebp)
  8010cb:	e8 04 fc ff ff       	call   800cd4 <vprintfmt>
  8010d0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010d3:	90                   	nop
  8010d4:	c9                   	leave  
  8010d5:	c3                   	ret    

008010d6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dc:	8b 40 08             	mov    0x8(%eax),%eax
  8010df:	8d 50 01             	lea    0x1(%eax),%edx
  8010e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	8b 10                	mov    (%eax),%edx
  8010ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f0:	8b 40 04             	mov    0x4(%eax),%eax
  8010f3:	39 c2                	cmp    %eax,%edx
  8010f5:	73 12                	jae    801109 <sprintputch+0x33>
		*b->buf++ = ch;
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	8b 00                	mov    (%eax),%eax
  8010fc:	8d 48 01             	lea    0x1(%eax),%ecx
  8010ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801102:	89 0a                	mov    %ecx,(%edx)
  801104:	8b 55 08             	mov    0x8(%ebp),%edx
  801107:	88 10                	mov    %dl,(%eax)
}
  801109:	90                   	nop
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    

0080110c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	01 d0                	add    %edx,%eax
  801123:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801126:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80112d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801131:	74 06                	je     801139 <vsnprintf+0x2d>
  801133:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801137:	7f 07                	jg     801140 <vsnprintf+0x34>
		return -E_INVAL;
  801139:	b8 03 00 00 00       	mov    $0x3,%eax
  80113e:	eb 20                	jmp    801160 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801140:	ff 75 14             	pushl  0x14(%ebp)
  801143:	ff 75 10             	pushl  0x10(%ebp)
  801146:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801149:	50                   	push   %eax
  80114a:	68 d6 10 80 00       	push   $0x8010d6
  80114f:	e8 80 fb ff ff       	call   800cd4 <vprintfmt>
  801154:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801157:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80115a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80115d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801160:	c9                   	leave  
  801161:	c3                   	ret    

00801162 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801168:	8d 45 10             	lea    0x10(%ebp),%eax
  80116b:	83 c0 04             	add    $0x4,%eax
  80116e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801171:	8b 45 10             	mov    0x10(%ebp),%eax
  801174:	ff 75 f4             	pushl  -0xc(%ebp)
  801177:	50                   	push   %eax
  801178:	ff 75 0c             	pushl  0xc(%ebp)
  80117b:	ff 75 08             	pushl  0x8(%ebp)
  80117e:	e8 89 ff ff ff       	call   80110c <vsnprintf>
  801183:	83 c4 10             	add    $0x10,%esp
  801186:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801189:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80118c:	c9                   	leave  
  80118d:	c3                   	ret    

0080118e <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801194:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801198:	74 13                	je     8011ad <readline+0x1f>
		cprintf("%s", prompt);
  80119a:	83 ec 08             	sub    $0x8,%esp
  80119d:	ff 75 08             	pushl  0x8(%ebp)
  8011a0:	68 48 2c 80 00       	push   $0x802c48
  8011a5:	e8 50 f9 ff ff       	call   800afa <cprintf>
  8011aa:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011b4:	83 ec 0c             	sub    $0xc,%esp
  8011b7:	6a 00                	push   $0x0
  8011b9:	e8 3e f5 ff ff       	call   8006fc <iscons>
  8011be:	83 c4 10             	add    $0x10,%esp
  8011c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011c4:	e8 20 f5 ff ff       	call   8006e9 <getchar>
  8011c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011d0:	79 22                	jns    8011f4 <readline+0x66>
			if (c != -E_EOF)
  8011d2:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011d6:	0f 84 ad 00 00 00    	je     801289 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8011dc:	83 ec 08             	sub    $0x8,%esp
  8011df:	ff 75 ec             	pushl  -0x14(%ebp)
  8011e2:	68 4b 2c 80 00       	push   $0x802c4b
  8011e7:	e8 0e f9 ff ff       	call   800afa <cprintf>
  8011ec:	83 c4 10             	add    $0x10,%esp
			break;
  8011ef:	e9 95 00 00 00       	jmp    801289 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011f4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011f8:	7e 34                	jle    80122e <readline+0xa0>
  8011fa:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801201:	7f 2b                	jg     80122e <readline+0xa0>
			if (echoing)
  801203:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801207:	74 0e                	je     801217 <readline+0x89>
				cputchar(c);
  801209:	83 ec 0c             	sub    $0xc,%esp
  80120c:	ff 75 ec             	pushl  -0x14(%ebp)
  80120f:	e8 b6 f4 ff ff       	call   8006ca <cputchar>
  801214:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80121a:	8d 50 01             	lea    0x1(%eax),%edx
  80121d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801220:	89 c2                	mov    %eax,%edx
  801222:	8b 45 0c             	mov    0xc(%ebp),%eax
  801225:	01 d0                	add    %edx,%eax
  801227:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80122a:	88 10                	mov    %dl,(%eax)
  80122c:	eb 56                	jmp    801284 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80122e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801232:	75 1f                	jne    801253 <readline+0xc5>
  801234:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801238:	7e 19                	jle    801253 <readline+0xc5>
			if (echoing)
  80123a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80123e:	74 0e                	je     80124e <readline+0xc0>
				cputchar(c);
  801240:	83 ec 0c             	sub    $0xc,%esp
  801243:	ff 75 ec             	pushl  -0x14(%ebp)
  801246:	e8 7f f4 ff ff       	call   8006ca <cputchar>
  80124b:	83 c4 10             	add    $0x10,%esp

			i--;
  80124e:	ff 4d f4             	decl   -0xc(%ebp)
  801251:	eb 31                	jmp    801284 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801253:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801257:	74 0a                	je     801263 <readline+0xd5>
  801259:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80125d:	0f 85 61 ff ff ff    	jne    8011c4 <readline+0x36>
			if (echoing)
  801263:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801267:	74 0e                	je     801277 <readline+0xe9>
				cputchar(c);
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	ff 75 ec             	pushl  -0x14(%ebp)
  80126f:	e8 56 f4 ff ff       	call   8006ca <cputchar>
  801274:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801277:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127d:	01 d0                	add    %edx,%eax
  80127f:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801282:	eb 06                	jmp    80128a <readline+0xfc>
		}
	}
  801284:	e9 3b ff ff ff       	jmp    8011c4 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801289:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80128a:	90                   	nop
  80128b:	c9                   	leave  
  80128c:	c3                   	ret    

0080128d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80128d:	55                   	push   %ebp
  80128e:	89 e5                	mov    %esp,%ebp
  801290:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801293:	e8 9b 09 00 00       	call   801c33 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801298:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80129c:	74 13                	je     8012b1 <atomic_readline+0x24>
			cprintf("%s", prompt);
  80129e:	83 ec 08             	sub    $0x8,%esp
  8012a1:	ff 75 08             	pushl  0x8(%ebp)
  8012a4:	68 48 2c 80 00       	push   $0x802c48
  8012a9:	e8 4c f8 ff ff       	call   800afa <cprintf>
  8012ae:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8012b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8012b8:	83 ec 0c             	sub    $0xc,%esp
  8012bb:	6a 00                	push   $0x0
  8012bd:	e8 3a f4 ff ff       	call   8006fc <iscons>
  8012c2:	83 c4 10             	add    $0x10,%esp
  8012c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8012c8:	e8 1c f4 ff ff       	call   8006e9 <getchar>
  8012cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8012d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012d4:	79 22                	jns    8012f8 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8012d6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8012da:	0f 84 ad 00 00 00    	je     80138d <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8012e0:	83 ec 08             	sub    $0x8,%esp
  8012e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8012e6:	68 4b 2c 80 00       	push   $0x802c4b
  8012eb:	e8 0a f8 ff ff       	call   800afa <cprintf>
  8012f0:	83 c4 10             	add    $0x10,%esp
				break;
  8012f3:	e9 95 00 00 00       	jmp    80138d <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8012f8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012fc:	7e 34                	jle    801332 <atomic_readline+0xa5>
  8012fe:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801305:	7f 2b                	jg     801332 <atomic_readline+0xa5>
				if (echoing)
  801307:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80130b:	74 0e                	je     80131b <atomic_readline+0x8e>
					cputchar(c);
  80130d:	83 ec 0c             	sub    $0xc,%esp
  801310:	ff 75 ec             	pushl  -0x14(%ebp)
  801313:	e8 b2 f3 ff ff       	call   8006ca <cputchar>
  801318:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80131b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131e:	8d 50 01             	lea    0x1(%eax),%edx
  801321:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801324:	89 c2                	mov    %eax,%edx
  801326:	8b 45 0c             	mov    0xc(%ebp),%eax
  801329:	01 d0                	add    %edx,%eax
  80132b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80132e:	88 10                	mov    %dl,(%eax)
  801330:	eb 56                	jmp    801388 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801332:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801336:	75 1f                	jne    801357 <atomic_readline+0xca>
  801338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80133c:	7e 19                	jle    801357 <atomic_readline+0xca>
				if (echoing)
  80133e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801342:	74 0e                	je     801352 <atomic_readline+0xc5>
					cputchar(c);
  801344:	83 ec 0c             	sub    $0xc,%esp
  801347:	ff 75 ec             	pushl  -0x14(%ebp)
  80134a:	e8 7b f3 ff ff       	call   8006ca <cputchar>
  80134f:	83 c4 10             	add    $0x10,%esp
				i--;
  801352:	ff 4d f4             	decl   -0xc(%ebp)
  801355:	eb 31                	jmp    801388 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801357:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80135b:	74 0a                	je     801367 <atomic_readline+0xda>
  80135d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801361:	0f 85 61 ff ff ff    	jne    8012c8 <atomic_readline+0x3b>
				if (echoing)
  801367:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80136b:	74 0e                	je     80137b <atomic_readline+0xee>
					cputchar(c);
  80136d:	83 ec 0c             	sub    $0xc,%esp
  801370:	ff 75 ec             	pushl  -0x14(%ebp)
  801373:	e8 52 f3 ff ff       	call   8006ca <cputchar>
  801378:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80137b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801381:	01 d0                	add    %edx,%eax
  801383:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801386:	eb 06                	jmp    80138e <atomic_readline+0x101>
			}
		}
  801388:	e9 3b ff ff ff       	jmp    8012c8 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80138d:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80138e:	e8 ba 08 00 00       	call   801c4d <sys_unlock_cons>
}
  801393:	90                   	nop
  801394:	c9                   	leave  
  801395:	c3                   	ret    

00801396 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80139c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a3:	eb 06                	jmp    8013ab <strlen+0x15>
		n++;
  8013a5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013a8:	ff 45 08             	incl   0x8(%ebp)
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	8a 00                	mov    (%eax),%al
  8013b0:	84 c0                	test   %al,%al
  8013b2:	75 f1                	jne    8013a5 <strlen+0xf>
		n++;
	return n;
  8013b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013b7:	c9                   	leave  
  8013b8:	c3                   	ret    

008013b9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013b9:	55                   	push   %ebp
  8013ba:	89 e5                	mov    %esp,%ebp
  8013bc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013c6:	eb 09                	jmp    8013d1 <strnlen+0x18>
		n++;
  8013c8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013cb:	ff 45 08             	incl   0x8(%ebp)
  8013ce:	ff 4d 0c             	decl   0xc(%ebp)
  8013d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013d5:	74 09                	je     8013e0 <strnlen+0x27>
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	8a 00                	mov    (%eax),%al
  8013dc:	84 c0                	test   %al,%al
  8013de:	75 e8                	jne    8013c8 <strnlen+0xf>
		n++;
	return n;
  8013e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013e3:	c9                   	leave  
  8013e4:	c3                   	ret    

008013e5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013f1:	90                   	nop
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8d 50 01             	lea    0x1(%eax),%edx
  8013f8:	89 55 08             	mov    %edx,0x8(%ebp)
  8013fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801401:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801404:	8a 12                	mov    (%edx),%dl
  801406:	88 10                	mov    %dl,(%eax)
  801408:	8a 00                	mov    (%eax),%al
  80140a:	84 c0                	test   %al,%al
  80140c:	75 e4                	jne    8013f2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80140e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80141f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801426:	eb 1f                	jmp    801447 <strncpy+0x34>
		*dst++ = *src;
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8d 50 01             	lea    0x1(%eax),%edx
  80142e:	89 55 08             	mov    %edx,0x8(%ebp)
  801431:	8b 55 0c             	mov    0xc(%ebp),%edx
  801434:	8a 12                	mov    (%edx),%dl
  801436:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801438:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	84 c0                	test   %al,%al
  80143f:	74 03                	je     801444 <strncpy+0x31>
			src++;
  801441:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801444:	ff 45 fc             	incl   -0x4(%ebp)
  801447:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80144a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80144d:	72 d9                	jb     801428 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80144f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801460:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801464:	74 30                	je     801496 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801466:	eb 16                	jmp    80147e <strlcpy+0x2a>
			*dst++ = *src++;
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	8d 50 01             	lea    0x1(%eax),%edx
  80146e:	89 55 08             	mov    %edx,0x8(%ebp)
  801471:	8b 55 0c             	mov    0xc(%ebp),%edx
  801474:	8d 4a 01             	lea    0x1(%edx),%ecx
  801477:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80147a:	8a 12                	mov    (%edx),%dl
  80147c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80147e:	ff 4d 10             	decl   0x10(%ebp)
  801481:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801485:	74 09                	je     801490 <strlcpy+0x3c>
  801487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148a:	8a 00                	mov    (%eax),%al
  80148c:	84 c0                	test   %al,%al
  80148e:	75 d8                	jne    801468 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801496:	8b 55 08             	mov    0x8(%ebp),%edx
  801499:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149c:	29 c2                	sub    %eax,%edx
  80149e:	89 d0                	mov    %edx,%eax
}
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    

008014a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014a5:	eb 06                	jmp    8014ad <strcmp+0xb>
		p++, q++;
  8014a7:	ff 45 08             	incl   0x8(%ebp)
  8014aa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	8a 00                	mov    (%eax),%al
  8014b2:	84 c0                	test   %al,%al
  8014b4:	74 0e                	je     8014c4 <strcmp+0x22>
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	8a 10                	mov    (%eax),%dl
  8014bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014be:	8a 00                	mov    (%eax),%al
  8014c0:	38 c2                	cmp    %al,%dl
  8014c2:	74 e3                	je     8014a7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	8a 00                	mov    (%eax),%al
  8014c9:	0f b6 d0             	movzbl %al,%edx
  8014cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	0f b6 c0             	movzbl %al,%eax
  8014d4:	29 c2                	sub    %eax,%edx
  8014d6:	89 d0                	mov    %edx,%eax
}
  8014d8:	5d                   	pop    %ebp
  8014d9:	c3                   	ret    

008014da <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014dd:	eb 09                	jmp    8014e8 <strncmp+0xe>
		n--, p++, q++;
  8014df:	ff 4d 10             	decl   0x10(%ebp)
  8014e2:	ff 45 08             	incl   0x8(%ebp)
  8014e5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ec:	74 17                	je     801505 <strncmp+0x2b>
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	8a 00                	mov    (%eax),%al
  8014f3:	84 c0                	test   %al,%al
  8014f5:	74 0e                	je     801505 <strncmp+0x2b>
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	8a 10                	mov    (%eax),%dl
  8014fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ff:	8a 00                	mov    (%eax),%al
  801501:	38 c2                	cmp    %al,%dl
  801503:	74 da                	je     8014df <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801505:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801509:	75 07                	jne    801512 <strncmp+0x38>
		return 0;
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
  801510:	eb 14                	jmp    801526 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	8a 00                	mov    (%eax),%al
  801517:	0f b6 d0             	movzbl %al,%edx
  80151a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151d:	8a 00                	mov    (%eax),%al
  80151f:	0f b6 c0             	movzbl %al,%eax
  801522:	29 c2                	sub    %eax,%edx
  801524:	89 d0                	mov    %edx,%eax
}
  801526:	5d                   	pop    %ebp
  801527:	c3                   	ret    

00801528 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	83 ec 04             	sub    $0x4,%esp
  80152e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801531:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801534:	eb 12                	jmp    801548 <strchr+0x20>
		if (*s == c)
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	8a 00                	mov    (%eax),%al
  80153b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80153e:	75 05                	jne    801545 <strchr+0x1d>
			return (char *) s;
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
  801543:	eb 11                	jmp    801556 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801545:	ff 45 08             	incl   0x8(%ebp)
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	84 c0                	test   %al,%al
  80154f:	75 e5                	jne    801536 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801551:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
  80155b:	83 ec 04             	sub    $0x4,%esp
  80155e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801561:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801564:	eb 0d                	jmp    801573 <strfind+0x1b>
		if (*s == c)
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	8a 00                	mov    (%eax),%al
  80156b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80156e:	74 0e                	je     80157e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801570:	ff 45 08             	incl   0x8(%ebp)
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	84 c0                	test   %al,%al
  80157a:	75 ea                	jne    801566 <strfind+0xe>
  80157c:	eb 01                	jmp    80157f <strfind+0x27>
		if (*s == c)
			break;
  80157e:	90                   	nop
	return (char *) s;
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801582:	c9                   	leave  
  801583:	c3                   	ret    

00801584 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801590:	8b 45 10             	mov    0x10(%ebp),%eax
  801593:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801596:	eb 0e                	jmp    8015a6 <memset+0x22>
		*p++ = c;
  801598:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80159b:	8d 50 01             	lea    0x1(%eax),%edx
  80159e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015a6:	ff 4d f8             	decl   -0x8(%ebp)
  8015a9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015ad:	79 e9                	jns    801598 <memset+0x14>
		*p++ = c;

	return v;
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8015c6:	eb 16                	jmp    8015de <memcpy+0x2a>
		*d++ = *s++;
  8015c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015cb:	8d 50 01             	lea    0x1(%eax),%edx
  8015ce:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015d7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015da:	8a 12                	mov    (%edx),%dl
  8015dc:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8015de:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	75 dd                	jne    8015c8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801602:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801605:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801608:	73 50                	jae    80165a <memmove+0x6a>
  80160a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160d:	8b 45 10             	mov    0x10(%ebp),%eax
  801610:	01 d0                	add    %edx,%eax
  801612:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801615:	76 43                	jbe    80165a <memmove+0x6a>
		s += n;
  801617:	8b 45 10             	mov    0x10(%ebp),%eax
  80161a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80161d:	8b 45 10             	mov    0x10(%ebp),%eax
  801620:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801623:	eb 10                	jmp    801635 <memmove+0x45>
			*--d = *--s;
  801625:	ff 4d f8             	decl   -0x8(%ebp)
  801628:	ff 4d fc             	decl   -0x4(%ebp)
  80162b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162e:	8a 10                	mov    (%eax),%dl
  801630:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801633:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801635:	8b 45 10             	mov    0x10(%ebp),%eax
  801638:	8d 50 ff             	lea    -0x1(%eax),%edx
  80163b:	89 55 10             	mov    %edx,0x10(%ebp)
  80163e:	85 c0                	test   %eax,%eax
  801640:	75 e3                	jne    801625 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801642:	eb 23                	jmp    801667 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801644:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801647:	8d 50 01             	lea    0x1(%eax),%edx
  80164a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80164d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801650:	8d 4a 01             	lea    0x1(%edx),%ecx
  801653:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801656:	8a 12                	mov    (%edx),%dl
  801658:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80165a:	8b 45 10             	mov    0x10(%ebp),%eax
  80165d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801660:	89 55 10             	mov    %edx,0x10(%ebp)
  801663:	85 c0                	test   %eax,%eax
  801665:	75 dd                	jne    801644 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801678:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80167e:	eb 2a                	jmp    8016aa <memcmp+0x3e>
		if (*s1 != *s2)
  801680:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801683:	8a 10                	mov    (%eax),%dl
  801685:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	38 c2                	cmp    %al,%dl
  80168c:	74 16                	je     8016a4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80168e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801691:	8a 00                	mov    (%eax),%al
  801693:	0f b6 d0             	movzbl %al,%edx
  801696:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801699:	8a 00                	mov    (%eax),%al
  80169b:	0f b6 c0             	movzbl %al,%eax
  80169e:	29 c2                	sub    %eax,%edx
  8016a0:	89 d0                	mov    %edx,%eax
  8016a2:	eb 18                	jmp    8016bc <memcmp+0x50>
		s1++, s2++;
  8016a4:	ff 45 fc             	incl   -0x4(%ebp)
  8016a7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ad:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b3:	85 c0                	test   %eax,%eax
  8016b5:	75 c9                	jne    801680 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ca:	01 d0                	add    %edx,%eax
  8016cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016cf:	eb 15                	jmp    8016e6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f b6 d0             	movzbl %al,%edx
  8016d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dc:	0f b6 c0             	movzbl %al,%eax
  8016df:	39 c2                	cmp    %eax,%edx
  8016e1:	74 0d                	je     8016f0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016e3:	ff 45 08             	incl   0x8(%ebp)
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016ec:	72 e3                	jb     8016d1 <memfind+0x13>
  8016ee:	eb 01                	jmp    8016f1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016f0:	90                   	nop
	return (void *) s;
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801703:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80170a:	eb 03                	jmp    80170f <strtol+0x19>
		s++;
  80170c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	8a 00                	mov    (%eax),%al
  801714:	3c 20                	cmp    $0x20,%al
  801716:	74 f4                	je     80170c <strtol+0x16>
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	8a 00                	mov    (%eax),%al
  80171d:	3c 09                	cmp    $0x9,%al
  80171f:	74 eb                	je     80170c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	8a 00                	mov    (%eax),%al
  801726:	3c 2b                	cmp    $0x2b,%al
  801728:	75 05                	jne    80172f <strtol+0x39>
		s++;
  80172a:	ff 45 08             	incl   0x8(%ebp)
  80172d:	eb 13                	jmp    801742 <strtol+0x4c>
	else if (*s == '-')
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	8a 00                	mov    (%eax),%al
  801734:	3c 2d                	cmp    $0x2d,%al
  801736:	75 0a                	jne    801742 <strtol+0x4c>
		s++, neg = 1;
  801738:	ff 45 08             	incl   0x8(%ebp)
  80173b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801742:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801746:	74 06                	je     80174e <strtol+0x58>
  801748:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80174c:	75 20                	jne    80176e <strtol+0x78>
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8a 00                	mov    (%eax),%al
  801753:	3c 30                	cmp    $0x30,%al
  801755:	75 17                	jne    80176e <strtol+0x78>
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	40                   	inc    %eax
  80175b:	8a 00                	mov    (%eax),%al
  80175d:	3c 78                	cmp    $0x78,%al
  80175f:	75 0d                	jne    80176e <strtol+0x78>
		s += 2, base = 16;
  801761:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801765:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80176c:	eb 28                	jmp    801796 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80176e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801772:	75 15                	jne    801789 <strtol+0x93>
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	8a 00                	mov    (%eax),%al
  801779:	3c 30                	cmp    $0x30,%al
  80177b:	75 0c                	jne    801789 <strtol+0x93>
		s++, base = 8;
  80177d:	ff 45 08             	incl   0x8(%ebp)
  801780:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801787:	eb 0d                	jmp    801796 <strtol+0xa0>
	else if (base == 0)
  801789:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80178d:	75 07                	jne    801796 <strtol+0xa0>
		base = 10;
  80178f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	8a 00                	mov    (%eax),%al
  80179b:	3c 2f                	cmp    $0x2f,%al
  80179d:	7e 19                	jle    8017b8 <strtol+0xc2>
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	3c 39                	cmp    $0x39,%al
  8017a6:	7f 10                	jg     8017b8 <strtol+0xc2>
			dig = *s - '0';
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	8a 00                	mov    (%eax),%al
  8017ad:	0f be c0             	movsbl %al,%eax
  8017b0:	83 e8 30             	sub    $0x30,%eax
  8017b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017b6:	eb 42                	jmp    8017fa <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	8a 00                	mov    (%eax),%al
  8017bd:	3c 60                	cmp    $0x60,%al
  8017bf:	7e 19                	jle    8017da <strtol+0xe4>
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8a 00                	mov    (%eax),%al
  8017c6:	3c 7a                	cmp    $0x7a,%al
  8017c8:	7f 10                	jg     8017da <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	8a 00                	mov    (%eax),%al
  8017cf:	0f be c0             	movsbl %al,%eax
  8017d2:	83 e8 57             	sub    $0x57,%eax
  8017d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017d8:	eb 20                	jmp    8017fa <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	8a 00                	mov    (%eax),%al
  8017df:	3c 40                	cmp    $0x40,%al
  8017e1:	7e 39                	jle    80181c <strtol+0x126>
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	8a 00                	mov    (%eax),%al
  8017e8:	3c 5a                	cmp    $0x5a,%al
  8017ea:	7f 30                	jg     80181c <strtol+0x126>
			dig = *s - 'A' + 10;
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	8a 00                	mov    (%eax),%al
  8017f1:	0f be c0             	movsbl %al,%eax
  8017f4:	83 e8 37             	sub    $0x37,%eax
  8017f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fd:	3b 45 10             	cmp    0x10(%ebp),%eax
  801800:	7d 19                	jge    80181b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801802:	ff 45 08             	incl   0x8(%ebp)
  801805:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801808:	0f af 45 10          	imul   0x10(%ebp),%eax
  80180c:	89 c2                	mov    %eax,%edx
  80180e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801811:	01 d0                	add    %edx,%eax
  801813:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801816:	e9 7b ff ff ff       	jmp    801796 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80181b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80181c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801820:	74 08                	je     80182a <strtol+0x134>
		*endptr = (char *) s;
  801822:	8b 45 0c             	mov    0xc(%ebp),%eax
  801825:	8b 55 08             	mov    0x8(%ebp),%edx
  801828:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80182a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80182e:	74 07                	je     801837 <strtol+0x141>
  801830:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801833:	f7 d8                	neg    %eax
  801835:	eb 03                	jmp    80183a <strtol+0x144>
  801837:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <ltostr>:

void
ltostr(long value, char *str)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801842:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801849:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801850:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801854:	79 13                	jns    801869 <ltostr+0x2d>
	{
		neg = 1;
  801856:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80185d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801860:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801863:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801866:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801871:	99                   	cltd   
  801872:	f7 f9                	idiv   %ecx
  801874:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801877:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187a:	8d 50 01             	lea    0x1(%eax),%edx
  80187d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801880:	89 c2                	mov    %eax,%edx
  801882:	8b 45 0c             	mov    0xc(%ebp),%eax
  801885:	01 d0                	add    %edx,%eax
  801887:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80188a:	83 c2 30             	add    $0x30,%edx
  80188d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80188f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801892:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801897:	f7 e9                	imul   %ecx
  801899:	c1 fa 02             	sar    $0x2,%edx
  80189c:	89 c8                	mov    %ecx,%eax
  80189e:	c1 f8 1f             	sar    $0x1f,%eax
  8018a1:	29 c2                	sub    %eax,%edx
  8018a3:	89 d0                	mov    %edx,%eax
  8018a5:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018ac:	75 bb                	jne    801869 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b8:	48                   	dec    %eax
  8018b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018c0:	74 3d                	je     8018ff <ltostr+0xc3>
		start = 1 ;
  8018c2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018c9:	eb 34                	jmp    8018ff <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d1:	01 d0                	add    %edx,%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018de:	01 c2                	add    %eax,%edx
  8018e0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e6:	01 c8                	add    %ecx,%eax
  8018e8:	8a 00                	mov    (%eax),%al
  8018ea:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f2:	01 c2                	add    %eax,%edx
  8018f4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018f7:	88 02                	mov    %al,(%edx)
		start++ ;
  8018f9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018fc:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801902:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801905:	7c c4                	jl     8018cb <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801907:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80190a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190d:	01 d0                	add    %edx,%eax
  80190f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801912:	90                   	nop
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80191b:	ff 75 08             	pushl  0x8(%ebp)
  80191e:	e8 73 fa ff ff       	call   801396 <strlen>
  801923:	83 c4 04             	add    $0x4,%esp
  801926:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801929:	ff 75 0c             	pushl  0xc(%ebp)
  80192c:	e8 65 fa ff ff       	call   801396 <strlen>
  801931:	83 c4 04             	add    $0x4,%esp
  801934:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801937:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80193e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801945:	eb 17                	jmp    80195e <strcconcat+0x49>
		final[s] = str1[s] ;
  801947:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80194a:	8b 45 10             	mov    0x10(%ebp),%eax
  80194d:	01 c2                	add    %eax,%edx
  80194f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	01 c8                	add    %ecx,%eax
  801957:	8a 00                	mov    (%eax),%al
  801959:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80195b:	ff 45 fc             	incl   -0x4(%ebp)
  80195e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801961:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801964:	7c e1                	jl     801947 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801966:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80196d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801974:	eb 1f                	jmp    801995 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801976:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801979:	8d 50 01             	lea    0x1(%eax),%edx
  80197c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80197f:	89 c2                	mov    %eax,%edx
  801981:	8b 45 10             	mov    0x10(%ebp),%eax
  801984:	01 c2                	add    %eax,%edx
  801986:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801989:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198c:	01 c8                	add    %ecx,%eax
  80198e:	8a 00                	mov    (%eax),%al
  801990:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801992:	ff 45 f8             	incl   -0x8(%ebp)
  801995:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801998:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80199b:	7c d9                	jl     801976 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80199d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a3:	01 d0                	add    %edx,%eax
  8019a5:	c6 00 00             	movb   $0x0,(%eax)
}
  8019a8:	90                   	nop
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ba:	8b 00                	mov    (%eax),%eax
  8019bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c6:	01 d0                	add    %edx,%eax
  8019c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019ce:	eb 0c                	jmp    8019dc <strsplit+0x31>
			*string++ = 0;
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	8d 50 01             	lea    0x1(%eax),%edx
  8019d6:	89 55 08             	mov    %edx,0x8(%ebp)
  8019d9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	8a 00                	mov    (%eax),%al
  8019e1:	84 c0                	test   %al,%al
  8019e3:	74 18                	je     8019fd <strsplit+0x52>
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	8a 00                	mov    (%eax),%al
  8019ea:	0f be c0             	movsbl %al,%eax
  8019ed:	50                   	push   %eax
  8019ee:	ff 75 0c             	pushl  0xc(%ebp)
  8019f1:	e8 32 fb ff ff       	call   801528 <strchr>
  8019f6:	83 c4 08             	add    $0x8,%esp
  8019f9:	85 c0                	test   %eax,%eax
  8019fb:	75 d3                	jne    8019d0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	8a 00                	mov    (%eax),%al
  801a02:	84 c0                	test   %al,%al
  801a04:	74 5a                	je     801a60 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a06:	8b 45 14             	mov    0x14(%ebp),%eax
  801a09:	8b 00                	mov    (%eax),%eax
  801a0b:	83 f8 0f             	cmp    $0xf,%eax
  801a0e:	75 07                	jne    801a17 <strsplit+0x6c>
		{
			return 0;
  801a10:	b8 00 00 00 00       	mov    $0x0,%eax
  801a15:	eb 66                	jmp    801a7d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a17:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1a:	8b 00                	mov    (%eax),%eax
  801a1c:	8d 48 01             	lea    0x1(%eax),%ecx
  801a1f:	8b 55 14             	mov    0x14(%ebp),%edx
  801a22:	89 0a                	mov    %ecx,(%edx)
  801a24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2e:	01 c2                	add    %eax,%edx
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a35:	eb 03                	jmp    801a3a <strsplit+0x8f>
			string++;
  801a37:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	8a 00                	mov    (%eax),%al
  801a3f:	84 c0                	test   %al,%al
  801a41:	74 8b                	je     8019ce <strsplit+0x23>
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	8a 00                	mov    (%eax),%al
  801a48:	0f be c0             	movsbl %al,%eax
  801a4b:	50                   	push   %eax
  801a4c:	ff 75 0c             	pushl  0xc(%ebp)
  801a4f:	e8 d4 fa ff ff       	call   801528 <strchr>
  801a54:	83 c4 08             	add    $0x8,%esp
  801a57:	85 c0                	test   %eax,%eax
  801a59:	74 dc                	je     801a37 <strsplit+0x8c>
			string++;
	}
  801a5b:	e9 6e ff ff ff       	jmp    8019ce <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a60:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a61:	8b 45 14             	mov    0x14(%ebp),%eax
  801a64:	8b 00                	mov    (%eax),%eax
  801a66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a70:	01 d0                	add    %edx,%eax
  801a72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a78:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801a85:	83 ec 04             	sub    $0x4,%esp
  801a88:	68 5c 2c 80 00       	push   $0x802c5c
  801a8d:	68 3f 01 00 00       	push   $0x13f
  801a92:	68 7e 2c 80 00       	push   $0x802c7e
  801a97:	e8 a1 ed ff ff       	call   80083d <_panic>

00801a9c <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801aa2:	83 ec 0c             	sub    $0xc,%esp
  801aa5:	ff 75 08             	pushl  0x8(%ebp)
  801aa8:	e8 ef 06 00 00       	call   80219c <sys_sbrk>
  801aad:	83 c4 10             	add    $0x10,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801ab8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801abc:	75 07                	jne    801ac5 <malloc+0x13>
  801abe:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac3:	eb 14                	jmp    801ad9 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801ac5:	83 ec 04             	sub    $0x4,%esp
  801ac8:	68 8c 2c 80 00       	push   $0x802c8c
  801acd:	6a 1b                	push   $0x1b
  801acf:	68 b1 2c 80 00       	push   $0x802cb1
  801ad4:	e8 64 ed ff ff       	call   80083d <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801ae1:	83 ec 04             	sub    $0x4,%esp
  801ae4:	68 c0 2c 80 00       	push   $0x802cc0
  801ae9:	6a 29                	push   $0x29
  801aeb:	68 b1 2c 80 00       	push   $0x802cb1
  801af0:	e8 48 ed ff ff       	call   80083d <_panic>

00801af5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	83 ec 18             	sub    $0x18,%esp
  801afb:	8b 45 10             	mov    0x10(%ebp),%eax
  801afe:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801b01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b05:	75 07                	jne    801b0e <smalloc+0x19>
  801b07:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0c:	eb 14                	jmp    801b22 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801b0e:	83 ec 04             	sub    $0x4,%esp
  801b11:	68 e4 2c 80 00       	push   $0x802ce4
  801b16:	6a 38                	push   $0x38
  801b18:	68 b1 2c 80 00       	push   $0x802cb1
  801b1d:	e8 1b ed ff ff       	call   80083d <_panic>
	return NULL;
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801b2a:	83 ec 04             	sub    $0x4,%esp
  801b2d:	68 0c 2d 80 00       	push   $0x802d0c
  801b32:	6a 43                	push   $0x43
  801b34:	68 b1 2c 80 00       	push   $0x802cb1
  801b39:	e8 ff ec ff ff       	call   80083d <_panic>

00801b3e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b44:	83 ec 04             	sub    $0x4,%esp
  801b47:	68 30 2d 80 00       	push   $0x802d30
  801b4c:	6a 5b                	push   $0x5b
  801b4e:	68 b1 2c 80 00       	push   $0x802cb1
  801b53:	e8 e5 ec ff ff       	call   80083d <_panic>

00801b58 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b5e:	83 ec 04             	sub    $0x4,%esp
  801b61:	68 54 2d 80 00       	push   $0x802d54
  801b66:	6a 72                	push   $0x72
  801b68:	68 b1 2c 80 00       	push   $0x802cb1
  801b6d:	e8 cb ec ff ff       	call   80083d <_panic>

00801b72 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b78:	83 ec 04             	sub    $0x4,%esp
  801b7b:	68 7a 2d 80 00       	push   $0x802d7a
  801b80:	6a 7e                	push   $0x7e
  801b82:	68 b1 2c 80 00       	push   $0x802cb1
  801b87:	e8 b1 ec ff ff       	call   80083d <_panic>

00801b8c <shrink>:

}
void shrink(uint32 newSize)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b92:	83 ec 04             	sub    $0x4,%esp
  801b95:	68 7a 2d 80 00       	push   $0x802d7a
  801b9a:	68 83 00 00 00       	push   $0x83
  801b9f:	68 b1 2c 80 00       	push   $0x802cb1
  801ba4:	e8 94 ec ff ff       	call   80083d <_panic>

00801ba9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801baf:	83 ec 04             	sub    $0x4,%esp
  801bb2:	68 7a 2d 80 00       	push   $0x802d7a
  801bb7:	68 88 00 00 00       	push   $0x88
  801bbc:	68 b1 2c 80 00       	push   $0x802cb1
  801bc1:	e8 77 ec ff ff       	call   80083d <_panic>

00801bc6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	57                   	push   %edi
  801bca:	56                   	push   %esi
  801bcb:	53                   	push   %ebx
  801bcc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bd8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bdb:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bde:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801be1:	cd 30                	int    $0x30
  801be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801be9:	83 c4 10             	add    $0x10,%esp
  801bec:	5b                   	pop    %ebx
  801bed:	5e                   	pop    %esi
  801bee:	5f                   	pop    %edi
  801bef:	5d                   	pop    %ebp
  801bf0:	c3                   	ret    

00801bf1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 04             	sub    $0x4,%esp
  801bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bfa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801bfd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	52                   	push   %edx
  801c09:	ff 75 0c             	pushl  0xc(%ebp)
  801c0c:	50                   	push   %eax
  801c0d:	6a 00                	push   $0x0
  801c0f:	e8 b2 ff ff ff       	call   801bc6 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	90                   	nop
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_cgetc>:

int
sys_cgetc(void)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 02                	push   $0x2
  801c29:	e8 98 ff ff ff       	call   801bc6 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 03                	push   $0x3
  801c42:	e8 7f ff ff ff       	call   801bc6 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	90                   	nop
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 04                	push   $0x4
  801c5c:	e8 65 ff ff ff       	call   801bc6 <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	90                   	nop
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	52                   	push   %edx
  801c77:	50                   	push   %eax
  801c78:	6a 08                	push   $0x8
  801c7a:	e8 47 ff ff ff       	call   801bc6 <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	56                   	push   %esi
  801c88:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c89:	8b 75 18             	mov    0x18(%ebp),%esi
  801c8c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	56                   	push   %esi
  801c99:	53                   	push   %ebx
  801c9a:	51                   	push   %ecx
  801c9b:	52                   	push   %edx
  801c9c:	50                   	push   %eax
  801c9d:	6a 09                	push   $0x9
  801c9f:	e8 22 ff ff ff       	call   801bc6 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801caa:	5b                   	pop    %ebx
  801cab:	5e                   	pop    %esi
  801cac:	5d                   	pop    %ebp
  801cad:	c3                   	ret    

00801cae <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	52                   	push   %edx
  801cbe:	50                   	push   %eax
  801cbf:	6a 0a                	push   $0xa
  801cc1:	e8 00 ff ff ff       	call   801bc6 <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	ff 75 0c             	pushl  0xc(%ebp)
  801cd7:	ff 75 08             	pushl  0x8(%ebp)
  801cda:	6a 0b                	push   $0xb
  801cdc:	e8 e5 fe ff ff       	call   801bc6 <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 0c                	push   $0xc
  801cf5:	e8 cc fe ff ff       	call   801bc6 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 0d                	push   $0xd
  801d0e:	e8 b3 fe ff ff       	call   801bc6 <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 0e                	push   $0xe
  801d27:	e8 9a fe ff ff       	call   801bc6 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 0f                	push   $0xf
  801d40:	e8 81 fe ff ff       	call   801bc6 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	ff 75 08             	pushl  0x8(%ebp)
  801d58:	6a 10                	push   $0x10
  801d5a:	e8 67 fe ff ff       	call   801bc6 <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 11                	push   $0x11
  801d73:	e8 4e fe ff ff       	call   801bc6 <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
}
  801d7b:	90                   	nop
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_cputc>:

void
sys_cputc(const char c)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 04             	sub    $0x4,%esp
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d8a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	50                   	push   %eax
  801d97:	6a 01                	push   $0x1
  801d99:	e8 28 fe ff ff       	call   801bc6 <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
}
  801da1:	90                   	nop
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 14                	push   $0x14
  801db3:	e8 0e fe ff ff       	call   801bc6 <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
}
  801dbb:	90                   	nop
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 04             	sub    $0x4,%esp
  801dc4:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801dca:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dcd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	6a 00                	push   $0x0
  801dd6:	51                   	push   %ecx
  801dd7:	52                   	push   %edx
  801dd8:	ff 75 0c             	pushl  0xc(%ebp)
  801ddb:	50                   	push   %eax
  801ddc:	6a 15                	push   $0x15
  801dde:	e8 e3 fd ff ff       	call   801bc6 <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	52                   	push   %edx
  801df8:	50                   	push   %eax
  801df9:	6a 16                	push   $0x16
  801dfb:	e8 c6 fd ff ff       	call   801bc6 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	51                   	push   %ecx
  801e16:	52                   	push   %edx
  801e17:	50                   	push   %eax
  801e18:	6a 17                	push   $0x17
  801e1a:	e8 a7 fd ff ff       	call   801bc6 <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	52                   	push   %edx
  801e34:	50                   	push   %eax
  801e35:	6a 18                	push   $0x18
  801e37:	e8 8a fd ff ff       	call   801bc6 <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	6a 00                	push   $0x0
  801e49:	ff 75 14             	pushl  0x14(%ebp)
  801e4c:	ff 75 10             	pushl  0x10(%ebp)
  801e4f:	ff 75 0c             	pushl  0xc(%ebp)
  801e52:	50                   	push   %eax
  801e53:	6a 19                	push   $0x19
  801e55:	e8 6c fd ff ff       	call   801bc6 <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <sys_run_env>:

void sys_run_env(int32 envId)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e62:	8b 45 08             	mov    0x8(%ebp),%eax
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	50                   	push   %eax
  801e6e:	6a 1a                	push   $0x1a
  801e70:	e8 51 fd ff ff       	call   801bc6 <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
}
  801e78:	90                   	nop
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	50                   	push   %eax
  801e8a:	6a 1b                	push   $0x1b
  801e8c:	e8 35 fd ff ff       	call   801bc6 <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 05                	push   $0x5
  801ea5:	e8 1c fd ff ff       	call   801bc6 <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 06                	push   $0x6
  801ebe:	e8 03 fd ff ff       	call   801bc6 <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 07                	push   $0x7
  801ed7:	e8 ea fc ff ff       	call   801bc6 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_exit_env>:


void sys_exit_env(void)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 1c                	push   $0x1c
  801ef0:	e8 d1 fc ff ff       	call   801bc6 <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	90                   	nop
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f01:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f04:	8d 50 04             	lea    0x4(%eax),%edx
  801f07:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	52                   	push   %edx
  801f11:	50                   	push   %eax
  801f12:	6a 1d                	push   $0x1d
  801f14:	e8 ad fc ff ff       	call   801bc6 <syscall>
  801f19:	83 c4 18             	add    $0x18,%esp
	return result;
  801f1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f25:	89 01                	mov    %eax,(%ecx)
  801f27:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	c9                   	leave  
  801f2e:	c2 04 00             	ret    $0x4

00801f31 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	ff 75 10             	pushl  0x10(%ebp)
  801f3b:	ff 75 0c             	pushl  0xc(%ebp)
  801f3e:	ff 75 08             	pushl  0x8(%ebp)
  801f41:	6a 13                	push   $0x13
  801f43:	e8 7e fc ff ff       	call   801bc6 <syscall>
  801f48:	83 c4 18             	add    $0x18,%esp
	return ;
  801f4b:	90                   	nop
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <sys_rcr2>:
uint32 sys_rcr2()
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 1e                	push   $0x1e
  801f5d:	e8 64 fc ff ff       	call   801bc6 <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	83 ec 04             	sub    $0x4,%esp
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f73:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	50                   	push   %eax
  801f80:	6a 1f                	push   $0x1f
  801f82:	e8 3f fc ff ff       	call   801bc6 <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
	return ;
  801f8a:	90                   	nop
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <rsttst>:
void rsttst()
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 21                	push   $0x21
  801f9c:	e8 25 fc ff ff       	call   801bc6 <syscall>
  801fa1:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa4:	90                   	nop
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	83 ec 04             	sub    $0x4,%esp
  801fad:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fb3:	8b 55 18             	mov    0x18(%ebp),%edx
  801fb6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fba:	52                   	push   %edx
  801fbb:	50                   	push   %eax
  801fbc:	ff 75 10             	pushl  0x10(%ebp)
  801fbf:	ff 75 0c             	pushl  0xc(%ebp)
  801fc2:	ff 75 08             	pushl  0x8(%ebp)
  801fc5:	6a 20                	push   $0x20
  801fc7:	e8 fa fb ff ff       	call   801bc6 <syscall>
  801fcc:	83 c4 18             	add    $0x18,%esp
	return ;
  801fcf:	90                   	nop
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <chktst>:
void chktst(uint32 n)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	ff 75 08             	pushl  0x8(%ebp)
  801fe0:	6a 22                	push   $0x22
  801fe2:	e8 df fb ff ff       	call   801bc6 <syscall>
  801fe7:	83 c4 18             	add    $0x18,%esp
	return ;
  801fea:	90                   	nop
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <inctst>:

void inctst()
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 23                	push   $0x23
  801ffc:	e8 c5 fb ff ff       	call   801bc6 <syscall>
  802001:	83 c4 18             	add    $0x18,%esp
	return ;
  802004:	90                   	nop
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <gettst>:
uint32 gettst()
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 24                	push   $0x24
  802016:	e8 ab fb ff ff       	call   801bc6 <syscall>
  80201b:	83 c4 18             	add    $0x18,%esp
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 25                	push   $0x25
  802032:	e8 8f fb ff ff       	call   801bc6 <syscall>
  802037:	83 c4 18             	add    $0x18,%esp
  80203a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80203d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802041:	75 07                	jne    80204a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802043:	b8 01 00 00 00       	mov    $0x1,%eax
  802048:	eb 05                	jmp    80204f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80204a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 25                	push   $0x25
  802063:	e8 5e fb ff ff       	call   801bc6 <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
  80206b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80206e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802072:	75 07                	jne    80207b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802074:	b8 01 00 00 00       	mov    $0x1,%eax
  802079:	eb 05                	jmp    802080 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80207b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 25                	push   $0x25
  802094:	e8 2d fb ff ff       	call   801bc6 <syscall>
  802099:	83 c4 18             	add    $0x18,%esp
  80209c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80209f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020a3:	75 07                	jne    8020ac <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8020aa:	eb 05                	jmp    8020b1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 25                	push   $0x25
  8020c5:	e8 fc fa ff ff       	call   801bc6 <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
  8020cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020d0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020d4:	75 07                	jne    8020dd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020db:	eb 05                	jmp    8020e2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	ff 75 08             	pushl  0x8(%ebp)
  8020f2:	6a 26                	push   $0x26
  8020f4:	e8 cd fa ff ff       	call   801bc6 <syscall>
  8020f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8020fc:	90                   	nop
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802103:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802106:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802109:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	6a 00                	push   $0x0
  802111:	53                   	push   %ebx
  802112:	51                   	push   %ecx
  802113:	52                   	push   %edx
  802114:	50                   	push   %eax
  802115:	6a 27                	push   $0x27
  802117:	e8 aa fa ff ff       	call   801bc6 <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
}
  80211f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802127:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	52                   	push   %edx
  802134:	50                   	push   %eax
  802135:	6a 28                	push   $0x28
  802137:	e8 8a fa ff ff       	call   801bc6 <syscall>
  80213c:	83 c4 18             	add    $0x18,%esp
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802144:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802147:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214a:	8b 45 08             	mov    0x8(%ebp),%eax
  80214d:	6a 00                	push   $0x0
  80214f:	51                   	push   %ecx
  802150:	ff 75 10             	pushl  0x10(%ebp)
  802153:	52                   	push   %edx
  802154:	50                   	push   %eax
  802155:	6a 29                	push   $0x29
  802157:	e8 6a fa ff ff       	call   801bc6 <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
}
  80215f:	c9                   	leave  
  802160:	c3                   	ret    

00802161 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	ff 75 10             	pushl  0x10(%ebp)
  80216b:	ff 75 0c             	pushl  0xc(%ebp)
  80216e:	ff 75 08             	pushl  0x8(%ebp)
  802171:	6a 12                	push   $0x12
  802173:	e8 4e fa ff ff       	call   801bc6 <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
	return ;
  80217b:	90                   	nop
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802181:	8b 55 0c             	mov    0xc(%ebp),%edx
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	52                   	push   %edx
  80218e:	50                   	push   %eax
  80218f:	6a 2a                	push   $0x2a
  802191:	e8 30 fa ff ff       	call   801bc6 <syscall>
  802196:	83 c4 18             	add    $0x18,%esp
	return;
  802199:	90                   	nop
}
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	50                   	push   %eax
  8021ab:	6a 2b                	push   $0x2b
  8021ad:	e8 14 fa ff ff       	call   801bc6 <syscall>
  8021b2:	83 c4 18             	add    $0x18,%esp
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	ff 75 0c             	pushl  0xc(%ebp)
  8021c3:	ff 75 08             	pushl  0x8(%ebp)
  8021c6:	6a 2c                	push   $0x2c
  8021c8:	e8 f9 f9 ff ff       	call   801bc6 <syscall>
  8021cd:	83 c4 18             	add    $0x18,%esp
	return;
  8021d0:	90                   	nop
}
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	ff 75 0c             	pushl  0xc(%ebp)
  8021df:	ff 75 08             	pushl  0x8(%ebp)
  8021e2:	6a 2d                	push   $0x2d
  8021e4:	e8 dd f9 ff ff       	call   801bc6 <syscall>
  8021e9:	83 c4 18             	add    $0x18,%esp
	return;
  8021ec:	90                   	nop
}
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    
  8021ef:	90                   	nop

008021f0 <__udivdi3>:
  8021f0:	55                   	push   %ebp
  8021f1:	57                   	push   %edi
  8021f2:	56                   	push   %esi
  8021f3:	53                   	push   %ebx
  8021f4:	83 ec 1c             	sub    $0x1c,%esp
  8021f7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8021fb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8021ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802203:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802207:	89 ca                	mov    %ecx,%edx
  802209:	89 f8                	mov    %edi,%eax
  80220b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80220f:	85 f6                	test   %esi,%esi
  802211:	75 2d                	jne    802240 <__udivdi3+0x50>
  802213:	39 cf                	cmp    %ecx,%edi
  802215:	77 65                	ja     80227c <__udivdi3+0x8c>
  802217:	89 fd                	mov    %edi,%ebp
  802219:	85 ff                	test   %edi,%edi
  80221b:	75 0b                	jne    802228 <__udivdi3+0x38>
  80221d:	b8 01 00 00 00       	mov    $0x1,%eax
  802222:	31 d2                	xor    %edx,%edx
  802224:	f7 f7                	div    %edi
  802226:	89 c5                	mov    %eax,%ebp
  802228:	31 d2                	xor    %edx,%edx
  80222a:	89 c8                	mov    %ecx,%eax
  80222c:	f7 f5                	div    %ebp
  80222e:	89 c1                	mov    %eax,%ecx
  802230:	89 d8                	mov    %ebx,%eax
  802232:	f7 f5                	div    %ebp
  802234:	89 cf                	mov    %ecx,%edi
  802236:	89 fa                	mov    %edi,%edx
  802238:	83 c4 1c             	add    $0x1c,%esp
  80223b:	5b                   	pop    %ebx
  80223c:	5e                   	pop    %esi
  80223d:	5f                   	pop    %edi
  80223e:	5d                   	pop    %ebp
  80223f:	c3                   	ret    
  802240:	39 ce                	cmp    %ecx,%esi
  802242:	77 28                	ja     80226c <__udivdi3+0x7c>
  802244:	0f bd fe             	bsr    %esi,%edi
  802247:	83 f7 1f             	xor    $0x1f,%edi
  80224a:	75 40                	jne    80228c <__udivdi3+0x9c>
  80224c:	39 ce                	cmp    %ecx,%esi
  80224e:	72 0a                	jb     80225a <__udivdi3+0x6a>
  802250:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802254:	0f 87 9e 00 00 00    	ja     8022f8 <__udivdi3+0x108>
  80225a:	b8 01 00 00 00       	mov    $0x1,%eax
  80225f:	89 fa                	mov    %edi,%edx
  802261:	83 c4 1c             	add    $0x1c,%esp
  802264:	5b                   	pop    %ebx
  802265:	5e                   	pop    %esi
  802266:	5f                   	pop    %edi
  802267:	5d                   	pop    %ebp
  802268:	c3                   	ret    
  802269:	8d 76 00             	lea    0x0(%esi),%esi
  80226c:	31 ff                	xor    %edi,%edi
  80226e:	31 c0                	xor    %eax,%eax
  802270:	89 fa                	mov    %edi,%edx
  802272:	83 c4 1c             	add    $0x1c,%esp
  802275:	5b                   	pop    %ebx
  802276:	5e                   	pop    %esi
  802277:	5f                   	pop    %edi
  802278:	5d                   	pop    %ebp
  802279:	c3                   	ret    
  80227a:	66 90                	xchg   %ax,%ax
  80227c:	89 d8                	mov    %ebx,%eax
  80227e:	f7 f7                	div    %edi
  802280:	31 ff                	xor    %edi,%edi
  802282:	89 fa                	mov    %edi,%edx
  802284:	83 c4 1c             	add    $0x1c,%esp
  802287:	5b                   	pop    %ebx
  802288:	5e                   	pop    %esi
  802289:	5f                   	pop    %edi
  80228a:	5d                   	pop    %ebp
  80228b:	c3                   	ret    
  80228c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802291:	89 eb                	mov    %ebp,%ebx
  802293:	29 fb                	sub    %edi,%ebx
  802295:	89 f9                	mov    %edi,%ecx
  802297:	d3 e6                	shl    %cl,%esi
  802299:	89 c5                	mov    %eax,%ebp
  80229b:	88 d9                	mov    %bl,%cl
  80229d:	d3 ed                	shr    %cl,%ebp
  80229f:	89 e9                	mov    %ebp,%ecx
  8022a1:	09 f1                	or     %esi,%ecx
  8022a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8022a7:	89 f9                	mov    %edi,%ecx
  8022a9:	d3 e0                	shl    %cl,%eax
  8022ab:	89 c5                	mov    %eax,%ebp
  8022ad:	89 d6                	mov    %edx,%esi
  8022af:	88 d9                	mov    %bl,%cl
  8022b1:	d3 ee                	shr    %cl,%esi
  8022b3:	89 f9                	mov    %edi,%ecx
  8022b5:	d3 e2                	shl    %cl,%edx
  8022b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022bb:	88 d9                	mov    %bl,%cl
  8022bd:	d3 e8                	shr    %cl,%eax
  8022bf:	09 c2                	or     %eax,%edx
  8022c1:	89 d0                	mov    %edx,%eax
  8022c3:	89 f2                	mov    %esi,%edx
  8022c5:	f7 74 24 0c          	divl   0xc(%esp)
  8022c9:	89 d6                	mov    %edx,%esi
  8022cb:	89 c3                	mov    %eax,%ebx
  8022cd:	f7 e5                	mul    %ebp
  8022cf:	39 d6                	cmp    %edx,%esi
  8022d1:	72 19                	jb     8022ec <__udivdi3+0xfc>
  8022d3:	74 0b                	je     8022e0 <__udivdi3+0xf0>
  8022d5:	89 d8                	mov    %ebx,%eax
  8022d7:	31 ff                	xor    %edi,%edi
  8022d9:	e9 58 ff ff ff       	jmp    802236 <__udivdi3+0x46>
  8022de:	66 90                	xchg   %ax,%ax
  8022e0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022e4:	89 f9                	mov    %edi,%ecx
  8022e6:	d3 e2                	shl    %cl,%edx
  8022e8:	39 c2                	cmp    %eax,%edx
  8022ea:	73 e9                	jae    8022d5 <__udivdi3+0xe5>
  8022ec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022ef:	31 ff                	xor    %edi,%edi
  8022f1:	e9 40 ff ff ff       	jmp    802236 <__udivdi3+0x46>
  8022f6:	66 90                	xchg   %ax,%ax
  8022f8:	31 c0                	xor    %eax,%eax
  8022fa:	e9 37 ff ff ff       	jmp    802236 <__udivdi3+0x46>
  8022ff:	90                   	nop

00802300 <__umoddi3>:
  802300:	55                   	push   %ebp
  802301:	57                   	push   %edi
  802302:	56                   	push   %esi
  802303:	53                   	push   %ebx
  802304:	83 ec 1c             	sub    $0x1c,%esp
  802307:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80230b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80230f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802313:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802317:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80231b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80231f:	89 f3                	mov    %esi,%ebx
  802321:	89 fa                	mov    %edi,%edx
  802323:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802327:	89 34 24             	mov    %esi,(%esp)
  80232a:	85 c0                	test   %eax,%eax
  80232c:	75 1a                	jne    802348 <__umoddi3+0x48>
  80232e:	39 f7                	cmp    %esi,%edi
  802330:	0f 86 a2 00 00 00    	jbe    8023d8 <__umoddi3+0xd8>
  802336:	89 c8                	mov    %ecx,%eax
  802338:	89 f2                	mov    %esi,%edx
  80233a:	f7 f7                	div    %edi
  80233c:	89 d0                	mov    %edx,%eax
  80233e:	31 d2                	xor    %edx,%edx
  802340:	83 c4 1c             	add    $0x1c,%esp
  802343:	5b                   	pop    %ebx
  802344:	5e                   	pop    %esi
  802345:	5f                   	pop    %edi
  802346:	5d                   	pop    %ebp
  802347:	c3                   	ret    
  802348:	39 f0                	cmp    %esi,%eax
  80234a:	0f 87 ac 00 00 00    	ja     8023fc <__umoddi3+0xfc>
  802350:	0f bd e8             	bsr    %eax,%ebp
  802353:	83 f5 1f             	xor    $0x1f,%ebp
  802356:	0f 84 ac 00 00 00    	je     802408 <__umoddi3+0x108>
  80235c:	bf 20 00 00 00       	mov    $0x20,%edi
  802361:	29 ef                	sub    %ebp,%edi
  802363:	89 fe                	mov    %edi,%esi
  802365:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802369:	89 e9                	mov    %ebp,%ecx
  80236b:	d3 e0                	shl    %cl,%eax
  80236d:	89 d7                	mov    %edx,%edi
  80236f:	89 f1                	mov    %esi,%ecx
  802371:	d3 ef                	shr    %cl,%edi
  802373:	09 c7                	or     %eax,%edi
  802375:	89 e9                	mov    %ebp,%ecx
  802377:	d3 e2                	shl    %cl,%edx
  802379:	89 14 24             	mov    %edx,(%esp)
  80237c:	89 d8                	mov    %ebx,%eax
  80237e:	d3 e0                	shl    %cl,%eax
  802380:	89 c2                	mov    %eax,%edx
  802382:	8b 44 24 08          	mov    0x8(%esp),%eax
  802386:	d3 e0                	shl    %cl,%eax
  802388:	89 44 24 04          	mov    %eax,0x4(%esp)
  80238c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802390:	89 f1                	mov    %esi,%ecx
  802392:	d3 e8                	shr    %cl,%eax
  802394:	09 d0                	or     %edx,%eax
  802396:	d3 eb                	shr    %cl,%ebx
  802398:	89 da                	mov    %ebx,%edx
  80239a:	f7 f7                	div    %edi
  80239c:	89 d3                	mov    %edx,%ebx
  80239e:	f7 24 24             	mull   (%esp)
  8023a1:	89 c6                	mov    %eax,%esi
  8023a3:	89 d1                	mov    %edx,%ecx
  8023a5:	39 d3                	cmp    %edx,%ebx
  8023a7:	0f 82 87 00 00 00    	jb     802434 <__umoddi3+0x134>
  8023ad:	0f 84 91 00 00 00    	je     802444 <__umoddi3+0x144>
  8023b3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023b7:	29 f2                	sub    %esi,%edx
  8023b9:	19 cb                	sbb    %ecx,%ebx
  8023bb:	89 d8                	mov    %ebx,%eax
  8023bd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8023c1:	d3 e0                	shl    %cl,%eax
  8023c3:	89 e9                	mov    %ebp,%ecx
  8023c5:	d3 ea                	shr    %cl,%edx
  8023c7:	09 d0                	or     %edx,%eax
  8023c9:	89 e9                	mov    %ebp,%ecx
  8023cb:	d3 eb                	shr    %cl,%ebx
  8023cd:	89 da                	mov    %ebx,%edx
  8023cf:	83 c4 1c             	add    $0x1c,%esp
  8023d2:	5b                   	pop    %ebx
  8023d3:	5e                   	pop    %esi
  8023d4:	5f                   	pop    %edi
  8023d5:	5d                   	pop    %ebp
  8023d6:	c3                   	ret    
  8023d7:	90                   	nop
  8023d8:	89 fd                	mov    %edi,%ebp
  8023da:	85 ff                	test   %edi,%edi
  8023dc:	75 0b                	jne    8023e9 <__umoddi3+0xe9>
  8023de:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e3:	31 d2                	xor    %edx,%edx
  8023e5:	f7 f7                	div    %edi
  8023e7:	89 c5                	mov    %eax,%ebp
  8023e9:	89 f0                	mov    %esi,%eax
  8023eb:	31 d2                	xor    %edx,%edx
  8023ed:	f7 f5                	div    %ebp
  8023ef:	89 c8                	mov    %ecx,%eax
  8023f1:	f7 f5                	div    %ebp
  8023f3:	89 d0                	mov    %edx,%eax
  8023f5:	e9 44 ff ff ff       	jmp    80233e <__umoddi3+0x3e>
  8023fa:	66 90                	xchg   %ax,%ax
  8023fc:	89 c8                	mov    %ecx,%eax
  8023fe:	89 f2                	mov    %esi,%edx
  802400:	83 c4 1c             	add    $0x1c,%esp
  802403:	5b                   	pop    %ebx
  802404:	5e                   	pop    %esi
  802405:	5f                   	pop    %edi
  802406:	5d                   	pop    %ebp
  802407:	c3                   	ret    
  802408:	3b 04 24             	cmp    (%esp),%eax
  80240b:	72 06                	jb     802413 <__umoddi3+0x113>
  80240d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802411:	77 0f                	ja     802422 <__umoddi3+0x122>
  802413:	89 f2                	mov    %esi,%edx
  802415:	29 f9                	sub    %edi,%ecx
  802417:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80241b:	89 14 24             	mov    %edx,(%esp)
  80241e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802422:	8b 44 24 04          	mov    0x4(%esp),%eax
  802426:	8b 14 24             	mov    (%esp),%edx
  802429:	83 c4 1c             	add    $0x1c,%esp
  80242c:	5b                   	pop    %ebx
  80242d:	5e                   	pop    %esi
  80242e:	5f                   	pop    %edi
  80242f:	5d                   	pop    %ebp
  802430:	c3                   	ret    
  802431:	8d 76 00             	lea    0x0(%esi),%esi
  802434:	2b 04 24             	sub    (%esp),%eax
  802437:	19 fa                	sbb    %edi,%edx
  802439:	89 d1                	mov    %edx,%ecx
  80243b:	89 c6                	mov    %eax,%esi
  80243d:	e9 71 ff ff ff       	jmp    8023b3 <__umoddi3+0xb3>
  802442:	66 90                	xchg   %ax,%ax
  802444:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802448:	72 ea                	jb     802434 <__umoddi3+0x134>
  80244a:	89 d9                	mov    %ebx,%ecx
  80244c:	e9 62 ff ff ff       	jmp    8023b3 <__umoddi3+0xb3>
