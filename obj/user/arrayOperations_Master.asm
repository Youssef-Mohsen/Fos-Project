
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
  800041:	e8 93 1f 00 00       	call   801fd9 <sys_lock_cons>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 42 80 00       	push   $0x8042a0
  80004e:	e8 af 0a 00 00       	call   800b02 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 42 80 00       	push   $0x8042a2
  80005e:	e8 9f 0a 00 00       	call   800b02 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 c0 42 80 00       	push   $0x8042c0
  80006e:	e8 8f 0a 00 00       	call   800b02 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 42 80 00       	push   $0x8042a2
  80007e:	e8 7f 0a 00 00       	call   800b02 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 42 80 00       	push   $0x8042a0
  80008e:	e8 6f 0a 00 00       	call   800b02 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 e0 42 80 00       	push   $0x8042e0
  8000a2:	e8 ef 10 00 00       	call   801196 <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 ff 42 80 00       	push   $0x8042ff
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
  8000ef:	68 07 43 80 00       	push   $0x804307
  8000f4:	e8 de 1c 00 00       	call   801dd7 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 0c 43 80 00       	push   $0x80430c
  800107:	e8 f6 09 00 00       	call   800b02 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 2e 43 80 00       	push   $0x80432e
  800117:	e8 e6 09 00 00       	call   800b02 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 3c 43 80 00       	push   $0x80433c
  800127:	e8 d6 09 00 00       	call   800b02 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 4b 43 80 00       	push   $0x80434b
  800137:	e8 c6 09 00 00       	call   800b02 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 5b 43 80 00       	push   $0x80435b
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
  800186:	e8 68 1e 00 00       	call   801ff3 <sys_unlock_cons>
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
  8001f6:	68 64 43 80 00       	push   $0x804364
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
  800235:	68 72 43 80 00       	push   $0x804372
  80023a:	e8 a8 1f 00 00       	call   8021e7 <sys_create_env>
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
  80026b:	68 7b 43 80 00       	push   $0x80437b
  800270:	e8 72 1f 00 00       	call   8021e7 <sys_create_env>
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
  8002a1:	68 84 43 80 00       	push   $0x804384
  8002a6:	e8 3c 1f 00 00       	call   8021e7 <sys_create_env>
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
  8002c6:	68 90 43 80 00       	push   $0x804390
  8002cb:	6a 4e                	push   $0x4e
  8002cd:	68 a5 43 80 00       	push   $0x8043a5
  8002d2:	e8 6e 05 00 00       	call   800845 <_panic>

	sys_run_env(envIdQuickSort);
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	ff 75 dc             	pushl  -0x24(%ebp)
  8002dd:	e8 23 1f 00 00       	call   802205 <sys_run_env>
  8002e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002eb:	e8 15 1f 00 00       	call   802205 <sys_run_env>
  8002f0:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f9:	e8 07 1f 00 00       	call   802205 <sys_run_env>
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
  800340:	68 c3 43 80 00       	push   $0x8043c3
  800345:	ff 75 dc             	pushl  -0x24(%ebp)
  800348:	e8 09 1b 00 00       	call   801e56 <sget>
  80034d:	83 c4 10             	add    $0x10,%esp
  800350:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  800353:	83 ec 08             	sub    $0x8,%esp
  800356:	68 d2 43 80 00       	push   $0x8043d2
  80035b:	ff 75 d8             	pushl  -0x28(%ebp)
  80035e:	e8 f3 1a 00 00       	call   801e56 <sget>
  800363:	83 c4 10             	add    $0x10,%esp
  800366:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800369:	83 ec 08             	sub    $0x8,%esp
  80036c:	68 e1 43 80 00       	push   $0x8043e1
  800371:	ff 75 d4             	pushl  -0x2c(%ebp)
  800374:	e8 dd 1a 00 00       	call   801e56 <sget>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	68 e6 43 80 00       	push   $0x8043e6
  800387:	ff 75 d4             	pushl  -0x2c(%ebp)
  80038a:	e8 c7 1a 00 00       	call   801e56 <sget>
  80038f:	83 c4 10             	add    $0x10,%esp
  800392:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  800395:	83 ec 08             	sub    $0x8,%esp
  800398:	68 ea 43 80 00       	push   $0x8043ea
  80039d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003a0:	e8 b1 1a 00 00       	call   801e56 <sget>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003ab:	83 ec 08             	sub    $0x8,%esp
  8003ae:	68 ee 43 80 00       	push   $0x8043ee
  8003b3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003b6:	e8 9b 1a 00 00       	call   801e56 <sget>
  8003bb:	83 c4 10             	add    $0x10,%esp
  8003be:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	68 f2 43 80 00       	push   $0x8043f2
  8003c9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003cc:	e8 85 1a 00 00       	call   801e56 <sget>
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
  8003f4:	68 f8 43 80 00       	push   $0x8043f8
  8003f9:	6a 69                	push   $0x69
  8003fb:	68 a5 43 80 00       	push   $0x8043a5
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
  800422:	68 20 44 80 00       	push   $0x804420
  800427:	6a 6b                	push   $0x6b
  800429:	68 a5 43 80 00       	push   $0x8043a5
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
  8004d5:	68 48 44 80 00       	push   $0x804448
  8004da:	6a 78                	push   $0x78
  8004dc:	68 a5 43 80 00       	push   $0x8043a5
  8004e1:	e8 5f 03 00 00       	call   800845 <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004e6:	83 ec 0c             	sub    $0xc,%esp
  8004e9:	68 78 44 80 00       	push   $0x804478
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
  8006de:	e8 41 1a 00 00       	call   802124 <sys_cputc>
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
  8006ef:	e8 cc 18 00 00       	call   801fc0 <sys_cgetc>
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
  80070c:	e8 44 1b 00 00       	call   802255 <sys_getenvindex>
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
  80077a:	e8 5a 18 00 00       	call   801fd9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80077f:	83 ec 0c             	sub    $0xc,%esp
  800782:	68 f4 44 80 00       	push   $0x8044f4
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
  8007aa:	68 1c 45 80 00       	push   $0x80451c
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
  8007db:	68 44 45 80 00       	push   $0x804544
  8007e0:	e8 1d 03 00 00       	call   800b02 <cprintf>
  8007e5:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8007ed:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	50                   	push   %eax
  8007f7:	68 9c 45 80 00       	push   $0x80459c
  8007fc:	e8 01 03 00 00       	call   800b02 <cprintf>
  800801:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800804:	83 ec 0c             	sub    $0xc,%esp
  800807:	68 f4 44 80 00       	push   $0x8044f4
  80080c:	e8 f1 02 00 00       	call   800b02 <cprintf>
  800811:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800814:	e8 da 17 00 00       	call   801ff3 <sys_unlock_cons>
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
  80082c:	e8 f0 19 00 00       	call   802221 <sys_destroy_env>
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
  80083d:	e8 45 1a 00 00       	call   802287 <sys_exit_env>
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
  800866:	68 b0 45 80 00       	push   $0x8045b0
  80086b:	e8 92 02 00 00       	call   800b02 <cprintf>
  800870:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800873:	a1 00 50 80 00       	mov    0x805000,%eax
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	50                   	push   %eax
  80087f:	68 b5 45 80 00       	push   $0x8045b5
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
  8008a3:	68 d1 45 80 00       	push   $0x8045d1
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
  8008d2:	68 d4 45 80 00       	push   $0x8045d4
  8008d7:	6a 26                	push   $0x26
  8008d9:	68 20 46 80 00       	push   $0x804620
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
  8009a7:	68 2c 46 80 00       	push   $0x80462c
  8009ac:	6a 3a                	push   $0x3a
  8009ae:	68 20 46 80 00       	push   $0x804620
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
  800a1a:	68 80 46 80 00       	push   $0x804680
  800a1f:	6a 44                	push   $0x44
  800a21:	68 20 46 80 00       	push   $0x804620
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
  800a74:	e8 1e 15 00 00       	call   801f97 <sys_cputs>
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
  800aeb:	e8 a7 14 00 00       	call   801f97 <sys_cputs>
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
  800b35:	e8 9f 14 00 00       	call   801fd9 <sys_lock_cons>
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
  800b55:	e8 99 14 00 00       	call   801ff3 <sys_unlock_cons>
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
  800b9f:	e8 8c 34 00 00       	call   804030 <__udivdi3>
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
  800bef:	e8 4c 35 00 00       	call   804140 <__umoddi3>
  800bf4:	83 c4 10             	add    $0x10,%esp
  800bf7:	05 f4 48 80 00       	add    $0x8048f4,%eax
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
  800d4a:	8b 04 85 18 49 80 00 	mov    0x804918(,%eax,4),%eax
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
  800e2b:	8b 34 9d 60 47 80 00 	mov    0x804760(,%ebx,4),%esi
  800e32:	85 f6                	test   %esi,%esi
  800e34:	75 19                	jne    800e4f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e36:	53                   	push   %ebx
  800e37:	68 05 49 80 00       	push   $0x804905
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
  800e50:	68 0e 49 80 00       	push   $0x80490e
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
  800e7d:	be 11 49 80 00       	mov    $0x804911,%esi
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
  8011a8:	68 88 4a 80 00       	push   $0x804a88
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
  8011ea:	68 8b 4a 80 00       	push   $0x804a8b
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
  80129b:	e8 39 0d 00 00       	call   801fd9 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012a4:	74 13                	je     8012b9 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012a6:	83 ec 08             	sub    $0x8,%esp
  8012a9:	ff 75 08             	pushl  0x8(%ebp)
  8012ac:	68 88 4a 80 00       	push   $0x804a88
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
  8012ee:	68 8b 4a 80 00       	push   $0x804a8b
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
  801396:	e8 58 0c 00 00       	call   801ff3 <sys_unlock_cons>
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
  801a90:	68 9c 4a 80 00       	push   $0x804a9c
  801a95:	68 3f 01 00 00       	push   $0x13f
  801a9a:	68 be 4a 80 00       	push   $0x804abe
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
  801ab0:	e8 8d 0a 00 00       	call   802542 <sys_sbrk>
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
  801b2b:	e8 96 08 00 00       	call   8023c6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b30:	85 c0                	test   %eax,%eax
  801b32:	74 16                	je     801b4a <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801b34:	83 ec 0c             	sub    $0xc,%esp
  801b37:	ff 75 08             	pushl  0x8(%ebp)
  801b3a:	e8 d6 0d 00 00       	call   802915 <alloc_block_FF>
  801b3f:	83 c4 10             	add    $0x10,%esp
  801b42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b45:	e9 8a 01 00 00       	jmp    801cd4 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b4a:	e8 a8 08 00 00       	call   8023f7 <sys_isUHeapPlacementStrategyBESTFIT>
  801b4f:	85 c0                	test   %eax,%eax
  801b51:	0f 84 7d 01 00 00    	je     801cd4 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801b57:	83 ec 0c             	sub    $0xc,%esp
  801b5a:	ff 75 08             	pushl  0x8(%ebp)
  801b5d:	e8 6f 12 00 00       	call   802dd1 <alloc_block_BF>
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
  801cc3:	e8 b1 08 00 00       	call   802579 <sys_allocate_user_mem>
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
  801d0b:	e8 85 08 00 00       	call   802595 <get_block_size>
  801d10:	83 c4 10             	add    $0x10,%esp
  801d13:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d16:	83 ec 0c             	sub    $0xc,%esp
  801d19:	ff 75 08             	pushl  0x8(%ebp)
  801d1c:	e8 b8 1a 00 00       	call   8037d9 <free_block>
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
  801db3:	e8 a5 07 00 00       	call   80255d <sys_free_user_mem>
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
  801dc1:	68 cc 4a 80 00       	push   $0x804acc
  801dc6:	68 84 00 00 00       	push   $0x84
  801dcb:	68 f6 4a 80 00       	push   $0x804af6
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
  801dee:	eb 64                	jmp    801e54 <smalloc+0x7d>
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
  801e23:	eb 2f                	jmp    801e54 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e25:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e29:	ff 75 ec             	pushl  -0x14(%ebp)
  801e2c:	50                   	push   %eax
  801e2d:	ff 75 0c             	pushl  0xc(%ebp)
  801e30:	ff 75 08             	pushl  0x8(%ebp)
  801e33:	e8 2c 03 00 00       	call   802164 <sys_createSharedObject>
  801e38:	83 c4 10             	add    $0x10,%esp
  801e3b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e3e:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e42:	74 06                	je     801e4a <smalloc+0x73>
  801e44:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e48:	75 07                	jne    801e51 <smalloc+0x7a>
  801e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4f:	eb 03                	jmp    801e54 <smalloc+0x7d>
	 return ptr;
  801e51:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e5c:	83 ec 08             	sub    $0x8,%esp
  801e5f:	ff 75 0c             	pushl  0xc(%ebp)
  801e62:	ff 75 08             	pushl  0x8(%ebp)
  801e65:	e8 24 03 00 00       	call   80218e <sys_getSizeOfSharedObject>
  801e6a:	83 c4 10             	add    $0x10,%esp
  801e6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801e70:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801e74:	75 07                	jne    801e7d <sget+0x27>
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7b:	eb 5c                	jmp    801ed9 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e83:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801e8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e90:	39 d0                	cmp    %edx,%eax
  801e92:	7d 02                	jge    801e96 <sget+0x40>
  801e94:	89 d0                	mov    %edx,%eax
  801e96:	83 ec 0c             	sub    $0xc,%esp
  801e99:	50                   	push   %eax
  801e9a:	e8 1b fc ff ff       	call   801aba <malloc>
  801e9f:	83 c4 10             	add    $0x10,%esp
  801ea2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801ea5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ea9:	75 07                	jne    801eb2 <sget+0x5c>
  801eab:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb0:	eb 27                	jmp    801ed9 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801eb2:	83 ec 04             	sub    $0x4,%esp
  801eb5:	ff 75 e8             	pushl  -0x18(%ebp)
  801eb8:	ff 75 0c             	pushl  0xc(%ebp)
  801ebb:	ff 75 08             	pushl  0x8(%ebp)
  801ebe:	e8 e8 02 00 00       	call   8021ab <sys_getSharedObject>
  801ec3:	83 c4 10             	add    $0x10,%esp
  801ec6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801ec9:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801ecd:	75 07                	jne    801ed6 <sget+0x80>
  801ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed4:	eb 03                	jmp    801ed9 <sget+0x83>
	return ptr;
  801ed6:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ee1:	83 ec 04             	sub    $0x4,%esp
  801ee4:	68 04 4b 80 00       	push   $0x804b04
  801ee9:	68 c1 00 00 00       	push   $0xc1
  801eee:	68 f6 4a 80 00       	push   $0x804af6
  801ef3:	e8 4d e9 ff ff       	call   800845 <_panic>

00801ef8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801efe:	83 ec 04             	sub    $0x4,%esp
  801f01:	68 28 4b 80 00       	push   $0x804b28
  801f06:	68 d8 00 00 00       	push   $0xd8
  801f0b:	68 f6 4a 80 00       	push   $0x804af6
  801f10:	e8 30 e9 ff ff       	call   800845 <_panic>

00801f15 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f1b:	83 ec 04             	sub    $0x4,%esp
  801f1e:	68 4e 4b 80 00       	push   $0x804b4e
  801f23:	68 e4 00 00 00       	push   $0xe4
  801f28:	68 f6 4a 80 00       	push   $0x804af6
  801f2d:	e8 13 e9 ff ff       	call   800845 <_panic>

00801f32 <shrink>:

}
void shrink(uint32 newSize)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f38:	83 ec 04             	sub    $0x4,%esp
  801f3b:	68 4e 4b 80 00       	push   $0x804b4e
  801f40:	68 e9 00 00 00       	push   $0xe9
  801f45:	68 f6 4a 80 00       	push   $0x804af6
  801f4a:	e8 f6 e8 ff ff       	call   800845 <_panic>

00801f4f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f55:	83 ec 04             	sub    $0x4,%esp
  801f58:	68 4e 4b 80 00       	push   $0x804b4e
  801f5d:	68 ee 00 00 00       	push   $0xee
  801f62:	68 f6 4a 80 00       	push   $0x804af6
  801f67:	e8 d9 e8 ff ff       	call   800845 <_panic>

00801f6c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	57                   	push   %edi
  801f70:	56                   	push   %esi
  801f71:	53                   	push   %ebx
  801f72:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f7e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f81:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f84:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f87:	cd 30                	int    $0x30
  801f89:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	5b                   	pop    %ebx
  801f93:	5e                   	pop    %esi
  801f94:	5f                   	pop    %edi
  801f95:	5d                   	pop    %ebp
  801f96:	c3                   	ret    

00801f97 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	83 ec 04             	sub    $0x4,%esp
  801f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801fa3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	52                   	push   %edx
  801faf:	ff 75 0c             	pushl  0xc(%ebp)
  801fb2:	50                   	push   %eax
  801fb3:	6a 00                	push   $0x0
  801fb5:	e8 b2 ff ff ff       	call   801f6c <syscall>
  801fba:	83 c4 18             	add    $0x18,%esp
}
  801fbd:	90                   	nop
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <sys_cgetc>:

