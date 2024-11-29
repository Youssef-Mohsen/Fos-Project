
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
  800041:	e8 eb 20 00 00       	call   802131 <sys_lock_cons>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 44 80 00       	push   $0x804400
  80004e:	e8 af 0a 00 00       	call   800b02 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 44 80 00       	push   $0x804402
  80005e:	e8 9f 0a 00 00       	call   800b02 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 20 44 80 00       	push   $0x804420
  80006e:	e8 8f 0a 00 00       	call   800b02 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 44 80 00       	push   $0x804402
  80007e:	e8 7f 0a 00 00       	call   800b02 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 44 80 00       	push   $0x804400
  80008e:	e8 6f 0a 00 00       	call   800b02 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 40 44 80 00       	push   $0x804440
  8000a2:	e8 ef 10 00 00       	call   801196 <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 5f 44 80 00       	push   $0x80445f
  8000b6:	e8 1d 1d 00 00       	call   801dd8 <smalloc>
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
  8000ef:	68 67 44 80 00       	push   $0x804467
  8000f4:	e8 df 1c 00 00       	call   801dd8 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 6c 44 80 00       	push   $0x80446c
  800107:	e8 f6 09 00 00       	call   800b02 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 8e 44 80 00       	push   $0x80448e
  800117:	e8 e6 09 00 00       	call   800b02 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 9c 44 80 00       	push   $0x80449c
  800127:	e8 d6 09 00 00       	call   800b02 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 ab 44 80 00       	push   $0x8044ab
  800137:	e8 c6 09 00 00       	call   800b02 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 bb 44 80 00       	push   $0x8044bb
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
  800186:	e8 c0 1f 00 00       	call   80214b <sys_unlock_cons>
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
  8001f6:	68 c4 44 80 00       	push   $0x8044c4
  8001fb:	e8 d8 1b 00 00       	call   801dd8 <smalloc>
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
  800235:	68 d2 44 80 00       	push   $0x8044d2
  80023a:	e8 00 21 00 00       	call   80233f <sys_create_env>
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
  80026b:	68 db 44 80 00       	push   $0x8044db
  800270:	e8 ca 20 00 00       	call   80233f <sys_create_env>
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
  8002a1:	68 e4 44 80 00       	push   $0x8044e4
  8002a6:	e8 94 20 00 00       	call   80233f <sys_create_env>
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
  8002c6:	68 f0 44 80 00       	push   $0x8044f0
  8002cb:	6a 4e                	push   $0x4e
  8002cd:	68 05 45 80 00       	push   $0x804505
  8002d2:	e8 6e 05 00 00       	call   800845 <_panic>

	sys_run_env(envIdQuickSort);
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	ff 75 dc             	pushl  -0x24(%ebp)
  8002dd:	e8 7b 20 00 00       	call   80235d <sys_run_env>
  8002e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002eb:	e8 6d 20 00 00       	call   80235d <sys_run_env>
  8002f0:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f9:	e8 5f 20 00 00       	call   80235d <sys_run_env>
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
  800340:	68 23 45 80 00       	push   $0x804523
  800345:	ff 75 dc             	pushl  -0x24(%ebp)
  800348:	e8 95 1b 00 00       	call   801ee2 <sget>
  80034d:	83 c4 10             	add    $0x10,%esp
  800350:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  800353:	83 ec 08             	sub    $0x8,%esp
  800356:	68 32 45 80 00       	push   $0x804532
  80035b:	ff 75 d8             	pushl  -0x28(%ebp)
  80035e:	e8 7f 1b 00 00       	call   801ee2 <sget>
  800363:	83 c4 10             	add    $0x10,%esp
  800366:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800369:	83 ec 08             	sub    $0x8,%esp
  80036c:	68 41 45 80 00       	push   $0x804541
  800371:	ff 75 d4             	pushl  -0x2c(%ebp)
  800374:	e8 69 1b 00 00       	call   801ee2 <sget>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	68 46 45 80 00       	push   $0x804546
  800387:	ff 75 d4             	pushl  -0x2c(%ebp)
  80038a:	e8 53 1b 00 00       	call   801ee2 <sget>
  80038f:	83 c4 10             	add    $0x10,%esp
  800392:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  800395:	83 ec 08             	sub    $0x8,%esp
  800398:	68 4a 45 80 00       	push   $0x80454a
  80039d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003a0:	e8 3d 1b 00 00       	call   801ee2 <sget>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003ab:	83 ec 08             	sub    $0x8,%esp
  8003ae:	68 4e 45 80 00       	push   $0x80454e
  8003b3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003b6:	e8 27 1b 00 00       	call   801ee2 <sget>
  8003bb:	83 c4 10             	add    $0x10,%esp
  8003be:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	68 52 45 80 00       	push   $0x804552
  8003c9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003cc:	e8 11 1b 00 00       	call   801ee2 <sget>
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
  8003f4:	68 58 45 80 00       	push   $0x804558
  8003f9:	6a 69                	push   $0x69
  8003fb:	68 05 45 80 00       	push   $0x804505
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
  800422:	68 80 45 80 00       	push   $0x804580
  800427:	6a 6b                	push   $0x6b
  800429:	68 05 45 80 00       	push   $0x804505
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
  8004d5:	68 a8 45 80 00       	push   $0x8045a8
  8004da:	6a 78                	push   $0x78
  8004dc:	68 05 45 80 00       	push   $0x804505
  8004e1:	e8 5f 03 00 00       	call   800845 <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004e6:	83 ec 0c             	sub    $0xc,%esp
  8004e9:	68 d8 45 80 00       	push   $0x8045d8
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
  8006de:	e8 99 1b 00 00       	call   80227c <sys_cputc>
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
  8006ef:	e8 24 1a 00 00       	call   802118 <sys_cgetc>
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
  80070c:	e8 9c 1c 00 00       	call   8023ad <sys_getenvindex>
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
  80077a:	e8 b2 19 00 00       	call   802131 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80077f:	83 ec 0c             	sub    $0xc,%esp
  800782:	68 54 46 80 00       	push   $0x804654
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
  8007aa:	68 7c 46 80 00       	push   $0x80467c
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
  8007db:	68 a4 46 80 00       	push   $0x8046a4
  8007e0:	e8 1d 03 00 00       	call   800b02 <cprintf>
  8007e5:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8007ed:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	50                   	push   %eax
  8007f7:	68 fc 46 80 00       	push   $0x8046fc
  8007fc:	e8 01 03 00 00       	call   800b02 <cprintf>
  800801:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800804:	83 ec 0c             	sub    $0xc,%esp
  800807:	68 54 46 80 00       	push   $0x804654
  80080c:	e8 f1 02 00 00       	call   800b02 <cprintf>
  800811:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800814:	e8 32 19 00 00       	call   80214b <sys_unlock_cons>
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
  80082c:	e8 48 1b 00 00       	call   802379 <sys_destroy_env>
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
  80083d:	e8 9d 1b 00 00       	call   8023df <sys_exit_env>
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
  800854:	a1 50 50 80 00       	mov    0x805050,%eax
  800859:	85 c0                	test   %eax,%eax
  80085b:	74 16                	je     800873 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80085d:	a1 50 50 80 00       	mov    0x805050,%eax
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	50                   	push   %eax
  800866:	68 10 47 80 00       	push   $0x804710
  80086b:	e8 92 02 00 00       	call   800b02 <cprintf>
  800870:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800873:	a1 00 50 80 00       	mov    0x805000,%eax
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	50                   	push   %eax
  80087f:	68 15 47 80 00       	push   $0x804715
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
  8008a3:	68 31 47 80 00       	push   $0x804731
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
  8008d2:	68 34 47 80 00       	push   $0x804734
  8008d7:	6a 26                	push   $0x26
  8008d9:	68 80 47 80 00       	push   $0x804780
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
  8009a7:	68 8c 47 80 00       	push   $0x80478c
  8009ac:	6a 3a                	push   $0x3a
  8009ae:	68 80 47 80 00       	push   $0x804780
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
  800a1a:	68 e0 47 80 00       	push   $0x8047e0
  800a1f:	6a 44                	push   $0x44
  800a21:	68 80 47 80 00       	push   $0x804780
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
  800a59:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  800a74:	e8 76 16 00 00       	call   8020ef <sys_cputs>
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
  800ace:	a0 2c 50 80 00       	mov    0x80502c,%al
  800ad3:	0f b6 c0             	movzbl %al,%eax
  800ad6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800adc:	83 ec 04             	sub    $0x4,%esp
  800adf:	50                   	push   %eax
  800ae0:	52                   	push   %edx
  800ae1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ae7:	83 c0 08             	add    $0x8,%eax
  800aea:	50                   	push   %eax
  800aeb:	e8 ff 15 00 00       	call   8020ef <sys_cputs>
  800af0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800af3:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  800b08:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  800b35:	e8 f7 15 00 00       	call   802131 <sys_lock_cons>
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
  800b55:	e8 f1 15 00 00       	call   80214b <sys_unlock_cons>
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
  800b9f:	e8 e4 35 00 00       	call   804188 <__udivdi3>
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
  800bef:	e8 a4 36 00 00       	call   804298 <__umoddi3>
  800bf4:	83 c4 10             	add    $0x10,%esp
  800bf7:	05 54 4a 80 00       	add    $0x804a54,%eax
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
  800d4a:	8b 04 85 78 4a 80 00 	mov    0x804a78(,%eax,4),%eax
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
  800e2b:	8b 34 9d c0 48 80 00 	mov    0x8048c0(,%ebx,4),%esi
  800e32:	85 f6                	test   %esi,%esi
  800e34:	75 19                	jne    800e4f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e36:	53                   	push   %ebx
  800e37:	68 65 4a 80 00       	push   $0x804a65
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
  800e50:	68 6e 4a 80 00       	push   $0x804a6e
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
  800e7d:	be 71 4a 80 00       	mov    $0x804a71,%esi
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
  801075:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  80107c:	eb 2c                	jmp    8010aa <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80107e:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  8011a8:	68 e8 4b 80 00       	push   $0x804be8
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
  8011ea:	68 eb 4b 80 00       	push   $0x804beb
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
  80129b:	e8 91 0e 00 00       	call   802131 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012a4:	74 13                	je     8012b9 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012a6:	83 ec 08             	sub    $0x8,%esp
  8012a9:	ff 75 08             	pushl  0x8(%ebp)
  8012ac:	68 e8 4b 80 00       	push   $0x804be8
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
  8012ee:	68 eb 4b 80 00       	push   $0x804beb
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
  801396:	e8 b0 0d 00 00       	call   80214b <sys_unlock_cons>
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
  801a90:	68 fc 4b 80 00       	push   $0x804bfc
  801a95:	68 3f 01 00 00       	push   $0x13f
  801a9a:	68 1e 4c 80 00       	push   $0x804c1e
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
  801ab0:	e8 e5 0b 00 00       	call   80269a <sys_sbrk>
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
  801b2b:	e8 ee 09 00 00       	call   80251e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b30:	85 c0                	test   %eax,%eax
  801b32:	74 16                	je     801b4a <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801b34:	83 ec 0c             	sub    $0xc,%esp
  801b37:	ff 75 08             	pushl  0x8(%ebp)
  801b3a:	e8 2e 0f 00 00       	call   802a6d <alloc_block_FF>
  801b3f:	83 c4 10             	add    $0x10,%esp
  801b42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b45:	e9 8a 01 00 00       	jmp    801cd4 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b4a:	e8 00 0a 00 00       	call   80254f <sys_isUHeapPlacementStrategyBESTFIT>
  801b4f:	85 c0                	test   %eax,%eax
  801b51:	0f 84 7d 01 00 00    	je     801cd4 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801b57:	83 ec 0c             	sub    $0xc,%esp
  801b5a:	ff 75 08             	pushl  0x8(%ebp)
  801b5d:	e8 c7 13 00 00       	call   802f29 <alloc_block_BF>
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
  801bad:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801bfa:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801c51:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  801cb3:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801cba:	83 ec 08             	sub    $0x8,%esp
  801cbd:	ff 75 08             	pushl  0x8(%ebp)
  801cc0:	ff 75 f0             	pushl  -0x10(%ebp)
  801cc3:	e8 09 0a 00 00       	call   8026d1 <sys_allocate_user_mem>
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
  801d0b:	e8 dd 09 00 00       	call   8026ed <get_block_size>
  801d10:	83 c4 10             	add    $0x10,%esp
  801d13:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d16:	83 ec 0c             	sub    $0xc,%esp
  801d19:	ff 75 08             	pushl  0x8(%ebp)
  801d1c:	e8 10 1c 00 00       	call   803931 <free_block>
  801d21:	83 c4 10             	add    $0x10,%esp
		}

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
  801d56:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
  801d5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801d60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d63:	c1 e0 0c             	shl    $0xc,%eax
  801d66:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801d69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d70:	eb 42                	jmp    801db4 <free+0xdb>
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
  801d93:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801d9a:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801d9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
  801da4:	83 ec 08             	sub    $0x8,%esp
  801da7:	52                   	push   %edx
  801da8:	50                   	push   %eax
  801da9:	e8 07 09 00 00       	call   8026b5 <sys_free_user_mem>
  801dae:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801db1:	ff 45 f4             	incl   -0xc(%ebp)
  801db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801dba:	72 b6                	jb     801d72 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801dbc:	eb 17                	jmp    801dd5 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801dbe:	83 ec 04             	sub    $0x4,%esp
  801dc1:	68 2c 4c 80 00       	push   $0x804c2c
  801dc6:	68 88 00 00 00       	push   $0x88
  801dcb:	68 56 4c 80 00       	push   $0x804c56
  801dd0:	e8 70 ea ff ff       	call   800845 <_panic>
	}
}
  801dd5:	90                   	nop
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	83 ec 28             	sub    $0x28,%esp
  801dde:	8b 45 10             	mov    0x10(%ebp),%eax
  801de1:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801de4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801de8:	75 0a                	jne    801df4 <smalloc+0x1c>
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
  801def:	e9 ec 00 00 00       	jmp    801ee0 <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dfa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e01:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e07:	39 d0                	cmp    %edx,%eax
  801e09:	73 02                	jae    801e0d <smalloc+0x35>
  801e0b:	89 d0                	mov    %edx,%eax
  801e0d:	83 ec 0c             	sub    $0xc,%esp
  801e10:	50                   	push   %eax
  801e11:	e8 a4 fc ff ff       	call   801aba <malloc>
  801e16:	83 c4 10             	add    $0x10,%esp
  801e19:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801e1c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e20:	75 0a                	jne    801e2c <smalloc+0x54>
  801e22:	b8 00 00 00 00       	mov    $0x0,%eax
  801e27:	e9 b4 00 00 00       	jmp    801ee0 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e2c:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e30:	ff 75 ec             	pushl  -0x14(%ebp)
  801e33:	50                   	push   %eax
  801e34:	ff 75 0c             	pushl  0xc(%ebp)
  801e37:	ff 75 08             	pushl  0x8(%ebp)
  801e3a:	e8 7d 04 00 00       	call   8022bc <sys_createSharedObject>
  801e3f:	83 c4 10             	add    $0x10,%esp
  801e42:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e45:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e49:	74 06                	je     801e51 <smalloc+0x79>
  801e4b:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e4f:	75 0a                	jne    801e5b <smalloc+0x83>
  801e51:	b8 00 00 00 00       	mov    $0x0,%eax
  801e56:	e9 85 00 00 00       	jmp    801ee0 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801e5b:	83 ec 08             	sub    $0x8,%esp
  801e5e:	ff 75 ec             	pushl  -0x14(%ebp)
  801e61:	68 62 4c 80 00       	push   $0x804c62
  801e66:	e8 97 ec ff ff       	call   800b02 <cprintf>
  801e6b:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801e6e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e71:	a1 20 50 80 00       	mov    0x805020,%eax
  801e76:	8b 40 78             	mov    0x78(%eax),%eax
  801e79:	29 c2                	sub    %eax,%edx
  801e7b:	89 d0                	mov    %edx,%eax
  801e7d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e82:	c1 e8 0c             	shr    $0xc,%eax
  801e85:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801e8b:	42                   	inc    %edx
  801e8c:	89 15 24 50 80 00    	mov    %edx,0x805024
  801e92:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801e98:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801e9f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ea2:	a1 20 50 80 00       	mov    0x805020,%eax
  801ea7:	8b 40 78             	mov    0x78(%eax),%eax
  801eaa:	29 c2                	sub    %eax,%edx
  801eac:	89 d0                	mov    %edx,%eax
  801eae:	2d 00 10 00 00       	sub    $0x1000,%eax
  801eb3:	c1 e8 0c             	shr    $0xc,%eax
  801eb6:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801ebd:	a1 20 50 80 00       	mov    0x805020,%eax
  801ec2:	8b 50 10             	mov    0x10(%eax),%edx
  801ec5:	89 c8                	mov    %ecx,%eax
  801ec7:	c1 e0 02             	shl    $0x2,%eax
  801eca:	89 c1                	mov    %eax,%ecx
  801ecc:	c1 e1 09             	shl    $0x9,%ecx
  801ecf:	01 c8                	add    %ecx,%eax
  801ed1:	01 c2                	add    %eax,%edx
  801ed3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ed6:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801edd:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ee8:	83 ec 08             	sub    $0x8,%esp
  801eeb:	ff 75 0c             	pushl  0xc(%ebp)
  801eee:	ff 75 08             	pushl  0x8(%ebp)
  801ef1:	e8 f0 03 00 00       	call   8022e6 <sys_getSizeOfSharedObject>
  801ef6:	83 c4 10             	add    $0x10,%esp
  801ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801efc:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801f00:	75 0a                	jne    801f0c <sget+0x2a>
  801f02:	b8 00 00 00 00       	mov    $0x0,%eax
  801f07:	e9 e7 00 00 00       	jmp    801ff3 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f12:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f19:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1f:	39 d0                	cmp    %edx,%eax
  801f21:	73 02                	jae    801f25 <sget+0x43>
  801f23:	89 d0                	mov    %edx,%eax
  801f25:	83 ec 0c             	sub    $0xc,%esp
  801f28:	50                   	push   %eax
  801f29:	e8 8c fb ff ff       	call   801aba <malloc>
  801f2e:	83 c4 10             	add    $0x10,%esp
  801f31:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801f34:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f38:	75 0a                	jne    801f44 <sget+0x62>
  801f3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3f:	e9 af 00 00 00       	jmp    801ff3 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801f44:	83 ec 04             	sub    $0x4,%esp
  801f47:	ff 75 e8             	pushl  -0x18(%ebp)
  801f4a:	ff 75 0c             	pushl  0xc(%ebp)
  801f4d:	ff 75 08             	pushl  0x8(%ebp)
  801f50:	e8 ae 03 00 00       	call   802303 <sys_getSharedObject>
  801f55:	83 c4 10             	add    $0x10,%esp
  801f58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801f5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f5e:	a1 20 50 80 00       	mov    0x805020,%eax
  801f63:	8b 40 78             	mov    0x78(%eax),%eax
  801f66:	29 c2                	sub    %eax,%edx
  801f68:	89 d0                	mov    %edx,%eax
  801f6a:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f6f:	c1 e8 0c             	shr    $0xc,%eax
  801f72:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801f78:	42                   	inc    %edx
  801f79:	89 15 24 50 80 00    	mov    %edx,0x805024
  801f7f:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801f85:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801f8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f8f:	a1 20 50 80 00       	mov    0x805020,%eax
  801f94:	8b 40 78             	mov    0x78(%eax),%eax
  801f97:	29 c2                	sub    %eax,%edx
  801f99:	89 d0                	mov    %edx,%eax
  801f9b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fa0:	c1 e8 0c             	shr    $0xc,%eax
  801fa3:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801faa:	a1 20 50 80 00       	mov    0x805020,%eax
  801faf:	8b 50 10             	mov    0x10(%eax),%edx
  801fb2:	89 c8                	mov    %ecx,%eax
  801fb4:	c1 e0 02             	shl    $0x2,%eax
  801fb7:	89 c1                	mov    %eax,%ecx
  801fb9:	c1 e1 09             	shl    $0x9,%ecx
  801fbc:	01 c8                	add    %ecx,%eax
  801fbe:	01 c2                	add    %eax,%edx
  801fc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fc3:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801fca:	a1 20 50 80 00       	mov    0x805020,%eax
  801fcf:	8b 40 10             	mov    0x10(%eax),%eax
  801fd2:	83 ec 08             	sub    $0x8,%esp
  801fd5:	50                   	push   %eax
  801fd6:	68 71 4c 80 00       	push   $0x804c71
  801fdb:	e8 22 eb ff ff       	call   800b02 <cprintf>
  801fe0:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801fe3:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801fe7:	75 07                	jne    801ff0 <sget+0x10e>
  801fe9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fee:	eb 03                	jmp    801ff3 <sget+0x111>
	return ptr;
  801ff0:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801ffb:	8b 55 08             	mov    0x8(%ebp),%edx
  801ffe:	a1 20 50 80 00       	mov    0x805020,%eax
  802003:	8b 40 78             	mov    0x78(%eax),%eax
  802006:	29 c2                	sub    %eax,%edx
  802008:	89 d0                	mov    %edx,%eax
  80200a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80200f:	c1 e8 0c             	shr    $0xc,%eax
  802012:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  802019:	a1 20 50 80 00       	mov    0x805020,%eax
  80201e:	8b 50 10             	mov    0x10(%eax),%edx
  802021:	89 c8                	mov    %ecx,%eax
  802023:	c1 e0 02             	shl    $0x2,%eax
  802026:	89 c1                	mov    %eax,%ecx
  802028:	c1 e1 09             	shl    $0x9,%ecx
  80202b:	01 c8                	add    %ecx,%eax
  80202d:	01 d0                	add    %edx,%eax
  80202f:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  802036:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802039:	83 ec 08             	sub    $0x8,%esp
  80203c:	ff 75 08             	pushl  0x8(%ebp)
  80203f:	ff 75 f4             	pushl  -0xc(%ebp)
  802042:	e8 db 02 00 00       	call   802322 <sys_freeSharedObject>
  802047:	83 c4 10             	add    $0x10,%esp
  80204a:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80204d:	90                   	nop
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802056:	83 ec 04             	sub    $0x4,%esp
  802059:	68 80 4c 80 00       	push   $0x804c80
  80205e:	68 e5 00 00 00       	push   $0xe5
  802063:	68 56 4c 80 00       	push   $0x804c56
  802068:	e8 d8 e7 ff ff       	call   800845 <_panic>

