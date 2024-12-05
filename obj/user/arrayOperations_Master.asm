
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
  800049:	68 c0 43 80 00       	push   $0x8043c0
  80004e:	50                   	push   %eax
  80004f:	e8 8f 40 00 00       	call   8040e3 <create_semaphore>
  800054:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = create_semaphore("Finished", 0);
  800057:	8d 45 94             	lea    -0x6c(%ebp),%eax
  80005a:	83 ec 04             	sub    $0x4,%esp
  80005d:	6a 00                	push   $0x0
  80005f:	68 c6 43 80 00       	push   $0x8043c6
  800064:	50                   	push   %eax
  800065:	e8 79 40 00 00       	call   8040e3 <create_semaphore>
  80006a:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cons_mutex = create_semaphore("Console Mutex", 1);
  80006d:	8d 45 90             	lea    -0x70(%ebp),%eax
  800070:	83 ec 04             	sub    $0x4,%esp
  800073:	6a 01                	push   $0x1
  800075:	68 cf 43 80 00       	push   $0x8043cf
  80007a:	50                   	push   %eax
  80007b:	e8 63 40 00 00       	call   8040e3 <create_semaphore>
  800080:	83 c4 0c             	add    $0xc,%esp

	/*[2] RUN THE SLAVES PROGRAMS*/
	int numOfSlaveProgs = 3 ;
  800083:	c7 45 ec 03 00 00 00 	movl   $0x3,-0x14(%ebp)

	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  80008a:	a1 20 50 80 00       	mov    0x805020,%eax
  80008f:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800095:	a1 20 50 80 00       	mov    0x805020,%eax
  80009a:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000a0:	89 c1                	mov    %eax,%ecx
  8000a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a7:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000ad:	52                   	push   %edx
  8000ae:	51                   	push   %ecx
  8000af:	50                   	push   %eax
  8000b0:	68 dd 43 80 00       	push   $0x8043dd
  8000b5:	e8 15 22 00 00       	call   8022cf <sys_create_env>
  8000ba:	83 c4 10             	add    $0x10,%esp
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8000c5:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8000cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d0:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000d6:	89 c1                	mov    %eax,%ecx
  8000d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8000dd:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000e3:	52                   	push   %edx
  8000e4:	51                   	push   %ecx
  8000e5:	50                   	push   %eax
  8000e6:	68 e6 43 80 00       	push   $0x8043e6
  8000eb:	e8 df 21 00 00       	call   8022cf <sys_create_env>
  8000f0:	83 c4 10             	add    $0x10,%esp
  8000f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8000fb:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800101:	a1 20 50 80 00       	mov    0x805020,%eax
  800106:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80010c:	89 c1                	mov    %eax,%ecx
  80010e:	a1 20 50 80 00       	mov    0x805020,%eax
  800113:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800119:	52                   	push   %edx
  80011a:	51                   	push   %ecx
  80011b:	50                   	push   %eax
  80011c:	68 ef 43 80 00       	push   $0x8043ef
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
  800141:	68 fb 43 80 00       	push   $0x8043fb
  800146:	6a 1a                	push   $0x1a
  800148:	68 10 44 80 00       	push   $0x804410
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
  800189:	e8 89 3f 00 00       	call   804117 <wait_semaphore>
  80018e:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("\n");
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	68 2e 44 80 00       	push   $0x80442e
  800199:	e8 e1 09 00 00       	call   800b7f <cprintf>
  80019e:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	68 30 44 80 00       	push   $0x804430
  8001a9:	e8 d1 09 00 00       	call   800b7f <cprintf>
  8001ae:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 4e 44 80 00       	push   $0x80444e
  8001b9:	e8 c1 09 00 00       	call   800b7f <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8001c1:	83 ec 0c             	sub    $0xc,%esp
  8001c4:	68 30 44 80 00       	push   $0x804430
  8001c9:	e8 b1 09 00 00       	call   800b7f <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	68 2e 44 80 00       	push   $0x80442e
  8001d9:	e8 a1 09 00 00       	call   800b7f <cprintf>
  8001de:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	8d 85 72 ff ff ff    	lea    -0x8e(%ebp),%eax
  8001ea:	50                   	push   %eax
  8001eb:	68 6c 44 80 00       	push   $0x80446c
  8001f0:	e8 1e 10 00 00       	call   801213 <readline>
  8001f5:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8001f8:	83 ec 04             	sub    $0x4,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	6a 04                	push   $0x4
  8001ff:	68 8b 44 80 00       	push   $0x80448b
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
  800240:	68 93 44 80 00       	push   $0x804493
  800245:	e8 0b 1c 00 00       	call   801e55 <smalloc>
  80024a:	83 c4 10             	add    $0x10,%esp
  80024d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		cprintf("Chose the initialization method:\n") ;
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	68 98 44 80 00       	push   $0x804498
  800258:	e8 22 09 00 00       	call   800b7f <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 ba 44 80 00       	push   $0x8044ba
  800268:	e8 12 09 00 00       	call   800b7f <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 c8 44 80 00       	push   $0x8044c8
  800278:	e8 02 09 00 00       	call   800b7f <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	68 d7 44 80 00       	push   $0x8044d7
  800288:	e8 f2 08 00 00       	call   800b7f <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 e7 44 80 00       	push   $0x8044e7
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
  8002dd:	e8 4f 3e 00 00       	call   804131 <signal_semaphore>
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
  800351:	e8 db 3d 00 00       	call   804131 <signal_semaphore>
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
  800373:	e8 9f 3d 00 00       	call   804117 <wait_semaphore>
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
  8003ba:	68 f0 44 80 00       	push   $0x8044f0
  8003bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8003c2:	e8 33 1b 00 00       	call   801efa <sget>
  8003c7:	83 c4 10             	add    $0x10,%esp
  8003ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  8003cd:	83 ec 08             	sub    $0x8,%esp
  8003d0:	68 ff 44 80 00       	push   $0x8044ff
  8003d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003d8:	e8 1d 1b 00 00       	call   801efa <sget>
  8003dd:	83 c4 10             	add    $0x10,%esp
  8003e0:	89 45 c8             	mov    %eax,-0x38(%ebp)
	mean = sget(envIdStats, "mean") ;
  8003e3:	83 ec 08             	sub    $0x8,%esp
  8003e6:	68 0e 45 80 00       	push   $0x80450e
  8003eb:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ee:	e8 07 1b 00 00       	call   801efa <sget>
  8003f3:	83 c4 10             	add    $0x10,%esp
  8003f6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	var = sget(envIdStats,"var") ;
  8003f9:	83 ec 08             	sub    $0x8,%esp
  8003fc:	68 13 45 80 00       	push   $0x804513
  800401:	ff 75 e0             	pushl  -0x20(%ebp)
  800404:	e8 f1 1a 00 00       	call   801efa <sget>
  800409:	83 c4 10             	add    $0x10,%esp
  80040c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	min = sget(envIdStats,"min") ;
  80040f:	83 ec 08             	sub    $0x8,%esp
  800412:	68 17 45 80 00       	push   $0x804517
  800417:	ff 75 e0             	pushl  -0x20(%ebp)
  80041a:	e8 db 1a 00 00       	call   801efa <sget>
  80041f:	83 c4 10             	add    $0x10,%esp
  800422:	89 45 bc             	mov    %eax,-0x44(%ebp)
	max = sget(envIdStats,"max") ;
  800425:	83 ec 08             	sub    $0x8,%esp
  800428:	68 1b 45 80 00       	push   $0x80451b
  80042d:	ff 75 e0             	pushl  -0x20(%ebp)
  800430:	e8 c5 1a 00 00       	call   801efa <sget>
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	89 45 b8             	mov    %eax,-0x48(%ebp)
	med = sget(envIdStats,"med") ;
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	68 1f 45 80 00       	push   $0x80451f
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
  80046e:	68 24 45 80 00       	push   $0x804524
  800473:	6a 73                	push   $0x73
  800475:	68 10 44 80 00       	push   $0x804410
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
  80049c:	68 4c 45 80 00       	push   $0x80454c
  8004a1:	6a 75                	push   $0x75
  8004a3:	68 10 44 80 00       	push   $0x804410
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
  80054f:	68 74 45 80 00       	push   $0x804574
  800554:	68 82 00 00 00       	push   $0x82
  800559:	68 10 44 80 00       	push   $0x804410
  80055e:	e8 5f 03 00 00       	call   8008c2 <_panic>

	cprintf("Congratulations!! Scenario of Using the Semaphores & Shared Variables completed successfully!!\n\n\n");
  800563:	83 ec 0c             	sub    $0xc,%esp
  800566:	68 a4 45 80 00       	push   $0x8045a4
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
  8007b8:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007bd:	a1 20 50 80 00       	mov    0x805020,%eax
  8007c2:	8a 40 20             	mov    0x20(%eax),%al
  8007c5:	84 c0                	test   %al,%al
  8007c7:	74 0d                	je     8007d6 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8007c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8007ce:	83 c0 20             	add    $0x20,%eax
  8007d1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007da:	7e 0a                	jle    8007e6 <libmain+0x63>
		binaryname = argv[0];
  8007dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	a3 00 50 80 00       	mov    %eax,0x805000

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
  8007ff:	68 20 46 80 00       	push   $0x804620
  800804:	e8 76 03 00 00       	call   800b7f <cprintf>
  800809:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80080c:	a1 20 50 80 00       	mov    0x805020,%eax
  800811:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800817:	a1 20 50 80 00       	mov    0x805020,%eax
  80081c:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	52                   	push   %edx
  800826:	50                   	push   %eax
  800827:	68 48 46 80 00       	push   $0x804648
  80082c:	e8 4e 03 00 00       	call   800b7f <cprintf>
  800831:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800834:	a1 20 50 80 00       	mov    0x805020,%eax
  800839:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80083f:	a1 20 50 80 00       	mov    0x805020,%eax
  800844:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80084a:	a1 20 50 80 00       	mov    0x805020,%eax
  80084f:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800855:	51                   	push   %ecx
  800856:	52                   	push   %edx
  800857:	50                   	push   %eax
  800858:	68 70 46 80 00       	push   $0x804670
  80085d:	e8 1d 03 00 00       	call   800b7f <cprintf>
  800862:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800865:	a1 20 50 80 00       	mov    0x805020,%eax
  80086a:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	50                   	push   %eax
  800874:	68 c8 46 80 00       	push   $0x8046c8
  800879:	e8 01 03 00 00       	call   800b7f <cprintf>
  80087e:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800881:	83 ec 0c             	sub    $0xc,%esp
  800884:	68 20 46 80 00       	push   $0x804620
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
  8008d1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8008d6:	85 c0                	test   %eax,%eax
  8008d8:	74 16                	je     8008f0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008da:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8008df:	83 ec 08             	sub    $0x8,%esp
  8008e2:	50                   	push   %eax
  8008e3:	68 dc 46 80 00       	push   $0x8046dc
  8008e8:	e8 92 02 00 00       	call   800b7f <cprintf>
  8008ed:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008f0:	a1 00 50 80 00       	mov    0x805000,%eax
  8008f5:	ff 75 0c             	pushl  0xc(%ebp)
  8008f8:	ff 75 08             	pushl  0x8(%ebp)
  8008fb:	50                   	push   %eax
  8008fc:	68 e1 46 80 00       	push   $0x8046e1
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
  800920:	68 fd 46 80 00       	push   $0x8046fd
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
  80093a:	a1 20 50 80 00       	mov    0x805020,%eax
  80093f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800945:	8b 45 0c             	mov    0xc(%ebp),%eax
  800948:	39 c2                	cmp    %eax,%edx
  80094a:	74 14                	je     800960 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80094c:	83 ec 04             	sub    $0x4,%esp
  80094f:	68 00 47 80 00       	push   $0x804700
  800954:	6a 26                	push   $0x26
  800956:	68 4c 47 80 00       	push   $0x80474c
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
  8009a0:	a1 20 50 80 00       	mov    0x805020,%eax
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
  8009c0:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800a09:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800a24:	68 58 47 80 00       	push   $0x804758
  800a29:	6a 3a                	push   $0x3a
  800a2b:	68 4c 47 80 00       	push   $0x80474c
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
  800a54:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800a7a:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800a97:	68 ac 47 80 00       	push   $0x8047ac
  800a9c:	6a 44                	push   $0x44
  800a9e:	68 4c 47 80 00       	push   $0x80474c
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
  800ad6:	a0 28 50 80 00       	mov    0x805028,%al
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
  800b4b:	a0 28 50 80 00       	mov    0x805028,%al
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
  800b70:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
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
  800b85:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  800c1c:	e8 37 35 00 00       	call   804158 <__udivdi3>
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
  800c6c:	e8 f7 35 00 00       	call   804268 <__umoddi3>
  800c71:	83 c4 10             	add    $0x10,%esp
  800c74:	05 14 4a 80 00       	add    $0x804a14,%eax
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
  800dc7:	8b 04 85 38 4a 80 00 	mov    0x804a38(,%eax,4),%eax
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
  800ea8:	8b 34 9d 80 48 80 00 	mov    0x804880(,%ebx,4),%esi
  800eaf:	85 f6                	test   %esi,%esi
  800eb1:	75 19                	jne    800ecc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800eb3:	53                   	push   %ebx
  800eb4:	68 25 4a 80 00       	push   $0x804a25
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
  800ecd:	68 2e 4a 80 00       	push   $0x804a2e
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
  800efa:	be 31 4a 80 00       	mov    $0x804a31,%esi
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
  8010f2:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  8010f9:	eb 2c                	jmp    801127 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010fb:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  801225:	68 a8 4b 80 00       	push   $0x804ba8
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
  801267:	68 ab 4b 80 00       	push   $0x804bab
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
  801329:	68 a8 4b 80 00       	push   $0x804ba8
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
  80136b:	68 ab 4b 80 00       	push   $0x804bab
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
  801b0d:	68 bc 4b 80 00       	push   $0x804bbc
  801b12:	68 3f 01 00 00       	push   $0x13f
  801b17:	68 de 4b 80 00       	push   $0x804bde
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
  801b76:	a1 20 50 80 00       	mov    0x805020,%eax
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
  801bb7:	e8 41 0e 00 00       	call   8029fd <alloc_block_FF>
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
  801bda:	e8 da 12 00 00       	call   802eb9 <alloc_block_BF>
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
  801bf7:	a1 20 50 80 00       	mov    0x805020,%eax
  801bfc:	8b 40 78             	mov    0x78(%eax),%eax
  801bff:	05 00 10 00 00       	add    $0x1000,%eax
  801c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801c07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801c0e:	e9 de 00 00 00       	jmp    801cf1 <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801c13:	a1 20 50 80 00       	mov    0x805020,%eax
  801c18:	8b 40 78             	mov    0x78(%eax),%eax
  801c1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c1e:	29 c2                	sub    %eax,%edx
  801c20:	89 d0                	mov    %edx,%eax
  801c22:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c27:	c1 e8 0c             	shr    $0xc,%eax
  801c2a:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801c60:	a1 20 50 80 00       	mov    0x805020,%eax
  801c65:	8b 40 78             	mov    0x78(%eax),%eax
  801c68:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c6b:	29 c2                	sub    %eax,%edx
  801c6d:	89 d0                	mov    %edx,%eax
  801c6f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c74:	c1 e8 0c             	shr    $0xc,%eax
  801c77:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801cba:	a1 20 50 80 00       	mov    0x805020,%eax
  801cbf:	8b 40 78             	mov    0x78(%eax),%eax
  801cc2:	29 c2                	sub    %eax,%edx
  801cc4:	89 d0                	mov    %edx,%eax
  801cc6:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ccb:	c1 e8 0c             	shr    $0xc,%eax
  801cce:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
  801d14:	a1 20 50 80 00       	mov    0x805020,%eax
  801d19:	8b 40 78             	mov    0x78(%eax),%eax
  801d1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d1f:	29 c2                	sub    %eax,%edx
  801d21:	89 d0                	mov    %edx,%eax
  801d23:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d28:	c1 e8 0c             	shr    $0xc,%eax
  801d2b:	89 c2                	mov    %eax,%edx
  801d2d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d30:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
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
  801d5c:	a1 20 50 80 00       	mov    0x805020,%eax
  801d61:	8b 40 78             	mov    0x78(%eax),%eax
  801d64:	05 00 10 00 00       	add    $0x1000,%eax
  801d69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801d6c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801d73:	a1 20 50 80 00       	mov    0x805020,%eax
  801d78:	8b 50 78             	mov    0x78(%eax),%edx
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	39 c2                	cmp    %eax,%edx
  801d80:	76 24                	jbe    801da6 <free+0x50>
		size = get_block_size(va);
  801d82:	83 ec 0c             	sub    $0xc,%esp
  801d85:	ff 75 08             	pushl  0x8(%ebp)
  801d88:	e8 f0 08 00 00       	call   80267d <get_block_size>
  801d8d:	83 c4 10             	add    $0x10,%esp
  801d90:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d93:	83 ec 0c             	sub    $0xc,%esp
  801d96:	ff 75 08             	pushl  0x8(%ebp)
  801d99:	e8 00 1b 00 00       	call   80389e <free_block>
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
  801dbf:	a1 20 50 80 00       	mov    0x805020,%eax
  801dc4:	8b 40 78             	mov    0x78(%eax),%eax
  801dc7:	29 c2                	sub    %eax,%edx
  801dc9:	89 d0                	mov    %edx,%eax
  801dcb:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dd0:	c1 e8 0c             	shr    $0xc,%eax
  801dd3:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  801dfc:	a1 20 50 80 00       	mov    0x805020,%eax
  801e01:	8b 40 78             	mov    0x78(%eax),%eax
  801e04:	29 c2                	sub    %eax,%edx
  801e06:	89 d0                	mov    %edx,%eax
  801e08:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e0d:	c1 e8 0c             	shr    $0xc,%eax
  801e10:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  801e3e:	68 ec 4b 80 00       	push   $0x804bec
  801e43:	68 87 00 00 00       	push   $0x87
  801e48:	68 16 4c 80 00       	push   $0x804c16
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
  801ed5:	a1 20 50 80 00       	mov    0x805020,%eax
  801eda:	8b 40 78             	mov    0x78(%eax),%eax
  801edd:	29 c2                	sub    %eax,%edx
  801edf:	89 d0                	mov    %edx,%eax
  801ee1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ee6:	c1 e8 0c             	shr    $0xc,%eax
  801ee9:	89 c2                	mov    %eax,%edx
  801eeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801eee:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
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
  801f70:	a1 20 50 80 00       	mov    0x805020,%eax
  801f75:	8b 40 78             	mov    0x78(%eax),%eax
  801f78:	29 c2                	sub    %eax,%edx
  801f7a:	89 d0                	mov    %edx,%eax
  801f7c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f81:	c1 e8 0c             	shr    $0xc,%eax
  801f84:	89 c2                	mov    %eax,%edx
  801f86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f89:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
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
  801fab:	a1 20 50 80 00       	mov    0x805020,%eax
  801fb0:	8b 40 78             	mov    0x78(%eax),%eax
  801fb3:	29 c2                	sub    %eax,%edx
  801fb5:	89 d0                	mov    %edx,%eax
  801fb7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fbc:	c1 e8 0c             	shr    $0xc,%eax
  801fbf:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801fe9:	68 24 4c 80 00       	push   $0x804c24
  801fee:	68 e4 00 00 00       	push   $0xe4
  801ff3:	68 16 4c 80 00       	push   $0x804c16
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
  802006:	68 4a 4c 80 00       	push   $0x804c4a
  80200b:	68 f0 00 00 00       	push   $0xf0
  802010:	68 16 4c 80 00       	push   $0x804c16
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
  802023:	68 4a 4c 80 00       	push   $0x804c4a
  802028:	68 f5 00 00 00       	push   $0xf5
  80202d:	68 16 4c 80 00       	push   $0x804c16
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
  802040:	68 4a 4c 80 00       	push   $0x804c4a
  802045:	68 fa 00 00 00       	push   $0xfa
  80204a:	68 16 4c 80 00       	push   $0x804c16
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