int
sys_cgetc(void)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 02                	push   $0x2
  801fcf:	e8 98 ff ff ff       	call   801f6c <syscall>
  801fd4:	83 c4 18             	add    $0x18,%esp
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 03                	push   $0x3
  801fe8:	e8 7f ff ff ff       	call   801f6c <syscall>
  801fed:	83 c4 18             	add    $0x18,%esp
}
  801ff0:	90                   	nop
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 04                	push   $0x4
  802002:	e8 65 ff ff ff       	call   801f6c <syscall>
  802007:	83 c4 18             	add    $0x18,%esp
}
  80200a:	90                   	nop
  80200b:	c9                   	leave  
  80200c:	c3                   	ret    

0080200d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802010:	8b 55 0c             	mov    0xc(%ebp),%edx
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	52                   	push   %edx
  80201d:	50                   	push   %eax
  80201e:	6a 08                	push   $0x8
  802020:	e8 47 ff ff ff       	call   801f6c <syscall>
  802025:	83 c4 18             	add    $0x18,%esp
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	56                   	push   %esi
  80202e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80202f:	8b 75 18             	mov    0x18(%ebp),%esi
  802032:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802035:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802038:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	56                   	push   %esi
  80203f:	53                   	push   %ebx
  802040:	51                   	push   %ecx
  802041:	52                   	push   %edx
  802042:	50                   	push   %eax
  802043:	6a 09                	push   $0x9
  802045:	e8 22 ff ff ff       	call   801f6c <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
}
  80204d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802050:	5b                   	pop    %ebx
  802051:	5e                   	pop    %esi
  802052:	5d                   	pop    %ebp
  802053:	c3                   	ret    

00802054 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802057:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205a:	8b 45 08             	mov    0x8(%ebp),%eax
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	52                   	push   %edx
  802064:	50                   	push   %eax
  802065:	6a 0a                	push   $0xa
  802067:	e8 00 ff ff ff       	call   801f6c <syscall>
  80206c:	83 c4 18             	add    $0x18,%esp
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	ff 75 0c             	pushl  0xc(%ebp)
  80207d:	ff 75 08             	pushl  0x8(%ebp)
  802080:	6a 0b                	push   $0xb
  802082:	e8 e5 fe ff ff       	call   801f6c <syscall>
  802087:	83 c4 18             	add    $0x18,%esp
}
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 0c                	push   $0xc
  80209b:	e8 cc fe ff ff       	call   801f6c <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 0d                	push   $0xd
  8020b4:	e8 b3 fe ff ff       	call   801f6c <syscall>
  8020b9:	83 c4 18             	add    $0x18,%esp
}
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 0e                	push   $0xe
  8020cd:	e8 9a fe ff ff       	call   801f6c <syscall>
  8020d2:	83 c4 18             	add    $0x18,%esp
}
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 0f                	push   $0xf
  8020e6:	e8 81 fe ff ff       	call   801f6c <syscall>
  8020eb:	83 c4 18             	add    $0x18,%esp
}
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	ff 75 08             	pushl  0x8(%ebp)
  8020fe:	6a 10                	push   $0x10
  802100:	e8 67 fe ff ff       	call   801f6c <syscall>
  802105:	83 c4 18             	add    $0x18,%esp
}
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 11                	push   $0x11
  802119:	e8 4e fe ff ff       	call   801f6c <syscall>
  80211e:	83 c4 18             	add    $0x18,%esp
}
  802121:	90                   	nop
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <sys_cputc>:

void
sys_cputc(const char c)
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	83 ec 04             	sub    $0x4,%esp
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802130:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	50                   	push   %eax
  80213d:	6a 01                	push   $0x1
  80213f:	e8 28 fe ff ff       	call   801f6c <syscall>
  802144:	83 c4 18             	add    $0x18,%esp
}
  802147:	90                   	nop
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 14                	push   $0x14
  802159:	e8 0e fe ff ff       	call   801f6c <syscall>
  80215e:	83 c4 18             	add    $0x18,%esp
}
  802161:	90                   	nop
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
  802167:	83 ec 04             	sub    $0x4,%esp
  80216a:	8b 45 10             	mov    0x10(%ebp),%eax
  80216d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802170:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802173:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	6a 00                	push   $0x0
  80217c:	51                   	push   %ecx
  80217d:	52                   	push   %edx
  80217e:	ff 75 0c             	pushl  0xc(%ebp)
  802181:	50                   	push   %eax
  802182:	6a 15                	push   $0x15
  802184:	e8 e3 fd ff ff       	call   801f6c <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802191:	8b 55 0c             	mov    0xc(%ebp),%edx
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	52                   	push   %edx
  80219e:	50                   	push   %eax
  80219f:	6a 16                	push   $0x16
  8021a1:	e8 c6 fd ff ff       	call   801f6c <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	51                   	push   %ecx
  8021bc:	52                   	push   %edx
  8021bd:	50                   	push   %eax
  8021be:	6a 17                	push   $0x17
  8021c0:	e8 a7 fd ff ff       	call   801f6c <syscall>
  8021c5:	83 c4 18             	add    $0x18,%esp
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	52                   	push   %edx
  8021da:	50                   	push   %eax
  8021db:	6a 18                	push   $0x18
  8021dd:	e8 8a fd ff ff       	call   801f6c <syscall>
  8021e2:	83 c4 18             	add    $0x18,%esp
}
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	6a 00                	push   $0x0
  8021ef:	ff 75 14             	pushl  0x14(%ebp)
  8021f2:	ff 75 10             	pushl  0x10(%ebp)
  8021f5:	ff 75 0c             	pushl  0xc(%ebp)
  8021f8:	50                   	push   %eax
  8021f9:	6a 19                	push   $0x19
  8021fb:	e8 6c fd ff ff       	call   801f6c <syscall>
  802200:	83 c4 18             	add    $0x18,%esp
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	50                   	push   %eax
  802214:	6a 1a                	push   $0x1a
  802216:	e8 51 fd ff ff       	call   801f6c <syscall>
  80221b:	83 c4 18             	add    $0x18,%esp
}
  80221e:	90                   	nop
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	50                   	push   %eax
  802230:	6a 1b                	push   $0x1b
  802232:	e8 35 fd ff ff       	call   801f6c <syscall>
  802237:	83 c4 18             	add    $0x18,%esp
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 05                	push   $0x5
  80224b:	e8 1c fd ff ff       	call   801f6c <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
}
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 06                	push   $0x6
  802264:	e8 03 fd ff ff       	call   801f6c <syscall>
  802269:	83 c4 18             	add    $0x18,%esp
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 07                	push   $0x7
  80227d:	e8 ea fc ff ff       	call   801f6c <syscall>
  802282:	83 c4 18             	add    $0x18,%esp
}
  802285:	c9                   	leave  
  802286:	c3                   	ret    

00802287 <sys_exit_env>:


void sys_exit_env(void)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 1c                	push   $0x1c
  802296:	e8 d1 fc ff ff       	call   801f6c <syscall>
  80229b:	83 c4 18             	add    $0x18,%esp
}
  80229e:	90                   	nop
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022a7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022aa:	8d 50 04             	lea    0x4(%eax),%edx
  8022ad:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	52                   	push   %edx
  8022b7:	50                   	push   %eax
  8022b8:	6a 1d                	push   $0x1d
  8022ba:	e8 ad fc ff ff       	call   801f6c <syscall>
  8022bf:	83 c4 18             	add    $0x18,%esp
	return result;
  8022c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022cb:	89 01                	mov    %eax,(%ecx)
  8022cd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d3:	c9                   	leave  
  8022d4:	c2 04 00             	ret    $0x4

008022d7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	ff 75 10             	pushl  0x10(%ebp)
  8022e1:	ff 75 0c             	pushl  0xc(%ebp)
  8022e4:	ff 75 08             	pushl  0x8(%ebp)
  8022e7:	6a 13                	push   $0x13
  8022e9:	e8 7e fc ff ff       	call   801f6c <syscall>
  8022ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f1:	90                   	nop
}
  8022f2:	c9                   	leave  
  8022f3:	c3                   	ret    

008022f4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 1e                	push   $0x1e
  802303:	e8 64 fc ff ff       	call   801f6c <syscall>
  802308:	83 c4 18             	add    $0x18,%esp
}
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	83 ec 04             	sub    $0x4,%esp
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802319:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	50                   	push   %eax
  802326:	6a 1f                	push   $0x1f
  802328:	e8 3f fc ff ff       	call   801f6c <syscall>
  80232d:	83 c4 18             	add    $0x18,%esp
	return ;
  802330:	90                   	nop
}
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <rsttst>:
void rsttst()
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 21                	push   $0x21
  802342:	e8 25 fc ff ff       	call   801f6c <syscall>
  802347:	83 c4 18             	add    $0x18,%esp
	return ;
  80234a:	90                   	nop
}
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
  802350:	83 ec 04             	sub    $0x4,%esp
  802353:	8b 45 14             	mov    0x14(%ebp),%eax
  802356:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802359:	8b 55 18             	mov    0x18(%ebp),%edx
  80235c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802360:	52                   	push   %edx
  802361:	50                   	push   %eax
  802362:	ff 75 10             	pushl  0x10(%ebp)
  802365:	ff 75 0c             	pushl  0xc(%ebp)
  802368:	ff 75 08             	pushl  0x8(%ebp)
  80236b:	6a 20                	push   $0x20
  80236d:	e8 fa fb ff ff       	call   801f6c <syscall>
  802372:	83 c4 18             	add    $0x18,%esp
	return ;
  802375:	90                   	nop
}
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <chktst>:
void chktst(uint32 n)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	ff 75 08             	pushl  0x8(%ebp)
  802386:	6a 22                	push   $0x22
  802388:	e8 df fb ff ff       	call   801f6c <syscall>
  80238d:	83 c4 18             	add    $0x18,%esp
	return ;
  802390:	90                   	nop
}
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <inctst>:

void inctst()
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 23                	push   $0x23
  8023a2:	e8 c5 fb ff ff       	call   801f6c <syscall>
  8023a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8023aa:	90                   	nop
}
  8023ab:	c9                   	leave  
  8023ac:	c3                   	ret    

008023ad <gettst>:
uint32 gettst()
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 24                	push   $0x24
  8023bc:	e8 ab fb ff ff       	call   801f6c <syscall>
  8023c1:	83 c4 18             	add    $0x18,%esp
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
  8023c9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 25                	push   $0x25
  8023d8:	e8 8f fb ff ff       	call   801f6c <syscall>
  8023dd:	83 c4 18             	add    $0x18,%esp
  8023e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023e3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023e7:	75 07                	jne    8023f0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ee:	eb 05                	jmp    8023f5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f5:	c9                   	leave  
  8023f6:	c3                   	ret    

008023f7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023f7:	55                   	push   %ebp
  8023f8:	89 e5                	mov    %esp,%ebp
  8023fa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 25                	push   $0x25
  802409:	e8 5e fb ff ff       	call   801f6c <syscall>
  80240e:	83 c4 18             	add    $0x18,%esp
  802411:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802414:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802418:	75 07                	jne    802421 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80241a:	b8 01 00 00 00       	mov    $0x1,%eax
  80241f:	eb 05                	jmp    802426 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802421:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 25                	push   $0x25
  80243a:	e8 2d fb ff ff       	call   801f6c <syscall>
  80243f:	83 c4 18             	add    $0x18,%esp
  802442:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802445:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802449:	75 07                	jne    802452 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80244b:	b8 01 00 00 00       	mov    $0x1,%eax
  802450:	eb 05                	jmp    802457 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802452:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 25                	push   $0x25
  80246b:	e8 fc fa ff ff       	call   801f6c <syscall>
  802470:	83 c4 18             	add    $0x18,%esp
  802473:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802476:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80247a:	75 07                	jne    802483 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80247c:	b8 01 00 00 00       	mov    $0x1,%eax
  802481:	eb 05                	jmp    802488 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802483:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	ff 75 08             	pushl  0x8(%ebp)
  802498:	6a 26                	push   $0x26
  80249a:	e8 cd fa ff ff       	call   801f6c <syscall>
  80249f:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a2:	90                   	nop
}
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    

008024a5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
  8024a8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	6a 00                	push   $0x0
  8024b7:	53                   	push   %ebx
  8024b8:	51                   	push   %ecx
  8024b9:	52                   	push   %edx
  8024ba:	50                   	push   %eax
  8024bb:	6a 27                	push   $0x27
  8024bd:	e8 aa fa ff ff       	call   801f6c <syscall>
  8024c2:	83 c4 18             	add    $0x18,%esp
}
  8024c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024c8:	c9                   	leave  
  8024c9:	c3                   	ret    

008024ca <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	52                   	push   %edx
  8024da:	50                   	push   %eax
  8024db:	6a 28                	push   $0x28
  8024dd:	e8 8a fa ff ff       	call   801f6c <syscall>
  8024e2:	83 c4 18             	add    $0x18,%esp
}
  8024e5:	c9                   	leave  
  8024e6:	c3                   	ret    

008024e7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8024e7:	55                   	push   %ebp
  8024e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8024ea:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f3:	6a 00                	push   $0x0
  8024f5:	51                   	push   %ecx
  8024f6:	ff 75 10             	pushl  0x10(%ebp)
  8024f9:	52                   	push   %edx
  8024fa:	50                   	push   %eax
  8024fb:	6a 29                	push   $0x29
  8024fd:	e8 6a fa ff ff       	call   801f6c <syscall>
  802502:	83 c4 18             	add    $0x18,%esp
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	ff 75 10             	pushl  0x10(%ebp)
  802511:	ff 75 0c             	pushl  0xc(%ebp)
  802514:	ff 75 08             	pushl  0x8(%ebp)
  802517:	6a 12                	push   $0x12
  802519:	e8 4e fa ff ff       	call   801f6c <syscall>
  80251e:	83 c4 18             	add    $0x18,%esp
	return ;
  802521:	90                   	nop
}
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802527:	8b 55 0c             	mov    0xc(%ebp),%edx
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	52                   	push   %edx
  802534:	50                   	push   %eax
  802535:	6a 2a                	push   $0x2a
  802537:	e8 30 fa ff ff       	call   801f6c <syscall>
  80253c:	83 c4 18             	add    $0x18,%esp
	return;
  80253f:	90                   	nop
}
  802540:	c9                   	leave  
  802541:	c3                   	ret    

00802542 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802545:	8b 45 08             	mov    0x8(%ebp),%eax
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	50                   	push   %eax
  802551:	6a 2b                	push   $0x2b
  802553:	e8 14 fa ff ff       	call   801f6c <syscall>
  802558:	83 c4 18             	add    $0x18,%esp
}
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	ff 75 0c             	pushl  0xc(%ebp)
  802569:	ff 75 08             	pushl  0x8(%ebp)
  80256c:	6a 2c                	push   $0x2c
  80256e:	e8 f9 f9 ff ff       	call   801f6c <syscall>
  802573:	83 c4 18             	add    $0x18,%esp
	return;
  802576:	90                   	nop
}
  802577:	c9                   	leave  
  802578:	c3                   	ret    

00802579 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802579:	55                   	push   %ebp
  80257a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	ff 75 0c             	pushl  0xc(%ebp)
  802585:	ff 75 08             	pushl  0x8(%ebp)
  802588:	6a 2d                	push   $0x2d
  80258a:	e8 dd f9 ff ff       	call   801f6c <syscall>
  80258f:	83 c4 18             	add    $0x18,%esp
	return;
  802592:	90                   	nop
}
  802593:	c9                   	leave  
  802594:	c3                   	ret    

00802595 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
  802598:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80259b:	8b 45 08             	mov    0x8(%ebp),%eax
  80259e:	83 e8 04             	sub    $0x4,%eax
  8025a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8025a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a7:	8b 00                	mov    (%eax),%eax
  8025a9:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8025ac:	c9                   	leave  
  8025ad:	c3                   	ret    

008025ae <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
  8025b1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b7:	83 e8 04             	sub    $0x4,%eax
  8025ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8025bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025c0:	8b 00                	mov    (%eax),%eax
  8025c2:	83 e0 01             	and    $0x1,%eax
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	0f 94 c0             	sete   %al
}
  8025ca:	c9                   	leave  
  8025cb:	c3                   	ret    