0080206d <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802073:	83 ec 04             	sub    $0x4,%esp
  802076:	68 a6 4c 80 00       	push   $0x804ca6
  80207b:	68 f1 00 00 00       	push   $0xf1
  802080:	68 56 4c 80 00       	push   $0x804c56
  802085:	e8 bb e7 ff ff       	call   800845 <_panic>

0080208a <shrink>:

}
void shrink(uint32 newSize)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802090:	83 ec 04             	sub    $0x4,%esp
  802093:	68 a6 4c 80 00       	push   $0x804ca6
  802098:	68 f6 00 00 00       	push   $0xf6
  80209d:	68 56 4c 80 00       	push   $0x804c56
  8020a2:	e8 9e e7 ff ff       	call   800845 <_panic>

008020a7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020ad:	83 ec 04             	sub    $0x4,%esp
  8020b0:	68 a6 4c 80 00       	push   $0x804ca6
  8020b5:	68 fb 00 00 00       	push   $0xfb
  8020ba:	68 56 4c 80 00       	push   $0x804c56
  8020bf:	e8 81 e7 ff ff       	call   800845 <_panic>

008020c4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	57                   	push   %edi
  8020c8:	56                   	push   %esi
  8020c9:	53                   	push   %ebx
  8020ca:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020d6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020d9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020dc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020df:	cd 30                	int    $0x30
  8020e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020e7:	83 c4 10             	add    $0x10,%esp
  8020ea:	5b                   	pop    %ebx
  8020eb:	5e                   	pop    %esi
  8020ec:	5f                   	pop    %edi
  8020ed:	5d                   	pop    %ebp
  8020ee:	c3                   	ret    

008020ef <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 04             	sub    $0x4,%esp
  8020f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020fb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	52                   	push   %edx
  802107:	ff 75 0c             	pushl  0xc(%ebp)
  80210a:	50                   	push   %eax
  80210b:	6a 00                	push   $0x0
  80210d:	e8 b2 ff ff ff       	call   8020c4 <syscall>
  802112:	83 c4 18             	add    $0x18,%esp
}
  802115:	90                   	nop
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <sys_cgetc>:

int
sys_cgetc(void)
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 02                	push   $0x2
  802127:	e8 98 ff ff ff       	call   8020c4 <syscall>
  80212c:	83 c4 18             	add    $0x18,%esp
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 03                	push   $0x3
  802140:	e8 7f ff ff ff       	call   8020c4 <syscall>
  802145:	83 c4 18             	add    $0x18,%esp
}
  802148:	90                   	nop
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 04                	push   $0x4
  80215a:	e8 65 ff ff ff       	call   8020c4 <syscall>
  80215f:	83 c4 18             	add    $0x18,%esp
}
  802162:	90                   	nop
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802168:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	52                   	push   %edx
  802175:	50                   	push   %eax
  802176:	6a 08                	push   $0x8
  802178:	e8 47 ff ff ff       	call   8020c4 <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	56                   	push   %esi
  802186:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802187:	8b 75 18             	mov    0x18(%ebp),%esi
  80218a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80218d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802190:	8b 55 0c             	mov    0xc(%ebp),%edx
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	56                   	push   %esi
  802197:	53                   	push   %ebx
  802198:	51                   	push   %ecx
  802199:	52                   	push   %edx
  80219a:	50                   	push   %eax
  80219b:	6a 09                	push   $0x9
  80219d:	e8 22 ff ff ff       	call   8020c4 <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
}
  8021a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021a8:	5b                   	pop    %ebx
  8021a9:	5e                   	pop    %esi
  8021aa:	5d                   	pop    %ebp
  8021ab:	c3                   	ret    

008021ac <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	52                   	push   %edx
  8021bc:	50                   	push   %eax
  8021bd:	6a 0a                	push   $0xa
  8021bf:	e8 00 ff ff ff       	call   8020c4 <syscall>
  8021c4:	83 c4 18             	add    $0x18,%esp
}
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	ff 75 0c             	pushl  0xc(%ebp)
  8021d5:	ff 75 08             	pushl  0x8(%ebp)
  8021d8:	6a 0b                	push   $0xb
  8021da:	e8 e5 fe ff ff       	call   8020c4 <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
}
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 0c                	push   $0xc
  8021f3:	e8 cc fe ff ff       	call   8020c4 <syscall>
  8021f8:	83 c4 18             	add    $0x18,%esp
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 0d                	push   $0xd
  80220c:	e8 b3 fe ff ff       	call   8020c4 <syscall>
  802211:	83 c4 18             	add    $0x18,%esp
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 0e                	push   $0xe
  802225:	e8 9a fe ff ff       	call   8020c4 <syscall>
  80222a:	83 c4 18             	add    $0x18,%esp
}
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 0f                	push   $0xf
  80223e:	e8 81 fe ff ff       	call   8020c4 <syscall>
  802243:	83 c4 18             	add    $0x18,%esp
}
  802246:	c9                   	leave  
  802247:	c3                   	ret    

00802248 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	ff 75 08             	pushl  0x8(%ebp)
  802256:	6a 10                	push   $0x10
  802258:	e8 67 fe ff ff       	call   8020c4 <syscall>
  80225d:	83 c4 18             	add    $0x18,%esp
}
  802260:	c9                   	leave  
  802261:	c3                   	ret    

00802262 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802262:	55                   	push   %ebp
  802263:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 11                	push   $0x11
  802271:	e8 4e fe ff ff       	call   8020c4 <syscall>
  802276:	83 c4 18             	add    $0x18,%esp
}
  802279:	90                   	nop
  80227a:	c9                   	leave  
  80227b:	c3                   	ret    

0080227c <sys_cputc>:

void
sys_cputc(const char c)
{
  80227c:	55                   	push   %ebp
  80227d:	89 e5                	mov    %esp,%ebp
  80227f:	83 ec 04             	sub    $0x4,%esp
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802288:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	50                   	push   %eax
  802295:	6a 01                	push   $0x1
  802297:	e8 28 fe ff ff       	call   8020c4 <syscall>
  80229c:	83 c4 18             	add    $0x18,%esp
}
  80229f:	90                   	nop
  8022a0:	c9                   	leave  
  8022a1:	c3                   	ret    

008022a2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 14                	push   $0x14
  8022b1:	e8 0e fe ff ff       	call   8020c4 <syscall>
  8022b6:	83 c4 18             	add    $0x18,%esp
}
  8022b9:	90                   	nop
  8022ba:	c9                   	leave  
  8022bb:	c3                   	ret    

008022bc <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
  8022bf:	83 ec 04             	sub    $0x4,%esp
  8022c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022c8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022cb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	6a 00                	push   $0x0
  8022d4:	51                   	push   %ecx
  8022d5:	52                   	push   %edx
  8022d6:	ff 75 0c             	pushl  0xc(%ebp)
  8022d9:	50                   	push   %eax
  8022da:	6a 15                	push   $0x15
  8022dc:	e8 e3 fd ff ff       	call   8020c4 <syscall>
  8022e1:	83 c4 18             	add    $0x18,%esp
}
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8022e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	52                   	push   %edx
  8022f6:	50                   	push   %eax
  8022f7:	6a 16                	push   $0x16
  8022f9:	e8 c6 fd ff ff       	call   8020c4 <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
}
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802306:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802309:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	51                   	push   %ecx
  802314:	52                   	push   %edx
  802315:	50                   	push   %eax
  802316:	6a 17                	push   $0x17
  802318:	e8 a7 fd ff ff       	call   8020c4 <syscall>
  80231d:	83 c4 18             	add    $0x18,%esp
}
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802325:	8b 55 0c             	mov    0xc(%ebp),%edx
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	52                   	push   %edx
  802332:	50                   	push   %eax
  802333:	6a 18                	push   $0x18
  802335:	e8 8a fd ff ff       	call   8020c4 <syscall>
  80233a:	83 c4 18             	add    $0x18,%esp
}
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	6a 00                	push   $0x0
  802347:	ff 75 14             	pushl  0x14(%ebp)
  80234a:	ff 75 10             	pushl  0x10(%ebp)
  80234d:	ff 75 0c             	pushl  0xc(%ebp)
  802350:	50                   	push   %eax
  802351:	6a 19                	push   $0x19
  802353:	e8 6c fd ff ff       	call   8020c4 <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	50                   	push   %eax
  80236c:	6a 1a                	push   $0x1a
  80236e:	e8 51 fd ff ff       	call   8020c4 <syscall>
  802373:	83 c4 18             	add    $0x18,%esp
}
  802376:	90                   	nop
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	50                   	push   %eax
  802388:	6a 1b                	push   $0x1b
  80238a:	e8 35 fd ff ff       	call   8020c4 <syscall>
  80238f:	83 c4 18             	add    $0x18,%esp
}
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 05                	push   $0x5
  8023a3:	e8 1c fd ff ff       	call   8020c4 <syscall>
  8023a8:	83 c4 18             	add    $0x18,%esp
}
  8023ab:	c9                   	leave  
  8023ac:	c3                   	ret    

008023ad <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 06                	push   $0x6
  8023bc:	e8 03 fd ff ff       	call   8020c4 <syscall>
  8023c1:	83 c4 18             	add    $0x18,%esp
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 07                	push   $0x7
  8023d5:	e8 ea fc ff ff       	call   8020c4 <syscall>
  8023da:	83 c4 18             	add    $0x18,%esp
}
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <sys_exit_env>:


void sys_exit_env(void)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 1c                	push   $0x1c
  8023ee:	e8 d1 fc ff ff       	call   8020c4 <syscall>
  8023f3:	83 c4 18             	add    $0x18,%esp
}
  8023f6:	90                   	nop
  8023f7:	c9                   	leave  
  8023f8:	c3                   	ret    

008023f9 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
  8023fc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8023ff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802402:	8d 50 04             	lea    0x4(%eax),%edx
  802405:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	52                   	push   %edx
  80240f:	50                   	push   %eax
  802410:	6a 1d                	push   $0x1d
  802412:	e8 ad fc ff ff       	call   8020c4 <syscall>
  802417:	83 c4 18             	add    $0x18,%esp
	return result;
  80241a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80241d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802420:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802423:	89 01                	mov    %eax,(%ecx)
  802425:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802428:	8b 45 08             	mov    0x8(%ebp),%eax
  80242b:	c9                   	leave  
  80242c:	c2 04 00             	ret    $0x4

0080242f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	ff 75 10             	pushl  0x10(%ebp)
  802439:	ff 75 0c             	pushl  0xc(%ebp)
  80243c:	ff 75 08             	pushl  0x8(%ebp)
  80243f:	6a 13                	push   $0x13
  802441:	e8 7e fc ff ff       	call   8020c4 <syscall>
  802446:	83 c4 18             	add    $0x18,%esp
	return ;
  802449:	90                   	nop
}
  80244a:	c9                   	leave  
  80244b:	c3                   	ret    

0080244c <sys_rcr2>:
uint32 sys_rcr2()
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 1e                	push   $0x1e
  80245b:	e8 64 fc ff ff       	call   8020c4 <syscall>
  802460:	83 c4 18             	add    $0x18,%esp
}
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
  802468:	83 ec 04             	sub    $0x4,%esp
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
  80246e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802471:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	50                   	push   %eax
  80247e:	6a 1f                	push   $0x1f
  802480:	e8 3f fc ff ff       	call   8020c4 <syscall>
  802485:	83 c4 18             	add    $0x18,%esp
	return ;
  802488:	90                   	nop
}
  802489:	c9                   	leave  
  80248a:	c3                   	ret    

0080248b <rsttst>:
void rsttst()
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 21                	push   $0x21
  80249a:	e8 25 fc ff ff       	call   8020c4 <syscall>
  80249f:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a2:	90                   	nop
}
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    

008024a5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
  8024a8:	83 ec 04             	sub    $0x4,%esp
  8024ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024b1:	8b 55 18             	mov    0x18(%ebp),%edx
  8024b4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024b8:	52                   	push   %edx
  8024b9:	50                   	push   %eax
  8024ba:	ff 75 10             	pushl  0x10(%ebp)
  8024bd:	ff 75 0c             	pushl  0xc(%ebp)
  8024c0:	ff 75 08             	pushl  0x8(%ebp)
  8024c3:	6a 20                	push   $0x20
  8024c5:	e8 fa fb ff ff       	call   8020c4 <syscall>
  8024ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8024cd:	90                   	nop
}
  8024ce:	c9                   	leave  
  8024cf:	c3                   	ret    

008024d0 <chktst>:
void chktst(uint32 n)
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	ff 75 08             	pushl  0x8(%ebp)
  8024de:	6a 22                	push   $0x22
  8024e0:	e8 df fb ff ff       	call   8020c4 <syscall>
  8024e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e8:	90                   	nop
}
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    

008024eb <inctst>:

void inctst()
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 23                	push   $0x23
  8024fa:	e8 c5 fb ff ff       	call   8020c4 <syscall>
  8024ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802502:	90                   	nop
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <gettst>:
uint32 gettst()
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 24                	push   $0x24
  802514:	e8 ab fb ff ff       	call   8020c4 <syscall>
  802519:	83 c4 18             	add    $0x18,%esp
}
  80251c:	c9                   	leave  
  80251d:	c3                   	ret    

0080251e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
  802521:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 25                	push   $0x25
  802530:	e8 8f fb ff ff       	call   8020c4 <syscall>
  802535:	83 c4 18             	add    $0x18,%esp
  802538:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80253b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80253f:	75 07                	jne    802548 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802541:	b8 01 00 00 00       	mov    $0x1,%eax
  802546:	eb 05                	jmp    80254d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802548:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80254d:	c9                   	leave  
  80254e:	c3                   	ret    

0080254f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80254f:	55                   	push   %ebp
  802550:	89 e5                	mov    %esp,%ebp
  802552:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 25                	push   $0x25
  802561:	e8 5e fb ff ff       	call   8020c4 <syscall>
  802566:	83 c4 18             	add    $0x18,%esp
  802569:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80256c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802570:	75 07                	jne    802579 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802572:	b8 01 00 00 00       	mov    $0x1,%eax
  802577:	eb 05                	jmp    80257e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802579:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80257e:	c9                   	leave  
  80257f:	c3                   	ret    

00802580 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
  802583:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 25                	push   $0x25
  802592:	e8 2d fb ff ff       	call   8020c4 <syscall>
  802597:	83 c4 18             	add    $0x18,%esp
  80259a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80259d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025a1:	75 07                	jne    8025aa <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a8:	eb 05                	jmp    8025af <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025af:	c9                   	leave  
  8025b0:	c3                   	ret    