0080267d <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
  802680:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	83 e8 04             	sub    $0x4,%eax
  802689:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80268c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802694:	c9                   	leave  
  802695:	c3                   	ret    

00802696 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802696:	55                   	push   %ebp
  802697:	89 e5                	mov    %esp,%ebp
  802699:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80269c:	8b 45 08             	mov    0x8(%ebp),%eax
  80269f:	83 e8 04             	sub    $0x4,%eax
  8026a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8026a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026a8:	8b 00                	mov    (%eax),%eax
  8026aa:	83 e0 01             	and    $0x1,%eax
  8026ad:	85 c0                	test   %eax,%eax
  8026af:	0f 94 c0             	sete   %al
}
  8026b2:	c9                   	leave  
  8026b3:	c3                   	ret    

008026b4 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8026b4:	55                   	push   %ebp
  8026b5:	89 e5                	mov    %esp,%ebp
  8026b7:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8026ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8026c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c4:	83 f8 02             	cmp    $0x2,%eax
  8026c7:	74 2b                	je     8026f4 <alloc_block+0x40>
  8026c9:	83 f8 02             	cmp    $0x2,%eax
  8026cc:	7f 07                	jg     8026d5 <alloc_block+0x21>
  8026ce:	83 f8 01             	cmp    $0x1,%eax
  8026d1:	74 0e                	je     8026e1 <alloc_block+0x2d>
  8026d3:	eb 58                	jmp    80272d <alloc_block+0x79>
  8026d5:	83 f8 03             	cmp    $0x3,%eax
  8026d8:	74 2d                	je     802707 <alloc_block+0x53>
  8026da:	83 f8 04             	cmp    $0x4,%eax
  8026dd:	74 3b                	je     80271a <alloc_block+0x66>
  8026df:	eb 4c                	jmp    80272d <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8026e1:	83 ec 0c             	sub    $0xc,%esp
  8026e4:	ff 75 08             	pushl  0x8(%ebp)
  8026e7:	e8 11 03 00 00       	call   8029fd <alloc_block_FF>
  8026ec:	83 c4 10             	add    $0x10,%esp
  8026ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026f2:	eb 4a                	jmp    80273e <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8026f4:	83 ec 0c             	sub    $0xc,%esp
  8026f7:	ff 75 08             	pushl  0x8(%ebp)
  8026fa:	e8 c7 19 00 00       	call   8040c6 <alloc_block_NF>
  8026ff:	83 c4 10             	add    $0x10,%esp
  802702:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802705:	eb 37                	jmp    80273e <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802707:	83 ec 0c             	sub    $0xc,%esp
  80270a:	ff 75 08             	pushl  0x8(%ebp)
  80270d:	e8 a7 07 00 00       	call   802eb9 <alloc_block_BF>
  802712:	83 c4 10             	add    $0x10,%esp
  802715:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802718:	eb 24                	jmp    80273e <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80271a:	83 ec 0c             	sub    $0xc,%esp
  80271d:	ff 75 08             	pushl  0x8(%ebp)
  802720:	e8 84 19 00 00       	call   8040a9 <alloc_block_WF>
  802725:	83 c4 10             	add    $0x10,%esp
  802728:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80272b:	eb 11                	jmp    80273e <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80272d:	83 ec 0c             	sub    $0xc,%esp
  802730:	68 5c 4c 80 00       	push   $0x804c5c
  802735:	e8 45 e4 ff ff       	call   800b7f <cprintf>
  80273a:	83 c4 10             	add    $0x10,%esp
		break;
  80273d:	90                   	nop
	}
	return va;
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802741:	c9                   	leave  
  802742:	c3                   	ret    

00802743 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802743:	55                   	push   %ebp
  802744:	89 e5                	mov    %esp,%ebp
  802746:	53                   	push   %ebx
  802747:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80274a:	83 ec 0c             	sub    $0xc,%esp
  80274d:	68 7c 4c 80 00       	push   $0x804c7c
  802752:	e8 28 e4 ff ff       	call   800b7f <cprintf>
  802757:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80275a:	83 ec 0c             	sub    $0xc,%esp
  80275d:	68 a7 4c 80 00       	push   $0x804ca7
  802762:	e8 18 e4 ff ff       	call   800b7f <cprintf>
  802767:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80276a:	8b 45 08             	mov    0x8(%ebp),%eax
  80276d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802770:	eb 37                	jmp    8027a9 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802772:	83 ec 0c             	sub    $0xc,%esp
  802775:	ff 75 f4             	pushl  -0xc(%ebp)
  802778:	e8 19 ff ff ff       	call   802696 <is_free_block>
  80277d:	83 c4 10             	add    $0x10,%esp
  802780:	0f be d8             	movsbl %al,%ebx
  802783:	83 ec 0c             	sub    $0xc,%esp
  802786:	ff 75 f4             	pushl  -0xc(%ebp)
  802789:	e8 ef fe ff ff       	call   80267d <get_block_size>
  80278e:	83 c4 10             	add    $0x10,%esp
  802791:	83 ec 04             	sub    $0x4,%esp
  802794:	53                   	push   %ebx
  802795:	50                   	push   %eax
  802796:	68 bf 4c 80 00       	push   $0x804cbf
  80279b:	e8 df e3 ff ff       	call   800b7f <cprintf>
  8027a0:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8027a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8027a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ad:	74 07                	je     8027b6 <print_blocks_list+0x73>
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 00                	mov    (%eax),%eax
  8027b4:	eb 05                	jmp    8027bb <print_blocks_list+0x78>
  8027b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bb:	89 45 10             	mov    %eax,0x10(%ebp)
  8027be:	8b 45 10             	mov    0x10(%ebp),%eax
  8027c1:	85 c0                	test   %eax,%eax
  8027c3:	75 ad                	jne    802772 <print_blocks_list+0x2f>
  8027c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c9:	75 a7                	jne    802772 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8027cb:	83 ec 0c             	sub    $0xc,%esp
  8027ce:	68 7c 4c 80 00       	push   $0x804c7c
  8027d3:	e8 a7 e3 ff ff       	call   800b7f <cprintf>
  8027d8:	83 c4 10             	add    $0x10,%esp

}
  8027db:	90                   	nop
  8027dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027df:	c9                   	leave  
  8027e0:	c3                   	ret    

008027e1 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8027e1:	55                   	push   %ebp
  8027e2:	89 e5                	mov    %esp,%ebp
  8027e4:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8027e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ea:	83 e0 01             	and    $0x1,%eax
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	74 03                	je     8027f4 <initialize_dynamic_allocator+0x13>
  8027f1:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8027f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027f8:	0f 84 c7 01 00 00    	je     8029c5 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8027fe:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802805:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802808:	8b 55 08             	mov    0x8(%ebp),%edx
  80280b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80280e:	01 d0                	add    %edx,%eax
  802810:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802815:	0f 87 ad 01 00 00    	ja     8029c8 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80281b:	8b 45 08             	mov    0x8(%ebp),%eax
  80281e:	85 c0                	test   %eax,%eax
  802820:	0f 89 a5 01 00 00    	jns    8029cb <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802826:	8b 55 08             	mov    0x8(%ebp),%edx
  802829:	8b 45 0c             	mov    0xc(%ebp),%eax
  80282c:	01 d0                	add    %edx,%eax
  80282e:	83 e8 04             	sub    $0x4,%eax
  802831:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80283d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802842:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802845:	e9 87 00 00 00       	jmp    8028d1 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80284a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284e:	75 14                	jne    802864 <initialize_dynamic_allocator+0x83>
  802850:	83 ec 04             	sub    $0x4,%esp
  802853:	68 d7 4c 80 00       	push   $0x804cd7
  802858:	6a 79                	push   $0x79
  80285a:	68 f5 4c 80 00       	push   $0x804cf5
  80285f:	e8 5e e0 ff ff       	call   8008c2 <_panic>
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	8b 00                	mov    (%eax),%eax
  802869:	85 c0                	test   %eax,%eax
  80286b:	74 10                	je     80287d <initialize_dynamic_allocator+0x9c>
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	8b 00                	mov    (%eax),%eax
  802872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802875:	8b 52 04             	mov    0x4(%edx),%edx
  802878:	89 50 04             	mov    %edx,0x4(%eax)
  80287b:	eb 0b                	jmp    802888 <initialize_dynamic_allocator+0xa7>
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 40 04             	mov    0x4(%eax),%eax
  802883:	a3 30 50 80 00       	mov    %eax,0x805030
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 40 04             	mov    0x4(%eax),%eax
  80288e:	85 c0                	test   %eax,%eax
  802890:	74 0f                	je     8028a1 <initialize_dynamic_allocator+0xc0>
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 40 04             	mov    0x4(%eax),%eax
  802898:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289b:	8b 12                	mov    (%edx),%edx
  80289d:	89 10                	mov    %edx,(%eax)
  80289f:	eb 0a                	jmp    8028ab <initialize_dynamic_allocator+0xca>
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	8b 00                	mov    (%eax),%eax
  8028a6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028be:	a1 38 50 80 00       	mov    0x805038,%eax
  8028c3:	48                   	dec    %eax
  8028c4:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8028c9:	a1 34 50 80 00       	mov    0x805034,%eax
  8028ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d5:	74 07                	je     8028de <initialize_dynamic_allocator+0xfd>
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	8b 00                	mov    (%eax),%eax
  8028dc:	eb 05                	jmp    8028e3 <initialize_dynamic_allocator+0x102>
  8028de:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e3:	a3 34 50 80 00       	mov    %eax,0x805034
  8028e8:	a1 34 50 80 00       	mov    0x805034,%eax
  8028ed:	85 c0                	test   %eax,%eax
  8028ef:	0f 85 55 ff ff ff    	jne    80284a <initialize_dynamic_allocator+0x69>
  8028f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f9:	0f 85 4b ff ff ff    	jne    80284a <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802902:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802908:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80290e:	a1 44 50 80 00       	mov    0x805044,%eax
  802913:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802918:	a1 40 50 80 00       	mov    0x805040,%eax
  80291d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802923:	8b 45 08             	mov    0x8(%ebp),%eax
  802926:	83 c0 08             	add    $0x8,%eax
  802929:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	83 c0 04             	add    $0x4,%eax
  802932:	8b 55 0c             	mov    0xc(%ebp),%edx
  802935:	83 ea 08             	sub    $0x8,%edx
  802938:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80293a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80293d:	8b 45 08             	mov    0x8(%ebp),%eax
  802940:	01 d0                	add    %edx,%eax
  802942:	83 e8 08             	sub    $0x8,%eax
  802945:	8b 55 0c             	mov    0xc(%ebp),%edx
  802948:	83 ea 08             	sub    $0x8,%edx
  80294b:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80294d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802950:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802956:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802959:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802960:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802964:	75 17                	jne    80297d <initialize_dynamic_allocator+0x19c>
  802966:	83 ec 04             	sub    $0x4,%esp
  802969:	68 10 4d 80 00       	push   $0x804d10
  80296e:	68 90 00 00 00       	push   $0x90
  802973:	68 f5 4c 80 00       	push   $0x804cf5
  802978:	e8 45 df ff ff       	call   8008c2 <_panic>
  80297d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802983:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802986:	89 10                	mov    %edx,(%eax)
  802988:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	85 c0                	test   %eax,%eax
  80298f:	74 0d                	je     80299e <initialize_dynamic_allocator+0x1bd>
  802991:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802996:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802999:	89 50 04             	mov    %edx,0x4(%eax)
  80299c:	eb 08                	jmp    8029a6 <initialize_dynamic_allocator+0x1c5>
  80299e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8029a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b8:	a1 38 50 80 00       	mov    0x805038,%eax
  8029bd:	40                   	inc    %eax
  8029be:	a3 38 50 80 00       	mov    %eax,0x805038
  8029c3:	eb 07                	jmp    8029cc <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8029c5:	90                   	nop
  8029c6:	eb 04                	jmp    8029cc <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8029c8:	90                   	nop
  8029c9:	eb 01                	jmp    8029cc <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8029cb:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8029cc:	c9                   	leave  
  8029cd:	c3                   	ret    