008025cc <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
  8025cf:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8025d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8025d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025dc:	83 f8 02             	cmp    $0x2,%eax
  8025df:	74 2b                	je     80260c <alloc_block+0x40>
  8025e1:	83 f8 02             	cmp    $0x2,%eax
  8025e4:	7f 07                	jg     8025ed <alloc_block+0x21>
  8025e6:	83 f8 01             	cmp    $0x1,%eax
  8025e9:	74 0e                	je     8025f9 <alloc_block+0x2d>
  8025eb:	eb 58                	jmp    802645 <alloc_block+0x79>
  8025ed:	83 f8 03             	cmp    $0x3,%eax
  8025f0:	74 2d                	je     80261f <alloc_block+0x53>
  8025f2:	83 f8 04             	cmp    $0x4,%eax
  8025f5:	74 3b                	je     802632 <alloc_block+0x66>
  8025f7:	eb 4c                	jmp    802645 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8025f9:	83 ec 0c             	sub    $0xc,%esp
  8025fc:	ff 75 08             	pushl  0x8(%ebp)
  8025ff:	e8 11 03 00 00       	call   802915 <alloc_block_FF>
  802604:	83 c4 10             	add    $0x10,%esp
  802607:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80260a:	eb 4a                	jmp    802656 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80260c:	83 ec 0c             	sub    $0xc,%esp
  80260f:	ff 75 08             	pushl  0x8(%ebp)
  802612:	e8 fa 19 00 00       	call   804011 <alloc_block_NF>
  802617:	83 c4 10             	add    $0x10,%esp
  80261a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80261d:	eb 37                	jmp    802656 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80261f:	83 ec 0c             	sub    $0xc,%esp
  802622:	ff 75 08             	pushl  0x8(%ebp)
  802625:	e8 a7 07 00 00       	call   802dd1 <alloc_block_BF>
  80262a:	83 c4 10             	add    $0x10,%esp
  80262d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802630:	eb 24                	jmp    802656 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802632:	83 ec 0c             	sub    $0xc,%esp
  802635:	ff 75 08             	pushl  0x8(%ebp)
  802638:	e8 b7 19 00 00       	call   803ff4 <alloc_block_WF>
  80263d:	83 c4 10             	add    $0x10,%esp
  802640:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802643:	eb 11                	jmp    802656 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802645:	83 ec 0c             	sub    $0xc,%esp
  802648:	68 60 4b 80 00       	push   $0x804b60
  80264d:	e8 b0 e4 ff ff       	call   800b02 <cprintf>
  802652:	83 c4 10             	add    $0x10,%esp
		break;
  802655:	90                   	nop
	}
	return va;
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
  80265e:	53                   	push   %ebx
  80265f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802662:	83 ec 0c             	sub    $0xc,%esp
  802665:	68 80 4b 80 00       	push   $0x804b80
  80266a:	e8 93 e4 ff ff       	call   800b02 <cprintf>
  80266f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802672:	83 ec 0c             	sub    $0xc,%esp
  802675:	68 ab 4b 80 00       	push   $0x804bab
  80267a:	e8 83 e4 ff ff       	call   800b02 <cprintf>
  80267f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802688:	eb 37                	jmp    8026c1 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80268a:	83 ec 0c             	sub    $0xc,%esp
  80268d:	ff 75 f4             	pushl  -0xc(%ebp)
  802690:	e8 19 ff ff ff       	call   8025ae <is_free_block>
  802695:	83 c4 10             	add    $0x10,%esp
  802698:	0f be d8             	movsbl %al,%ebx
  80269b:	83 ec 0c             	sub    $0xc,%esp
  80269e:	ff 75 f4             	pushl  -0xc(%ebp)
  8026a1:	e8 ef fe ff ff       	call   802595 <get_block_size>
  8026a6:	83 c4 10             	add    $0x10,%esp
  8026a9:	83 ec 04             	sub    $0x4,%esp
  8026ac:	53                   	push   %ebx
  8026ad:	50                   	push   %eax
  8026ae:	68 c3 4b 80 00       	push   $0x804bc3
  8026b3:	e8 4a e4 ff ff       	call   800b02 <cprintf>
  8026b8:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8026be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c5:	74 07                	je     8026ce <print_blocks_list+0x73>
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 00                	mov    (%eax),%eax
  8026cc:	eb 05                	jmp    8026d3 <print_blocks_list+0x78>
  8026ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d3:	89 45 10             	mov    %eax,0x10(%ebp)
  8026d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8026d9:	85 c0                	test   %eax,%eax
  8026db:	75 ad                	jne    80268a <print_blocks_list+0x2f>
  8026dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e1:	75 a7                	jne    80268a <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8026e3:	83 ec 0c             	sub    $0xc,%esp
  8026e6:	68 80 4b 80 00       	push   $0x804b80
  8026eb:	e8 12 e4 ff ff       	call   800b02 <cprintf>
  8026f0:	83 c4 10             	add    $0x10,%esp

}
  8026f3:	90                   	nop
  8026f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
  8026fc:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8026ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802702:	83 e0 01             	and    $0x1,%eax
  802705:	85 c0                	test   %eax,%eax
  802707:	74 03                	je     80270c <initialize_dynamic_allocator+0x13>
  802709:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80270c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802710:	0f 84 c7 01 00 00    	je     8028dd <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802716:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80271d:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802720:	8b 55 08             	mov    0x8(%ebp),%edx
  802723:	8b 45 0c             	mov    0xc(%ebp),%eax
  802726:	01 d0                	add    %edx,%eax
  802728:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80272d:	0f 87 ad 01 00 00    	ja     8028e0 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802733:	8b 45 08             	mov    0x8(%ebp),%eax
  802736:	85 c0                	test   %eax,%eax
  802738:	0f 89 a5 01 00 00    	jns    8028e3 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80273e:	8b 55 08             	mov    0x8(%ebp),%edx
  802741:	8b 45 0c             	mov    0xc(%ebp),%eax
  802744:	01 d0                	add    %edx,%eax
  802746:	83 e8 04             	sub    $0x4,%eax
  802749:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80274e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802755:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80275a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275d:	e9 87 00 00 00       	jmp    8027e9 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802762:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802766:	75 14                	jne    80277c <initialize_dynamic_allocator+0x83>
  802768:	83 ec 04             	sub    $0x4,%esp
  80276b:	68 db 4b 80 00       	push   $0x804bdb
  802770:	6a 79                	push   $0x79
  802772:	68 f9 4b 80 00       	push   $0x804bf9
  802777:	e8 c9 e0 ff ff       	call   800845 <_panic>
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	8b 00                	mov    (%eax),%eax
  802781:	85 c0                	test   %eax,%eax
  802783:	74 10                	je     802795 <initialize_dynamic_allocator+0x9c>
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	8b 00                	mov    (%eax),%eax
  80278a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278d:	8b 52 04             	mov    0x4(%edx),%edx
  802790:	89 50 04             	mov    %edx,0x4(%eax)
  802793:	eb 0b                	jmp    8027a0 <initialize_dynamic_allocator+0xa7>
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 40 04             	mov    0x4(%eax),%eax
  80279b:	a3 30 50 80 00       	mov    %eax,0x805030
  8027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a3:	8b 40 04             	mov    0x4(%eax),%eax
  8027a6:	85 c0                	test   %eax,%eax
  8027a8:	74 0f                	je     8027b9 <initialize_dynamic_allocator+0xc0>
  8027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ad:	8b 40 04             	mov    0x4(%eax),%eax
  8027b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b3:	8b 12                	mov    (%edx),%edx
  8027b5:	89 10                	mov    %edx,(%eax)
  8027b7:	eb 0a                	jmp    8027c3 <initialize_dynamic_allocator+0xca>
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	8b 00                	mov    (%eax),%eax
  8027be:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8027db:	48                   	dec    %eax
  8027dc:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8027e1:	a1 34 50 80 00       	mov    0x805034,%eax
  8027e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ed:	74 07                	je     8027f6 <initialize_dynamic_allocator+0xfd>
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 00                	mov    (%eax),%eax
  8027f4:	eb 05                	jmp    8027fb <initialize_dynamic_allocator+0x102>
  8027f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fb:	a3 34 50 80 00       	mov    %eax,0x805034
  802800:	a1 34 50 80 00       	mov    0x805034,%eax
  802805:	85 c0                	test   %eax,%eax
  802807:	0f 85 55 ff ff ff    	jne    802762 <initialize_dynamic_allocator+0x69>
  80280d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802811:	0f 85 4b ff ff ff    	jne    802762 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802817:	8b 45 08             	mov    0x8(%ebp),%eax
  80281a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80281d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802820:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802826:	a1 44 50 80 00       	mov    0x805044,%eax
  80282b:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802830:	a1 40 50 80 00       	mov    0x805040,%eax
  802835:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	83 c0 08             	add    $0x8,%eax
  802841:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802844:	8b 45 08             	mov    0x8(%ebp),%eax
  802847:	83 c0 04             	add    $0x4,%eax
  80284a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80284d:	83 ea 08             	sub    $0x8,%edx
  802850:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802852:	8b 55 0c             	mov    0xc(%ebp),%edx
  802855:	8b 45 08             	mov    0x8(%ebp),%eax
  802858:	01 d0                	add    %edx,%eax
  80285a:	83 e8 08             	sub    $0x8,%eax
  80285d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802860:	83 ea 08             	sub    $0x8,%edx
  802863:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802865:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802868:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80286e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802871:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802878:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80287c:	75 17                	jne    802895 <initialize_dynamic_allocator+0x19c>
  80287e:	83 ec 04             	sub    $0x4,%esp
  802881:	68 14 4c 80 00       	push   $0x804c14
  802886:	68 90 00 00 00       	push   $0x90
  80288b:	68 f9 4b 80 00       	push   $0x804bf9
  802890:	e8 b0 df ff ff       	call   800845 <_panic>
  802895:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80289b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289e:	89 10                	mov    %edx,(%eax)
  8028a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	74 0d                	je     8028b6 <initialize_dynamic_allocator+0x1bd>
  8028a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028b1:	89 50 04             	mov    %edx,0x4(%eax)
  8028b4:	eb 08                	jmp    8028be <initialize_dynamic_allocator+0x1c5>
  8028b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8028be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8028d5:	40                   	inc    %eax
  8028d6:	a3 38 50 80 00       	mov    %eax,0x805038
  8028db:	eb 07                	jmp    8028e4 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8028dd:	90                   	nop
  8028de:	eb 04                	jmp    8028e4 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8028e0:	90                   	nop
  8028e1:	eb 01                	jmp    8028e4 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8028e3:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8028e4:	c9                   	leave  
  8028e5:	c3                   	ret    

008028e6 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8028e6:	55                   	push   %ebp
  8028e7:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8028e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8028ec:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028f8:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	83 e8 04             	sub    $0x4,%eax
  802900:	8b 00                	mov    (%eax),%eax
  802902:	83 e0 fe             	and    $0xfffffffe,%eax
  802905:	8d 50 f8             	lea    -0x8(%eax),%edx
  802908:	8b 45 08             	mov    0x8(%ebp),%eax
  80290b:	01 c2                	add    %eax,%edx
  80290d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802910:	89 02                	mov    %eax,(%edx)
}
  802912:	90                   	nop
  802913:	5d                   	pop    %ebp
  802914:	c3                   	ret    