008025b1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
  8025b4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 25                	push   $0x25
  8025c3:	e8 fc fa ff ff       	call   8020c4 <syscall>
  8025c8:	83 c4 18             	add    $0x18,%esp
  8025cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8025ce:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8025d2:	75 07                	jne    8025db <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8025d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d9:	eb 05                	jmp    8025e0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 00                	push   $0x0
  8025ed:	ff 75 08             	pushl  0x8(%ebp)
  8025f0:	6a 26                	push   $0x26
  8025f2:	e8 cd fa ff ff       	call   8020c4 <syscall>
  8025f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8025fa:	90                   	nop
}
  8025fb:	c9                   	leave  
  8025fc:	c3                   	ret    

008025fd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8025fd:	55                   	push   %ebp
  8025fe:	89 e5                	mov    %esp,%ebp
  802600:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802601:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802604:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802607:	8b 55 0c             	mov    0xc(%ebp),%edx
  80260a:	8b 45 08             	mov    0x8(%ebp),%eax
  80260d:	6a 00                	push   $0x0
  80260f:	53                   	push   %ebx
  802610:	51                   	push   %ecx
  802611:	52                   	push   %edx
  802612:	50                   	push   %eax
  802613:	6a 27                	push   $0x27
  802615:	e8 aa fa ff ff       	call   8020c4 <syscall>
  80261a:	83 c4 18             	add    $0x18,%esp
}
  80261d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802620:	c9                   	leave  
  802621:	c3                   	ret    

00802622 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802622:	55                   	push   %ebp
  802623:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802625:	8b 55 0c             	mov    0xc(%ebp),%edx
  802628:	8b 45 08             	mov    0x8(%ebp),%eax
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 00                	push   $0x0
  802631:	52                   	push   %edx
  802632:	50                   	push   %eax
  802633:	6a 28                	push   $0x28
  802635:	e8 8a fa ff ff       	call   8020c4 <syscall>
  80263a:	83 c4 18             	add    $0x18,%esp
}
  80263d:	c9                   	leave  
  80263e:	c3                   	ret    

0080263f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802642:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802645:	8b 55 0c             	mov    0xc(%ebp),%edx
  802648:	8b 45 08             	mov    0x8(%ebp),%eax
  80264b:	6a 00                	push   $0x0
  80264d:	51                   	push   %ecx
  80264e:	ff 75 10             	pushl  0x10(%ebp)
  802651:	52                   	push   %edx
  802652:	50                   	push   %eax
  802653:	6a 29                	push   $0x29
  802655:	e8 6a fa ff ff       	call   8020c4 <syscall>
  80265a:	83 c4 18             	add    $0x18,%esp
}
  80265d:	c9                   	leave  
  80265e:	c3                   	ret    

0080265f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80265f:	55                   	push   %ebp
  802660:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802662:	6a 00                	push   $0x0
  802664:	6a 00                	push   $0x0
  802666:	ff 75 10             	pushl  0x10(%ebp)
  802669:	ff 75 0c             	pushl  0xc(%ebp)
  80266c:	ff 75 08             	pushl  0x8(%ebp)
  80266f:	6a 12                	push   $0x12
  802671:	e8 4e fa ff ff       	call   8020c4 <syscall>
  802676:	83 c4 18             	add    $0x18,%esp
	return ;
  802679:	90                   	nop
}
  80267a:	c9                   	leave  
  80267b:	c3                   	ret    

0080267c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80267f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	6a 00                	push   $0x0
  802687:	6a 00                	push   $0x0
  802689:	6a 00                	push   $0x0
  80268b:	52                   	push   %edx
  80268c:	50                   	push   %eax
  80268d:	6a 2a                	push   $0x2a
  80268f:	e8 30 fa ff ff       	call   8020c4 <syscall>
  802694:	83 c4 18             	add    $0x18,%esp
	return;
  802697:	90                   	nop
}
  802698:	c9                   	leave  
  802699:	c3                   	ret    

0080269a <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80269a:	55                   	push   %ebp
  80269b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 00                	push   $0x0
  8026a4:	6a 00                	push   $0x0
  8026a6:	6a 00                	push   $0x0
  8026a8:	50                   	push   %eax
  8026a9:	6a 2b                	push   $0x2b
  8026ab:	e8 14 fa ff ff       	call   8020c4 <syscall>
  8026b0:	83 c4 18             	add    $0x18,%esp
}
  8026b3:	c9                   	leave  
  8026b4:	c3                   	ret    

008026b5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	ff 75 0c             	pushl  0xc(%ebp)
  8026c1:	ff 75 08             	pushl  0x8(%ebp)
  8026c4:	6a 2c                	push   $0x2c
  8026c6:	e8 f9 f9 ff ff       	call   8020c4 <syscall>
  8026cb:	83 c4 18             	add    $0x18,%esp
	return;
  8026ce:	90                   	nop
}
  8026cf:	c9                   	leave  
  8026d0:	c3                   	ret    

008026d1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8026d1:	55                   	push   %ebp
  8026d2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	ff 75 0c             	pushl  0xc(%ebp)
  8026dd:	ff 75 08             	pushl  0x8(%ebp)
  8026e0:	6a 2d                	push   $0x2d
  8026e2:	e8 dd f9 ff ff       	call   8020c4 <syscall>
  8026e7:	83 c4 18             	add    $0x18,%esp
	return;
  8026ea:	90                   	nop
}
  8026eb:	c9                   	leave  
  8026ec:	c3                   	ret    

008026ed <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8026ed:	55                   	push   %ebp
  8026ee:	89 e5                	mov    %esp,%ebp
  8026f0:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8026f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f6:	83 e8 04             	sub    $0x4,%eax
  8026f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8026fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026ff:	8b 00                	mov    (%eax),%eax
  802701:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80270c:	8b 45 08             	mov    0x8(%ebp),%eax
  80270f:	83 e8 04             	sub    $0x4,%eax
  802712:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802715:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802718:	8b 00                	mov    (%eax),%eax
  80271a:	83 e0 01             	and    $0x1,%eax
  80271d:	85 c0                	test   %eax,%eax
  80271f:	0f 94 c0             	sete   %al
}
  802722:	c9                   	leave  
  802723:	c3                   	ret    

00802724 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802724:	55                   	push   %ebp
  802725:	89 e5                	mov    %esp,%ebp
  802727:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80272a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802731:	8b 45 0c             	mov    0xc(%ebp),%eax
  802734:	83 f8 02             	cmp    $0x2,%eax
  802737:	74 2b                	je     802764 <alloc_block+0x40>
  802739:	83 f8 02             	cmp    $0x2,%eax
  80273c:	7f 07                	jg     802745 <alloc_block+0x21>
  80273e:	83 f8 01             	cmp    $0x1,%eax
  802741:	74 0e                	je     802751 <alloc_block+0x2d>
  802743:	eb 58                	jmp    80279d <alloc_block+0x79>
  802745:	83 f8 03             	cmp    $0x3,%eax
  802748:	74 2d                	je     802777 <alloc_block+0x53>
  80274a:	83 f8 04             	cmp    $0x4,%eax
  80274d:	74 3b                	je     80278a <alloc_block+0x66>
  80274f:	eb 4c                	jmp    80279d <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802751:	83 ec 0c             	sub    $0xc,%esp
  802754:	ff 75 08             	pushl  0x8(%ebp)
  802757:	e8 11 03 00 00       	call   802a6d <alloc_block_FF>
  80275c:	83 c4 10             	add    $0x10,%esp
  80275f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802762:	eb 4a                	jmp    8027ae <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802764:	83 ec 0c             	sub    $0xc,%esp
  802767:	ff 75 08             	pushl  0x8(%ebp)
  80276a:	e8 fa 19 00 00       	call   804169 <alloc_block_NF>
  80276f:	83 c4 10             	add    $0x10,%esp
  802772:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802775:	eb 37                	jmp    8027ae <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802777:	83 ec 0c             	sub    $0xc,%esp
  80277a:	ff 75 08             	pushl  0x8(%ebp)
  80277d:	e8 a7 07 00 00       	call   802f29 <alloc_block_BF>
  802782:	83 c4 10             	add    $0x10,%esp
  802785:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802788:	eb 24                	jmp    8027ae <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80278a:	83 ec 0c             	sub    $0xc,%esp
  80278d:	ff 75 08             	pushl  0x8(%ebp)
  802790:	e8 b7 19 00 00       	call   80414c <alloc_block_WF>
  802795:	83 c4 10             	add    $0x10,%esp
  802798:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80279b:	eb 11                	jmp    8027ae <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80279d:	83 ec 0c             	sub    $0xc,%esp
  8027a0:	68 b8 4c 80 00       	push   $0x804cb8
  8027a5:	e8 58 e3 ff ff       	call   800b02 <cprintf>
  8027aa:	83 c4 10             	add    $0x10,%esp
		break;
  8027ad:	90                   	nop
	}
	return va;
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8027b1:	c9                   	leave  
  8027b2:	c3                   	ret    

008027b3 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8027b3:	55                   	push   %ebp
  8027b4:	89 e5                	mov    %esp,%ebp
  8027b6:	53                   	push   %ebx
  8027b7:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8027ba:	83 ec 0c             	sub    $0xc,%esp
  8027bd:	68 d8 4c 80 00       	push   $0x804cd8
  8027c2:	e8 3b e3 ff ff       	call   800b02 <cprintf>
  8027c7:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8027ca:	83 ec 0c             	sub    $0xc,%esp
  8027cd:	68 03 4d 80 00       	push   $0x804d03
  8027d2:	e8 2b e3 ff ff       	call   800b02 <cprintf>
  8027d7:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8027da:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e0:	eb 37                	jmp    802819 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8027e2:	83 ec 0c             	sub    $0xc,%esp
  8027e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8027e8:	e8 19 ff ff ff       	call   802706 <is_free_block>
  8027ed:	83 c4 10             	add    $0x10,%esp
  8027f0:	0f be d8             	movsbl %al,%ebx
  8027f3:	83 ec 0c             	sub    $0xc,%esp
  8027f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8027f9:	e8 ef fe ff ff       	call   8026ed <get_block_size>
  8027fe:	83 c4 10             	add    $0x10,%esp
  802801:	83 ec 04             	sub    $0x4,%esp
  802804:	53                   	push   %ebx
  802805:	50                   	push   %eax
  802806:	68 1b 4d 80 00       	push   $0x804d1b
  80280b:	e8 f2 e2 ff ff       	call   800b02 <cprintf>
  802810:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802813:	8b 45 10             	mov    0x10(%ebp),%eax
  802816:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802819:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281d:	74 07                	je     802826 <print_blocks_list+0x73>
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 00                	mov    (%eax),%eax
  802824:	eb 05                	jmp    80282b <print_blocks_list+0x78>
  802826:	b8 00 00 00 00       	mov    $0x0,%eax
  80282b:	89 45 10             	mov    %eax,0x10(%ebp)
  80282e:	8b 45 10             	mov    0x10(%ebp),%eax
  802831:	85 c0                	test   %eax,%eax
  802833:	75 ad                	jne    8027e2 <print_blocks_list+0x2f>
  802835:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802839:	75 a7                	jne    8027e2 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80283b:	83 ec 0c             	sub    $0xc,%esp
  80283e:	68 d8 4c 80 00       	push   $0x804cd8
  802843:	e8 ba e2 ff ff       	call   800b02 <cprintf>
  802848:	83 c4 10             	add    $0x10,%esp

}
  80284b:	90                   	nop
  80284c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80284f:	c9                   	leave  
  802850:	c3                   	ret    

00802851 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
  802854:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802857:	8b 45 0c             	mov    0xc(%ebp),%eax
  80285a:	83 e0 01             	and    $0x1,%eax
  80285d:	85 c0                	test   %eax,%eax
  80285f:	74 03                	je     802864 <initialize_dynamic_allocator+0x13>
  802861:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802864:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802868:	0f 84 c7 01 00 00    	je     802a35 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80286e:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802875:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802878:	8b 55 08             	mov    0x8(%ebp),%edx
  80287b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80287e:	01 d0                	add    %edx,%eax
  802880:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802885:	0f 87 ad 01 00 00    	ja     802a38 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80288b:	8b 45 08             	mov    0x8(%ebp),%eax
  80288e:	85 c0                	test   %eax,%eax
  802890:	0f 89 a5 01 00 00    	jns    802a3b <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802896:	8b 55 08             	mov    0x8(%ebp),%edx
  802899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80289c:	01 d0                	add    %edx,%eax
  80289e:	83 e8 04             	sub    $0x4,%eax
  8028a1:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8028a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8028ad:	a1 30 50 80 00       	mov    0x805030,%eax
  8028b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b5:	e9 87 00 00 00       	jmp    802941 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8028ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028be:	75 14                	jne    8028d4 <initialize_dynamic_allocator+0x83>
  8028c0:	83 ec 04             	sub    $0x4,%esp
  8028c3:	68 33 4d 80 00       	push   $0x804d33
  8028c8:	6a 79                	push   $0x79
  8028ca:	68 51 4d 80 00       	push   $0x804d51
  8028cf:	e8 71 df ff ff       	call   800845 <_panic>
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	74 10                	je     8028ed <initialize_dynamic_allocator+0x9c>
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 00                	mov    (%eax),%eax
  8028e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e5:	8b 52 04             	mov    0x4(%edx),%edx
  8028e8:	89 50 04             	mov    %edx,0x4(%eax)
  8028eb:	eb 0b                	jmp    8028f8 <initialize_dynamic_allocator+0xa7>
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 40 04             	mov    0x4(%eax),%eax
  8028f3:	a3 34 50 80 00       	mov    %eax,0x805034
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 40 04             	mov    0x4(%eax),%eax
  8028fe:	85 c0                	test   %eax,%eax
  802900:	74 0f                	je     802911 <initialize_dynamic_allocator+0xc0>
  802902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802905:	8b 40 04             	mov    0x4(%eax),%eax
  802908:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290b:	8b 12                	mov    (%edx),%edx
  80290d:	89 10                	mov    %edx,(%eax)
  80290f:	eb 0a                	jmp    80291b <initialize_dynamic_allocator+0xca>
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 00                	mov    (%eax),%eax
  802916:	a3 30 50 80 00       	mov    %eax,0x805030
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802933:	48                   	dec    %eax
  802934:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802939:	a1 38 50 80 00       	mov    0x805038,%eax
  80293e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802941:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802945:	74 07                	je     80294e <initialize_dynamic_allocator+0xfd>
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 00                	mov    (%eax),%eax
  80294c:	eb 05                	jmp    802953 <initialize_dynamic_allocator+0x102>
  80294e:	b8 00 00 00 00       	mov    $0x0,%eax
  802953:	a3 38 50 80 00       	mov    %eax,0x805038
  802958:	a1 38 50 80 00       	mov    0x805038,%eax
  80295d:	85 c0                	test   %eax,%eax
  80295f:	0f 85 55 ff ff ff    	jne    8028ba <initialize_dynamic_allocator+0x69>
  802965:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802969:	0f 85 4b ff ff ff    	jne    8028ba <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80296f:	8b 45 08             	mov    0x8(%ebp),%eax
  802972:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802978:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80297e:	a1 48 50 80 00       	mov    0x805048,%eax
  802983:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802988:	a1 44 50 80 00       	mov    0x805044,%eax
  80298d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	83 c0 08             	add    $0x8,%eax
  802999:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80299c:	8b 45 08             	mov    0x8(%ebp),%eax
  80299f:	83 c0 04             	add    $0x4,%eax
  8029a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029a5:	83 ea 08             	sub    $0x8,%edx
  8029a8:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8029aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b0:	01 d0                	add    %edx,%eax
  8029b2:	83 e8 08             	sub    $0x8,%eax
  8029b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029b8:	83 ea 08             	sub    $0x8,%edx
  8029bb:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8029bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8029c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8029d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029d4:	75 17                	jne    8029ed <initialize_dynamic_allocator+0x19c>
  8029d6:	83 ec 04             	sub    $0x4,%esp
  8029d9:	68 6c 4d 80 00       	push   $0x804d6c
  8029de:	68 90 00 00 00       	push   $0x90
  8029e3:	68 51 4d 80 00       	push   $0x804d51
  8029e8:	e8 58 de ff ff       	call   800845 <_panic>
  8029ed:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f6:	89 10                	mov    %edx,(%eax)
  8029f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fb:	8b 00                	mov    (%eax),%eax
  8029fd:	85 c0                	test   %eax,%eax
  8029ff:	74 0d                	je     802a0e <initialize_dynamic_allocator+0x1bd>
  802a01:	a1 30 50 80 00       	mov    0x805030,%eax
  802a06:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a09:	89 50 04             	mov    %edx,0x4(%eax)
  802a0c:	eb 08                	jmp    802a16 <initialize_dynamic_allocator+0x1c5>
  802a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a11:	a3 34 50 80 00       	mov    %eax,0x805034
  802a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a19:	a3 30 50 80 00       	mov    %eax,0x805030
  802a1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a28:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a2d:	40                   	inc    %eax
  802a2e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a33:	eb 07                	jmp    802a3c <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802a35:	90                   	nop
  802a36:	eb 04                	jmp    802a3c <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802a38:	90                   	nop
  802a39:	eb 01                	jmp    802a3c <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802a3b:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802a3c:	c9                   	leave  
  802a3d:	c3                   	ret    

00802a3e <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802a3e:	55                   	push   %ebp
  802a3f:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802a41:	8b 45 10             	mov    0x10(%ebp),%eax
  802a44:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802a47:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4a:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a50:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802a52:	8b 45 08             	mov    0x8(%ebp),%eax
  802a55:	83 e8 04             	sub    $0x4,%eax
  802a58:	8b 00                	mov    (%eax),%eax
  802a5a:	83 e0 fe             	and    $0xfffffffe,%eax
  802a5d:	8d 50 f8             	lea    -0x8(%eax),%edx
  802a60:	8b 45 08             	mov    0x8(%ebp),%eax
  802a63:	01 c2                	add    %eax,%edx
  802a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a68:	89 02                	mov    %eax,(%edx)
}
  802a6a:	90                   	nop
  802a6b:	5d                   	pop    %ebp
  802a6c:	c3                   	ret    