008029ce <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8029ce:	55                   	push   %ebp
  8029cf:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8029d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8029d4:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	8d 50 fc             	lea    -0x4(%eax),%edx
  8029dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029e0:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	83 e8 04             	sub    $0x4,%eax
  8029e8:	8b 00                	mov    (%eax),%eax
  8029ea:	83 e0 fe             	and    $0xfffffffe,%eax
  8029ed:	8d 50 f8             	lea    -0x8(%eax),%edx
  8029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f3:	01 c2                	add    %eax,%edx
  8029f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029f8:	89 02                	mov    %eax,(%edx)
}
  8029fa:	90                   	nop
  8029fb:	5d                   	pop    %ebp
  8029fc:	c3                   	ret    

008029fd <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8029fd:	55                   	push   %ebp
  8029fe:	89 e5                	mov    %esp,%ebp
  802a00:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a03:	8b 45 08             	mov    0x8(%ebp),%eax
  802a06:	83 e0 01             	and    $0x1,%eax
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	74 03                	je     802a10 <alloc_block_FF+0x13>
  802a0d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802a10:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802a14:	77 07                	ja     802a1d <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802a16:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802a1d:	a1 24 50 80 00       	mov    0x805024,%eax
  802a22:	85 c0                	test   %eax,%eax
  802a24:	75 73                	jne    802a99 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	83 c0 10             	add    $0x10,%eax
  802a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a2f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3c:	01 d0                	add    %edx,%eax
  802a3e:	48                   	dec    %eax
  802a3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a45:	ba 00 00 00 00       	mov    $0x0,%edx
  802a4a:	f7 75 ec             	divl   -0x14(%ebp)
  802a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a50:	29 d0                	sub    %edx,%eax
  802a52:	c1 e8 0c             	shr    $0xc,%eax
  802a55:	83 ec 0c             	sub    $0xc,%esp
  802a58:	50                   	push   %eax
  802a59:	e8 c3 f0 ff ff       	call   801b21 <sbrk>
  802a5e:	83 c4 10             	add    $0x10,%esp
  802a61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a64:	83 ec 0c             	sub    $0xc,%esp
  802a67:	6a 00                	push   $0x0
  802a69:	e8 b3 f0 ff ff       	call   801b21 <sbrk>
  802a6e:	83 c4 10             	add    $0x10,%esp
  802a71:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a77:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802a7a:	83 ec 08             	sub    $0x8,%esp
  802a7d:	50                   	push   %eax
  802a7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802a81:	e8 5b fd ff ff       	call   8027e1 <initialize_dynamic_allocator>
  802a86:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802a89:	83 ec 0c             	sub    $0xc,%esp
  802a8c:	68 33 4d 80 00       	push   $0x804d33
  802a91:	e8 e9 e0 ff ff       	call   800b7f <cprintf>
  802a96:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802a99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a9d:	75 0a                	jne    802aa9 <alloc_block_FF+0xac>
	        return NULL;
  802a9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa4:	e9 0e 04 00 00       	jmp    802eb7 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802aa9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802ab0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ab5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab8:	e9 f3 02 00 00       	jmp    802db0 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802ac3:	83 ec 0c             	sub    $0xc,%esp
  802ac6:	ff 75 bc             	pushl  -0x44(%ebp)
  802ac9:	e8 af fb ff ff       	call   80267d <get_block_size>
  802ace:	83 c4 10             	add    $0x10,%esp
  802ad1:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad7:	83 c0 08             	add    $0x8,%eax
  802ada:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802add:	0f 87 c5 02 00 00    	ja     802da8 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	83 c0 18             	add    $0x18,%eax
  802ae9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802aec:	0f 87 19 02 00 00    	ja     802d0b <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802af2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802af5:	2b 45 08             	sub    0x8(%ebp),%eax
  802af8:	83 e8 08             	sub    $0x8,%eax
  802afb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802afe:	8b 45 08             	mov    0x8(%ebp),%eax
  802b01:	8d 50 08             	lea    0x8(%eax),%edx
  802b04:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b07:	01 d0                	add    %edx,%eax
  802b09:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0f:	83 c0 08             	add    $0x8,%eax
  802b12:	83 ec 04             	sub    $0x4,%esp
  802b15:	6a 01                	push   $0x1
  802b17:	50                   	push   %eax
  802b18:	ff 75 bc             	pushl  -0x44(%ebp)
  802b1b:	e8 ae fe ff ff       	call   8029ce <set_block_data>
  802b20:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 40 04             	mov    0x4(%eax),%eax
  802b29:	85 c0                	test   %eax,%eax
  802b2b:	75 68                	jne    802b95 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b2d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b31:	75 17                	jne    802b4a <alloc_block_FF+0x14d>
  802b33:	83 ec 04             	sub    $0x4,%esp
  802b36:	68 10 4d 80 00       	push   $0x804d10
  802b3b:	68 d7 00 00 00       	push   $0xd7
  802b40:	68 f5 4c 80 00       	push   $0x804cf5
  802b45:	e8 78 dd ff ff       	call   8008c2 <_panic>
  802b4a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802b50:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b53:	89 10                	mov    %edx,(%eax)
  802b55:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b58:	8b 00                	mov    (%eax),%eax
  802b5a:	85 c0                	test   %eax,%eax
  802b5c:	74 0d                	je     802b6b <alloc_block_FF+0x16e>
  802b5e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b63:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b66:	89 50 04             	mov    %edx,0x4(%eax)
  802b69:	eb 08                	jmp    802b73 <alloc_block_FF+0x176>
  802b6b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b6e:	a3 30 50 80 00       	mov    %eax,0x805030
  802b73:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b76:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b7b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b85:	a1 38 50 80 00       	mov    0x805038,%eax
  802b8a:	40                   	inc    %eax
  802b8b:	a3 38 50 80 00       	mov    %eax,0x805038
  802b90:	e9 dc 00 00 00       	jmp    802c71 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 00                	mov    (%eax),%eax
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	75 65                	jne    802c03 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b9e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ba2:	75 17                	jne    802bbb <alloc_block_FF+0x1be>
  802ba4:	83 ec 04             	sub    $0x4,%esp
  802ba7:	68 44 4d 80 00       	push   $0x804d44
  802bac:	68 db 00 00 00       	push   $0xdb
  802bb1:	68 f5 4c 80 00       	push   $0x804cf5
  802bb6:	e8 07 dd ff ff       	call   8008c2 <_panic>
  802bbb:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802bc1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bc4:	89 50 04             	mov    %edx,0x4(%eax)
  802bc7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bca:	8b 40 04             	mov    0x4(%eax),%eax
  802bcd:	85 c0                	test   %eax,%eax
  802bcf:	74 0c                	je     802bdd <alloc_block_FF+0x1e0>
  802bd1:	a1 30 50 80 00       	mov    0x805030,%eax
  802bd6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bd9:	89 10                	mov    %edx,(%eax)
  802bdb:	eb 08                	jmp    802be5 <alloc_block_FF+0x1e8>
  802bdd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802be0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802be5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802be8:	a3 30 50 80 00       	mov    %eax,0x805030
  802bed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf6:	a1 38 50 80 00       	mov    0x805038,%eax
  802bfb:	40                   	inc    %eax
  802bfc:	a3 38 50 80 00       	mov    %eax,0x805038
  802c01:	eb 6e                	jmp    802c71 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802c03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c07:	74 06                	je     802c0f <alloc_block_FF+0x212>
  802c09:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c0d:	75 17                	jne    802c26 <alloc_block_FF+0x229>
  802c0f:	83 ec 04             	sub    $0x4,%esp
  802c12:	68 68 4d 80 00       	push   $0x804d68
  802c17:	68 df 00 00 00       	push   $0xdf
  802c1c:	68 f5 4c 80 00       	push   $0x804cf5
  802c21:	e8 9c dc ff ff       	call   8008c2 <_panic>
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	8b 10                	mov    (%eax),%edx
  802c2b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c2e:	89 10                	mov    %edx,(%eax)
  802c30:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c33:	8b 00                	mov    (%eax),%eax
  802c35:	85 c0                	test   %eax,%eax
  802c37:	74 0b                	je     802c44 <alloc_block_FF+0x247>
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	8b 00                	mov    (%eax),%eax
  802c3e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c41:	89 50 04             	mov    %edx,0x4(%eax)
  802c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c47:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c4a:	89 10                	mov    %edx,(%eax)
  802c4c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c52:	89 50 04             	mov    %edx,0x4(%eax)
  802c55:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c58:	8b 00                	mov    (%eax),%eax
  802c5a:	85 c0                	test   %eax,%eax
  802c5c:	75 08                	jne    802c66 <alloc_block_FF+0x269>
  802c5e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c61:	a3 30 50 80 00       	mov    %eax,0x805030
  802c66:	a1 38 50 80 00       	mov    0x805038,%eax
  802c6b:	40                   	inc    %eax
  802c6c:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802c71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c75:	75 17                	jne    802c8e <alloc_block_FF+0x291>
  802c77:	83 ec 04             	sub    $0x4,%esp
  802c7a:	68 d7 4c 80 00       	push   $0x804cd7
  802c7f:	68 e1 00 00 00       	push   $0xe1
  802c84:	68 f5 4c 80 00       	push   $0x804cf5
  802c89:	e8 34 dc ff ff       	call   8008c2 <_panic>
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	8b 00                	mov    (%eax),%eax
  802c93:	85 c0                	test   %eax,%eax
  802c95:	74 10                	je     802ca7 <alloc_block_FF+0x2aa>
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c9f:	8b 52 04             	mov    0x4(%edx),%edx
  802ca2:	89 50 04             	mov    %edx,0x4(%eax)
  802ca5:	eb 0b                	jmp    802cb2 <alloc_block_FF+0x2b5>
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	8b 40 04             	mov    0x4(%eax),%eax
  802cad:	a3 30 50 80 00       	mov    %eax,0x805030
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 40 04             	mov    0x4(%eax),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	74 0f                	je     802ccb <alloc_block_FF+0x2ce>
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 40 04             	mov    0x4(%eax),%eax
  802cc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc5:	8b 12                	mov    (%edx),%edx
  802cc7:	89 10                	mov    %edx,(%eax)
  802cc9:	eb 0a                	jmp    802cd5 <alloc_block_FF+0x2d8>
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	8b 00                	mov    (%eax),%eax
  802cd0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce8:	a1 38 50 80 00       	mov    0x805038,%eax
  802ced:	48                   	dec    %eax
  802cee:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802cf3:	83 ec 04             	sub    $0x4,%esp
  802cf6:	6a 00                	push   $0x0
  802cf8:	ff 75 b4             	pushl  -0x4c(%ebp)
  802cfb:	ff 75 b0             	pushl  -0x50(%ebp)
  802cfe:	e8 cb fc ff ff       	call   8029ce <set_block_data>
  802d03:	83 c4 10             	add    $0x10,%esp
  802d06:	e9 95 00 00 00       	jmp    802da0 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802d0b:	83 ec 04             	sub    $0x4,%esp
  802d0e:	6a 01                	push   $0x1
  802d10:	ff 75 b8             	pushl  -0x48(%ebp)
  802d13:	ff 75 bc             	pushl  -0x44(%ebp)
  802d16:	e8 b3 fc ff ff       	call   8029ce <set_block_data>
  802d1b:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802d1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d22:	75 17                	jne    802d3b <alloc_block_FF+0x33e>
  802d24:	83 ec 04             	sub    $0x4,%esp
  802d27:	68 d7 4c 80 00       	push   $0x804cd7
  802d2c:	68 e8 00 00 00       	push   $0xe8
  802d31:	68 f5 4c 80 00       	push   $0x804cf5
  802d36:	e8 87 db ff ff       	call   8008c2 <_panic>
  802d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3e:	8b 00                	mov    (%eax),%eax
  802d40:	85 c0                	test   %eax,%eax
  802d42:	74 10                	je     802d54 <alloc_block_FF+0x357>
  802d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d47:	8b 00                	mov    (%eax),%eax
  802d49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d4c:	8b 52 04             	mov    0x4(%edx),%edx
  802d4f:	89 50 04             	mov    %edx,0x4(%eax)
  802d52:	eb 0b                	jmp    802d5f <alloc_block_FF+0x362>
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 40 04             	mov    0x4(%eax),%eax
  802d5a:	a3 30 50 80 00       	mov    %eax,0x805030
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	8b 40 04             	mov    0x4(%eax),%eax
  802d65:	85 c0                	test   %eax,%eax
  802d67:	74 0f                	je     802d78 <alloc_block_FF+0x37b>
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	8b 40 04             	mov    0x4(%eax),%eax
  802d6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d72:	8b 12                	mov    (%edx),%edx
  802d74:	89 10                	mov    %edx,(%eax)
  802d76:	eb 0a                	jmp    802d82 <alloc_block_FF+0x385>
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8b 00                	mov    (%eax),%eax
  802d7d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d95:	a1 38 50 80 00       	mov    0x805038,%eax
  802d9a:	48                   	dec    %eax
  802d9b:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802da0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802da3:	e9 0f 01 00 00       	jmp    802eb7 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802da8:	a1 34 50 80 00       	mov    0x805034,%eax
  802dad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db4:	74 07                	je     802dbd <alloc_block_FF+0x3c0>
  802db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db9:	8b 00                	mov    (%eax),%eax
  802dbb:	eb 05                	jmp    802dc2 <alloc_block_FF+0x3c5>
  802dbd:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc2:	a3 34 50 80 00       	mov    %eax,0x805034
  802dc7:	a1 34 50 80 00       	mov    0x805034,%eax
  802dcc:	85 c0                	test   %eax,%eax
  802dce:	0f 85 e9 fc ff ff    	jne    802abd <alloc_block_FF+0xc0>
  802dd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd8:	0f 85 df fc ff ff    	jne    802abd <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802dde:	8b 45 08             	mov    0x8(%ebp),%eax
  802de1:	83 c0 08             	add    $0x8,%eax
  802de4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802de7:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802dee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802df1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802df4:	01 d0                	add    %edx,%eax
  802df6:	48                   	dec    %eax
  802df7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802dfa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dfd:	ba 00 00 00 00       	mov    $0x0,%edx
  802e02:	f7 75 d8             	divl   -0x28(%ebp)
  802e05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e08:	29 d0                	sub    %edx,%eax
  802e0a:	c1 e8 0c             	shr    $0xc,%eax
  802e0d:	83 ec 0c             	sub    $0xc,%esp
  802e10:	50                   	push   %eax
  802e11:	e8 0b ed ff ff       	call   801b21 <sbrk>
  802e16:	83 c4 10             	add    $0x10,%esp
  802e19:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802e1c:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802e20:	75 0a                	jne    802e2c <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802e22:	b8 00 00 00 00       	mov    $0x0,%eax
  802e27:	e9 8b 00 00 00       	jmp    802eb7 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e2c:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802e33:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e39:	01 d0                	add    %edx,%eax
  802e3b:	48                   	dec    %eax
  802e3c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802e3f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e42:	ba 00 00 00 00       	mov    $0x0,%edx
  802e47:	f7 75 cc             	divl   -0x34(%ebp)
  802e4a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e4d:	29 d0                	sub    %edx,%eax
  802e4f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e52:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e55:	01 d0                	add    %edx,%eax
  802e57:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802e5c:	a1 40 50 80 00       	mov    0x805040,%eax
  802e61:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e67:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e71:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e74:	01 d0                	add    %edx,%eax
  802e76:	48                   	dec    %eax
  802e77:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e7a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e7d:	ba 00 00 00 00       	mov    $0x0,%edx
  802e82:	f7 75 c4             	divl   -0x3c(%ebp)
  802e85:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e88:	29 d0                	sub    %edx,%eax
  802e8a:	83 ec 04             	sub    $0x4,%esp
  802e8d:	6a 01                	push   $0x1
  802e8f:	50                   	push   %eax
  802e90:	ff 75 d0             	pushl  -0x30(%ebp)
  802e93:	e8 36 fb ff ff       	call   8029ce <set_block_data>
  802e98:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802e9b:	83 ec 0c             	sub    $0xc,%esp
  802e9e:	ff 75 d0             	pushl  -0x30(%ebp)
  802ea1:	e8 f8 09 00 00       	call   80389e <free_block>
  802ea6:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802ea9:	83 ec 0c             	sub    $0xc,%esp
  802eac:	ff 75 08             	pushl  0x8(%ebp)
  802eaf:	e8 49 fb ff ff       	call   8029fd <alloc_block_FF>
  802eb4:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802eb7:	c9                   	leave  
  802eb8:	c3                   	ret    