00802915 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802915:	55                   	push   %ebp
  802916:	89 e5                	mov    %esp,%ebp
  802918:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	83 e0 01             	and    $0x1,%eax
  802921:	85 c0                	test   %eax,%eax
  802923:	74 03                	je     802928 <alloc_block_FF+0x13>
  802925:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802928:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80292c:	77 07                	ja     802935 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80292e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802935:	a1 24 50 80 00       	mov    0x805024,%eax
  80293a:	85 c0                	test   %eax,%eax
  80293c:	75 73                	jne    8029b1 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	83 c0 10             	add    $0x10,%eax
  802944:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802947:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80294e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802951:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802954:	01 d0                	add    %edx,%eax
  802956:	48                   	dec    %eax
  802957:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80295a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295d:	ba 00 00 00 00       	mov    $0x0,%edx
  802962:	f7 75 ec             	divl   -0x14(%ebp)
  802965:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802968:	29 d0                	sub    %edx,%eax
  80296a:	c1 e8 0c             	shr    $0xc,%eax
  80296d:	83 ec 0c             	sub    $0xc,%esp
  802970:	50                   	push   %eax
  802971:	e8 2e f1 ff ff       	call   801aa4 <sbrk>
  802976:	83 c4 10             	add    $0x10,%esp
  802979:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80297c:	83 ec 0c             	sub    $0xc,%esp
  80297f:	6a 00                	push   $0x0
  802981:	e8 1e f1 ff ff       	call   801aa4 <sbrk>
  802986:	83 c4 10             	add    $0x10,%esp
  802989:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80298c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80298f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802992:	83 ec 08             	sub    $0x8,%esp
  802995:	50                   	push   %eax
  802996:	ff 75 e4             	pushl  -0x1c(%ebp)
  802999:	e8 5b fd ff ff       	call   8026f9 <initialize_dynamic_allocator>
  80299e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029a1:	83 ec 0c             	sub    $0xc,%esp
  8029a4:	68 37 4c 80 00       	push   $0x804c37
  8029a9:	e8 54 e1 ff ff       	call   800b02 <cprintf>
  8029ae:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8029b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b5:	75 0a                	jne    8029c1 <alloc_block_FF+0xac>
	        return NULL;
  8029b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bc:	e9 0e 04 00 00       	jmp    802dcf <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8029c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8029c8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d0:	e9 f3 02 00 00       	jmp    802cc8 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8029db:	83 ec 0c             	sub    $0xc,%esp
  8029de:	ff 75 bc             	pushl  -0x44(%ebp)
  8029e1:	e8 af fb ff ff       	call   802595 <get_block_size>
  8029e6:	83 c4 10             	add    $0x10,%esp
  8029e9:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8029ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ef:	83 c0 08             	add    $0x8,%eax
  8029f2:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8029f5:	0f 87 c5 02 00 00    	ja     802cc0 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	83 c0 18             	add    $0x18,%eax
  802a01:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a04:	0f 87 19 02 00 00    	ja     802c23 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802a0a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a0d:	2b 45 08             	sub    0x8(%ebp),%eax
  802a10:	83 e8 08             	sub    $0x8,%eax
  802a13:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	8d 50 08             	lea    0x8(%eax),%edx
  802a1c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a1f:	01 d0                	add    %edx,%eax
  802a21:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	83 c0 08             	add    $0x8,%eax
  802a2a:	83 ec 04             	sub    $0x4,%esp
  802a2d:	6a 01                	push   $0x1
  802a2f:	50                   	push   %eax
  802a30:	ff 75 bc             	pushl  -0x44(%ebp)
  802a33:	e8 ae fe ff ff       	call   8028e6 <set_block_data>
  802a38:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3e:	8b 40 04             	mov    0x4(%eax),%eax
  802a41:	85 c0                	test   %eax,%eax
  802a43:	75 68                	jne    802aad <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a45:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a49:	75 17                	jne    802a62 <alloc_block_FF+0x14d>
  802a4b:	83 ec 04             	sub    $0x4,%esp
  802a4e:	68 14 4c 80 00       	push   $0x804c14
  802a53:	68 d7 00 00 00       	push   $0xd7
  802a58:	68 f9 4b 80 00       	push   $0x804bf9
  802a5d:	e8 e3 dd ff ff       	call   800845 <_panic>
  802a62:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a68:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a6b:	89 10                	mov    %edx,(%eax)
  802a6d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a70:	8b 00                	mov    (%eax),%eax
  802a72:	85 c0                	test   %eax,%eax
  802a74:	74 0d                	je     802a83 <alloc_block_FF+0x16e>
  802a76:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a7b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a7e:	89 50 04             	mov    %edx,0x4(%eax)
  802a81:	eb 08                	jmp    802a8b <alloc_block_FF+0x176>
  802a83:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a86:	a3 30 50 80 00       	mov    %eax,0x805030
  802a8b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a8e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a93:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9d:	a1 38 50 80 00       	mov    0x805038,%eax
  802aa2:	40                   	inc    %eax
  802aa3:	a3 38 50 80 00       	mov    %eax,0x805038
  802aa8:	e9 dc 00 00 00       	jmp    802b89 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	8b 00                	mov    (%eax),%eax
  802ab2:	85 c0                	test   %eax,%eax
  802ab4:	75 65                	jne    802b1b <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ab6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802aba:	75 17                	jne    802ad3 <alloc_block_FF+0x1be>
  802abc:	83 ec 04             	sub    $0x4,%esp
  802abf:	68 48 4c 80 00       	push   $0x804c48
  802ac4:	68 db 00 00 00       	push   $0xdb
  802ac9:	68 f9 4b 80 00       	push   $0x804bf9
  802ace:	e8 72 dd ff ff       	call   800845 <_panic>
  802ad3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ad9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802adc:	89 50 04             	mov    %edx,0x4(%eax)
  802adf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ae2:	8b 40 04             	mov    0x4(%eax),%eax
  802ae5:	85 c0                	test   %eax,%eax
  802ae7:	74 0c                	je     802af5 <alloc_block_FF+0x1e0>
  802ae9:	a1 30 50 80 00       	mov    0x805030,%eax
  802aee:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802af1:	89 10                	mov    %edx,(%eax)
  802af3:	eb 08                	jmp    802afd <alloc_block_FF+0x1e8>
  802af5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802af8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802afd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b00:	a3 30 50 80 00       	mov    %eax,0x805030
  802b05:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0e:	a1 38 50 80 00       	mov    0x805038,%eax
  802b13:	40                   	inc    %eax
  802b14:	a3 38 50 80 00       	mov    %eax,0x805038
  802b19:	eb 6e                	jmp    802b89 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802b1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1f:	74 06                	je     802b27 <alloc_block_FF+0x212>
  802b21:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b25:	75 17                	jne    802b3e <alloc_block_FF+0x229>
  802b27:	83 ec 04             	sub    $0x4,%esp
  802b2a:	68 6c 4c 80 00       	push   $0x804c6c
  802b2f:	68 df 00 00 00       	push   $0xdf
  802b34:	68 f9 4b 80 00       	push   $0x804bf9
  802b39:	e8 07 dd ff ff       	call   800845 <_panic>
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	8b 10                	mov    (%eax),%edx
  802b43:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b46:	89 10                	mov    %edx,(%eax)
  802b48:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b4b:	8b 00                	mov    (%eax),%eax
  802b4d:	85 c0                	test   %eax,%eax
  802b4f:	74 0b                	je     802b5c <alloc_block_FF+0x247>
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b59:	89 50 04             	mov    %edx,0x4(%eax)
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b62:	89 10                	mov    %edx,(%eax)
  802b64:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b6a:	89 50 04             	mov    %edx,0x4(%eax)
  802b6d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b70:	8b 00                	mov    (%eax),%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	75 08                	jne    802b7e <alloc_block_FF+0x269>
  802b76:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b79:	a3 30 50 80 00       	mov    %eax,0x805030
  802b7e:	a1 38 50 80 00       	mov    0x805038,%eax
  802b83:	40                   	inc    %eax
  802b84:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802b89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8d:	75 17                	jne    802ba6 <alloc_block_FF+0x291>
  802b8f:	83 ec 04             	sub    $0x4,%esp
  802b92:	68 db 4b 80 00       	push   $0x804bdb
  802b97:	68 e1 00 00 00       	push   $0xe1
  802b9c:	68 f9 4b 80 00       	push   $0x804bf9
  802ba1:	e8 9f dc ff ff       	call   800845 <_panic>
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	8b 00                	mov    (%eax),%eax
  802bab:	85 c0                	test   %eax,%eax
  802bad:	74 10                	je     802bbf <alloc_block_FF+0x2aa>
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 00                	mov    (%eax),%eax
  802bb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb7:	8b 52 04             	mov    0x4(%edx),%edx
  802bba:	89 50 04             	mov    %edx,0x4(%eax)
  802bbd:	eb 0b                	jmp    802bca <alloc_block_FF+0x2b5>
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	8b 40 04             	mov    0x4(%eax),%eax
  802bc5:	a3 30 50 80 00       	mov    %eax,0x805030
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 40 04             	mov    0x4(%eax),%eax
  802bd0:	85 c0                	test   %eax,%eax
  802bd2:	74 0f                	je     802be3 <alloc_block_FF+0x2ce>
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	8b 40 04             	mov    0x4(%eax),%eax
  802bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bdd:	8b 12                	mov    (%edx),%edx
  802bdf:	89 10                	mov    %edx,(%eax)
  802be1:	eb 0a                	jmp    802bed <alloc_block_FF+0x2d8>
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	8b 00                	mov    (%eax),%eax
  802be8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c00:	a1 38 50 80 00       	mov    0x805038,%eax
  802c05:	48                   	dec    %eax
  802c06:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802c0b:	83 ec 04             	sub    $0x4,%esp
  802c0e:	6a 00                	push   $0x0
  802c10:	ff 75 b4             	pushl  -0x4c(%ebp)
  802c13:	ff 75 b0             	pushl  -0x50(%ebp)
  802c16:	e8 cb fc ff ff       	call   8028e6 <set_block_data>
  802c1b:	83 c4 10             	add    $0x10,%esp
  802c1e:	e9 95 00 00 00       	jmp    802cb8 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802c23:	83 ec 04             	sub    $0x4,%esp
  802c26:	6a 01                	push   $0x1
  802c28:	ff 75 b8             	pushl  -0x48(%ebp)
  802c2b:	ff 75 bc             	pushl  -0x44(%ebp)
  802c2e:	e8 b3 fc ff ff       	call   8028e6 <set_block_data>
  802c33:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802c36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3a:	75 17                	jne    802c53 <alloc_block_FF+0x33e>
  802c3c:	83 ec 04             	sub    $0x4,%esp
  802c3f:	68 db 4b 80 00       	push   $0x804bdb
  802c44:	68 e8 00 00 00       	push   $0xe8
  802c49:	68 f9 4b 80 00       	push   $0x804bf9
  802c4e:	e8 f2 db ff ff       	call   800845 <_panic>
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 00                	mov    (%eax),%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	74 10                	je     802c6c <alloc_block_FF+0x357>
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 00                	mov    (%eax),%eax
  802c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c64:	8b 52 04             	mov    0x4(%edx),%edx
  802c67:	89 50 04             	mov    %edx,0x4(%eax)
  802c6a:	eb 0b                	jmp    802c77 <alloc_block_FF+0x362>
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 40 04             	mov    0x4(%eax),%eax
  802c72:	a3 30 50 80 00       	mov    %eax,0x805030
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 40 04             	mov    0x4(%eax),%eax
  802c7d:	85 c0                	test   %eax,%eax
  802c7f:	74 0f                	je     802c90 <alloc_block_FF+0x37b>
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 40 04             	mov    0x4(%eax),%eax
  802c87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8a:	8b 12                	mov    (%edx),%edx
  802c8c:	89 10                	mov    %edx,(%eax)
  802c8e:	eb 0a                	jmp    802c9a <alloc_block_FF+0x385>
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cad:	a1 38 50 80 00       	mov    0x805038,%eax
  802cb2:	48                   	dec    %eax
  802cb3:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802cb8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cbb:	e9 0f 01 00 00       	jmp    802dcf <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802cc0:	a1 34 50 80 00       	mov    0x805034,%eax
  802cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccc:	74 07                	je     802cd5 <alloc_block_FF+0x3c0>
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	8b 00                	mov    (%eax),%eax
  802cd3:	eb 05                	jmp    802cda <alloc_block_FF+0x3c5>
  802cd5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cda:	a3 34 50 80 00       	mov    %eax,0x805034
  802cdf:	a1 34 50 80 00       	mov    0x805034,%eax
  802ce4:	85 c0                	test   %eax,%eax
  802ce6:	0f 85 e9 fc ff ff    	jne    8029d5 <alloc_block_FF+0xc0>
  802cec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf0:	0f 85 df fc ff ff    	jne    8029d5 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf9:	83 c0 08             	add    $0x8,%eax
  802cfc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802cff:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802d06:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d09:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d0c:	01 d0                	add    %edx,%eax
  802d0e:	48                   	dec    %eax
  802d0f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802d12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d15:	ba 00 00 00 00       	mov    $0x0,%edx
  802d1a:	f7 75 d8             	divl   -0x28(%ebp)
  802d1d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d20:	29 d0                	sub    %edx,%eax
  802d22:	c1 e8 0c             	shr    $0xc,%eax
  802d25:	83 ec 0c             	sub    $0xc,%esp
  802d28:	50                   	push   %eax
  802d29:	e8 76 ed ff ff       	call   801aa4 <sbrk>
  802d2e:	83 c4 10             	add    $0x10,%esp
  802d31:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802d34:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802d38:	75 0a                	jne    802d44 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3f:	e9 8b 00 00 00       	jmp    802dcf <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d44:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802d4b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d51:	01 d0                	add    %edx,%eax
  802d53:	48                   	dec    %eax
  802d54:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802d57:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d5a:	ba 00 00 00 00       	mov    $0x0,%edx
  802d5f:	f7 75 cc             	divl   -0x34(%ebp)
  802d62:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d65:	29 d0                	sub    %edx,%eax
  802d67:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d6a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d6d:	01 d0                	add    %edx,%eax
  802d6f:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802d74:	a1 40 50 80 00       	mov    0x805040,%eax
  802d79:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d7f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d86:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d8c:	01 d0                	add    %edx,%eax
  802d8e:	48                   	dec    %eax
  802d8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d92:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d95:	ba 00 00 00 00       	mov    $0x0,%edx
  802d9a:	f7 75 c4             	divl   -0x3c(%ebp)
  802d9d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802da0:	29 d0                	sub    %edx,%eax
  802da2:	83 ec 04             	sub    $0x4,%esp
  802da5:	6a 01                	push   $0x1
  802da7:	50                   	push   %eax
  802da8:	ff 75 d0             	pushl  -0x30(%ebp)
  802dab:	e8 36 fb ff ff       	call   8028e6 <set_block_data>
  802db0:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802db3:	83 ec 0c             	sub    $0xc,%esp
  802db6:	ff 75 d0             	pushl  -0x30(%ebp)
  802db9:	e8 1b 0a 00 00       	call   8037d9 <free_block>
  802dbe:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802dc1:	83 ec 0c             	sub    $0xc,%esp
  802dc4:	ff 75 08             	pushl  0x8(%ebp)
  802dc7:	e8 49 fb ff ff       	call   802915 <alloc_block_FF>
  802dcc:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802dcf:	c9                   	leave  
  802dd0:	c3                   	ret    