00802a6d <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802a6d:	55                   	push   %ebp
  802a6e:	89 e5                	mov    %esp,%ebp
  802a70:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	83 e0 01             	and    $0x1,%eax
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	74 03                	je     802a80 <alloc_block_FF+0x13>
  802a7d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802a80:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802a84:	77 07                	ja     802a8d <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802a86:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802a8d:	a1 28 50 80 00       	mov    0x805028,%eax
  802a92:	85 c0                	test   %eax,%eax
  802a94:	75 73                	jne    802b09 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	83 c0 10             	add    $0x10,%eax
  802a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a9f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802aa6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aac:	01 d0                	add    %edx,%eax
  802aae:	48                   	dec    %eax
  802aaf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ab2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  802aba:	f7 75 ec             	divl   -0x14(%ebp)
  802abd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac0:	29 d0                	sub    %edx,%eax
  802ac2:	c1 e8 0c             	shr    $0xc,%eax
  802ac5:	83 ec 0c             	sub    $0xc,%esp
  802ac8:	50                   	push   %eax
  802ac9:	e8 d6 ef ff ff       	call   801aa4 <sbrk>
  802ace:	83 c4 10             	add    $0x10,%esp
  802ad1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802ad4:	83 ec 0c             	sub    $0xc,%esp
  802ad7:	6a 00                	push   $0x0
  802ad9:	e8 c6 ef ff ff       	call   801aa4 <sbrk>
  802ade:	83 c4 10             	add    $0x10,%esp
  802ae1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802ae4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae7:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802aea:	83 ec 08             	sub    $0x8,%esp
  802aed:	50                   	push   %eax
  802aee:	ff 75 e4             	pushl  -0x1c(%ebp)
  802af1:	e8 5b fd ff ff       	call   802851 <initialize_dynamic_allocator>
  802af6:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802af9:	83 ec 0c             	sub    $0xc,%esp
  802afc:	68 8f 4d 80 00       	push   $0x804d8f
  802b01:	e8 fc df ff ff       	call   800b02 <cprintf>
  802b06:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802b09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b0d:	75 0a                	jne    802b19 <alloc_block_FF+0xac>
	        return NULL;
  802b0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b14:	e9 0e 04 00 00       	jmp    802f27 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802b19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802b20:	a1 30 50 80 00       	mov    0x805030,%eax
  802b25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b28:	e9 f3 02 00 00       	jmp    802e20 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802b33:	83 ec 0c             	sub    $0xc,%esp
  802b36:	ff 75 bc             	pushl  -0x44(%ebp)
  802b39:	e8 af fb ff ff       	call   8026ed <get_block_size>
  802b3e:	83 c4 10             	add    $0x10,%esp
  802b41:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802b44:	8b 45 08             	mov    0x8(%ebp),%eax
  802b47:	83 c0 08             	add    $0x8,%eax
  802b4a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b4d:	0f 87 c5 02 00 00    	ja     802e18 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	83 c0 18             	add    $0x18,%eax
  802b59:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b5c:	0f 87 19 02 00 00    	ja     802d7b <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802b62:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b65:	2b 45 08             	sub    0x8(%ebp),%eax
  802b68:	83 e8 08             	sub    $0x8,%eax
  802b6b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	8d 50 08             	lea    0x8(%eax),%edx
  802b74:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b77:	01 d0                	add    %edx,%eax
  802b79:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	83 c0 08             	add    $0x8,%eax
  802b82:	83 ec 04             	sub    $0x4,%esp
  802b85:	6a 01                	push   $0x1
  802b87:	50                   	push   %eax
  802b88:	ff 75 bc             	pushl  -0x44(%ebp)
  802b8b:	e8 ae fe ff ff       	call   802a3e <set_block_data>
  802b90:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	8b 40 04             	mov    0x4(%eax),%eax
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	75 68                	jne    802c05 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b9d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ba1:	75 17                	jne    802bba <alloc_block_FF+0x14d>
  802ba3:	83 ec 04             	sub    $0x4,%esp
  802ba6:	68 6c 4d 80 00       	push   $0x804d6c
  802bab:	68 d7 00 00 00       	push   $0xd7
  802bb0:	68 51 4d 80 00       	push   $0x804d51
  802bb5:	e8 8b dc ff ff       	call   800845 <_panic>
  802bba:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802bc0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bc3:	89 10                	mov    %edx,(%eax)
  802bc5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bc8:	8b 00                	mov    (%eax),%eax
  802bca:	85 c0                	test   %eax,%eax
  802bcc:	74 0d                	je     802bdb <alloc_block_FF+0x16e>
  802bce:	a1 30 50 80 00       	mov    0x805030,%eax
  802bd3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bd6:	89 50 04             	mov    %edx,0x4(%eax)
  802bd9:	eb 08                	jmp    802be3 <alloc_block_FF+0x176>
  802bdb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bde:	a3 34 50 80 00       	mov    %eax,0x805034
  802be3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802be6:	a3 30 50 80 00       	mov    %eax,0x805030
  802beb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bfa:	40                   	inc    %eax
  802bfb:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802c00:	e9 dc 00 00 00       	jmp    802ce1 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 00                	mov    (%eax),%eax
  802c0a:	85 c0                	test   %eax,%eax
  802c0c:	75 65                	jne    802c73 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c0e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c12:	75 17                	jne    802c2b <alloc_block_FF+0x1be>
  802c14:	83 ec 04             	sub    $0x4,%esp
  802c17:	68 a0 4d 80 00       	push   $0x804da0
  802c1c:	68 db 00 00 00       	push   $0xdb
  802c21:	68 51 4d 80 00       	push   $0x804d51
  802c26:	e8 1a dc ff ff       	call   800845 <_panic>
  802c2b:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802c31:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c34:	89 50 04             	mov    %edx,0x4(%eax)
  802c37:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c3a:	8b 40 04             	mov    0x4(%eax),%eax
  802c3d:	85 c0                	test   %eax,%eax
  802c3f:	74 0c                	je     802c4d <alloc_block_FF+0x1e0>
  802c41:	a1 34 50 80 00       	mov    0x805034,%eax
  802c46:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c49:	89 10                	mov    %edx,(%eax)
  802c4b:	eb 08                	jmp    802c55 <alloc_block_FF+0x1e8>
  802c4d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c50:	a3 30 50 80 00       	mov    %eax,0x805030
  802c55:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c58:	a3 34 50 80 00       	mov    %eax,0x805034
  802c5d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c66:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c6b:	40                   	inc    %eax
  802c6c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802c71:	eb 6e                	jmp    802ce1 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802c73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c77:	74 06                	je     802c7f <alloc_block_FF+0x212>
  802c79:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c7d:	75 17                	jne    802c96 <alloc_block_FF+0x229>
  802c7f:	83 ec 04             	sub    $0x4,%esp
  802c82:	68 c4 4d 80 00       	push   $0x804dc4
  802c87:	68 df 00 00 00       	push   $0xdf
  802c8c:	68 51 4d 80 00       	push   $0x804d51
  802c91:	e8 af db ff ff       	call   800845 <_panic>
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	8b 10                	mov    (%eax),%edx
  802c9b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c9e:	89 10                	mov    %edx,(%eax)
  802ca0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ca3:	8b 00                	mov    (%eax),%eax
  802ca5:	85 c0                	test   %eax,%eax
  802ca7:	74 0b                	je     802cb4 <alloc_block_FF+0x247>
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 00                	mov    (%eax),%eax
  802cae:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cb1:	89 50 04             	mov    %edx,0x4(%eax)
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cba:	89 10                	mov    %edx,(%eax)
  802cbc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc2:	89 50 04             	mov    %edx,0x4(%eax)
  802cc5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cc8:	8b 00                	mov    (%eax),%eax
  802cca:	85 c0                	test   %eax,%eax
  802ccc:	75 08                	jne    802cd6 <alloc_block_FF+0x269>
  802cce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cd1:	a3 34 50 80 00       	mov    %eax,0x805034
  802cd6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802cdb:	40                   	inc    %eax
  802cdc:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802ce1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce5:	75 17                	jne    802cfe <alloc_block_FF+0x291>
  802ce7:	83 ec 04             	sub    $0x4,%esp
  802cea:	68 33 4d 80 00       	push   $0x804d33
  802cef:	68 e1 00 00 00       	push   $0xe1
  802cf4:	68 51 4d 80 00       	push   $0x804d51
  802cf9:	e8 47 db ff ff       	call   800845 <_panic>
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	8b 00                	mov    (%eax),%eax
  802d03:	85 c0                	test   %eax,%eax
  802d05:	74 10                	je     802d17 <alloc_block_FF+0x2aa>
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	8b 00                	mov    (%eax),%eax
  802d0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0f:	8b 52 04             	mov    0x4(%edx),%edx
  802d12:	89 50 04             	mov    %edx,0x4(%eax)
  802d15:	eb 0b                	jmp    802d22 <alloc_block_FF+0x2b5>
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	8b 40 04             	mov    0x4(%eax),%eax
  802d1d:	a3 34 50 80 00       	mov    %eax,0x805034
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 40 04             	mov    0x4(%eax),%eax
  802d28:	85 c0                	test   %eax,%eax
  802d2a:	74 0f                	je     802d3b <alloc_block_FF+0x2ce>
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 40 04             	mov    0x4(%eax),%eax
  802d32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d35:	8b 12                	mov    (%edx),%edx
  802d37:	89 10                	mov    %edx,(%eax)
  802d39:	eb 0a                	jmp    802d45 <alloc_block_FF+0x2d8>
  802d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3e:	8b 00                	mov    (%eax),%eax
  802d40:	a3 30 50 80 00       	mov    %eax,0x805030
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d58:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d5d:	48                   	dec    %eax
  802d5e:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802d63:	83 ec 04             	sub    $0x4,%esp
  802d66:	6a 00                	push   $0x0
  802d68:	ff 75 b4             	pushl  -0x4c(%ebp)
  802d6b:	ff 75 b0             	pushl  -0x50(%ebp)
  802d6e:	e8 cb fc ff ff       	call   802a3e <set_block_data>
  802d73:	83 c4 10             	add    $0x10,%esp
  802d76:	e9 95 00 00 00       	jmp    802e10 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802d7b:	83 ec 04             	sub    $0x4,%esp
  802d7e:	6a 01                	push   $0x1
  802d80:	ff 75 b8             	pushl  -0x48(%ebp)
  802d83:	ff 75 bc             	pushl  -0x44(%ebp)
  802d86:	e8 b3 fc ff ff       	call   802a3e <set_block_data>
  802d8b:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802d8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d92:	75 17                	jne    802dab <alloc_block_FF+0x33e>
  802d94:	83 ec 04             	sub    $0x4,%esp
  802d97:	68 33 4d 80 00       	push   $0x804d33
  802d9c:	68 e8 00 00 00       	push   $0xe8
  802da1:	68 51 4d 80 00       	push   $0x804d51
  802da6:	e8 9a da ff ff       	call   800845 <_panic>
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	8b 00                	mov    (%eax),%eax
  802db0:	85 c0                	test   %eax,%eax
  802db2:	74 10                	je     802dc4 <alloc_block_FF+0x357>
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 00                	mov    (%eax),%eax
  802db9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbc:	8b 52 04             	mov    0x4(%edx),%edx
  802dbf:	89 50 04             	mov    %edx,0x4(%eax)
  802dc2:	eb 0b                	jmp    802dcf <alloc_block_FF+0x362>
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	8b 40 04             	mov    0x4(%eax),%eax
  802dca:	a3 34 50 80 00       	mov    %eax,0x805034
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	85 c0                	test   %eax,%eax
  802dd7:	74 0f                	je     802de8 <alloc_block_FF+0x37b>
  802dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddc:	8b 40 04             	mov    0x4(%eax),%eax
  802ddf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de2:	8b 12                	mov    (%edx),%edx
  802de4:	89 10                	mov    %edx,(%eax)
  802de6:	eb 0a                	jmp    802df2 <alloc_block_FF+0x385>
  802de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802deb:	8b 00                	mov    (%eax),%eax
  802ded:	a3 30 50 80 00       	mov    %eax,0x805030
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e05:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e0a:	48                   	dec    %eax
  802e0b:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802e10:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e13:	e9 0f 01 00 00       	jmp    802f27 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802e18:	a1 38 50 80 00       	mov    0x805038,%eax
  802e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e24:	74 07                	je     802e2d <alloc_block_FF+0x3c0>
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	8b 00                	mov    (%eax),%eax
  802e2b:	eb 05                	jmp    802e32 <alloc_block_FF+0x3c5>
  802e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e32:	a3 38 50 80 00       	mov    %eax,0x805038
  802e37:	a1 38 50 80 00       	mov    0x805038,%eax
  802e3c:	85 c0                	test   %eax,%eax
  802e3e:	0f 85 e9 fc ff ff    	jne    802b2d <alloc_block_FF+0xc0>
  802e44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e48:	0f 85 df fc ff ff    	jne    802b2d <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e51:	83 c0 08             	add    $0x8,%eax
  802e54:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e57:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802e5e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e61:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e64:	01 d0                	add    %edx,%eax
  802e66:	48                   	dec    %eax
  802e67:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802e6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e6d:	ba 00 00 00 00       	mov    $0x0,%edx
  802e72:	f7 75 d8             	divl   -0x28(%ebp)
  802e75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e78:	29 d0                	sub    %edx,%eax
  802e7a:	c1 e8 0c             	shr    $0xc,%eax
  802e7d:	83 ec 0c             	sub    $0xc,%esp
  802e80:	50                   	push   %eax
  802e81:	e8 1e ec ff ff       	call   801aa4 <sbrk>
  802e86:	83 c4 10             	add    $0x10,%esp
  802e89:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802e8c:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802e90:	75 0a                	jne    802e9c <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802e92:	b8 00 00 00 00       	mov    $0x0,%eax
  802e97:	e9 8b 00 00 00       	jmp    802f27 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e9c:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802ea3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ea6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ea9:	01 d0                	add    %edx,%eax
  802eab:	48                   	dec    %eax
  802eac:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802eaf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802eb2:	ba 00 00 00 00       	mov    $0x0,%edx
  802eb7:	f7 75 cc             	divl   -0x34(%ebp)
  802eba:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ebd:	29 d0                	sub    %edx,%eax
  802ebf:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ec2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ec5:	01 d0                	add    %edx,%eax
  802ec7:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802ecc:	a1 44 50 80 00       	mov    0x805044,%eax
  802ed1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ed7:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ede:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ee1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ee4:	01 d0                	add    %edx,%eax
  802ee6:	48                   	dec    %eax
  802ee7:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802eea:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802eed:	ba 00 00 00 00       	mov    $0x0,%edx
  802ef2:	f7 75 c4             	divl   -0x3c(%ebp)
  802ef5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ef8:	29 d0                	sub    %edx,%eax
  802efa:	83 ec 04             	sub    $0x4,%esp
  802efd:	6a 01                	push   $0x1
  802eff:	50                   	push   %eax
  802f00:	ff 75 d0             	pushl  -0x30(%ebp)
  802f03:	e8 36 fb ff ff       	call   802a3e <set_block_data>
  802f08:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802f0b:	83 ec 0c             	sub    $0xc,%esp
  802f0e:	ff 75 d0             	pushl  -0x30(%ebp)
  802f11:	e8 1b 0a 00 00       	call   803931 <free_block>
  802f16:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802f19:	83 ec 0c             	sub    $0xc,%esp
  802f1c:	ff 75 08             	pushl  0x8(%ebp)
  802f1f:	e8 49 fb ff ff       	call   802a6d <alloc_block_FF>
  802f24:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802f27:	c9                   	leave  
  802f28:	c3                   	ret    

