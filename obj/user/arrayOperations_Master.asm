
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
  800031:	e8 4d 07 00 00       	call   800783 <libmain>
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
  80003b:	81 ec 98 00 00 00    	sub    $0x98,%esp
	/*[1] CREATE SEMAPHORES*/
	struct semaphore ready = create_semaphore("Ready", 0);
  800041:	8d 45 98             	lea    -0x68(%ebp),%eax
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 00                	push   $0x0
  800049:	68 c0 45 80 00       	push   $0x8045c0
  80004e:	50                   	push   %eax
  80004f:	e8 2b 41 00 00       	call   80417f <create_semaphore>
  800054:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = create_semaphore("Finished", 0);
  800057:	8d 45 94             	lea    -0x6c(%ebp),%eax
  80005a:	83 ec 04             	sub    $0x4,%esp
  80005d:	6a 00                	push   $0x0
  80005f:	68 c6 45 80 00       	push   $0x8045c6
  800064:	50                   	push   %eax
  800065:	e8 15 41 00 00       	call   80417f <create_semaphore>
  80006a:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cons_mutex = create_semaphore("Console Mutex", 1);
  80006d:	8d 45 90             	lea    -0x70(%ebp),%eax
  800070:	83 ec 04             	sub    $0x4,%esp
  800073:	6a 01                	push   $0x1
  800075:	68 cf 45 80 00       	push   $0x8045cf
  80007a:	50                   	push   %eax
  80007b:	e8 ff 40 00 00       	call   80417f <create_semaphore>
  800080:	83 c4 0c             	add    $0xc,%esp

	/*[2] RUN THE SLAVES PROGRAMS*/
	int numOfSlaveProgs = 3 ;
  800083:	c7 45 ec 03 00 00 00 	movl   $0x3,-0x14(%ebp)

	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  80008a:	a1 20 60 80 00       	mov    0x806020,%eax
  80008f:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800095:	a1 20 60 80 00       	mov    0x806020,%eax
  80009a:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000a0:	89 c1                	mov    %eax,%ecx
  8000a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8000a7:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000ad:	52                   	push   %edx
  8000ae:	51                   	push   %ecx
  8000af:	50                   	push   %eax
  8000b0:	68 dd 45 80 00       	push   $0x8045dd
  8000b5:	e8 15 22 00 00       	call   8022cf <sys_create_env>
  8000ba:	83 c4 10             	add    $0x10,%esp
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000c0:	a1 20 60 80 00       	mov    0x806020,%eax
  8000c5:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8000cb:	a1 20 60 80 00       	mov    0x806020,%eax
  8000d0:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000d6:	89 c1                	mov    %eax,%ecx
  8000d8:	a1 20 60 80 00       	mov    0x806020,%eax
  8000dd:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000e3:	52                   	push   %edx
  8000e4:	51                   	push   %ecx
  8000e5:	50                   	push   %eax
  8000e6:	68 e6 45 80 00       	push   $0x8045e6
  8000eb:	e8 df 21 00 00       	call   8022cf <sys_create_env>
  8000f0:	83 c4 10             	add    $0x10,%esp
  8000f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000f6:	a1 20 60 80 00       	mov    0x806020,%eax
  8000fb:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800101:	a1 20 60 80 00       	mov    0x806020,%eax
  800106:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80010c:	89 c1                	mov    %eax,%ecx
  80010e:	a1 20 60 80 00       	mov    0x806020,%eax
  800113:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800119:	52                   	push   %edx
  80011a:	51                   	push   %ecx
  80011b:	50                   	push   %eax
  80011c:	68 ef 45 80 00       	push   $0x8045ef
  800121:	e8 a9 21 00 00       	call   8022cf <sys_create_env>
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (envIdQuickSort == E_ENV_CREATION_ERROR || envIdMergeSort == E_ENV_CREATION_ERROR || envIdStats == E_ENV_CREATION_ERROR)
  80012c:	83 7d e8 ef          	cmpl   $0xffffffef,-0x18(%ebp)
  800130:	74 0c                	je     80013e <_main+0x106>
  800132:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800136:	74 06                	je     80013e <_main+0x106>
  800138:	83 7d e0 ef          	cmpl   $0xffffffef,-0x20(%ebp)
  80013c:	75 14                	jne    800152 <_main+0x11a>
		panic("NO AVAILABLE ENVs...");
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	68 fb 45 80 00       	push   $0x8045fb
  800146:	6a 1a                	push   $0x1a
  800148:	68 10 46 80 00       	push   $0x804610
  80014d:	e8 70 07 00 00       	call   8008c2 <_panic>

	sys_run_env(envIdQuickSort);
  800152:	83 ec 0c             	sub    $0xc,%esp
  800155:	ff 75 e8             	pushl  -0x18(%ebp)
  800158:	e8 90 21 00 00       	call   8022ed <sys_run_env>
  80015d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	ff 75 e4             	pushl  -0x1c(%ebp)
  800166:	e8 82 21 00 00       	call   8022ed <sys_run_env>
  80016b:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	ff 75 e0             	pushl  -0x20(%ebp)
  800174:	e8 74 21 00 00       	call   8022ed <sys_run_env>
  800179:	83 c4 10             	add    $0x10,%esp
	/*[3] CREATE SHARED ARRAY*/
	int ret;
	char Chose;
	char Line[30];
	int NumOfElements;
	int *Elements = NULL;
  80017c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	//lock the console
	wait_semaphore(cons_mutex);
  800183:	83 ec 0c             	sub    $0xc,%esp
  800186:	ff 75 90             	pushl  -0x70(%ebp)
  800189:	e8 b0 40 00 00       	call   80423e <wait_semaphore>
  80018e:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("\n");
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	68 2e 46 80 00       	push   $0x80462e
  800199:	e8 e1 09 00 00       	call   800b7f <cprintf>
  80019e:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	68 30 46 80 00       	push   $0x804630
  8001a9:	e8 d1 09 00 00       	call   800b7f <cprintf>
  8001ae:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 4e 46 80 00       	push   $0x80464e
  8001b9:	e8 c1 09 00 00       	call   800b7f <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8001c1:	83 ec 0c             	sub    $0xc,%esp
  8001c4:	68 30 46 80 00       	push   $0x804630
  8001c9:	e8 b1 09 00 00       	call   800b7f <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	68 2e 46 80 00       	push   $0x80462e
  8001d9:	e8 a1 09 00 00       	call   800b7f <cprintf>
  8001de:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	8d 85 72 ff ff ff    	lea    -0x8e(%ebp),%eax
  8001ea:	50                   	push   %eax
  8001eb:	68 6c 46 80 00       	push   $0x80466c
  8001f0:	e8 1e 10 00 00       	call   801213 <readline>
  8001f5:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8001f8:	83 ec 04             	sub    $0x4,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	6a 04                	push   $0x4
  8001ff:	68 8b 46 80 00       	push   $0x80468b
  800204:	e8 4c 1c 00 00       	call   801e55 <smalloc>
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	6a 0a                	push   $0xa
  800214:	6a 00                	push   $0x0
  800216:	8d 85 72 ff ff ff    	lea    -0x8e(%ebp),%eax
  80021c:	50                   	push   %eax
  80021d:	e8 59 15 00 00       	call   80177b <strtol>
  800222:	83 c4 10             	add    $0x10,%esp
  800225:	89 c2                	mov    %eax,%edx
  800227:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80022a:	89 10                	mov    %edx,(%eax)
		NumOfElements = *arrSize;
  80022c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80022f:	8b 00                	mov    (%eax),%eax
  800231:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  800234:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800237:	c1 e0 02             	shl    $0x2,%eax
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	6a 00                	push   $0x0
  80023f:	50                   	push   %eax
  800240:	68 93 46 80 00       	push   $0x804693
  800245:	e8 0b 1c 00 00       	call   801e55 <smalloc>
  80024a:	83 c4 10             	add    $0x10,%esp
  80024d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		cprintf("Chose the initialization method:\n") ;
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	68 98 46 80 00       	push   $0x804698
  800258:	e8 22 09 00 00       	call   800b7f <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 ba 46 80 00       	push   $0x8046ba
  800268:	e8 12 09 00 00       	call   800b7f <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 c8 46 80 00       	push   $0x8046c8
  800278:	e8 02 09 00 00       	call   800b7f <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	68 d7 46 80 00       	push   $0x8046d7
  800288:	e8 f2 08 00 00       	call   800b7f <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 e7 46 80 00       	push   $0x8046e7
  800298:	e8 e2 08 00 00       	call   800b7f <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8002a0:	e8 c1 04 00 00       	call   800766 <getchar>
  8002a5:	88 45 d3             	mov    %al,-0x2d(%ebp)
			cputchar(Chose);
  8002a8:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8002ac:	83 ec 0c             	sub    $0xc,%esp
  8002af:	50                   	push   %eax
  8002b0:	e8 92 04 00 00       	call   800747 <cputchar>
  8002b5:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	6a 0a                	push   $0xa
  8002bd:	e8 85 04 00 00       	call   800747 <cputchar>
  8002c2:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  8002c5:	80 7d d3 61          	cmpb   $0x61,-0x2d(%ebp)
  8002c9:	74 0c                	je     8002d7 <_main+0x29f>
  8002cb:	80 7d d3 62          	cmpb   $0x62,-0x2d(%ebp)
  8002cf:	74 06                	je     8002d7 <_main+0x29f>
  8002d1:	80 7d d3 63          	cmpb   $0x63,-0x2d(%ebp)
  8002d5:	75 b9                	jne    800290 <_main+0x258>

	}
	signal_semaphore(cons_mutex);
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	ff 75 90             	pushl  -0x70(%ebp)
  8002dd:	e8 de 3f 00 00       	call   8042c0 <signal_semaphore>
  8002e2:	83 c4 10             	add    $0x10,%esp
	//unlock the console

	int  i ;
	switch (Chose)
  8002e5:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8002e9:	83 f8 62             	cmp    $0x62,%eax
  8002ec:	74 1d                	je     80030b <_main+0x2d3>
  8002ee:	83 f8 63             	cmp    $0x63,%eax
  8002f1:	74 2b                	je     80031e <_main+0x2e6>
  8002f3:	83 f8 61             	cmp    $0x61,%eax
  8002f6:	75 39                	jne    800331 <_main+0x2f9>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  8002f8:	83 ec 08             	sub    $0x8,%esp
  8002fb:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002fe:	ff 75 dc             	pushl  -0x24(%ebp)
  800301:	e8 c7 02 00 00       	call   8005cd <InitializeAscending>
  800306:	83 c4 10             	add    $0x10,%esp
		break ;
  800309:	eb 37                	jmp    800342 <_main+0x30a>
	case 'b':
		InitializeIdentical(Elements, NumOfElements);
  80030b:	83 ec 08             	sub    $0x8,%esp
  80030e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800311:	ff 75 dc             	pushl  -0x24(%ebp)
  800314:	e8 e5 02 00 00       	call   8005fe <InitializeIdentical>
  800319:	83 c4 10             	add    $0x10,%esp
		break ;
  80031c:	eb 24                	jmp    800342 <_main+0x30a>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  80031e:	83 ec 08             	sub    $0x8,%esp
  800321:	ff 75 d4             	pushl  -0x2c(%ebp)
  800324:	ff 75 dc             	pushl  -0x24(%ebp)
  800327:	e8 07 03 00 00       	call   800633 <InitializeSemiRandom>
  80032c:	83 c4 10             	add    $0x10,%esp
		break ;
  80032f:	eb 11                	jmp    800342 <_main+0x30a>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  800331:	83 ec 08             	sub    $0x8,%esp
  800334:	ff 75 d4             	pushl  -0x2c(%ebp)
  800337:	ff 75 dc             	pushl  -0x24(%ebp)
  80033a:	e8 f4 02 00 00       	call   800633 <InitializeSemiRandom>
  80033f:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] SIGNAL READY TO THE SLAVES*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  800342:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800349:	eb 11                	jmp    80035c <_main+0x324>
		signal_semaphore(ready);
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	ff 75 98             	pushl  -0x68(%ebp)
  800351:	e8 6a 3f 00 00       	call   8042c0 <signal_semaphore>
  800356:	83 c4 10             	add    $0x10,%esp
	default:
		InitializeSemiRandom(Elements, NumOfElements);
	}

	/*[4] SIGNAL READY TO THE SLAVES*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  800359:	ff 45 f4             	incl   -0xc(%ebp)
  80035c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800362:	7c e7                	jl     80034b <_main+0x313>
		signal_semaphore(ready);
	}

	/*[5] WAIT TILL ALL SLAVES FINISHED*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  800364:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036b:	eb 11                	jmp    80037e <_main+0x346>
		wait_semaphore(finished);
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	ff 75 94             	pushl  -0x6c(%ebp)
  800373:	e8 c6 3e 00 00       	call   80423e <wait_semaphore>
  800378:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < numOfSlaveProgs; ++i) {
		signal_semaphore(ready);
	}

	/*[5] WAIT TILL ALL SLAVES FINISHED*/
	for (int i = 0; i < numOfSlaveProgs; ++i) {
  80037b:	ff 45 f0             	incl   -0x10(%ebp)
  80037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800381:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800384:	7c e7                	jl     80036d <_main+0x335>
		wait_semaphore(finished);
	}

	/*[6] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  800386:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	int *mergesortedArr = NULL;
  80038d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	int *mean = NULL;
  800394:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	int *var = NULL;
  80039b:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
	int *min = NULL;
  8003a2:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int *max = NULL;
  8003a9:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	int *med = NULL;
  8003b0:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  8003b7:	83 ec 08             	sub    $0x8,%esp
  8003ba:	68 f0 46 80 00       	push   $0x8046f0
  8003bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8003c2:	e8 33 1b 00 00       	call   801efa <sget>
  8003c7:	83 c4 10             	add    $0x10,%esp
  8003ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  8003cd:	83 ec 08             	sub    $0x8,%esp
  8003d0:	68 ff 46 80 00       	push   $0x8046ff
  8003d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003d8:	e8 1d 1b 00 00       	call   801efa <sget>
  8003dd:	83 c4 10             	add    $0x10,%esp
  8003e0:	89 45 c8             	mov    %eax,-0x38(%ebp)
	mean = sget(envIdStats, "mean") ;
  8003e3:	83 ec 08             	sub    $0x8,%esp
  8003e6:	68 0e 47 80 00       	push   $0x80470e
  8003eb:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ee:	e8 07 1b 00 00       	call   801efa <sget>
  8003f3:	83 c4 10             	add    $0x10,%esp
  8003f6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	var = sget(envIdStats,"var") ;
  8003f9:	83 ec 08             	sub    $0x8,%esp
  8003fc:	68 13 47 80 00       	push   $0x804713
  800401:	ff 75 e0             	pushl  -0x20(%ebp)
  800404:	e8 f1 1a 00 00       	call   801efa <sget>
  800409:	83 c4 10             	add    $0x10,%esp
  80040c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	min = sget(envIdStats,"min") ;
  80040f:	83 ec 08             	sub    $0x8,%esp
  800412:	68 17 47 80 00       	push   $0x804717
  800417:	ff 75 e0             	pushl  -0x20(%ebp)
  80041a:	e8 db 1a 00 00       	call   801efa <sget>
  80041f:	83 c4 10             	add    $0x10,%esp
  800422:	89 45 bc             	mov    %eax,-0x44(%ebp)
	max = sget(envIdStats,"max") ;
  800425:	83 ec 08             	sub    $0x8,%esp
  800428:	68 1b 47 80 00       	push   $0x80471b
  80042d:	ff 75 e0             	pushl  -0x20(%ebp)
  800430:	e8 c5 1a 00 00       	call   801efa <sget>
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	89 45 b8             	mov    %eax,-0x48(%ebp)
	med = sget(envIdStats,"med") ;
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	68 1f 47 80 00       	push   $0x80471f
  800443:	ff 75 e0             	pushl  -0x20(%ebp)
  800446:	e8 af 1a 00 00       	call   801efa <sget>
  80044b:	83 c4 10             	add    $0x10,%esp
  80044e:	89 45 b4             	mov    %eax,-0x4c(%ebp)

	/*[7] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  800451:	83 ec 08             	sub    $0x8,%esp
  800454:	ff 75 d4             	pushl  -0x2c(%ebp)
  800457:	ff 75 cc             	pushl  -0x34(%ebp)
  80045a:	e8 17 01 00 00       	call   800576 <CheckSorted>
  80045f:	83 c4 10             	add    $0x10,%esp
  800462:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  800465:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  800469:	75 14                	jne    80047f <_main+0x447>
  80046b:	83 ec 04             	sub    $0x4,%esp
  80046e:	68 24 47 80 00       	push   $0x804724
  800473:	6a 73                	push   $0x73
  800475:	68 10 46 80 00       	push   $0x804610
  80047a:	e8 43 04 00 00       	call   8008c2 <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	ff 75 d4             	pushl  -0x2c(%ebp)
  800485:	ff 75 c8             	pushl  -0x38(%ebp)
  800488:	e8 e9 00 00 00       	call   800576 <CheckSorted>
  80048d:	83 c4 10             	add    $0x10,%esp
  800490:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  800493:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  800497:	75 14                	jne    8004ad <_main+0x475>
  800499:	83 ec 04             	sub    $0x4,%esp
  80049c:	68 4c 47 80 00       	push   $0x80474c
  8004a1:	6a 75                	push   $0x75
  8004a3:	68 10 46 80 00       	push   $0x804610
  8004a8:	e8 15 04 00 00       	call   8008c2 <_panic>
	int correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  8004ad:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8004b3:	50                   	push   %eax
  8004b4:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8004ba:	50                   	push   %eax
  8004bb:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004be:	ff 75 dc             	pushl  -0x24(%ebp)
  8004c1:	e8 b9 01 00 00       	call   80067f <ArrayStats>
  8004c6:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  8004c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int last = NumOfElements-1;
  8004d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004d4:	48                   	dec    %eax
  8004d5:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int middle = (NumOfElements-1)/2;
  8004d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004db:	48                   	dec    %eax
  8004dc:	89 c2                	mov    %eax,%edx
  8004de:	c1 ea 1f             	shr    $0x1f,%edx
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	d1 f8                	sar    %eax
  8004e5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int correctMax = quicksortedArr[last];
  8004e8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004f5:	01 d0                	add    %edx,%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	89 45 a0             	mov    %eax,-0x60(%ebp)
	int correctMed = quicksortedArr[middle];
  8004fc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800506:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	89 45 9c             	mov    %eax,-0x64(%ebp)
	//cprintf("Array is correctly sorted\n");
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);

	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  800510:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800513:	8b 10                	mov    (%eax),%edx
  800515:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80051b:	39 c2                	cmp    %eax,%edx
  80051d:	75 2d                	jne    80054c <_main+0x514>
  80051f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800522:	8b 10                	mov    (%eax),%edx
  800524:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80052a:	39 c2                	cmp    %eax,%edx
  80052c:	75 1e                	jne    80054c <_main+0x514>
  80052e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800531:	8b 00                	mov    (%eax),%eax
  800533:	3b 45 ac             	cmp    -0x54(%ebp),%eax
  800536:	75 14                	jne    80054c <_main+0x514>
  800538:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	3b 45 a0             	cmp    -0x60(%ebp),%eax
  800540:	75 0a                	jne    80054c <_main+0x514>
  800542:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800545:	8b 00                	mov    (%eax),%eax
  800547:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  80054a:	74 17                	je     800563 <_main+0x52b>
		panic("The array STATS are NOT calculated correctly") ;
  80054c:	83 ec 04             	sub    $0x4,%esp
  80054f:	68 74 47 80 00       	push   $0x804774
  800554:	68 82 00 00 00       	push   $0x82
  800559:	68 10 46 80 00       	push   $0x804610
  80055e:	e8 5f 03 00 00       	call   8008c2 <_panic>

	cprintf("Congratulations!! Scenario of Using the Semaphores & Shared Variables completed successfully!!\n\n\n");
  800563:	83 ec 0c             	sub    $0xc,%esp
  800566:	68 a4 47 80 00       	push   $0x8047a4
  80056b:	e8 0f 06 00 00       	call   800b7f <cprintf>
  800570:	83 c4 10             	add    $0x10,%esp

	return;
  800573:	90                   	nop
}
  800574:	c9                   	leave  
  800575:	c3                   	ret    

00800576 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800576:	55                   	push   %ebp
  800577:	89 e5                	mov    %esp,%ebp
  800579:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80057c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800583:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80058a:	eb 33                	jmp    8005bf <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80058c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80058f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	01 d0                	add    %edx,%eax
  80059b:	8b 10                	mov    (%eax),%edx
  80059d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005a0:	40                   	inc    %eax
  8005a1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ab:	01 c8                	add    %ecx,%eax
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	39 c2                	cmp    %eax,%edx
  8005b1:	7e 09                	jle    8005bc <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8005b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8005ba:	eb 0c                	jmp    8005c8 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005bc:	ff 45 f8             	incl   -0x8(%ebp)
  8005bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c2:	48                   	dec    %eax
  8005c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8005c6:	7f c4                	jg     80058c <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8005c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8005cb:	c9                   	leave  
  8005cc:	c3                   	ret    

008005cd <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8005cd:	55                   	push   %ebp
  8005ce:	89 e5                	mov    %esp,%ebp
  8005d0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8005d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8005da:	eb 17                	jmp    8005f3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8005dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	01 c2                	add    %eax,%edx
  8005eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005ee:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8005f0:	ff 45 fc             	incl   -0x4(%ebp)
  8005f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005f9:	7c e1                	jl     8005dc <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8005fb:	90                   	nop
  8005fc:	c9                   	leave  
  8005fd:	c3                   	ret    

008005fe <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8005fe:	55                   	push   %ebp
  8005ff:	89 e5                	mov    %esp,%ebp
  800601:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800604:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80060b:	eb 1b                	jmp    800628 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  80060d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800610:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800617:	8b 45 08             	mov    0x8(%ebp),%eax
  80061a:	01 c2                	add    %eax,%edx
  80061c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061f:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800622:	48                   	dec    %eax
  800623:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800625:	ff 45 fc             	incl   -0x4(%ebp)
  800628:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80062b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80062e:	7c dd                	jl     80060d <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800630:	90                   	nop
  800631:	c9                   	leave  
  800632:	c3                   	ret    

00800633 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800633:	55                   	push   %ebp
  800634:	89 e5                	mov    %esp,%ebp
  800636:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800639:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80063c:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800641:	f7 e9                	imul   %ecx
  800643:	c1 f9 1f             	sar    $0x1f,%ecx
  800646:	89 d0                	mov    %edx,%eax
  800648:	29 c8                	sub    %ecx,%eax
  80064a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80064d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800654:	eb 1e                	jmp    800674 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800656:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800659:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800666:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800669:	99                   	cltd   
  80066a:	f7 7d f8             	idivl  -0x8(%ebp)
  80066d:	89 d0                	mov    %edx,%eax
  80066f:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800671:	ff 45 fc             	incl   -0x4(%ebp)
  800674:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800677:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80067a:	7c da                	jl     800656 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  80067c:	90                   	nop
  80067d:	c9                   	leave  
  80067e:	c3                   	ret    

0080067f <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
  80067f:	55                   	push   %ebp
  800680:	89 e5                	mov    %esp,%ebp
  800682:	53                   	push   %ebx
  800683:	83 ec 10             	sub    $0x10,%esp
	int i ;
	*mean =0 ;
  800686:	8b 45 10             	mov    0x10(%ebp),%eax
  800689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80068f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800696:	eb 20                	jmp    8006b8 <ArrayStats+0x39>
	{
		*mean += Elements[i];
  800698:	8b 45 10             	mov    0x10(%ebp),%eax
  80069b:	8b 10                	mov    (%eax),%edx
  80069d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8006a0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	01 c8                	add    %ecx,%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	01 c2                	add    %eax,%edx
  8006b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8006b3:	89 10                	mov    %edx,(%eax)

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006b5:	ff 45 f8             	incl   -0x8(%ebp)
  8006b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8006bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006be:	7c d8                	jl     800698 <ArrayStats+0x19>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  8006c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	99                   	cltd   
  8006c6:	f7 7d 0c             	idivl  0xc(%ebp)
  8006c9:	89 c2                	mov    %eax,%edx
  8006cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ce:	89 10                	mov    %edx,(%eax)
	*var = 0;
  8006d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  8006d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8006e0:	eb 46                	jmp    800728 <ArrayStats+0xa9>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8b 10                	mov    (%eax),%edx
  8006e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8006ea:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f4:	01 c8                	add    %ecx,%eax
  8006f6:	8b 08                	mov    (%eax),%ecx
  8006f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	89 cb                	mov    %ecx,%ebx
  8006ff:	29 c3                	sub    %eax,%ebx
  800701:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800704:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	01 c8                	add    %ecx,%eax
  800710:	8b 08                	mov    (%eax),%ecx
  800712:	8b 45 10             	mov    0x10(%ebp),%eax
  800715:	8b 00                	mov    (%eax),%eax
  800717:	29 c1                	sub    %eax,%ecx
  800719:	89 c8                	mov    %ecx,%eax
  80071b:	0f af c3             	imul   %ebx,%eax
  80071e:	01 c2                	add    %eax,%edx
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	89 10                	mov    %edx,(%eax)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  800725:	ff 45 f8             	incl   -0x8(%ebp)
  800728:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80072b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80072e:	7c b2                	jl     8006e2 <ArrayStats+0x63>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
	}
	*var /= NumOfElements;
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	99                   	cltd   
  800736:	f7 7d 0c             	idivl  0xc(%ebp)
  800739:	89 c2                	mov    %eax,%edx
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	89 10                	mov    %edx,(%eax)
}
  800740:	90                   	nop
  800741:	83 c4 10             	add    $0x10,%esp
  800744:	5b                   	pop    %ebx
  800745:	5d                   	pop    %ebp
  800746:	c3                   	ret    

00800747 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800747:	55                   	push   %ebp
  800748:	89 e5                	mov    %esp,%ebp
  80074a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800753:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800757:	83 ec 0c             	sub    $0xc,%esp
  80075a:	50                   	push   %eax
  80075b:	e8 ac 1a 00 00       	call   80220c <sys_cputc>
  800760:	83 c4 10             	add    $0x10,%esp
}
  800763:	90                   	nop
  800764:	c9                   	leave  
  800765:	c3                   	ret    

00800766 <getchar>:


int
getchar(void)
{
  800766:	55                   	push   %ebp
  800767:	89 e5                	mov    %esp,%ebp
  800769:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80076c:	e8 37 19 00 00       	call   8020a8 <sys_cgetc>
  800771:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800774:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800777:	c9                   	leave  
  800778:	c3                   	ret    

00800779 <iscons>:

int iscons(int fdnum)
{
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80077c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800781:	5d                   	pop    %ebp
  800782:	c3                   	ret    

00800783 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800789:	e8 af 1b 00 00       	call   80233d <sys_getenvindex>
  80078e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800791:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800794:	89 d0                	mov    %edx,%eax
  800796:	c1 e0 03             	shl    $0x3,%eax
  800799:	01 d0                	add    %edx,%eax
  80079b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8007a2:	01 c8                	add    %ecx,%eax
  8007a4:	01 c0                	add    %eax,%eax
  8007a6:	01 d0                	add    %edx,%eax
  8007a8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8007af:	01 c8                	add    %ecx,%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007b8:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007bd:	a1 20 60 80 00       	mov    0x806020,%eax
  8007c2:	8a 40 20             	mov    0x20(%eax),%al
  8007c5:	84 c0                	test   %al,%al
  8007c7:	74 0d                	je     8007d6 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8007c9:	a1 20 60 80 00       	mov    0x806020,%eax
  8007ce:	83 c0 20             	add    $0x20,%eax
  8007d1:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007da:	7e 0a                	jle    8007e6 <libmain+0x63>
		binaryname = argv[0];
  8007dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ec:	ff 75 08             	pushl  0x8(%ebp)
  8007ef:	e8 44 f8 ff ff       	call   800038 <_main>
  8007f4:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8007f7:	e8 c5 18 00 00       	call   8020c1 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8007fc:	83 ec 0c             	sub    $0xc,%esp
  8007ff:	68 20 48 80 00       	push   $0x804820
  800804:	e8 76 03 00 00       	call   800b7f <cprintf>
  800809:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80080c:	a1 20 60 80 00       	mov    0x806020,%eax
  800811:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800817:	a1 20 60 80 00       	mov    0x806020,%eax
  80081c:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	52                   	push   %edx
  800826:	50                   	push   %eax
  800827:	68 48 48 80 00       	push   $0x804848
  80082c:	e8 4e 03 00 00       	call   800b7f <cprintf>
  800831:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800834:	a1 20 60 80 00       	mov    0x806020,%eax
  800839:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80083f:	a1 20 60 80 00       	mov    0x806020,%eax
  800844:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80084a:	a1 20 60 80 00       	mov    0x806020,%eax
  80084f:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800855:	51                   	push   %ecx
  800856:	52                   	push   %edx
  800857:	50                   	push   %eax
  800858:	68 70 48 80 00       	push   $0x804870
  80085d:	e8 1d 03 00 00       	call   800b7f <cprintf>
  800862:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800865:	a1 20 60 80 00       	mov    0x806020,%eax
  80086a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	50                   	push   %eax
  800874:	68 c8 48 80 00       	push   $0x8048c8
  800879:	e8 01 03 00 00       	call   800b7f <cprintf>
  80087e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800881:	83 ec 0c             	sub    $0xc,%esp
  800884:	68 20 48 80 00       	push   $0x804820
  800889:	e8 f1 02 00 00       	call   800b7f <cprintf>
  80088e:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800891:	e8 45 18 00 00       	call   8020db <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800896:	e8 19 00 00 00       	call   8008b4 <exit>
}
  80089b:	90                   	nop
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    

0080089e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008a4:	83 ec 0c             	sub    $0xc,%esp
  8008a7:	6a 00                	push   $0x0
  8008a9:	e8 5b 1a 00 00       	call   802309 <sys_destroy_env>
  8008ae:	83 c4 10             	add    $0x10,%esp
}
  8008b1:	90                   	nop
  8008b2:	c9                   	leave  
  8008b3:	c3                   	ret    

008008b4 <exit>:

void
exit(void)
{
  8008b4:	55                   	push   %ebp
  8008b5:	89 e5                	mov    %esp,%ebp
  8008b7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008ba:	e8 b0 1a 00 00       	call   80236f <sys_exit_env>
}
  8008bf:	90                   	nop
  8008c0:	c9                   	leave  
  8008c1:	c3                   	ret    

008008c2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008c8:	8d 45 10             	lea    0x10(%ebp),%eax
  8008cb:	83 c0 04             	add    $0x4,%eax
  8008ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008d1:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8008d6:	85 c0                	test   %eax,%eax
  8008d8:	74 16                	je     8008f0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008da:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8008df:	83 ec 08             	sub    $0x8,%esp
  8008e2:	50                   	push   %eax
  8008e3:	68 dc 48 80 00       	push   $0x8048dc
  8008e8:	e8 92 02 00 00       	call   800b7f <cprintf>
  8008ed:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008f0:	a1 00 60 80 00       	mov    0x806000,%eax
  8008f5:	ff 75 0c             	pushl  0xc(%ebp)
  8008f8:	ff 75 08             	pushl  0x8(%ebp)
  8008fb:	50                   	push   %eax
  8008fc:	68 e1 48 80 00       	push   $0x8048e1
  800901:	e8 79 02 00 00       	call   800b7f <cprintf>
  800906:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800909:	8b 45 10             	mov    0x10(%ebp),%eax
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 f4             	pushl  -0xc(%ebp)
  800912:	50                   	push   %eax
  800913:	e8 fc 01 00 00       	call   800b14 <vcprintf>
  800918:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	6a 00                	push   $0x0
  800920:	68 fd 48 80 00       	push   $0x8048fd
  800925:	e8 ea 01 00 00       	call   800b14 <vcprintf>
  80092a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80092d:	e8 82 ff ff ff       	call   8008b4 <exit>

	// should not return here
	while (1) ;
  800932:	eb fe                	jmp    800932 <_panic+0x70>

00800934 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80093a:	a1 20 60 80 00       	mov    0x806020,%eax
  80093f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800945:	8b 45 0c             	mov    0xc(%ebp),%eax
  800948:	39 c2                	cmp    %eax,%edx
  80094a:	74 14                	je     800960 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80094c:	83 ec 04             	sub    $0x4,%esp
  80094f:	68 00 49 80 00       	push   $0x804900
  800954:	6a 26                	push   $0x26
  800956:	68 4c 49 80 00       	push   $0x80494c
  80095b:	e8 62 ff ff ff       	call   8008c2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800960:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800967:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80096e:	e9 c5 00 00 00       	jmp    800a38 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800976:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	01 d0                	add    %edx,%eax
  800982:	8b 00                	mov    (%eax),%eax
  800984:	85 c0                	test   %eax,%eax
  800986:	75 08                	jne    800990 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800988:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80098b:	e9 a5 00 00 00       	jmp    800a35 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800990:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800997:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80099e:	eb 69                	jmp    800a09 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009a0:	a1 20 60 80 00       	mov    0x806020,%eax
  8009a5:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8009ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ae:	89 d0                	mov    %edx,%eax
  8009b0:	01 c0                	add    %eax,%eax
  8009b2:	01 d0                	add    %edx,%eax
  8009b4:	c1 e0 03             	shl    $0x3,%eax
  8009b7:	01 c8                	add    %ecx,%eax
  8009b9:	8a 40 04             	mov    0x4(%eax),%al
  8009bc:	84 c0                	test   %al,%al
  8009be:	75 46                	jne    800a06 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009c0:	a1 20 60 80 00       	mov    0x806020,%eax
  8009c5:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8009cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ce:	89 d0                	mov    %edx,%eax
  8009d0:	01 c0                	add    %eax,%eax
  8009d2:	01 d0                	add    %edx,%eax
  8009d4:	c1 e0 03             	shl    $0x3,%eax
  8009d7:	01 c8                	add    %ecx,%eax
  8009d9:	8b 00                	mov    (%eax),%eax
  8009db:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009e6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	01 c8                	add    %ecx,%eax
  8009f7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009f9:	39 c2                	cmp    %eax,%edx
  8009fb:	75 09                	jne    800a06 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8009fd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a04:	eb 15                	jmp    800a1b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a06:	ff 45 e8             	incl   -0x18(%ebp)
  800a09:	a1 20 60 80 00       	mov    0x806020,%eax
  800a0e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800a14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a17:	39 c2                	cmp    %eax,%edx
  800a19:	77 85                	ja     8009a0 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a1b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a1f:	75 14                	jne    800a35 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a21:	83 ec 04             	sub    $0x4,%esp
  800a24:	68 58 49 80 00       	push   $0x804958
  800a29:	6a 3a                	push   $0x3a
  800a2b:	68 4c 49 80 00       	push   $0x80494c
  800a30:	e8 8d fe ff ff       	call   8008c2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a35:	ff 45 f0             	incl   -0x10(%ebp)
  800a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a3e:	0f 8c 2f ff ff ff    	jl     800973 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a4b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a52:	eb 26                	jmp    800a7a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a54:	a1 20 60 80 00       	mov    0x806020,%eax
  800a59:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800a5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a62:	89 d0                	mov    %edx,%eax
  800a64:	01 c0                	add    %eax,%eax
  800a66:	01 d0                	add    %edx,%eax
  800a68:	c1 e0 03             	shl    $0x3,%eax
  800a6b:	01 c8                	add    %ecx,%eax
  800a6d:	8a 40 04             	mov    0x4(%eax),%al
  800a70:	3c 01                	cmp    $0x1,%al
  800a72:	75 03                	jne    800a77 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a74:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a77:	ff 45 e0             	incl   -0x20(%ebp)
  800a7a:	a1 20 60 80 00       	mov    0x806020,%eax
  800a7f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800a85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a88:	39 c2                	cmp    %eax,%edx
  800a8a:	77 c8                	ja     800a54 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a8f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a92:	74 14                	je     800aa8 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a94:	83 ec 04             	sub    $0x4,%esp
  800a97:	68 ac 49 80 00       	push   $0x8049ac
  800a9c:	6a 44                	push   $0x44
  800a9e:	68 4c 49 80 00       	push   $0x80494c
  800aa3:	e8 1a fe ff ff       	call   8008c2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800aa8:	90                   	nop
  800aa9:	c9                   	leave  
  800aaa:	c3                   	ret    

00800aab <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab4:	8b 00                	mov    (%eax),%eax
  800ab6:	8d 48 01             	lea    0x1(%eax),%ecx
  800ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abc:	89 0a                	mov    %ecx,(%edx)
  800abe:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac1:	88 d1                	mov    %dl,%cl
  800ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800aca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acd:	8b 00                	mov    (%eax),%eax
  800acf:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ad4:	75 2c                	jne    800b02 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ad6:	a0 28 60 80 00       	mov    0x806028,%al
  800adb:	0f b6 c0             	movzbl %al,%eax
  800ade:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae1:	8b 12                	mov    (%edx),%edx
  800ae3:	89 d1                	mov    %edx,%ecx
  800ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae8:	83 c2 08             	add    $0x8,%edx
  800aeb:	83 ec 04             	sub    $0x4,%esp
  800aee:	50                   	push   %eax
  800aef:	51                   	push   %ecx
  800af0:	52                   	push   %edx
  800af1:	e8 89 15 00 00       	call   80207f <sys_cputs>
  800af6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b05:	8b 40 04             	mov    0x4(%eax),%eax
  800b08:	8d 50 01             	lea    0x1(%eax),%edx
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b11:	90                   	nop
  800b12:	c9                   	leave  
  800b13:	c3                   	ret    

00800b14 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b1d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b24:	00 00 00 
	b.cnt = 0;
  800b27:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b2e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	ff 75 08             	pushl  0x8(%ebp)
  800b37:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b3d:	50                   	push   %eax
  800b3e:	68 ab 0a 80 00       	push   $0x800aab
  800b43:	e8 11 02 00 00       	call   800d59 <vprintfmt>
  800b48:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b4b:	a0 28 60 80 00       	mov    0x806028,%al
  800b50:	0f b6 c0             	movzbl %al,%eax
  800b53:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b59:	83 ec 04             	sub    $0x4,%esp
  800b5c:	50                   	push   %eax
  800b5d:	52                   	push   %edx
  800b5e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b64:	83 c0 08             	add    $0x8,%eax
  800b67:	50                   	push   %eax
  800b68:	e8 12 15 00 00       	call   80207f <sys_cputs>
  800b6d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b70:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
	return b.cnt;
  800b77:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b7d:	c9                   	leave  
  800b7e:	c3                   	ret    

00800b7f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b85:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
	va_start(ap, fmt);
  800b8c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9b:	50                   	push   %eax
  800b9c:	e8 73 ff ff ff       	call   800b14 <vcprintf>
  800ba1:	83 c4 10             	add    $0x10,%esp
  800ba4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800baa:	c9                   	leave  
  800bab:	c3                   	ret    

00800bac <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800bb2:	e8 0a 15 00 00       	call   8020c1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800bb7:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bba:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	83 ec 08             	sub    $0x8,%esp
  800bc3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc6:	50                   	push   %eax
  800bc7:	e8 48 ff ff ff       	call   800b14 <vcprintf>
  800bcc:	83 c4 10             	add    $0x10,%esp
  800bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800bd2:	e8 04 15 00 00       	call   8020db <sys_unlock_cons>
	return cnt;
  800bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bda:	c9                   	leave  
  800bdb:	c3                   	ret    

00800bdc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	53                   	push   %ebx
  800be0:	83 ec 14             	sub    $0x14,%esp
  800be3:	8b 45 10             	mov    0x10(%ebp),%eax
  800be6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bef:	8b 45 18             	mov    0x18(%ebp),%eax
  800bf2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bfa:	77 55                	ja     800c51 <printnum+0x75>
  800bfc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bff:	72 05                	jb     800c06 <printnum+0x2a>
  800c01:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c04:	77 4b                	ja     800c51 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c06:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c09:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c0c:	8b 45 18             	mov    0x18(%ebp),%eax
  800c0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c14:	52                   	push   %edx
  800c15:	50                   	push   %eax
  800c16:	ff 75 f4             	pushl  -0xc(%ebp)
  800c19:	ff 75 f0             	pushl  -0x10(%ebp)
  800c1c:	e8 1f 37 00 00       	call   804340 <__udivdi3>
  800c21:	83 c4 10             	add    $0x10,%esp
  800c24:	83 ec 04             	sub    $0x4,%esp
  800c27:	ff 75 20             	pushl  0x20(%ebp)
  800c2a:	53                   	push   %ebx
  800c2b:	ff 75 18             	pushl  0x18(%ebp)
  800c2e:	52                   	push   %edx
  800c2f:	50                   	push   %eax
  800c30:	ff 75 0c             	pushl  0xc(%ebp)
  800c33:	ff 75 08             	pushl  0x8(%ebp)
  800c36:	e8 a1 ff ff ff       	call   800bdc <printnum>
  800c3b:	83 c4 20             	add    $0x20,%esp
  800c3e:	eb 1a                	jmp    800c5a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c40:	83 ec 08             	sub    $0x8,%esp
  800c43:	ff 75 0c             	pushl  0xc(%ebp)
  800c46:	ff 75 20             	pushl  0x20(%ebp)
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	ff d0                	call   *%eax
  800c4e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c51:	ff 4d 1c             	decl   0x1c(%ebp)
  800c54:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c58:	7f e6                	jg     800c40 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c5a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c68:	53                   	push   %ebx
  800c69:	51                   	push   %ecx
  800c6a:	52                   	push   %edx
  800c6b:	50                   	push   %eax
  800c6c:	e8 df 37 00 00       	call   804450 <__umoddi3>
  800c71:	83 c4 10             	add    $0x10,%esp
  800c74:	05 14 4c 80 00       	add    $0x804c14,%eax
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	0f be c0             	movsbl %al,%eax
  800c7e:	83 ec 08             	sub    $0x8,%esp
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	50                   	push   %eax
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	ff d0                	call   *%eax
  800c8a:	83 c4 10             	add    $0x10,%esp
}
  800c8d:	90                   	nop
  800c8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c91:	c9                   	leave  
  800c92:	c3                   	ret    

00800c93 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c96:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c9a:	7e 1c                	jle    800cb8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	8b 00                	mov    (%eax),%eax
  800ca1:	8d 50 08             	lea    0x8(%eax),%edx
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	89 10                	mov    %edx,(%eax)
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8b 00                	mov    (%eax),%eax
  800cae:	83 e8 08             	sub    $0x8,%eax
  800cb1:	8b 50 04             	mov    0x4(%eax),%edx
  800cb4:	8b 00                	mov    (%eax),%eax
  800cb6:	eb 40                	jmp    800cf8 <getuint+0x65>
	else if (lflag)
  800cb8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cbc:	74 1e                	je     800cdc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8b 00                	mov    (%eax),%eax
  800cc3:	8d 50 04             	lea    0x4(%eax),%edx
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	89 10                	mov    %edx,(%eax)
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	8b 00                	mov    (%eax),%eax
  800cd0:	83 e8 04             	sub    $0x4,%eax
  800cd3:	8b 00                	mov    (%eax),%eax
  800cd5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cda:	eb 1c                	jmp    800cf8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	8b 00                	mov    (%eax),%eax
  800ce1:	8d 50 04             	lea    0x4(%eax),%edx
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	89 10                	mov    %edx,(%eax)
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8b 00                	mov    (%eax),%eax
  800cee:	83 e8 04             	sub    $0x4,%eax
  800cf1:	8b 00                	mov    (%eax),%eax
  800cf3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cf8:	5d                   	pop    %ebp
  800cf9:	c3                   	ret    

00800cfa <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cfd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d01:	7e 1c                	jle    800d1f <getint+0x25>
		return va_arg(*ap, long long);
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8b 00                	mov    (%eax),%eax
  800d08:	8d 50 08             	lea    0x8(%eax),%edx
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	89 10                	mov    %edx,(%eax)
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8b 00                	mov    (%eax),%eax
  800d15:	83 e8 08             	sub    $0x8,%eax
  800d18:	8b 50 04             	mov    0x4(%eax),%edx
  800d1b:	8b 00                	mov    (%eax),%eax
  800d1d:	eb 38                	jmp    800d57 <getint+0x5d>
	else if (lflag)
  800d1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d23:	74 1a                	je     800d3f <getint+0x45>
		return va_arg(*ap, long);
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8b 00                	mov    (%eax),%eax
  800d2a:	8d 50 04             	lea    0x4(%eax),%edx
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	89 10                	mov    %edx,(%eax)
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8b 00                	mov    (%eax),%eax
  800d37:	83 e8 04             	sub    $0x4,%eax
  800d3a:	8b 00                	mov    (%eax),%eax
  800d3c:	99                   	cltd   
  800d3d:	eb 18                	jmp    800d57 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8b 00                	mov    (%eax),%eax
  800d44:	8d 50 04             	lea    0x4(%eax),%edx
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	89 10                	mov    %edx,(%eax)
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	83 e8 04             	sub    $0x4,%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	99                   	cltd   
}
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	56                   	push   %esi
  800d5d:	53                   	push   %ebx
  800d5e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d61:	eb 17                	jmp    800d7a <vprintfmt+0x21>
			if (ch == '\0')
  800d63:	85 db                	test   %ebx,%ebx
  800d65:	0f 84 c1 03 00 00    	je     80112c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d6b:	83 ec 08             	sub    $0x8,%esp
  800d6e:	ff 75 0c             	pushl  0xc(%ebp)
  800d71:	53                   	push   %ebx
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	ff d0                	call   *%eax
  800d77:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7d:	8d 50 01             	lea    0x1(%eax),%edx
  800d80:	89 55 10             	mov    %edx,0x10(%ebp)
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	0f b6 d8             	movzbl %al,%ebx
  800d88:	83 fb 25             	cmp    $0x25,%ebx
  800d8b:	75 d6                	jne    800d63 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d8d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d91:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d98:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d9f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800da6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dad:	8b 45 10             	mov    0x10(%ebp),%eax
  800db0:	8d 50 01             	lea    0x1(%eax),%edx
  800db3:	89 55 10             	mov    %edx,0x10(%ebp)
  800db6:	8a 00                	mov    (%eax),%al
  800db8:	0f b6 d8             	movzbl %al,%ebx
  800dbb:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dbe:	83 f8 5b             	cmp    $0x5b,%eax
  800dc1:	0f 87 3d 03 00 00    	ja     801104 <vprintfmt+0x3ab>
  800dc7:	8b 04 85 38 4c 80 00 	mov    0x804c38(,%eax,4),%eax
  800dce:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800dd0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800dd4:	eb d7                	jmp    800dad <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800dd6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800dda:	eb d1                	jmp    800dad <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ddc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800de3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800de6:	89 d0                	mov    %edx,%eax
  800de8:	c1 e0 02             	shl    $0x2,%eax
  800deb:	01 d0                	add    %edx,%eax
  800ded:	01 c0                	add    %eax,%eax
  800def:	01 d8                	add    %ebx,%eax
  800df1:	83 e8 30             	sub    $0x30,%eax
  800df4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800df7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dff:	83 fb 2f             	cmp    $0x2f,%ebx
  800e02:	7e 3e                	jle    800e42 <vprintfmt+0xe9>
  800e04:	83 fb 39             	cmp    $0x39,%ebx
  800e07:	7f 39                	jg     800e42 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e09:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e0c:	eb d5                	jmp    800de3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e11:	83 c0 04             	add    $0x4,%eax
  800e14:	89 45 14             	mov    %eax,0x14(%ebp)
  800e17:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1a:	83 e8 04             	sub    $0x4,%eax
  800e1d:	8b 00                	mov    (%eax),%eax
  800e1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e22:	eb 1f                	jmp    800e43 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e24:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e28:	79 83                	jns    800dad <vprintfmt+0x54>
				width = 0;
  800e2a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e31:	e9 77 ff ff ff       	jmp    800dad <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e36:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e3d:	e9 6b ff ff ff       	jmp    800dad <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e42:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e47:	0f 89 60 ff ff ff    	jns    800dad <vprintfmt+0x54>
				width = precision, precision = -1;
  800e4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e53:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e5a:	e9 4e ff ff ff       	jmp    800dad <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e5f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e62:	e9 46 ff ff ff       	jmp    800dad <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	83 c0 04             	add    $0x4,%eax
  800e6d:	89 45 14             	mov    %eax,0x14(%ebp)
  800e70:	8b 45 14             	mov    0x14(%ebp),%eax
  800e73:	83 e8 04             	sub    $0x4,%eax
  800e76:	8b 00                	mov    (%eax),%eax
  800e78:	83 ec 08             	sub    $0x8,%esp
  800e7b:	ff 75 0c             	pushl  0xc(%ebp)
  800e7e:	50                   	push   %eax
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	ff d0                	call   *%eax
  800e84:	83 c4 10             	add    $0x10,%esp
			break;
  800e87:	e9 9b 02 00 00       	jmp    801127 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e8f:	83 c0 04             	add    $0x4,%eax
  800e92:	89 45 14             	mov    %eax,0x14(%ebp)
  800e95:	8b 45 14             	mov    0x14(%ebp),%eax
  800e98:	83 e8 04             	sub    $0x4,%eax
  800e9b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e9d:	85 db                	test   %ebx,%ebx
  800e9f:	79 02                	jns    800ea3 <vprintfmt+0x14a>
				err = -err;
  800ea1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ea3:	83 fb 64             	cmp    $0x64,%ebx
  800ea6:	7f 0b                	jg     800eb3 <vprintfmt+0x15a>
  800ea8:	8b 34 9d 80 4a 80 00 	mov    0x804a80(,%ebx,4),%esi
  800eaf:	85 f6                	test   %esi,%esi
  800eb1:	75 19                	jne    800ecc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800eb3:	53                   	push   %ebx
  800eb4:	68 25 4c 80 00       	push   $0x804c25
  800eb9:	ff 75 0c             	pushl  0xc(%ebp)
  800ebc:	ff 75 08             	pushl  0x8(%ebp)
  800ebf:	e8 70 02 00 00       	call   801134 <printfmt>
  800ec4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ec7:	e9 5b 02 00 00       	jmp    801127 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ecc:	56                   	push   %esi
  800ecd:	68 2e 4c 80 00       	push   $0x804c2e
  800ed2:	ff 75 0c             	pushl  0xc(%ebp)
  800ed5:	ff 75 08             	pushl  0x8(%ebp)
  800ed8:	e8 57 02 00 00       	call   801134 <printfmt>
  800edd:	83 c4 10             	add    $0x10,%esp
			break;
  800ee0:	e9 42 02 00 00       	jmp    801127 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ee5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee8:	83 c0 04             	add    $0x4,%eax
  800eeb:	89 45 14             	mov    %eax,0x14(%ebp)
  800eee:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef1:	83 e8 04             	sub    $0x4,%eax
  800ef4:	8b 30                	mov    (%eax),%esi
  800ef6:	85 f6                	test   %esi,%esi
  800ef8:	75 05                	jne    800eff <vprintfmt+0x1a6>
				p = "(null)";
  800efa:	be 31 4c 80 00       	mov    $0x804c31,%esi
			if (width > 0 && padc != '-')
  800eff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f03:	7e 6d                	jle    800f72 <vprintfmt+0x219>
  800f05:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f09:	74 67                	je     800f72 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	50                   	push   %eax
  800f12:	56                   	push   %esi
  800f13:	e8 26 05 00 00       	call   80143e <strnlen>
  800f18:	83 c4 10             	add    $0x10,%esp
  800f1b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f1e:	eb 16                	jmp    800f36 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f20:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f24:	83 ec 08             	sub    $0x8,%esp
  800f27:	ff 75 0c             	pushl  0xc(%ebp)
  800f2a:	50                   	push   %eax
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	ff d0                	call   *%eax
  800f30:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f33:	ff 4d e4             	decl   -0x1c(%ebp)
  800f36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f3a:	7f e4                	jg     800f20 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f3c:	eb 34                	jmp    800f72 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f3e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f42:	74 1c                	je     800f60 <vprintfmt+0x207>
  800f44:	83 fb 1f             	cmp    $0x1f,%ebx
  800f47:	7e 05                	jle    800f4e <vprintfmt+0x1f5>
  800f49:	83 fb 7e             	cmp    $0x7e,%ebx
  800f4c:	7e 12                	jle    800f60 <vprintfmt+0x207>
					putch('?', putdat);
  800f4e:	83 ec 08             	sub    $0x8,%esp
  800f51:	ff 75 0c             	pushl  0xc(%ebp)
  800f54:	6a 3f                	push   $0x3f
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	ff d0                	call   *%eax
  800f5b:	83 c4 10             	add    $0x10,%esp
  800f5e:	eb 0f                	jmp    800f6f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f60:	83 ec 08             	sub    $0x8,%esp
  800f63:	ff 75 0c             	pushl  0xc(%ebp)
  800f66:	53                   	push   %ebx
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	ff d0                	call   *%eax
  800f6c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f6f:	ff 4d e4             	decl   -0x1c(%ebp)
  800f72:	89 f0                	mov    %esi,%eax
  800f74:	8d 70 01             	lea    0x1(%eax),%esi
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	0f be d8             	movsbl %al,%ebx
  800f7c:	85 db                	test   %ebx,%ebx
  800f7e:	74 24                	je     800fa4 <vprintfmt+0x24b>
  800f80:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f84:	78 b8                	js     800f3e <vprintfmt+0x1e5>
  800f86:	ff 4d e0             	decl   -0x20(%ebp)
  800f89:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f8d:	79 af                	jns    800f3e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f8f:	eb 13                	jmp    800fa4 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f91:	83 ec 08             	sub    $0x8,%esp
  800f94:	ff 75 0c             	pushl  0xc(%ebp)
  800f97:	6a 20                	push   $0x20
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	ff d0                	call   *%eax
  800f9e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fa1:	ff 4d e4             	decl   -0x1c(%ebp)
  800fa4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa8:	7f e7                	jg     800f91 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800faa:	e9 78 01 00 00       	jmp    801127 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800faf:	83 ec 08             	sub    $0x8,%esp
  800fb2:	ff 75 e8             	pushl  -0x18(%ebp)
  800fb5:	8d 45 14             	lea    0x14(%ebp),%eax
  800fb8:	50                   	push   %eax
  800fb9:	e8 3c fd ff ff       	call   800cfa <getint>
  800fbe:	83 c4 10             	add    $0x10,%esp
  800fc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fcd:	85 d2                	test   %edx,%edx
  800fcf:	79 23                	jns    800ff4 <vprintfmt+0x29b>
				putch('-', putdat);
  800fd1:	83 ec 08             	sub    $0x8,%esp
  800fd4:	ff 75 0c             	pushl  0xc(%ebp)
  800fd7:	6a 2d                	push   $0x2d
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	ff d0                	call   *%eax
  800fde:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe7:	f7 d8                	neg    %eax
  800fe9:	83 d2 00             	adc    $0x0,%edx
  800fec:	f7 da                	neg    %edx
  800fee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ff4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ffb:	e9 bc 00 00 00       	jmp    8010bc <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801000:	83 ec 08             	sub    $0x8,%esp
  801003:	ff 75 e8             	pushl  -0x18(%ebp)
  801006:	8d 45 14             	lea    0x14(%ebp),%eax
  801009:	50                   	push   %eax
  80100a:	e8 84 fc ff ff       	call   800c93 <getuint>
  80100f:	83 c4 10             	add    $0x10,%esp
  801012:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801015:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801018:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80101f:	e9 98 00 00 00       	jmp    8010bc <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801024:	83 ec 08             	sub    $0x8,%esp
  801027:	ff 75 0c             	pushl  0xc(%ebp)
  80102a:	6a 58                	push   $0x58
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	ff d0                	call   *%eax
  801031:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801034:	83 ec 08             	sub    $0x8,%esp
  801037:	ff 75 0c             	pushl  0xc(%ebp)
  80103a:	6a 58                	push   $0x58
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	ff d0                	call   *%eax
  801041:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801044:	83 ec 08             	sub    $0x8,%esp
  801047:	ff 75 0c             	pushl  0xc(%ebp)
  80104a:	6a 58                	push   $0x58
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	ff d0                	call   *%eax
  801051:	83 c4 10             	add    $0x10,%esp
			break;
  801054:	e9 ce 00 00 00       	jmp    801127 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801059:	83 ec 08             	sub    $0x8,%esp
  80105c:	ff 75 0c             	pushl  0xc(%ebp)
  80105f:	6a 30                	push   $0x30
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	ff d0                	call   *%eax
  801066:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801069:	83 ec 08             	sub    $0x8,%esp
  80106c:	ff 75 0c             	pushl  0xc(%ebp)
  80106f:	6a 78                	push   $0x78
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	ff d0                	call   *%eax
  801076:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801079:	8b 45 14             	mov    0x14(%ebp),%eax
  80107c:	83 c0 04             	add    $0x4,%eax
  80107f:	89 45 14             	mov    %eax,0x14(%ebp)
  801082:	8b 45 14             	mov    0x14(%ebp),%eax
  801085:	83 e8 04             	sub    $0x4,%eax
  801088:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80108a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801094:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80109b:	eb 1f                	jmp    8010bc <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80109d:	83 ec 08             	sub    $0x8,%esp
  8010a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8010a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8010a6:	50                   	push   %eax
  8010a7:	e8 e7 fb ff ff       	call   800c93 <getuint>
  8010ac:	83 c4 10             	add    $0x10,%esp
  8010af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010b5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010bc:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010c3:	83 ec 04             	sub    $0x4,%esp
  8010c6:	52                   	push   %edx
  8010c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010ca:	50                   	push   %eax
  8010cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8010d1:	ff 75 0c             	pushl  0xc(%ebp)
  8010d4:	ff 75 08             	pushl  0x8(%ebp)
  8010d7:	e8 00 fb ff ff       	call   800bdc <printnum>
  8010dc:	83 c4 20             	add    $0x20,%esp
			break;
  8010df:	eb 46                	jmp    801127 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010e1:	83 ec 08             	sub    $0x8,%esp
  8010e4:	ff 75 0c             	pushl  0xc(%ebp)
  8010e7:	53                   	push   %ebx
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	ff d0                	call   *%eax
  8010ed:	83 c4 10             	add    $0x10,%esp
			break;
  8010f0:	eb 35                	jmp    801127 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8010f2:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
			break;
  8010f9:	eb 2c                	jmp    801127 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010fb:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
			break;
  801102:	eb 23                	jmp    801127 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801104:	83 ec 08             	sub    $0x8,%esp
  801107:	ff 75 0c             	pushl  0xc(%ebp)
  80110a:	6a 25                	push   $0x25
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	ff d0                	call   *%eax
  801111:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801114:	ff 4d 10             	decl   0x10(%ebp)
  801117:	eb 03                	jmp    80111c <vprintfmt+0x3c3>
  801119:	ff 4d 10             	decl   0x10(%ebp)
  80111c:	8b 45 10             	mov    0x10(%ebp),%eax
  80111f:	48                   	dec    %eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	3c 25                	cmp    $0x25,%al
  801124:	75 f3                	jne    801119 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801126:	90                   	nop
		}
	}
  801127:	e9 35 fc ff ff       	jmp    800d61 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80112c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80112d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801130:	5b                   	pop    %ebx
  801131:	5e                   	pop    %esi
  801132:	5d                   	pop    %ebp
  801133:	c3                   	ret    

00801134 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80113a:	8d 45 10             	lea    0x10(%ebp),%eax
  80113d:	83 c0 04             	add    $0x4,%eax
  801140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801143:	8b 45 10             	mov    0x10(%ebp),%eax
  801146:	ff 75 f4             	pushl  -0xc(%ebp)
  801149:	50                   	push   %eax
  80114a:	ff 75 0c             	pushl  0xc(%ebp)
  80114d:	ff 75 08             	pushl  0x8(%ebp)
  801150:	e8 04 fc ff ff       	call   800d59 <vprintfmt>
  801155:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801158:	90                   	nop
  801159:	c9                   	leave  
  80115a:	c3                   	ret    

0080115b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	8b 40 08             	mov    0x8(%eax),%eax
  801164:	8d 50 01             	lea    0x1(%eax),%edx
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80116d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801170:	8b 10                	mov    (%eax),%edx
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	8b 40 04             	mov    0x4(%eax),%eax
  801178:	39 c2                	cmp    %eax,%edx
  80117a:	73 12                	jae    80118e <sprintputch+0x33>
		*b->buf++ = ch;
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	8b 00                	mov    (%eax),%eax
  801181:	8d 48 01             	lea    0x1(%eax),%ecx
  801184:	8b 55 0c             	mov    0xc(%ebp),%edx
  801187:	89 0a                	mov    %ecx,(%edx)
  801189:	8b 55 08             	mov    0x8(%ebp),%edx
  80118c:	88 10                	mov    %dl,(%eax)
}
  80118e:	90                   	nop
  80118f:	5d                   	pop    %ebp
  801190:	c3                   	ret    

00801191 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	01 d0                	add    %edx,%eax
  8011a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b6:	74 06                	je     8011be <vsnprintf+0x2d>
  8011b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011bc:	7f 07                	jg     8011c5 <vsnprintf+0x34>
		return -E_INVAL;
  8011be:	b8 03 00 00 00       	mov    $0x3,%eax
  8011c3:	eb 20                	jmp    8011e5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011c5:	ff 75 14             	pushl  0x14(%ebp)
  8011c8:	ff 75 10             	pushl  0x10(%ebp)
  8011cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011ce:	50                   	push   %eax
  8011cf:	68 5b 11 80 00       	push   $0x80115b
  8011d4:	e8 80 fb ff ff       	call   800d59 <vprintfmt>
  8011d9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011df:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011e5:	c9                   	leave  
  8011e6:	c3                   	ret    

008011e7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011ed:	8d 45 10             	lea    0x10(%ebp),%eax
  8011f0:	83 c0 04             	add    $0x4,%eax
  8011f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011fc:	50                   	push   %eax
  8011fd:	ff 75 0c             	pushl  0xc(%ebp)
  801200:	ff 75 08             	pushl  0x8(%ebp)
  801203:	e8 89 ff ff ff       	call   801191 <vsnprintf>
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80120e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801211:	c9                   	leave  
  801212:	c3                   	ret    

00801213 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80121d:	74 13                	je     801232 <readline+0x1f>
		cprintf("%s", prompt);
  80121f:	83 ec 08             	sub    $0x8,%esp
  801222:	ff 75 08             	pushl  0x8(%ebp)
  801225:	68 a8 4d 80 00       	push   $0x804da8
  80122a:	e8 50 f9 ff ff       	call   800b7f <cprintf>
  80122f:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801232:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801239:	83 ec 0c             	sub    $0xc,%esp
  80123c:	6a 00                	push   $0x0
  80123e:	e8 36 f5 ff ff       	call   800779 <iscons>
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801249:	e8 18 f5 ff ff       	call   800766 <getchar>
  80124e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801251:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801255:	79 22                	jns    801279 <readline+0x66>
			if (c != -E_EOF)
  801257:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80125b:	0f 84 ad 00 00 00    	je     80130e <readline+0xfb>
				cprintf("read error: %e\n", c);
  801261:	83 ec 08             	sub    $0x8,%esp
  801264:	ff 75 ec             	pushl  -0x14(%ebp)
  801267:	68 ab 4d 80 00       	push   $0x804dab
  80126c:	e8 0e f9 ff ff       	call   800b7f <cprintf>
  801271:	83 c4 10             	add    $0x10,%esp
			break;
  801274:	e9 95 00 00 00       	jmp    80130e <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801279:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80127d:	7e 34                	jle    8012b3 <readline+0xa0>
  80127f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801286:	7f 2b                	jg     8012b3 <readline+0xa0>
			if (echoing)
  801288:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80128c:	74 0e                	je     80129c <readline+0x89>
				cputchar(c);
  80128e:	83 ec 0c             	sub    $0xc,%esp
  801291:	ff 75 ec             	pushl  -0x14(%ebp)
  801294:	e8 ae f4 ff ff       	call   800747 <cputchar>
  801299:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80129c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80129f:	8d 50 01             	lea    0x1(%eax),%edx
  8012a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012a5:	89 c2                	mov    %eax,%edx
  8012a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012aa:	01 d0                	add    %edx,%eax
  8012ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012af:	88 10                	mov    %dl,(%eax)
  8012b1:	eb 56                	jmp    801309 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012b3:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012b7:	75 1f                	jne    8012d8 <readline+0xc5>
  8012b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012bd:	7e 19                	jle    8012d8 <readline+0xc5>
			if (echoing)
  8012bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012c3:	74 0e                	je     8012d3 <readline+0xc0>
				cputchar(c);
  8012c5:	83 ec 0c             	sub    $0xc,%esp
  8012c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8012cb:	e8 77 f4 ff ff       	call   800747 <cputchar>
  8012d0:	83 c4 10             	add    $0x10,%esp

			i--;
  8012d3:	ff 4d f4             	decl   -0xc(%ebp)
  8012d6:	eb 31                	jmp    801309 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012d8:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012dc:	74 0a                	je     8012e8 <readline+0xd5>
  8012de:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012e2:	0f 85 61 ff ff ff    	jne    801249 <readline+0x36>
			if (echoing)
  8012e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012ec:	74 0e                	je     8012fc <readline+0xe9>
				cputchar(c);
  8012ee:	83 ec 0c             	sub    $0xc,%esp
  8012f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8012f4:	e8 4e f4 ff ff       	call   800747 <cputchar>
  8012f9:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801302:	01 d0                	add    %edx,%eax
  801304:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801307:	eb 06                	jmp    80130f <readline+0xfc>
		}
	}
  801309:	e9 3b ff ff ff       	jmp    801249 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80130e:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80130f:	90                   	nop
  801310:	c9                   	leave  
  801311:	c3                   	ret    

00801312 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801318:	e8 a4 0d 00 00       	call   8020c1 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80131d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801321:	74 13                	je     801336 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801323:	83 ec 08             	sub    $0x8,%esp
  801326:	ff 75 08             	pushl  0x8(%ebp)
  801329:	68 a8 4d 80 00       	push   $0x804da8
  80132e:	e8 4c f8 ff ff       	call   800b7f <cprintf>
  801333:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801336:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  80133d:	83 ec 0c             	sub    $0xc,%esp
  801340:	6a 00                	push   $0x0
  801342:	e8 32 f4 ff ff       	call   800779 <iscons>
  801347:	83 c4 10             	add    $0x10,%esp
  80134a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  80134d:	e8 14 f4 ff ff       	call   800766 <getchar>
  801352:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801355:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801359:	79 22                	jns    80137d <atomic_readline+0x6b>
				if (c != -E_EOF)
  80135b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80135f:	0f 84 ad 00 00 00    	je     801412 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801365:	83 ec 08             	sub    $0x8,%esp
  801368:	ff 75 ec             	pushl  -0x14(%ebp)
  80136b:	68 ab 4d 80 00       	push   $0x804dab
  801370:	e8 0a f8 ff ff       	call   800b7f <cprintf>
  801375:	83 c4 10             	add    $0x10,%esp
				break;
  801378:	e9 95 00 00 00       	jmp    801412 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  80137d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801381:	7e 34                	jle    8013b7 <atomic_readline+0xa5>
  801383:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80138a:	7f 2b                	jg     8013b7 <atomic_readline+0xa5>
				if (echoing)
  80138c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801390:	74 0e                	je     8013a0 <atomic_readline+0x8e>
					cputchar(c);
  801392:	83 ec 0c             	sub    $0xc,%esp
  801395:	ff 75 ec             	pushl  -0x14(%ebp)
  801398:	e8 aa f3 ff ff       	call   800747 <cputchar>
  80139d:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  8013a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a3:	8d 50 01             	lea    0x1(%eax),%edx
  8013a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013a9:	89 c2                	mov    %eax,%edx
  8013ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ae:	01 d0                	add    %edx,%eax
  8013b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013b3:	88 10                	mov    %dl,(%eax)
  8013b5:	eb 56                	jmp    80140d <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  8013b7:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013bb:	75 1f                	jne    8013dc <atomic_readline+0xca>
  8013bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013c1:	7e 19                	jle    8013dc <atomic_readline+0xca>
				if (echoing)
  8013c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013c7:	74 0e                	je     8013d7 <atomic_readline+0xc5>
					cputchar(c);
  8013c9:	83 ec 0c             	sub    $0xc,%esp
  8013cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8013cf:	e8 73 f3 ff ff       	call   800747 <cputchar>
  8013d4:	83 c4 10             	add    $0x10,%esp
				i--;
  8013d7:	ff 4d f4             	decl   -0xc(%ebp)
  8013da:	eb 31                	jmp    80140d <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8013dc:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013e0:	74 0a                	je     8013ec <atomic_readline+0xda>
  8013e2:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013e6:	0f 85 61 ff ff ff    	jne    80134d <atomic_readline+0x3b>
				if (echoing)
  8013ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013f0:	74 0e                	je     801400 <atomic_readline+0xee>
					cputchar(c);
  8013f2:	83 ec 0c             	sub    $0xc,%esp
  8013f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f8:	e8 4a f3 ff ff       	call   800747 <cputchar>
  8013fd:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801400:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	01 d0                	add    %edx,%eax
  801408:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80140b:	eb 06                	jmp    801413 <atomic_readline+0x101>
			}
		}
  80140d:	e9 3b ff ff ff       	jmp    80134d <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801412:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801413:	e8 c3 0c 00 00       	call   8020db <sys_unlock_cons>
}
  801418:	90                   	nop
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801421:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801428:	eb 06                	jmp    801430 <strlen+0x15>
		n++;
  80142a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80142d:	ff 45 08             	incl   0x8(%ebp)
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	84 c0                	test   %al,%al
  801437:	75 f1                	jne    80142a <strlen+0xf>
		n++;
	return n;
  801439:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801444:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144b:	eb 09                	jmp    801456 <strnlen+0x18>
		n++;
  80144d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801450:	ff 45 08             	incl   0x8(%ebp)
  801453:	ff 4d 0c             	decl   0xc(%ebp)
  801456:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80145a:	74 09                	je     801465 <strnlen+0x27>
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	84 c0                	test   %al,%al
  801463:	75 e8                	jne    80144d <strnlen+0xf>
		n++;
	return n;
  801465:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801468:	c9                   	leave  
  801469:	c3                   	ret    

0080146a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801476:	90                   	nop
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8d 50 01             	lea    0x1(%eax),%edx
  80147d:	89 55 08             	mov    %edx,0x8(%ebp)
  801480:	8b 55 0c             	mov    0xc(%ebp),%edx
  801483:	8d 4a 01             	lea    0x1(%edx),%ecx
  801486:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801489:	8a 12                	mov    (%edx),%dl
  80148b:	88 10                	mov    %dl,(%eax)
  80148d:	8a 00                	mov    (%eax),%al
  80148f:	84 c0                	test   %al,%al
  801491:	75 e4                	jne    801477 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801493:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
  80149b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014ab:	eb 1f                	jmp    8014cc <strncpy+0x34>
		*dst++ = *src;
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	8d 50 01             	lea    0x1(%eax),%edx
  8014b3:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b9:	8a 12                	mov    (%edx),%dl
  8014bb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	84 c0                	test   %al,%al
  8014c4:	74 03                	je     8014c9 <strncpy+0x31>
			src++;
  8014c6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014c9:	ff 45 fc             	incl   -0x4(%ebp)
  8014cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014d2:	72 d9                	jb     8014ad <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e9:	74 30                	je     80151b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014eb:	eb 16                	jmp    801503 <strlcpy+0x2a>
			*dst++ = *src++;
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	8d 50 01             	lea    0x1(%eax),%edx
  8014f3:	89 55 08             	mov    %edx,0x8(%ebp)
  8014f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014fc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014ff:	8a 12                	mov    (%edx),%dl
  801501:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801503:	ff 4d 10             	decl   0x10(%ebp)
  801506:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150a:	74 09                	je     801515 <strlcpy+0x3c>
  80150c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150f:	8a 00                	mov    (%eax),%al
  801511:	84 c0                	test   %al,%al
  801513:	75 d8                	jne    8014ed <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80151b:	8b 55 08             	mov    0x8(%ebp),%edx
  80151e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801521:	29 c2                	sub    %eax,%edx
  801523:	89 d0                	mov    %edx,%eax
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80152a:	eb 06                	jmp    801532 <strcmp+0xb>
		p++, q++;
  80152c:	ff 45 08             	incl   0x8(%ebp)
  80152f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	8a 00                	mov    (%eax),%al
  801537:	84 c0                	test   %al,%al
  801539:	74 0e                	je     801549 <strcmp+0x22>
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	8a 10                	mov    (%eax),%dl
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	8a 00                	mov    (%eax),%al
  801545:	38 c2                	cmp    %al,%dl
  801547:	74 e3                	je     80152c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
  80154c:	8a 00                	mov    (%eax),%al
  80154e:	0f b6 d0             	movzbl %al,%edx
  801551:	8b 45 0c             	mov    0xc(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	0f b6 c0             	movzbl %al,%eax
  801559:	29 c2                	sub    %eax,%edx
  80155b:	89 d0                	mov    %edx,%eax
}
  80155d:	5d                   	pop    %ebp
  80155e:	c3                   	ret    

0080155f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801562:	eb 09                	jmp    80156d <strncmp+0xe>
		n--, p++, q++;
  801564:	ff 4d 10             	decl   0x10(%ebp)
  801567:	ff 45 08             	incl   0x8(%ebp)
  80156a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80156d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801571:	74 17                	je     80158a <strncmp+0x2b>
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	84 c0                	test   %al,%al
  80157a:	74 0e                	je     80158a <strncmp+0x2b>
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	8a 10                	mov    (%eax),%dl
  801581:	8b 45 0c             	mov    0xc(%ebp),%eax
  801584:	8a 00                	mov    (%eax),%al
  801586:	38 c2                	cmp    %al,%dl
  801588:	74 da                	je     801564 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80158a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80158e:	75 07                	jne    801597 <strncmp+0x38>
		return 0;
  801590:	b8 00 00 00 00       	mov    $0x0,%eax
  801595:	eb 14                	jmp    8015ab <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	0f b6 d0             	movzbl %al,%edx
  80159f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a2:	8a 00                	mov    (%eax),%al
  8015a4:	0f b6 c0             	movzbl %al,%eax
  8015a7:	29 c2                	sub    %eax,%edx
  8015a9:	89 d0                	mov    %edx,%eax
}
  8015ab:	5d                   	pop    %ebp
  8015ac:	c3                   	ret    

008015ad <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 04             	sub    $0x4,%esp
  8015b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b9:	eb 12                	jmp    8015cd <strchr+0x20>
		if (*s == c)
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015c3:	75 05                	jne    8015ca <strchr+0x1d>
			return (char *) s;
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	eb 11                	jmp    8015db <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015ca:	ff 45 08             	incl   0x8(%ebp)
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	84 c0                	test   %al,%al
  8015d4:	75 e5                	jne    8015bb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 04             	sub    $0x4,%esp
  8015e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015e9:	eb 0d                	jmp    8015f8 <strfind+0x1b>
		if (*s == c)
  8015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ee:	8a 00                	mov    (%eax),%al
  8015f0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015f3:	74 0e                	je     801603 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015f5:	ff 45 08             	incl   0x8(%ebp)
  8015f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fb:	8a 00                	mov    (%eax),%al
  8015fd:	84 c0                	test   %al,%al
  8015ff:	75 ea                	jne    8015eb <strfind+0xe>
  801601:	eb 01                	jmp    801604 <strfind+0x27>
		if (*s == c)
			break;
  801603:	90                   	nop
	return (char *) s;
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801615:	8b 45 10             	mov    0x10(%ebp),%eax
  801618:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80161b:	eb 0e                	jmp    80162b <memset+0x22>
		*p++ = c;
  80161d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801620:	8d 50 01             	lea    0x1(%eax),%edx
  801623:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801626:	8b 55 0c             	mov    0xc(%ebp),%edx
  801629:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80162b:	ff 4d f8             	decl   -0x8(%ebp)
  80162e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801632:	79 e9                	jns    80161d <memset+0x14>
		*p++ = c;

	return v;
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80163f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801642:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80164b:	eb 16                	jmp    801663 <memcpy+0x2a>
		*d++ = *s++;
  80164d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801650:	8d 50 01             	lea    0x1(%eax),%edx
  801653:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801656:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801659:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80165f:	8a 12                	mov    (%edx),%dl
  801661:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801663:	8b 45 10             	mov    0x10(%ebp),%eax
  801666:	8d 50 ff             	lea    -0x1(%eax),%edx
  801669:	89 55 10             	mov    %edx,0x10(%ebp)
  80166c:	85 c0                	test   %eax,%eax
  80166e:	75 dd                	jne    80164d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80167b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801687:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80168a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80168d:	73 50                	jae    8016df <memmove+0x6a>
  80168f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801692:	8b 45 10             	mov    0x10(%ebp),%eax
  801695:	01 d0                	add    %edx,%eax
  801697:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80169a:	76 43                	jbe    8016df <memmove+0x6a>
		s += n;
  80169c:	8b 45 10             	mov    0x10(%ebp),%eax
  80169f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016a8:	eb 10                	jmp    8016ba <memmove+0x45>
			*--d = *--s;
  8016aa:	ff 4d f8             	decl   -0x8(%ebp)
  8016ad:	ff 4d fc             	decl   -0x4(%ebp)
  8016b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016b3:	8a 10                	mov    (%eax),%dl
  8016b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016c0:	89 55 10             	mov    %edx,0x10(%ebp)
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	75 e3                	jne    8016aa <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016c7:	eb 23                	jmp    8016ec <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cc:	8d 50 01             	lea    0x1(%eax),%edx
  8016cf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016db:	8a 12                	mov    (%edx),%dl
  8016dd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016df:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e5:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	75 dd                	jne    8016c9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801700:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801703:	eb 2a                	jmp    80172f <memcmp+0x3e>
		if (*s1 != *s2)
  801705:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801708:	8a 10                	mov    (%eax),%dl
  80170a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170d:	8a 00                	mov    (%eax),%al
  80170f:	38 c2                	cmp    %al,%dl
  801711:	74 16                	je     801729 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801713:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801716:	8a 00                	mov    (%eax),%al
  801718:	0f b6 d0             	movzbl %al,%edx
  80171b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80171e:	8a 00                	mov    (%eax),%al
  801720:	0f b6 c0             	movzbl %al,%eax
  801723:	29 c2                	sub    %eax,%edx
  801725:	89 d0                	mov    %edx,%eax
  801727:	eb 18                	jmp    801741 <memcmp+0x50>
		s1++, s2++;
  801729:	ff 45 fc             	incl   -0x4(%ebp)
  80172c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80172f:	8b 45 10             	mov    0x10(%ebp),%eax
  801732:	8d 50 ff             	lea    -0x1(%eax),%edx
  801735:	89 55 10             	mov    %edx,0x10(%ebp)
  801738:	85 c0                	test   %eax,%eax
  80173a:	75 c9                	jne    801705 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80173c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801749:	8b 55 08             	mov    0x8(%ebp),%edx
  80174c:	8b 45 10             	mov    0x10(%ebp),%eax
  80174f:	01 d0                	add    %edx,%eax
  801751:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801754:	eb 15                	jmp    80176b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	8a 00                	mov    (%eax),%al
  80175b:	0f b6 d0             	movzbl %al,%edx
  80175e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801761:	0f b6 c0             	movzbl %al,%eax
  801764:	39 c2                	cmp    %eax,%edx
  801766:	74 0d                	je     801775 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801768:	ff 45 08             	incl   0x8(%ebp)
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801771:	72 e3                	jb     801756 <memfind+0x13>
  801773:	eb 01                	jmp    801776 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801775:	90                   	nop
	return (void *) s;
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801781:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801788:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80178f:	eb 03                	jmp    801794 <strtol+0x19>
		s++;
  801791:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	3c 20                	cmp    $0x20,%al
  80179b:	74 f4                	je     801791 <strtol+0x16>
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	8a 00                	mov    (%eax),%al
  8017a2:	3c 09                	cmp    $0x9,%al
  8017a4:	74 eb                	je     801791 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	8a 00                	mov    (%eax),%al
  8017ab:	3c 2b                	cmp    $0x2b,%al
  8017ad:	75 05                	jne    8017b4 <strtol+0x39>
		s++;
  8017af:	ff 45 08             	incl   0x8(%ebp)
  8017b2:	eb 13                	jmp    8017c7 <strtol+0x4c>
	else if (*s == '-')
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	8a 00                	mov    (%eax),%al
  8017b9:	3c 2d                	cmp    $0x2d,%al
  8017bb:	75 0a                	jne    8017c7 <strtol+0x4c>
		s++, neg = 1;
  8017bd:	ff 45 08             	incl   0x8(%ebp)
  8017c0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017cb:	74 06                	je     8017d3 <strtol+0x58>
  8017cd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017d1:	75 20                	jne    8017f3 <strtol+0x78>
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	8a 00                	mov    (%eax),%al
  8017d8:	3c 30                	cmp    $0x30,%al
  8017da:	75 17                	jne    8017f3 <strtol+0x78>
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	40                   	inc    %eax
  8017e0:	8a 00                	mov    (%eax),%al
  8017e2:	3c 78                	cmp    $0x78,%al
  8017e4:	75 0d                	jne    8017f3 <strtol+0x78>
		s += 2, base = 16;
  8017e6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017ea:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017f1:	eb 28                	jmp    80181b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f7:	75 15                	jne    80180e <strtol+0x93>
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	8a 00                	mov    (%eax),%al
  8017fe:	3c 30                	cmp    $0x30,%al
  801800:	75 0c                	jne    80180e <strtol+0x93>
		s++, base = 8;
  801802:	ff 45 08             	incl   0x8(%ebp)
  801805:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80180c:	eb 0d                	jmp    80181b <strtol+0xa0>
	else if (base == 0)
  80180e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801812:	75 07                	jne    80181b <strtol+0xa0>
		base = 10;
  801814:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	8a 00                	mov    (%eax),%al
  801820:	3c 2f                	cmp    $0x2f,%al
  801822:	7e 19                	jle    80183d <strtol+0xc2>
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	8a 00                	mov    (%eax),%al
  801829:	3c 39                	cmp    $0x39,%al
  80182b:	7f 10                	jg     80183d <strtol+0xc2>
			dig = *s - '0';
  80182d:	8b 45 08             	mov    0x8(%ebp),%eax
  801830:	8a 00                	mov    (%eax),%al
  801832:	0f be c0             	movsbl %al,%eax
  801835:	83 e8 30             	sub    $0x30,%eax
  801838:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80183b:	eb 42                	jmp    80187f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	3c 60                	cmp    $0x60,%al
  801844:	7e 19                	jle    80185f <strtol+0xe4>
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	3c 7a                	cmp    $0x7a,%al
  80184d:	7f 10                	jg     80185f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	8a 00                	mov    (%eax),%al
  801854:	0f be c0             	movsbl %al,%eax
  801857:	83 e8 57             	sub    $0x57,%eax
  80185a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80185d:	eb 20                	jmp    80187f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	3c 40                	cmp    $0x40,%al
  801866:	7e 39                	jle    8018a1 <strtol+0x126>
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	8a 00                	mov    (%eax),%al
  80186d:	3c 5a                	cmp    $0x5a,%al
  80186f:	7f 30                	jg     8018a1 <strtol+0x126>
			dig = *s - 'A' + 10;
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	8a 00                	mov    (%eax),%al
  801876:	0f be c0             	movsbl %al,%eax
  801879:	83 e8 37             	sub    $0x37,%eax
  80187c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80187f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801882:	3b 45 10             	cmp    0x10(%ebp),%eax
  801885:	7d 19                	jge    8018a0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801887:	ff 45 08             	incl   0x8(%ebp)
  80188a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80188d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801891:	89 c2                	mov    %eax,%edx
  801893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801896:	01 d0                	add    %edx,%eax
  801898:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80189b:	e9 7b ff ff ff       	jmp    80181b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018a0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018a5:	74 08                	je     8018af <strtol+0x134>
		*endptr = (char *) s;
  8018a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ad:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018af:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018b3:	74 07                	je     8018bc <strtol+0x141>
  8018b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b8:	f7 d8                	neg    %eax
  8018ba:	eb 03                	jmp    8018bf <strtol+0x144>
  8018bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <ltostr>:

void
ltostr(long value, char *str)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018ce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d9:	79 13                	jns    8018ee <ltostr+0x2d>
	{
		neg = 1;
  8018db:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018e8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018eb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018f6:	99                   	cltd   
  8018f7:	f7 f9                	idiv   %ecx
  8018f9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ff:	8d 50 01             	lea    0x1(%eax),%edx
  801902:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801905:	89 c2                	mov    %eax,%edx
  801907:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190a:	01 d0                	add    %edx,%eax
  80190c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80190f:	83 c2 30             	add    $0x30,%edx
  801912:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801914:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801917:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80191c:	f7 e9                	imul   %ecx
  80191e:	c1 fa 02             	sar    $0x2,%edx
  801921:	89 c8                	mov    %ecx,%eax
  801923:	c1 f8 1f             	sar    $0x1f,%eax
  801926:	29 c2                	sub    %eax,%edx
  801928:	89 d0                	mov    %edx,%eax
  80192a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80192d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801931:	75 bb                	jne    8018ee <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801933:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80193a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80193d:	48                   	dec    %eax
  80193e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801941:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801945:	74 3d                	je     801984 <ltostr+0xc3>
		start = 1 ;
  801947:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80194e:	eb 34                	jmp    801984 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801950:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801953:	8b 45 0c             	mov    0xc(%ebp),%eax
  801956:	01 d0                	add    %edx,%eax
  801958:	8a 00                	mov    (%eax),%al
  80195a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80195d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801960:	8b 45 0c             	mov    0xc(%ebp),%eax
  801963:	01 c2                	add    %eax,%edx
  801965:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196b:	01 c8                	add    %ecx,%eax
  80196d:	8a 00                	mov    (%eax),%al
  80196f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801971:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801974:	8b 45 0c             	mov    0xc(%ebp),%eax
  801977:	01 c2                	add    %eax,%edx
  801979:	8a 45 eb             	mov    -0x15(%ebp),%al
  80197c:	88 02                	mov    %al,(%edx)
		start++ ;
  80197e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801981:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801987:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80198a:	7c c4                	jl     801950 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80198c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80198f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801992:	01 d0                	add    %edx,%eax
  801994:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801997:	90                   	nop
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019a0:	ff 75 08             	pushl  0x8(%ebp)
  8019a3:	e8 73 fa ff ff       	call   80141b <strlen>
  8019a8:	83 c4 04             	add    $0x4,%esp
  8019ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019ae:	ff 75 0c             	pushl  0xc(%ebp)
  8019b1:	e8 65 fa ff ff       	call   80141b <strlen>
  8019b6:	83 c4 04             	add    $0x4,%esp
  8019b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019ca:	eb 17                	jmp    8019e3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d2:	01 c2                	add    %eax,%edx
  8019d4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	01 c8                	add    %ecx,%eax
  8019dc:	8a 00                	mov    (%eax),%al
  8019de:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019e0:	ff 45 fc             	incl   -0x4(%ebp)
  8019e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019e6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019e9:	7c e1                	jl     8019cc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019eb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019f9:	eb 1f                	jmp    801a1a <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fe:	8d 50 01             	lea    0x1(%eax),%edx
  801a01:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a04:	89 c2                	mov    %eax,%edx
  801a06:	8b 45 10             	mov    0x10(%ebp),%eax
  801a09:	01 c2                	add    %eax,%edx
  801a0b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a11:	01 c8                	add    %ecx,%eax
  801a13:	8a 00                	mov    (%eax),%al
  801a15:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a17:	ff 45 f8             	incl   -0x8(%ebp)
  801a1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a20:	7c d9                	jl     8019fb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a25:	8b 45 10             	mov    0x10(%ebp),%eax
  801a28:	01 d0                	add    %edx,%eax
  801a2a:	c6 00 00             	movb   $0x0,(%eax)
}
  801a2d:	90                   	nop
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a33:	8b 45 14             	mov    0x14(%ebp),%eax
  801a36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3f:	8b 00                	mov    (%eax),%eax
  801a41:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a48:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4b:	01 d0                	add    %edx,%eax
  801a4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a53:	eb 0c                	jmp    801a61 <strsplit+0x31>
			*string++ = 0;
  801a55:	8b 45 08             	mov    0x8(%ebp),%eax
  801a58:	8d 50 01             	lea    0x1(%eax),%edx
  801a5b:	89 55 08             	mov    %edx,0x8(%ebp)
  801a5e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	8a 00                	mov    (%eax),%al
  801a66:	84 c0                	test   %al,%al
  801a68:	74 18                	je     801a82 <strsplit+0x52>
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	8a 00                	mov    (%eax),%al
  801a6f:	0f be c0             	movsbl %al,%eax
  801a72:	50                   	push   %eax
  801a73:	ff 75 0c             	pushl  0xc(%ebp)
  801a76:	e8 32 fb ff ff       	call   8015ad <strchr>
  801a7b:	83 c4 08             	add    $0x8,%esp
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	75 d3                	jne    801a55 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	8a 00                	mov    (%eax),%al
  801a87:	84 c0                	test   %al,%al
  801a89:	74 5a                	je     801ae5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8e:	8b 00                	mov    (%eax),%eax
  801a90:	83 f8 0f             	cmp    $0xf,%eax
  801a93:	75 07                	jne    801a9c <strsplit+0x6c>
		{
			return 0;
  801a95:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9a:	eb 66                	jmp    801b02 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a9c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9f:	8b 00                	mov    (%eax),%eax
  801aa1:	8d 48 01             	lea    0x1(%eax),%ecx
  801aa4:	8b 55 14             	mov    0x14(%ebp),%edx
  801aa7:	89 0a                	mov    %ecx,(%edx)
  801aa9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ab0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab3:	01 c2                	add    %eax,%edx
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aba:	eb 03                	jmp    801abf <strsplit+0x8f>
			string++;
  801abc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	8a 00                	mov    (%eax),%al
  801ac4:	84 c0                	test   %al,%al
  801ac6:	74 8b                	je     801a53 <strsplit+0x23>
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	8a 00                	mov    (%eax),%al
  801acd:	0f be c0             	movsbl %al,%eax
  801ad0:	50                   	push   %eax
  801ad1:	ff 75 0c             	pushl  0xc(%ebp)
  801ad4:	e8 d4 fa ff ff       	call   8015ad <strchr>
  801ad9:	83 c4 08             	add    $0x8,%esp
  801adc:	85 c0                	test   %eax,%eax
  801ade:	74 dc                	je     801abc <strsplit+0x8c>
			string++;
	}
  801ae0:	e9 6e ff ff ff       	jmp    801a53 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ae5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ae6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae9:	8b 00                	mov    (%eax),%eax
  801aeb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af2:	8b 45 10             	mov    0x10(%ebp),%eax
  801af5:	01 d0                	add    %edx,%eax
  801af7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801afd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801b0a:	83 ec 04             	sub    $0x4,%esp
  801b0d:	68 bc 4d 80 00       	push   $0x804dbc
  801b12:	68 3f 01 00 00       	push   $0x13f
  801b17:	68 de 4d 80 00       	push   $0x804dde
  801b1c:	e8 a1 ed ff ff       	call   8008c2 <_panic>

00801b21 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801b27:	83 ec 0c             	sub    $0xc,%esp
  801b2a:	ff 75 08             	pushl  0x8(%ebp)
  801b2d:	e8 f8 0a 00 00       	call   80262a <sys_sbrk>
  801b32:	83 c4 10             	add    $0x10,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801b3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b41:	75 0a                	jne    801b4d <malloc+0x16>
  801b43:	b8 00 00 00 00       	mov    $0x0,%eax
  801b48:	e9 07 02 00 00       	jmp    801d54 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801b4d:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801b54:	8b 55 08             	mov    0x8(%ebp),%edx
  801b57:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b5a:	01 d0                	add    %edx,%eax
  801b5c:	48                   	dec    %eax
  801b5d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b60:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b63:	ba 00 00 00 00       	mov    $0x0,%edx
  801b68:	f7 75 dc             	divl   -0x24(%ebp)
  801b6b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b6e:	29 d0                	sub    %edx,%eax
  801b70:	c1 e8 0c             	shr    $0xc,%eax
  801b73:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801b76:	a1 20 60 80 00       	mov    0x806020,%eax
  801b7b:	8b 40 78             	mov    0x78(%eax),%eax
  801b7e:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801b83:	29 c2                	sub    %eax,%edx
  801b85:	89 d0                	mov    %edx,%eax
  801b87:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b8a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b8d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b92:	c1 e8 0c             	shr    $0xc,%eax
  801b95:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801b98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801b9f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801ba6:	77 42                	ja     801bea <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801ba8:	e8 01 09 00 00       	call   8024ae <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bad:	85 c0                	test   %eax,%eax
  801baf:	74 16                	je     801bc7 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801bb1:	83 ec 0c             	sub    $0xc,%esp
  801bb4:	ff 75 08             	pushl  0x8(%ebp)
  801bb7:	e8 dd 0e 00 00       	call   802a99 <alloc_block_FF>
  801bbc:	83 c4 10             	add    $0x10,%esp
  801bbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bc2:	e9 8a 01 00 00       	jmp    801d51 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801bc7:	e8 13 09 00 00       	call   8024df <sys_isUHeapPlacementStrategyBESTFIT>
  801bcc:	85 c0                	test   %eax,%eax
  801bce:	0f 84 7d 01 00 00    	je     801d51 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801bd4:	83 ec 0c             	sub    $0xc,%esp
  801bd7:	ff 75 08             	pushl  0x8(%ebp)
  801bda:	e8 76 13 00 00       	call   802f55 <alloc_block_BF>
  801bdf:	83 c4 10             	add    $0x10,%esp
  801be2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801be5:	e9 67 01 00 00       	jmp    801d51 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801bea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801bed:	48                   	dec    %eax
  801bee:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801bf1:	0f 86 53 01 00 00    	jbe    801d4a <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801bf7:	a1 20 60 80 00       	mov    0x806020,%eax
  801bfc:	8b 40 78             	mov    0x78(%eax),%eax
  801bff:	05 00 10 00 00       	add    $0x1000,%eax
  801c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801c07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801c0e:	e9 de 00 00 00       	jmp    801cf1 <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801c13:	a1 20 60 80 00       	mov    0x806020,%eax
  801c18:	8b 40 78             	mov    0x78(%eax),%eax
  801c1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c1e:	29 c2                	sub    %eax,%edx
  801c20:	89 d0                	mov    %edx,%eax
  801c22:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c27:	c1 e8 0c             	shr    $0xc,%eax
  801c2a:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  801c31:	85 c0                	test   %eax,%eax
  801c33:	0f 85 ab 00 00 00    	jne    801ce4 <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3c:	05 00 10 00 00       	add    $0x1000,%eax
  801c41:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801c44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  801c4b:	eb 47                	jmp    801c94 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801c4d:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801c54:	76 0a                	jbe    801c60 <malloc+0x129>
  801c56:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5b:	e9 f4 00 00 00       	jmp    801d54 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801c60:	a1 20 60 80 00       	mov    0x806020,%eax
  801c65:	8b 40 78             	mov    0x78(%eax),%eax
  801c68:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c6b:	29 c2                	sub    %eax,%edx
  801c6d:	89 d0                	mov    %edx,%eax
  801c6f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c74:	c1 e8 0c             	shr    $0xc,%eax
  801c77:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	74 08                	je     801c8a <malloc+0x153>
					{
						
						i = j;
  801c82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c85:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801c88:	eb 5a                	jmp    801ce4 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801c8a:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801c91:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  801c94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c97:	48                   	dec    %eax
  801c98:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c9b:	77 b0                	ja     801c4d <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801c9d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801ca4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801cab:	eb 2f                	jmp    801cdc <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801cad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cb0:	c1 e0 0c             	shl    $0xc,%eax
  801cb3:	89 c2                	mov    %eax,%edx
  801cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb8:	01 c2                	add    %eax,%edx
  801cba:	a1 20 60 80 00       	mov    0x806020,%eax
  801cbf:	8b 40 78             	mov    0x78(%eax),%eax
  801cc2:	29 c2                	sub    %eax,%edx
  801cc4:	89 d0                	mov    %edx,%eax
  801cc6:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ccb:	c1 e8 0c             	shr    $0xc,%eax
  801cce:	c7 04 85 60 60 88 00 	movl   $0x1,0x886060(,%eax,4)
  801cd5:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801cd9:	ff 45 e0             	incl   -0x20(%ebp)
  801cdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cdf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ce2:	72 c9                	jb     801cad <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  801ce4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ce8:	75 16                	jne    801d00 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801cea:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801cf1:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801cf8:	0f 86 15 ff ff ff    	jbe    801c13 <malloc+0xdc>
  801cfe:	eb 01                	jmp    801d01 <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  801d00:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801d01:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d05:	75 07                	jne    801d0e <malloc+0x1d7>
  801d07:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0c:	eb 46                	jmp    801d54 <malloc+0x21d>
		ptr = (void*)i;
  801d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801d14:	a1 20 60 80 00       	mov    0x806020,%eax
  801d19:	8b 40 78             	mov    0x78(%eax),%eax
  801d1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d1f:	29 c2                	sub    %eax,%edx
  801d21:	89 d0                	mov    %edx,%eax
  801d23:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d28:	c1 e8 0c             	shr    $0xc,%eax
  801d2b:	89 c2                	mov    %eax,%edx
  801d2d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d30:	89 04 95 60 60 90 00 	mov    %eax,0x906060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801d37:	83 ec 08             	sub    $0x8,%esp
  801d3a:	ff 75 08             	pushl  0x8(%ebp)
  801d3d:	ff 75 f0             	pushl  -0x10(%ebp)
  801d40:	e8 1c 09 00 00       	call   802661 <sys_allocate_user_mem>
  801d45:	83 c4 10             	add    $0x10,%esp
  801d48:	eb 07                	jmp    801d51 <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  801d4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4f:	eb 03                	jmp    801d54 <malloc+0x21d>
	}
	return ptr;
  801d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801d5c:	a1 20 60 80 00       	mov    0x806020,%eax
  801d61:	8b 40 78             	mov    0x78(%eax),%eax
  801d64:	05 00 10 00 00       	add    $0x1000,%eax
  801d69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801d6c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801d73:	a1 20 60 80 00       	mov    0x806020,%eax
  801d78:	8b 50 78             	mov    0x78(%eax),%edx
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	39 c2                	cmp    %eax,%edx
  801d80:	76 24                	jbe    801da6 <free+0x50>
		size = get_block_size(va);
  801d82:	83 ec 0c             	sub    $0xc,%esp
  801d85:	ff 75 08             	pushl  0x8(%ebp)
  801d88:	e8 8c 09 00 00       	call   802719 <get_block_size>
  801d8d:	83 c4 10             	add    $0x10,%esp
  801d90:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d93:	83 ec 0c             	sub    $0xc,%esp
  801d96:	ff 75 08             	pushl  0x8(%ebp)
  801d99:	e8 9c 1b 00 00       	call   80393a <free_block>
  801d9e:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801da1:	e9 ac 00 00 00       	jmp    801e52 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801dac:	0f 82 89 00 00 00    	jb     801e3b <free+0xe5>
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801dba:	77 7f                	ja     801e3b <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801dbc:	8b 55 08             	mov    0x8(%ebp),%edx
  801dbf:	a1 20 60 80 00       	mov    0x806020,%eax
  801dc4:	8b 40 78             	mov    0x78(%eax),%eax
  801dc7:	29 c2                	sub    %eax,%edx
  801dc9:	89 d0                	mov    %edx,%eax
  801dcb:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dd0:	c1 e8 0c             	shr    $0xc,%eax
  801dd3:	8b 04 85 60 60 90 00 	mov    0x906060(,%eax,4),%eax
  801dda:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801ddd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801de0:	c1 e0 0c             	shl    $0xc,%eax
  801de3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801de6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ded:	eb 42                	jmp    801e31 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df2:	c1 e0 0c             	shl    $0xc,%eax
  801df5:	89 c2                	mov    %eax,%edx
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	01 c2                	add    %eax,%edx
  801dfc:	a1 20 60 80 00       	mov    0x806020,%eax
  801e01:	8b 40 78             	mov    0x78(%eax),%eax
  801e04:	29 c2                	sub    %eax,%edx
  801e06:	89 d0                	mov    %edx,%eax
  801e08:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e0d:	c1 e8 0c             	shr    $0xc,%eax
  801e10:	c7 04 85 60 60 88 00 	movl   $0x0,0x886060(,%eax,4)
  801e17:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801e1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	83 ec 08             	sub    $0x8,%esp
  801e24:	52                   	push   %edx
  801e25:	50                   	push   %eax
  801e26:	e8 1a 08 00 00       	call   802645 <sys_free_user_mem>
  801e2b:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801e2e:	ff 45 f4             	incl   -0xc(%ebp)
  801e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e34:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e37:	72 b6                	jb     801def <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801e39:	eb 17                	jmp    801e52 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801e3b:	83 ec 04             	sub    $0x4,%esp
  801e3e:	68 ec 4d 80 00       	push   $0x804dec
  801e43:	68 87 00 00 00       	push   $0x87
  801e48:	68 16 4e 80 00       	push   $0x804e16
  801e4d:	e8 70 ea ff ff       	call   8008c2 <_panic>
	}
}
  801e52:	90                   	nop
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	83 ec 28             	sub    $0x28,%esp
  801e5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5e:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801e61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e65:	75 0a                	jne    801e71 <smalloc+0x1c>
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6c:	e9 87 00 00 00       	jmp    801ef8 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e77:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e84:	39 d0                	cmp    %edx,%eax
  801e86:	73 02                	jae    801e8a <smalloc+0x35>
  801e88:	89 d0                	mov    %edx,%eax
  801e8a:	83 ec 0c             	sub    $0xc,%esp
  801e8d:	50                   	push   %eax
  801e8e:	e8 a4 fc ff ff       	call   801b37 <malloc>
  801e93:	83 c4 10             	add    $0x10,%esp
  801e96:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801e99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e9d:	75 07                	jne    801ea6 <smalloc+0x51>
  801e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea4:	eb 52                	jmp    801ef8 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801ea6:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801eaa:	ff 75 ec             	pushl  -0x14(%ebp)
  801ead:	50                   	push   %eax
  801eae:	ff 75 0c             	pushl  0xc(%ebp)
  801eb1:	ff 75 08             	pushl  0x8(%ebp)
  801eb4:	e8 93 03 00 00       	call   80224c <sys_createSharedObject>
  801eb9:	83 c4 10             	add    $0x10,%esp
  801ebc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801ebf:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801ec3:	74 06                	je     801ecb <smalloc+0x76>
  801ec5:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801ec9:	75 07                	jne    801ed2 <smalloc+0x7d>
  801ecb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed0:	eb 26                	jmp    801ef8 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801ed2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ed5:	a1 20 60 80 00       	mov    0x806020,%eax
  801eda:	8b 40 78             	mov    0x78(%eax),%eax
  801edd:	29 c2                	sub    %eax,%edx
  801edf:	89 d0                	mov    %edx,%eax
  801ee1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ee6:	c1 e8 0c             	shr    $0xc,%eax
  801ee9:	89 c2                	mov    %eax,%edx
  801eeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801eee:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	 return ptr;
  801ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f00:	83 ec 08             	sub    $0x8,%esp
  801f03:	ff 75 0c             	pushl  0xc(%ebp)
  801f06:	ff 75 08             	pushl  0x8(%ebp)
  801f09:	e8 68 03 00 00       	call   802276 <sys_getSizeOfSharedObject>
  801f0e:	83 c4 10             	add    $0x10,%esp
  801f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801f14:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801f18:	75 07                	jne    801f21 <sget+0x27>
  801f1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1f:	eb 7f                	jmp    801fa0 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f27:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f2e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f34:	39 d0                	cmp    %edx,%eax
  801f36:	73 02                	jae    801f3a <sget+0x40>
  801f38:	89 d0                	mov    %edx,%eax
  801f3a:	83 ec 0c             	sub    $0xc,%esp
  801f3d:	50                   	push   %eax
  801f3e:	e8 f4 fb ff ff       	call   801b37 <malloc>
  801f43:	83 c4 10             	add    $0x10,%esp
  801f46:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801f49:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f4d:	75 07                	jne    801f56 <sget+0x5c>
  801f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f54:	eb 4a                	jmp    801fa0 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801f56:	83 ec 04             	sub    $0x4,%esp
  801f59:	ff 75 e8             	pushl  -0x18(%ebp)
  801f5c:	ff 75 0c             	pushl  0xc(%ebp)
  801f5f:	ff 75 08             	pushl  0x8(%ebp)
  801f62:	e8 2c 03 00 00       	call   802293 <sys_getSharedObject>
  801f67:	83 c4 10             	add    $0x10,%esp
  801f6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801f6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f70:	a1 20 60 80 00       	mov    0x806020,%eax
  801f75:	8b 40 78             	mov    0x78(%eax),%eax
  801f78:	29 c2                	sub    %eax,%edx
  801f7a:	89 d0                	mov    %edx,%eax
  801f7c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f81:	c1 e8 0c             	shr    $0xc,%eax
  801f84:	89 c2                	mov    %eax,%edx
  801f86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f89:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801f90:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801f94:	75 07                	jne    801f9d <sget+0xa3>
  801f96:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9b:	eb 03                	jmp    801fa0 <sget+0xa6>
	return ptr;
  801f9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801fa8:	8b 55 08             	mov    0x8(%ebp),%edx
  801fab:	a1 20 60 80 00       	mov    0x806020,%eax
  801fb0:	8b 40 78             	mov    0x78(%eax),%eax
  801fb3:	29 c2                	sub    %eax,%edx
  801fb5:	89 d0                	mov    %edx,%eax
  801fb7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fbc:	c1 e8 0c             	shr    $0xc,%eax
  801fbf:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  801fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801fc9:	83 ec 08             	sub    $0x8,%esp
  801fcc:	ff 75 08             	pushl  0x8(%ebp)
  801fcf:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd2:	e8 db 02 00 00       	call   8022b2 <sys_freeSharedObject>
  801fd7:	83 c4 10             	add    $0x10,%esp
  801fda:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801fdd:	90                   	nop
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fe6:	83 ec 04             	sub    $0x4,%esp
  801fe9:	68 24 4e 80 00       	push   $0x804e24
  801fee:	68 e4 00 00 00       	push   $0xe4
  801ff3:	68 16 4e 80 00       	push   $0x804e16
  801ff8:	e8 c5 e8 ff ff       	call   8008c2 <_panic>

00801ffd <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
  802000:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802003:	83 ec 04             	sub    $0x4,%esp
  802006:	68 4a 4e 80 00       	push   $0x804e4a
  80200b:	68 f0 00 00 00       	push   $0xf0
  802010:	68 16 4e 80 00       	push   $0x804e16
  802015:	e8 a8 e8 ff ff       	call   8008c2 <_panic>

0080201a <shrink>:

}
void shrink(uint32 newSize)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802020:	83 ec 04             	sub    $0x4,%esp
  802023:	68 4a 4e 80 00       	push   $0x804e4a
  802028:	68 f5 00 00 00       	push   $0xf5
  80202d:	68 16 4e 80 00       	push   $0x804e16
  802032:	e8 8b e8 ff ff       	call   8008c2 <_panic>

00802037 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80203d:	83 ec 04             	sub    $0x4,%esp
  802040:	68 4a 4e 80 00       	push   $0x804e4a
  802045:	68 fa 00 00 00       	push   $0xfa
  80204a:	68 16 4e 80 00       	push   $0x804e16
  80204f:	e8 6e e8 ff ff       	call   8008c2 <_panic>

00802054 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	57                   	push   %edi
  802058:	56                   	push   %esi
  802059:	53                   	push   %ebx
  80205a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	8b 55 0c             	mov    0xc(%ebp),%edx
  802063:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802066:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802069:	8b 7d 18             	mov    0x18(%ebp),%edi
  80206c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80206f:	cd 30                	int    $0x30
  802071:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802074:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802077:	83 c4 10             	add    $0x10,%esp
  80207a:	5b                   	pop    %ebx
  80207b:	5e                   	pop    %esi
  80207c:	5f                   	pop    %edi
  80207d:	5d                   	pop    %ebp
  80207e:	c3                   	ret    

0080207f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 04             	sub    $0x4,%esp
  802085:	8b 45 10             	mov    0x10(%ebp),%eax
  802088:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80208b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	52                   	push   %edx
  802097:	ff 75 0c             	pushl  0xc(%ebp)
  80209a:	50                   	push   %eax
  80209b:	6a 00                	push   $0x0
  80209d:	e8 b2 ff ff ff       	call   802054 <syscall>
  8020a2:	83 c4 18             	add    $0x18,%esp
}
  8020a5:	90                   	nop
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 02                	push   $0x2
  8020b7:	e8 98 ff ff ff       	call   802054 <syscall>
  8020bc:	83 c4 18             	add    $0x18,%esp
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 03                	push   $0x3
  8020d0:	e8 7f ff ff ff       	call   802054 <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
}
  8020d8:	90                   	nop
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 04                	push   $0x4
  8020ea:	e8 65 ff ff ff       	call   802054 <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
}
  8020f2:	90                   	nop
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	52                   	push   %edx
  802105:	50                   	push   %eax
  802106:	6a 08                	push   $0x8
  802108:	e8 47 ff ff ff       	call   802054 <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	56                   	push   %esi
  802116:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802117:	8b 75 18             	mov    0x18(%ebp),%esi
  80211a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80211d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802120:	8b 55 0c             	mov    0xc(%ebp),%edx
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	56                   	push   %esi
  802127:	53                   	push   %ebx
  802128:	51                   	push   %ecx
  802129:	52                   	push   %edx
  80212a:	50                   	push   %eax
  80212b:	6a 09                	push   $0x9
  80212d:	e8 22 ff ff ff       	call   802054 <syscall>
  802132:	83 c4 18             	add    $0x18,%esp
}
  802135:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802138:	5b                   	pop    %ebx
  802139:	5e                   	pop    %esi
  80213a:	5d                   	pop    %ebp
  80213b:	c3                   	ret    

0080213c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80213f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	52                   	push   %edx
  80214c:	50                   	push   %eax
  80214d:	6a 0a                	push   $0xa
  80214f:	e8 00 ff ff ff       	call   802054 <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	ff 75 0c             	pushl  0xc(%ebp)
  802165:	ff 75 08             	pushl  0x8(%ebp)
  802168:	6a 0b                	push   $0xb
  80216a:	e8 e5 fe ff ff       	call   802054 <syscall>
  80216f:	83 c4 18             	add    $0x18,%esp
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 0c                	push   $0xc
  802183:	e8 cc fe ff ff       	call   802054 <syscall>
  802188:	83 c4 18             	add    $0x18,%esp
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 0d                	push   $0xd
  80219c:	e8 b3 fe ff ff       	call   802054 <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 0e                	push   $0xe
  8021b5:	e8 9a fe ff ff       	call   802054 <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 0f                	push   $0xf
  8021ce:	e8 81 fe ff ff       	call   802054 <syscall>
  8021d3:	83 c4 18             	add    $0x18,%esp
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	ff 75 08             	pushl  0x8(%ebp)
  8021e6:	6a 10                	push   $0x10
  8021e8:	e8 67 fe ff ff       	call   802054 <syscall>
  8021ed:	83 c4 18             	add    $0x18,%esp
}
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 11                	push   $0x11
  802201:	e8 4e fe ff ff       	call   802054 <syscall>
  802206:	83 c4 18             	add    $0x18,%esp
}
  802209:	90                   	nop
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <sys_cputc>:

void
sys_cputc(const char c)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 04             	sub    $0x4,%esp
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802218:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	50                   	push   %eax
  802225:	6a 01                	push   $0x1
  802227:	e8 28 fe ff ff       	call   802054 <syscall>
  80222c:	83 c4 18             	add    $0x18,%esp
}
  80222f:	90                   	nop
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 14                	push   $0x14
  802241:	e8 0e fe ff ff       	call   802054 <syscall>
  802246:	83 c4 18             	add    $0x18,%esp
}
  802249:	90                   	nop
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
  80224f:	83 ec 04             	sub    $0x4,%esp
  802252:	8b 45 10             	mov    0x10(%ebp),%eax
  802255:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802258:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80225b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	6a 00                	push   $0x0
  802264:	51                   	push   %ecx
  802265:	52                   	push   %edx
  802266:	ff 75 0c             	pushl  0xc(%ebp)
  802269:	50                   	push   %eax
  80226a:	6a 15                	push   $0x15
  80226c:	e8 e3 fd ff ff       	call   802054 <syscall>
  802271:	83 c4 18             	add    $0x18,%esp
}
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802279:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227c:	8b 45 08             	mov    0x8(%ebp),%eax
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	52                   	push   %edx
  802286:	50                   	push   %eax
  802287:	6a 16                	push   $0x16
  802289:	e8 c6 fd ff ff       	call   802054 <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802296:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802299:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	51                   	push   %ecx
  8022a4:	52                   	push   %edx
  8022a5:	50                   	push   %eax
  8022a6:	6a 17                	push   $0x17
  8022a8:	e8 a7 fd ff ff       	call   802054 <syscall>
  8022ad:	83 c4 18             	add    $0x18,%esp
}
  8022b0:	c9                   	leave  
  8022b1:	c3                   	ret    

008022b2 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8022b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	52                   	push   %edx
  8022c2:	50                   	push   %eax
  8022c3:	6a 18                	push   $0x18
  8022c5:	e8 8a fd ff ff       	call   802054 <syscall>
  8022ca:	83 c4 18             	add    $0x18,%esp
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	6a 00                	push   $0x0
  8022d7:	ff 75 14             	pushl  0x14(%ebp)
  8022da:	ff 75 10             	pushl  0x10(%ebp)
  8022dd:	ff 75 0c             	pushl  0xc(%ebp)
  8022e0:	50                   	push   %eax
  8022e1:	6a 19                	push   $0x19
  8022e3:	e8 6c fd ff ff       	call   802054 <syscall>
  8022e8:	83 c4 18             	add    $0x18,%esp
}
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <sys_run_env>:

void sys_run_env(int32 envId)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	50                   	push   %eax
  8022fc:	6a 1a                	push   $0x1a
  8022fe:	e8 51 fd ff ff       	call   802054 <syscall>
  802303:	83 c4 18             	add    $0x18,%esp
}
  802306:	90                   	nop
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	50                   	push   %eax
  802318:	6a 1b                	push   $0x1b
  80231a:	e8 35 fd ff ff       	call   802054 <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 05                	push   $0x5
  802333:	e8 1c fd ff ff       	call   802054 <syscall>
  802338:	83 c4 18             	add    $0x18,%esp
}
  80233b:	c9                   	leave  
  80233c:	c3                   	ret    

0080233d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 06                	push   $0x6
  80234c:	e8 03 fd ff ff       	call   802054 <syscall>
  802351:	83 c4 18             	add    $0x18,%esp
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 07                	push   $0x7
  802365:	e8 ea fc ff ff       	call   802054 <syscall>
  80236a:	83 c4 18             	add    $0x18,%esp
}
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    

0080236f <sys_exit_env>:


void sys_exit_env(void)
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 1c                	push   $0x1c
  80237e:	e8 d1 fc ff ff       	call   802054 <syscall>
  802383:	83 c4 18             	add    $0x18,%esp
}
  802386:	90                   	nop
  802387:	c9                   	leave  
  802388:	c3                   	ret    

00802389 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
  80238c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80238f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802392:	8d 50 04             	lea    0x4(%eax),%edx
  802395:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	52                   	push   %edx
  80239f:	50                   	push   %eax
  8023a0:	6a 1d                	push   $0x1d
  8023a2:	e8 ad fc ff ff       	call   802054 <syscall>
  8023a7:	83 c4 18             	add    $0x18,%esp
	return result;
  8023aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023b3:	89 01                	mov    %eax,(%ecx)
  8023b5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	c9                   	leave  
  8023bc:	c2 04 00             	ret    $0x4

008023bf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	ff 75 10             	pushl  0x10(%ebp)
  8023c9:	ff 75 0c             	pushl  0xc(%ebp)
  8023cc:	ff 75 08             	pushl  0x8(%ebp)
  8023cf:	6a 13                	push   $0x13
  8023d1:	e8 7e fc ff ff       	call   802054 <syscall>
  8023d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d9:	90                   	nop
}
  8023da:	c9                   	leave  
  8023db:	c3                   	ret    

008023dc <sys_rcr2>:
uint32 sys_rcr2()
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 1e                	push   $0x1e
  8023eb:	e8 64 fc ff ff       	call   802054 <syscall>
  8023f0:	83 c4 18             	add    $0x18,%esp
}
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    

008023f5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
  8023f8:	83 ec 04             	sub    $0x4,%esp
  8023fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802401:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	50                   	push   %eax
  80240e:	6a 1f                	push   $0x1f
  802410:	e8 3f fc ff ff       	call   802054 <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
	return ;
  802418:	90                   	nop
}
  802419:	c9                   	leave  
  80241a:	c3                   	ret    

0080241b <rsttst>:
void rsttst()
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 21                	push   $0x21
  80242a:	e8 25 fc ff ff       	call   802054 <syscall>
  80242f:	83 c4 18             	add    $0x18,%esp
	return ;
  802432:	90                   	nop
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
  802438:	83 ec 04             	sub    $0x4,%esp
  80243b:	8b 45 14             	mov    0x14(%ebp),%eax
  80243e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802441:	8b 55 18             	mov    0x18(%ebp),%edx
  802444:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802448:	52                   	push   %edx
  802449:	50                   	push   %eax
  80244a:	ff 75 10             	pushl  0x10(%ebp)
  80244d:	ff 75 0c             	pushl  0xc(%ebp)
  802450:	ff 75 08             	pushl  0x8(%ebp)
  802453:	6a 20                	push   $0x20
  802455:	e8 fa fb ff ff       	call   802054 <syscall>
  80245a:	83 c4 18             	add    $0x18,%esp
	return ;
  80245d:	90                   	nop
}
  80245e:	c9                   	leave  
  80245f:	c3                   	ret    

00802460 <chktst>:
void chktst(uint32 n)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	ff 75 08             	pushl  0x8(%ebp)
  80246e:	6a 22                	push   $0x22
  802470:	e8 df fb ff ff       	call   802054 <syscall>
  802475:	83 c4 18             	add    $0x18,%esp
	return ;
  802478:	90                   	nop
}
  802479:	c9                   	leave  
  80247a:	c3                   	ret    

0080247b <inctst>:

void inctst()
{
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 23                	push   $0x23
  80248a:	e8 c5 fb ff ff       	call   802054 <syscall>
  80248f:	83 c4 18             	add    $0x18,%esp
	return ;
  802492:	90                   	nop
}
  802493:	c9                   	leave  
  802494:	c3                   	ret    

00802495 <gettst>:
uint32 gettst()
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 24                	push   $0x24
  8024a4:	e8 ab fb ff ff       	call   802054 <syscall>
  8024a9:	83 c4 18             	add    $0x18,%esp
}
  8024ac:	c9                   	leave  
  8024ad:	c3                   	ret    

008024ae <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
  8024b1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 25                	push   $0x25
  8024c0:	e8 8f fb ff ff       	call   802054 <syscall>
  8024c5:	83 c4 18             	add    $0x18,%esp
  8024c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024cb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024cf:	75 07                	jne    8024d8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d6:	eb 05                	jmp    8024dd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024dd:	c9                   	leave  
  8024de:	c3                   	ret    

008024df <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
  8024e2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 25                	push   $0x25
  8024f1:	e8 5e fb ff ff       	call   802054 <syscall>
  8024f6:	83 c4 18             	add    $0x18,%esp
  8024f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024fc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802500:	75 07                	jne    802509 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802502:	b8 01 00 00 00       	mov    $0x1,%eax
  802507:	eb 05                	jmp    80250e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802509:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80250e:	c9                   	leave  
  80250f:	c3                   	ret    

00802510 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 25                	push   $0x25
  802522:	e8 2d fb ff ff       	call   802054 <syscall>
  802527:	83 c4 18             	add    $0x18,%esp
  80252a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80252d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802531:	75 07                	jne    80253a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802533:	b8 01 00 00 00       	mov    $0x1,%eax
  802538:	eb 05                	jmp    80253f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80253a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80253f:	c9                   	leave  
  802540:	c3                   	ret    

00802541 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802541:	55                   	push   %ebp
  802542:	89 e5                	mov    %esp,%ebp
  802544:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 25                	push   $0x25
  802553:	e8 fc fa ff ff       	call   802054 <syscall>
  802558:	83 c4 18             	add    $0x18,%esp
  80255b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80255e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802562:	75 07                	jne    80256b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802564:	b8 01 00 00 00       	mov    $0x1,%eax
  802569:	eb 05                	jmp    802570 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80256b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	ff 75 08             	pushl  0x8(%ebp)
  802580:	6a 26                	push   $0x26
  802582:	e8 cd fa ff ff       	call   802054 <syscall>
  802587:	83 c4 18             	add    $0x18,%esp
	return ;
  80258a:	90                   	nop
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
  802590:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802591:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802594:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802597:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259a:	8b 45 08             	mov    0x8(%ebp),%eax
  80259d:	6a 00                	push   $0x0
  80259f:	53                   	push   %ebx
  8025a0:	51                   	push   %ecx
  8025a1:	52                   	push   %edx
  8025a2:	50                   	push   %eax
  8025a3:	6a 27                	push   $0x27
  8025a5:	e8 aa fa ff ff       	call   802054 <syscall>
  8025aa:	83 c4 18             	add    $0x18,%esp
}
  8025ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025b0:	c9                   	leave  
  8025b1:	c3                   	ret    

008025b2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8025b2:	55                   	push   %ebp
  8025b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8025b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	52                   	push   %edx
  8025c2:	50                   	push   %eax
  8025c3:	6a 28                	push   $0x28
  8025c5:	e8 8a fa ff ff       	call   802054 <syscall>
  8025ca:	83 c4 18             	add    $0x18,%esp
}
  8025cd:	c9                   	leave  
  8025ce:	c3                   	ret    

008025cf <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8025d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8025d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025db:	6a 00                	push   $0x0
  8025dd:	51                   	push   %ecx
  8025de:	ff 75 10             	pushl  0x10(%ebp)
  8025e1:	52                   	push   %edx
  8025e2:	50                   	push   %eax
  8025e3:	6a 29                	push   $0x29
  8025e5:	e8 6a fa ff ff       	call   802054 <syscall>
  8025ea:	83 c4 18             	add    $0x18,%esp
}
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	ff 75 10             	pushl  0x10(%ebp)
  8025f9:	ff 75 0c             	pushl  0xc(%ebp)
  8025fc:	ff 75 08             	pushl  0x8(%ebp)
  8025ff:	6a 12                	push   $0x12
  802601:	e8 4e fa ff ff       	call   802054 <syscall>
  802606:	83 c4 18             	add    $0x18,%esp
	return ;
  802609:	90                   	nop
}
  80260a:	c9                   	leave  
  80260b:	c3                   	ret    

0080260c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80260c:	55                   	push   %ebp
  80260d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80260f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802612:	8b 45 08             	mov    0x8(%ebp),%eax
  802615:	6a 00                	push   $0x0
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	52                   	push   %edx
  80261c:	50                   	push   %eax
  80261d:	6a 2a                	push   $0x2a
  80261f:	e8 30 fa ff ff       	call   802054 <syscall>
  802624:	83 c4 18             	add    $0x18,%esp
	return;
  802627:	90                   	nop
}
  802628:	c9                   	leave  
  802629:	c3                   	ret    

0080262a <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80262a:	55                   	push   %ebp
  80262b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80262d:	8b 45 08             	mov    0x8(%ebp),%eax
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	50                   	push   %eax
  802639:	6a 2b                	push   $0x2b
  80263b:	e8 14 fa ff ff       	call   802054 <syscall>
  802640:	83 c4 18             	add    $0x18,%esp
}
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802648:	6a 00                	push   $0x0
  80264a:	6a 00                	push   $0x0
  80264c:	6a 00                	push   $0x0
  80264e:	ff 75 0c             	pushl  0xc(%ebp)
  802651:	ff 75 08             	pushl  0x8(%ebp)
  802654:	6a 2c                	push   $0x2c
  802656:	e8 f9 f9 ff ff       	call   802054 <syscall>
  80265b:	83 c4 18             	add    $0x18,%esp
	return;
  80265e:	90                   	nop
}
  80265f:	c9                   	leave  
  802660:	c3                   	ret    

00802661 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802661:	55                   	push   %ebp
  802662:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802664:	6a 00                	push   $0x0
  802666:	6a 00                	push   $0x0
  802668:	6a 00                	push   $0x0
  80266a:	ff 75 0c             	pushl  0xc(%ebp)
  80266d:	ff 75 08             	pushl  0x8(%ebp)
  802670:	6a 2d                	push   $0x2d
  802672:	e8 dd f9 ff ff       	call   802054 <syscall>
  802677:	83 c4 18             	add    $0x18,%esp
	return;
  80267a:	90                   	nop
}
  80267b:	c9                   	leave  
  80267c:	c3                   	ret    

0080267d <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
  802680:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  802683:	6a 00                	push   $0x0
  802685:	6a 00                	push   $0x0
  802687:	6a 00                	push   $0x0
  802689:	6a 00                	push   $0x0
  80268b:	6a 00                	push   $0x0
  80268d:	6a 2e                	push   $0x2e
  80268f:	e8 c0 f9 ff ff       	call   802054 <syscall>
  802694:	83 c4 18             	add    $0x18,%esp
  802697:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  80269a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80269d:	c9                   	leave  
  80269e:	c3                   	ret    

0080269f <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  80269f:	55                   	push   %ebp
  8026a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  8026a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	50                   	push   %eax
  8026ae:	6a 2f                	push   $0x2f
  8026b0:	e8 9f f9 ff ff       	call   802054 <syscall>
  8026b5:	83 c4 18             	add    $0x18,%esp
	return;
  8026b8:	90                   	nop
}
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    

008026bb <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  8026be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	52                   	push   %edx
  8026cb:	50                   	push   %eax
  8026cc:	6a 30                	push   $0x30
  8026ce:	e8 81 f9 ff ff       	call   802054 <syscall>
  8026d3:	83 c4 18             	add    $0x18,%esp
	return;
  8026d6:	90                   	nop
}
  8026d7:	c9                   	leave  
  8026d8:	c3                   	ret    

008026d9 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  8026d9:	55                   	push   %ebp
  8026da:	89 e5                	mov    %esp,%ebp
  8026dc:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  8026df:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e2:	6a 00                	push   $0x0
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	50                   	push   %eax
  8026eb:	6a 31                	push   $0x31
  8026ed:	e8 62 f9 ff ff       	call   802054 <syscall>
  8026f2:	83 c4 18             	add    $0x18,%esp
  8026f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8026f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8026fb:	c9                   	leave  
  8026fc:	c3                   	ret    

008026fd <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  8026fd:	55                   	push   %ebp
  8026fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  802700:	8b 45 08             	mov    0x8(%ebp),%eax
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	6a 00                	push   $0x0
  80270b:	50                   	push   %eax
  80270c:	6a 32                	push   $0x32
  80270e:	e8 41 f9 ff ff       	call   802054 <syscall>
  802713:	83 c4 18             	add    $0x18,%esp
	return;
  802716:	90                   	nop
}
  802717:	c9                   	leave  
  802718:	c3                   	ret    

00802719 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
  80271c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80271f:	8b 45 08             	mov    0x8(%ebp),%eax
  802722:	83 e8 04             	sub    $0x4,%eax
  802725:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802728:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80272b:	8b 00                	mov    (%eax),%eax
  80272d:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802730:	c9                   	leave  
  802731:	c3                   	ret    

00802732 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802732:	55                   	push   %ebp
  802733:	89 e5                	mov    %esp,%ebp
  802735:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802738:	8b 45 08             	mov    0x8(%ebp),%eax
  80273b:	83 e8 04             	sub    $0x4,%eax
  80273e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802741:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802744:	8b 00                	mov    (%eax),%eax
  802746:	83 e0 01             	and    $0x1,%eax
  802749:	85 c0                	test   %eax,%eax
  80274b:	0f 94 c0             	sete   %al
}
  80274e:	c9                   	leave  
  80274f:	c3                   	ret    

00802750 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802750:	55                   	push   %ebp
  802751:	89 e5                	mov    %esp,%ebp
  802753:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802756:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80275d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802760:	83 f8 02             	cmp    $0x2,%eax
  802763:	74 2b                	je     802790 <alloc_block+0x40>
  802765:	83 f8 02             	cmp    $0x2,%eax
  802768:	7f 07                	jg     802771 <alloc_block+0x21>
  80276a:	83 f8 01             	cmp    $0x1,%eax
  80276d:	74 0e                	je     80277d <alloc_block+0x2d>
  80276f:	eb 58                	jmp    8027c9 <alloc_block+0x79>
  802771:	83 f8 03             	cmp    $0x3,%eax
  802774:	74 2d                	je     8027a3 <alloc_block+0x53>
  802776:	83 f8 04             	cmp    $0x4,%eax
  802779:	74 3b                	je     8027b6 <alloc_block+0x66>
  80277b:	eb 4c                	jmp    8027c9 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80277d:	83 ec 0c             	sub    $0xc,%esp
  802780:	ff 75 08             	pushl  0x8(%ebp)
  802783:	e8 11 03 00 00       	call   802a99 <alloc_block_FF>
  802788:	83 c4 10             	add    $0x10,%esp
  80278b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80278e:	eb 4a                	jmp    8027da <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802790:	83 ec 0c             	sub    $0xc,%esp
  802793:	ff 75 08             	pushl  0x8(%ebp)
  802796:	e8 c7 19 00 00       	call   804162 <alloc_block_NF>
  80279b:	83 c4 10             	add    $0x10,%esp
  80279e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027a1:	eb 37                	jmp    8027da <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8027a3:	83 ec 0c             	sub    $0xc,%esp
  8027a6:	ff 75 08             	pushl  0x8(%ebp)
  8027a9:	e8 a7 07 00 00       	call   802f55 <alloc_block_BF>
  8027ae:	83 c4 10             	add    $0x10,%esp
  8027b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027b4:	eb 24                	jmp    8027da <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8027b6:	83 ec 0c             	sub    $0xc,%esp
  8027b9:	ff 75 08             	pushl  0x8(%ebp)
  8027bc:	e8 84 19 00 00       	call   804145 <alloc_block_WF>
  8027c1:	83 c4 10             	add    $0x10,%esp
  8027c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027c7:	eb 11                	jmp    8027da <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8027c9:	83 ec 0c             	sub    $0xc,%esp
  8027cc:	68 5c 4e 80 00       	push   $0x804e5c
  8027d1:	e8 a9 e3 ff ff       	call   800b7f <cprintf>
  8027d6:	83 c4 10             	add    $0x10,%esp
		break;
  8027d9:	90                   	nop
	}
	return va;
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8027dd:	c9                   	leave  
  8027de:	c3                   	ret    

008027df <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8027df:	55                   	push   %ebp
  8027e0:	89 e5                	mov    %esp,%ebp
  8027e2:	53                   	push   %ebx
  8027e3:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8027e6:	83 ec 0c             	sub    $0xc,%esp
  8027e9:	68 7c 4e 80 00       	push   $0x804e7c
  8027ee:	e8 8c e3 ff ff       	call   800b7f <cprintf>
  8027f3:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8027f6:	83 ec 0c             	sub    $0xc,%esp
  8027f9:	68 a7 4e 80 00       	push   $0x804ea7
  8027fe:	e8 7c e3 ff ff       	call   800b7f <cprintf>
  802803:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280c:	eb 37                	jmp    802845 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80280e:	83 ec 0c             	sub    $0xc,%esp
  802811:	ff 75 f4             	pushl  -0xc(%ebp)
  802814:	e8 19 ff ff ff       	call   802732 <is_free_block>
  802819:	83 c4 10             	add    $0x10,%esp
  80281c:	0f be d8             	movsbl %al,%ebx
  80281f:	83 ec 0c             	sub    $0xc,%esp
  802822:	ff 75 f4             	pushl  -0xc(%ebp)
  802825:	e8 ef fe ff ff       	call   802719 <get_block_size>
  80282a:	83 c4 10             	add    $0x10,%esp
  80282d:	83 ec 04             	sub    $0x4,%esp
  802830:	53                   	push   %ebx
  802831:	50                   	push   %eax
  802832:	68 bf 4e 80 00       	push   $0x804ebf
  802837:	e8 43 e3 ff ff       	call   800b7f <cprintf>
  80283c:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80283f:	8b 45 10             	mov    0x10(%ebp),%eax
  802842:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802845:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802849:	74 07                	je     802852 <print_blocks_list+0x73>
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	8b 00                	mov    (%eax),%eax
  802850:	eb 05                	jmp    802857 <print_blocks_list+0x78>
  802852:	b8 00 00 00 00       	mov    $0x0,%eax
  802857:	89 45 10             	mov    %eax,0x10(%ebp)
  80285a:	8b 45 10             	mov    0x10(%ebp),%eax
  80285d:	85 c0                	test   %eax,%eax
  80285f:	75 ad                	jne    80280e <print_blocks_list+0x2f>
  802861:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802865:	75 a7                	jne    80280e <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802867:	83 ec 0c             	sub    $0xc,%esp
  80286a:	68 7c 4e 80 00       	push   $0x804e7c
  80286f:	e8 0b e3 ff ff       	call   800b7f <cprintf>
  802874:	83 c4 10             	add    $0x10,%esp

}
  802877:	90                   	nop
  802878:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80287b:	c9                   	leave  
  80287c:	c3                   	ret    

0080287d <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80287d:	55                   	push   %ebp
  80287e:	89 e5                	mov    %esp,%ebp
  802880:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802883:	8b 45 0c             	mov    0xc(%ebp),%eax
  802886:	83 e0 01             	and    $0x1,%eax
  802889:	85 c0                	test   %eax,%eax
  80288b:	74 03                	je     802890 <initialize_dynamic_allocator+0x13>
  80288d:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802890:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802894:	0f 84 c7 01 00 00    	je     802a61 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80289a:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  8028a1:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8028a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028aa:	01 d0                	add    %edx,%eax
  8028ac:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8028b1:	0f 87 ad 01 00 00    	ja     802a64 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	85 c0                	test   %eax,%eax
  8028bc:	0f 89 a5 01 00 00    	jns    802a67 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8028c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028c8:	01 d0                	add    %edx,%eax
  8028ca:	83 e8 04             	sub    $0x4,%eax
  8028cd:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  8028d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8028d9:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8028de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e1:	e9 87 00 00 00       	jmp    80296d <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8028e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ea:	75 14                	jne    802900 <initialize_dynamic_allocator+0x83>
  8028ec:	83 ec 04             	sub    $0x4,%esp
  8028ef:	68 d7 4e 80 00       	push   $0x804ed7
  8028f4:	6a 79                	push   $0x79
  8028f6:	68 f5 4e 80 00       	push   $0x804ef5
  8028fb:	e8 c2 df ff ff       	call   8008c2 <_panic>
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	85 c0                	test   %eax,%eax
  802907:	74 10                	je     802919 <initialize_dynamic_allocator+0x9c>
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	8b 00                	mov    (%eax),%eax
  80290e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802911:	8b 52 04             	mov    0x4(%edx),%edx
  802914:	89 50 04             	mov    %edx,0x4(%eax)
  802917:	eb 0b                	jmp    802924 <initialize_dynamic_allocator+0xa7>
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	8b 40 04             	mov    0x4(%eax),%eax
  80291f:	a3 30 60 80 00       	mov    %eax,0x806030
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	8b 40 04             	mov    0x4(%eax),%eax
  80292a:	85 c0                	test   %eax,%eax
  80292c:	74 0f                	je     80293d <initialize_dynamic_allocator+0xc0>
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	8b 40 04             	mov    0x4(%eax),%eax
  802934:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802937:	8b 12                	mov    (%edx),%edx
  802939:	89 10                	mov    %edx,(%eax)
  80293b:	eb 0a                	jmp    802947 <initialize_dynamic_allocator+0xca>
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	8b 00                	mov    (%eax),%eax
  802942:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80295a:	a1 38 60 80 00       	mov    0x806038,%eax
  80295f:	48                   	dec    %eax
  802960:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802965:	a1 34 60 80 00       	mov    0x806034,%eax
  80296a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802971:	74 07                	je     80297a <initialize_dynamic_allocator+0xfd>
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 00                	mov    (%eax),%eax
  802978:	eb 05                	jmp    80297f <initialize_dynamic_allocator+0x102>
  80297a:	b8 00 00 00 00       	mov    $0x0,%eax
  80297f:	a3 34 60 80 00       	mov    %eax,0x806034
  802984:	a1 34 60 80 00       	mov    0x806034,%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	0f 85 55 ff ff ff    	jne    8028e6 <initialize_dynamic_allocator+0x69>
  802991:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802995:	0f 85 4b ff ff ff    	jne    8028e6 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80299b:	8b 45 08             	mov    0x8(%ebp),%eax
  80299e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8029a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8029aa:	a1 44 60 80 00       	mov    0x806044,%eax
  8029af:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  8029b4:	a1 40 60 80 00       	mov    0x806040,%eax
  8029b9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8029bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c2:	83 c0 08             	add    $0x8,%eax
  8029c5:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	83 c0 04             	add    $0x4,%eax
  8029ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d1:	83 ea 08             	sub    $0x8,%edx
  8029d4:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8029d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dc:	01 d0                	add    %edx,%eax
  8029de:	83 e8 08             	sub    $0x8,%eax
  8029e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029e4:	83 ea 08             	sub    $0x8,%edx
  8029e7:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8029e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8029f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8029fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a00:	75 17                	jne    802a19 <initialize_dynamic_allocator+0x19c>
  802a02:	83 ec 04             	sub    $0x4,%esp
  802a05:	68 10 4f 80 00       	push   $0x804f10
  802a0a:	68 90 00 00 00       	push   $0x90
  802a0f:	68 f5 4e 80 00       	push   $0x804ef5
  802a14:	e8 a9 de ff ff       	call   8008c2 <_panic>
  802a19:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a22:	89 10                	mov    %edx,(%eax)
  802a24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a27:	8b 00                	mov    (%eax),%eax
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	74 0d                	je     802a3a <initialize_dynamic_allocator+0x1bd>
  802a2d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802a32:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a35:	89 50 04             	mov    %edx,0x4(%eax)
  802a38:	eb 08                	jmp    802a42 <initialize_dynamic_allocator+0x1c5>
  802a3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3d:	a3 30 60 80 00       	mov    %eax,0x806030
  802a42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a45:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a54:	a1 38 60 80 00       	mov    0x806038,%eax
  802a59:	40                   	inc    %eax
  802a5a:	a3 38 60 80 00       	mov    %eax,0x806038
  802a5f:	eb 07                	jmp    802a68 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802a61:	90                   	nop
  802a62:	eb 04                	jmp    802a68 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802a64:	90                   	nop
  802a65:	eb 01                	jmp    802a68 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802a67:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802a68:	c9                   	leave  
  802a69:	c3                   	ret    

00802a6a <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802a6a:	55                   	push   %ebp
  802a6b:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802a6d:	8b 45 10             	mov    0x10(%ebp),%eax
  802a70:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a7c:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a81:	83 e8 04             	sub    $0x4,%eax
  802a84:	8b 00                	mov    (%eax),%eax
  802a86:	83 e0 fe             	and    $0xfffffffe,%eax
  802a89:	8d 50 f8             	lea    -0x8(%eax),%edx
  802a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8f:	01 c2                	add    %eax,%edx
  802a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a94:	89 02                	mov    %eax,(%edx)
}
  802a96:	90                   	nop
  802a97:	5d                   	pop    %ebp
  802a98:	c3                   	ret    

00802a99 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802a99:	55                   	push   %ebp
  802a9a:	89 e5                	mov    %esp,%ebp
  802a9c:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa2:	83 e0 01             	and    $0x1,%eax
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	74 03                	je     802aac <alloc_block_FF+0x13>
  802aa9:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802aac:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802ab0:	77 07                	ja     802ab9 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802ab2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802ab9:	a1 24 60 80 00       	mov    0x806024,%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	75 73                	jne    802b35 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac5:	83 c0 10             	add    $0x10,%eax
  802ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802acb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802ad2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad8:	01 d0                	add    %edx,%eax
  802ada:	48                   	dec    %eax
  802adb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ade:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae1:	ba 00 00 00 00       	mov    $0x0,%edx
  802ae6:	f7 75 ec             	divl   -0x14(%ebp)
  802ae9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aec:	29 d0                	sub    %edx,%eax
  802aee:	c1 e8 0c             	shr    $0xc,%eax
  802af1:	83 ec 0c             	sub    $0xc,%esp
  802af4:	50                   	push   %eax
  802af5:	e8 27 f0 ff ff       	call   801b21 <sbrk>
  802afa:	83 c4 10             	add    $0x10,%esp
  802afd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802b00:	83 ec 0c             	sub    $0xc,%esp
  802b03:	6a 00                	push   $0x0
  802b05:	e8 17 f0 ff ff       	call   801b21 <sbrk>
  802b0a:	83 c4 10             	add    $0x10,%esp
  802b0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802b10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b13:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802b16:	83 ec 08             	sub    $0x8,%esp
  802b19:	50                   	push   %eax
  802b1a:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b1d:	e8 5b fd ff ff       	call   80287d <initialize_dynamic_allocator>
  802b22:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802b25:	83 ec 0c             	sub    $0xc,%esp
  802b28:	68 33 4f 80 00       	push   $0x804f33
  802b2d:	e8 4d e0 ff ff       	call   800b7f <cprintf>
  802b32:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802b35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b39:	75 0a                	jne    802b45 <alloc_block_FF+0xac>
	        return NULL;
  802b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b40:	e9 0e 04 00 00       	jmp    802f53 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802b45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802b4c:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b54:	e9 f3 02 00 00       	jmp    802e4c <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802b5f:	83 ec 0c             	sub    $0xc,%esp
  802b62:	ff 75 bc             	pushl  -0x44(%ebp)
  802b65:	e8 af fb ff ff       	call   802719 <get_block_size>
  802b6a:	83 c4 10             	add    $0x10,%esp
  802b6d:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	83 c0 08             	add    $0x8,%eax
  802b76:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b79:	0f 87 c5 02 00 00    	ja     802e44 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	83 c0 18             	add    $0x18,%eax
  802b85:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b88:	0f 87 19 02 00 00    	ja     802da7 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802b8e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b91:	2b 45 08             	sub    0x8(%ebp),%eax
  802b94:	83 e8 08             	sub    $0x8,%eax
  802b97:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	8d 50 08             	lea    0x8(%eax),%edx
  802ba0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ba3:	01 d0                	add    %edx,%eax
  802ba5:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	83 c0 08             	add    $0x8,%eax
  802bae:	83 ec 04             	sub    $0x4,%esp
  802bb1:	6a 01                	push   $0x1
  802bb3:	50                   	push   %eax
  802bb4:	ff 75 bc             	pushl  -0x44(%ebp)
  802bb7:	e8 ae fe ff ff       	call   802a6a <set_block_data>
  802bbc:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	8b 40 04             	mov    0x4(%eax),%eax
  802bc5:	85 c0                	test   %eax,%eax
  802bc7:	75 68                	jne    802c31 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bc9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802bcd:	75 17                	jne    802be6 <alloc_block_FF+0x14d>
  802bcf:	83 ec 04             	sub    $0x4,%esp
  802bd2:	68 10 4f 80 00       	push   $0x804f10
  802bd7:	68 d7 00 00 00       	push   $0xd7
  802bdc:	68 f5 4e 80 00       	push   $0x804ef5
  802be1:	e8 dc dc ff ff       	call   8008c2 <_panic>
  802be6:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  802bec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bef:	89 10                	mov    %edx,(%eax)
  802bf1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bf4:	8b 00                	mov    (%eax),%eax
  802bf6:	85 c0                	test   %eax,%eax
  802bf8:	74 0d                	je     802c07 <alloc_block_FF+0x16e>
  802bfa:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802bff:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c02:	89 50 04             	mov    %edx,0x4(%eax)
  802c05:	eb 08                	jmp    802c0f <alloc_block_FF+0x176>
  802c07:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c0a:	a3 30 60 80 00       	mov    %eax,0x806030
  802c0f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c12:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802c17:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c21:	a1 38 60 80 00       	mov    0x806038,%eax
  802c26:	40                   	inc    %eax
  802c27:	a3 38 60 80 00       	mov    %eax,0x806038
  802c2c:	e9 dc 00 00 00       	jmp    802d0d <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	85 c0                	test   %eax,%eax
  802c38:	75 65                	jne    802c9f <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c3a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c3e:	75 17                	jne    802c57 <alloc_block_FF+0x1be>
  802c40:	83 ec 04             	sub    $0x4,%esp
  802c43:	68 44 4f 80 00       	push   $0x804f44
  802c48:	68 db 00 00 00       	push   $0xdb
  802c4d:	68 f5 4e 80 00       	push   $0x804ef5
  802c52:	e8 6b dc ff ff       	call   8008c2 <_panic>
  802c57:	8b 15 30 60 80 00    	mov    0x806030,%edx
  802c5d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c60:	89 50 04             	mov    %edx,0x4(%eax)
  802c63:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c66:	8b 40 04             	mov    0x4(%eax),%eax
  802c69:	85 c0                	test   %eax,%eax
  802c6b:	74 0c                	je     802c79 <alloc_block_FF+0x1e0>
  802c6d:	a1 30 60 80 00       	mov    0x806030,%eax
  802c72:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c75:	89 10                	mov    %edx,(%eax)
  802c77:	eb 08                	jmp    802c81 <alloc_block_FF+0x1e8>
  802c79:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c7c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802c81:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c84:	a3 30 60 80 00       	mov    %eax,0x806030
  802c89:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c92:	a1 38 60 80 00       	mov    0x806038,%eax
  802c97:	40                   	inc    %eax
  802c98:	a3 38 60 80 00       	mov    %eax,0x806038
  802c9d:	eb 6e                	jmp    802d0d <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802c9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca3:	74 06                	je     802cab <alloc_block_FF+0x212>
  802ca5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ca9:	75 17                	jne    802cc2 <alloc_block_FF+0x229>
  802cab:	83 ec 04             	sub    $0x4,%esp
  802cae:	68 68 4f 80 00       	push   $0x804f68
  802cb3:	68 df 00 00 00       	push   $0xdf
  802cb8:	68 f5 4e 80 00       	push   $0x804ef5
  802cbd:	e8 00 dc ff ff       	call   8008c2 <_panic>
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	8b 10                	mov    (%eax),%edx
  802cc7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cca:	89 10                	mov    %edx,(%eax)
  802ccc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ccf:	8b 00                	mov    (%eax),%eax
  802cd1:	85 c0                	test   %eax,%eax
  802cd3:	74 0b                	je     802ce0 <alloc_block_FF+0x247>
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cdd:	89 50 04             	mov    %edx,0x4(%eax)
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ce6:	89 10                	mov    %edx,(%eax)
  802ce8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ceb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cee:	89 50 04             	mov    %edx,0x4(%eax)
  802cf1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cf4:	8b 00                	mov    (%eax),%eax
  802cf6:	85 c0                	test   %eax,%eax
  802cf8:	75 08                	jne    802d02 <alloc_block_FF+0x269>
  802cfa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cfd:	a3 30 60 80 00       	mov    %eax,0x806030
  802d02:	a1 38 60 80 00       	mov    0x806038,%eax
  802d07:	40                   	inc    %eax
  802d08:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802d0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d11:	75 17                	jne    802d2a <alloc_block_FF+0x291>
  802d13:	83 ec 04             	sub    $0x4,%esp
  802d16:	68 d7 4e 80 00       	push   $0x804ed7
  802d1b:	68 e1 00 00 00       	push   $0xe1
  802d20:	68 f5 4e 80 00       	push   $0x804ef5
  802d25:	e8 98 db ff ff       	call   8008c2 <_panic>
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	85 c0                	test   %eax,%eax
  802d31:	74 10                	je     802d43 <alloc_block_FF+0x2aa>
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 00                	mov    (%eax),%eax
  802d38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d3b:	8b 52 04             	mov    0x4(%edx),%edx
  802d3e:	89 50 04             	mov    %edx,0x4(%eax)
  802d41:	eb 0b                	jmp    802d4e <alloc_block_FF+0x2b5>
  802d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d46:	8b 40 04             	mov    0x4(%eax),%eax
  802d49:	a3 30 60 80 00       	mov    %eax,0x806030
  802d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d51:	8b 40 04             	mov    0x4(%eax),%eax
  802d54:	85 c0                	test   %eax,%eax
  802d56:	74 0f                	je     802d67 <alloc_block_FF+0x2ce>
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	8b 40 04             	mov    0x4(%eax),%eax
  802d5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d61:	8b 12                	mov    (%edx),%edx
  802d63:	89 10                	mov    %edx,(%eax)
  802d65:	eb 0a                	jmp    802d71 <alloc_block_FF+0x2d8>
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 00                	mov    (%eax),%eax
  802d6c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d84:	a1 38 60 80 00       	mov    0x806038,%eax
  802d89:	48                   	dec    %eax
  802d8a:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  802d8f:	83 ec 04             	sub    $0x4,%esp
  802d92:	6a 00                	push   $0x0
  802d94:	ff 75 b4             	pushl  -0x4c(%ebp)
  802d97:	ff 75 b0             	pushl  -0x50(%ebp)
  802d9a:	e8 cb fc ff ff       	call   802a6a <set_block_data>
  802d9f:	83 c4 10             	add    $0x10,%esp
  802da2:	e9 95 00 00 00       	jmp    802e3c <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802da7:	83 ec 04             	sub    $0x4,%esp
  802daa:	6a 01                	push   $0x1
  802dac:	ff 75 b8             	pushl  -0x48(%ebp)
  802daf:	ff 75 bc             	pushl  -0x44(%ebp)
  802db2:	e8 b3 fc ff ff       	call   802a6a <set_block_data>
  802db7:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802dba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dbe:	75 17                	jne    802dd7 <alloc_block_FF+0x33e>
  802dc0:	83 ec 04             	sub    $0x4,%esp
  802dc3:	68 d7 4e 80 00       	push   $0x804ed7
  802dc8:	68 e8 00 00 00       	push   $0xe8
  802dcd:	68 f5 4e 80 00       	push   $0x804ef5
  802dd2:	e8 eb da ff ff       	call   8008c2 <_panic>
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 00                	mov    (%eax),%eax
  802ddc:	85 c0                	test   %eax,%eax
  802dde:	74 10                	je     802df0 <alloc_block_FF+0x357>
  802de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de3:	8b 00                	mov    (%eax),%eax
  802de5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de8:	8b 52 04             	mov    0x4(%edx),%edx
  802deb:	89 50 04             	mov    %edx,0x4(%eax)
  802dee:	eb 0b                	jmp    802dfb <alloc_block_FF+0x362>
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	8b 40 04             	mov    0x4(%eax),%eax
  802df6:	a3 30 60 80 00       	mov    %eax,0x806030
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	8b 40 04             	mov    0x4(%eax),%eax
  802e01:	85 c0                	test   %eax,%eax
  802e03:	74 0f                	je     802e14 <alloc_block_FF+0x37b>
  802e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e08:	8b 40 04             	mov    0x4(%eax),%eax
  802e0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e0e:	8b 12                	mov    (%edx),%edx
  802e10:	89 10                	mov    %edx,(%eax)
  802e12:	eb 0a                	jmp    802e1e <alloc_block_FF+0x385>
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	8b 00                	mov    (%eax),%eax
  802e19:	a3 2c 60 80 00       	mov    %eax,0x80602c
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e31:	a1 38 60 80 00       	mov    0x806038,%eax
  802e36:	48                   	dec    %eax
  802e37:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  802e3c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e3f:	e9 0f 01 00 00       	jmp    802f53 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802e44:	a1 34 60 80 00       	mov    0x806034,%eax
  802e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e50:	74 07                	je     802e59 <alloc_block_FF+0x3c0>
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e55:	8b 00                	mov    (%eax),%eax
  802e57:	eb 05                	jmp    802e5e <alloc_block_FF+0x3c5>
  802e59:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5e:	a3 34 60 80 00       	mov    %eax,0x806034
  802e63:	a1 34 60 80 00       	mov    0x806034,%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	0f 85 e9 fc ff ff    	jne    802b59 <alloc_block_FF+0xc0>
  802e70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e74:	0f 85 df fc ff ff    	jne    802b59 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7d:	83 c0 08             	add    $0x8,%eax
  802e80:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e83:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802e8a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e90:	01 d0                	add    %edx,%eax
  802e92:	48                   	dec    %eax
  802e93:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802e96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e99:	ba 00 00 00 00       	mov    $0x0,%edx
  802e9e:	f7 75 d8             	divl   -0x28(%ebp)
  802ea1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ea4:	29 d0                	sub    %edx,%eax
  802ea6:	c1 e8 0c             	shr    $0xc,%eax
  802ea9:	83 ec 0c             	sub    $0xc,%esp
  802eac:	50                   	push   %eax
  802ead:	e8 6f ec ff ff       	call   801b21 <sbrk>
  802eb2:	83 c4 10             	add    $0x10,%esp
  802eb5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802eb8:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802ebc:	75 0a                	jne    802ec8 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec3:	e9 8b 00 00 00       	jmp    802f53 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ec8:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802ecf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ed2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ed5:	01 d0                	add    %edx,%eax
  802ed7:	48                   	dec    %eax
  802ed8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802edb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ede:	ba 00 00 00 00       	mov    $0x0,%edx
  802ee3:	f7 75 cc             	divl   -0x34(%ebp)
  802ee6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ee9:	29 d0                	sub    %edx,%eax
  802eeb:	8d 50 fc             	lea    -0x4(%eax),%edx
  802eee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ef1:	01 d0                	add    %edx,%eax
  802ef3:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  802ef8:	a1 40 60 80 00       	mov    0x806040,%eax
  802efd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802f03:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802f0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f0d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f10:	01 d0                	add    %edx,%eax
  802f12:	48                   	dec    %eax
  802f13:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f16:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f19:	ba 00 00 00 00       	mov    $0x0,%edx
  802f1e:	f7 75 c4             	divl   -0x3c(%ebp)
  802f21:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f24:	29 d0                	sub    %edx,%eax
  802f26:	83 ec 04             	sub    $0x4,%esp
  802f29:	6a 01                	push   $0x1
  802f2b:	50                   	push   %eax
  802f2c:	ff 75 d0             	pushl  -0x30(%ebp)
  802f2f:	e8 36 fb ff ff       	call   802a6a <set_block_data>
  802f34:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802f37:	83 ec 0c             	sub    $0xc,%esp
  802f3a:	ff 75 d0             	pushl  -0x30(%ebp)
  802f3d:	e8 f8 09 00 00       	call   80393a <free_block>
  802f42:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802f45:	83 ec 0c             	sub    $0xc,%esp
  802f48:	ff 75 08             	pushl  0x8(%ebp)
  802f4b:	e8 49 fb ff ff       	call   802a99 <alloc_block_FF>
  802f50:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802f53:	c9                   	leave  
  802f54:	c3                   	ret    

00802f55 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802f55:	55                   	push   %ebp
  802f56:	89 e5                	mov    %esp,%ebp
  802f58:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	83 e0 01             	and    $0x1,%eax
  802f61:	85 c0                	test   %eax,%eax
  802f63:	74 03                	je     802f68 <alloc_block_BF+0x13>
  802f65:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802f68:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802f6c:	77 07                	ja     802f75 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802f6e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802f75:	a1 24 60 80 00       	mov    0x806024,%eax
  802f7a:	85 c0                	test   %eax,%eax
  802f7c:	75 73                	jne    802ff1 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f81:	83 c0 10             	add    $0x10,%eax
  802f84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802f87:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802f8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f94:	01 d0                	add    %edx,%eax
  802f96:	48                   	dec    %eax
  802f97:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802f9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f9d:	ba 00 00 00 00       	mov    $0x0,%edx
  802fa2:	f7 75 e0             	divl   -0x20(%ebp)
  802fa5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa8:	29 d0                	sub    %edx,%eax
  802faa:	c1 e8 0c             	shr    $0xc,%eax
  802fad:	83 ec 0c             	sub    $0xc,%esp
  802fb0:	50                   	push   %eax
  802fb1:	e8 6b eb ff ff       	call   801b21 <sbrk>
  802fb6:	83 c4 10             	add    $0x10,%esp
  802fb9:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802fbc:	83 ec 0c             	sub    $0xc,%esp
  802fbf:	6a 00                	push   $0x0
  802fc1:	e8 5b eb ff ff       	call   801b21 <sbrk>
  802fc6:	83 c4 10             	add    $0x10,%esp
  802fc9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802fcc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fcf:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802fd2:	83 ec 08             	sub    $0x8,%esp
  802fd5:	50                   	push   %eax
  802fd6:	ff 75 d8             	pushl  -0x28(%ebp)
  802fd9:	e8 9f f8 ff ff       	call   80287d <initialize_dynamic_allocator>
  802fde:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802fe1:	83 ec 0c             	sub    $0xc,%esp
  802fe4:	68 33 4f 80 00       	push   $0x804f33
  802fe9:	e8 91 db ff ff       	call   800b7f <cprintf>
  802fee:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802ff1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802ff8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802fff:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803006:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80300d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803012:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803015:	e9 1d 01 00 00       	jmp    803137 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803020:	83 ec 0c             	sub    $0xc,%esp
  803023:	ff 75 a8             	pushl  -0x58(%ebp)
  803026:	e8 ee f6 ff ff       	call   802719 <get_block_size>
  80302b:	83 c4 10             	add    $0x10,%esp
  80302e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803031:	8b 45 08             	mov    0x8(%ebp),%eax
  803034:	83 c0 08             	add    $0x8,%eax
  803037:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80303a:	0f 87 ef 00 00 00    	ja     80312f <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	83 c0 18             	add    $0x18,%eax
  803046:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803049:	77 1d                	ja     803068 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80304b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803051:	0f 86 d8 00 00 00    	jbe    80312f <alloc_block_BF+0x1da>
				{
					best_va = va;
  803057:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80305a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80305d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803060:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803063:	e9 c7 00 00 00       	jmp    80312f <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803068:	8b 45 08             	mov    0x8(%ebp),%eax
  80306b:	83 c0 08             	add    $0x8,%eax
  80306e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803071:	0f 85 9d 00 00 00    	jne    803114 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803077:	83 ec 04             	sub    $0x4,%esp
  80307a:	6a 01                	push   $0x1
  80307c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80307f:	ff 75 a8             	pushl  -0x58(%ebp)
  803082:	e8 e3 f9 ff ff       	call   802a6a <set_block_data>
  803087:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80308a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80308e:	75 17                	jne    8030a7 <alloc_block_BF+0x152>
  803090:	83 ec 04             	sub    $0x4,%esp
  803093:	68 d7 4e 80 00       	push   $0x804ed7
  803098:	68 2c 01 00 00       	push   $0x12c
  80309d:	68 f5 4e 80 00       	push   $0x804ef5
  8030a2:	e8 1b d8 ff ff       	call   8008c2 <_panic>
  8030a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030aa:	8b 00                	mov    (%eax),%eax
  8030ac:	85 c0                	test   %eax,%eax
  8030ae:	74 10                	je     8030c0 <alloc_block_BF+0x16b>
  8030b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b3:	8b 00                	mov    (%eax),%eax
  8030b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b8:	8b 52 04             	mov    0x4(%edx),%edx
  8030bb:	89 50 04             	mov    %edx,0x4(%eax)
  8030be:	eb 0b                	jmp    8030cb <alloc_block_BF+0x176>
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	8b 40 04             	mov    0x4(%eax),%eax
  8030c6:	a3 30 60 80 00       	mov    %eax,0x806030
  8030cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ce:	8b 40 04             	mov    0x4(%eax),%eax
  8030d1:	85 c0                	test   %eax,%eax
  8030d3:	74 0f                	je     8030e4 <alloc_block_BF+0x18f>
  8030d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d8:	8b 40 04             	mov    0x4(%eax),%eax
  8030db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030de:	8b 12                	mov    (%edx),%edx
  8030e0:	89 10                	mov    %edx,(%eax)
  8030e2:	eb 0a                	jmp    8030ee <alloc_block_BF+0x199>
  8030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e7:	8b 00                	mov    (%eax),%eax
  8030e9:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8030ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803101:	a1 38 60 80 00       	mov    0x806038,%eax
  803106:	48                   	dec    %eax
  803107:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  80310c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80310f:	e9 01 04 00 00       	jmp    803515 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  803114:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803117:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80311a:	76 13                	jbe    80312f <alloc_block_BF+0x1da>
					{
						internal = 1;
  80311c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803123:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803126:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803129:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80312c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80312f:	a1 34 60 80 00       	mov    0x806034,%eax
  803134:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803137:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80313b:	74 07                	je     803144 <alloc_block_BF+0x1ef>
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	8b 00                	mov    (%eax),%eax
  803142:	eb 05                	jmp    803149 <alloc_block_BF+0x1f4>
  803144:	b8 00 00 00 00       	mov    $0x0,%eax
  803149:	a3 34 60 80 00       	mov    %eax,0x806034
  80314e:	a1 34 60 80 00       	mov    0x806034,%eax
  803153:	85 c0                	test   %eax,%eax
  803155:	0f 85 bf fe ff ff    	jne    80301a <alloc_block_BF+0xc5>
  80315b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80315f:	0f 85 b5 fe ff ff    	jne    80301a <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803165:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803169:	0f 84 26 02 00 00    	je     803395 <alloc_block_BF+0x440>
  80316f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803173:	0f 85 1c 02 00 00    	jne    803395 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80317c:	2b 45 08             	sub    0x8(%ebp),%eax
  80317f:	83 e8 08             	sub    $0x8,%eax
  803182:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803185:	8b 45 08             	mov    0x8(%ebp),%eax
  803188:	8d 50 08             	lea    0x8(%eax),%edx
  80318b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318e:	01 d0                	add    %edx,%eax
  803190:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	83 c0 08             	add    $0x8,%eax
  803199:	83 ec 04             	sub    $0x4,%esp
  80319c:	6a 01                	push   $0x1
  80319e:	50                   	push   %eax
  80319f:	ff 75 f0             	pushl  -0x10(%ebp)
  8031a2:	e8 c3 f8 ff ff       	call   802a6a <set_block_data>
  8031a7:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8031aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ad:	8b 40 04             	mov    0x4(%eax),%eax
  8031b0:	85 c0                	test   %eax,%eax
  8031b2:	75 68                	jne    80321c <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8031b4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031b8:	75 17                	jne    8031d1 <alloc_block_BF+0x27c>
  8031ba:	83 ec 04             	sub    $0x4,%esp
  8031bd:	68 10 4f 80 00       	push   $0x804f10
  8031c2:	68 45 01 00 00       	push   $0x145
  8031c7:	68 f5 4e 80 00       	push   $0x804ef5
  8031cc:	e8 f1 d6 ff ff       	call   8008c2 <_panic>
  8031d1:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8031d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031da:	89 10                	mov    %edx,(%eax)
  8031dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031df:	8b 00                	mov    (%eax),%eax
  8031e1:	85 c0                	test   %eax,%eax
  8031e3:	74 0d                	je     8031f2 <alloc_block_BF+0x29d>
  8031e5:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8031ea:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031ed:	89 50 04             	mov    %edx,0x4(%eax)
  8031f0:	eb 08                	jmp    8031fa <alloc_block_BF+0x2a5>
  8031f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031f5:	a3 30 60 80 00       	mov    %eax,0x806030
  8031fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031fd:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803202:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803205:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80320c:	a1 38 60 80 00       	mov    0x806038,%eax
  803211:	40                   	inc    %eax
  803212:	a3 38 60 80 00       	mov    %eax,0x806038
  803217:	e9 dc 00 00 00       	jmp    8032f8 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80321c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321f:	8b 00                	mov    (%eax),%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	75 65                	jne    80328a <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803225:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803229:	75 17                	jne    803242 <alloc_block_BF+0x2ed>
  80322b:	83 ec 04             	sub    $0x4,%esp
  80322e:	68 44 4f 80 00       	push   $0x804f44
  803233:	68 4a 01 00 00       	push   $0x14a
  803238:	68 f5 4e 80 00       	push   $0x804ef5
  80323d:	e8 80 d6 ff ff       	call   8008c2 <_panic>
  803242:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803248:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80324b:	89 50 04             	mov    %edx,0x4(%eax)
  80324e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803251:	8b 40 04             	mov    0x4(%eax),%eax
  803254:	85 c0                	test   %eax,%eax
  803256:	74 0c                	je     803264 <alloc_block_BF+0x30f>
  803258:	a1 30 60 80 00       	mov    0x806030,%eax
  80325d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803260:	89 10                	mov    %edx,(%eax)
  803262:	eb 08                	jmp    80326c <alloc_block_BF+0x317>
  803264:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803267:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80326c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80326f:	a3 30 60 80 00       	mov    %eax,0x806030
  803274:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803277:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80327d:	a1 38 60 80 00       	mov    0x806038,%eax
  803282:	40                   	inc    %eax
  803283:	a3 38 60 80 00       	mov    %eax,0x806038
  803288:	eb 6e                	jmp    8032f8 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80328a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80328e:	74 06                	je     803296 <alloc_block_BF+0x341>
  803290:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803294:	75 17                	jne    8032ad <alloc_block_BF+0x358>
  803296:	83 ec 04             	sub    $0x4,%esp
  803299:	68 68 4f 80 00       	push   $0x804f68
  80329e:	68 4f 01 00 00       	push   $0x14f
  8032a3:	68 f5 4e 80 00       	push   $0x804ef5
  8032a8:	e8 15 d6 ff ff       	call   8008c2 <_panic>
  8032ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b0:	8b 10                	mov    (%eax),%edx
  8032b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032b5:	89 10                	mov    %edx,(%eax)
  8032b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032ba:	8b 00                	mov    (%eax),%eax
  8032bc:	85 c0                	test   %eax,%eax
  8032be:	74 0b                	je     8032cb <alloc_block_BF+0x376>
  8032c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c3:	8b 00                	mov    (%eax),%eax
  8032c5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032c8:	89 50 04             	mov    %edx,0x4(%eax)
  8032cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ce:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032d1:	89 10                	mov    %edx,(%eax)
  8032d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032d9:	89 50 04             	mov    %edx,0x4(%eax)
  8032dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032df:	8b 00                	mov    (%eax),%eax
  8032e1:	85 c0                	test   %eax,%eax
  8032e3:	75 08                	jne    8032ed <alloc_block_BF+0x398>
  8032e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032e8:	a3 30 60 80 00       	mov    %eax,0x806030
  8032ed:	a1 38 60 80 00       	mov    0x806038,%eax
  8032f2:	40                   	inc    %eax
  8032f3:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8032f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032fc:	75 17                	jne    803315 <alloc_block_BF+0x3c0>
  8032fe:	83 ec 04             	sub    $0x4,%esp
  803301:	68 d7 4e 80 00       	push   $0x804ed7
  803306:	68 51 01 00 00       	push   $0x151
  80330b:	68 f5 4e 80 00       	push   $0x804ef5
  803310:	e8 ad d5 ff ff       	call   8008c2 <_panic>
  803315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803318:	8b 00                	mov    (%eax),%eax
  80331a:	85 c0                	test   %eax,%eax
  80331c:	74 10                	je     80332e <alloc_block_BF+0x3d9>
  80331e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803321:	8b 00                	mov    (%eax),%eax
  803323:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803326:	8b 52 04             	mov    0x4(%edx),%edx
  803329:	89 50 04             	mov    %edx,0x4(%eax)
  80332c:	eb 0b                	jmp    803339 <alloc_block_BF+0x3e4>
  80332e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803331:	8b 40 04             	mov    0x4(%eax),%eax
  803334:	a3 30 60 80 00       	mov    %eax,0x806030
  803339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333c:	8b 40 04             	mov    0x4(%eax),%eax
  80333f:	85 c0                	test   %eax,%eax
  803341:	74 0f                	je     803352 <alloc_block_BF+0x3fd>
  803343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803346:	8b 40 04             	mov    0x4(%eax),%eax
  803349:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80334c:	8b 12                	mov    (%edx),%edx
  80334e:	89 10                	mov    %edx,(%eax)
  803350:	eb 0a                	jmp    80335c <alloc_block_BF+0x407>
  803352:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803355:	8b 00                	mov    (%eax),%eax
  803357:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80335c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803368:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80336f:	a1 38 60 80 00       	mov    0x806038,%eax
  803374:	48                   	dec    %eax
  803375:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  80337a:	83 ec 04             	sub    $0x4,%esp
  80337d:	6a 00                	push   $0x0
  80337f:	ff 75 d0             	pushl  -0x30(%ebp)
  803382:	ff 75 cc             	pushl  -0x34(%ebp)
  803385:	e8 e0 f6 ff ff       	call   802a6a <set_block_data>
  80338a:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80338d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803390:	e9 80 01 00 00       	jmp    803515 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  803395:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803399:	0f 85 9d 00 00 00    	jne    80343c <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80339f:	83 ec 04             	sub    $0x4,%esp
  8033a2:	6a 01                	push   $0x1
  8033a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8033a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8033aa:	e8 bb f6 ff ff       	call   802a6a <set_block_data>
  8033af:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8033b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033b6:	75 17                	jne    8033cf <alloc_block_BF+0x47a>
  8033b8:	83 ec 04             	sub    $0x4,%esp
  8033bb:	68 d7 4e 80 00       	push   $0x804ed7
  8033c0:	68 58 01 00 00       	push   $0x158
  8033c5:	68 f5 4e 80 00       	push   $0x804ef5
  8033ca:	e8 f3 d4 ff ff       	call   8008c2 <_panic>
  8033cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	85 c0                	test   %eax,%eax
  8033d6:	74 10                	je     8033e8 <alloc_block_BF+0x493>
  8033d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033db:	8b 00                	mov    (%eax),%eax
  8033dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033e0:	8b 52 04             	mov    0x4(%edx),%edx
  8033e3:	89 50 04             	mov    %edx,0x4(%eax)
  8033e6:	eb 0b                	jmp    8033f3 <alloc_block_BF+0x49e>
  8033e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033eb:	8b 40 04             	mov    0x4(%eax),%eax
  8033ee:	a3 30 60 80 00       	mov    %eax,0x806030
  8033f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f6:	8b 40 04             	mov    0x4(%eax),%eax
  8033f9:	85 c0                	test   %eax,%eax
  8033fb:	74 0f                	je     80340c <alloc_block_BF+0x4b7>
  8033fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803400:	8b 40 04             	mov    0x4(%eax),%eax
  803403:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803406:	8b 12                	mov    (%edx),%edx
  803408:	89 10                	mov    %edx,(%eax)
  80340a:	eb 0a                	jmp    803416 <alloc_block_BF+0x4c1>
  80340c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340f:	8b 00                	mov    (%eax),%eax
  803411:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803416:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803419:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80341f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803422:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803429:	a1 38 60 80 00       	mov    0x806038,%eax
  80342e:	48                   	dec    %eax
  80342f:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  803434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803437:	e9 d9 00 00 00       	jmp    803515 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80343c:	8b 45 08             	mov    0x8(%ebp),%eax
  80343f:	83 c0 08             	add    $0x8,%eax
  803442:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803445:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80344c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80344f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803452:	01 d0                	add    %edx,%eax
  803454:	48                   	dec    %eax
  803455:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803458:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80345b:	ba 00 00 00 00       	mov    $0x0,%edx
  803460:	f7 75 c4             	divl   -0x3c(%ebp)
  803463:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803466:	29 d0                	sub    %edx,%eax
  803468:	c1 e8 0c             	shr    $0xc,%eax
  80346b:	83 ec 0c             	sub    $0xc,%esp
  80346e:	50                   	push   %eax
  80346f:	e8 ad e6 ff ff       	call   801b21 <sbrk>
  803474:	83 c4 10             	add    $0x10,%esp
  803477:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80347a:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80347e:	75 0a                	jne    80348a <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803480:	b8 00 00 00 00       	mov    $0x0,%eax
  803485:	e9 8b 00 00 00       	jmp    803515 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80348a:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803491:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803494:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803497:	01 d0                	add    %edx,%eax
  803499:	48                   	dec    %eax
  80349a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80349d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8034a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8034a5:	f7 75 b8             	divl   -0x48(%ebp)
  8034a8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8034ab:	29 d0                	sub    %edx,%eax
  8034ad:	8d 50 fc             	lea    -0x4(%eax),%edx
  8034b0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8034b3:	01 d0                	add    %edx,%eax
  8034b5:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  8034ba:	a1 40 60 80 00       	mov    0x806040,%eax
  8034bf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8034c5:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8034cc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034cf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8034d2:	01 d0                	add    %edx,%eax
  8034d4:	48                   	dec    %eax
  8034d5:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8034d8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8034db:	ba 00 00 00 00       	mov    $0x0,%edx
  8034e0:	f7 75 b0             	divl   -0x50(%ebp)
  8034e3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8034e6:	29 d0                	sub    %edx,%eax
  8034e8:	83 ec 04             	sub    $0x4,%esp
  8034eb:	6a 01                	push   $0x1
  8034ed:	50                   	push   %eax
  8034ee:	ff 75 bc             	pushl  -0x44(%ebp)
  8034f1:	e8 74 f5 ff ff       	call   802a6a <set_block_data>
  8034f6:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8034f9:	83 ec 0c             	sub    $0xc,%esp
  8034fc:	ff 75 bc             	pushl  -0x44(%ebp)
  8034ff:	e8 36 04 00 00       	call   80393a <free_block>
  803504:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803507:	83 ec 0c             	sub    $0xc,%esp
  80350a:	ff 75 08             	pushl  0x8(%ebp)
  80350d:	e8 43 fa ff ff       	call   802f55 <alloc_block_BF>
  803512:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803515:	c9                   	leave  
  803516:	c3                   	ret    

00803517 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803517:	55                   	push   %ebp
  803518:	89 e5                	mov    %esp,%ebp
  80351a:	53                   	push   %ebx
  80351b:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80351e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803525:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80352c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803530:	74 1e                	je     803550 <merging+0x39>
  803532:	ff 75 08             	pushl  0x8(%ebp)
  803535:	e8 df f1 ff ff       	call   802719 <get_block_size>
  80353a:	83 c4 04             	add    $0x4,%esp
  80353d:	89 c2                	mov    %eax,%edx
  80353f:	8b 45 08             	mov    0x8(%ebp),%eax
  803542:	01 d0                	add    %edx,%eax
  803544:	3b 45 10             	cmp    0x10(%ebp),%eax
  803547:	75 07                	jne    803550 <merging+0x39>
		prev_is_free = 1;
  803549:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803550:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803554:	74 1e                	je     803574 <merging+0x5d>
  803556:	ff 75 10             	pushl  0x10(%ebp)
  803559:	e8 bb f1 ff ff       	call   802719 <get_block_size>
  80355e:	83 c4 04             	add    $0x4,%esp
  803561:	89 c2                	mov    %eax,%edx
  803563:	8b 45 10             	mov    0x10(%ebp),%eax
  803566:	01 d0                	add    %edx,%eax
  803568:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80356b:	75 07                	jne    803574 <merging+0x5d>
		next_is_free = 1;
  80356d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803574:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803578:	0f 84 cc 00 00 00    	je     80364a <merging+0x133>
  80357e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803582:	0f 84 c2 00 00 00    	je     80364a <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803588:	ff 75 08             	pushl  0x8(%ebp)
  80358b:	e8 89 f1 ff ff       	call   802719 <get_block_size>
  803590:	83 c4 04             	add    $0x4,%esp
  803593:	89 c3                	mov    %eax,%ebx
  803595:	ff 75 10             	pushl  0x10(%ebp)
  803598:	e8 7c f1 ff ff       	call   802719 <get_block_size>
  80359d:	83 c4 04             	add    $0x4,%esp
  8035a0:	01 c3                	add    %eax,%ebx
  8035a2:	ff 75 0c             	pushl  0xc(%ebp)
  8035a5:	e8 6f f1 ff ff       	call   802719 <get_block_size>
  8035aa:	83 c4 04             	add    $0x4,%esp
  8035ad:	01 d8                	add    %ebx,%eax
  8035af:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8035b2:	6a 00                	push   $0x0
  8035b4:	ff 75 ec             	pushl  -0x14(%ebp)
  8035b7:	ff 75 08             	pushl  0x8(%ebp)
  8035ba:	e8 ab f4 ff ff       	call   802a6a <set_block_data>
  8035bf:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8035c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035c6:	75 17                	jne    8035df <merging+0xc8>
  8035c8:	83 ec 04             	sub    $0x4,%esp
  8035cb:	68 d7 4e 80 00       	push   $0x804ed7
  8035d0:	68 7d 01 00 00       	push   $0x17d
  8035d5:	68 f5 4e 80 00       	push   $0x804ef5
  8035da:	e8 e3 d2 ff ff       	call   8008c2 <_panic>
  8035df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e2:	8b 00                	mov    (%eax),%eax
  8035e4:	85 c0                	test   %eax,%eax
  8035e6:	74 10                	je     8035f8 <merging+0xe1>
  8035e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035eb:	8b 00                	mov    (%eax),%eax
  8035ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035f0:	8b 52 04             	mov    0x4(%edx),%edx
  8035f3:	89 50 04             	mov    %edx,0x4(%eax)
  8035f6:	eb 0b                	jmp    803603 <merging+0xec>
  8035f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fb:	8b 40 04             	mov    0x4(%eax),%eax
  8035fe:	a3 30 60 80 00       	mov    %eax,0x806030
  803603:	8b 45 0c             	mov    0xc(%ebp),%eax
  803606:	8b 40 04             	mov    0x4(%eax),%eax
  803609:	85 c0                	test   %eax,%eax
  80360b:	74 0f                	je     80361c <merging+0x105>
  80360d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803610:	8b 40 04             	mov    0x4(%eax),%eax
  803613:	8b 55 0c             	mov    0xc(%ebp),%edx
  803616:	8b 12                	mov    (%edx),%edx
  803618:	89 10                	mov    %edx,(%eax)
  80361a:	eb 0a                	jmp    803626 <merging+0x10f>
  80361c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80361f:	8b 00                	mov    (%eax),%eax
  803621:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803626:	8b 45 0c             	mov    0xc(%ebp),%eax
  803629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80362f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803632:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803639:	a1 38 60 80 00       	mov    0x806038,%eax
  80363e:	48                   	dec    %eax
  80363f:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803644:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803645:	e9 ea 02 00 00       	jmp    803934 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80364a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80364e:	74 3b                	je     80368b <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803650:	83 ec 0c             	sub    $0xc,%esp
  803653:	ff 75 08             	pushl  0x8(%ebp)
  803656:	e8 be f0 ff ff       	call   802719 <get_block_size>
  80365b:	83 c4 10             	add    $0x10,%esp
  80365e:	89 c3                	mov    %eax,%ebx
  803660:	83 ec 0c             	sub    $0xc,%esp
  803663:	ff 75 10             	pushl  0x10(%ebp)
  803666:	e8 ae f0 ff ff       	call   802719 <get_block_size>
  80366b:	83 c4 10             	add    $0x10,%esp
  80366e:	01 d8                	add    %ebx,%eax
  803670:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803673:	83 ec 04             	sub    $0x4,%esp
  803676:	6a 00                	push   $0x0
  803678:	ff 75 e8             	pushl  -0x18(%ebp)
  80367b:	ff 75 08             	pushl  0x8(%ebp)
  80367e:	e8 e7 f3 ff ff       	call   802a6a <set_block_data>
  803683:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803686:	e9 a9 02 00 00       	jmp    803934 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80368b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80368f:	0f 84 2d 01 00 00    	je     8037c2 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803695:	83 ec 0c             	sub    $0xc,%esp
  803698:	ff 75 10             	pushl  0x10(%ebp)
  80369b:	e8 79 f0 ff ff       	call   802719 <get_block_size>
  8036a0:	83 c4 10             	add    $0x10,%esp
  8036a3:	89 c3                	mov    %eax,%ebx
  8036a5:	83 ec 0c             	sub    $0xc,%esp
  8036a8:	ff 75 0c             	pushl  0xc(%ebp)
  8036ab:	e8 69 f0 ff ff       	call   802719 <get_block_size>
  8036b0:	83 c4 10             	add    $0x10,%esp
  8036b3:	01 d8                	add    %ebx,%eax
  8036b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8036b8:	83 ec 04             	sub    $0x4,%esp
  8036bb:	6a 00                	push   $0x0
  8036bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036c0:	ff 75 10             	pushl  0x10(%ebp)
  8036c3:	e8 a2 f3 ff ff       	call   802a6a <set_block_data>
  8036c8:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8036cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8036ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8036d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036d5:	74 06                	je     8036dd <merging+0x1c6>
  8036d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8036db:	75 17                	jne    8036f4 <merging+0x1dd>
  8036dd:	83 ec 04             	sub    $0x4,%esp
  8036e0:	68 9c 4f 80 00       	push   $0x804f9c
  8036e5:	68 8d 01 00 00       	push   $0x18d
  8036ea:	68 f5 4e 80 00       	push   $0x804ef5
  8036ef:	e8 ce d1 ff ff       	call   8008c2 <_panic>
  8036f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036f7:	8b 50 04             	mov    0x4(%eax),%edx
  8036fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036fd:	89 50 04             	mov    %edx,0x4(%eax)
  803700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803703:	8b 55 0c             	mov    0xc(%ebp),%edx
  803706:	89 10                	mov    %edx,(%eax)
  803708:	8b 45 0c             	mov    0xc(%ebp),%eax
  80370b:	8b 40 04             	mov    0x4(%eax),%eax
  80370e:	85 c0                	test   %eax,%eax
  803710:	74 0d                	je     80371f <merging+0x208>
  803712:	8b 45 0c             	mov    0xc(%ebp),%eax
  803715:	8b 40 04             	mov    0x4(%eax),%eax
  803718:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80371b:	89 10                	mov    %edx,(%eax)
  80371d:	eb 08                	jmp    803727 <merging+0x210>
  80371f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803722:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803727:	8b 45 0c             	mov    0xc(%ebp),%eax
  80372a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80372d:	89 50 04             	mov    %edx,0x4(%eax)
  803730:	a1 38 60 80 00       	mov    0x806038,%eax
  803735:	40                   	inc    %eax
  803736:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  80373b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80373f:	75 17                	jne    803758 <merging+0x241>
  803741:	83 ec 04             	sub    $0x4,%esp
  803744:	68 d7 4e 80 00       	push   $0x804ed7
  803749:	68 8e 01 00 00       	push   $0x18e
  80374e:	68 f5 4e 80 00       	push   $0x804ef5
  803753:	e8 6a d1 ff ff       	call   8008c2 <_panic>
  803758:	8b 45 0c             	mov    0xc(%ebp),%eax
  80375b:	8b 00                	mov    (%eax),%eax
  80375d:	85 c0                	test   %eax,%eax
  80375f:	74 10                	je     803771 <merging+0x25a>
  803761:	8b 45 0c             	mov    0xc(%ebp),%eax
  803764:	8b 00                	mov    (%eax),%eax
  803766:	8b 55 0c             	mov    0xc(%ebp),%edx
  803769:	8b 52 04             	mov    0x4(%edx),%edx
  80376c:	89 50 04             	mov    %edx,0x4(%eax)
  80376f:	eb 0b                	jmp    80377c <merging+0x265>
  803771:	8b 45 0c             	mov    0xc(%ebp),%eax
  803774:	8b 40 04             	mov    0x4(%eax),%eax
  803777:	a3 30 60 80 00       	mov    %eax,0x806030
  80377c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80377f:	8b 40 04             	mov    0x4(%eax),%eax
  803782:	85 c0                	test   %eax,%eax
  803784:	74 0f                	je     803795 <merging+0x27e>
  803786:	8b 45 0c             	mov    0xc(%ebp),%eax
  803789:	8b 40 04             	mov    0x4(%eax),%eax
  80378c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80378f:	8b 12                	mov    (%edx),%edx
  803791:	89 10                	mov    %edx,(%eax)
  803793:	eb 0a                	jmp    80379f <merging+0x288>
  803795:	8b 45 0c             	mov    0xc(%ebp),%eax
  803798:	8b 00                	mov    (%eax),%eax
  80379a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80379f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037b2:	a1 38 60 80 00       	mov    0x806038,%eax
  8037b7:	48                   	dec    %eax
  8037b8:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8037bd:	e9 72 01 00 00       	jmp    803934 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8037c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8037c5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8037c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037cc:	74 79                	je     803847 <merging+0x330>
  8037ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037d2:	74 73                	je     803847 <merging+0x330>
  8037d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037d8:	74 06                	je     8037e0 <merging+0x2c9>
  8037da:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037de:	75 17                	jne    8037f7 <merging+0x2e0>
  8037e0:	83 ec 04             	sub    $0x4,%esp
  8037e3:	68 68 4f 80 00       	push   $0x804f68
  8037e8:	68 94 01 00 00       	push   $0x194
  8037ed:	68 f5 4e 80 00       	push   $0x804ef5
  8037f2:	e8 cb d0 ff ff       	call   8008c2 <_panic>
  8037f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fa:	8b 10                	mov    (%eax),%edx
  8037fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037ff:	89 10                	mov    %edx,(%eax)
  803801:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803804:	8b 00                	mov    (%eax),%eax
  803806:	85 c0                	test   %eax,%eax
  803808:	74 0b                	je     803815 <merging+0x2fe>
  80380a:	8b 45 08             	mov    0x8(%ebp),%eax
  80380d:	8b 00                	mov    (%eax),%eax
  80380f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803812:	89 50 04             	mov    %edx,0x4(%eax)
  803815:	8b 45 08             	mov    0x8(%ebp),%eax
  803818:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80381b:	89 10                	mov    %edx,(%eax)
  80381d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803820:	8b 55 08             	mov    0x8(%ebp),%edx
  803823:	89 50 04             	mov    %edx,0x4(%eax)
  803826:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803829:	8b 00                	mov    (%eax),%eax
  80382b:	85 c0                	test   %eax,%eax
  80382d:	75 08                	jne    803837 <merging+0x320>
  80382f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803832:	a3 30 60 80 00       	mov    %eax,0x806030
  803837:	a1 38 60 80 00       	mov    0x806038,%eax
  80383c:	40                   	inc    %eax
  80383d:	a3 38 60 80 00       	mov    %eax,0x806038
  803842:	e9 ce 00 00 00       	jmp    803915 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803847:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80384b:	74 65                	je     8038b2 <merging+0x39b>
  80384d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803851:	75 17                	jne    80386a <merging+0x353>
  803853:	83 ec 04             	sub    $0x4,%esp
  803856:	68 44 4f 80 00       	push   $0x804f44
  80385b:	68 95 01 00 00       	push   $0x195
  803860:	68 f5 4e 80 00       	push   $0x804ef5
  803865:	e8 58 d0 ff ff       	call   8008c2 <_panic>
  80386a:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803870:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803873:	89 50 04             	mov    %edx,0x4(%eax)
  803876:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803879:	8b 40 04             	mov    0x4(%eax),%eax
  80387c:	85 c0                	test   %eax,%eax
  80387e:	74 0c                	je     80388c <merging+0x375>
  803880:	a1 30 60 80 00       	mov    0x806030,%eax
  803885:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803888:	89 10                	mov    %edx,(%eax)
  80388a:	eb 08                	jmp    803894 <merging+0x37d>
  80388c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80388f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803894:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803897:	a3 30 60 80 00       	mov    %eax,0x806030
  80389c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80389f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038a5:	a1 38 60 80 00       	mov    0x806038,%eax
  8038aa:	40                   	inc    %eax
  8038ab:	a3 38 60 80 00       	mov    %eax,0x806038
  8038b0:	eb 63                	jmp    803915 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8038b2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038b6:	75 17                	jne    8038cf <merging+0x3b8>
  8038b8:	83 ec 04             	sub    $0x4,%esp
  8038bb:	68 10 4f 80 00       	push   $0x804f10
  8038c0:	68 98 01 00 00       	push   $0x198
  8038c5:	68 f5 4e 80 00       	push   $0x804ef5
  8038ca:	e8 f3 cf ff ff       	call   8008c2 <_panic>
  8038cf:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8038d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038d8:	89 10                	mov    %edx,(%eax)
  8038da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038dd:	8b 00                	mov    (%eax),%eax
  8038df:	85 c0                	test   %eax,%eax
  8038e1:	74 0d                	je     8038f0 <merging+0x3d9>
  8038e3:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8038e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038eb:	89 50 04             	mov    %edx,0x4(%eax)
  8038ee:	eb 08                	jmp    8038f8 <merging+0x3e1>
  8038f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038f3:	a3 30 60 80 00       	mov    %eax,0x806030
  8038f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038fb:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803900:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803903:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80390a:	a1 38 60 80 00       	mov    0x806038,%eax
  80390f:	40                   	inc    %eax
  803910:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  803915:	83 ec 0c             	sub    $0xc,%esp
  803918:	ff 75 10             	pushl  0x10(%ebp)
  80391b:	e8 f9 ed ff ff       	call   802719 <get_block_size>
  803920:	83 c4 10             	add    $0x10,%esp
  803923:	83 ec 04             	sub    $0x4,%esp
  803926:	6a 00                	push   $0x0
  803928:	50                   	push   %eax
  803929:	ff 75 10             	pushl  0x10(%ebp)
  80392c:	e8 39 f1 ff ff       	call   802a6a <set_block_data>
  803931:	83 c4 10             	add    $0x10,%esp
	}
}
  803934:	90                   	nop
  803935:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803938:	c9                   	leave  
  803939:	c3                   	ret    

0080393a <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80393a:	55                   	push   %ebp
  80393b:	89 e5                	mov    %esp,%ebp
  80393d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803940:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803945:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803948:	a1 30 60 80 00       	mov    0x806030,%eax
  80394d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803950:	73 1b                	jae    80396d <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803952:	a1 30 60 80 00       	mov    0x806030,%eax
  803957:	83 ec 04             	sub    $0x4,%esp
  80395a:	ff 75 08             	pushl  0x8(%ebp)
  80395d:	6a 00                	push   $0x0
  80395f:	50                   	push   %eax
  803960:	e8 b2 fb ff ff       	call   803517 <merging>
  803965:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803968:	e9 8b 00 00 00       	jmp    8039f8 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80396d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803972:	3b 45 08             	cmp    0x8(%ebp),%eax
  803975:	76 18                	jbe    80398f <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803977:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80397c:	83 ec 04             	sub    $0x4,%esp
  80397f:	ff 75 08             	pushl  0x8(%ebp)
  803982:	50                   	push   %eax
  803983:	6a 00                	push   $0x0
  803985:	e8 8d fb ff ff       	call   803517 <merging>
  80398a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80398d:	eb 69                	jmp    8039f8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80398f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803994:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803997:	eb 39                	jmp    8039d2 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80399f:	73 29                	jae    8039ca <free_block+0x90>
  8039a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a4:	8b 00                	mov    (%eax),%eax
  8039a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039a9:	76 1f                	jbe    8039ca <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8039ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ae:	8b 00                	mov    (%eax),%eax
  8039b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8039b3:	83 ec 04             	sub    $0x4,%esp
  8039b6:	ff 75 08             	pushl  0x8(%ebp)
  8039b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8039bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8039bf:	e8 53 fb ff ff       	call   803517 <merging>
  8039c4:	83 c4 10             	add    $0x10,%esp
			break;
  8039c7:	90                   	nop
		}
	}
}
  8039c8:	eb 2e                	jmp    8039f8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8039ca:	a1 34 60 80 00       	mov    0x806034,%eax
  8039cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039d6:	74 07                	je     8039df <free_block+0xa5>
  8039d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039db:	8b 00                	mov    (%eax),%eax
  8039dd:	eb 05                	jmp    8039e4 <free_block+0xaa>
  8039df:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e4:	a3 34 60 80 00       	mov    %eax,0x806034
  8039e9:	a1 34 60 80 00       	mov    0x806034,%eax
  8039ee:	85 c0                	test   %eax,%eax
  8039f0:	75 a7                	jne    803999 <free_block+0x5f>
  8039f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039f6:	75 a1                	jne    803999 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8039f8:	90                   	nop
  8039f9:	c9                   	leave  
  8039fa:	c3                   	ret    

008039fb <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8039fb:	55                   	push   %ebp
  8039fc:	89 e5                	mov    %esp,%ebp
  8039fe:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803a01:	ff 75 08             	pushl  0x8(%ebp)
  803a04:	e8 10 ed ff ff       	call   802719 <get_block_size>
  803a09:	83 c4 04             	add    $0x4,%esp
  803a0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803a0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803a16:	eb 17                	jmp    803a2f <copy_data+0x34>
  803a18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a1e:	01 c2                	add    %eax,%edx
  803a20:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803a23:	8b 45 08             	mov    0x8(%ebp),%eax
  803a26:	01 c8                	add    %ecx,%eax
  803a28:	8a 00                	mov    (%eax),%al
  803a2a:	88 02                	mov    %al,(%edx)
  803a2c:	ff 45 fc             	incl   -0x4(%ebp)
  803a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a32:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803a35:	72 e1                	jb     803a18 <copy_data+0x1d>
}
  803a37:	90                   	nop
  803a38:	c9                   	leave  
  803a39:	c3                   	ret    

00803a3a <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803a3a:	55                   	push   %ebp
  803a3b:	89 e5                	mov    %esp,%ebp
  803a3d:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803a40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a44:	75 23                	jne    803a69 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803a46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a4a:	74 13                	je     803a5f <realloc_block_FF+0x25>
  803a4c:	83 ec 0c             	sub    $0xc,%esp
  803a4f:	ff 75 0c             	pushl  0xc(%ebp)
  803a52:	e8 42 f0 ff ff       	call   802a99 <alloc_block_FF>
  803a57:	83 c4 10             	add    $0x10,%esp
  803a5a:	e9 e4 06 00 00       	jmp    804143 <realloc_block_FF+0x709>
		return NULL;
  803a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  803a64:	e9 da 06 00 00       	jmp    804143 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803a69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a6d:	75 18                	jne    803a87 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803a6f:	83 ec 0c             	sub    $0xc,%esp
  803a72:	ff 75 08             	pushl  0x8(%ebp)
  803a75:	e8 c0 fe ff ff       	call   80393a <free_block>
  803a7a:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803a7d:	b8 00 00 00 00       	mov    $0x0,%eax
  803a82:	e9 bc 06 00 00       	jmp    804143 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803a87:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803a8b:	77 07                	ja     803a94 <realloc_block_FF+0x5a>
  803a8d:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803a94:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a97:	83 e0 01             	and    $0x1,%eax
  803a9a:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aa0:	83 c0 08             	add    $0x8,%eax
  803aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803aa6:	83 ec 0c             	sub    $0xc,%esp
  803aa9:	ff 75 08             	pushl  0x8(%ebp)
  803aac:	e8 68 ec ff ff       	call   802719 <get_block_size>
  803ab1:	83 c4 10             	add    $0x10,%esp
  803ab4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aba:	83 e8 08             	sub    $0x8,%eax
  803abd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac3:	83 e8 04             	sub    $0x4,%eax
  803ac6:	8b 00                	mov    (%eax),%eax
  803ac8:	83 e0 fe             	and    $0xfffffffe,%eax
  803acb:	89 c2                	mov    %eax,%edx
  803acd:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad0:	01 d0                	add    %edx,%eax
  803ad2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803ad5:	83 ec 0c             	sub    $0xc,%esp
  803ad8:	ff 75 e4             	pushl  -0x1c(%ebp)
  803adb:	e8 39 ec ff ff       	call   802719 <get_block_size>
  803ae0:	83 c4 10             	add    $0x10,%esp
  803ae3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803ae6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ae9:	83 e8 08             	sub    $0x8,%eax
  803aec:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  803af2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803af5:	75 08                	jne    803aff <realloc_block_FF+0xc5>
	{
		 return va;
  803af7:	8b 45 08             	mov    0x8(%ebp),%eax
  803afa:	e9 44 06 00 00       	jmp    804143 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b02:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b05:	0f 83 d5 03 00 00    	jae    803ee0 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803b0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b0e:	2b 45 0c             	sub    0xc(%ebp),%eax
  803b11:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803b14:	83 ec 0c             	sub    $0xc,%esp
  803b17:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b1a:	e8 13 ec ff ff       	call   802732 <is_free_block>
  803b1f:	83 c4 10             	add    $0x10,%esp
  803b22:	84 c0                	test   %al,%al
  803b24:	0f 84 3b 01 00 00    	je     803c65 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803b2a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b2d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b30:	01 d0                	add    %edx,%eax
  803b32:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803b35:	83 ec 04             	sub    $0x4,%esp
  803b38:	6a 01                	push   $0x1
  803b3a:	ff 75 f0             	pushl  -0x10(%ebp)
  803b3d:	ff 75 08             	pushl  0x8(%ebp)
  803b40:	e8 25 ef ff ff       	call   802a6a <set_block_data>
  803b45:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803b48:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4b:	83 e8 04             	sub    $0x4,%eax
  803b4e:	8b 00                	mov    (%eax),%eax
  803b50:	83 e0 fe             	and    $0xfffffffe,%eax
  803b53:	89 c2                	mov    %eax,%edx
  803b55:	8b 45 08             	mov    0x8(%ebp),%eax
  803b58:	01 d0                	add    %edx,%eax
  803b5a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803b5d:	83 ec 04             	sub    $0x4,%esp
  803b60:	6a 00                	push   $0x0
  803b62:	ff 75 cc             	pushl  -0x34(%ebp)
  803b65:	ff 75 c8             	pushl  -0x38(%ebp)
  803b68:	e8 fd ee ff ff       	call   802a6a <set_block_data>
  803b6d:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803b70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b74:	74 06                	je     803b7c <realloc_block_FF+0x142>
  803b76:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803b7a:	75 17                	jne    803b93 <realloc_block_FF+0x159>
  803b7c:	83 ec 04             	sub    $0x4,%esp
  803b7f:	68 68 4f 80 00       	push   $0x804f68
  803b84:	68 f6 01 00 00       	push   $0x1f6
  803b89:	68 f5 4e 80 00       	push   $0x804ef5
  803b8e:	e8 2f cd ff ff       	call   8008c2 <_panic>
  803b93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b96:	8b 10                	mov    (%eax),%edx
  803b98:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b9b:	89 10                	mov    %edx,(%eax)
  803b9d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ba0:	8b 00                	mov    (%eax),%eax
  803ba2:	85 c0                	test   %eax,%eax
  803ba4:	74 0b                	je     803bb1 <realloc_block_FF+0x177>
  803ba6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba9:	8b 00                	mov    (%eax),%eax
  803bab:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bae:	89 50 04             	mov    %edx,0x4(%eax)
  803bb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bb7:	89 10                	mov    %edx,(%eax)
  803bb9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bbc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bbf:	89 50 04             	mov    %edx,0x4(%eax)
  803bc2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bc5:	8b 00                	mov    (%eax),%eax
  803bc7:	85 c0                	test   %eax,%eax
  803bc9:	75 08                	jne    803bd3 <realloc_block_FF+0x199>
  803bcb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803bce:	a3 30 60 80 00       	mov    %eax,0x806030
  803bd3:	a1 38 60 80 00       	mov    0x806038,%eax
  803bd8:	40                   	inc    %eax
  803bd9:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803bde:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803be2:	75 17                	jne    803bfb <realloc_block_FF+0x1c1>
  803be4:	83 ec 04             	sub    $0x4,%esp
  803be7:	68 d7 4e 80 00       	push   $0x804ed7
  803bec:	68 f7 01 00 00       	push   $0x1f7
  803bf1:	68 f5 4e 80 00       	push   $0x804ef5
  803bf6:	e8 c7 cc ff ff       	call   8008c2 <_panic>
  803bfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bfe:	8b 00                	mov    (%eax),%eax
  803c00:	85 c0                	test   %eax,%eax
  803c02:	74 10                	je     803c14 <realloc_block_FF+0x1da>
  803c04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c07:	8b 00                	mov    (%eax),%eax
  803c09:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c0c:	8b 52 04             	mov    0x4(%edx),%edx
  803c0f:	89 50 04             	mov    %edx,0x4(%eax)
  803c12:	eb 0b                	jmp    803c1f <realloc_block_FF+0x1e5>
  803c14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c17:	8b 40 04             	mov    0x4(%eax),%eax
  803c1a:	a3 30 60 80 00       	mov    %eax,0x806030
  803c1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c22:	8b 40 04             	mov    0x4(%eax),%eax
  803c25:	85 c0                	test   %eax,%eax
  803c27:	74 0f                	je     803c38 <realloc_block_FF+0x1fe>
  803c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2c:	8b 40 04             	mov    0x4(%eax),%eax
  803c2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c32:	8b 12                	mov    (%edx),%edx
  803c34:	89 10                	mov    %edx,(%eax)
  803c36:	eb 0a                	jmp    803c42 <realloc_block_FF+0x208>
  803c38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3b:	8b 00                	mov    (%eax),%eax
  803c3d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803c42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c55:	a1 38 60 80 00       	mov    0x806038,%eax
  803c5a:	48                   	dec    %eax
  803c5b:	a3 38 60 80 00       	mov    %eax,0x806038
  803c60:	e9 73 02 00 00       	jmp    803ed8 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803c65:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803c69:	0f 86 69 02 00 00    	jbe    803ed8 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803c6f:	83 ec 04             	sub    $0x4,%esp
  803c72:	6a 01                	push   $0x1
  803c74:	ff 75 f0             	pushl  -0x10(%ebp)
  803c77:	ff 75 08             	pushl  0x8(%ebp)
  803c7a:	e8 eb ed ff ff       	call   802a6a <set_block_data>
  803c7f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803c82:	8b 45 08             	mov    0x8(%ebp),%eax
  803c85:	83 e8 04             	sub    $0x4,%eax
  803c88:	8b 00                	mov    (%eax),%eax
  803c8a:	83 e0 fe             	and    $0xfffffffe,%eax
  803c8d:	89 c2                	mov    %eax,%edx
  803c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c92:	01 d0                	add    %edx,%eax
  803c94:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803c97:	a1 38 60 80 00       	mov    0x806038,%eax
  803c9c:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803c9f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803ca3:	75 68                	jne    803d0d <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ca5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ca9:	75 17                	jne    803cc2 <realloc_block_FF+0x288>
  803cab:	83 ec 04             	sub    $0x4,%esp
  803cae:	68 10 4f 80 00       	push   $0x804f10
  803cb3:	68 06 02 00 00       	push   $0x206
  803cb8:	68 f5 4e 80 00       	push   $0x804ef5
  803cbd:	e8 00 cc ff ff       	call   8008c2 <_panic>
  803cc2:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803cc8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ccb:	89 10                	mov    %edx,(%eax)
  803ccd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cd0:	8b 00                	mov    (%eax),%eax
  803cd2:	85 c0                	test   %eax,%eax
  803cd4:	74 0d                	je     803ce3 <realloc_block_FF+0x2a9>
  803cd6:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803cdb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cde:	89 50 04             	mov    %edx,0x4(%eax)
  803ce1:	eb 08                	jmp    803ceb <realloc_block_FF+0x2b1>
  803ce3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ce6:	a3 30 60 80 00       	mov    %eax,0x806030
  803ceb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cee:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803cf3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cf6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cfd:	a1 38 60 80 00       	mov    0x806038,%eax
  803d02:	40                   	inc    %eax
  803d03:	a3 38 60 80 00       	mov    %eax,0x806038
  803d08:	e9 b0 01 00 00       	jmp    803ebd <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803d0d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d12:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d15:	76 68                	jbe    803d7f <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d17:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d1b:	75 17                	jne    803d34 <realloc_block_FF+0x2fa>
  803d1d:	83 ec 04             	sub    $0x4,%esp
  803d20:	68 10 4f 80 00       	push   $0x804f10
  803d25:	68 0b 02 00 00       	push   $0x20b
  803d2a:	68 f5 4e 80 00       	push   $0x804ef5
  803d2f:	e8 8e cb ff ff       	call   8008c2 <_panic>
  803d34:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803d3a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d3d:	89 10                	mov    %edx,(%eax)
  803d3f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d42:	8b 00                	mov    (%eax),%eax
  803d44:	85 c0                	test   %eax,%eax
  803d46:	74 0d                	je     803d55 <realloc_block_FF+0x31b>
  803d48:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d4d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d50:	89 50 04             	mov    %edx,0x4(%eax)
  803d53:	eb 08                	jmp    803d5d <realloc_block_FF+0x323>
  803d55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d58:	a3 30 60 80 00       	mov    %eax,0x806030
  803d5d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d60:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d65:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d6f:	a1 38 60 80 00       	mov    0x806038,%eax
  803d74:	40                   	inc    %eax
  803d75:	a3 38 60 80 00       	mov    %eax,0x806038
  803d7a:	e9 3e 01 00 00       	jmp    803ebd <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803d7f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803d84:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d87:	73 68                	jae    803df1 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d89:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d8d:	75 17                	jne    803da6 <realloc_block_FF+0x36c>
  803d8f:	83 ec 04             	sub    $0x4,%esp
  803d92:	68 44 4f 80 00       	push   $0x804f44
  803d97:	68 10 02 00 00       	push   $0x210
  803d9c:	68 f5 4e 80 00       	push   $0x804ef5
  803da1:	e8 1c cb ff ff       	call   8008c2 <_panic>
  803da6:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803dac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803daf:	89 50 04             	mov    %edx,0x4(%eax)
  803db2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803db5:	8b 40 04             	mov    0x4(%eax),%eax
  803db8:	85 c0                	test   %eax,%eax
  803dba:	74 0c                	je     803dc8 <realloc_block_FF+0x38e>
  803dbc:	a1 30 60 80 00       	mov    0x806030,%eax
  803dc1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dc4:	89 10                	mov    %edx,(%eax)
  803dc6:	eb 08                	jmp    803dd0 <realloc_block_FF+0x396>
  803dc8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dcb:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803dd0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dd3:	a3 30 60 80 00       	mov    %eax,0x806030
  803dd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ddb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803de1:	a1 38 60 80 00       	mov    0x806038,%eax
  803de6:	40                   	inc    %eax
  803de7:	a3 38 60 80 00       	mov    %eax,0x806038
  803dec:	e9 cc 00 00 00       	jmp    803ebd <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803df1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803df8:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803dfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e00:	e9 8a 00 00 00       	jmp    803e8f <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e08:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e0b:	73 7a                	jae    803e87 <realloc_block_FF+0x44d>
  803e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e10:	8b 00                	mov    (%eax),%eax
  803e12:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e15:	73 70                	jae    803e87 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803e17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e1b:	74 06                	je     803e23 <realloc_block_FF+0x3e9>
  803e1d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e21:	75 17                	jne    803e3a <realloc_block_FF+0x400>
  803e23:	83 ec 04             	sub    $0x4,%esp
  803e26:	68 68 4f 80 00       	push   $0x804f68
  803e2b:	68 1a 02 00 00       	push   $0x21a
  803e30:	68 f5 4e 80 00       	push   $0x804ef5
  803e35:	e8 88 ca ff ff       	call   8008c2 <_panic>
  803e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e3d:	8b 10                	mov    (%eax),%edx
  803e3f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e42:	89 10                	mov    %edx,(%eax)
  803e44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e47:	8b 00                	mov    (%eax),%eax
  803e49:	85 c0                	test   %eax,%eax
  803e4b:	74 0b                	je     803e58 <realloc_block_FF+0x41e>
  803e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e50:	8b 00                	mov    (%eax),%eax
  803e52:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e55:	89 50 04             	mov    %edx,0x4(%eax)
  803e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e5e:	89 10                	mov    %edx,(%eax)
  803e60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e66:	89 50 04             	mov    %edx,0x4(%eax)
  803e69:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e6c:	8b 00                	mov    (%eax),%eax
  803e6e:	85 c0                	test   %eax,%eax
  803e70:	75 08                	jne    803e7a <realloc_block_FF+0x440>
  803e72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e75:	a3 30 60 80 00       	mov    %eax,0x806030
  803e7a:	a1 38 60 80 00       	mov    0x806038,%eax
  803e7f:	40                   	inc    %eax
  803e80:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  803e85:	eb 36                	jmp    803ebd <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803e87:	a1 34 60 80 00       	mov    0x806034,%eax
  803e8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e93:	74 07                	je     803e9c <realloc_block_FF+0x462>
  803e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e98:	8b 00                	mov    (%eax),%eax
  803e9a:	eb 05                	jmp    803ea1 <realloc_block_FF+0x467>
  803e9c:	b8 00 00 00 00       	mov    $0x0,%eax
  803ea1:	a3 34 60 80 00       	mov    %eax,0x806034
  803ea6:	a1 34 60 80 00       	mov    0x806034,%eax
  803eab:	85 c0                	test   %eax,%eax
  803ead:	0f 85 52 ff ff ff    	jne    803e05 <realloc_block_FF+0x3cb>
  803eb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803eb7:	0f 85 48 ff ff ff    	jne    803e05 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803ebd:	83 ec 04             	sub    $0x4,%esp
  803ec0:	6a 00                	push   $0x0
  803ec2:	ff 75 d8             	pushl  -0x28(%ebp)
  803ec5:	ff 75 d4             	pushl  -0x2c(%ebp)
  803ec8:	e8 9d eb ff ff       	call   802a6a <set_block_data>
  803ecd:	83 c4 10             	add    $0x10,%esp
				return va;
  803ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed3:	e9 6b 02 00 00       	jmp    804143 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  803edb:	e9 63 02 00 00       	jmp    804143 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ee3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ee6:	0f 86 4d 02 00 00    	jbe    804139 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803eec:	83 ec 0c             	sub    $0xc,%esp
  803eef:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ef2:	e8 3b e8 ff ff       	call   802732 <is_free_block>
  803ef7:	83 c4 10             	add    $0x10,%esp
  803efa:	84 c0                	test   %al,%al
  803efc:	0f 84 37 02 00 00    	je     804139 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f05:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803f08:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803f0b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f0e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803f11:	76 38                	jbe    803f4b <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803f13:	83 ec 0c             	sub    $0xc,%esp
  803f16:	ff 75 0c             	pushl  0xc(%ebp)
  803f19:	e8 7b eb ff ff       	call   802a99 <alloc_block_FF>
  803f1e:	83 c4 10             	add    $0x10,%esp
  803f21:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803f24:	83 ec 08             	sub    $0x8,%esp
  803f27:	ff 75 c0             	pushl  -0x40(%ebp)
  803f2a:	ff 75 08             	pushl  0x8(%ebp)
  803f2d:	e8 c9 fa ff ff       	call   8039fb <copy_data>
  803f32:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803f35:	83 ec 0c             	sub    $0xc,%esp
  803f38:	ff 75 08             	pushl  0x8(%ebp)
  803f3b:	e8 fa f9 ff ff       	call   80393a <free_block>
  803f40:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803f43:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803f46:	e9 f8 01 00 00       	jmp    804143 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803f4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f4e:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803f51:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803f54:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803f58:	0f 87 a0 00 00 00    	ja     803ffe <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803f5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f62:	75 17                	jne    803f7b <realloc_block_FF+0x541>
  803f64:	83 ec 04             	sub    $0x4,%esp
  803f67:	68 d7 4e 80 00       	push   $0x804ed7
  803f6c:	68 38 02 00 00       	push   $0x238
  803f71:	68 f5 4e 80 00       	push   $0x804ef5
  803f76:	e8 47 c9 ff ff       	call   8008c2 <_panic>
  803f7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f7e:	8b 00                	mov    (%eax),%eax
  803f80:	85 c0                	test   %eax,%eax
  803f82:	74 10                	je     803f94 <realloc_block_FF+0x55a>
  803f84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f87:	8b 00                	mov    (%eax),%eax
  803f89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f8c:	8b 52 04             	mov    0x4(%edx),%edx
  803f8f:	89 50 04             	mov    %edx,0x4(%eax)
  803f92:	eb 0b                	jmp    803f9f <realloc_block_FF+0x565>
  803f94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f97:	8b 40 04             	mov    0x4(%eax),%eax
  803f9a:	a3 30 60 80 00       	mov    %eax,0x806030
  803f9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa2:	8b 40 04             	mov    0x4(%eax),%eax
  803fa5:	85 c0                	test   %eax,%eax
  803fa7:	74 0f                	je     803fb8 <realloc_block_FF+0x57e>
  803fa9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fac:	8b 40 04             	mov    0x4(%eax),%eax
  803faf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fb2:	8b 12                	mov    (%edx),%edx
  803fb4:	89 10                	mov    %edx,(%eax)
  803fb6:	eb 0a                	jmp    803fc2 <realloc_block_FF+0x588>
  803fb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fbb:	8b 00                	mov    (%eax),%eax
  803fbd:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803fc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fd5:	a1 38 60 80 00       	mov    0x806038,%eax
  803fda:	48                   	dec    %eax
  803fdb:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803fe0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fe3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fe6:	01 d0                	add    %edx,%eax
  803fe8:	83 ec 04             	sub    $0x4,%esp
  803feb:	6a 01                	push   $0x1
  803fed:	50                   	push   %eax
  803fee:	ff 75 08             	pushl  0x8(%ebp)
  803ff1:	e8 74 ea ff ff       	call   802a6a <set_block_data>
  803ff6:	83 c4 10             	add    $0x10,%esp
  803ff9:	e9 36 01 00 00       	jmp    804134 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803ffe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804001:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804004:	01 d0                	add    %edx,%eax
  804006:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804009:	83 ec 04             	sub    $0x4,%esp
  80400c:	6a 01                	push   $0x1
  80400e:	ff 75 f0             	pushl  -0x10(%ebp)
  804011:	ff 75 08             	pushl  0x8(%ebp)
  804014:	e8 51 ea ff ff       	call   802a6a <set_block_data>
  804019:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80401c:	8b 45 08             	mov    0x8(%ebp),%eax
  80401f:	83 e8 04             	sub    $0x4,%eax
  804022:	8b 00                	mov    (%eax),%eax
  804024:	83 e0 fe             	and    $0xfffffffe,%eax
  804027:	89 c2                	mov    %eax,%edx
  804029:	8b 45 08             	mov    0x8(%ebp),%eax
  80402c:	01 d0                	add    %edx,%eax
  80402e:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804031:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804035:	74 06                	je     80403d <realloc_block_FF+0x603>
  804037:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80403b:	75 17                	jne    804054 <realloc_block_FF+0x61a>
  80403d:	83 ec 04             	sub    $0x4,%esp
  804040:	68 68 4f 80 00       	push   $0x804f68
  804045:	68 44 02 00 00       	push   $0x244
  80404a:	68 f5 4e 80 00       	push   $0x804ef5
  80404f:	e8 6e c8 ff ff       	call   8008c2 <_panic>
  804054:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804057:	8b 10                	mov    (%eax),%edx
  804059:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80405c:	89 10                	mov    %edx,(%eax)
  80405e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804061:	8b 00                	mov    (%eax),%eax
  804063:	85 c0                	test   %eax,%eax
  804065:	74 0b                	je     804072 <realloc_block_FF+0x638>
  804067:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80406a:	8b 00                	mov    (%eax),%eax
  80406c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80406f:	89 50 04             	mov    %edx,0x4(%eax)
  804072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804075:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804078:	89 10                	mov    %edx,(%eax)
  80407a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80407d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804080:	89 50 04             	mov    %edx,0x4(%eax)
  804083:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804086:	8b 00                	mov    (%eax),%eax
  804088:	85 c0                	test   %eax,%eax
  80408a:	75 08                	jne    804094 <realloc_block_FF+0x65a>
  80408c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80408f:	a3 30 60 80 00       	mov    %eax,0x806030
  804094:	a1 38 60 80 00       	mov    0x806038,%eax
  804099:	40                   	inc    %eax
  80409a:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80409f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040a3:	75 17                	jne    8040bc <realloc_block_FF+0x682>
  8040a5:	83 ec 04             	sub    $0x4,%esp
  8040a8:	68 d7 4e 80 00       	push   $0x804ed7
  8040ad:	68 45 02 00 00       	push   $0x245
  8040b2:	68 f5 4e 80 00       	push   $0x804ef5
  8040b7:	e8 06 c8 ff ff       	call   8008c2 <_panic>
  8040bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040bf:	8b 00                	mov    (%eax),%eax
  8040c1:	85 c0                	test   %eax,%eax
  8040c3:	74 10                	je     8040d5 <realloc_block_FF+0x69b>
  8040c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040c8:	8b 00                	mov    (%eax),%eax
  8040ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040cd:	8b 52 04             	mov    0x4(%edx),%edx
  8040d0:	89 50 04             	mov    %edx,0x4(%eax)
  8040d3:	eb 0b                	jmp    8040e0 <realloc_block_FF+0x6a6>
  8040d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040d8:	8b 40 04             	mov    0x4(%eax),%eax
  8040db:	a3 30 60 80 00       	mov    %eax,0x806030
  8040e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e3:	8b 40 04             	mov    0x4(%eax),%eax
  8040e6:	85 c0                	test   %eax,%eax
  8040e8:	74 0f                	je     8040f9 <realloc_block_FF+0x6bf>
  8040ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040ed:	8b 40 04             	mov    0x4(%eax),%eax
  8040f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040f3:	8b 12                	mov    (%edx),%edx
  8040f5:	89 10                	mov    %edx,(%eax)
  8040f7:	eb 0a                	jmp    804103 <realloc_block_FF+0x6c9>
  8040f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040fc:	8b 00                	mov    (%eax),%eax
  8040fe:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804106:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80410c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80410f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804116:	a1 38 60 80 00       	mov    0x806038,%eax
  80411b:	48                   	dec    %eax
  80411c:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  804121:	83 ec 04             	sub    $0x4,%esp
  804124:	6a 00                	push   $0x0
  804126:	ff 75 bc             	pushl  -0x44(%ebp)
  804129:	ff 75 b8             	pushl  -0x48(%ebp)
  80412c:	e8 39 e9 ff ff       	call   802a6a <set_block_data>
  804131:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804134:	8b 45 08             	mov    0x8(%ebp),%eax
  804137:	eb 0a                	jmp    804143 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804139:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804140:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804143:	c9                   	leave  
  804144:	c3                   	ret    

00804145 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804145:	55                   	push   %ebp
  804146:	89 e5                	mov    %esp,%ebp
  804148:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80414b:	83 ec 04             	sub    $0x4,%esp
  80414e:	68 d4 4f 80 00       	push   $0x804fd4
  804153:	68 58 02 00 00       	push   $0x258
  804158:	68 f5 4e 80 00       	push   $0x804ef5
  80415d:	e8 60 c7 ff ff       	call   8008c2 <_panic>

00804162 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804162:	55                   	push   %ebp
  804163:	89 e5                	mov    %esp,%ebp
  804165:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804168:	83 ec 04             	sub    $0x4,%esp
  80416b:	68 fc 4f 80 00       	push   $0x804ffc
  804170:	68 61 02 00 00       	push   $0x261
  804175:	68 f5 4e 80 00       	push   $0x804ef5
  80417a:	e8 43 c7 ff ff       	call   8008c2 <_panic>

0080417f <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80417f:	55                   	push   %ebp
  804180:	89 e5                	mov    %esp,%ebp
  804182:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("create_semaphore is not implemented yet");
	//Your Code is Here...

		void* ret = smalloc(semaphoreName, sizeof(struct semaphore), 1);
  804185:	83 ec 04             	sub    $0x4,%esp
  804188:	6a 01                	push   $0x1
  80418a:	6a 04                	push   $0x4
  80418c:	ff 75 0c             	pushl  0xc(%ebp)
  80418f:	e8 c1 dc ff ff       	call   801e55 <smalloc>
  804194:	83 c4 10             	add    $0x10,%esp
  804197:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if (ret == NULL ) panic("no memory in creat_semaphore");
  80419a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80419e:	75 14                	jne    8041b4 <create_semaphore+0x35>
  8041a0:	83 ec 04             	sub    $0x4,%esp
  8041a3:	68 22 50 80 00       	push   $0x805022
  8041a8:	6a 0d                	push   $0xd
  8041aa:	68 3f 50 80 00       	push   $0x80503f
  8041af:	e8 0e c7 ff ff       	call   8008c2 <_panic>

	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  8041b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041b7:	89 45 f0             	mov    %eax,-0x10(%ebp)

	    sem_ptr->semdata->count = value;
  8041ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041bd:	8b 00                	mov    (%eax),%eax
  8041bf:	8b 55 10             	mov    0x10(%ebp),%edx
  8041c2:	89 50 10             	mov    %edx,0x10(%eax)
	    sys_init_queue(&(sem_ptr->semdata->queue));
  8041c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041c8:	8b 00                	mov    (%eax),%eax
  8041ca:	83 ec 0c             	sub    $0xc,%esp
  8041cd:	50                   	push   %eax
  8041ce:	e8 cc e4 ff ff       	call   80269f <sys_init_queue>
  8041d3:	83 c4 10             	add    $0x10,%esp

	    sem_ptr->semdata->lock = 0;
  8041d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041d9:	8b 00                	mov    (%eax),%eax
  8041db:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	    return *sem_ptr;
  8041e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8041e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8041e8:	8b 12                	mov    (%edx),%edx
  8041ea:	89 10                	mov    %edx,(%eax)
}
  8041ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8041ef:	c9                   	leave  
  8041f0:	c2 04 00             	ret    $0x4

008041f3 <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8041f3:	55                   	push   %ebp
  8041f4:	89 e5                	mov    %esp,%ebp
  8041f6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("get_semaphore is not implemented yet");
	//Your Code is Here...
		void* ret = sget(ownerEnvID, semaphoreName);
  8041f9:	83 ec 08             	sub    $0x8,%esp
  8041fc:	ff 75 10             	pushl  0x10(%ebp)
  8041ff:	ff 75 0c             	pushl  0xc(%ebp)
  804202:	e8 f3 dc ff ff       	call   801efa <sget>
  804207:	83 c4 10             	add    $0x10,%esp
  80420a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (ret == NULL ) panic("no semaphore in get_semaphore");
  80420d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804211:	75 14                	jne    804227 <get_semaphore+0x34>
  804213:	83 ec 04             	sub    $0x4,%esp
  804216:	68 4f 50 80 00       	push   $0x80504f
  80421b:	6a 1f                	push   $0x1f
  80421d:	68 3f 50 80 00       	push   $0x80503f
  804222:	e8 9b c6 ff ff       	call   8008c2 <_panic>
	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  804227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80422a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    return *sem_ptr;
  80422d:	8b 45 08             	mov    0x8(%ebp),%eax
  804230:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804233:	8b 12                	mov    (%edx),%edx
  804235:	89 10                	mov    %edx,(%eax)
}
  804237:	8b 45 08             	mov    0x8(%ebp),%eax
  80423a:	c9                   	leave  
  80423b:	c2 04 00             	ret    $0x4

0080423e <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  80423e:	55                   	push   %ebp
  80423f:	89 e5                	mov    %esp,%ebp
  804241:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("wait_semaphore is not implemented yet");
	//Your Code is Here...
			uint32 key = 1;
  804244:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		    do { xchg(&sem.semdata->lock,key); } while (key != 0);
  80424b:	8b 45 08             	mov    0x8(%ebp),%eax
  80424e:	83 c0 14             	add    $0x14,%eax
  804251:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804257:	89 45 e8             	mov    %eax,-0x18(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  80425a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80425d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804260:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  804263:	f0 87 02             	lock xchg %eax,(%edx)
  804266:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  804269:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80426d:	75 dc                	jne    80424b <wait_semaphore+0xd>

		    sem.semdata->count--;
  80426f:	8b 45 08             	mov    0x8(%ebp),%eax
  804272:	8b 50 10             	mov    0x10(%eax),%edx
  804275:	4a                   	dec    %edx
  804276:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count < 0) {
  804279:	8b 45 08             	mov    0x8(%ebp),%eax
  80427c:	8b 40 10             	mov    0x10(%eax),%eax
  80427f:	85 c0                	test   %eax,%eax
  804281:	79 30                	jns    8042b3 <wait_semaphore+0x75>

	    	struct Env* cur_env = sys_get_cpu_process();
  804283:	e8 f5 e3 ff ff       	call   80267d <sys_get_cpu_process>
  804288:	89 45 f0             	mov    %eax,-0x10(%ebp)

//	    	acquire_spinlock(&ProcessQueues.qlock); //acquire procque
	        sys_enqueue(&(sem.semdata->queue),cur_env);  // Add process to waiting queue
  80428b:	8b 45 08             	mov    0x8(%ebp),%eax
  80428e:	83 ec 08             	sub    $0x8,%esp
  804291:	ff 75 f0             	pushl  -0x10(%ebp)
  804294:	50                   	push   %eax
  804295:	e8 21 e4 ff ff       	call   8026bb <sys_enqueue>
  80429a:	83 c4 10             	add    $0x10,%esp
	        cur_env->env_status= ENV_BLOCKED;
  80429d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042a0:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%eax)
	        sem.semdata->lock = 0;
  8042a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8042aa:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;

}
  8042b1:	eb 0a                	jmp    8042bd <wait_semaphore+0x7f>
	        cur_env->env_status= ENV_BLOCKED;
	        sem.semdata->lock = 0;
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;
  8042b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8042b6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

}
  8042bd:	90                   	nop
  8042be:	c9                   	leave  
  8042bf:	c3                   	ret    

008042c0 <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  8042c0:	55                   	push   %ebp
  8042c1:	89 e5                	mov    %esp,%ebp
  8042c3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("signal_semaphore is not implemented yet");
	//Your Code is Here...
		uint32 key = 1;
  8042c6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	    do { xchg(&sem.semdata->lock,key ); } while (key != 0);
  8042cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8042d0:	83 c0 14             	add    $0x14,%eax
  8042d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8042d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8042dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8042df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042e2:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8042e5:	f0 87 02             	lock xchg %eax,(%edx)
  8042e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8042eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042ef:	75 dc                	jne    8042cd <signal_semaphore+0xd>
	    sem.semdata->count++;
  8042f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8042f4:	8b 50 10             	mov    0x10(%eax),%edx
  8042f7:	42                   	inc    %edx
  8042f8:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count <= 0) {
  8042fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8042fe:	8b 40 10             	mov    0x10(%eax),%eax
  804301:	85 c0                	test   %eax,%eax
  804303:	7f 20                	jg     804325 <signal_semaphore+0x65>
	        struct Env* env = sys_dequeue(&(sem.semdata->queue)) ;
  804305:	8b 45 08             	mov    0x8(%ebp),%eax
  804308:	83 ec 0c             	sub    $0xc,%esp
  80430b:	50                   	push   %eax
  80430c:	e8 c8 e3 ff ff       	call   8026d9 <sys_dequeue>
  804311:	83 c4 10             	add    $0x10,%esp
  804314:	89 45 f0             	mov    %eax,-0x10(%ebp)
	        sys_sched_insert_ready(env);
  804317:	83 ec 0c             	sub    $0xc,%esp
  80431a:	ff 75 f0             	pushl  -0x10(%ebp)
  80431d:	e8 db e3 ff ff       	call   8026fd <sys_sched_insert_ready>
  804322:	83 c4 10             	add    $0x10,%esp
	    }
	    sem.semdata->lock = 0;
  804325:	8b 45 08             	mov    0x8(%ebp),%eax
  804328:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  80432f:	90                   	nop
  804330:	c9                   	leave  
  804331:	c3                   	ret    

00804332 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  804332:	55                   	push   %ebp
  804333:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  804335:	8b 45 08             	mov    0x8(%ebp),%eax
  804338:	8b 40 10             	mov    0x10(%eax),%eax
}
  80433b:	5d                   	pop    %ebp
  80433c:	c3                   	ret    
  80433d:	66 90                	xchg   %ax,%ax
  80433f:	90                   	nop

00804340 <__udivdi3>:
  804340:	55                   	push   %ebp
  804341:	57                   	push   %edi
  804342:	56                   	push   %esi
  804343:	53                   	push   %ebx
  804344:	83 ec 1c             	sub    $0x1c,%esp
  804347:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80434b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80434f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804353:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804357:	89 ca                	mov    %ecx,%edx
  804359:	89 f8                	mov    %edi,%eax
  80435b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80435f:	85 f6                	test   %esi,%esi
  804361:	75 2d                	jne    804390 <__udivdi3+0x50>
  804363:	39 cf                	cmp    %ecx,%edi
  804365:	77 65                	ja     8043cc <__udivdi3+0x8c>
  804367:	89 fd                	mov    %edi,%ebp
  804369:	85 ff                	test   %edi,%edi
  80436b:	75 0b                	jne    804378 <__udivdi3+0x38>
  80436d:	b8 01 00 00 00       	mov    $0x1,%eax
  804372:	31 d2                	xor    %edx,%edx
  804374:	f7 f7                	div    %edi
  804376:	89 c5                	mov    %eax,%ebp
  804378:	31 d2                	xor    %edx,%edx
  80437a:	89 c8                	mov    %ecx,%eax
  80437c:	f7 f5                	div    %ebp
  80437e:	89 c1                	mov    %eax,%ecx
  804380:	89 d8                	mov    %ebx,%eax
  804382:	f7 f5                	div    %ebp
  804384:	89 cf                	mov    %ecx,%edi
  804386:	89 fa                	mov    %edi,%edx
  804388:	83 c4 1c             	add    $0x1c,%esp
  80438b:	5b                   	pop    %ebx
  80438c:	5e                   	pop    %esi
  80438d:	5f                   	pop    %edi
  80438e:	5d                   	pop    %ebp
  80438f:	c3                   	ret    
  804390:	39 ce                	cmp    %ecx,%esi
  804392:	77 28                	ja     8043bc <__udivdi3+0x7c>
  804394:	0f bd fe             	bsr    %esi,%edi
  804397:	83 f7 1f             	xor    $0x1f,%edi
  80439a:	75 40                	jne    8043dc <__udivdi3+0x9c>
  80439c:	39 ce                	cmp    %ecx,%esi
  80439e:	72 0a                	jb     8043aa <__udivdi3+0x6a>
  8043a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8043a4:	0f 87 9e 00 00 00    	ja     804448 <__udivdi3+0x108>
  8043aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8043af:	89 fa                	mov    %edi,%edx
  8043b1:	83 c4 1c             	add    $0x1c,%esp
  8043b4:	5b                   	pop    %ebx
  8043b5:	5e                   	pop    %esi
  8043b6:	5f                   	pop    %edi
  8043b7:	5d                   	pop    %ebp
  8043b8:	c3                   	ret    
  8043b9:	8d 76 00             	lea    0x0(%esi),%esi
  8043bc:	31 ff                	xor    %edi,%edi
  8043be:	31 c0                	xor    %eax,%eax
  8043c0:	89 fa                	mov    %edi,%edx
  8043c2:	83 c4 1c             	add    $0x1c,%esp
  8043c5:	5b                   	pop    %ebx
  8043c6:	5e                   	pop    %esi
  8043c7:	5f                   	pop    %edi
  8043c8:	5d                   	pop    %ebp
  8043c9:	c3                   	ret    
  8043ca:	66 90                	xchg   %ax,%ax
  8043cc:	89 d8                	mov    %ebx,%eax
  8043ce:	f7 f7                	div    %edi
  8043d0:	31 ff                	xor    %edi,%edi
  8043d2:	89 fa                	mov    %edi,%edx
  8043d4:	83 c4 1c             	add    $0x1c,%esp
  8043d7:	5b                   	pop    %ebx
  8043d8:	5e                   	pop    %esi
  8043d9:	5f                   	pop    %edi
  8043da:	5d                   	pop    %ebp
  8043db:	c3                   	ret    
  8043dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8043e1:	89 eb                	mov    %ebp,%ebx
  8043e3:	29 fb                	sub    %edi,%ebx
  8043e5:	89 f9                	mov    %edi,%ecx
  8043e7:	d3 e6                	shl    %cl,%esi
  8043e9:	89 c5                	mov    %eax,%ebp
  8043eb:	88 d9                	mov    %bl,%cl
  8043ed:	d3 ed                	shr    %cl,%ebp
  8043ef:	89 e9                	mov    %ebp,%ecx
  8043f1:	09 f1                	or     %esi,%ecx
  8043f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8043f7:	89 f9                	mov    %edi,%ecx
  8043f9:	d3 e0                	shl    %cl,%eax
  8043fb:	89 c5                	mov    %eax,%ebp
  8043fd:	89 d6                	mov    %edx,%esi
  8043ff:	88 d9                	mov    %bl,%cl
  804401:	d3 ee                	shr    %cl,%esi
  804403:	89 f9                	mov    %edi,%ecx
  804405:	d3 e2                	shl    %cl,%edx
  804407:	8b 44 24 08          	mov    0x8(%esp),%eax
  80440b:	88 d9                	mov    %bl,%cl
  80440d:	d3 e8                	shr    %cl,%eax
  80440f:	09 c2                	or     %eax,%edx
  804411:	89 d0                	mov    %edx,%eax
  804413:	89 f2                	mov    %esi,%edx
  804415:	f7 74 24 0c          	divl   0xc(%esp)
  804419:	89 d6                	mov    %edx,%esi
  80441b:	89 c3                	mov    %eax,%ebx
  80441d:	f7 e5                	mul    %ebp
  80441f:	39 d6                	cmp    %edx,%esi
  804421:	72 19                	jb     80443c <__udivdi3+0xfc>
  804423:	74 0b                	je     804430 <__udivdi3+0xf0>
  804425:	89 d8                	mov    %ebx,%eax
  804427:	31 ff                	xor    %edi,%edi
  804429:	e9 58 ff ff ff       	jmp    804386 <__udivdi3+0x46>
  80442e:	66 90                	xchg   %ax,%ax
  804430:	8b 54 24 08          	mov    0x8(%esp),%edx
  804434:	89 f9                	mov    %edi,%ecx
  804436:	d3 e2                	shl    %cl,%edx
  804438:	39 c2                	cmp    %eax,%edx
  80443a:	73 e9                	jae    804425 <__udivdi3+0xe5>
  80443c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80443f:	31 ff                	xor    %edi,%edi
  804441:	e9 40 ff ff ff       	jmp    804386 <__udivdi3+0x46>
  804446:	66 90                	xchg   %ax,%ax
  804448:	31 c0                	xor    %eax,%eax
  80444a:	e9 37 ff ff ff       	jmp    804386 <__udivdi3+0x46>
  80444f:	90                   	nop

00804450 <__umoddi3>:
  804450:	55                   	push   %ebp
  804451:	57                   	push   %edi
  804452:	56                   	push   %esi
  804453:	53                   	push   %ebx
  804454:	83 ec 1c             	sub    $0x1c,%esp
  804457:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80445b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80445f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804463:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804467:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80446b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80446f:	89 f3                	mov    %esi,%ebx
  804471:	89 fa                	mov    %edi,%edx
  804473:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804477:	89 34 24             	mov    %esi,(%esp)
  80447a:	85 c0                	test   %eax,%eax
  80447c:	75 1a                	jne    804498 <__umoddi3+0x48>
  80447e:	39 f7                	cmp    %esi,%edi
  804480:	0f 86 a2 00 00 00    	jbe    804528 <__umoddi3+0xd8>
  804486:	89 c8                	mov    %ecx,%eax
  804488:	89 f2                	mov    %esi,%edx
  80448a:	f7 f7                	div    %edi
  80448c:	89 d0                	mov    %edx,%eax
  80448e:	31 d2                	xor    %edx,%edx
  804490:	83 c4 1c             	add    $0x1c,%esp
  804493:	5b                   	pop    %ebx
  804494:	5e                   	pop    %esi
  804495:	5f                   	pop    %edi
  804496:	5d                   	pop    %ebp
  804497:	c3                   	ret    
  804498:	39 f0                	cmp    %esi,%eax
  80449a:	0f 87 ac 00 00 00    	ja     80454c <__umoddi3+0xfc>
  8044a0:	0f bd e8             	bsr    %eax,%ebp
  8044a3:	83 f5 1f             	xor    $0x1f,%ebp
  8044a6:	0f 84 ac 00 00 00    	je     804558 <__umoddi3+0x108>
  8044ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8044b1:	29 ef                	sub    %ebp,%edi
  8044b3:	89 fe                	mov    %edi,%esi
  8044b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8044b9:	89 e9                	mov    %ebp,%ecx
  8044bb:	d3 e0                	shl    %cl,%eax
  8044bd:	89 d7                	mov    %edx,%edi
  8044bf:	89 f1                	mov    %esi,%ecx
  8044c1:	d3 ef                	shr    %cl,%edi
  8044c3:	09 c7                	or     %eax,%edi
  8044c5:	89 e9                	mov    %ebp,%ecx
  8044c7:	d3 e2                	shl    %cl,%edx
  8044c9:	89 14 24             	mov    %edx,(%esp)
  8044cc:	89 d8                	mov    %ebx,%eax
  8044ce:	d3 e0                	shl    %cl,%eax
  8044d0:	89 c2                	mov    %eax,%edx
  8044d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044d6:	d3 e0                	shl    %cl,%eax
  8044d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8044dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044e0:	89 f1                	mov    %esi,%ecx
  8044e2:	d3 e8                	shr    %cl,%eax
  8044e4:	09 d0                	or     %edx,%eax
  8044e6:	d3 eb                	shr    %cl,%ebx
  8044e8:	89 da                	mov    %ebx,%edx
  8044ea:	f7 f7                	div    %edi
  8044ec:	89 d3                	mov    %edx,%ebx
  8044ee:	f7 24 24             	mull   (%esp)
  8044f1:	89 c6                	mov    %eax,%esi
  8044f3:	89 d1                	mov    %edx,%ecx
  8044f5:	39 d3                	cmp    %edx,%ebx
  8044f7:	0f 82 87 00 00 00    	jb     804584 <__umoddi3+0x134>
  8044fd:	0f 84 91 00 00 00    	je     804594 <__umoddi3+0x144>
  804503:	8b 54 24 04          	mov    0x4(%esp),%edx
  804507:	29 f2                	sub    %esi,%edx
  804509:	19 cb                	sbb    %ecx,%ebx
  80450b:	89 d8                	mov    %ebx,%eax
  80450d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804511:	d3 e0                	shl    %cl,%eax
  804513:	89 e9                	mov    %ebp,%ecx
  804515:	d3 ea                	shr    %cl,%edx
  804517:	09 d0                	or     %edx,%eax
  804519:	89 e9                	mov    %ebp,%ecx
  80451b:	d3 eb                	shr    %cl,%ebx
  80451d:	89 da                	mov    %ebx,%edx
  80451f:	83 c4 1c             	add    $0x1c,%esp
  804522:	5b                   	pop    %ebx
  804523:	5e                   	pop    %esi
  804524:	5f                   	pop    %edi
  804525:	5d                   	pop    %ebp
  804526:	c3                   	ret    
  804527:	90                   	nop
  804528:	89 fd                	mov    %edi,%ebp
  80452a:	85 ff                	test   %edi,%edi
  80452c:	75 0b                	jne    804539 <__umoddi3+0xe9>
  80452e:	b8 01 00 00 00       	mov    $0x1,%eax
  804533:	31 d2                	xor    %edx,%edx
  804535:	f7 f7                	div    %edi
  804537:	89 c5                	mov    %eax,%ebp
  804539:	89 f0                	mov    %esi,%eax
  80453b:	31 d2                	xor    %edx,%edx
  80453d:	f7 f5                	div    %ebp
  80453f:	89 c8                	mov    %ecx,%eax
  804541:	f7 f5                	div    %ebp
  804543:	89 d0                	mov    %edx,%eax
  804545:	e9 44 ff ff ff       	jmp    80448e <__umoddi3+0x3e>
  80454a:	66 90                	xchg   %ax,%ax
  80454c:	89 c8                	mov    %ecx,%eax
  80454e:	89 f2                	mov    %esi,%edx
  804550:	83 c4 1c             	add    $0x1c,%esp
  804553:	5b                   	pop    %ebx
  804554:	5e                   	pop    %esi
  804555:	5f                   	pop    %edi
  804556:	5d                   	pop    %ebp
  804557:	c3                   	ret    
  804558:	3b 04 24             	cmp    (%esp),%eax
  80455b:	72 06                	jb     804563 <__umoddi3+0x113>
  80455d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804561:	77 0f                	ja     804572 <__umoddi3+0x122>
  804563:	89 f2                	mov    %esi,%edx
  804565:	29 f9                	sub    %edi,%ecx
  804567:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80456b:	89 14 24             	mov    %edx,(%esp)
  80456e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804572:	8b 44 24 04          	mov    0x4(%esp),%eax
  804576:	8b 14 24             	mov    (%esp),%edx
  804579:	83 c4 1c             	add    $0x1c,%esp
  80457c:	5b                   	pop    %ebx
  80457d:	5e                   	pop    %esi
  80457e:	5f                   	pop    %edi
  80457f:	5d                   	pop    %ebp
  804580:	c3                   	ret    
  804581:	8d 76 00             	lea    0x0(%esi),%esi
  804584:	2b 04 24             	sub    (%esp),%eax
  804587:	19 fa                	sbb    %edi,%edx
  804589:	89 d1                	mov    %edx,%ecx
  80458b:	89 c6                	mov    %eax,%esi
  80458d:	e9 71 ff ff ff       	jmp    804503 <__umoddi3+0xb3>
  804592:	66 90                	xchg   %ax,%ax
  804594:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804598:	72 ea                	jb     804584 <__umoddi3+0x134>
  80459a:	89 d9                	mov    %ebx,%ecx
  80459c:	e9 62 ff ff ff       	jmp    804503 <__umoddi3+0xb3>