00802dd1 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802dd1:	55                   	push   %ebp
  802dd2:	89 e5                	mov    %esp,%ebp
  802dd4:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	83 e0 01             	and    $0x1,%eax
  802ddd:	85 c0                	test   %eax,%eax
  802ddf:	74 03                	je     802de4 <alloc_block_BF+0x13>
  802de1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802de4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802de8:	77 07                	ja     802df1 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802dea:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802df1:	a1 24 50 80 00       	mov    0x805024,%eax
  802df6:	85 c0                	test   %eax,%eax
  802df8:	75 73                	jne    802e6d <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	83 c0 10             	add    $0x10,%eax
  802e00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802e03:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802e0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e10:	01 d0                	add    %edx,%eax
  802e12:	48                   	dec    %eax
  802e13:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802e16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e19:	ba 00 00 00 00       	mov    $0x0,%edx
  802e1e:	f7 75 e0             	divl   -0x20(%ebp)
  802e21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e24:	29 d0                	sub    %edx,%eax
  802e26:	c1 e8 0c             	shr    $0xc,%eax
  802e29:	83 ec 0c             	sub    $0xc,%esp
  802e2c:	50                   	push   %eax
  802e2d:	e8 72 ec ff ff       	call   801aa4 <sbrk>
  802e32:	83 c4 10             	add    $0x10,%esp
  802e35:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802e38:	83 ec 0c             	sub    $0xc,%esp
  802e3b:	6a 00                	push   $0x0
  802e3d:	e8 62 ec ff ff       	call   801aa4 <sbrk>
  802e42:	83 c4 10             	add    $0x10,%esp
  802e45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802e48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e4b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802e4e:	83 ec 08             	sub    $0x8,%esp
  802e51:	50                   	push   %eax
  802e52:	ff 75 d8             	pushl  -0x28(%ebp)
  802e55:	e8 9f f8 ff ff       	call   8026f9 <initialize_dynamic_allocator>
  802e5a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802e5d:	83 ec 0c             	sub    $0xc,%esp
  802e60:	68 37 4c 80 00       	push   $0x804c37
  802e65:	e8 98 dc ff ff       	call   800b02 <cprintf>
  802e6a:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802e6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802e74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802e7b:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802e82:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802e89:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e91:	e9 1d 01 00 00       	jmp    802fb3 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802e9c:	83 ec 0c             	sub    $0xc,%esp
  802e9f:	ff 75 a8             	pushl  -0x58(%ebp)
  802ea2:	e8 ee f6 ff ff       	call   802595 <get_block_size>
  802ea7:	83 c4 10             	add    $0x10,%esp
  802eaa:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	83 c0 08             	add    $0x8,%eax
  802eb3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802eb6:	0f 87 ef 00 00 00    	ja     802fab <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	83 c0 18             	add    $0x18,%eax
  802ec2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ec5:	77 1d                	ja     802ee4 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802ec7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eca:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ecd:	0f 86 d8 00 00 00    	jbe    802fab <alloc_block_BF+0x1da>
				{
					best_va = va;
  802ed3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ed6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802ed9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802edc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802edf:	e9 c7 00 00 00       	jmp    802fab <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	83 c0 08             	add    $0x8,%eax
  802eea:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802eed:	0f 85 9d 00 00 00    	jne    802f90 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802ef3:	83 ec 04             	sub    $0x4,%esp
  802ef6:	6a 01                	push   $0x1
  802ef8:	ff 75 a4             	pushl  -0x5c(%ebp)
  802efb:	ff 75 a8             	pushl  -0x58(%ebp)
  802efe:	e8 e3 f9 ff ff       	call   8028e6 <set_block_data>
  802f03:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802f06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0a:	75 17                	jne    802f23 <alloc_block_BF+0x152>
  802f0c:	83 ec 04             	sub    $0x4,%esp
  802f0f:	68 db 4b 80 00       	push   $0x804bdb
  802f14:	68 2c 01 00 00       	push   $0x12c
  802f19:	68 f9 4b 80 00       	push   $0x804bf9
  802f1e:	e8 22 d9 ff ff       	call   800845 <_panic>
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	8b 00                	mov    (%eax),%eax
  802f28:	85 c0                	test   %eax,%eax
  802f2a:	74 10                	je     802f3c <alloc_block_BF+0x16b>
  802f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2f:	8b 00                	mov    (%eax),%eax
  802f31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f34:	8b 52 04             	mov    0x4(%edx),%edx
  802f37:	89 50 04             	mov    %edx,0x4(%eax)
  802f3a:	eb 0b                	jmp    802f47 <alloc_block_BF+0x176>
  802f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3f:	8b 40 04             	mov    0x4(%eax),%eax
  802f42:	a3 30 50 80 00       	mov    %eax,0x805030
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	8b 40 04             	mov    0x4(%eax),%eax
  802f4d:	85 c0                	test   %eax,%eax
  802f4f:	74 0f                	je     802f60 <alloc_block_BF+0x18f>
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	8b 40 04             	mov    0x4(%eax),%eax
  802f57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f5a:	8b 12                	mov    (%edx),%edx
  802f5c:	89 10                	mov    %edx,(%eax)
  802f5e:	eb 0a                	jmp    802f6a <alloc_block_BF+0x199>
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	8b 00                	mov    (%eax),%eax
  802f65:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7d:	a1 38 50 80 00       	mov    0x805038,%eax
  802f82:	48                   	dec    %eax
  802f83:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802f88:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f8b:	e9 24 04 00 00       	jmp    8033b4 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f93:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f96:	76 13                	jbe    802fab <alloc_block_BF+0x1da>
					{
						internal = 1;
  802f98:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802f9f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802fa5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802fa8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802fab:	a1 34 50 80 00       	mov    0x805034,%eax
  802fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb7:	74 07                	je     802fc0 <alloc_block_BF+0x1ef>
  802fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbc:	8b 00                	mov    (%eax),%eax
  802fbe:	eb 05                	jmp    802fc5 <alloc_block_BF+0x1f4>
  802fc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc5:	a3 34 50 80 00       	mov    %eax,0x805034
  802fca:	a1 34 50 80 00       	mov    0x805034,%eax
  802fcf:	85 c0                	test   %eax,%eax
  802fd1:	0f 85 bf fe ff ff    	jne    802e96 <alloc_block_BF+0xc5>
  802fd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fdb:	0f 85 b5 fe ff ff    	jne    802e96 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802fe1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fe5:	0f 84 26 02 00 00    	je     803211 <alloc_block_BF+0x440>
  802feb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fef:	0f 85 1c 02 00 00    	jne    803211 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802ff5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff8:	2b 45 08             	sub    0x8(%ebp),%eax
  802ffb:	83 e8 08             	sub    $0x8,%eax
  802ffe:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	8d 50 08             	lea    0x8(%eax),%edx
  803007:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300a:	01 d0                	add    %edx,%eax
  80300c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80300f:	8b 45 08             	mov    0x8(%ebp),%eax
  803012:	83 c0 08             	add    $0x8,%eax
  803015:	83 ec 04             	sub    $0x4,%esp
  803018:	6a 01                	push   $0x1
  80301a:	50                   	push   %eax
  80301b:	ff 75 f0             	pushl  -0x10(%ebp)
  80301e:	e8 c3 f8 ff ff       	call   8028e6 <set_block_data>
  803023:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803029:	8b 40 04             	mov    0x4(%eax),%eax
  80302c:	85 c0                	test   %eax,%eax
  80302e:	75 68                	jne    803098 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803030:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803034:	75 17                	jne    80304d <alloc_block_BF+0x27c>
  803036:	83 ec 04             	sub    $0x4,%esp
  803039:	68 14 4c 80 00       	push   $0x804c14
  80303e:	68 45 01 00 00       	push   $0x145
  803043:	68 f9 4b 80 00       	push   $0x804bf9
  803048:	e8 f8 d7 ff ff       	call   800845 <_panic>
  80304d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803053:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803056:	89 10                	mov    %edx,(%eax)
  803058:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80305b:	8b 00                	mov    (%eax),%eax
  80305d:	85 c0                	test   %eax,%eax
  80305f:	74 0d                	je     80306e <alloc_block_BF+0x29d>
  803061:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803066:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803069:	89 50 04             	mov    %edx,0x4(%eax)
  80306c:	eb 08                	jmp    803076 <alloc_block_BF+0x2a5>
  80306e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803071:	a3 30 50 80 00       	mov    %eax,0x805030
  803076:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803079:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80307e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803081:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803088:	a1 38 50 80 00       	mov    0x805038,%eax
  80308d:	40                   	inc    %eax
  80308e:	a3 38 50 80 00       	mov    %eax,0x805038
  803093:	e9 dc 00 00 00       	jmp    803174 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309b:	8b 00                	mov    (%eax),%eax
  80309d:	85 c0                	test   %eax,%eax
  80309f:	75 65                	jne    803106 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030a1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030a5:	75 17                	jne    8030be <alloc_block_BF+0x2ed>
  8030a7:	83 ec 04             	sub    $0x4,%esp
  8030aa:	68 48 4c 80 00       	push   $0x804c48
  8030af:	68 4a 01 00 00       	push   $0x14a
  8030b4:	68 f9 4b 80 00       	push   $0x804bf9
  8030b9:	e8 87 d7 ff ff       	call   800845 <_panic>
  8030be:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030c7:	89 50 04             	mov    %edx,0x4(%eax)
  8030ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030cd:	8b 40 04             	mov    0x4(%eax),%eax
  8030d0:	85 c0                	test   %eax,%eax
  8030d2:	74 0c                	je     8030e0 <alloc_block_BF+0x30f>
  8030d4:	a1 30 50 80 00       	mov    0x805030,%eax
  8030d9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030dc:	89 10                	mov    %edx,(%eax)
  8030de:	eb 08                	jmp    8030e8 <alloc_block_BF+0x317>
  8030e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030e3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030eb:	a3 30 50 80 00       	mov    %eax,0x805030
  8030f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8030fe:	40                   	inc    %eax
  8030ff:	a3 38 50 80 00       	mov    %eax,0x805038
  803104:	eb 6e                	jmp    803174 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803106:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80310a:	74 06                	je     803112 <alloc_block_BF+0x341>
  80310c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803110:	75 17                	jne    803129 <alloc_block_BF+0x358>
  803112:	83 ec 04             	sub    $0x4,%esp
  803115:	68 6c 4c 80 00       	push   $0x804c6c
  80311a:	68 4f 01 00 00       	push   $0x14f
  80311f:	68 f9 4b 80 00       	push   $0x804bf9
  803124:	e8 1c d7 ff ff       	call   800845 <_panic>
  803129:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312c:	8b 10                	mov    (%eax),%edx
  80312e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803131:	89 10                	mov    %edx,(%eax)
  803133:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803136:	8b 00                	mov    (%eax),%eax
  803138:	85 c0                	test   %eax,%eax
  80313a:	74 0b                	je     803147 <alloc_block_BF+0x376>
  80313c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803144:	89 50 04             	mov    %edx,0x4(%eax)
  803147:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80314d:	89 10                	mov    %edx,(%eax)
  80314f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803152:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803155:	89 50 04             	mov    %edx,0x4(%eax)
  803158:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	85 c0                	test   %eax,%eax
  80315f:	75 08                	jne    803169 <alloc_block_BF+0x398>
  803161:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803164:	a3 30 50 80 00       	mov    %eax,0x805030
  803169:	a1 38 50 80 00       	mov    0x805038,%eax
  80316e:	40                   	inc    %eax
  80316f:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803174:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803178:	75 17                	jne    803191 <alloc_block_BF+0x3c0>
  80317a:	83 ec 04             	sub    $0x4,%esp
  80317d:	68 db 4b 80 00       	push   $0x804bdb
  803182:	68 51 01 00 00       	push   $0x151
  803187:	68 f9 4b 80 00       	push   $0x804bf9
  80318c:	e8 b4 d6 ff ff       	call   800845 <_panic>
  803191:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803194:	8b 00                	mov    (%eax),%eax
  803196:	85 c0                	test   %eax,%eax
  803198:	74 10                	je     8031aa <alloc_block_BF+0x3d9>
  80319a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319d:	8b 00                	mov    (%eax),%eax
  80319f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031a2:	8b 52 04             	mov    0x4(%edx),%edx
  8031a5:	89 50 04             	mov    %edx,0x4(%eax)
  8031a8:	eb 0b                	jmp    8031b5 <alloc_block_BF+0x3e4>
  8031aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ad:	8b 40 04             	mov    0x4(%eax),%eax
  8031b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8031b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b8:	8b 40 04             	mov    0x4(%eax),%eax
  8031bb:	85 c0                	test   %eax,%eax
  8031bd:	74 0f                	je     8031ce <alloc_block_BF+0x3fd>
  8031bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c2:	8b 40 04             	mov    0x4(%eax),%eax
  8031c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031c8:	8b 12                	mov    (%edx),%edx
  8031ca:	89 10                	mov    %edx,(%eax)
  8031cc:	eb 0a                	jmp    8031d8 <alloc_block_BF+0x407>
  8031ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d1:	8b 00                	mov    (%eax),%eax
  8031d3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8031f0:	48                   	dec    %eax
  8031f1:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8031f6:	83 ec 04             	sub    $0x4,%esp
  8031f9:	6a 00                	push   $0x0
  8031fb:	ff 75 d0             	pushl  -0x30(%ebp)
  8031fe:	ff 75 cc             	pushl  -0x34(%ebp)
  803201:	e8 e0 f6 ff ff       	call   8028e6 <set_block_data>
  803206:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803209:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320c:	e9 a3 01 00 00       	jmp    8033b4 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803211:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803215:	0f 85 9d 00 00 00    	jne    8032b8 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80321b:	83 ec 04             	sub    $0x4,%esp
  80321e:	6a 01                	push   $0x1
  803220:	ff 75 ec             	pushl  -0x14(%ebp)
  803223:	ff 75 f0             	pushl  -0x10(%ebp)
  803226:	e8 bb f6 ff ff       	call   8028e6 <set_block_data>
  80322b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80322e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803232:	75 17                	jne    80324b <alloc_block_BF+0x47a>
  803234:	83 ec 04             	sub    $0x4,%esp
  803237:	68 db 4b 80 00       	push   $0x804bdb
  80323c:	68 58 01 00 00       	push   $0x158
  803241:	68 f9 4b 80 00       	push   $0x804bf9
  803246:	e8 fa d5 ff ff       	call   800845 <_panic>
  80324b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324e:	8b 00                	mov    (%eax),%eax
  803250:	85 c0                	test   %eax,%eax
  803252:	74 10                	je     803264 <alloc_block_BF+0x493>
  803254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803257:	8b 00                	mov    (%eax),%eax
  803259:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80325c:	8b 52 04             	mov    0x4(%edx),%edx
  80325f:	89 50 04             	mov    %edx,0x4(%eax)
  803262:	eb 0b                	jmp    80326f <alloc_block_BF+0x49e>
  803264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803267:	8b 40 04             	mov    0x4(%eax),%eax
  80326a:	a3 30 50 80 00       	mov    %eax,0x805030
  80326f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803272:	8b 40 04             	mov    0x4(%eax),%eax
  803275:	85 c0                	test   %eax,%eax
  803277:	74 0f                	je     803288 <alloc_block_BF+0x4b7>
  803279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327c:	8b 40 04             	mov    0x4(%eax),%eax
  80327f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803282:	8b 12                	mov    (%edx),%edx
  803284:	89 10                	mov    %edx,(%eax)
  803286:	eb 0a                	jmp    803292 <alloc_block_BF+0x4c1>
  803288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328b:	8b 00                	mov    (%eax),%eax
  80328d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803292:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803295:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80329b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8032aa:	48                   	dec    %eax
  8032ab:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8032b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b3:	e9 fc 00 00 00       	jmp    8033b4 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bb:	83 c0 08             	add    $0x8,%eax
  8032be:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8032c1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8032c8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032cb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8032ce:	01 d0                	add    %edx,%eax
  8032d0:	48                   	dec    %eax
  8032d1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8032d4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8032d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8032dc:	f7 75 c4             	divl   -0x3c(%ebp)
  8032df:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8032e2:	29 d0                	sub    %edx,%eax
  8032e4:	c1 e8 0c             	shr    $0xc,%eax
  8032e7:	83 ec 0c             	sub    $0xc,%esp
  8032ea:	50                   	push   %eax
  8032eb:	e8 b4 e7 ff ff       	call   801aa4 <sbrk>
  8032f0:	83 c4 10             	add    $0x10,%esp
  8032f3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8032f6:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8032fa:	75 0a                	jne    803306 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8032fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803301:	e9 ae 00 00 00       	jmp    8033b4 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803306:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80330d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803310:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803313:	01 d0                	add    %edx,%eax
  803315:	48                   	dec    %eax
  803316:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803319:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80331c:	ba 00 00 00 00       	mov    $0x0,%edx
  803321:	f7 75 b8             	divl   -0x48(%ebp)
  803324:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803327:	29 d0                	sub    %edx,%eax
  803329:	8d 50 fc             	lea    -0x4(%eax),%edx
  80332c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80332f:	01 d0                	add    %edx,%eax
  803331:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  803336:	a1 40 50 80 00       	mov    0x805040,%eax
  80333b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803341:	83 ec 0c             	sub    $0xc,%esp
  803344:	68 a0 4c 80 00       	push   $0x804ca0
  803349:	e8 b4 d7 ff ff       	call   800b02 <cprintf>
  80334e:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803351:	83 ec 08             	sub    $0x8,%esp
  803354:	ff 75 bc             	pushl  -0x44(%ebp)
  803357:	68 a5 4c 80 00       	push   $0x804ca5
  80335c:	e8 a1 d7 ff ff       	call   800b02 <cprintf>
  803361:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803364:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80336b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80336e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803371:	01 d0                	add    %edx,%eax
  803373:	48                   	dec    %eax
  803374:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803377:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80337a:	ba 00 00 00 00       	mov    $0x0,%edx
  80337f:	f7 75 b0             	divl   -0x50(%ebp)
  803382:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803385:	29 d0                	sub    %edx,%eax
  803387:	83 ec 04             	sub    $0x4,%esp
  80338a:	6a 01                	push   $0x1
  80338c:	50                   	push   %eax
  80338d:	ff 75 bc             	pushl  -0x44(%ebp)
  803390:	e8 51 f5 ff ff       	call   8028e6 <set_block_data>
  803395:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803398:	83 ec 0c             	sub    $0xc,%esp
  80339b:	ff 75 bc             	pushl  -0x44(%ebp)
  80339e:	e8 36 04 00 00       	call   8037d9 <free_block>
  8033a3:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8033a6:	83 ec 0c             	sub    $0xc,%esp
  8033a9:	ff 75 08             	pushl  0x8(%ebp)
  8033ac:	e8 20 fa ff ff       	call   802dd1 <alloc_block_BF>
  8033b1:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8033b4:	c9                   	leave  
  8033b5:	c3                   	ret    

008033b6 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8033b6:	55                   	push   %ebp
  8033b7:	89 e5                	mov    %esp,%ebp
  8033b9:	53                   	push   %ebx
  8033ba:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8033bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8033c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8033cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033cf:	74 1e                	je     8033ef <merging+0x39>
  8033d1:	ff 75 08             	pushl  0x8(%ebp)
  8033d4:	e8 bc f1 ff ff       	call   802595 <get_block_size>
  8033d9:	83 c4 04             	add    $0x4,%esp
  8033dc:	89 c2                	mov    %eax,%edx
  8033de:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e1:	01 d0                	add    %edx,%eax
  8033e3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8033e6:	75 07                	jne    8033ef <merging+0x39>
		prev_is_free = 1;
  8033e8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8033ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033f3:	74 1e                	je     803413 <merging+0x5d>
  8033f5:	ff 75 10             	pushl  0x10(%ebp)
  8033f8:	e8 98 f1 ff ff       	call   802595 <get_block_size>
  8033fd:	83 c4 04             	add    $0x4,%esp
  803400:	89 c2                	mov    %eax,%edx
  803402:	8b 45 10             	mov    0x10(%ebp),%eax
  803405:	01 d0                	add    %edx,%eax
  803407:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80340a:	75 07                	jne    803413 <merging+0x5d>
		next_is_free = 1;
  80340c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803413:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803417:	0f 84 cc 00 00 00    	je     8034e9 <merging+0x133>
  80341d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803421:	0f 84 c2 00 00 00    	je     8034e9 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803427:	ff 75 08             	pushl  0x8(%ebp)
  80342a:	e8 66 f1 ff ff       	call   802595 <get_block_size>
  80342f:	83 c4 04             	add    $0x4,%esp
  803432:	89 c3                	mov    %eax,%ebx
  803434:	ff 75 10             	pushl  0x10(%ebp)
  803437:	e8 59 f1 ff ff       	call   802595 <get_block_size>
  80343c:	83 c4 04             	add    $0x4,%esp
  80343f:	01 c3                	add    %eax,%ebx
  803441:	ff 75 0c             	pushl  0xc(%ebp)
  803444:	e8 4c f1 ff ff       	call   802595 <get_block_size>
  803449:	83 c4 04             	add    $0x4,%esp
  80344c:	01 d8                	add    %ebx,%eax
  80344e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803451:	6a 00                	push   $0x0
  803453:	ff 75 ec             	pushl  -0x14(%ebp)
  803456:	ff 75 08             	pushl  0x8(%ebp)
  803459:	e8 88 f4 ff ff       	call   8028e6 <set_block_data>
  80345e:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803461:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803465:	75 17                	jne    80347e <merging+0xc8>
  803467:	83 ec 04             	sub    $0x4,%esp
  80346a:	68 db 4b 80 00       	push   $0x804bdb
  80346f:	68 7d 01 00 00       	push   $0x17d
  803474:	68 f9 4b 80 00       	push   $0x804bf9
  803479:	e8 c7 d3 ff ff       	call   800845 <_panic>
  80347e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803481:	8b 00                	mov    (%eax),%eax
  803483:	85 c0                	test   %eax,%eax
  803485:	74 10                	je     803497 <merging+0xe1>
  803487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348a:	8b 00                	mov    (%eax),%eax
  80348c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80348f:	8b 52 04             	mov    0x4(%edx),%edx
  803492:	89 50 04             	mov    %edx,0x4(%eax)
  803495:	eb 0b                	jmp    8034a2 <merging+0xec>
  803497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349a:	8b 40 04             	mov    0x4(%eax),%eax
  80349d:	a3 30 50 80 00       	mov    %eax,0x805030
  8034a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a5:	8b 40 04             	mov    0x4(%eax),%eax
  8034a8:	85 c0                	test   %eax,%eax
  8034aa:	74 0f                	je     8034bb <merging+0x105>
  8034ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034af:	8b 40 04             	mov    0x4(%eax),%eax
  8034b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034b5:	8b 12                	mov    (%edx),%edx
  8034b7:	89 10                	mov    %edx,(%eax)
  8034b9:	eb 0a                	jmp    8034c5 <merging+0x10f>
  8034bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034be:	8b 00                	mov    (%eax),%eax
  8034c0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8034dd:	48                   	dec    %eax
  8034de:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8034e3:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034e4:	e9 ea 02 00 00       	jmp    8037d3 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8034e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ed:	74 3b                	je     80352a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8034ef:	83 ec 0c             	sub    $0xc,%esp
  8034f2:	ff 75 08             	pushl  0x8(%ebp)
  8034f5:	e8 9b f0 ff ff       	call   802595 <get_block_size>
  8034fa:	83 c4 10             	add    $0x10,%esp
  8034fd:	89 c3                	mov    %eax,%ebx
  8034ff:	83 ec 0c             	sub    $0xc,%esp
  803502:	ff 75 10             	pushl  0x10(%ebp)
  803505:	e8 8b f0 ff ff       	call   802595 <get_block_size>
  80350a:	83 c4 10             	add    $0x10,%esp
  80350d:	01 d8                	add    %ebx,%eax
  80350f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803512:	83 ec 04             	sub    $0x4,%esp
  803515:	6a 00                	push   $0x0
  803517:	ff 75 e8             	pushl  -0x18(%ebp)
  80351a:	ff 75 08             	pushl  0x8(%ebp)
  80351d:	e8 c4 f3 ff ff       	call   8028e6 <set_block_data>
  803522:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803525:	e9 a9 02 00 00       	jmp    8037d3 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80352a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80352e:	0f 84 2d 01 00 00    	je     803661 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803534:	83 ec 0c             	sub    $0xc,%esp
  803537:	ff 75 10             	pushl  0x10(%ebp)
  80353a:	e8 56 f0 ff ff       	call   802595 <get_block_size>
  80353f:	83 c4 10             	add    $0x10,%esp
  803542:	89 c3                	mov    %eax,%ebx
  803544:	83 ec 0c             	sub    $0xc,%esp
  803547:	ff 75 0c             	pushl  0xc(%ebp)
  80354a:	e8 46 f0 ff ff       	call   802595 <get_block_size>
  80354f:	83 c4 10             	add    $0x10,%esp
  803552:	01 d8                	add    %ebx,%eax
  803554:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803557:	83 ec 04             	sub    $0x4,%esp
  80355a:	6a 00                	push   $0x0
  80355c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80355f:	ff 75 10             	pushl  0x10(%ebp)
  803562:	e8 7f f3 ff ff       	call   8028e6 <set_block_data>
  803567:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80356a:	8b 45 10             	mov    0x10(%ebp),%eax
  80356d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803570:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803574:	74 06                	je     80357c <merging+0x1c6>
  803576:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80357a:	75 17                	jne    803593 <merging+0x1dd>
  80357c:	83 ec 04             	sub    $0x4,%esp
  80357f:	68 b4 4c 80 00       	push   $0x804cb4
  803584:	68 8d 01 00 00       	push   $0x18d
  803589:	68 f9 4b 80 00       	push   $0x804bf9
  80358e:	e8 b2 d2 ff ff       	call   800845 <_panic>
  803593:	8b 45 0c             	mov    0xc(%ebp),%eax
  803596:	8b 50 04             	mov    0x4(%eax),%edx
  803599:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80359c:	89 50 04             	mov    %edx,0x4(%eax)
  80359f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035a5:	89 10                	mov    %edx,(%eax)
  8035a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035aa:	8b 40 04             	mov    0x4(%eax),%eax
  8035ad:	85 c0                	test   %eax,%eax
  8035af:	74 0d                	je     8035be <merging+0x208>
  8035b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b4:	8b 40 04             	mov    0x4(%eax),%eax
  8035b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035ba:	89 10                	mov    %edx,(%eax)
  8035bc:	eb 08                	jmp    8035c6 <merging+0x210>
  8035be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035cc:	89 50 04             	mov    %edx,0x4(%eax)
  8035cf:	a1 38 50 80 00       	mov    0x805038,%eax
  8035d4:	40                   	inc    %eax
  8035d5:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  8035da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035de:	75 17                	jne    8035f7 <merging+0x241>
  8035e0:	83 ec 04             	sub    $0x4,%esp
  8035e3:	68 db 4b 80 00       	push   $0x804bdb
  8035e8:	68 8e 01 00 00       	push   $0x18e
  8035ed:	68 f9 4b 80 00       	push   $0x804bf9
  8035f2:	e8 4e d2 ff ff       	call   800845 <_panic>
  8035f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fa:	8b 00                	mov    (%eax),%eax
  8035fc:	85 c0                	test   %eax,%eax
  8035fe:	74 10                	je     803610 <merging+0x25a>
  803600:	8b 45 0c             	mov    0xc(%ebp),%eax
  803603:	8b 00                	mov    (%eax),%eax
  803605:	8b 55 0c             	mov    0xc(%ebp),%edx
  803608:	8b 52 04             	mov    0x4(%edx),%edx
  80360b:	89 50 04             	mov    %edx,0x4(%eax)
  80360e:	eb 0b                	jmp    80361b <merging+0x265>
  803610:	8b 45 0c             	mov    0xc(%ebp),%eax
  803613:	8b 40 04             	mov    0x4(%eax),%eax
  803616:	a3 30 50 80 00       	mov    %eax,0x805030
  80361b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80361e:	8b 40 04             	mov    0x4(%eax),%eax
  803621:	85 c0                	test   %eax,%eax
  803623:	74 0f                	je     803634 <merging+0x27e>
  803625:	8b 45 0c             	mov    0xc(%ebp),%eax
  803628:	8b 40 04             	mov    0x4(%eax),%eax
  80362b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80362e:	8b 12                	mov    (%edx),%edx
  803630:	89 10                	mov    %edx,(%eax)
  803632:	eb 0a                	jmp    80363e <merging+0x288>
  803634:	8b 45 0c             	mov    0xc(%ebp),%eax
  803637:	8b 00                	mov    (%eax),%eax
  803639:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80363e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803641:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80364a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803651:	a1 38 50 80 00       	mov    0x805038,%eax
  803656:	48                   	dec    %eax
  803657:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80365c:	e9 72 01 00 00       	jmp    8037d3 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803661:	8b 45 10             	mov    0x10(%ebp),%eax
  803664:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803667:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80366b:	74 79                	je     8036e6 <merging+0x330>
  80366d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803671:	74 73                	je     8036e6 <merging+0x330>
  803673:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803677:	74 06                	je     80367f <merging+0x2c9>
  803679:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80367d:	75 17                	jne    803696 <merging+0x2e0>
  80367f:	83 ec 04             	sub    $0x4,%esp
  803682:	68 6c 4c 80 00       	push   $0x804c6c
  803687:	68 94 01 00 00       	push   $0x194
  80368c:	68 f9 4b 80 00       	push   $0x804bf9
  803691:	e8 af d1 ff ff       	call   800845 <_panic>
  803696:	8b 45 08             	mov    0x8(%ebp),%eax
  803699:	8b 10                	mov    (%eax),%edx
  80369b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80369e:	89 10                	mov    %edx,(%eax)
  8036a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036a3:	8b 00                	mov    (%eax),%eax
  8036a5:	85 c0                	test   %eax,%eax
  8036a7:	74 0b                	je     8036b4 <merging+0x2fe>
  8036a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ac:	8b 00                	mov    (%eax),%eax
  8036ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036b1:	89 50 04             	mov    %edx,0x4(%eax)
  8036b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036ba:	89 10                	mov    %edx,(%eax)
  8036bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8036c2:	89 50 04             	mov    %edx,0x4(%eax)
  8036c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036c8:	8b 00                	mov    (%eax),%eax
  8036ca:	85 c0                	test   %eax,%eax
  8036cc:	75 08                	jne    8036d6 <merging+0x320>
  8036ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036d1:	a3 30 50 80 00       	mov    %eax,0x805030
  8036d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8036db:	40                   	inc    %eax
  8036dc:	a3 38 50 80 00       	mov    %eax,0x805038
  8036e1:	e9 ce 00 00 00       	jmp    8037b4 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8036e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036ea:	74 65                	je     803751 <merging+0x39b>
  8036ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036f0:	75 17                	jne    803709 <merging+0x353>
  8036f2:	83 ec 04             	sub    $0x4,%esp
  8036f5:	68 48 4c 80 00       	push   $0x804c48
  8036fa:	68 95 01 00 00       	push   $0x195
  8036ff:	68 f9 4b 80 00       	push   $0x804bf9
  803704:	e8 3c d1 ff ff       	call   800845 <_panic>
  803709:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80370f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803712:	89 50 04             	mov    %edx,0x4(%eax)
  803715:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803718:	8b 40 04             	mov    0x4(%eax),%eax
  80371b:	85 c0                	test   %eax,%eax
  80371d:	74 0c                	je     80372b <merging+0x375>
  80371f:	a1 30 50 80 00       	mov    0x805030,%eax
  803724:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803727:	89 10                	mov    %edx,(%eax)
  803729:	eb 08                	jmp    803733 <merging+0x37d>
  80372b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80372e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803733:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803736:	a3 30 50 80 00       	mov    %eax,0x805030
  80373b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80373e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803744:	a1 38 50 80 00       	mov    0x805038,%eax
  803749:	40                   	inc    %eax
  80374a:	a3 38 50 80 00       	mov    %eax,0x805038
  80374f:	eb 63                	jmp    8037b4 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803751:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803755:	75 17                	jne    80376e <merging+0x3b8>
  803757:	83 ec 04             	sub    $0x4,%esp
  80375a:	68 14 4c 80 00       	push   $0x804c14
  80375f:	68 98 01 00 00       	push   $0x198
  803764:	68 f9 4b 80 00       	push   $0x804bf9
  803769:	e8 d7 d0 ff ff       	call   800845 <_panic>
  80376e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803774:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803777:	89 10                	mov    %edx,(%eax)
  803779:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80377c:	8b 00                	mov    (%eax),%eax
  80377e:	85 c0                	test   %eax,%eax
  803780:	74 0d                	je     80378f <merging+0x3d9>
  803782:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803787:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80378a:	89 50 04             	mov    %edx,0x4(%eax)
  80378d:	eb 08                	jmp    803797 <merging+0x3e1>
  80378f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803792:	a3 30 50 80 00       	mov    %eax,0x805030
  803797:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80379a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80379f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a9:	a1 38 50 80 00       	mov    0x805038,%eax
  8037ae:	40                   	inc    %eax
  8037af:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8037b4:	83 ec 0c             	sub    $0xc,%esp
  8037b7:	ff 75 10             	pushl  0x10(%ebp)
  8037ba:	e8 d6 ed ff ff       	call   802595 <get_block_size>
  8037bf:	83 c4 10             	add    $0x10,%esp
  8037c2:	83 ec 04             	sub    $0x4,%esp
  8037c5:	6a 00                	push   $0x0
  8037c7:	50                   	push   %eax
  8037c8:	ff 75 10             	pushl  0x10(%ebp)
  8037cb:	e8 16 f1 ff ff       	call   8028e6 <set_block_data>
  8037d0:	83 c4 10             	add    $0x10,%esp
	}
}
  8037d3:	90                   	nop
  8037d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8037d7:	c9                   	leave  
  8037d8:	c3                   	ret    