00802eb9 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802eb9:	55                   	push   %ebp
  802eba:	89 e5                	mov    %esp,%ebp
  802ebc:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	83 e0 01             	and    $0x1,%eax
  802ec5:	85 c0                	test   %eax,%eax
  802ec7:	74 03                	je     802ecc <alloc_block_BF+0x13>
  802ec9:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802ecc:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802ed0:	77 07                	ja     802ed9 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802ed2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802ed9:	a1 24 50 80 00       	mov    0x805024,%eax
  802ede:	85 c0                	test   %eax,%eax
  802ee0:	75 73                	jne    802f55 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	83 c0 10             	add    $0x10,%eax
  802ee8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802eeb:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802ef2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ef5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef8:	01 d0                	add    %edx,%eax
  802efa:	48                   	dec    %eax
  802efb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802efe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f01:	ba 00 00 00 00       	mov    $0x0,%edx
  802f06:	f7 75 e0             	divl   -0x20(%ebp)
  802f09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f0c:	29 d0                	sub    %edx,%eax
  802f0e:	c1 e8 0c             	shr    $0xc,%eax
  802f11:	83 ec 0c             	sub    $0xc,%esp
  802f14:	50                   	push   %eax
  802f15:	e8 07 ec ff ff       	call   801b21 <sbrk>
  802f1a:	83 c4 10             	add    $0x10,%esp
  802f1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802f20:	83 ec 0c             	sub    $0xc,%esp
  802f23:	6a 00                	push   $0x0
  802f25:	e8 f7 eb ff ff       	call   801b21 <sbrk>
  802f2a:	83 c4 10             	add    $0x10,%esp
  802f2d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802f30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f33:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802f36:	83 ec 08             	sub    $0x8,%esp
  802f39:	50                   	push   %eax
  802f3a:	ff 75 d8             	pushl  -0x28(%ebp)
  802f3d:	e8 9f f8 ff ff       	call   8027e1 <initialize_dynamic_allocator>
  802f42:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802f45:	83 ec 0c             	sub    $0xc,%esp
  802f48:	68 33 4d 80 00       	push   $0x804d33
  802f4d:	e8 2d dc ff ff       	call   800b7f <cprintf>
  802f52:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802f55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802f5c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802f63:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802f6a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802f71:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f79:	e9 1d 01 00 00       	jmp    80309b <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802f84:	83 ec 0c             	sub    $0xc,%esp
  802f87:	ff 75 a8             	pushl  -0x58(%ebp)
  802f8a:	e8 ee f6 ff ff       	call   80267d <get_block_size>
  802f8f:	83 c4 10             	add    $0x10,%esp
  802f92:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	83 c0 08             	add    $0x8,%eax
  802f9b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f9e:	0f 87 ef 00 00 00    	ja     803093 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	83 c0 18             	add    $0x18,%eax
  802faa:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fad:	77 1d                	ja     802fcc <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802faf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fb5:	0f 86 d8 00 00 00    	jbe    803093 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802fbb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802fbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802fc1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802fc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802fc7:	e9 c7 00 00 00       	jmp    803093 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcf:	83 c0 08             	add    $0x8,%eax
  802fd2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fd5:	0f 85 9d 00 00 00    	jne    803078 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802fdb:	83 ec 04             	sub    $0x4,%esp
  802fde:	6a 01                	push   $0x1
  802fe0:	ff 75 a4             	pushl  -0x5c(%ebp)
  802fe3:	ff 75 a8             	pushl  -0x58(%ebp)
  802fe6:	e8 e3 f9 ff ff       	call   8029ce <set_block_data>
  802feb:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802fee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff2:	75 17                	jne    80300b <alloc_block_BF+0x152>
  802ff4:	83 ec 04             	sub    $0x4,%esp
  802ff7:	68 d7 4c 80 00       	push   $0x804cd7
  802ffc:	68 2c 01 00 00       	push   $0x12c
  803001:	68 f5 4c 80 00       	push   $0x804cf5
  803006:	e8 b7 d8 ff ff       	call   8008c2 <_panic>
  80300b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300e:	8b 00                	mov    (%eax),%eax
  803010:	85 c0                	test   %eax,%eax
  803012:	74 10                	je     803024 <alloc_block_BF+0x16b>
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	8b 00                	mov    (%eax),%eax
  803019:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80301c:	8b 52 04             	mov    0x4(%edx),%edx
  80301f:	89 50 04             	mov    %edx,0x4(%eax)
  803022:	eb 0b                	jmp    80302f <alloc_block_BF+0x176>
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	8b 40 04             	mov    0x4(%eax),%eax
  80302a:	a3 30 50 80 00       	mov    %eax,0x805030
  80302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803032:	8b 40 04             	mov    0x4(%eax),%eax
  803035:	85 c0                	test   %eax,%eax
  803037:	74 0f                	je     803048 <alloc_block_BF+0x18f>
  803039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303c:	8b 40 04             	mov    0x4(%eax),%eax
  80303f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803042:	8b 12                	mov    (%edx),%edx
  803044:	89 10                	mov    %edx,(%eax)
  803046:	eb 0a                	jmp    803052 <alloc_block_BF+0x199>
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	8b 00                	mov    (%eax),%eax
  80304d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803065:	a1 38 50 80 00       	mov    0x805038,%eax
  80306a:	48                   	dec    %eax
  80306b:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  803070:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803073:	e9 01 04 00 00       	jmp    803479 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  803078:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80307e:	76 13                	jbe    803093 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803080:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803087:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80308a:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80308d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803090:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803093:	a1 34 50 80 00       	mov    0x805034,%eax
  803098:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80309b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80309f:	74 07                	je     8030a8 <alloc_block_BF+0x1ef>
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 00                	mov    (%eax),%eax
  8030a6:	eb 05                	jmp    8030ad <alloc_block_BF+0x1f4>
  8030a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ad:	a3 34 50 80 00       	mov    %eax,0x805034
  8030b2:	a1 34 50 80 00       	mov    0x805034,%eax
  8030b7:	85 c0                	test   %eax,%eax
  8030b9:	0f 85 bf fe ff ff    	jne    802f7e <alloc_block_BF+0xc5>
  8030bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c3:	0f 85 b5 fe ff ff    	jne    802f7e <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8030c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030cd:	0f 84 26 02 00 00    	je     8032f9 <alloc_block_BF+0x440>
  8030d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d7:	0f 85 1c 02 00 00    	jne    8032f9 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8030dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e0:	2b 45 08             	sub    0x8(%ebp),%eax
  8030e3:	83 e8 08             	sub    $0x8,%eax
  8030e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ec:	8d 50 08             	lea    0x8(%eax),%edx
  8030ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f2:	01 d0                	add    %edx,%eax
  8030f4:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	83 c0 08             	add    $0x8,%eax
  8030fd:	83 ec 04             	sub    $0x4,%esp
  803100:	6a 01                	push   $0x1
  803102:	50                   	push   %eax
  803103:	ff 75 f0             	pushl  -0x10(%ebp)
  803106:	e8 c3 f8 ff ff       	call   8029ce <set_block_data>
  80310b:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80310e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803111:	8b 40 04             	mov    0x4(%eax),%eax
  803114:	85 c0                	test   %eax,%eax
  803116:	75 68                	jne    803180 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803118:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80311c:	75 17                	jne    803135 <alloc_block_BF+0x27c>
  80311e:	83 ec 04             	sub    $0x4,%esp
  803121:	68 10 4d 80 00       	push   $0x804d10
  803126:	68 45 01 00 00       	push   $0x145
  80312b:	68 f5 4c 80 00       	push   $0x804cf5
  803130:	e8 8d d7 ff ff       	call   8008c2 <_panic>
  803135:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80313b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80313e:	89 10                	mov    %edx,(%eax)
  803140:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803143:	8b 00                	mov    (%eax),%eax
  803145:	85 c0                	test   %eax,%eax
  803147:	74 0d                	je     803156 <alloc_block_BF+0x29d>
  803149:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80314e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803151:	89 50 04             	mov    %edx,0x4(%eax)
  803154:	eb 08                	jmp    80315e <alloc_block_BF+0x2a5>
  803156:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803159:	a3 30 50 80 00       	mov    %eax,0x805030
  80315e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803161:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803166:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803169:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803170:	a1 38 50 80 00       	mov    0x805038,%eax
  803175:	40                   	inc    %eax
  803176:	a3 38 50 80 00       	mov    %eax,0x805038
  80317b:	e9 dc 00 00 00       	jmp    80325c <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803183:	8b 00                	mov    (%eax),%eax
  803185:	85 c0                	test   %eax,%eax
  803187:	75 65                	jne    8031ee <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803189:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80318d:	75 17                	jne    8031a6 <alloc_block_BF+0x2ed>
  80318f:	83 ec 04             	sub    $0x4,%esp
  803192:	68 44 4d 80 00       	push   $0x804d44
  803197:	68 4a 01 00 00       	push   $0x14a
  80319c:	68 f5 4c 80 00       	push   $0x804cf5
  8031a1:	e8 1c d7 ff ff       	call   8008c2 <_panic>
  8031a6:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8031ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031af:	89 50 04             	mov    %edx,0x4(%eax)
  8031b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031b5:	8b 40 04             	mov    0x4(%eax),%eax
  8031b8:	85 c0                	test   %eax,%eax
  8031ba:	74 0c                	je     8031c8 <alloc_block_BF+0x30f>
  8031bc:	a1 30 50 80 00       	mov    0x805030,%eax
  8031c1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031c4:	89 10                	mov    %edx,(%eax)
  8031c6:	eb 08                	jmp    8031d0 <alloc_block_BF+0x317>
  8031c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031cb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031d3:	a3 30 50 80 00       	mov    %eax,0x805030
  8031d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e1:	a1 38 50 80 00       	mov    0x805038,%eax
  8031e6:	40                   	inc    %eax
  8031e7:	a3 38 50 80 00       	mov    %eax,0x805038
  8031ec:	eb 6e                	jmp    80325c <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8031ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031f2:	74 06                	je     8031fa <alloc_block_BF+0x341>
  8031f4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031f8:	75 17                	jne    803211 <alloc_block_BF+0x358>
  8031fa:	83 ec 04             	sub    $0x4,%esp
  8031fd:	68 68 4d 80 00       	push   $0x804d68
  803202:	68 4f 01 00 00       	push   $0x14f
  803207:	68 f5 4c 80 00       	push   $0x804cf5
  80320c:	e8 b1 d6 ff ff       	call   8008c2 <_panic>
  803211:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803214:	8b 10                	mov    (%eax),%edx
  803216:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803219:	89 10                	mov    %edx,(%eax)
  80321b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80321e:	8b 00                	mov    (%eax),%eax
  803220:	85 c0                	test   %eax,%eax
  803222:	74 0b                	je     80322f <alloc_block_BF+0x376>
  803224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803227:	8b 00                	mov    (%eax),%eax
  803229:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80322c:	89 50 04             	mov    %edx,0x4(%eax)
  80322f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803232:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803235:	89 10                	mov    %edx,(%eax)
  803237:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80323a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80323d:	89 50 04             	mov    %edx,0x4(%eax)
  803240:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803243:	8b 00                	mov    (%eax),%eax
  803245:	85 c0                	test   %eax,%eax
  803247:	75 08                	jne    803251 <alloc_block_BF+0x398>
  803249:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80324c:	a3 30 50 80 00       	mov    %eax,0x805030
  803251:	a1 38 50 80 00       	mov    0x805038,%eax
  803256:	40                   	inc    %eax
  803257:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80325c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803260:	75 17                	jne    803279 <alloc_block_BF+0x3c0>
  803262:	83 ec 04             	sub    $0x4,%esp
  803265:	68 d7 4c 80 00       	push   $0x804cd7
  80326a:	68 51 01 00 00       	push   $0x151
  80326f:	68 f5 4c 80 00       	push   $0x804cf5
  803274:	e8 49 d6 ff ff       	call   8008c2 <_panic>
  803279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	85 c0                	test   %eax,%eax
  803280:	74 10                	je     803292 <alloc_block_BF+0x3d9>
  803282:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803285:	8b 00                	mov    (%eax),%eax
  803287:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80328a:	8b 52 04             	mov    0x4(%edx),%edx
  80328d:	89 50 04             	mov    %edx,0x4(%eax)
  803290:	eb 0b                	jmp    80329d <alloc_block_BF+0x3e4>
  803292:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803295:	8b 40 04             	mov    0x4(%eax),%eax
  803298:	a3 30 50 80 00       	mov    %eax,0x805030
  80329d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a0:	8b 40 04             	mov    0x4(%eax),%eax
  8032a3:	85 c0                	test   %eax,%eax
  8032a5:	74 0f                	je     8032b6 <alloc_block_BF+0x3fd>
  8032a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032aa:	8b 40 04             	mov    0x4(%eax),%eax
  8032ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032b0:	8b 12                	mov    (%edx),%edx
  8032b2:	89 10                	mov    %edx,(%eax)
  8032b4:	eb 0a                	jmp    8032c0 <alloc_block_BF+0x407>
  8032b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b9:	8b 00                	mov    (%eax),%eax
  8032bb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d3:	a1 38 50 80 00       	mov    0x805038,%eax
  8032d8:	48                   	dec    %eax
  8032d9:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8032de:	83 ec 04             	sub    $0x4,%esp
  8032e1:	6a 00                	push   $0x0
  8032e3:	ff 75 d0             	pushl  -0x30(%ebp)
  8032e6:	ff 75 cc             	pushl  -0x34(%ebp)
  8032e9:	e8 e0 f6 ff ff       	call   8029ce <set_block_data>
  8032ee:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8032f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f4:	e9 80 01 00 00       	jmp    803479 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  8032f9:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8032fd:	0f 85 9d 00 00 00    	jne    8033a0 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803303:	83 ec 04             	sub    $0x4,%esp
  803306:	6a 01                	push   $0x1
  803308:	ff 75 ec             	pushl  -0x14(%ebp)
  80330b:	ff 75 f0             	pushl  -0x10(%ebp)
  80330e:	e8 bb f6 ff ff       	call   8029ce <set_block_data>
  803313:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803316:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80331a:	75 17                	jne    803333 <alloc_block_BF+0x47a>
  80331c:	83 ec 04             	sub    $0x4,%esp
  80331f:	68 d7 4c 80 00       	push   $0x804cd7
  803324:	68 58 01 00 00       	push   $0x158
  803329:	68 f5 4c 80 00       	push   $0x804cf5
  80332e:	e8 8f d5 ff ff       	call   8008c2 <_panic>
  803333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803336:	8b 00                	mov    (%eax),%eax
  803338:	85 c0                	test   %eax,%eax
  80333a:	74 10                	je     80334c <alloc_block_BF+0x493>
  80333c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333f:	8b 00                	mov    (%eax),%eax
  803341:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803344:	8b 52 04             	mov    0x4(%edx),%edx
  803347:	89 50 04             	mov    %edx,0x4(%eax)
  80334a:	eb 0b                	jmp    803357 <alloc_block_BF+0x49e>
  80334c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334f:	8b 40 04             	mov    0x4(%eax),%eax
  803352:	a3 30 50 80 00       	mov    %eax,0x805030
  803357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335a:	8b 40 04             	mov    0x4(%eax),%eax
  80335d:	85 c0                	test   %eax,%eax
  80335f:	74 0f                	je     803370 <alloc_block_BF+0x4b7>
  803361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803364:	8b 40 04             	mov    0x4(%eax),%eax
  803367:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80336a:	8b 12                	mov    (%edx),%edx
  80336c:	89 10                	mov    %edx,(%eax)
  80336e:	eb 0a                	jmp    80337a <alloc_block_BF+0x4c1>
  803370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803373:	8b 00                	mov    (%eax),%eax
  803375:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80337a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803386:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80338d:	a1 38 50 80 00       	mov    0x805038,%eax
  803392:	48                   	dec    %eax
  803393:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  803398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339b:	e9 d9 00 00 00       	jmp    803479 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8033a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a3:	83 c0 08             	add    $0x8,%eax
  8033a6:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8033a9:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8033b0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8033b6:	01 d0                	add    %edx,%eax
  8033b8:	48                   	dec    %eax
  8033b9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8033bc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8033bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8033c4:	f7 75 c4             	divl   -0x3c(%ebp)
  8033c7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8033ca:	29 d0                	sub    %edx,%eax
  8033cc:	c1 e8 0c             	shr    $0xc,%eax
  8033cf:	83 ec 0c             	sub    $0xc,%esp
  8033d2:	50                   	push   %eax
  8033d3:	e8 49 e7 ff ff       	call   801b21 <sbrk>
  8033d8:	83 c4 10             	add    $0x10,%esp
  8033db:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8033de:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8033e2:	75 0a                	jne    8033ee <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8033e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e9:	e9 8b 00 00 00       	jmp    803479 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8033ee:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8033f5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8033fb:	01 d0                	add    %edx,%eax
  8033fd:	48                   	dec    %eax
  8033fe:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803401:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803404:	ba 00 00 00 00       	mov    $0x0,%edx
  803409:	f7 75 b8             	divl   -0x48(%ebp)
  80340c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80340f:	29 d0                	sub    %edx,%eax
  803411:	8d 50 fc             	lea    -0x4(%eax),%edx
  803414:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803417:	01 d0                	add    %edx,%eax
  803419:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  80341e:	a1 40 50 80 00       	mov    0x805040,%eax
  803423:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803429:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803430:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803433:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803436:	01 d0                	add    %edx,%eax
  803438:	48                   	dec    %eax
  803439:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80343c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80343f:	ba 00 00 00 00       	mov    $0x0,%edx
  803444:	f7 75 b0             	divl   -0x50(%ebp)
  803447:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80344a:	29 d0                	sub    %edx,%eax
  80344c:	83 ec 04             	sub    $0x4,%esp
  80344f:	6a 01                	push   $0x1
  803451:	50                   	push   %eax
  803452:	ff 75 bc             	pushl  -0x44(%ebp)
  803455:	e8 74 f5 ff ff       	call   8029ce <set_block_data>
  80345a:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80345d:	83 ec 0c             	sub    $0xc,%esp
  803460:	ff 75 bc             	pushl  -0x44(%ebp)
  803463:	e8 36 04 00 00       	call   80389e <free_block>
  803468:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80346b:	83 ec 0c             	sub    $0xc,%esp
  80346e:	ff 75 08             	pushl  0x8(%ebp)
  803471:	e8 43 fa ff ff       	call   802eb9 <alloc_block_BF>
  803476:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803479:	c9                   	leave  
  80347a:	c3                   	ret    