00802f29 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802f29:	55                   	push   %ebp
  802f2a:	89 e5                	mov    %esp,%ebp
  802f2c:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	83 e0 01             	and    $0x1,%eax
  802f35:	85 c0                	test   %eax,%eax
  802f37:	74 03                	je     802f3c <alloc_block_BF+0x13>
  802f39:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802f3c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802f40:	77 07                	ja     802f49 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802f42:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802f49:	a1 28 50 80 00       	mov    0x805028,%eax
  802f4e:	85 c0                	test   %eax,%eax
  802f50:	75 73                	jne    802fc5 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	83 c0 10             	add    $0x10,%eax
  802f58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802f5b:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802f62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f68:	01 d0                	add    %edx,%eax
  802f6a:	48                   	dec    %eax
  802f6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802f6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f71:	ba 00 00 00 00       	mov    $0x0,%edx
  802f76:	f7 75 e0             	divl   -0x20(%ebp)
  802f79:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f7c:	29 d0                	sub    %edx,%eax
  802f7e:	c1 e8 0c             	shr    $0xc,%eax
  802f81:	83 ec 0c             	sub    $0xc,%esp
  802f84:	50                   	push   %eax
  802f85:	e8 1a eb ff ff       	call   801aa4 <sbrk>
  802f8a:	83 c4 10             	add    $0x10,%esp
  802f8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802f90:	83 ec 0c             	sub    $0xc,%esp
  802f93:	6a 00                	push   $0x0
  802f95:	e8 0a eb ff ff       	call   801aa4 <sbrk>
  802f9a:	83 c4 10             	add    $0x10,%esp
  802f9d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802fa0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fa3:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802fa6:	83 ec 08             	sub    $0x8,%esp
  802fa9:	50                   	push   %eax
  802faa:	ff 75 d8             	pushl  -0x28(%ebp)
  802fad:	e8 9f f8 ff ff       	call   802851 <initialize_dynamic_allocator>
  802fb2:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802fb5:	83 ec 0c             	sub    $0xc,%esp
  802fb8:	68 8f 4d 80 00       	push   $0x804d8f
  802fbd:	e8 40 db ff ff       	call   800b02 <cprintf>
  802fc2:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802fc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802fcc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802fd3:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802fda:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802fe1:	a1 30 50 80 00       	mov    0x805030,%eax
  802fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fe9:	e9 1d 01 00 00       	jmp    80310b <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff1:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802ff4:	83 ec 0c             	sub    $0xc,%esp
  802ff7:	ff 75 a8             	pushl  -0x58(%ebp)
  802ffa:	e8 ee f6 ff ff       	call   8026ed <get_block_size>
  802fff:	83 c4 10             	add    $0x10,%esp
  803002:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803005:	8b 45 08             	mov    0x8(%ebp),%eax
  803008:	83 c0 08             	add    $0x8,%eax
  80300b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80300e:	0f 87 ef 00 00 00    	ja     803103 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	83 c0 18             	add    $0x18,%eax
  80301a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80301d:	77 1d                	ja     80303c <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80301f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803022:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803025:	0f 86 d8 00 00 00    	jbe    803103 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80302b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80302e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803031:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803034:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803037:	e9 c7 00 00 00       	jmp    803103 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80303c:	8b 45 08             	mov    0x8(%ebp),%eax
  80303f:	83 c0 08             	add    $0x8,%eax
  803042:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803045:	0f 85 9d 00 00 00    	jne    8030e8 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80304b:	83 ec 04             	sub    $0x4,%esp
  80304e:	6a 01                	push   $0x1
  803050:	ff 75 a4             	pushl  -0x5c(%ebp)
  803053:	ff 75 a8             	pushl  -0x58(%ebp)
  803056:	e8 e3 f9 ff ff       	call   802a3e <set_block_data>
  80305b:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80305e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803062:	75 17                	jne    80307b <alloc_block_BF+0x152>
  803064:	83 ec 04             	sub    $0x4,%esp
  803067:	68 33 4d 80 00       	push   $0x804d33
  80306c:	68 2c 01 00 00       	push   $0x12c
  803071:	68 51 4d 80 00       	push   $0x804d51
  803076:	e8 ca d7 ff ff       	call   800845 <_panic>
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	8b 00                	mov    (%eax),%eax
  803080:	85 c0                	test   %eax,%eax
  803082:	74 10                	je     803094 <alloc_block_BF+0x16b>
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	8b 00                	mov    (%eax),%eax
  803089:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80308c:	8b 52 04             	mov    0x4(%edx),%edx
  80308f:	89 50 04             	mov    %edx,0x4(%eax)
  803092:	eb 0b                	jmp    80309f <alloc_block_BF+0x176>
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	8b 40 04             	mov    0x4(%eax),%eax
  80309a:	a3 34 50 80 00       	mov    %eax,0x805034
  80309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a2:	8b 40 04             	mov    0x4(%eax),%eax
  8030a5:	85 c0                	test   %eax,%eax
  8030a7:	74 0f                	je     8030b8 <alloc_block_BF+0x18f>
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	8b 40 04             	mov    0x4(%eax),%eax
  8030af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b2:	8b 12                	mov    (%edx),%edx
  8030b4:	89 10                	mov    %edx,(%eax)
  8030b6:	eb 0a                	jmp    8030c2 <alloc_block_BF+0x199>
  8030b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bb:	8b 00                	mov    (%eax),%eax
  8030bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8030c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030da:	48                   	dec    %eax
  8030db:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  8030e0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030e3:	e9 24 04 00 00       	jmp    80350c <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8030e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030eb:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030ee:	76 13                	jbe    803103 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8030f0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8030f7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8030fd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803100:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803103:	a1 38 50 80 00       	mov    0x805038,%eax
  803108:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80310b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310f:	74 07                	je     803118 <alloc_block_BF+0x1ef>
  803111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803114:	8b 00                	mov    (%eax),%eax
  803116:	eb 05                	jmp    80311d <alloc_block_BF+0x1f4>
  803118:	b8 00 00 00 00       	mov    $0x0,%eax
  80311d:	a3 38 50 80 00       	mov    %eax,0x805038
  803122:	a1 38 50 80 00       	mov    0x805038,%eax
  803127:	85 c0                	test   %eax,%eax
  803129:	0f 85 bf fe ff ff    	jne    802fee <alloc_block_BF+0xc5>
  80312f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803133:	0f 85 b5 fe ff ff    	jne    802fee <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803139:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80313d:	0f 84 26 02 00 00    	je     803369 <alloc_block_BF+0x440>
  803143:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803147:	0f 85 1c 02 00 00    	jne    803369 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80314d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803150:	2b 45 08             	sub    0x8(%ebp),%eax
  803153:	83 e8 08             	sub    $0x8,%eax
  803156:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	8d 50 08             	lea    0x8(%eax),%edx
  80315f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803162:	01 d0                	add    %edx,%eax
  803164:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803167:	8b 45 08             	mov    0x8(%ebp),%eax
  80316a:	83 c0 08             	add    $0x8,%eax
  80316d:	83 ec 04             	sub    $0x4,%esp
  803170:	6a 01                	push   $0x1
  803172:	50                   	push   %eax
  803173:	ff 75 f0             	pushl  -0x10(%ebp)
  803176:	e8 c3 f8 ff ff       	call   802a3e <set_block_data>
  80317b:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80317e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803181:	8b 40 04             	mov    0x4(%eax),%eax
  803184:	85 c0                	test   %eax,%eax
  803186:	75 68                	jne    8031f0 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803188:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80318c:	75 17                	jne    8031a5 <alloc_block_BF+0x27c>
  80318e:	83 ec 04             	sub    $0x4,%esp
  803191:	68 6c 4d 80 00       	push   $0x804d6c
  803196:	68 45 01 00 00       	push   $0x145
  80319b:	68 51 4d 80 00       	push   $0x804d51
  8031a0:	e8 a0 d6 ff ff       	call   800845 <_panic>
  8031a5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8031ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ae:	89 10                	mov    %edx,(%eax)
  8031b0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031b3:	8b 00                	mov    (%eax),%eax
  8031b5:	85 c0                	test   %eax,%eax
  8031b7:	74 0d                	je     8031c6 <alloc_block_BF+0x29d>
  8031b9:	a1 30 50 80 00       	mov    0x805030,%eax
  8031be:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031c1:	89 50 04             	mov    %edx,0x4(%eax)
  8031c4:	eb 08                	jmp    8031ce <alloc_block_BF+0x2a5>
  8031c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031c9:	a3 34 50 80 00       	mov    %eax,0x805034
  8031ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031d1:	a3 30 50 80 00       	mov    %eax,0x805030
  8031d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031e5:	40                   	inc    %eax
  8031e6:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8031eb:	e9 dc 00 00 00       	jmp    8032cc <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8031f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f3:	8b 00                	mov    (%eax),%eax
  8031f5:	85 c0                	test   %eax,%eax
  8031f7:	75 65                	jne    80325e <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8031f9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031fd:	75 17                	jne    803216 <alloc_block_BF+0x2ed>
  8031ff:	83 ec 04             	sub    $0x4,%esp
  803202:	68 a0 4d 80 00       	push   $0x804da0
  803207:	68 4a 01 00 00       	push   $0x14a
  80320c:	68 51 4d 80 00       	push   $0x804d51
  803211:	e8 2f d6 ff ff       	call   800845 <_panic>
  803216:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80321c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80321f:	89 50 04             	mov    %edx,0x4(%eax)
  803222:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803225:	8b 40 04             	mov    0x4(%eax),%eax
  803228:	85 c0                	test   %eax,%eax
  80322a:	74 0c                	je     803238 <alloc_block_BF+0x30f>
  80322c:	a1 34 50 80 00       	mov    0x805034,%eax
  803231:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803234:	89 10                	mov    %edx,(%eax)
  803236:	eb 08                	jmp    803240 <alloc_block_BF+0x317>
  803238:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80323b:	a3 30 50 80 00       	mov    %eax,0x805030
  803240:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803243:	a3 34 50 80 00       	mov    %eax,0x805034
  803248:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80324b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803251:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803256:	40                   	inc    %eax
  803257:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80325c:	eb 6e                	jmp    8032cc <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80325e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803262:	74 06                	je     80326a <alloc_block_BF+0x341>
  803264:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803268:	75 17                	jne    803281 <alloc_block_BF+0x358>
  80326a:	83 ec 04             	sub    $0x4,%esp
  80326d:	68 c4 4d 80 00       	push   $0x804dc4
  803272:	68 4f 01 00 00       	push   $0x14f
  803277:	68 51 4d 80 00       	push   $0x804d51
  80327c:	e8 c4 d5 ff ff       	call   800845 <_panic>
  803281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803284:	8b 10                	mov    (%eax),%edx
  803286:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803289:	89 10                	mov    %edx,(%eax)
  80328b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80328e:	8b 00                	mov    (%eax),%eax
  803290:	85 c0                	test   %eax,%eax
  803292:	74 0b                	je     80329f <alloc_block_BF+0x376>
  803294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803297:	8b 00                	mov    (%eax),%eax
  803299:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80329c:	89 50 04             	mov    %edx,0x4(%eax)
  80329f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032a5:	89 10                	mov    %edx,(%eax)
  8032a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032ad:	89 50 04             	mov    %edx,0x4(%eax)
  8032b0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	85 c0                	test   %eax,%eax
  8032b7:	75 08                	jne    8032c1 <alloc_block_BF+0x398>
  8032b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032bc:	a3 34 50 80 00       	mov    %eax,0x805034
  8032c1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032c6:	40                   	inc    %eax
  8032c7:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8032cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032d0:	75 17                	jne    8032e9 <alloc_block_BF+0x3c0>
  8032d2:	83 ec 04             	sub    $0x4,%esp
  8032d5:	68 33 4d 80 00       	push   $0x804d33
  8032da:	68 51 01 00 00       	push   $0x151
  8032df:	68 51 4d 80 00       	push   $0x804d51
  8032e4:	e8 5c d5 ff ff       	call   800845 <_panic>
  8032e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ec:	8b 00                	mov    (%eax),%eax
  8032ee:	85 c0                	test   %eax,%eax
  8032f0:	74 10                	je     803302 <alloc_block_BF+0x3d9>
  8032f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f5:	8b 00                	mov    (%eax),%eax
  8032f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032fa:	8b 52 04             	mov    0x4(%edx),%edx
  8032fd:	89 50 04             	mov    %edx,0x4(%eax)
  803300:	eb 0b                	jmp    80330d <alloc_block_BF+0x3e4>
  803302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803305:	8b 40 04             	mov    0x4(%eax),%eax
  803308:	a3 34 50 80 00       	mov    %eax,0x805034
  80330d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803310:	8b 40 04             	mov    0x4(%eax),%eax
  803313:	85 c0                	test   %eax,%eax
  803315:	74 0f                	je     803326 <alloc_block_BF+0x3fd>
  803317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331a:	8b 40 04             	mov    0x4(%eax),%eax
  80331d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803320:	8b 12                	mov    (%edx),%edx
  803322:	89 10                	mov    %edx,(%eax)
  803324:	eb 0a                	jmp    803330 <alloc_block_BF+0x407>
  803326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803329:	8b 00                	mov    (%eax),%eax
  80332b:	a3 30 50 80 00       	mov    %eax,0x805030
  803330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803333:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803343:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803348:	48                   	dec    %eax
  803349:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  80334e:	83 ec 04             	sub    $0x4,%esp
  803351:	6a 00                	push   $0x0
  803353:	ff 75 d0             	pushl  -0x30(%ebp)
  803356:	ff 75 cc             	pushl  -0x34(%ebp)
  803359:	e8 e0 f6 ff ff       	call   802a3e <set_block_data>
  80335e:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803364:	e9 a3 01 00 00       	jmp    80350c <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803369:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80336d:	0f 85 9d 00 00 00    	jne    803410 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803373:	83 ec 04             	sub    $0x4,%esp
  803376:	6a 01                	push   $0x1
  803378:	ff 75 ec             	pushl  -0x14(%ebp)
  80337b:	ff 75 f0             	pushl  -0x10(%ebp)
  80337e:	e8 bb f6 ff ff       	call   802a3e <set_block_data>
  803383:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803386:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80338a:	75 17                	jne    8033a3 <alloc_block_BF+0x47a>
  80338c:	83 ec 04             	sub    $0x4,%esp
  80338f:	68 33 4d 80 00       	push   $0x804d33
  803394:	68 58 01 00 00       	push   $0x158
  803399:	68 51 4d 80 00       	push   $0x804d51
  80339e:	e8 a2 d4 ff ff       	call   800845 <_panic>
  8033a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a6:	8b 00                	mov    (%eax),%eax
  8033a8:	85 c0                	test   %eax,%eax
  8033aa:	74 10                	je     8033bc <alloc_block_BF+0x493>
  8033ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033af:	8b 00                	mov    (%eax),%eax
  8033b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033b4:	8b 52 04             	mov    0x4(%edx),%edx
  8033b7:	89 50 04             	mov    %edx,0x4(%eax)
  8033ba:	eb 0b                	jmp    8033c7 <alloc_block_BF+0x49e>
  8033bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bf:	8b 40 04             	mov    0x4(%eax),%eax
  8033c2:	a3 34 50 80 00       	mov    %eax,0x805034
  8033c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ca:	8b 40 04             	mov    0x4(%eax),%eax
  8033cd:	85 c0                	test   %eax,%eax
  8033cf:	74 0f                	je     8033e0 <alloc_block_BF+0x4b7>
  8033d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d4:	8b 40 04             	mov    0x4(%eax),%eax
  8033d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033da:	8b 12                	mov    (%edx),%edx
  8033dc:	89 10                	mov    %edx,(%eax)
  8033de:	eb 0a                	jmp    8033ea <alloc_block_BF+0x4c1>
  8033e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e3:	8b 00                	mov    (%eax),%eax
  8033e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8033ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033fd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803402:	48                   	dec    %eax
  803403:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  803408:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340b:	e9 fc 00 00 00       	jmp    80350c <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803410:	8b 45 08             	mov    0x8(%ebp),%eax
  803413:	83 c0 08             	add    $0x8,%eax
  803416:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803419:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803420:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803423:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803426:	01 d0                	add    %edx,%eax
  803428:	48                   	dec    %eax
  803429:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80342c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80342f:	ba 00 00 00 00       	mov    $0x0,%edx
  803434:	f7 75 c4             	divl   -0x3c(%ebp)
  803437:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80343a:	29 d0                	sub    %edx,%eax
  80343c:	c1 e8 0c             	shr    $0xc,%eax
  80343f:	83 ec 0c             	sub    $0xc,%esp
  803442:	50                   	push   %eax
  803443:	e8 5c e6 ff ff       	call   801aa4 <sbrk>
  803448:	83 c4 10             	add    $0x10,%esp
  80344b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80344e:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803452:	75 0a                	jne    80345e <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803454:	b8 00 00 00 00       	mov    $0x0,%eax
  803459:	e9 ae 00 00 00       	jmp    80350c <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80345e:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803465:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803468:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80346b:	01 d0                	add    %edx,%eax
  80346d:	48                   	dec    %eax
  80346e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803471:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803474:	ba 00 00 00 00       	mov    $0x0,%edx
  803479:	f7 75 b8             	divl   -0x48(%ebp)
  80347c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80347f:	29 d0                	sub    %edx,%eax
  803481:	8d 50 fc             	lea    -0x4(%eax),%edx
  803484:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803487:	01 d0                	add    %edx,%eax
  803489:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  80348e:	a1 44 50 80 00       	mov    0x805044,%eax
  803493:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803499:	83 ec 0c             	sub    $0xc,%esp
  80349c:	68 f8 4d 80 00       	push   $0x804df8
  8034a1:	e8 5c d6 ff ff       	call   800b02 <cprintf>
  8034a6:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8034a9:	83 ec 08             	sub    $0x8,%esp
  8034ac:	ff 75 bc             	pushl  -0x44(%ebp)
  8034af:	68 fd 4d 80 00       	push   $0x804dfd
  8034b4:	e8 49 d6 ff ff       	call   800b02 <cprintf>
  8034b9:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8034bc:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8034c3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034c6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8034c9:	01 d0                	add    %edx,%eax
  8034cb:	48                   	dec    %eax
  8034cc:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8034cf:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8034d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8034d7:	f7 75 b0             	divl   -0x50(%ebp)
  8034da:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8034dd:	29 d0                	sub    %edx,%eax
  8034df:	83 ec 04             	sub    $0x4,%esp
  8034e2:	6a 01                	push   $0x1
  8034e4:	50                   	push   %eax
  8034e5:	ff 75 bc             	pushl  -0x44(%ebp)
  8034e8:	e8 51 f5 ff ff       	call   802a3e <set_block_data>
  8034ed:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8034f0:	83 ec 0c             	sub    $0xc,%esp
  8034f3:	ff 75 bc             	pushl  -0x44(%ebp)
  8034f6:	e8 36 04 00 00       	call   803931 <free_block>
  8034fb:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8034fe:	83 ec 0c             	sub    $0xc,%esp
  803501:	ff 75 08             	pushl  0x8(%ebp)
  803504:	e8 20 fa ff ff       	call   802f29 <alloc_block_BF>
  803509:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80350c:	c9                   	leave  
  80350d:	c3                   	ret    