008037d9 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8037d9:	55                   	push   %ebp
  8037da:	89 e5                	mov    %esp,%ebp
  8037dc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8037df:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037e4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8037e7:	a1 30 50 80 00       	mov    0x805030,%eax
  8037ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037ef:	73 1b                	jae    80380c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8037f1:	a1 30 50 80 00       	mov    0x805030,%eax
  8037f6:	83 ec 04             	sub    $0x4,%esp
  8037f9:	ff 75 08             	pushl  0x8(%ebp)
  8037fc:	6a 00                	push   $0x0
  8037fe:	50                   	push   %eax
  8037ff:	e8 b2 fb ff ff       	call   8033b6 <merging>
  803804:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803807:	e9 8b 00 00 00       	jmp    803897 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80380c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803811:	3b 45 08             	cmp    0x8(%ebp),%eax
  803814:	76 18                	jbe    80382e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803816:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80381b:	83 ec 04             	sub    $0x4,%esp
  80381e:	ff 75 08             	pushl  0x8(%ebp)
  803821:	50                   	push   %eax
  803822:	6a 00                	push   $0x0
  803824:	e8 8d fb ff ff       	call   8033b6 <merging>
  803829:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80382c:	eb 69                	jmp    803897 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80382e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803833:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803836:	eb 39                	jmp    803871 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80383e:	73 29                	jae    803869 <free_block+0x90>
  803840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803843:	8b 00                	mov    (%eax),%eax
  803845:	3b 45 08             	cmp    0x8(%ebp),%eax
  803848:	76 1f                	jbe    803869 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80384a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384d:	8b 00                	mov    (%eax),%eax
  80384f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803852:	83 ec 04             	sub    $0x4,%esp
  803855:	ff 75 08             	pushl  0x8(%ebp)
  803858:	ff 75 f0             	pushl  -0x10(%ebp)
  80385b:	ff 75 f4             	pushl  -0xc(%ebp)
  80385e:	e8 53 fb ff ff       	call   8033b6 <merging>
  803863:	83 c4 10             	add    $0x10,%esp
			break;
  803866:	90                   	nop
		}
	}
}
  803867:	eb 2e                	jmp    803897 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803869:	a1 34 50 80 00       	mov    0x805034,%eax
  80386e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803871:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803875:	74 07                	je     80387e <free_block+0xa5>
  803877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387a:	8b 00                	mov    (%eax),%eax
  80387c:	eb 05                	jmp    803883 <free_block+0xaa>
  80387e:	b8 00 00 00 00       	mov    $0x0,%eax
  803883:	a3 34 50 80 00       	mov    %eax,0x805034
  803888:	a1 34 50 80 00       	mov    0x805034,%eax
  80388d:	85 c0                	test   %eax,%eax
  80388f:	75 a7                	jne    803838 <free_block+0x5f>
  803891:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803895:	75 a1                	jne    803838 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803897:	90                   	nop
  803898:	c9                   	leave  
  803899:	c3                   	ret    

0080389a <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80389a:	55                   	push   %ebp
  80389b:	89 e5                	mov    %esp,%ebp
  80389d:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8038a0:	ff 75 08             	pushl  0x8(%ebp)
  8038a3:	e8 ed ec ff ff       	call   802595 <get_block_size>
  8038a8:	83 c4 04             	add    $0x4,%esp
  8038ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8038ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8038b5:	eb 17                	jmp    8038ce <copy_data+0x34>
  8038b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8038ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038bd:	01 c2                	add    %eax,%edx
  8038bf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8038c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c5:	01 c8                	add    %ecx,%eax
  8038c7:	8a 00                	mov    (%eax),%al
  8038c9:	88 02                	mov    %al,(%edx)
  8038cb:	ff 45 fc             	incl   -0x4(%ebp)
  8038ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8038d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8038d4:	72 e1                	jb     8038b7 <copy_data+0x1d>
}
  8038d6:	90                   	nop
  8038d7:	c9                   	leave  
  8038d8:	c3                   	ret    