0080347b <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80347b:	55                   	push   %ebp
  80347c:	89 e5                	mov    %esp,%ebp
  80347e:	53                   	push   %ebx
  80347f:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803482:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803489:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803490:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803494:	74 1e                	je     8034b4 <merging+0x39>
  803496:	ff 75 08             	pushl  0x8(%ebp)
  803499:	e8 df f1 ff ff       	call   80267d <get_block_size>
  80349e:	83 c4 04             	add    $0x4,%esp
  8034a1:	89 c2                	mov    %eax,%edx
  8034a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a6:	01 d0                	add    %edx,%eax
  8034a8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8034ab:	75 07                	jne    8034b4 <merging+0x39>
		prev_is_free = 1;
  8034ad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8034b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034b8:	74 1e                	je     8034d8 <merging+0x5d>
  8034ba:	ff 75 10             	pushl  0x10(%ebp)
  8034bd:	e8 bb f1 ff ff       	call   80267d <get_block_size>
  8034c2:	83 c4 04             	add    $0x4,%esp
  8034c5:	89 c2                	mov    %eax,%edx
  8034c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8034ca:	01 d0                	add    %edx,%eax
  8034cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034cf:	75 07                	jne    8034d8 <merging+0x5d>
		next_is_free = 1;
  8034d1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8034d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034dc:	0f 84 cc 00 00 00    	je     8035ae <merging+0x133>
  8034e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034e6:	0f 84 c2 00 00 00    	je     8035ae <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8034ec:	ff 75 08             	pushl  0x8(%ebp)
  8034ef:	e8 89 f1 ff ff       	call   80267d <get_block_size>
  8034f4:	83 c4 04             	add    $0x4,%esp
  8034f7:	89 c3                	mov    %eax,%ebx
  8034f9:	ff 75 10             	pushl  0x10(%ebp)
  8034fc:	e8 7c f1 ff ff       	call   80267d <get_block_size>
  803501:	83 c4 04             	add    $0x4,%esp
  803504:	01 c3                	add    %eax,%ebx
  803506:	ff 75 0c             	pushl  0xc(%ebp)
  803509:	e8 6f f1 ff ff       	call   80267d <get_block_size>
  80350e:	83 c4 04             	add    $0x4,%esp
  803511:	01 d8                	add    %ebx,%eax
  803513:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803516:	6a 00                	push   $0x0
  803518:	ff 75 ec             	pushl  -0x14(%ebp)
  80351b:	ff 75 08             	pushl  0x8(%ebp)
  80351e:	e8 ab f4 ff ff       	call   8029ce <set_block_data>
  803523:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803526:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80352a:	75 17                	jne    803543 <merging+0xc8>
  80352c:	83 ec 04             	sub    $0x4,%esp
  80352f:	68 d7 4c 80 00       	push   $0x804cd7
  803534:	68 7d 01 00 00       	push   $0x17d
  803539:	68 f5 4c 80 00       	push   $0x804cf5
  80353e:	e8 7f d3 ff ff       	call   8008c2 <_panic>
  803543:	8b 45 0c             	mov    0xc(%ebp),%eax
  803546:	8b 00                	mov    (%eax),%eax
  803548:	85 c0                	test   %eax,%eax
  80354a:	74 10                	je     80355c <merging+0xe1>
  80354c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80354f:	8b 00                	mov    (%eax),%eax
  803551:	8b 55 0c             	mov    0xc(%ebp),%edx
  803554:	8b 52 04             	mov    0x4(%edx),%edx
  803557:	89 50 04             	mov    %edx,0x4(%eax)
  80355a:	eb 0b                	jmp    803567 <merging+0xec>
  80355c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80355f:	8b 40 04             	mov    0x4(%eax),%eax
  803562:	a3 30 50 80 00       	mov    %eax,0x805030
  803567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80356a:	8b 40 04             	mov    0x4(%eax),%eax
  80356d:	85 c0                	test   %eax,%eax
  80356f:	74 0f                	je     803580 <merging+0x105>
  803571:	8b 45 0c             	mov    0xc(%ebp),%eax
  803574:	8b 40 04             	mov    0x4(%eax),%eax
  803577:	8b 55 0c             	mov    0xc(%ebp),%edx
  80357a:	8b 12                	mov    (%edx),%edx
  80357c:	89 10                	mov    %edx,(%eax)
  80357e:	eb 0a                	jmp    80358a <merging+0x10f>
  803580:	8b 45 0c             	mov    0xc(%ebp),%eax
  803583:	8b 00                	mov    (%eax),%eax
  803585:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80358a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80358d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803593:	8b 45 0c             	mov    0xc(%ebp),%eax
  803596:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80359d:	a1 38 50 80 00       	mov    0x805038,%eax
  8035a2:	48                   	dec    %eax
  8035a3:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8035a8:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035a9:	e9 ea 02 00 00       	jmp    803898 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8035ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b2:	74 3b                	je     8035ef <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8035b4:	83 ec 0c             	sub    $0xc,%esp
  8035b7:	ff 75 08             	pushl  0x8(%ebp)
  8035ba:	e8 be f0 ff ff       	call   80267d <get_block_size>
  8035bf:	83 c4 10             	add    $0x10,%esp
  8035c2:	89 c3                	mov    %eax,%ebx
  8035c4:	83 ec 0c             	sub    $0xc,%esp
  8035c7:	ff 75 10             	pushl  0x10(%ebp)
  8035ca:	e8 ae f0 ff ff       	call   80267d <get_block_size>
  8035cf:	83 c4 10             	add    $0x10,%esp
  8035d2:	01 d8                	add    %ebx,%eax
  8035d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8035d7:	83 ec 04             	sub    $0x4,%esp
  8035da:	6a 00                	push   $0x0
  8035dc:	ff 75 e8             	pushl  -0x18(%ebp)
  8035df:	ff 75 08             	pushl  0x8(%ebp)
  8035e2:	e8 e7 f3 ff ff       	call   8029ce <set_block_data>
  8035e7:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035ea:	e9 a9 02 00 00       	jmp    803898 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8035ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035f3:	0f 84 2d 01 00 00    	je     803726 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8035f9:	83 ec 0c             	sub    $0xc,%esp
  8035fc:	ff 75 10             	pushl  0x10(%ebp)
  8035ff:	e8 79 f0 ff ff       	call   80267d <get_block_size>
  803604:	83 c4 10             	add    $0x10,%esp
  803607:	89 c3                	mov    %eax,%ebx
  803609:	83 ec 0c             	sub    $0xc,%esp
  80360c:	ff 75 0c             	pushl  0xc(%ebp)
  80360f:	e8 69 f0 ff ff       	call   80267d <get_block_size>
  803614:	83 c4 10             	add    $0x10,%esp
  803617:	01 d8                	add    %ebx,%eax
  803619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80361c:	83 ec 04             	sub    $0x4,%esp
  80361f:	6a 00                	push   $0x0
  803621:	ff 75 e4             	pushl  -0x1c(%ebp)
  803624:	ff 75 10             	pushl  0x10(%ebp)
  803627:	e8 a2 f3 ff ff       	call   8029ce <set_block_data>
  80362c:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80362f:	8b 45 10             	mov    0x10(%ebp),%eax
  803632:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803635:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803639:	74 06                	je     803641 <merging+0x1c6>
  80363b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80363f:	75 17                	jne    803658 <merging+0x1dd>
  803641:	83 ec 04             	sub    $0x4,%esp
  803644:	68 9c 4d 80 00       	push   $0x804d9c
  803649:	68 8d 01 00 00       	push   $0x18d
  80364e:	68 f5 4c 80 00       	push   $0x804cf5
  803653:	e8 6a d2 ff ff       	call   8008c2 <_panic>
  803658:	8b 45 0c             	mov    0xc(%ebp),%eax
  80365b:	8b 50 04             	mov    0x4(%eax),%edx
  80365e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803661:	89 50 04             	mov    %edx,0x4(%eax)
  803664:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803667:	8b 55 0c             	mov    0xc(%ebp),%edx
  80366a:	89 10                	mov    %edx,(%eax)
  80366c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80366f:	8b 40 04             	mov    0x4(%eax),%eax
  803672:	85 c0                	test   %eax,%eax
  803674:	74 0d                	je     803683 <merging+0x208>
  803676:	8b 45 0c             	mov    0xc(%ebp),%eax
  803679:	8b 40 04             	mov    0x4(%eax),%eax
  80367c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80367f:	89 10                	mov    %edx,(%eax)
  803681:	eb 08                	jmp    80368b <merging+0x210>
  803683:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803686:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80368b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80368e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803691:	89 50 04             	mov    %edx,0x4(%eax)
  803694:	a1 38 50 80 00       	mov    0x805038,%eax
  803699:	40                   	inc    %eax
  80369a:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  80369f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036a3:	75 17                	jne    8036bc <merging+0x241>
  8036a5:	83 ec 04             	sub    $0x4,%esp
  8036a8:	68 d7 4c 80 00       	push   $0x804cd7
  8036ad:	68 8e 01 00 00       	push   $0x18e
  8036b2:	68 f5 4c 80 00       	push   $0x804cf5
  8036b7:	e8 06 d2 ff ff       	call   8008c2 <_panic>
  8036bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036bf:	8b 00                	mov    (%eax),%eax
  8036c1:	85 c0                	test   %eax,%eax
  8036c3:	74 10                	je     8036d5 <merging+0x25a>
  8036c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c8:	8b 00                	mov    (%eax),%eax
  8036ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036cd:	8b 52 04             	mov    0x4(%edx),%edx
  8036d0:	89 50 04             	mov    %edx,0x4(%eax)
  8036d3:	eb 0b                	jmp    8036e0 <merging+0x265>
  8036d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d8:	8b 40 04             	mov    0x4(%eax),%eax
  8036db:	a3 30 50 80 00       	mov    %eax,0x805030
  8036e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e3:	8b 40 04             	mov    0x4(%eax),%eax
  8036e6:	85 c0                	test   %eax,%eax
  8036e8:	74 0f                	je     8036f9 <merging+0x27e>
  8036ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ed:	8b 40 04             	mov    0x4(%eax),%eax
  8036f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036f3:	8b 12                	mov    (%edx),%edx
  8036f5:	89 10                	mov    %edx,(%eax)
  8036f7:	eb 0a                	jmp    803703 <merging+0x288>
  8036f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036fc:	8b 00                	mov    (%eax),%eax
  8036fe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803703:	8b 45 0c             	mov    0xc(%ebp),%eax
  803706:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80370c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80370f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803716:	a1 38 50 80 00       	mov    0x805038,%eax
  80371b:	48                   	dec    %eax
  80371c:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803721:	e9 72 01 00 00       	jmp    803898 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803726:	8b 45 10             	mov    0x10(%ebp),%eax
  803729:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80372c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803730:	74 79                	je     8037ab <merging+0x330>
  803732:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803736:	74 73                	je     8037ab <merging+0x330>
  803738:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80373c:	74 06                	je     803744 <merging+0x2c9>
  80373e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803742:	75 17                	jne    80375b <merging+0x2e0>
  803744:	83 ec 04             	sub    $0x4,%esp
  803747:	68 68 4d 80 00       	push   $0x804d68
  80374c:	68 94 01 00 00       	push   $0x194
  803751:	68 f5 4c 80 00       	push   $0x804cf5
  803756:	e8 67 d1 ff ff       	call   8008c2 <_panic>
  80375b:	8b 45 08             	mov    0x8(%ebp),%eax
  80375e:	8b 10                	mov    (%eax),%edx
  803760:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803763:	89 10                	mov    %edx,(%eax)
  803765:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803768:	8b 00                	mov    (%eax),%eax
  80376a:	85 c0                	test   %eax,%eax
  80376c:	74 0b                	je     803779 <merging+0x2fe>
  80376e:	8b 45 08             	mov    0x8(%ebp),%eax
  803771:	8b 00                	mov    (%eax),%eax
  803773:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803776:	89 50 04             	mov    %edx,0x4(%eax)
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80377f:	89 10                	mov    %edx,(%eax)
  803781:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803784:	8b 55 08             	mov    0x8(%ebp),%edx
  803787:	89 50 04             	mov    %edx,0x4(%eax)
  80378a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80378d:	8b 00                	mov    (%eax),%eax
  80378f:	85 c0                	test   %eax,%eax
  803791:	75 08                	jne    80379b <merging+0x320>
  803793:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803796:	a3 30 50 80 00       	mov    %eax,0x805030
  80379b:	a1 38 50 80 00       	mov    0x805038,%eax
  8037a0:	40                   	inc    %eax
  8037a1:	a3 38 50 80 00       	mov    %eax,0x805038
  8037a6:	e9 ce 00 00 00       	jmp    803879 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8037ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037af:	74 65                	je     803816 <merging+0x39b>
  8037b1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037b5:	75 17                	jne    8037ce <merging+0x353>
  8037b7:	83 ec 04             	sub    $0x4,%esp
  8037ba:	68 44 4d 80 00       	push   $0x804d44
  8037bf:	68 95 01 00 00       	push   $0x195
  8037c4:	68 f5 4c 80 00       	push   $0x804cf5
  8037c9:	e8 f4 d0 ff ff       	call   8008c2 <_panic>
  8037ce:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8037d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d7:	89 50 04             	mov    %edx,0x4(%eax)
  8037da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037dd:	8b 40 04             	mov    0x4(%eax),%eax
  8037e0:	85 c0                	test   %eax,%eax
  8037e2:	74 0c                	je     8037f0 <merging+0x375>
  8037e4:	a1 30 50 80 00       	mov    0x805030,%eax
  8037e9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037ec:	89 10                	mov    %edx,(%eax)
  8037ee:	eb 08                	jmp    8037f8 <merging+0x37d>
  8037f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037fb:	a3 30 50 80 00       	mov    %eax,0x805030
  803800:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803803:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803809:	a1 38 50 80 00       	mov    0x805038,%eax
  80380e:	40                   	inc    %eax
  80380f:	a3 38 50 80 00       	mov    %eax,0x805038
  803814:	eb 63                	jmp    803879 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803816:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80381a:	75 17                	jne    803833 <merging+0x3b8>
  80381c:	83 ec 04             	sub    $0x4,%esp
  80381f:	68 10 4d 80 00       	push   $0x804d10
  803824:	68 98 01 00 00       	push   $0x198
  803829:	68 f5 4c 80 00       	push   $0x804cf5
  80382e:	e8 8f d0 ff ff       	call   8008c2 <_panic>
  803833:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803839:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80383c:	89 10                	mov    %edx,(%eax)
  80383e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803841:	8b 00                	mov    (%eax),%eax
  803843:	85 c0                	test   %eax,%eax
  803845:	74 0d                	je     803854 <merging+0x3d9>
  803847:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80384c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80384f:	89 50 04             	mov    %edx,0x4(%eax)
  803852:	eb 08                	jmp    80385c <merging+0x3e1>
  803854:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803857:	a3 30 50 80 00       	mov    %eax,0x805030
  80385c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80385f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803864:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803867:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80386e:	a1 38 50 80 00       	mov    0x805038,%eax
  803873:	40                   	inc    %eax
  803874:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803879:	83 ec 0c             	sub    $0xc,%esp
  80387c:	ff 75 10             	pushl  0x10(%ebp)
  80387f:	e8 f9 ed ff ff       	call   80267d <get_block_size>
  803884:	83 c4 10             	add    $0x10,%esp
  803887:	83 ec 04             	sub    $0x4,%esp
  80388a:	6a 00                	push   $0x0
  80388c:	50                   	push   %eax
  80388d:	ff 75 10             	pushl  0x10(%ebp)
  803890:	e8 39 f1 ff ff       	call   8029ce <set_block_data>
  803895:	83 c4 10             	add    $0x10,%esp
	}
}
  803898:	90                   	nop
  803899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80389c:	c9                   	leave  
  80389d:	c3                   	ret    