0080350e <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80350e:	55                   	push   %ebp
  80350f:	89 e5                	mov    %esp,%ebp
  803511:	53                   	push   %ebx
  803512:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803515:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80351c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803523:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803527:	74 1e                	je     803547 <merging+0x39>
  803529:	ff 75 08             	pushl  0x8(%ebp)
  80352c:	e8 bc f1 ff ff       	call   8026ed <get_block_size>
  803531:	83 c4 04             	add    $0x4,%esp
  803534:	89 c2                	mov    %eax,%edx
  803536:	8b 45 08             	mov    0x8(%ebp),%eax
  803539:	01 d0                	add    %edx,%eax
  80353b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80353e:	75 07                	jne    803547 <merging+0x39>
		prev_is_free = 1;
  803540:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803547:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80354b:	74 1e                	je     80356b <merging+0x5d>
  80354d:	ff 75 10             	pushl  0x10(%ebp)
  803550:	e8 98 f1 ff ff       	call   8026ed <get_block_size>
  803555:	83 c4 04             	add    $0x4,%esp
  803558:	89 c2                	mov    %eax,%edx
  80355a:	8b 45 10             	mov    0x10(%ebp),%eax
  80355d:	01 d0                	add    %edx,%eax
  80355f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803562:	75 07                	jne    80356b <merging+0x5d>
		next_is_free = 1;
  803564:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80356b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80356f:	0f 84 cc 00 00 00    	je     803641 <merging+0x133>
  803575:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803579:	0f 84 c2 00 00 00    	je     803641 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80357f:	ff 75 08             	pushl  0x8(%ebp)
  803582:	e8 66 f1 ff ff       	call   8026ed <get_block_size>
  803587:	83 c4 04             	add    $0x4,%esp
  80358a:	89 c3                	mov    %eax,%ebx
  80358c:	ff 75 10             	pushl  0x10(%ebp)
  80358f:	e8 59 f1 ff ff       	call   8026ed <get_block_size>
  803594:	83 c4 04             	add    $0x4,%esp
  803597:	01 c3                	add    %eax,%ebx
  803599:	ff 75 0c             	pushl  0xc(%ebp)
  80359c:	e8 4c f1 ff ff       	call   8026ed <get_block_size>
  8035a1:	83 c4 04             	add    $0x4,%esp
  8035a4:	01 d8                	add    %ebx,%eax
  8035a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8035a9:	6a 00                	push   $0x0
  8035ab:	ff 75 ec             	pushl  -0x14(%ebp)
  8035ae:	ff 75 08             	pushl  0x8(%ebp)
  8035b1:	e8 88 f4 ff ff       	call   802a3e <set_block_data>
  8035b6:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8035b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035bd:	75 17                	jne    8035d6 <merging+0xc8>
  8035bf:	83 ec 04             	sub    $0x4,%esp
  8035c2:	68 33 4d 80 00       	push   $0x804d33
  8035c7:	68 7d 01 00 00       	push   $0x17d
  8035cc:	68 51 4d 80 00       	push   $0x804d51
  8035d1:	e8 6f d2 ff ff       	call   800845 <_panic>
  8035d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d9:	8b 00                	mov    (%eax),%eax
  8035db:	85 c0                	test   %eax,%eax
  8035dd:	74 10                	je     8035ef <merging+0xe1>
  8035df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e2:	8b 00                	mov    (%eax),%eax
  8035e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035e7:	8b 52 04             	mov    0x4(%edx),%edx
  8035ea:	89 50 04             	mov    %edx,0x4(%eax)
  8035ed:	eb 0b                	jmp    8035fa <merging+0xec>
  8035ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f2:	8b 40 04             	mov    0x4(%eax),%eax
  8035f5:	a3 34 50 80 00       	mov    %eax,0x805034
  8035fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fd:	8b 40 04             	mov    0x4(%eax),%eax
  803600:	85 c0                	test   %eax,%eax
  803602:	74 0f                	je     803613 <merging+0x105>
  803604:	8b 45 0c             	mov    0xc(%ebp),%eax
  803607:	8b 40 04             	mov    0x4(%eax),%eax
  80360a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80360d:	8b 12                	mov    (%edx),%edx
  80360f:	89 10                	mov    %edx,(%eax)
  803611:	eb 0a                	jmp    80361d <merging+0x10f>
  803613:	8b 45 0c             	mov    0xc(%ebp),%eax
  803616:	8b 00                	mov    (%eax),%eax
  803618:	a3 30 50 80 00       	mov    %eax,0x805030
  80361d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803626:	8b 45 0c             	mov    0xc(%ebp),%eax
  803629:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803630:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803635:	48                   	dec    %eax
  803636:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80363b:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80363c:	e9 ea 02 00 00       	jmp    80392b <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803641:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803645:	74 3b                	je     803682 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803647:	83 ec 0c             	sub    $0xc,%esp
  80364a:	ff 75 08             	pushl  0x8(%ebp)
  80364d:	e8 9b f0 ff ff       	call   8026ed <get_block_size>
  803652:	83 c4 10             	add    $0x10,%esp
  803655:	89 c3                	mov    %eax,%ebx
  803657:	83 ec 0c             	sub    $0xc,%esp
  80365a:	ff 75 10             	pushl  0x10(%ebp)
  80365d:	e8 8b f0 ff ff       	call   8026ed <get_block_size>
  803662:	83 c4 10             	add    $0x10,%esp
  803665:	01 d8                	add    %ebx,%eax
  803667:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80366a:	83 ec 04             	sub    $0x4,%esp
  80366d:	6a 00                	push   $0x0
  80366f:	ff 75 e8             	pushl  -0x18(%ebp)
  803672:	ff 75 08             	pushl  0x8(%ebp)
  803675:	e8 c4 f3 ff ff       	call   802a3e <set_block_data>
  80367a:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80367d:	e9 a9 02 00 00       	jmp    80392b <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803682:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803686:	0f 84 2d 01 00 00    	je     8037b9 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80368c:	83 ec 0c             	sub    $0xc,%esp
  80368f:	ff 75 10             	pushl  0x10(%ebp)
  803692:	e8 56 f0 ff ff       	call   8026ed <get_block_size>
  803697:	83 c4 10             	add    $0x10,%esp
  80369a:	89 c3                	mov    %eax,%ebx
  80369c:	83 ec 0c             	sub    $0xc,%esp
  80369f:	ff 75 0c             	pushl  0xc(%ebp)
  8036a2:	e8 46 f0 ff ff       	call   8026ed <get_block_size>
  8036a7:	83 c4 10             	add    $0x10,%esp
  8036aa:	01 d8                	add    %ebx,%eax
  8036ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8036af:	83 ec 04             	sub    $0x4,%esp
  8036b2:	6a 00                	push   $0x0
  8036b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036b7:	ff 75 10             	pushl  0x10(%ebp)
  8036ba:	e8 7f f3 ff ff       	call   802a3e <set_block_data>
  8036bf:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8036c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8036c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8036c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036cc:	74 06                	je     8036d4 <merging+0x1c6>
  8036ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8036d2:	75 17                	jne    8036eb <merging+0x1dd>
  8036d4:	83 ec 04             	sub    $0x4,%esp
  8036d7:	68 0c 4e 80 00       	push   $0x804e0c
  8036dc:	68 8d 01 00 00       	push   $0x18d
  8036e1:	68 51 4d 80 00       	push   $0x804d51
  8036e6:	e8 5a d1 ff ff       	call   800845 <_panic>
  8036eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ee:	8b 50 04             	mov    0x4(%eax),%edx
  8036f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036f4:	89 50 04             	mov    %edx,0x4(%eax)
  8036f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036fd:	89 10                	mov    %edx,(%eax)
  8036ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803702:	8b 40 04             	mov    0x4(%eax),%eax
  803705:	85 c0                	test   %eax,%eax
  803707:	74 0d                	je     803716 <merging+0x208>
  803709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80370c:	8b 40 04             	mov    0x4(%eax),%eax
  80370f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803712:	89 10                	mov    %edx,(%eax)
  803714:	eb 08                	jmp    80371e <merging+0x210>
  803716:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803719:	a3 30 50 80 00       	mov    %eax,0x805030
  80371e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803721:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803724:	89 50 04             	mov    %edx,0x4(%eax)
  803727:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80372c:	40                   	inc    %eax
  80372d:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  803732:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803736:	75 17                	jne    80374f <merging+0x241>
  803738:	83 ec 04             	sub    $0x4,%esp
  80373b:	68 33 4d 80 00       	push   $0x804d33
  803740:	68 8e 01 00 00       	push   $0x18e
  803745:	68 51 4d 80 00       	push   $0x804d51
  80374a:	e8 f6 d0 ff ff       	call   800845 <_panic>
  80374f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803752:	8b 00                	mov    (%eax),%eax
  803754:	85 c0                	test   %eax,%eax
  803756:	74 10                	je     803768 <merging+0x25a>
  803758:	8b 45 0c             	mov    0xc(%ebp),%eax
  80375b:	8b 00                	mov    (%eax),%eax
  80375d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803760:	8b 52 04             	mov    0x4(%edx),%edx
  803763:	89 50 04             	mov    %edx,0x4(%eax)
  803766:	eb 0b                	jmp    803773 <merging+0x265>
  803768:	8b 45 0c             	mov    0xc(%ebp),%eax
  80376b:	8b 40 04             	mov    0x4(%eax),%eax
  80376e:	a3 34 50 80 00       	mov    %eax,0x805034
  803773:	8b 45 0c             	mov    0xc(%ebp),%eax
  803776:	8b 40 04             	mov    0x4(%eax),%eax
  803779:	85 c0                	test   %eax,%eax
  80377b:	74 0f                	je     80378c <merging+0x27e>
  80377d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803780:	8b 40 04             	mov    0x4(%eax),%eax
  803783:	8b 55 0c             	mov    0xc(%ebp),%edx
  803786:	8b 12                	mov    (%edx),%edx
  803788:	89 10                	mov    %edx,(%eax)
  80378a:	eb 0a                	jmp    803796 <merging+0x288>
  80378c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80378f:	8b 00                	mov    (%eax),%eax
  803791:	a3 30 50 80 00       	mov    %eax,0x805030
  803796:	8b 45 0c             	mov    0xc(%ebp),%eax
  803799:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80379f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037ae:	48                   	dec    %eax
  8037af:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8037b4:	e9 72 01 00 00       	jmp    80392b <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8037b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8037bc:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8037bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037c3:	74 79                	je     80383e <merging+0x330>
  8037c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037c9:	74 73                	je     80383e <merging+0x330>
  8037cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037cf:	74 06                	je     8037d7 <merging+0x2c9>
  8037d1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037d5:	75 17                	jne    8037ee <merging+0x2e0>
  8037d7:	83 ec 04             	sub    $0x4,%esp
  8037da:	68 c4 4d 80 00       	push   $0x804dc4
  8037df:	68 94 01 00 00       	push   $0x194
  8037e4:	68 51 4d 80 00       	push   $0x804d51
  8037e9:	e8 57 d0 ff ff       	call   800845 <_panic>
  8037ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f1:	8b 10                	mov    (%eax),%edx
  8037f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f6:	89 10                	mov    %edx,(%eax)
  8037f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037fb:	8b 00                	mov    (%eax),%eax
  8037fd:	85 c0                	test   %eax,%eax
  8037ff:	74 0b                	je     80380c <merging+0x2fe>
  803801:	8b 45 08             	mov    0x8(%ebp),%eax
  803804:	8b 00                	mov    (%eax),%eax
  803806:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803809:	89 50 04             	mov    %edx,0x4(%eax)
  80380c:	8b 45 08             	mov    0x8(%ebp),%eax
  80380f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803812:	89 10                	mov    %edx,(%eax)
  803814:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803817:	8b 55 08             	mov    0x8(%ebp),%edx
  80381a:	89 50 04             	mov    %edx,0x4(%eax)
  80381d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803820:	8b 00                	mov    (%eax),%eax
  803822:	85 c0                	test   %eax,%eax
  803824:	75 08                	jne    80382e <merging+0x320>
  803826:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803829:	a3 34 50 80 00       	mov    %eax,0x805034
  80382e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803833:	40                   	inc    %eax
  803834:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803839:	e9 ce 00 00 00       	jmp    80390c <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80383e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803842:	74 65                	je     8038a9 <merging+0x39b>
  803844:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803848:	75 17                	jne    803861 <merging+0x353>
  80384a:	83 ec 04             	sub    $0x4,%esp
  80384d:	68 a0 4d 80 00       	push   $0x804da0
  803852:	68 95 01 00 00       	push   $0x195
  803857:	68 51 4d 80 00       	push   $0x804d51
  80385c:	e8 e4 cf ff ff       	call   800845 <_panic>
  803861:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803867:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80386a:	89 50 04             	mov    %edx,0x4(%eax)
  80386d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803870:	8b 40 04             	mov    0x4(%eax),%eax
  803873:	85 c0                	test   %eax,%eax
  803875:	74 0c                	je     803883 <merging+0x375>
  803877:	a1 34 50 80 00       	mov    0x805034,%eax
  80387c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80387f:	89 10                	mov    %edx,(%eax)
  803881:	eb 08                	jmp    80388b <merging+0x37d>
  803883:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803886:	a3 30 50 80 00       	mov    %eax,0x805030
  80388b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80388e:	a3 34 50 80 00       	mov    %eax,0x805034
  803893:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803896:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80389c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8038a1:	40                   	inc    %eax
  8038a2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8038a7:	eb 63                	jmp    80390c <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8038a9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038ad:	75 17                	jne    8038c6 <merging+0x3b8>
  8038af:	83 ec 04             	sub    $0x4,%esp
  8038b2:	68 6c 4d 80 00       	push   $0x804d6c
  8038b7:	68 98 01 00 00       	push   $0x198
  8038bc:	68 51 4d 80 00       	push   $0x804d51
  8038c1:	e8 7f cf ff ff       	call   800845 <_panic>
  8038c6:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8038cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038cf:	89 10                	mov    %edx,(%eax)
  8038d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038d4:	8b 00                	mov    (%eax),%eax
  8038d6:	85 c0                	test   %eax,%eax
  8038d8:	74 0d                	je     8038e7 <merging+0x3d9>
  8038da:	a1 30 50 80 00       	mov    0x805030,%eax
  8038df:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038e2:	89 50 04             	mov    %edx,0x4(%eax)
  8038e5:	eb 08                	jmp    8038ef <merging+0x3e1>
  8038e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038ea:	a3 34 50 80 00       	mov    %eax,0x805034
  8038ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8038f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803901:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803906:	40                   	inc    %eax
  803907:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  80390c:	83 ec 0c             	sub    $0xc,%esp
  80390f:	ff 75 10             	pushl  0x10(%ebp)
  803912:	e8 d6 ed ff ff       	call   8026ed <get_block_size>
  803917:	83 c4 10             	add    $0x10,%esp
  80391a:	83 ec 04             	sub    $0x4,%esp
  80391d:	6a 00                	push   $0x0
  80391f:	50                   	push   %eax
  803920:	ff 75 10             	pushl  0x10(%ebp)
  803923:	e8 16 f1 ff ff       	call   802a3e <set_block_data>
  803928:	83 c4 10             	add    $0x10,%esp
	}
}
  80392b:	90                   	nop
  80392c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80392f:	c9                   	leave  
  803930:	c3                   	ret    

00803931 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803931:	55                   	push   %ebp
  803932:	89 e5                	mov    %esp,%ebp
  803934:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803937:	a1 30 50 80 00       	mov    0x805030,%eax
  80393c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80393f:	a1 34 50 80 00       	mov    0x805034,%eax
  803944:	3b 45 08             	cmp    0x8(%ebp),%eax
  803947:	73 1b                	jae    803964 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803949:	a1 34 50 80 00       	mov    0x805034,%eax
  80394e:	83 ec 04             	sub    $0x4,%esp
  803951:	ff 75 08             	pushl  0x8(%ebp)
  803954:	6a 00                	push   $0x0
  803956:	50                   	push   %eax
  803957:	e8 b2 fb ff ff       	call   80350e <merging>
  80395c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80395f:	e9 8b 00 00 00       	jmp    8039ef <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803964:	a1 30 50 80 00       	mov    0x805030,%eax
  803969:	3b 45 08             	cmp    0x8(%ebp),%eax
  80396c:	76 18                	jbe    803986 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80396e:	a1 30 50 80 00       	mov    0x805030,%eax
  803973:	83 ec 04             	sub    $0x4,%esp
  803976:	ff 75 08             	pushl  0x8(%ebp)
  803979:	50                   	push   %eax
  80397a:	6a 00                	push   $0x0
  80397c:	e8 8d fb ff ff       	call   80350e <merging>
  803981:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803984:	eb 69                	jmp    8039ef <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803986:	a1 30 50 80 00       	mov    0x805030,%eax
  80398b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80398e:	eb 39                	jmp    8039c9 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803993:	3b 45 08             	cmp    0x8(%ebp),%eax
  803996:	73 29                	jae    8039c1 <free_block+0x90>
  803998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399b:	8b 00                	mov    (%eax),%eax
  80399d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039a0:	76 1f                	jbe    8039c1 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8039a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a5:	8b 00                	mov    (%eax),%eax
  8039a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8039aa:	83 ec 04             	sub    $0x4,%esp
  8039ad:	ff 75 08             	pushl  0x8(%ebp)
  8039b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8039b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8039b6:	e8 53 fb ff ff       	call   80350e <merging>
  8039bb:	83 c4 10             	add    $0x10,%esp
			break;
  8039be:	90                   	nop
		}
	}
}
  8039bf:	eb 2e                	jmp    8039ef <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8039c1:	a1 38 50 80 00       	mov    0x805038,%eax
  8039c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039cd:	74 07                	je     8039d6 <free_block+0xa5>
  8039cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d2:	8b 00                	mov    (%eax),%eax
  8039d4:	eb 05                	jmp    8039db <free_block+0xaa>
  8039d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8039db:	a3 38 50 80 00       	mov    %eax,0x805038
  8039e0:	a1 38 50 80 00       	mov    0x805038,%eax
  8039e5:	85 c0                	test   %eax,%eax
  8039e7:	75 a7                	jne    803990 <free_block+0x5f>
  8039e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039ed:	75 a1                	jne    803990 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8039ef:	90                   	nop
  8039f0:	c9                   	leave  
  8039f1:	c3                   	ret    

008039f2 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8039f2:	55                   	push   %ebp
  8039f3:	89 e5                	mov    %esp,%ebp
  8039f5:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8039f8:	ff 75 08             	pushl  0x8(%ebp)
  8039fb:	e8 ed ec ff ff       	call   8026ed <get_block_size>
  803a00:	83 c4 04             	add    $0x4,%esp
  803a03:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803a06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803a0d:	eb 17                	jmp    803a26 <copy_data+0x34>
  803a0f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803a12:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a15:	01 c2                	add    %eax,%edx
  803a17:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1d:	01 c8                	add    %ecx,%eax
  803a1f:	8a 00                	mov    (%eax),%al
  803a21:	88 02                	mov    %al,(%edx)
  803a23:	ff 45 fc             	incl   -0x4(%ebp)
  803a26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a29:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803a2c:	72 e1                	jb     803a0f <copy_data+0x1d>
}
  803a2e:	90                   	nop
  803a2f:	c9                   	leave  
  803a30:	c3                   	ret    