008038d9 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8038d9:	55                   	push   %ebp
  8038da:	89 e5                	mov    %esp,%ebp
  8038dc:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8038df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038e3:	75 23                	jne    803908 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8038e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038e9:	74 13                	je     8038fe <realloc_block_FF+0x25>
  8038eb:	83 ec 0c             	sub    $0xc,%esp
  8038ee:	ff 75 0c             	pushl  0xc(%ebp)
  8038f1:	e8 1f f0 ff ff       	call   802915 <alloc_block_FF>
  8038f6:	83 c4 10             	add    $0x10,%esp
  8038f9:	e9 f4 06 00 00       	jmp    803ff2 <realloc_block_FF+0x719>
		return NULL;
  8038fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803903:	e9 ea 06 00 00       	jmp    803ff2 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803908:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80390c:	75 18                	jne    803926 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80390e:	83 ec 0c             	sub    $0xc,%esp
  803911:	ff 75 08             	pushl  0x8(%ebp)
  803914:	e8 c0 fe ff ff       	call   8037d9 <free_block>
  803919:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80391c:	b8 00 00 00 00       	mov    $0x0,%eax
  803921:	e9 cc 06 00 00       	jmp    803ff2 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803926:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80392a:	77 07                	ja     803933 <realloc_block_FF+0x5a>
  80392c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803933:	8b 45 0c             	mov    0xc(%ebp),%eax
  803936:	83 e0 01             	and    $0x1,%eax
  803939:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80393c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80393f:	83 c0 08             	add    $0x8,%eax
  803942:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803945:	83 ec 0c             	sub    $0xc,%esp
  803948:	ff 75 08             	pushl  0x8(%ebp)
  80394b:	e8 45 ec ff ff       	call   802595 <get_block_size>
  803950:	83 c4 10             	add    $0x10,%esp
  803953:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803956:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803959:	83 e8 08             	sub    $0x8,%eax
  80395c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80395f:	8b 45 08             	mov    0x8(%ebp),%eax
  803962:	83 e8 04             	sub    $0x4,%eax
  803965:	8b 00                	mov    (%eax),%eax
  803967:	83 e0 fe             	and    $0xfffffffe,%eax
  80396a:	89 c2                	mov    %eax,%edx
  80396c:	8b 45 08             	mov    0x8(%ebp),%eax
  80396f:	01 d0                	add    %edx,%eax
  803971:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803974:	83 ec 0c             	sub    $0xc,%esp
  803977:	ff 75 e4             	pushl  -0x1c(%ebp)
  80397a:	e8 16 ec ff ff       	call   802595 <get_block_size>
  80397f:	83 c4 10             	add    $0x10,%esp
  803982:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803985:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803988:	83 e8 08             	sub    $0x8,%eax
  80398b:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80398e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803991:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803994:	75 08                	jne    80399e <realloc_block_FF+0xc5>
	{
		 return va;
  803996:	8b 45 08             	mov    0x8(%ebp),%eax
  803999:	e9 54 06 00 00       	jmp    803ff2 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80399e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039a1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039a4:	0f 83 e5 03 00 00    	jae    803d8f <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8039aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ad:	2b 45 0c             	sub    0xc(%ebp),%eax
  8039b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8039b3:	83 ec 0c             	sub    $0xc,%esp
  8039b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039b9:	e8 f0 eb ff ff       	call   8025ae <is_free_block>
  8039be:	83 c4 10             	add    $0x10,%esp
  8039c1:	84 c0                	test   %al,%al
  8039c3:	0f 84 3b 01 00 00    	je     803b04 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8039c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039cf:	01 d0                	add    %edx,%eax
  8039d1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8039d4:	83 ec 04             	sub    $0x4,%esp
  8039d7:	6a 01                	push   $0x1
  8039d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8039dc:	ff 75 08             	pushl  0x8(%ebp)
  8039df:	e8 02 ef ff ff       	call   8028e6 <set_block_data>
  8039e4:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8039e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ea:	83 e8 04             	sub    $0x4,%eax
  8039ed:	8b 00                	mov    (%eax),%eax
  8039ef:	83 e0 fe             	and    $0xfffffffe,%eax
  8039f2:	89 c2                	mov    %eax,%edx
  8039f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f7:	01 d0                	add    %edx,%eax
  8039f9:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8039fc:	83 ec 04             	sub    $0x4,%esp
  8039ff:	6a 00                	push   $0x0
  803a01:	ff 75 cc             	pushl  -0x34(%ebp)
  803a04:	ff 75 c8             	pushl  -0x38(%ebp)
  803a07:	e8 da ee ff ff       	call   8028e6 <set_block_data>
  803a0c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a13:	74 06                	je     803a1b <realloc_block_FF+0x142>
  803a15:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803a19:	75 17                	jne    803a32 <realloc_block_FF+0x159>
  803a1b:	83 ec 04             	sub    $0x4,%esp
  803a1e:	68 6c 4c 80 00       	push   $0x804c6c
  803a23:	68 f6 01 00 00       	push   $0x1f6
  803a28:	68 f9 4b 80 00       	push   $0x804bf9
  803a2d:	e8 13 ce ff ff       	call   800845 <_panic>
  803a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a35:	8b 10                	mov    (%eax),%edx
  803a37:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a3a:	89 10                	mov    %edx,(%eax)
  803a3c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a3f:	8b 00                	mov    (%eax),%eax
  803a41:	85 c0                	test   %eax,%eax
  803a43:	74 0b                	je     803a50 <realloc_block_FF+0x177>
  803a45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a48:	8b 00                	mov    (%eax),%eax
  803a4a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a4d:	89 50 04             	mov    %edx,0x4(%eax)
  803a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a53:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a56:	89 10                	mov    %edx,(%eax)
  803a58:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a5e:	89 50 04             	mov    %edx,0x4(%eax)
  803a61:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a64:	8b 00                	mov    (%eax),%eax
  803a66:	85 c0                	test   %eax,%eax
  803a68:	75 08                	jne    803a72 <realloc_block_FF+0x199>
  803a6a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a6d:	a3 30 50 80 00       	mov    %eax,0x805030
  803a72:	a1 38 50 80 00       	mov    0x805038,%eax
  803a77:	40                   	inc    %eax
  803a78:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a81:	75 17                	jne    803a9a <realloc_block_FF+0x1c1>
  803a83:	83 ec 04             	sub    $0x4,%esp
  803a86:	68 db 4b 80 00       	push   $0x804bdb
  803a8b:	68 f7 01 00 00       	push   $0x1f7
  803a90:	68 f9 4b 80 00       	push   $0x804bf9
  803a95:	e8 ab cd ff ff       	call   800845 <_panic>
  803a9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a9d:	8b 00                	mov    (%eax),%eax
  803a9f:	85 c0                	test   %eax,%eax
  803aa1:	74 10                	je     803ab3 <realloc_block_FF+0x1da>
  803aa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa6:	8b 00                	mov    (%eax),%eax
  803aa8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aab:	8b 52 04             	mov    0x4(%edx),%edx
  803aae:	89 50 04             	mov    %edx,0x4(%eax)
  803ab1:	eb 0b                	jmp    803abe <realloc_block_FF+0x1e5>
  803ab3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab6:	8b 40 04             	mov    0x4(%eax),%eax
  803ab9:	a3 30 50 80 00       	mov    %eax,0x805030
  803abe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac1:	8b 40 04             	mov    0x4(%eax),%eax
  803ac4:	85 c0                	test   %eax,%eax
  803ac6:	74 0f                	je     803ad7 <realloc_block_FF+0x1fe>
  803ac8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803acb:	8b 40 04             	mov    0x4(%eax),%eax
  803ace:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ad1:	8b 12                	mov    (%edx),%edx
  803ad3:	89 10                	mov    %edx,(%eax)
  803ad5:	eb 0a                	jmp    803ae1 <realloc_block_FF+0x208>
  803ad7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ada:	8b 00                	mov    (%eax),%eax
  803adc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ae1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803af4:	a1 38 50 80 00       	mov    0x805038,%eax
  803af9:	48                   	dec    %eax
  803afa:	a3 38 50 80 00       	mov    %eax,0x805038
  803aff:	e9 83 02 00 00       	jmp    803d87 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803b04:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803b08:	0f 86 69 02 00 00    	jbe    803d77 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803b0e:	83 ec 04             	sub    $0x4,%esp
  803b11:	6a 01                	push   $0x1
  803b13:	ff 75 f0             	pushl  -0x10(%ebp)
  803b16:	ff 75 08             	pushl  0x8(%ebp)
  803b19:	e8 c8 ed ff ff       	call   8028e6 <set_block_data>
  803b1e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b21:	8b 45 08             	mov    0x8(%ebp),%eax
  803b24:	83 e8 04             	sub    $0x4,%eax
  803b27:	8b 00                	mov    (%eax),%eax
  803b29:	83 e0 fe             	and    $0xfffffffe,%eax
  803b2c:	89 c2                	mov    %eax,%edx
  803b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b31:	01 d0                	add    %edx,%eax
  803b33:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803b36:	a1 38 50 80 00       	mov    0x805038,%eax
  803b3b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803b3e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b42:	75 68                	jne    803bac <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b44:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b48:	75 17                	jne    803b61 <realloc_block_FF+0x288>
  803b4a:	83 ec 04             	sub    $0x4,%esp
  803b4d:	68 14 4c 80 00       	push   $0x804c14
  803b52:	68 06 02 00 00       	push   $0x206
  803b57:	68 f9 4b 80 00       	push   $0x804bf9
  803b5c:	e8 e4 cc ff ff       	call   800845 <_panic>
  803b61:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803b67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b6a:	89 10                	mov    %edx,(%eax)
  803b6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b6f:	8b 00                	mov    (%eax),%eax
  803b71:	85 c0                	test   %eax,%eax
  803b73:	74 0d                	je     803b82 <realloc_block_FF+0x2a9>
  803b75:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803b7a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b7d:	89 50 04             	mov    %edx,0x4(%eax)
  803b80:	eb 08                	jmp    803b8a <realloc_block_FF+0x2b1>
  803b82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b85:	a3 30 50 80 00       	mov    %eax,0x805030
  803b8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b8d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803b92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b9c:	a1 38 50 80 00       	mov    0x805038,%eax
  803ba1:	40                   	inc    %eax
  803ba2:	a3 38 50 80 00       	mov    %eax,0x805038
  803ba7:	e9 b0 01 00 00       	jmp    803d5c <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803bac:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803bb1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bb4:	76 68                	jbe    803c1e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803bb6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803bba:	75 17                	jne    803bd3 <realloc_block_FF+0x2fa>
  803bbc:	83 ec 04             	sub    $0x4,%esp
  803bbf:	68 14 4c 80 00       	push   $0x804c14
  803bc4:	68 0b 02 00 00       	push   $0x20b
  803bc9:	68 f9 4b 80 00       	push   $0x804bf9
  803bce:	e8 72 cc ff ff       	call   800845 <_panic>
  803bd3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803bd9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bdc:	89 10                	mov    %edx,(%eax)
  803bde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be1:	8b 00                	mov    (%eax),%eax
  803be3:	85 c0                	test   %eax,%eax
  803be5:	74 0d                	je     803bf4 <realloc_block_FF+0x31b>
  803be7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803bec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bef:	89 50 04             	mov    %edx,0x4(%eax)
  803bf2:	eb 08                	jmp    803bfc <realloc_block_FF+0x323>
  803bf4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bf7:	a3 30 50 80 00       	mov    %eax,0x805030
  803bfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bff:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c0e:	a1 38 50 80 00       	mov    0x805038,%eax
  803c13:	40                   	inc    %eax
  803c14:	a3 38 50 80 00       	mov    %eax,0x805038
  803c19:	e9 3e 01 00 00       	jmp    803d5c <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803c1e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803c23:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c26:	73 68                	jae    803c90 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c28:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c2c:	75 17                	jne    803c45 <realloc_block_FF+0x36c>
  803c2e:	83 ec 04             	sub    $0x4,%esp
  803c31:	68 48 4c 80 00       	push   $0x804c48
  803c36:	68 10 02 00 00       	push   $0x210
  803c3b:	68 f9 4b 80 00       	push   $0x804bf9
  803c40:	e8 00 cc ff ff       	call   800845 <_panic>
  803c45:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803c4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c4e:	89 50 04             	mov    %edx,0x4(%eax)
  803c51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c54:	8b 40 04             	mov    0x4(%eax),%eax
  803c57:	85 c0                	test   %eax,%eax
  803c59:	74 0c                	je     803c67 <realloc_block_FF+0x38e>
  803c5b:	a1 30 50 80 00       	mov    0x805030,%eax
  803c60:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c63:	89 10                	mov    %edx,(%eax)
  803c65:	eb 08                	jmp    803c6f <realloc_block_FF+0x396>
  803c67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c6a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c72:	a3 30 50 80 00       	mov    %eax,0x805030
  803c77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c80:	a1 38 50 80 00       	mov    0x805038,%eax
  803c85:	40                   	inc    %eax
  803c86:	a3 38 50 80 00       	mov    %eax,0x805038
  803c8b:	e9 cc 00 00 00       	jmp    803d5c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803c90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803c97:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803c9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c9f:	e9 8a 00 00 00       	jmp    803d2e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803caa:	73 7a                	jae    803d26 <realloc_block_FF+0x44d>
  803cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803caf:	8b 00                	mov    (%eax),%eax
  803cb1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803cb4:	73 70                	jae    803d26 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803cb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cba:	74 06                	je     803cc2 <realloc_block_FF+0x3e9>
  803cbc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cc0:	75 17                	jne    803cd9 <realloc_block_FF+0x400>
  803cc2:	83 ec 04             	sub    $0x4,%esp
  803cc5:	68 6c 4c 80 00       	push   $0x804c6c
  803cca:	68 1a 02 00 00       	push   $0x21a
  803ccf:	68 f9 4b 80 00       	push   $0x804bf9
  803cd4:	e8 6c cb ff ff       	call   800845 <_panic>
  803cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cdc:	8b 10                	mov    (%eax),%edx
  803cde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ce1:	89 10                	mov    %edx,(%eax)
  803ce3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ce6:	8b 00                	mov    (%eax),%eax
  803ce8:	85 c0                	test   %eax,%eax
  803cea:	74 0b                	je     803cf7 <realloc_block_FF+0x41e>
  803cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cef:	8b 00                	mov    (%eax),%eax
  803cf1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cf4:	89 50 04             	mov    %edx,0x4(%eax)
  803cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cfa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cfd:	89 10                	mov    %edx,(%eax)
  803cff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d05:	89 50 04             	mov    %edx,0x4(%eax)
  803d08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d0b:	8b 00                	mov    (%eax),%eax
  803d0d:	85 c0                	test   %eax,%eax
  803d0f:	75 08                	jne    803d19 <realloc_block_FF+0x440>
  803d11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d14:	a3 30 50 80 00       	mov    %eax,0x805030
  803d19:	a1 38 50 80 00       	mov    0x805038,%eax
  803d1e:	40                   	inc    %eax
  803d1f:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803d24:	eb 36                	jmp    803d5c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803d26:	a1 34 50 80 00       	mov    0x805034,%eax
  803d2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d32:	74 07                	je     803d3b <realloc_block_FF+0x462>
  803d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d37:	8b 00                	mov    (%eax),%eax
  803d39:	eb 05                	jmp    803d40 <realloc_block_FF+0x467>
  803d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  803d40:	a3 34 50 80 00       	mov    %eax,0x805034
  803d45:	a1 34 50 80 00       	mov    0x805034,%eax
  803d4a:	85 c0                	test   %eax,%eax
  803d4c:	0f 85 52 ff ff ff    	jne    803ca4 <realloc_block_FF+0x3cb>
  803d52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d56:	0f 85 48 ff ff ff    	jne    803ca4 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803d5c:	83 ec 04             	sub    $0x4,%esp
  803d5f:	6a 00                	push   $0x0
  803d61:	ff 75 d8             	pushl  -0x28(%ebp)
  803d64:	ff 75 d4             	pushl  -0x2c(%ebp)
  803d67:	e8 7a eb ff ff       	call   8028e6 <set_block_data>
  803d6c:	83 c4 10             	add    $0x10,%esp
				return va;
  803d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d72:	e9 7b 02 00 00       	jmp    803ff2 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803d77:	83 ec 0c             	sub    $0xc,%esp
  803d7a:	68 e9 4c 80 00       	push   $0x804ce9
  803d7f:	e8 7e cd ff ff       	call   800b02 <cprintf>
  803d84:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803d87:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8a:	e9 63 02 00 00       	jmp    803ff2 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d92:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d95:	0f 86 4d 02 00 00    	jbe    803fe8 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803d9b:	83 ec 0c             	sub    $0xc,%esp
  803d9e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803da1:	e8 08 e8 ff ff       	call   8025ae <is_free_block>
  803da6:	83 c4 10             	add    $0x10,%esp
  803da9:	84 c0                	test   %al,%al
  803dab:	0f 84 37 02 00 00    	je     803fe8 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803db4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803db7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803dba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803dbd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803dc0:	76 38                	jbe    803dfa <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803dc2:	83 ec 0c             	sub    $0xc,%esp
  803dc5:	ff 75 08             	pushl  0x8(%ebp)
  803dc8:	e8 0c fa ff ff       	call   8037d9 <free_block>
  803dcd:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803dd0:	83 ec 0c             	sub    $0xc,%esp
  803dd3:	ff 75 0c             	pushl  0xc(%ebp)
  803dd6:	e8 3a eb ff ff       	call   802915 <alloc_block_FF>
  803ddb:	83 c4 10             	add    $0x10,%esp
  803dde:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803de1:	83 ec 08             	sub    $0x8,%esp
  803de4:	ff 75 c0             	pushl  -0x40(%ebp)
  803de7:	ff 75 08             	pushl  0x8(%ebp)
  803dea:	e8 ab fa ff ff       	call   80389a <copy_data>
  803def:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803df2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803df5:	e9 f8 01 00 00       	jmp    803ff2 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803dfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dfd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803e00:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803e03:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803e07:	0f 87 a0 00 00 00    	ja     803ead <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803e0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e11:	75 17                	jne    803e2a <realloc_block_FF+0x551>
  803e13:	83 ec 04             	sub    $0x4,%esp
  803e16:	68 db 4b 80 00       	push   $0x804bdb
  803e1b:	68 38 02 00 00       	push   $0x238
  803e20:	68 f9 4b 80 00       	push   $0x804bf9
  803e25:	e8 1b ca ff ff       	call   800845 <_panic>
  803e2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e2d:	8b 00                	mov    (%eax),%eax
  803e2f:	85 c0                	test   %eax,%eax
  803e31:	74 10                	je     803e43 <realloc_block_FF+0x56a>
  803e33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e36:	8b 00                	mov    (%eax),%eax
  803e38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e3b:	8b 52 04             	mov    0x4(%edx),%edx
  803e3e:	89 50 04             	mov    %edx,0x4(%eax)
  803e41:	eb 0b                	jmp    803e4e <realloc_block_FF+0x575>
  803e43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e46:	8b 40 04             	mov    0x4(%eax),%eax
  803e49:	a3 30 50 80 00       	mov    %eax,0x805030
  803e4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e51:	8b 40 04             	mov    0x4(%eax),%eax
  803e54:	85 c0                	test   %eax,%eax
  803e56:	74 0f                	je     803e67 <realloc_block_FF+0x58e>
  803e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e5b:	8b 40 04             	mov    0x4(%eax),%eax
  803e5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e61:	8b 12                	mov    (%edx),%edx
  803e63:	89 10                	mov    %edx,(%eax)
  803e65:	eb 0a                	jmp    803e71 <realloc_block_FF+0x598>
  803e67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e6a:	8b 00                	mov    (%eax),%eax
  803e6c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803e71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e84:	a1 38 50 80 00       	mov    0x805038,%eax
  803e89:	48                   	dec    %eax
  803e8a:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803e8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e95:	01 d0                	add    %edx,%eax
  803e97:	83 ec 04             	sub    $0x4,%esp
  803e9a:	6a 01                	push   $0x1
  803e9c:	50                   	push   %eax
  803e9d:	ff 75 08             	pushl  0x8(%ebp)
  803ea0:	e8 41 ea ff ff       	call   8028e6 <set_block_data>
  803ea5:	83 c4 10             	add    $0x10,%esp
  803ea8:	e9 36 01 00 00       	jmp    803fe3 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803ead:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803eb0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803eb3:	01 d0                	add    %edx,%eax
  803eb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803eb8:	83 ec 04             	sub    $0x4,%esp
  803ebb:	6a 01                	push   $0x1
  803ebd:	ff 75 f0             	pushl  -0x10(%ebp)
  803ec0:	ff 75 08             	pushl  0x8(%ebp)
  803ec3:	e8 1e ea ff ff       	call   8028e6 <set_block_data>
  803ec8:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ece:	83 e8 04             	sub    $0x4,%eax
  803ed1:	8b 00                	mov    (%eax),%eax
  803ed3:	83 e0 fe             	and    $0xfffffffe,%eax
  803ed6:	89 c2                	mov    %eax,%edx
  803ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  803edb:	01 d0                	add    %edx,%eax
  803edd:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803ee0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ee4:	74 06                	je     803eec <realloc_block_FF+0x613>
  803ee6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803eea:	75 17                	jne    803f03 <realloc_block_FF+0x62a>
  803eec:	83 ec 04             	sub    $0x4,%esp
  803eef:	68 6c 4c 80 00       	push   $0x804c6c
  803ef4:	68 44 02 00 00       	push   $0x244
  803ef9:	68 f9 4b 80 00       	push   $0x804bf9
  803efe:	e8 42 c9 ff ff       	call   800845 <_panic>
  803f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f06:	8b 10                	mov    (%eax),%edx
  803f08:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f0b:	89 10                	mov    %edx,(%eax)
  803f0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f10:	8b 00                	mov    (%eax),%eax
  803f12:	85 c0                	test   %eax,%eax
  803f14:	74 0b                	je     803f21 <realloc_block_FF+0x648>
  803f16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f19:	8b 00                	mov    (%eax),%eax
  803f1b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f1e:	89 50 04             	mov    %edx,0x4(%eax)
  803f21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f24:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f27:	89 10                	mov    %edx,(%eax)
  803f29:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f2f:	89 50 04             	mov    %edx,0x4(%eax)
  803f32:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f35:	8b 00                	mov    (%eax),%eax
  803f37:	85 c0                	test   %eax,%eax
  803f39:	75 08                	jne    803f43 <realloc_block_FF+0x66a>
  803f3b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f3e:	a3 30 50 80 00       	mov    %eax,0x805030
  803f43:	a1 38 50 80 00       	mov    0x805038,%eax
  803f48:	40                   	inc    %eax
  803f49:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803f4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f52:	75 17                	jne    803f6b <realloc_block_FF+0x692>
  803f54:	83 ec 04             	sub    $0x4,%esp
  803f57:	68 db 4b 80 00       	push   $0x804bdb
  803f5c:	68 45 02 00 00       	push   $0x245
  803f61:	68 f9 4b 80 00       	push   $0x804bf9
  803f66:	e8 da c8 ff ff       	call   800845 <_panic>
  803f6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f6e:	8b 00                	mov    (%eax),%eax
  803f70:	85 c0                	test   %eax,%eax
  803f72:	74 10                	je     803f84 <realloc_block_FF+0x6ab>
  803f74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f77:	8b 00                	mov    (%eax),%eax
  803f79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f7c:	8b 52 04             	mov    0x4(%edx),%edx
  803f7f:	89 50 04             	mov    %edx,0x4(%eax)
  803f82:	eb 0b                	jmp    803f8f <realloc_block_FF+0x6b6>
  803f84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f87:	8b 40 04             	mov    0x4(%eax),%eax
  803f8a:	a3 30 50 80 00       	mov    %eax,0x805030
  803f8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f92:	8b 40 04             	mov    0x4(%eax),%eax
  803f95:	85 c0                	test   %eax,%eax
  803f97:	74 0f                	je     803fa8 <realloc_block_FF+0x6cf>
  803f99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f9c:	8b 40 04             	mov    0x4(%eax),%eax
  803f9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fa2:	8b 12                	mov    (%edx),%edx
  803fa4:	89 10                	mov    %edx,(%eax)
  803fa6:	eb 0a                	jmp    803fb2 <realloc_block_FF+0x6d9>
  803fa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fab:	8b 00                	mov    (%eax),%eax
  803fad:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803fb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fc5:	a1 38 50 80 00       	mov    0x805038,%eax
  803fca:	48                   	dec    %eax
  803fcb:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803fd0:	83 ec 04             	sub    $0x4,%esp
  803fd3:	6a 00                	push   $0x0
  803fd5:	ff 75 bc             	pushl  -0x44(%ebp)
  803fd8:	ff 75 b8             	pushl  -0x48(%ebp)
  803fdb:	e8 06 e9 ff ff       	call   8028e6 <set_block_data>
  803fe0:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe6:	eb 0a                	jmp    803ff2 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803fe8:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803fef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803ff2:	c9                   	leave  
  803ff3:	c3                   	ret    

00803ff4 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803ff4:	55                   	push   %ebp
  803ff5:	89 e5                	mov    %esp,%ebp
  803ff7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803ffa:	83 ec 04             	sub    $0x4,%esp
  803ffd:	68 f0 4c 80 00       	push   $0x804cf0
  804002:	68 58 02 00 00       	push   $0x258
  804007:	68 f9 4b 80 00       	push   $0x804bf9
  80400c:	e8 34 c8 ff ff       	call   800845 <_panic>

00804011 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804011:	55                   	push   %ebp
  804012:	89 e5                	mov    %esp,%ebp
  804014:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804017:	83 ec 04             	sub    $0x4,%esp
  80401a:	68 18 4d 80 00       	push   $0x804d18
  80401f:	68 61 02 00 00       	push   $0x261
  804024:	68 f9 4b 80 00       	push   $0x804bf9
  804029:	e8 17 c8 ff ff       	call   800845 <_panic>
  80402e:	66 90                	xchg   %ax,%ax

00804030 <__udivdi3>:
  804030:	55                   	push   %ebp
  804031:	57                   	push   %edi
  804032:	56                   	push   %esi
  804033:	53                   	push   %ebx
  804034:	83 ec 1c             	sub    $0x1c,%esp
  804037:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80403b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80403f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804043:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804047:	89 ca                	mov    %ecx,%edx
  804049:	89 f8                	mov    %edi,%eax
  80404b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80404f:	85 f6                	test   %esi,%esi
  804051:	75 2d                	jne    804080 <__udivdi3+0x50>
  804053:	39 cf                	cmp    %ecx,%edi
  804055:	77 65                	ja     8040bc <__udivdi3+0x8c>
  804057:	89 fd                	mov    %edi,%ebp
  804059:	85 ff                	test   %edi,%edi
  80405b:	75 0b                	jne    804068 <__udivdi3+0x38>
  80405d:	b8 01 00 00 00       	mov    $0x1,%eax
  804062:	31 d2                	xor    %edx,%edx
  804064:	f7 f7                	div    %edi
  804066:	89 c5                	mov    %eax,%ebp
  804068:	31 d2                	xor    %edx,%edx
  80406a:	89 c8                	mov    %ecx,%eax
  80406c:	f7 f5                	div    %ebp
  80406e:	89 c1                	mov    %eax,%ecx
  804070:	89 d8                	mov    %ebx,%eax
  804072:	f7 f5                	div    %ebp
  804074:	89 cf                	mov    %ecx,%edi
  804076:	89 fa                	mov    %edi,%edx
  804078:	83 c4 1c             	add    $0x1c,%esp
  80407b:	5b                   	pop    %ebx
  80407c:	5e                   	pop    %esi
  80407d:	5f                   	pop    %edi
  80407e:	5d                   	pop    %ebp
  80407f:	c3                   	ret    
  804080:	39 ce                	cmp    %ecx,%esi
  804082:	77 28                	ja     8040ac <__udivdi3+0x7c>
  804084:	0f bd fe             	bsr    %esi,%edi
  804087:	83 f7 1f             	xor    $0x1f,%edi
  80408a:	75 40                	jne    8040cc <__udivdi3+0x9c>
  80408c:	39 ce                	cmp    %ecx,%esi
  80408e:	72 0a                	jb     80409a <__udivdi3+0x6a>
  804090:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804094:	0f 87 9e 00 00 00    	ja     804138 <__udivdi3+0x108>
  80409a:	b8 01 00 00 00       	mov    $0x1,%eax
  80409f:	89 fa                	mov    %edi,%edx
  8040a1:	83 c4 1c             	add    $0x1c,%esp
  8040a4:	5b                   	pop    %ebx
  8040a5:	5e                   	pop    %esi
  8040a6:	5f                   	pop    %edi
  8040a7:	5d                   	pop    %ebp
  8040a8:	c3                   	ret    
  8040a9:	8d 76 00             	lea    0x0(%esi),%esi
  8040ac:	31 ff                	xor    %edi,%edi
  8040ae:	31 c0                	xor    %eax,%eax
  8040b0:	89 fa                	mov    %edi,%edx
  8040b2:	83 c4 1c             	add    $0x1c,%esp
  8040b5:	5b                   	pop    %ebx
  8040b6:	5e                   	pop    %esi
  8040b7:	5f                   	pop    %edi
  8040b8:	5d                   	pop    %ebp
  8040b9:	c3                   	ret    
  8040ba:	66 90                	xchg   %ax,%ax
  8040bc:	89 d8                	mov    %ebx,%eax
  8040be:	f7 f7                	div    %edi
  8040c0:	31 ff                	xor    %edi,%edi
  8040c2:	89 fa                	mov    %edi,%edx
  8040c4:	83 c4 1c             	add    $0x1c,%esp
  8040c7:	5b                   	pop    %ebx
  8040c8:	5e                   	pop    %esi
  8040c9:	5f                   	pop    %edi
  8040ca:	5d                   	pop    %ebp
  8040cb:	c3                   	ret    
  8040cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040d1:	89 eb                	mov    %ebp,%ebx
  8040d3:	29 fb                	sub    %edi,%ebx
  8040d5:	89 f9                	mov    %edi,%ecx
  8040d7:	d3 e6                	shl    %cl,%esi
  8040d9:	89 c5                	mov    %eax,%ebp
  8040db:	88 d9                	mov    %bl,%cl
  8040dd:	d3 ed                	shr    %cl,%ebp
  8040df:	89 e9                	mov    %ebp,%ecx
  8040e1:	09 f1                	or     %esi,%ecx
  8040e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040e7:	89 f9                	mov    %edi,%ecx
  8040e9:	d3 e0                	shl    %cl,%eax
  8040eb:	89 c5                	mov    %eax,%ebp
  8040ed:	89 d6                	mov    %edx,%esi
  8040ef:	88 d9                	mov    %bl,%cl
  8040f1:	d3 ee                	shr    %cl,%esi
  8040f3:	89 f9                	mov    %edi,%ecx
  8040f5:	d3 e2                	shl    %cl,%edx
  8040f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040fb:	88 d9                	mov    %bl,%cl
  8040fd:	d3 e8                	shr    %cl,%eax
  8040ff:	09 c2                	or     %eax,%edx
  804101:	89 d0                	mov    %edx,%eax
  804103:	89 f2                	mov    %esi,%edx
  804105:	f7 74 24 0c          	divl   0xc(%esp)
  804109:	89 d6                	mov    %edx,%esi
  80410b:	89 c3                	mov    %eax,%ebx
  80410d:	f7 e5                	mul    %ebp
  80410f:	39 d6                	cmp    %edx,%esi
  804111:	72 19                	jb     80412c <__udivdi3+0xfc>
  804113:	74 0b                	je     804120 <__udivdi3+0xf0>
  804115:	89 d8                	mov    %ebx,%eax
  804117:	31 ff                	xor    %edi,%edi
  804119:	e9 58 ff ff ff       	jmp    804076 <__udivdi3+0x46>
  80411e:	66 90                	xchg   %ax,%ax
  804120:	8b 54 24 08          	mov    0x8(%esp),%edx
  804124:	89 f9                	mov    %edi,%ecx
  804126:	d3 e2                	shl    %cl,%edx
  804128:	39 c2                	cmp    %eax,%edx
  80412a:	73 e9                	jae    804115 <__udivdi3+0xe5>
  80412c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80412f:	31 ff                	xor    %edi,%edi
  804131:	e9 40 ff ff ff       	jmp    804076 <__udivdi3+0x46>
  804136:	66 90                	xchg   %ax,%ax
  804138:	31 c0                	xor    %eax,%eax
  80413a:	e9 37 ff ff ff       	jmp    804076 <__udivdi3+0x46>
  80413f:	90                   	nop

00804140 <__umoddi3>:
  804140:	55                   	push   %ebp
  804141:	57                   	push   %edi
  804142:	56                   	push   %esi
  804143:	53                   	push   %ebx
  804144:	83 ec 1c             	sub    $0x1c,%esp
  804147:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80414b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80414f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804153:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804157:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80415b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80415f:	89 f3                	mov    %esi,%ebx
  804161:	89 fa                	mov    %edi,%edx
  804163:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804167:	89 34 24             	mov    %esi,(%esp)
  80416a:	85 c0                	test   %eax,%eax
  80416c:	75 1a                	jne    804188 <__umoddi3+0x48>
  80416e:	39 f7                	cmp    %esi,%edi
  804170:	0f 86 a2 00 00 00    	jbe    804218 <__umoddi3+0xd8>
  804176:	89 c8                	mov    %ecx,%eax
  804178:	89 f2                	mov    %esi,%edx
  80417a:	f7 f7                	div    %edi
  80417c:	89 d0                	mov    %edx,%eax
  80417e:	31 d2                	xor    %edx,%edx
  804180:	83 c4 1c             	add    $0x1c,%esp
  804183:	5b                   	pop    %ebx
  804184:	5e                   	pop    %esi
  804185:	5f                   	pop    %edi
  804186:	5d                   	pop    %ebp
  804187:	c3                   	ret    
  804188:	39 f0                	cmp    %esi,%eax
  80418a:	0f 87 ac 00 00 00    	ja     80423c <__umoddi3+0xfc>
  804190:	0f bd e8             	bsr    %eax,%ebp
  804193:	83 f5 1f             	xor    $0x1f,%ebp
  804196:	0f 84 ac 00 00 00    	je     804248 <__umoddi3+0x108>
  80419c:	bf 20 00 00 00       	mov    $0x20,%edi
  8041a1:	29 ef                	sub    %ebp,%edi
  8041a3:	89 fe                	mov    %edi,%esi
  8041a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8041a9:	89 e9                	mov    %ebp,%ecx
  8041ab:	d3 e0                	shl    %cl,%eax
  8041ad:	89 d7                	mov    %edx,%edi
  8041af:	89 f1                	mov    %esi,%ecx
  8041b1:	d3 ef                	shr    %cl,%edi
  8041b3:	09 c7                	or     %eax,%edi
  8041b5:	89 e9                	mov    %ebp,%ecx
  8041b7:	d3 e2                	shl    %cl,%edx
  8041b9:	89 14 24             	mov    %edx,(%esp)
  8041bc:	89 d8                	mov    %ebx,%eax
  8041be:	d3 e0                	shl    %cl,%eax
  8041c0:	89 c2                	mov    %eax,%edx
  8041c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041c6:	d3 e0                	shl    %cl,%eax
  8041c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041d0:	89 f1                	mov    %esi,%ecx
  8041d2:	d3 e8                	shr    %cl,%eax
  8041d4:	09 d0                	or     %edx,%eax
  8041d6:	d3 eb                	shr    %cl,%ebx
  8041d8:	89 da                	mov    %ebx,%edx
  8041da:	f7 f7                	div    %edi
  8041dc:	89 d3                	mov    %edx,%ebx
  8041de:	f7 24 24             	mull   (%esp)
  8041e1:	89 c6                	mov    %eax,%esi
  8041e3:	89 d1                	mov    %edx,%ecx
  8041e5:	39 d3                	cmp    %edx,%ebx
  8041e7:	0f 82 87 00 00 00    	jb     804274 <__umoddi3+0x134>
  8041ed:	0f 84 91 00 00 00    	je     804284 <__umoddi3+0x144>
  8041f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8041f7:	29 f2                	sub    %esi,%edx
  8041f9:	19 cb                	sbb    %ecx,%ebx
  8041fb:	89 d8                	mov    %ebx,%eax
  8041fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804201:	d3 e0                	shl    %cl,%eax
  804203:	89 e9                	mov    %ebp,%ecx
  804205:	d3 ea                	shr    %cl,%edx
  804207:	09 d0                	or     %edx,%eax
  804209:	89 e9                	mov    %ebp,%ecx
  80420b:	d3 eb                	shr    %cl,%ebx
  80420d:	89 da                	mov    %ebx,%edx
  80420f:	83 c4 1c             	add    $0x1c,%esp
  804212:	5b                   	pop    %ebx
  804213:	5e                   	pop    %esi
  804214:	5f                   	pop    %edi
  804215:	5d                   	pop    %ebp
  804216:	c3                   	ret    
  804217:	90                   	nop
  804218:	89 fd                	mov    %edi,%ebp
  80421a:	85 ff                	test   %edi,%edi
  80421c:	75 0b                	jne    804229 <__umoddi3+0xe9>
  80421e:	b8 01 00 00 00       	mov    $0x1,%eax
  804223:	31 d2                	xor    %edx,%edx
  804225:	f7 f7                	div    %edi
  804227:	89 c5                	mov    %eax,%ebp
  804229:	89 f0                	mov    %esi,%eax
  80422b:	31 d2                	xor    %edx,%edx
  80422d:	f7 f5                	div    %ebp
  80422f:	89 c8                	mov    %ecx,%eax
  804231:	f7 f5                	div    %ebp
  804233:	89 d0                	mov    %edx,%eax
  804235:	e9 44 ff ff ff       	jmp    80417e <__umoddi3+0x3e>
  80423a:	66 90                	xchg   %ax,%ax
  80423c:	89 c8                	mov    %ecx,%eax
  80423e:	89 f2                	mov    %esi,%edx
  804240:	83 c4 1c             	add    $0x1c,%esp
  804243:	5b                   	pop    %ebx
  804244:	5e                   	pop    %esi
  804245:	5f                   	pop    %edi
  804246:	5d                   	pop    %ebp
  804247:	c3                   	ret    
  804248:	3b 04 24             	cmp    (%esp),%eax
  80424b:	72 06                	jb     804253 <__umoddi3+0x113>
  80424d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804251:	77 0f                	ja     804262 <__umoddi3+0x122>
  804253:	89 f2                	mov    %esi,%edx
  804255:	29 f9                	sub    %edi,%ecx
  804257:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80425b:	89 14 24             	mov    %edx,(%esp)
  80425e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804262:	8b 44 24 04          	mov    0x4(%esp),%eax
  804266:	8b 14 24             	mov    (%esp),%edx
  804269:	83 c4 1c             	add    $0x1c,%esp
  80426c:	5b                   	pop    %ebx
  80426d:	5e                   	pop    %esi
  80426e:	5f                   	pop    %edi
  80426f:	5d                   	pop    %ebp
  804270:	c3                   	ret    
  804271:	8d 76 00             	lea    0x0(%esi),%esi
  804274:	2b 04 24             	sub    (%esp),%eax
  804277:	19 fa                	sbb    %edi,%edx
  804279:	89 d1                	mov    %edx,%ecx
  80427b:	89 c6                	mov    %eax,%esi
  80427d:	e9 71 ff ff ff       	jmp    8041f3 <__umoddi3+0xb3>
  804282:	66 90                	xchg   %ax,%ax
  804284:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804288:	72 ea                	jb     804274 <__umoddi3+0x134>
  80428a:	89 d9                	mov    %ebx,%ecx
  80428c:	e9 62 ff ff ff       	jmp    8041f3 <__umoddi3+0xb3>