0080389e <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80389e:	55                   	push   %ebp
  80389f:	89 e5                	mov    %esp,%ebp
  8038a1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8038a4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8038a9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8038ac:	a1 30 50 80 00       	mov    0x805030,%eax
  8038b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038b4:	73 1b                	jae    8038d1 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8038b6:	a1 30 50 80 00       	mov    0x805030,%eax
  8038bb:	83 ec 04             	sub    $0x4,%esp
  8038be:	ff 75 08             	pushl  0x8(%ebp)
  8038c1:	6a 00                	push   $0x0
  8038c3:	50                   	push   %eax
  8038c4:	e8 b2 fb ff ff       	call   80347b <merging>
  8038c9:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038cc:	e9 8b 00 00 00       	jmp    80395c <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8038d1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8038d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038d9:	76 18                	jbe    8038f3 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8038db:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8038e0:	83 ec 04             	sub    $0x4,%esp
  8038e3:	ff 75 08             	pushl  0x8(%ebp)
  8038e6:	50                   	push   %eax
  8038e7:	6a 00                	push   $0x0
  8038e9:	e8 8d fb ff ff       	call   80347b <merging>
  8038ee:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038f1:	eb 69                	jmp    80395c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8038f3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8038f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038fb:	eb 39                	jmp    803936 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8038fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803900:	3b 45 08             	cmp    0x8(%ebp),%eax
  803903:	73 29                	jae    80392e <free_block+0x90>
  803905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803908:	8b 00                	mov    (%eax),%eax
  80390a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80390d:	76 1f                	jbe    80392e <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80390f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803912:	8b 00                	mov    (%eax),%eax
  803914:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803917:	83 ec 04             	sub    $0x4,%esp
  80391a:	ff 75 08             	pushl  0x8(%ebp)
  80391d:	ff 75 f0             	pushl  -0x10(%ebp)
  803920:	ff 75 f4             	pushl  -0xc(%ebp)
  803923:	e8 53 fb ff ff       	call   80347b <merging>
  803928:	83 c4 10             	add    $0x10,%esp
			break;
  80392b:	90                   	nop
		}
	}
}
  80392c:	eb 2e                	jmp    80395c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80392e:	a1 34 50 80 00       	mov    0x805034,%eax
  803933:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803936:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80393a:	74 07                	je     803943 <free_block+0xa5>
  80393c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393f:	8b 00                	mov    (%eax),%eax
  803941:	eb 05                	jmp    803948 <free_block+0xaa>
  803943:	b8 00 00 00 00       	mov    $0x0,%eax
  803948:	a3 34 50 80 00       	mov    %eax,0x805034
  80394d:	a1 34 50 80 00       	mov    0x805034,%eax
  803952:	85 c0                	test   %eax,%eax
  803954:	75 a7                	jne    8038fd <free_block+0x5f>
  803956:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80395a:	75 a1                	jne    8038fd <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80395c:	90                   	nop
  80395d:	c9                   	leave  
  80395e:	c3                   	ret    

0080395f <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80395f:	55                   	push   %ebp
  803960:	89 e5                	mov    %esp,%ebp
  803962:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803965:	ff 75 08             	pushl  0x8(%ebp)
  803968:	e8 10 ed ff ff       	call   80267d <get_block_size>
  80396d:	83 c4 04             	add    $0x4,%esp
  803970:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803973:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80397a:	eb 17                	jmp    803993 <copy_data+0x34>
  80397c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80397f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803982:	01 c2                	add    %eax,%edx
  803984:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803987:	8b 45 08             	mov    0x8(%ebp),%eax
  80398a:	01 c8                	add    %ecx,%eax
  80398c:	8a 00                	mov    (%eax),%al
  80398e:	88 02                	mov    %al,(%edx)
  803990:	ff 45 fc             	incl   -0x4(%ebp)
  803993:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803996:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803999:	72 e1                	jb     80397c <copy_data+0x1d>
}
  80399b:	90                   	nop
  80399c:	c9                   	leave  
  80399d:	c3                   	ret    