00803a31 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803a31:	55                   	push   %ebp
  803a32:	89 e5                	mov    %esp,%ebp
  803a34:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803a37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a3b:	75 23                	jne    803a60 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803a3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a41:	74 13                	je     803a56 <realloc_block_FF+0x25>
  803a43:	83 ec 0c             	sub    $0xc,%esp
  803a46:	ff 75 0c             	pushl  0xc(%ebp)
  803a49:	e8 1f f0 ff ff       	call   802a6d <alloc_block_FF>
  803a4e:	83 c4 10             	add    $0x10,%esp
  803a51:	e9 f4 06 00 00       	jmp    80414a <realloc_block_FF+0x719>
		return NULL;
  803a56:	b8 00 00 00 00       	mov    $0x0,%eax
  803a5b:	e9 ea 06 00 00       	jmp    80414a <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803a60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a64:	75 18                	jne    803a7e <realloc_block_FF+0x4d>
	{
		free_block(va);
  803a66:	83 ec 0c             	sub    $0xc,%esp
  803a69:	ff 75 08             	pushl  0x8(%ebp)
  803a6c:	e8 c0 fe ff ff       	call   803931 <free_block>
  803a71:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803a74:	b8 00 00 00 00       	mov    $0x0,%eax
  803a79:	e9 cc 06 00 00       	jmp    80414a <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803a7e:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803a82:	77 07                	ja     803a8b <realloc_block_FF+0x5a>
  803a84:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a8e:	83 e0 01             	and    $0x1,%eax
  803a91:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803a94:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a97:	83 c0 08             	add    $0x8,%eax
  803a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803a9d:	83 ec 0c             	sub    $0xc,%esp
  803aa0:	ff 75 08             	pushl  0x8(%ebp)
  803aa3:	e8 45 ec ff ff       	call   8026ed <get_block_size>
  803aa8:	83 c4 10             	add    $0x10,%esp
  803aab:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803aae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ab1:	83 e8 08             	sub    $0x8,%eax
  803ab4:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aba:	83 e8 04             	sub    $0x4,%eax
  803abd:	8b 00                	mov    (%eax),%eax
  803abf:	83 e0 fe             	and    $0xfffffffe,%eax
  803ac2:	89 c2                	mov    %eax,%edx
  803ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac7:	01 d0                	add    %edx,%eax
  803ac9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803acc:	83 ec 0c             	sub    $0xc,%esp
  803acf:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ad2:	e8 16 ec ff ff       	call   8026ed <get_block_size>
  803ad7:	83 c4 10             	add    $0x10,%esp
  803ada:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803add:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ae0:	83 e8 08             	sub    $0x8,%eax
  803ae3:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ae9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803aec:	75 08                	jne    803af6 <realloc_block_FF+0xc5>
	{
		 return va;
  803aee:	8b 45 08             	mov    0x8(%ebp),%eax
  803af1:	e9 54 06 00 00       	jmp    80414a <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803af9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803afc:	0f 83 e5 03 00 00    	jae    803ee7 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803b02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b05:	2b 45 0c             	sub    0xc(%ebp),%eax
  803b08:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803b0b:	83 ec 0c             	sub    $0xc,%esp
  803b0e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b11:	e8 f0 eb ff ff       	call   802706 <is_free_block>
  803b16:	83 c4 10             	add    $0x10,%esp
  803b19:	84 c0                	test   %al,%al
  803b1b:	0f 84 3b 01 00 00    	je     803c5c <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803b21:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b24:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b27:	01 d0                	add    %edx,%eax
  803b29:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803b2c:	83 ec 04             	sub    $0x4,%esp
  803b2f:	6a 01                	push   $0x1
  803b31:	ff 75 f0             	pushl  -0x10(%ebp)
  803b34:	ff 75 08             	pushl  0x8(%ebp)
  803b37:	e8 02 ef ff ff       	call   802a3e <set_block_data>
  803b3c:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b42:	83 e8 04             	sub    $0x4,%eax
  803b45:	8b 00                	mov    (%eax),%eax
  803b47:	83 e0 fe             	and    $0xfffffffe,%eax
  803b4a:	89 c2                	mov    %eax,%edx
  803b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4f:	01 d0                	add    %edx,%eax
  803b51:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803b54:	83 ec 04             	sub    $0x4,%esp
  803b57:	6a 00                	push   $0x0
  803b59:	ff 75 cc             	pushl  -0x34(%ebp)
  803b5c:	ff 75 c8             	pushl  -0x38(%ebp)
  803b5f:	e8 da ee ff ff       	call   802a3e <set_block_data>
  803b64:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803b67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b6b:	74 06                	je     803b73 <realloc_block_FF+0x142>
  803b6d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803b71:	75 17                	jne    803b8a <realloc_block_FF+0x159>
  803b73:	83 ec 04             	sub    $0x4,%esp
  803b76:	68 c4 4d 80 00       	push   $0x804dc4
  803b7b:	68 f6 01 00 00       	push   $0x1f6
  803b80:	68 51 4d 80 00       	push   $0x804d51
  803b85:	e8 bb cc ff ff       	call   800845 <_panic>
  803b8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b8d:	8b 10                	mov    (%eax),%edx
  803b8f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b92:	89 10                	mov    %edx,(%eax)
  803b94:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b97:	8b 00                	mov    (%eax),%eax
  803b99:	85 c0                	test   %eax,%eax
  803b9b:	74 0b                	je     803ba8 <realloc_block_FF+0x177>
  803b9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba0:	8b 00                	mov    (%eax),%eax
  803ba2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ba5:	89 50 04             	mov    %edx,0x4(%eax)
  803ba8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bab:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bae:	89 10                	mov    %edx,(%eax)
  803bb0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bb6:	89 50 04             	mov    %edx,0x4(%eax)
  803bb9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bbc:	8b 00                	mov    (%eax),%eax
  803bbe:	85 c0                	test   %eax,%eax
  803bc0:	75 08                	jne    803bca <realloc_block_FF+0x199>
  803bc2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bc5:	a3 34 50 80 00       	mov    %eax,0x805034
  803bca:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bcf:	40                   	inc    %eax
  803bd0:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803bd5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bd9:	75 17                	jne    803bf2 <realloc_block_FF+0x1c1>
  803bdb:	83 ec 04             	sub    $0x4,%esp
  803bde:	68 33 4d 80 00       	push   $0x804d33
  803be3:	68 f7 01 00 00       	push   $0x1f7
  803be8:	68 51 4d 80 00       	push   $0x804d51
  803bed:	e8 53 cc ff ff       	call   800845 <_panic>
  803bf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf5:	8b 00                	mov    (%eax),%eax
  803bf7:	85 c0                	test   %eax,%eax
  803bf9:	74 10                	je     803c0b <realloc_block_FF+0x1da>
  803bfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bfe:	8b 00                	mov    (%eax),%eax
  803c00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c03:	8b 52 04             	mov    0x4(%edx),%edx
  803c06:	89 50 04             	mov    %edx,0x4(%eax)
  803c09:	eb 0b                	jmp    803c16 <realloc_block_FF+0x1e5>
  803c0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c0e:	8b 40 04             	mov    0x4(%eax),%eax
  803c11:	a3 34 50 80 00       	mov    %eax,0x805034
  803c16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c19:	8b 40 04             	mov    0x4(%eax),%eax
  803c1c:	85 c0                	test   %eax,%eax
  803c1e:	74 0f                	je     803c2f <realloc_block_FF+0x1fe>
  803c20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c23:	8b 40 04             	mov    0x4(%eax),%eax
  803c26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c29:	8b 12                	mov    (%edx),%edx
  803c2b:	89 10                	mov    %edx,(%eax)
  803c2d:	eb 0a                	jmp    803c39 <realloc_block_FF+0x208>
  803c2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c32:	8b 00                	mov    (%eax),%eax
  803c34:	a3 30 50 80 00       	mov    %eax,0x805030
  803c39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c4c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c51:	48                   	dec    %eax
  803c52:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c57:	e9 83 02 00 00       	jmp    803edf <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803c5c:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803c60:	0f 86 69 02 00 00    	jbe    803ecf <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803c66:	83 ec 04             	sub    $0x4,%esp
  803c69:	6a 01                	push   $0x1
  803c6b:	ff 75 f0             	pushl  -0x10(%ebp)
  803c6e:	ff 75 08             	pushl  0x8(%ebp)
  803c71:	e8 c8 ed ff ff       	call   802a3e <set_block_data>
  803c76:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803c79:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7c:	83 e8 04             	sub    $0x4,%eax
  803c7f:	8b 00                	mov    (%eax),%eax
  803c81:	83 e0 fe             	and    $0xfffffffe,%eax
  803c84:	89 c2                	mov    %eax,%edx
  803c86:	8b 45 08             	mov    0x8(%ebp),%eax
  803c89:	01 d0                	add    %edx,%eax
  803c8b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803c8e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c93:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803c96:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803c9a:	75 68                	jne    803d04 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c9c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ca0:	75 17                	jne    803cb9 <realloc_block_FF+0x288>
  803ca2:	83 ec 04             	sub    $0x4,%esp
  803ca5:	68 6c 4d 80 00       	push   $0x804d6c
  803caa:	68 06 02 00 00       	push   $0x206
  803caf:	68 51 4d 80 00       	push   $0x804d51
  803cb4:	e8 8c cb ff ff       	call   800845 <_panic>
  803cb9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803cbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc2:	89 10                	mov    %edx,(%eax)
  803cc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc7:	8b 00                	mov    (%eax),%eax
  803cc9:	85 c0                	test   %eax,%eax
  803ccb:	74 0d                	je     803cda <realloc_block_FF+0x2a9>
  803ccd:	a1 30 50 80 00       	mov    0x805030,%eax
  803cd2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cd5:	89 50 04             	mov    %edx,0x4(%eax)
  803cd8:	eb 08                	jmp    803ce2 <realloc_block_FF+0x2b1>
  803cda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cdd:	a3 34 50 80 00       	mov    %eax,0x805034
  803ce2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ce5:	a3 30 50 80 00       	mov    %eax,0x805030
  803cea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ced:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cf4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803cf9:	40                   	inc    %eax
  803cfa:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803cff:	e9 b0 01 00 00       	jmp    803eb4 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803d04:	a1 30 50 80 00       	mov    0x805030,%eax
  803d09:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d0c:	76 68                	jbe    803d76 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d0e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d12:	75 17                	jne    803d2b <realloc_block_FF+0x2fa>
  803d14:	83 ec 04             	sub    $0x4,%esp
  803d17:	68 6c 4d 80 00       	push   $0x804d6c
  803d1c:	68 0b 02 00 00       	push   $0x20b
  803d21:	68 51 4d 80 00       	push   $0x804d51
  803d26:	e8 1a cb ff ff       	call   800845 <_panic>
  803d2b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803d31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d34:	89 10                	mov    %edx,(%eax)
  803d36:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d39:	8b 00                	mov    (%eax),%eax
  803d3b:	85 c0                	test   %eax,%eax
  803d3d:	74 0d                	je     803d4c <realloc_block_FF+0x31b>
  803d3f:	a1 30 50 80 00       	mov    0x805030,%eax
  803d44:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d47:	89 50 04             	mov    %edx,0x4(%eax)
  803d4a:	eb 08                	jmp    803d54 <realloc_block_FF+0x323>
  803d4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d4f:	a3 34 50 80 00       	mov    %eax,0x805034
  803d54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d57:	a3 30 50 80 00       	mov    %eax,0x805030
  803d5c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d66:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d6b:	40                   	inc    %eax
  803d6c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803d71:	e9 3e 01 00 00       	jmp    803eb4 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803d76:	a1 30 50 80 00       	mov    0x805030,%eax
  803d7b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d7e:	73 68                	jae    803de8 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d80:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d84:	75 17                	jne    803d9d <realloc_block_FF+0x36c>
  803d86:	83 ec 04             	sub    $0x4,%esp
  803d89:	68 a0 4d 80 00       	push   $0x804da0
  803d8e:	68 10 02 00 00       	push   $0x210
  803d93:	68 51 4d 80 00       	push   $0x804d51
  803d98:	e8 a8 ca ff ff       	call   800845 <_panic>
  803d9d:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803da3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803da6:	89 50 04             	mov    %edx,0x4(%eax)
  803da9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dac:	8b 40 04             	mov    0x4(%eax),%eax
  803daf:	85 c0                	test   %eax,%eax
  803db1:	74 0c                	je     803dbf <realloc_block_FF+0x38e>
  803db3:	a1 34 50 80 00       	mov    0x805034,%eax
  803db8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dbb:	89 10                	mov    %edx,(%eax)
  803dbd:	eb 08                	jmp    803dc7 <realloc_block_FF+0x396>
  803dbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dc2:	a3 30 50 80 00       	mov    %eax,0x805030
  803dc7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dca:	a3 34 50 80 00       	mov    %eax,0x805034
  803dcf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dd8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ddd:	40                   	inc    %eax
  803dde:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803de3:	e9 cc 00 00 00       	jmp    803eb4 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803de8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803def:	a1 30 50 80 00       	mov    0x805030,%eax
  803df4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803df7:	e9 8a 00 00 00       	jmp    803e86 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dff:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e02:	73 7a                	jae    803e7e <realloc_block_FF+0x44d>
  803e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e07:	8b 00                	mov    (%eax),%eax
  803e09:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e0c:	73 70                	jae    803e7e <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803e0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e12:	74 06                	je     803e1a <realloc_block_FF+0x3e9>
  803e14:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e18:	75 17                	jne    803e31 <realloc_block_FF+0x400>
  803e1a:	83 ec 04             	sub    $0x4,%esp
  803e1d:	68 c4 4d 80 00       	push   $0x804dc4
  803e22:	68 1a 02 00 00       	push   $0x21a
  803e27:	68 51 4d 80 00       	push   $0x804d51
  803e2c:	e8 14 ca ff ff       	call   800845 <_panic>
  803e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e34:	8b 10                	mov    (%eax),%edx
  803e36:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e39:	89 10                	mov    %edx,(%eax)
  803e3b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e3e:	8b 00                	mov    (%eax),%eax
  803e40:	85 c0                	test   %eax,%eax
  803e42:	74 0b                	je     803e4f <realloc_block_FF+0x41e>
  803e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e47:	8b 00                	mov    (%eax),%eax
  803e49:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e4c:	89 50 04             	mov    %edx,0x4(%eax)
  803e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e52:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e55:	89 10                	mov    %edx,(%eax)
  803e57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e5d:	89 50 04             	mov    %edx,0x4(%eax)
  803e60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e63:	8b 00                	mov    (%eax),%eax
  803e65:	85 c0                	test   %eax,%eax
  803e67:	75 08                	jne    803e71 <realloc_block_FF+0x440>
  803e69:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e6c:	a3 34 50 80 00       	mov    %eax,0x805034
  803e71:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e76:	40                   	inc    %eax
  803e77:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803e7c:	eb 36                	jmp    803eb4 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803e7e:	a1 38 50 80 00       	mov    0x805038,%eax
  803e83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e8a:	74 07                	je     803e93 <realloc_block_FF+0x462>
  803e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e8f:	8b 00                	mov    (%eax),%eax
  803e91:	eb 05                	jmp    803e98 <realloc_block_FF+0x467>
  803e93:	b8 00 00 00 00       	mov    $0x0,%eax
  803e98:	a3 38 50 80 00       	mov    %eax,0x805038
  803e9d:	a1 38 50 80 00       	mov    0x805038,%eax
  803ea2:	85 c0                	test   %eax,%eax
  803ea4:	0f 85 52 ff ff ff    	jne    803dfc <realloc_block_FF+0x3cb>
  803eaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803eae:	0f 85 48 ff ff ff    	jne    803dfc <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803eb4:	83 ec 04             	sub    $0x4,%esp
  803eb7:	6a 00                	push   $0x0
  803eb9:	ff 75 d8             	pushl  -0x28(%ebp)
  803ebc:	ff 75 d4             	pushl  -0x2c(%ebp)
  803ebf:	e8 7a eb ff ff       	call   802a3e <set_block_data>
  803ec4:	83 c4 10             	add    $0x10,%esp
				return va;
  803ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  803eca:	e9 7b 02 00 00       	jmp    80414a <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803ecf:	83 ec 0c             	sub    $0xc,%esp
  803ed2:	68 41 4e 80 00       	push   $0x804e41
  803ed7:	e8 26 cc ff ff       	call   800b02 <cprintf>
  803edc:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803edf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee2:	e9 63 02 00 00       	jmp    80414a <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803eea:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803eed:	0f 86 4d 02 00 00    	jbe    804140 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803ef3:	83 ec 0c             	sub    $0xc,%esp
  803ef6:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ef9:	e8 08 e8 ff ff       	call   802706 <is_free_block>
  803efe:	83 c4 10             	add    $0x10,%esp
  803f01:	84 c0                	test   %al,%al
  803f03:	0f 84 37 02 00 00    	je     804140 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f0c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803f0f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803f12:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f15:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803f18:	76 38                	jbe    803f52 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803f1a:	83 ec 0c             	sub    $0xc,%esp
  803f1d:	ff 75 08             	pushl  0x8(%ebp)
  803f20:	e8 0c fa ff ff       	call   803931 <free_block>
  803f25:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803f28:	83 ec 0c             	sub    $0xc,%esp
  803f2b:	ff 75 0c             	pushl  0xc(%ebp)
  803f2e:	e8 3a eb ff ff       	call   802a6d <alloc_block_FF>
  803f33:	83 c4 10             	add    $0x10,%esp
  803f36:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803f39:	83 ec 08             	sub    $0x8,%esp
  803f3c:	ff 75 c0             	pushl  -0x40(%ebp)
  803f3f:	ff 75 08             	pushl  0x8(%ebp)
  803f42:	e8 ab fa ff ff       	call   8039f2 <copy_data>
  803f47:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803f4a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803f4d:	e9 f8 01 00 00       	jmp    80414a <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803f52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f55:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803f58:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803f5b:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803f5f:	0f 87 a0 00 00 00    	ja     804005 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803f65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f69:	75 17                	jne    803f82 <realloc_block_FF+0x551>
  803f6b:	83 ec 04             	sub    $0x4,%esp
  803f6e:	68 33 4d 80 00       	push   $0x804d33
  803f73:	68 38 02 00 00       	push   $0x238
  803f78:	68 51 4d 80 00       	push   $0x804d51
  803f7d:	e8 c3 c8 ff ff       	call   800845 <_panic>
  803f82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f85:	8b 00                	mov    (%eax),%eax
  803f87:	85 c0                	test   %eax,%eax
  803f89:	74 10                	je     803f9b <realloc_block_FF+0x56a>
  803f8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f8e:	8b 00                	mov    (%eax),%eax
  803f90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f93:	8b 52 04             	mov    0x4(%edx),%edx
  803f96:	89 50 04             	mov    %edx,0x4(%eax)
  803f99:	eb 0b                	jmp    803fa6 <realloc_block_FF+0x575>
  803f9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f9e:	8b 40 04             	mov    0x4(%eax),%eax
  803fa1:	a3 34 50 80 00       	mov    %eax,0x805034
  803fa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa9:	8b 40 04             	mov    0x4(%eax),%eax
  803fac:	85 c0                	test   %eax,%eax
  803fae:	74 0f                	je     803fbf <realloc_block_FF+0x58e>
  803fb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fb3:	8b 40 04             	mov    0x4(%eax),%eax
  803fb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fb9:	8b 12                	mov    (%edx),%edx
  803fbb:	89 10                	mov    %edx,(%eax)
  803fbd:	eb 0a                	jmp    803fc9 <realloc_block_FF+0x598>
  803fbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc2:	8b 00                	mov    (%eax),%eax
  803fc4:	a3 30 50 80 00       	mov    %eax,0x805030
  803fc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fdc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803fe1:	48                   	dec    %eax
  803fe2:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803fe7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fed:	01 d0                	add    %edx,%eax
  803fef:	83 ec 04             	sub    $0x4,%esp
  803ff2:	6a 01                	push   $0x1
  803ff4:	50                   	push   %eax
  803ff5:	ff 75 08             	pushl  0x8(%ebp)
  803ff8:	e8 41 ea ff ff       	call   802a3e <set_block_data>
  803ffd:	83 c4 10             	add    $0x10,%esp
  804000:	e9 36 01 00 00       	jmp    80413b <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804005:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804008:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80400b:	01 d0                	add    %edx,%eax
  80400d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804010:	83 ec 04             	sub    $0x4,%esp
  804013:	6a 01                	push   $0x1
  804015:	ff 75 f0             	pushl  -0x10(%ebp)
  804018:	ff 75 08             	pushl  0x8(%ebp)
  80401b:	e8 1e ea ff ff       	call   802a3e <set_block_data>
  804020:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804023:	8b 45 08             	mov    0x8(%ebp),%eax
  804026:	83 e8 04             	sub    $0x4,%eax
  804029:	8b 00                	mov    (%eax),%eax
  80402b:	83 e0 fe             	and    $0xfffffffe,%eax
  80402e:	89 c2                	mov    %eax,%edx
  804030:	8b 45 08             	mov    0x8(%ebp),%eax
  804033:	01 d0                	add    %edx,%eax
  804035:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804038:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80403c:	74 06                	je     804044 <realloc_block_FF+0x613>
  80403e:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804042:	75 17                	jne    80405b <realloc_block_FF+0x62a>
  804044:	83 ec 04             	sub    $0x4,%esp
  804047:	68 c4 4d 80 00       	push   $0x804dc4
  80404c:	68 44 02 00 00       	push   $0x244
  804051:	68 51 4d 80 00       	push   $0x804d51
  804056:	e8 ea c7 ff ff       	call   800845 <_panic>
  80405b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80405e:	8b 10                	mov    (%eax),%edx
  804060:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804063:	89 10                	mov    %edx,(%eax)
  804065:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804068:	8b 00                	mov    (%eax),%eax
  80406a:	85 c0                	test   %eax,%eax
  80406c:	74 0b                	je     804079 <realloc_block_FF+0x648>
  80406e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804071:	8b 00                	mov    (%eax),%eax
  804073:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804076:	89 50 04             	mov    %edx,0x4(%eax)
  804079:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80407c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80407f:	89 10                	mov    %edx,(%eax)
  804081:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804084:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804087:	89 50 04             	mov    %edx,0x4(%eax)
  80408a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80408d:	8b 00                	mov    (%eax),%eax
  80408f:	85 c0                	test   %eax,%eax
  804091:	75 08                	jne    80409b <realloc_block_FF+0x66a>
  804093:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804096:	a3 34 50 80 00       	mov    %eax,0x805034
  80409b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8040a0:	40                   	inc    %eax
  8040a1:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8040a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040aa:	75 17                	jne    8040c3 <realloc_block_FF+0x692>
  8040ac:	83 ec 04             	sub    $0x4,%esp
  8040af:	68 33 4d 80 00       	push   $0x804d33
  8040b4:	68 45 02 00 00       	push   $0x245
  8040b9:	68 51 4d 80 00       	push   $0x804d51
  8040be:	e8 82 c7 ff ff       	call   800845 <_panic>
  8040c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040c6:	8b 00                	mov    (%eax),%eax
  8040c8:	85 c0                	test   %eax,%eax
  8040ca:	74 10                	je     8040dc <realloc_block_FF+0x6ab>
  8040cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040cf:	8b 00                	mov    (%eax),%eax
  8040d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040d4:	8b 52 04             	mov    0x4(%edx),%edx
  8040d7:	89 50 04             	mov    %edx,0x4(%eax)
  8040da:	eb 0b                	jmp    8040e7 <realloc_block_FF+0x6b6>
  8040dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040df:	8b 40 04             	mov    0x4(%eax),%eax
  8040e2:	a3 34 50 80 00       	mov    %eax,0x805034
  8040e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040ea:	8b 40 04             	mov    0x4(%eax),%eax
  8040ed:	85 c0                	test   %eax,%eax
  8040ef:	74 0f                	je     804100 <realloc_block_FF+0x6cf>
  8040f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f4:	8b 40 04             	mov    0x4(%eax),%eax
  8040f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040fa:	8b 12                	mov    (%edx),%edx
  8040fc:	89 10                	mov    %edx,(%eax)
  8040fe:	eb 0a                	jmp    80410a <realloc_block_FF+0x6d9>
  804100:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804103:	8b 00                	mov    (%eax),%eax
  804105:	a3 30 50 80 00       	mov    %eax,0x805030
  80410a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80410d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804116:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80411d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  804122:	48                   	dec    %eax
  804123:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  804128:	83 ec 04             	sub    $0x4,%esp
  80412b:	6a 00                	push   $0x0
  80412d:	ff 75 bc             	pushl  -0x44(%ebp)
  804130:	ff 75 b8             	pushl  -0x48(%ebp)
  804133:	e8 06 e9 ff ff       	call   802a3e <set_block_data>
  804138:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80413b:	8b 45 08             	mov    0x8(%ebp),%eax
  80413e:	eb 0a                	jmp    80414a <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804140:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804147:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80414a:	c9                   	leave  
  80414b:	c3                   	ret    

0080414c <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80414c:	55                   	push   %ebp
  80414d:	89 e5                	mov    %esp,%ebp
  80414f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804152:	83 ec 04             	sub    $0x4,%esp
  804155:	68 48 4e 80 00       	push   $0x804e48
  80415a:	68 58 02 00 00       	push   $0x258
  80415f:	68 51 4d 80 00       	push   $0x804d51
  804164:	e8 dc c6 ff ff       	call   800845 <_panic>

00804169 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804169:	55                   	push   %ebp
  80416a:	89 e5                	mov    %esp,%ebp
  80416c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80416f:	83 ec 04             	sub    $0x4,%esp
  804172:	68 70 4e 80 00       	push   $0x804e70
  804177:	68 61 02 00 00       	push   $0x261
  80417c:	68 51 4d 80 00       	push   $0x804d51
  804181:	e8 bf c6 ff ff       	call   800845 <_panic>
  804186:	66 90                	xchg   %ax,%ax

00804188 <__udivdi3>:
  804188:	55                   	push   %ebp
  804189:	57                   	push   %edi
  80418a:	56                   	push   %esi
  80418b:	53                   	push   %ebx
  80418c:	83 ec 1c             	sub    $0x1c,%esp
  80418f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804193:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804197:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80419b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80419f:	89 ca                	mov    %ecx,%edx
  8041a1:	89 f8                	mov    %edi,%eax
  8041a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8041a7:	85 f6                	test   %esi,%esi
  8041a9:	75 2d                	jne    8041d8 <__udivdi3+0x50>
  8041ab:	39 cf                	cmp    %ecx,%edi
  8041ad:	77 65                	ja     804214 <__udivdi3+0x8c>
  8041af:	89 fd                	mov    %edi,%ebp
  8041b1:	85 ff                	test   %edi,%edi
  8041b3:	75 0b                	jne    8041c0 <__udivdi3+0x38>
  8041b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8041ba:	31 d2                	xor    %edx,%edx
  8041bc:	f7 f7                	div    %edi
  8041be:	89 c5                	mov    %eax,%ebp
  8041c0:	31 d2                	xor    %edx,%edx
  8041c2:	89 c8                	mov    %ecx,%eax
  8041c4:	f7 f5                	div    %ebp
  8041c6:	89 c1                	mov    %eax,%ecx
  8041c8:	89 d8                	mov    %ebx,%eax
  8041ca:	f7 f5                	div    %ebp
  8041cc:	89 cf                	mov    %ecx,%edi
  8041ce:	89 fa                	mov    %edi,%edx
  8041d0:	83 c4 1c             	add    $0x1c,%esp
  8041d3:	5b                   	pop    %ebx
  8041d4:	5e                   	pop    %esi
  8041d5:	5f                   	pop    %edi
  8041d6:	5d                   	pop    %ebp
  8041d7:	c3                   	ret    
  8041d8:	39 ce                	cmp    %ecx,%esi
  8041da:	77 28                	ja     804204 <__udivdi3+0x7c>
  8041dc:	0f bd fe             	bsr    %esi,%edi
  8041df:	83 f7 1f             	xor    $0x1f,%edi
  8041e2:	75 40                	jne    804224 <__udivdi3+0x9c>
  8041e4:	39 ce                	cmp    %ecx,%esi
  8041e6:	72 0a                	jb     8041f2 <__udivdi3+0x6a>
  8041e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8041ec:	0f 87 9e 00 00 00    	ja     804290 <__udivdi3+0x108>
  8041f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8041f7:	89 fa                	mov    %edi,%edx
  8041f9:	83 c4 1c             	add    $0x1c,%esp
  8041fc:	5b                   	pop    %ebx
  8041fd:	5e                   	pop    %esi
  8041fe:	5f                   	pop    %edi
  8041ff:	5d                   	pop    %ebp
  804200:	c3                   	ret    
  804201:	8d 76 00             	lea    0x0(%esi),%esi
  804204:	31 ff                	xor    %edi,%edi
  804206:	31 c0                	xor    %eax,%eax
  804208:	89 fa                	mov    %edi,%edx
  80420a:	83 c4 1c             	add    $0x1c,%esp
  80420d:	5b                   	pop    %ebx
  80420e:	5e                   	pop    %esi
  80420f:	5f                   	pop    %edi
  804210:	5d                   	pop    %ebp
  804211:	c3                   	ret    
  804212:	66 90                	xchg   %ax,%ax
  804214:	89 d8                	mov    %ebx,%eax
  804216:	f7 f7                	div    %edi
  804218:	31 ff                	xor    %edi,%edi
  80421a:	89 fa                	mov    %edi,%edx
  80421c:	83 c4 1c             	add    $0x1c,%esp
  80421f:	5b                   	pop    %ebx
  804220:	5e                   	pop    %esi
  804221:	5f                   	pop    %edi
  804222:	5d                   	pop    %ebp
  804223:	c3                   	ret    
  804224:	bd 20 00 00 00       	mov    $0x20,%ebp
  804229:	89 eb                	mov    %ebp,%ebx
  80422b:	29 fb                	sub    %edi,%ebx
  80422d:	89 f9                	mov    %edi,%ecx
  80422f:	d3 e6                	shl    %cl,%esi
  804231:	89 c5                	mov    %eax,%ebp
  804233:	88 d9                	mov    %bl,%cl
  804235:	d3 ed                	shr    %cl,%ebp
  804237:	89 e9                	mov    %ebp,%ecx
  804239:	09 f1                	or     %esi,%ecx
  80423b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80423f:	89 f9                	mov    %edi,%ecx
  804241:	d3 e0                	shl    %cl,%eax
  804243:	89 c5                	mov    %eax,%ebp
  804245:	89 d6                	mov    %edx,%esi
  804247:	88 d9                	mov    %bl,%cl
  804249:	d3 ee                	shr    %cl,%esi
  80424b:	89 f9                	mov    %edi,%ecx
  80424d:	d3 e2                	shl    %cl,%edx
  80424f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804253:	88 d9                	mov    %bl,%cl
  804255:	d3 e8                	shr    %cl,%eax
  804257:	09 c2                	or     %eax,%edx
  804259:	89 d0                	mov    %edx,%eax
  80425b:	89 f2                	mov    %esi,%edx
  80425d:	f7 74 24 0c          	divl   0xc(%esp)
  804261:	89 d6                	mov    %edx,%esi
  804263:	89 c3                	mov    %eax,%ebx
  804265:	f7 e5                	mul    %ebp
  804267:	39 d6                	cmp    %edx,%esi
  804269:	72 19                	jb     804284 <__udivdi3+0xfc>
  80426b:	74 0b                	je     804278 <__udivdi3+0xf0>
  80426d:	89 d8                	mov    %ebx,%eax
  80426f:	31 ff                	xor    %edi,%edi
  804271:	e9 58 ff ff ff       	jmp    8041ce <__udivdi3+0x46>
  804276:	66 90                	xchg   %ax,%ax
  804278:	8b 54 24 08          	mov    0x8(%esp),%edx
  80427c:	89 f9                	mov    %edi,%ecx
  80427e:	d3 e2                	shl    %cl,%edx
  804280:	39 c2                	cmp    %eax,%edx
  804282:	73 e9                	jae    80426d <__udivdi3+0xe5>
  804284:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804287:	31 ff                	xor    %edi,%edi
  804289:	e9 40 ff ff ff       	jmp    8041ce <__udivdi3+0x46>
  80428e:	66 90                	xchg   %ax,%ax
  804290:	31 c0                	xor    %eax,%eax
  804292:	e9 37 ff ff ff       	jmp    8041ce <__udivdi3+0x46>
  804297:	90                   	nop

00804298 <__umoddi3>:
  804298:	55                   	push   %ebp
  804299:	57                   	push   %edi
  80429a:	56                   	push   %esi
  80429b:	53                   	push   %ebx
  80429c:	83 ec 1c             	sub    $0x1c,%esp
  80429f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8042a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8042a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8042af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8042b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8042b7:	89 f3                	mov    %esi,%ebx
  8042b9:	89 fa                	mov    %edi,%edx
  8042bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042bf:	89 34 24             	mov    %esi,(%esp)
  8042c2:	85 c0                	test   %eax,%eax
  8042c4:	75 1a                	jne    8042e0 <__umoddi3+0x48>
  8042c6:	39 f7                	cmp    %esi,%edi
  8042c8:	0f 86 a2 00 00 00    	jbe    804370 <__umoddi3+0xd8>
  8042ce:	89 c8                	mov    %ecx,%eax
  8042d0:	89 f2                	mov    %esi,%edx
  8042d2:	f7 f7                	div    %edi
  8042d4:	89 d0                	mov    %edx,%eax
  8042d6:	31 d2                	xor    %edx,%edx
  8042d8:	83 c4 1c             	add    $0x1c,%esp
  8042db:	5b                   	pop    %ebx
  8042dc:	5e                   	pop    %esi
  8042dd:	5f                   	pop    %edi
  8042de:	5d                   	pop    %ebp
  8042df:	c3                   	ret    
  8042e0:	39 f0                	cmp    %esi,%eax
  8042e2:	0f 87 ac 00 00 00    	ja     804394 <__umoddi3+0xfc>
  8042e8:	0f bd e8             	bsr    %eax,%ebp
  8042eb:	83 f5 1f             	xor    $0x1f,%ebp
  8042ee:	0f 84 ac 00 00 00    	je     8043a0 <__umoddi3+0x108>
  8042f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8042f9:	29 ef                	sub    %ebp,%edi
  8042fb:	89 fe                	mov    %edi,%esi
  8042fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804301:	89 e9                	mov    %ebp,%ecx
  804303:	d3 e0                	shl    %cl,%eax
  804305:	89 d7                	mov    %edx,%edi
  804307:	89 f1                	mov    %esi,%ecx
  804309:	d3 ef                	shr    %cl,%edi
  80430b:	09 c7                	or     %eax,%edi
  80430d:	89 e9                	mov    %ebp,%ecx
  80430f:	d3 e2                	shl    %cl,%edx
  804311:	89 14 24             	mov    %edx,(%esp)
  804314:	89 d8                	mov    %ebx,%eax
  804316:	d3 e0                	shl    %cl,%eax
  804318:	89 c2                	mov    %eax,%edx
  80431a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80431e:	d3 e0                	shl    %cl,%eax
  804320:	89 44 24 04          	mov    %eax,0x4(%esp)
  804324:	8b 44 24 08          	mov    0x8(%esp),%eax
  804328:	89 f1                	mov    %esi,%ecx
  80432a:	d3 e8                	shr    %cl,%eax
  80432c:	09 d0                	or     %edx,%eax
  80432e:	d3 eb                	shr    %cl,%ebx
  804330:	89 da                	mov    %ebx,%edx
  804332:	f7 f7                	div    %edi
  804334:	89 d3                	mov    %edx,%ebx
  804336:	f7 24 24             	mull   (%esp)
  804339:	89 c6                	mov    %eax,%esi
  80433b:	89 d1                	mov    %edx,%ecx
  80433d:	39 d3                	cmp    %edx,%ebx
  80433f:	0f 82 87 00 00 00    	jb     8043cc <__umoddi3+0x134>
  804345:	0f 84 91 00 00 00    	je     8043dc <__umoddi3+0x144>
  80434b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80434f:	29 f2                	sub    %esi,%edx
  804351:	19 cb                	sbb    %ecx,%ebx
  804353:	89 d8                	mov    %ebx,%eax
  804355:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804359:	d3 e0                	shl    %cl,%eax
  80435b:	89 e9                	mov    %ebp,%ecx
  80435d:	d3 ea                	shr    %cl,%edx
  80435f:	09 d0                	or     %edx,%eax
  804361:	89 e9                	mov    %ebp,%ecx
  804363:	d3 eb                	shr    %cl,%ebx
  804365:	89 da                	mov    %ebx,%edx
  804367:	83 c4 1c             	add    $0x1c,%esp
  80436a:	5b                   	pop    %ebx
  80436b:	5e                   	pop    %esi
  80436c:	5f                   	pop    %edi
  80436d:	5d                   	pop    %ebp
  80436e:	c3                   	ret    
  80436f:	90                   	nop
  804370:	89 fd                	mov    %edi,%ebp
  804372:	85 ff                	test   %edi,%edi
  804374:	75 0b                	jne    804381 <__umoddi3+0xe9>
  804376:	b8 01 00 00 00       	mov    $0x1,%eax
  80437b:	31 d2                	xor    %edx,%edx
  80437d:	f7 f7                	div    %edi
  80437f:	89 c5                	mov    %eax,%ebp
  804381:	89 f0                	mov    %esi,%eax
  804383:	31 d2                	xor    %edx,%edx
  804385:	f7 f5                	div    %ebp
  804387:	89 c8                	mov    %ecx,%eax
  804389:	f7 f5                	div    %ebp
  80438b:	89 d0                	mov    %edx,%eax
  80438d:	e9 44 ff ff ff       	jmp    8042d6 <__umoddi3+0x3e>
  804392:	66 90                	xchg   %ax,%ax
  804394:	89 c8                	mov    %ecx,%eax
  804396:	89 f2                	mov    %esi,%edx
  804398:	83 c4 1c             	add    $0x1c,%esp
  80439b:	5b                   	pop    %ebx
  80439c:	5e                   	pop    %esi
  80439d:	5f                   	pop    %edi
  80439e:	5d                   	pop    %ebp
  80439f:	c3                   	ret    
  8043a0:	3b 04 24             	cmp    (%esp),%eax
  8043a3:	72 06                	jb     8043ab <__umoddi3+0x113>
  8043a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8043a9:	77 0f                	ja     8043ba <__umoddi3+0x122>
  8043ab:	89 f2                	mov    %esi,%edx
  8043ad:	29 f9                	sub    %edi,%ecx
  8043af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8043b3:	89 14 24             	mov    %edx,(%esp)
  8043b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8043ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8043be:	8b 14 24             	mov    (%esp),%edx
  8043c1:	83 c4 1c             	add    $0x1c,%esp
  8043c4:	5b                   	pop    %ebx
  8043c5:	5e                   	pop    %esi
  8043c6:	5f                   	pop    %edi
  8043c7:	5d                   	pop    %ebp
  8043c8:	c3                   	ret    
  8043c9:	8d 76 00             	lea    0x0(%esi),%esi
  8043cc:	2b 04 24             	sub    (%esp),%eax
  8043cf:	19 fa                	sbb    %edi,%edx
  8043d1:	89 d1                	mov    %edx,%ecx
  8043d3:	89 c6                	mov    %eax,%esi
  8043d5:	e9 71 ff ff ff       	jmp    80434b <__umoddi3+0xb3>
  8043da:	66 90                	xchg   %ax,%ax
  8043dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8043e0:	72 ea                	jb     8043cc <__umoddi3+0x134>
  8043e2:	89 d9                	mov    %ebx,%ecx
  8043e4:	e9 62 ff ff ff       	jmp    80434b <__umoddi3+0xb3>