0080399e <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80399e:	55                   	push   %ebp
  80399f:	89 e5                	mov    %esp,%ebp
  8039a1:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8039a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039a8:	75 23                	jne    8039cd <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8039aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039ae:	74 13                	je     8039c3 <realloc_block_FF+0x25>
  8039b0:	83 ec 0c             	sub    $0xc,%esp
  8039b3:	ff 75 0c             	pushl  0xc(%ebp)
  8039b6:	e8 42 f0 ff ff       	call   8029fd <alloc_block_FF>
  8039bb:	83 c4 10             	add    $0x10,%esp
  8039be:	e9 e4 06 00 00       	jmp    8040a7 <realloc_block_FF+0x709>
		return NULL;
  8039c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8039c8:	e9 da 06 00 00       	jmp    8040a7 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8039cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039d1:	75 18                	jne    8039eb <realloc_block_FF+0x4d>
	{
		free_block(va);
  8039d3:	83 ec 0c             	sub    $0xc,%esp
  8039d6:	ff 75 08             	pushl  0x8(%ebp)
  8039d9:	e8 c0 fe ff ff       	call   80389e <free_block>
  8039de:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8039e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e6:	e9 bc 06 00 00       	jmp    8040a7 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8039eb:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8039ef:	77 07                	ja     8039f8 <realloc_block_FF+0x5a>
  8039f1:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8039f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039fb:	83 e0 01             	and    $0x1,%eax
  8039fe:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a04:	83 c0 08             	add    $0x8,%eax
  803a07:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803a0a:	83 ec 0c             	sub    $0xc,%esp
  803a0d:	ff 75 08             	pushl  0x8(%ebp)
  803a10:	e8 68 ec ff ff       	call   80267d <get_block_size>
  803a15:	83 c4 10             	add    $0x10,%esp
  803a18:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a1e:	83 e8 08             	sub    $0x8,%eax
  803a21:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803a24:	8b 45 08             	mov    0x8(%ebp),%eax
  803a27:	83 e8 04             	sub    $0x4,%eax
  803a2a:	8b 00                	mov    (%eax),%eax
  803a2c:	83 e0 fe             	and    $0xfffffffe,%eax
  803a2f:	89 c2                	mov    %eax,%edx
  803a31:	8b 45 08             	mov    0x8(%ebp),%eax
  803a34:	01 d0                	add    %edx,%eax
  803a36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803a39:	83 ec 0c             	sub    $0xc,%esp
  803a3c:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a3f:	e8 39 ec ff ff       	call   80267d <get_block_size>
  803a44:	83 c4 10             	add    $0x10,%esp
  803a47:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803a4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a4d:	83 e8 08             	sub    $0x8,%eax
  803a50:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a56:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a59:	75 08                	jne    803a63 <realloc_block_FF+0xc5>
	{
		 return va;
  803a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5e:	e9 44 06 00 00       	jmp    8040a7 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803a63:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a66:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a69:	0f 83 d5 03 00 00    	jae    803e44 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a72:	2b 45 0c             	sub    0xc(%ebp),%eax
  803a75:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803a78:	83 ec 0c             	sub    $0xc,%esp
  803a7b:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a7e:	e8 13 ec ff ff       	call   802696 <is_free_block>
  803a83:	83 c4 10             	add    $0x10,%esp
  803a86:	84 c0                	test   %al,%al
  803a88:	0f 84 3b 01 00 00    	je     803bc9 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803a8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a94:	01 d0                	add    %edx,%eax
  803a96:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803a99:	83 ec 04             	sub    $0x4,%esp
  803a9c:	6a 01                	push   $0x1
  803a9e:	ff 75 f0             	pushl  -0x10(%ebp)
  803aa1:	ff 75 08             	pushl  0x8(%ebp)
  803aa4:	e8 25 ef ff ff       	call   8029ce <set_block_data>
  803aa9:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803aac:	8b 45 08             	mov    0x8(%ebp),%eax
  803aaf:	83 e8 04             	sub    $0x4,%eax
  803ab2:	8b 00                	mov    (%eax),%eax
  803ab4:	83 e0 fe             	and    $0xfffffffe,%eax
  803ab7:	89 c2                	mov    %eax,%edx
  803ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  803abc:	01 d0                	add    %edx,%eax
  803abe:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803ac1:	83 ec 04             	sub    $0x4,%esp
  803ac4:	6a 00                	push   $0x0
  803ac6:	ff 75 cc             	pushl  -0x34(%ebp)
  803ac9:	ff 75 c8             	pushl  -0x38(%ebp)
  803acc:	e8 fd ee ff ff       	call   8029ce <set_block_data>
  803ad1:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803ad4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ad8:	74 06                	je     803ae0 <realloc_block_FF+0x142>
  803ada:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803ade:	75 17                	jne    803af7 <realloc_block_FF+0x159>
  803ae0:	83 ec 04             	sub    $0x4,%esp
  803ae3:	68 68 4d 80 00       	push   $0x804d68
  803ae8:	68 f6 01 00 00       	push   $0x1f6
  803aed:	68 f5 4c 80 00       	push   $0x804cf5
  803af2:	e8 cb cd ff ff       	call   8008c2 <_panic>
  803af7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803afa:	8b 10                	mov    (%eax),%edx
  803afc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803aff:	89 10                	mov    %edx,(%eax)
  803b01:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b04:	8b 00                	mov    (%eax),%eax
  803b06:	85 c0                	test   %eax,%eax
  803b08:	74 0b                	je     803b15 <realloc_block_FF+0x177>
  803b0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b0d:	8b 00                	mov    (%eax),%eax
  803b0f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b12:	89 50 04             	mov    %edx,0x4(%eax)
  803b15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b18:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b1b:	89 10                	mov    %edx,(%eax)
  803b1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b23:	89 50 04             	mov    %edx,0x4(%eax)
  803b26:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b29:	8b 00                	mov    (%eax),%eax
  803b2b:	85 c0                	test   %eax,%eax
  803b2d:	75 08                	jne    803b37 <realloc_block_FF+0x199>
  803b2f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b32:	a3 30 50 80 00       	mov    %eax,0x805030
  803b37:	a1 38 50 80 00       	mov    0x805038,%eax
  803b3c:	40                   	inc    %eax
  803b3d:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803b42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b46:	75 17                	jne    803b5f <realloc_block_FF+0x1c1>
  803b48:	83 ec 04             	sub    $0x4,%esp
  803b4b:	68 d7 4c 80 00       	push   $0x804cd7
  803b50:	68 f7 01 00 00       	push   $0x1f7
  803b55:	68 f5 4c 80 00       	push   $0x804cf5
  803b5a:	e8 63 cd ff ff       	call   8008c2 <_panic>
  803b5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b62:	8b 00                	mov    (%eax),%eax
  803b64:	85 c0                	test   %eax,%eax
  803b66:	74 10                	je     803b78 <realloc_block_FF+0x1da>
  803b68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b6b:	8b 00                	mov    (%eax),%eax
  803b6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b70:	8b 52 04             	mov    0x4(%edx),%edx
  803b73:	89 50 04             	mov    %edx,0x4(%eax)
  803b76:	eb 0b                	jmp    803b83 <realloc_block_FF+0x1e5>
  803b78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b7b:	8b 40 04             	mov    0x4(%eax),%eax
  803b7e:	a3 30 50 80 00       	mov    %eax,0x805030
  803b83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b86:	8b 40 04             	mov    0x4(%eax),%eax
  803b89:	85 c0                	test   %eax,%eax
  803b8b:	74 0f                	je     803b9c <realloc_block_FF+0x1fe>
  803b8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b90:	8b 40 04             	mov    0x4(%eax),%eax
  803b93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b96:	8b 12                	mov    (%edx),%edx
  803b98:	89 10                	mov    %edx,(%eax)
  803b9a:	eb 0a                	jmp    803ba6 <realloc_block_FF+0x208>
  803b9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b9f:	8b 00                	mov    (%eax),%eax
  803ba1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ba6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803baf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bb9:	a1 38 50 80 00       	mov    0x805038,%eax
  803bbe:	48                   	dec    %eax
  803bbf:	a3 38 50 80 00       	mov    %eax,0x805038
  803bc4:	e9 73 02 00 00       	jmp    803e3c <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803bc9:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803bcd:	0f 86 69 02 00 00    	jbe    803e3c <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803bd3:	83 ec 04             	sub    $0x4,%esp
  803bd6:	6a 01                	push   $0x1
  803bd8:	ff 75 f0             	pushl  -0x10(%ebp)
  803bdb:	ff 75 08             	pushl  0x8(%ebp)
  803bde:	e8 eb ed ff ff       	call   8029ce <set_block_data>
  803be3:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803be6:	8b 45 08             	mov    0x8(%ebp),%eax
  803be9:	83 e8 04             	sub    $0x4,%eax
  803bec:	8b 00                	mov    (%eax),%eax
  803bee:	83 e0 fe             	and    $0xfffffffe,%eax
  803bf1:	89 c2                	mov    %eax,%edx
  803bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf6:	01 d0                	add    %edx,%eax
  803bf8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803bfb:	a1 38 50 80 00       	mov    0x805038,%eax
  803c00:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803c03:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803c07:	75 68                	jne    803c71 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c09:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c0d:	75 17                	jne    803c26 <realloc_block_FF+0x288>
  803c0f:	83 ec 04             	sub    $0x4,%esp
  803c12:	68 10 4d 80 00       	push   $0x804d10
  803c17:	68 06 02 00 00       	push   $0x206
  803c1c:	68 f5 4c 80 00       	push   $0x804cf5
  803c21:	e8 9c cc ff ff       	call   8008c2 <_panic>
  803c26:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803c2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c2f:	89 10                	mov    %edx,(%eax)
  803c31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c34:	8b 00                	mov    (%eax),%eax
  803c36:	85 c0                	test   %eax,%eax
  803c38:	74 0d                	je     803c47 <realloc_block_FF+0x2a9>
  803c3a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803c3f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c42:	89 50 04             	mov    %edx,0x4(%eax)
  803c45:	eb 08                	jmp    803c4f <realloc_block_FF+0x2b1>
  803c47:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c4a:	a3 30 50 80 00       	mov    %eax,0x805030
  803c4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c52:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803c57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c61:	a1 38 50 80 00       	mov    0x805038,%eax
  803c66:	40                   	inc    %eax
  803c67:	a3 38 50 80 00       	mov    %eax,0x805038
  803c6c:	e9 b0 01 00 00       	jmp    803e21 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803c71:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803c76:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c79:	76 68                	jbe    803ce3 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c7b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c7f:	75 17                	jne    803c98 <realloc_block_FF+0x2fa>
  803c81:	83 ec 04             	sub    $0x4,%esp
  803c84:	68 10 4d 80 00       	push   $0x804d10
  803c89:	68 0b 02 00 00       	push   $0x20b
  803c8e:	68 f5 4c 80 00       	push   $0x804cf5
  803c93:	e8 2a cc ff ff       	call   8008c2 <_panic>
  803c98:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803c9e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca1:	89 10                	mov    %edx,(%eax)
  803ca3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca6:	8b 00                	mov    (%eax),%eax
  803ca8:	85 c0                	test   %eax,%eax
  803caa:	74 0d                	je     803cb9 <realloc_block_FF+0x31b>
  803cac:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803cb1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cb4:	89 50 04             	mov    %edx,0x4(%eax)
  803cb7:	eb 08                	jmp    803cc1 <realloc_block_FF+0x323>
  803cb9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cbc:	a3 30 50 80 00       	mov    %eax,0x805030
  803cc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803cc9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ccc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cd3:	a1 38 50 80 00       	mov    0x805038,%eax
  803cd8:	40                   	inc    %eax
  803cd9:	a3 38 50 80 00       	mov    %eax,0x805038
  803cde:	e9 3e 01 00 00       	jmp    803e21 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803ce3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803ce8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ceb:	73 68                	jae    803d55 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ced:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cf1:	75 17                	jne    803d0a <realloc_block_FF+0x36c>
  803cf3:	83 ec 04             	sub    $0x4,%esp
  803cf6:	68 44 4d 80 00       	push   $0x804d44
  803cfb:	68 10 02 00 00       	push   $0x210
  803d00:	68 f5 4c 80 00       	push   $0x804cf5
  803d05:	e8 b8 cb ff ff       	call   8008c2 <_panic>
  803d0a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803d10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d13:	89 50 04             	mov    %edx,0x4(%eax)
  803d16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d19:	8b 40 04             	mov    0x4(%eax),%eax
  803d1c:	85 c0                	test   %eax,%eax
  803d1e:	74 0c                	je     803d2c <realloc_block_FF+0x38e>
  803d20:	a1 30 50 80 00       	mov    0x805030,%eax
  803d25:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d28:	89 10                	mov    %edx,(%eax)
  803d2a:	eb 08                	jmp    803d34 <realloc_block_FF+0x396>
  803d2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d2f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803d34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d37:	a3 30 50 80 00       	mov    %eax,0x805030
  803d3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d45:	a1 38 50 80 00       	mov    0x805038,%eax
  803d4a:	40                   	inc    %eax
  803d4b:	a3 38 50 80 00       	mov    %eax,0x805038
  803d50:	e9 cc 00 00 00       	jmp    803e21 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803d55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803d5c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803d61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d64:	e9 8a 00 00 00       	jmp    803df3 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d6f:	73 7a                	jae    803deb <realloc_block_FF+0x44d>
  803d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d74:	8b 00                	mov    (%eax),%eax
  803d76:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d79:	73 70                	jae    803deb <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803d7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d7f:	74 06                	je     803d87 <realloc_block_FF+0x3e9>
  803d81:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d85:	75 17                	jne    803d9e <realloc_block_FF+0x400>
  803d87:	83 ec 04             	sub    $0x4,%esp
  803d8a:	68 68 4d 80 00       	push   $0x804d68
  803d8f:	68 1a 02 00 00       	push   $0x21a
  803d94:	68 f5 4c 80 00       	push   $0x804cf5
  803d99:	e8 24 cb ff ff       	call   8008c2 <_panic>
  803d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da1:	8b 10                	mov    (%eax),%edx
  803da3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803da6:	89 10                	mov    %edx,(%eax)
  803da8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dab:	8b 00                	mov    (%eax),%eax
  803dad:	85 c0                	test   %eax,%eax
  803daf:	74 0b                	je     803dbc <realloc_block_FF+0x41e>
  803db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db4:	8b 00                	mov    (%eax),%eax
  803db6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803db9:	89 50 04             	mov    %edx,0x4(%eax)
  803dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dbf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dc2:	89 10                	mov    %edx,(%eax)
  803dc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803dca:	89 50 04             	mov    %edx,0x4(%eax)
  803dcd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dd0:	8b 00                	mov    (%eax),%eax
  803dd2:	85 c0                	test   %eax,%eax
  803dd4:	75 08                	jne    803dde <realloc_block_FF+0x440>
  803dd6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dd9:	a3 30 50 80 00       	mov    %eax,0x805030
  803dde:	a1 38 50 80 00       	mov    0x805038,%eax
  803de3:	40                   	inc    %eax
  803de4:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803de9:	eb 36                	jmp    803e21 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803deb:	a1 34 50 80 00       	mov    0x805034,%eax
  803df0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803df3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803df7:	74 07                	je     803e00 <realloc_block_FF+0x462>
  803df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dfc:	8b 00                	mov    (%eax),%eax
  803dfe:	eb 05                	jmp    803e05 <realloc_block_FF+0x467>
  803e00:	b8 00 00 00 00       	mov    $0x0,%eax
  803e05:	a3 34 50 80 00       	mov    %eax,0x805034
  803e0a:	a1 34 50 80 00       	mov    0x805034,%eax
  803e0f:	85 c0                	test   %eax,%eax
  803e11:	0f 85 52 ff ff ff    	jne    803d69 <realloc_block_FF+0x3cb>
  803e17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e1b:	0f 85 48 ff ff ff    	jne    803d69 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803e21:	83 ec 04             	sub    $0x4,%esp
  803e24:	6a 00                	push   $0x0
  803e26:	ff 75 d8             	pushl  -0x28(%ebp)
  803e29:	ff 75 d4             	pushl  -0x2c(%ebp)
  803e2c:	e8 9d eb ff ff       	call   8029ce <set_block_data>
  803e31:	83 c4 10             	add    $0x10,%esp
				return va;
  803e34:	8b 45 08             	mov    0x8(%ebp),%eax
  803e37:	e9 6b 02 00 00       	jmp    8040a7 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e3f:	e9 63 02 00 00       	jmp    8040a7 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e47:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803e4a:	0f 86 4d 02 00 00    	jbe    80409d <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803e50:	83 ec 0c             	sub    $0xc,%esp
  803e53:	ff 75 e4             	pushl  -0x1c(%ebp)
  803e56:	e8 3b e8 ff ff       	call   802696 <is_free_block>
  803e5b:	83 c4 10             	add    $0x10,%esp
  803e5e:	84 c0                	test   %al,%al
  803e60:	0f 84 37 02 00 00    	je     80409d <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e69:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803e6c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803e6f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e72:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803e75:	76 38                	jbe    803eaf <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803e77:	83 ec 0c             	sub    $0xc,%esp
  803e7a:	ff 75 0c             	pushl  0xc(%ebp)
  803e7d:	e8 7b eb ff ff       	call   8029fd <alloc_block_FF>
  803e82:	83 c4 10             	add    $0x10,%esp
  803e85:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803e88:	83 ec 08             	sub    $0x8,%esp
  803e8b:	ff 75 c0             	pushl  -0x40(%ebp)
  803e8e:	ff 75 08             	pushl  0x8(%ebp)
  803e91:	e8 c9 fa ff ff       	call   80395f <copy_data>
  803e96:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803e99:	83 ec 0c             	sub    $0xc,%esp
  803e9c:	ff 75 08             	pushl  0x8(%ebp)
  803e9f:	e8 fa f9 ff ff       	call   80389e <free_block>
  803ea4:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803ea7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803eaa:	e9 f8 01 00 00       	jmp    8040a7 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803eaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803eb2:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803eb5:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803eb8:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803ebc:	0f 87 a0 00 00 00    	ja     803f62 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803ec2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ec6:	75 17                	jne    803edf <realloc_block_FF+0x541>
  803ec8:	83 ec 04             	sub    $0x4,%esp
  803ecb:	68 d7 4c 80 00       	push   $0x804cd7
  803ed0:	68 38 02 00 00       	push   $0x238
  803ed5:	68 f5 4c 80 00       	push   $0x804cf5
  803eda:	e8 e3 c9 ff ff       	call   8008c2 <_panic>
  803edf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee2:	8b 00                	mov    (%eax),%eax
  803ee4:	85 c0                	test   %eax,%eax
  803ee6:	74 10                	je     803ef8 <realloc_block_FF+0x55a>
  803ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eeb:	8b 00                	mov    (%eax),%eax
  803eed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ef0:	8b 52 04             	mov    0x4(%edx),%edx
  803ef3:	89 50 04             	mov    %edx,0x4(%eax)
  803ef6:	eb 0b                	jmp    803f03 <realloc_block_FF+0x565>
  803ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803efb:	8b 40 04             	mov    0x4(%eax),%eax
  803efe:	a3 30 50 80 00       	mov    %eax,0x805030
  803f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f06:	8b 40 04             	mov    0x4(%eax),%eax
  803f09:	85 c0                	test   %eax,%eax
  803f0b:	74 0f                	je     803f1c <realloc_block_FF+0x57e>
  803f0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f10:	8b 40 04             	mov    0x4(%eax),%eax
  803f13:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f16:	8b 12                	mov    (%edx),%edx
  803f18:	89 10                	mov    %edx,(%eax)
  803f1a:	eb 0a                	jmp    803f26 <realloc_block_FF+0x588>
  803f1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f1f:	8b 00                	mov    (%eax),%eax
  803f21:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f39:	a1 38 50 80 00       	mov    0x805038,%eax
  803f3e:	48                   	dec    %eax
  803f3f:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803f44:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f4a:	01 d0                	add    %edx,%eax
  803f4c:	83 ec 04             	sub    $0x4,%esp
  803f4f:	6a 01                	push   $0x1
  803f51:	50                   	push   %eax
  803f52:	ff 75 08             	pushl  0x8(%ebp)
  803f55:	e8 74 ea ff ff       	call   8029ce <set_block_data>
  803f5a:	83 c4 10             	add    $0x10,%esp
  803f5d:	e9 36 01 00 00       	jmp    804098 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803f62:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f65:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f68:	01 d0                	add    %edx,%eax
  803f6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803f6d:	83 ec 04             	sub    $0x4,%esp
  803f70:	6a 01                	push   $0x1
  803f72:	ff 75 f0             	pushl  -0x10(%ebp)
  803f75:	ff 75 08             	pushl  0x8(%ebp)
  803f78:	e8 51 ea ff ff       	call   8029ce <set_block_data>
  803f7d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803f80:	8b 45 08             	mov    0x8(%ebp),%eax
  803f83:	83 e8 04             	sub    $0x4,%eax
  803f86:	8b 00                	mov    (%eax),%eax
  803f88:	83 e0 fe             	and    $0xfffffffe,%eax
  803f8b:	89 c2                	mov    %eax,%edx
  803f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  803f90:	01 d0                	add    %edx,%eax
  803f92:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803f95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f99:	74 06                	je     803fa1 <realloc_block_FF+0x603>
  803f9b:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803f9f:	75 17                	jne    803fb8 <realloc_block_FF+0x61a>
  803fa1:	83 ec 04             	sub    $0x4,%esp
  803fa4:	68 68 4d 80 00       	push   $0x804d68
  803fa9:	68 44 02 00 00       	push   $0x244
  803fae:	68 f5 4c 80 00       	push   $0x804cf5
  803fb3:	e8 0a c9 ff ff       	call   8008c2 <_panic>
  803fb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fbb:	8b 10                	mov    (%eax),%edx
  803fbd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fc0:	89 10                	mov    %edx,(%eax)
  803fc2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fc5:	8b 00                	mov    (%eax),%eax
  803fc7:	85 c0                	test   %eax,%eax
  803fc9:	74 0b                	je     803fd6 <realloc_block_FF+0x638>
  803fcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fce:	8b 00                	mov    (%eax),%eax
  803fd0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803fd3:	89 50 04             	mov    %edx,0x4(%eax)
  803fd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803fdc:	89 10                	mov    %edx,(%eax)
  803fde:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fe1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fe4:	89 50 04             	mov    %edx,0x4(%eax)
  803fe7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fea:	8b 00                	mov    (%eax),%eax
  803fec:	85 c0                	test   %eax,%eax
  803fee:	75 08                	jne    803ff8 <realloc_block_FF+0x65a>
  803ff0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ff3:	a3 30 50 80 00       	mov    %eax,0x805030
  803ff8:	a1 38 50 80 00       	mov    0x805038,%eax
  803ffd:	40                   	inc    %eax
  803ffe:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804003:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804007:	75 17                	jne    804020 <realloc_block_FF+0x682>
  804009:	83 ec 04             	sub    $0x4,%esp
  80400c:	68 d7 4c 80 00       	push   $0x804cd7
  804011:	68 45 02 00 00       	push   $0x245
  804016:	68 f5 4c 80 00       	push   $0x804cf5
  80401b:	e8 a2 c8 ff ff       	call   8008c2 <_panic>
  804020:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804023:	8b 00                	mov    (%eax),%eax
  804025:	85 c0                	test   %eax,%eax
  804027:	74 10                	je     804039 <realloc_block_FF+0x69b>
  804029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80402c:	8b 00                	mov    (%eax),%eax
  80402e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804031:	8b 52 04             	mov    0x4(%edx),%edx
  804034:	89 50 04             	mov    %edx,0x4(%eax)
  804037:	eb 0b                	jmp    804044 <realloc_block_FF+0x6a6>
  804039:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80403c:	8b 40 04             	mov    0x4(%eax),%eax
  80403f:	a3 30 50 80 00       	mov    %eax,0x805030
  804044:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804047:	8b 40 04             	mov    0x4(%eax),%eax
  80404a:	85 c0                	test   %eax,%eax
  80404c:	74 0f                	je     80405d <realloc_block_FF+0x6bf>
  80404e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804051:	8b 40 04             	mov    0x4(%eax),%eax
  804054:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804057:	8b 12                	mov    (%edx),%edx
  804059:	89 10                	mov    %edx,(%eax)
  80405b:	eb 0a                	jmp    804067 <realloc_block_FF+0x6c9>
  80405d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804060:	8b 00                	mov    (%eax),%eax
  804062:	a3 2c 50 80 00       	mov    %eax,0x80502c
  804067:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80406a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804070:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804073:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80407a:	a1 38 50 80 00       	mov    0x805038,%eax
  80407f:	48                   	dec    %eax
  804080:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  804085:	83 ec 04             	sub    $0x4,%esp
  804088:	6a 00                	push   $0x0
  80408a:	ff 75 bc             	pushl  -0x44(%ebp)
  80408d:	ff 75 b8             	pushl  -0x48(%ebp)
  804090:	e8 39 e9 ff ff       	call   8029ce <set_block_data>
  804095:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804098:	8b 45 08             	mov    0x8(%ebp),%eax
  80409b:	eb 0a                	jmp    8040a7 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80409d:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8040a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8040a7:	c9                   	leave  
  8040a8:	c3                   	ret    

008040a9 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8040a9:	55                   	push   %ebp
  8040aa:	89 e5                	mov    %esp,%ebp
  8040ac:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8040af:	83 ec 04             	sub    $0x4,%esp
  8040b2:	68 d4 4d 80 00       	push   $0x804dd4
  8040b7:	68 58 02 00 00       	push   $0x258
  8040bc:	68 f5 4c 80 00       	push   $0x804cf5
  8040c1:	e8 fc c7 ff ff       	call   8008c2 <_panic>

008040c6 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8040c6:	55                   	push   %ebp
  8040c7:	89 e5                	mov    %esp,%ebp
  8040c9:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8040cc:	83 ec 04             	sub    $0x4,%esp
  8040cf:	68 fc 4d 80 00       	push   $0x804dfc
  8040d4:	68 61 02 00 00       	push   $0x261
  8040d9:	68 f5 4c 80 00       	push   $0x804cf5
  8040de:	e8 df c7 ff ff       	call   8008c2 <_panic>

008040e3 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8040e3:	55                   	push   %ebp
  8040e4:	89 e5                	mov    %esp,%ebp
  8040e6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8040e9:	83 ec 04             	sub    $0x4,%esp
  8040ec:	68 24 4e 80 00       	push   $0x804e24
  8040f1:	6a 09                	push   $0x9
  8040f3:	68 4c 4e 80 00       	push   $0x804e4c
  8040f8:	e8 c5 c7 ff ff       	call   8008c2 <_panic>

008040fd <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8040fd:	55                   	push   %ebp
  8040fe:	89 e5                	mov    %esp,%ebp
  804100:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  804103:	83 ec 04             	sub    $0x4,%esp
  804106:	68 5c 4e 80 00       	push   $0x804e5c
  80410b:	6a 10                	push   $0x10
  80410d:	68 4c 4e 80 00       	push   $0x804e4c
  804112:	e8 ab c7 ff ff       	call   8008c2 <_panic>

00804117 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  804117:	55                   	push   %ebp
  804118:	89 e5                	mov    %esp,%ebp
  80411a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  80411d:	83 ec 04             	sub    $0x4,%esp
  804120:	68 84 4e 80 00       	push   $0x804e84
  804125:	6a 18                	push   $0x18
  804127:	68 4c 4e 80 00       	push   $0x804e4c
  80412c:	e8 91 c7 ff ff       	call   8008c2 <_panic>

00804131 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  804131:	55                   	push   %ebp
  804132:	89 e5                	mov    %esp,%ebp
  804134:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  804137:	83 ec 04             	sub    $0x4,%esp
  80413a:	68 ac 4e 80 00       	push   $0x804eac
  80413f:	6a 20                	push   $0x20
  804141:	68 4c 4e 80 00       	push   $0x804e4c
  804146:	e8 77 c7 ff ff       	call   8008c2 <_panic>

0080414b <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  80414b:	55                   	push   %ebp
  80414c:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80414e:	8b 45 08             	mov    0x8(%ebp),%eax
  804151:	8b 40 10             	mov    0x10(%eax),%eax
}
  804154:	5d                   	pop    %ebp
  804155:	c3                   	ret    
  804156:	66 90                	xchg   %ax,%ax

00804158 <__udivdi3>:
  804158:	55                   	push   %ebp
  804159:	57                   	push   %edi
  80415a:	56                   	push   %esi
  80415b:	53                   	push   %ebx
  80415c:	83 ec 1c             	sub    $0x1c,%esp
  80415f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804163:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804167:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80416b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80416f:	89 ca                	mov    %ecx,%edx
  804171:	89 f8                	mov    %edi,%eax
  804173:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804177:	85 f6                	test   %esi,%esi
  804179:	75 2d                	jne    8041a8 <__udivdi3+0x50>
  80417b:	39 cf                	cmp    %ecx,%edi
  80417d:	77 65                	ja     8041e4 <__udivdi3+0x8c>
  80417f:	89 fd                	mov    %edi,%ebp
  804181:	85 ff                	test   %edi,%edi
  804183:	75 0b                	jne    804190 <__udivdi3+0x38>
  804185:	b8 01 00 00 00       	mov    $0x1,%eax
  80418a:	31 d2                	xor    %edx,%edx
  80418c:	f7 f7                	div    %edi
  80418e:	89 c5                	mov    %eax,%ebp
  804190:	31 d2                	xor    %edx,%edx
  804192:	89 c8                	mov    %ecx,%eax
  804194:	f7 f5                	div    %ebp
  804196:	89 c1                	mov    %eax,%ecx
  804198:	89 d8                	mov    %ebx,%eax
  80419a:	f7 f5                	div    %ebp
  80419c:	89 cf                	mov    %ecx,%edi
  80419e:	89 fa                	mov    %edi,%edx
  8041a0:	83 c4 1c             	add    $0x1c,%esp
  8041a3:	5b                   	pop    %ebx
  8041a4:	5e                   	pop    %esi
  8041a5:	5f                   	pop    %edi
  8041a6:	5d                   	pop    %ebp
  8041a7:	c3                   	ret    
  8041a8:	39 ce                	cmp    %ecx,%esi
  8041aa:	77 28                	ja     8041d4 <__udivdi3+0x7c>
  8041ac:	0f bd fe             	bsr    %esi,%edi
  8041af:	83 f7 1f             	xor    $0x1f,%edi
  8041b2:	75 40                	jne    8041f4 <__udivdi3+0x9c>
  8041b4:	39 ce                	cmp    %ecx,%esi
  8041b6:	72 0a                	jb     8041c2 <__udivdi3+0x6a>
  8041b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8041bc:	0f 87 9e 00 00 00    	ja     804260 <__udivdi3+0x108>
  8041c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8041c7:	89 fa                	mov    %edi,%edx
  8041c9:	83 c4 1c             	add    $0x1c,%esp
  8041cc:	5b                   	pop    %ebx
  8041cd:	5e                   	pop    %esi
  8041ce:	5f                   	pop    %edi
  8041cf:	5d                   	pop    %ebp
  8041d0:	c3                   	ret    
  8041d1:	8d 76 00             	lea    0x0(%esi),%esi
  8041d4:	31 ff                	xor    %edi,%edi
  8041d6:	31 c0                	xor    %eax,%eax
  8041d8:	89 fa                	mov    %edi,%edx
  8041da:	83 c4 1c             	add    $0x1c,%esp
  8041dd:	5b                   	pop    %ebx
  8041de:	5e                   	pop    %esi
  8041df:	5f                   	pop    %edi
  8041e0:	5d                   	pop    %ebp
  8041e1:	c3                   	ret    
  8041e2:	66 90                	xchg   %ax,%ax
  8041e4:	89 d8                	mov    %ebx,%eax
  8041e6:	f7 f7                	div    %edi
  8041e8:	31 ff                	xor    %edi,%edi
  8041ea:	89 fa                	mov    %edi,%edx
  8041ec:	83 c4 1c             	add    $0x1c,%esp
  8041ef:	5b                   	pop    %ebx
  8041f0:	5e                   	pop    %esi
  8041f1:	5f                   	pop    %edi
  8041f2:	5d                   	pop    %ebp
  8041f3:	c3                   	ret    
  8041f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8041f9:	89 eb                	mov    %ebp,%ebx
  8041fb:	29 fb                	sub    %edi,%ebx
  8041fd:	89 f9                	mov    %edi,%ecx
  8041ff:	d3 e6                	shl    %cl,%esi
  804201:	89 c5                	mov    %eax,%ebp
  804203:	88 d9                	mov    %bl,%cl
  804205:	d3 ed                	shr    %cl,%ebp
  804207:	89 e9                	mov    %ebp,%ecx
  804209:	09 f1                	or     %esi,%ecx
  80420b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80420f:	89 f9                	mov    %edi,%ecx
  804211:	d3 e0                	shl    %cl,%eax
  804213:	89 c5                	mov    %eax,%ebp
  804215:	89 d6                	mov    %edx,%esi
  804217:	88 d9                	mov    %bl,%cl
  804219:	d3 ee                	shr    %cl,%esi
  80421b:	89 f9                	mov    %edi,%ecx
  80421d:	d3 e2                	shl    %cl,%edx
  80421f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804223:	88 d9                	mov    %bl,%cl
  804225:	d3 e8                	shr    %cl,%eax
  804227:	09 c2                	or     %eax,%edx
  804229:	89 d0                	mov    %edx,%eax
  80422b:	89 f2                	mov    %esi,%edx
  80422d:	f7 74 24 0c          	divl   0xc(%esp)
  804231:	89 d6                	mov    %edx,%esi
  804233:	89 c3                	mov    %eax,%ebx
  804235:	f7 e5                	mul    %ebp
  804237:	39 d6                	cmp    %edx,%esi
  804239:	72 19                	jb     804254 <__udivdi3+0xfc>
  80423b:	74 0b                	je     804248 <__udivdi3+0xf0>
  80423d:	89 d8                	mov    %ebx,%eax
  80423f:	31 ff                	xor    %edi,%edi
  804241:	e9 58 ff ff ff       	jmp    80419e <__udivdi3+0x46>
  804246:	66 90                	xchg   %ax,%ax
  804248:	8b 54 24 08          	mov    0x8(%esp),%edx
  80424c:	89 f9                	mov    %edi,%ecx
  80424e:	d3 e2                	shl    %cl,%edx
  804250:	39 c2                	cmp    %eax,%edx
  804252:	73 e9                	jae    80423d <__udivdi3+0xe5>
  804254:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804257:	31 ff                	xor    %edi,%edi
  804259:	e9 40 ff ff ff       	jmp    80419e <__udivdi3+0x46>
  80425e:	66 90                	xchg   %ax,%ax
  804260:	31 c0                	xor    %eax,%eax
  804262:	e9 37 ff ff ff       	jmp    80419e <__udivdi3+0x46>
  804267:	90                   	nop

00804268 <__umoddi3>:
  804268:	55                   	push   %ebp
  804269:	57                   	push   %edi
  80426a:	56                   	push   %esi
  80426b:	53                   	push   %ebx
  80426c:	83 ec 1c             	sub    $0x1c,%esp
  80426f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804273:	8b 74 24 34          	mov    0x34(%esp),%esi
  804277:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80427b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80427f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804283:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804287:	89 f3                	mov    %esi,%ebx
  804289:	89 fa                	mov    %edi,%edx
  80428b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80428f:	89 34 24             	mov    %esi,(%esp)
  804292:	85 c0                	test   %eax,%eax
  804294:	75 1a                	jne    8042b0 <__umoddi3+0x48>
  804296:	39 f7                	cmp    %esi,%edi
  804298:	0f 86 a2 00 00 00    	jbe    804340 <__umoddi3+0xd8>
  80429e:	89 c8                	mov    %ecx,%eax
  8042a0:	89 f2                	mov    %esi,%edx
  8042a2:	f7 f7                	div    %edi
  8042a4:	89 d0                	mov    %edx,%eax
  8042a6:	31 d2                	xor    %edx,%edx
  8042a8:	83 c4 1c             	add    $0x1c,%esp
  8042ab:	5b                   	pop    %ebx
  8042ac:	5e                   	pop    %esi
  8042ad:	5f                   	pop    %edi
  8042ae:	5d                   	pop    %ebp
  8042af:	c3                   	ret    
  8042b0:	39 f0                	cmp    %esi,%eax
  8042b2:	0f 87 ac 00 00 00    	ja     804364 <__umoddi3+0xfc>
  8042b8:	0f bd e8             	bsr    %eax,%ebp
  8042bb:	83 f5 1f             	xor    $0x1f,%ebp
  8042be:	0f 84 ac 00 00 00    	je     804370 <__umoddi3+0x108>
  8042c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8042c9:	29 ef                	sub    %ebp,%edi
  8042cb:	89 fe                	mov    %edi,%esi
  8042cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8042d1:	89 e9                	mov    %ebp,%ecx
  8042d3:	d3 e0                	shl    %cl,%eax
  8042d5:	89 d7                	mov    %edx,%edi
  8042d7:	89 f1                	mov    %esi,%ecx
  8042d9:	d3 ef                	shr    %cl,%edi
  8042db:	09 c7                	or     %eax,%edi
  8042dd:	89 e9                	mov    %ebp,%ecx
  8042df:	d3 e2                	shl    %cl,%edx
  8042e1:	89 14 24             	mov    %edx,(%esp)
  8042e4:	89 d8                	mov    %ebx,%eax
  8042e6:	d3 e0                	shl    %cl,%eax
  8042e8:	89 c2                	mov    %eax,%edx
  8042ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042ee:	d3 e0                	shl    %cl,%eax
  8042f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8042f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042f8:	89 f1                	mov    %esi,%ecx
  8042fa:	d3 e8                	shr    %cl,%eax
  8042fc:	09 d0                	or     %edx,%eax
  8042fe:	d3 eb                	shr    %cl,%ebx
  804300:	89 da                	mov    %ebx,%edx
  804302:	f7 f7                	div    %edi
  804304:	89 d3                	mov    %edx,%ebx
  804306:	f7 24 24             	mull   (%esp)
  804309:	89 c6                	mov    %eax,%esi
  80430b:	89 d1                	mov    %edx,%ecx
  80430d:	39 d3                	cmp    %edx,%ebx
  80430f:	0f 82 87 00 00 00    	jb     80439c <__umoddi3+0x134>
  804315:	0f 84 91 00 00 00    	je     8043ac <__umoddi3+0x144>
  80431b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80431f:	29 f2                	sub    %esi,%edx
  804321:	19 cb                	sbb    %ecx,%ebx
  804323:	89 d8                	mov    %ebx,%eax
  804325:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804329:	d3 e0                	shl    %cl,%eax
  80432b:	89 e9                	mov    %ebp,%ecx
  80432d:	d3 ea                	shr    %cl,%edx
  80432f:	09 d0                	or     %edx,%eax
  804331:	89 e9                	mov    %ebp,%ecx
  804333:	d3 eb                	shr    %cl,%ebx
  804335:	89 da                	mov    %ebx,%edx
  804337:	83 c4 1c             	add    $0x1c,%esp
  80433a:	5b                   	pop    %ebx
  80433b:	5e                   	pop    %esi
  80433c:	5f                   	pop    %edi
  80433d:	5d                   	pop    %ebp
  80433e:	c3                   	ret    
  80433f:	90                   	nop
  804340:	89 fd                	mov    %edi,%ebp
  804342:	85 ff                	test   %edi,%edi
  804344:	75 0b                	jne    804351 <__umoddi3+0xe9>
  804346:	b8 01 00 00 00       	mov    $0x1,%eax
  80434b:	31 d2                	xor    %edx,%edx
  80434d:	f7 f7                	div    %edi
  80434f:	89 c5                	mov    %eax,%ebp
  804351:	89 f0                	mov    %esi,%eax
  804353:	31 d2                	xor    %edx,%edx
  804355:	f7 f5                	div    %ebp
  804357:	89 c8                	mov    %ecx,%eax
  804359:	f7 f5                	div    %ebp
  80435b:	89 d0                	mov    %edx,%eax
  80435d:	e9 44 ff ff ff       	jmp    8042a6 <__umoddi3+0x3e>
  804362:	66 90                	xchg   %ax,%ax
  804364:	89 c8                	mov    %ecx,%eax
  804366:	89 f2                	mov    %esi,%edx
  804368:	83 c4 1c             	add    $0x1c,%esp
  80436b:	5b                   	pop    %ebx
  80436c:	5e                   	pop    %esi
  80436d:	5f                   	pop    %edi
  80436e:	5d                   	pop    %ebp
  80436f:	c3                   	ret    
  804370:	3b 04 24             	cmp    (%esp),%eax
  804373:	72 06                	jb     80437b <__umoddi3+0x113>
  804375:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804379:	77 0f                	ja     80438a <__umoddi3+0x122>
  80437b:	89 f2                	mov    %esi,%edx
  80437d:	29 f9                	sub    %edi,%ecx
  80437f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804383:	89 14 24             	mov    %edx,(%esp)
  804386:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80438a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80438e:	8b 14 24             	mov    (%esp),%edx
  804391:	83 c4 1c             	add    $0x1c,%esp
  804394:	5b                   	pop    %ebx
  804395:	5e                   	pop    %esi
  804396:	5f                   	pop    %edi
  804397:	5d                   	pop    %ebp
  804398:	c3                   	ret    
  804399:	8d 76 00             	lea    0x0(%esi),%esi
  80439c:	2b 04 24             	sub    (%esp),%eax
  80439f:	19 fa                	sbb    %edi,%edx
  8043a1:	89 d1                	mov    %edx,%ecx
  8043a3:	89 c6                	mov    %eax,%esi
  8043a5:	e9 71 ff ff ff       	jmp    80431b <__umoddi3+0xb3>
  8043aa:	66 90                	xchg   %ax,%ax
  8043ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8043b0:	72 ea                	jb     80439c <__umoddi3+0x134>
  8043b2:	89 d9                	mov    %ebx,%ecx
  8043b4:	e9 62 ff ff ff       	jmp    80431b <__umoddi3+0xb3>
