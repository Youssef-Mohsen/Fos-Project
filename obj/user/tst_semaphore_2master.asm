
obj/user/tst_semaphore_2master:     file format elf32-i386


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
  800031:	e8 a9 01 00 00       	call   8001df <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: take user input, create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 38 01 00 00    	sub    $0x138,%esp
	int envID = sys_getenvid();
  800041:	e8 ff 17 00 00       	call   801845 <sys_getenvid>
  800046:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char line[256] ;
	readline("Enter total number of customers: ", line) ;
  800049:	83 ec 08             	sub    $0x8,%esp
  80004c:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  800052:	50                   	push   %eax
  800053:	68 80 1f 80 00       	push   $0x801f80
  800058:	e8 0a 0c 00 00       	call   800c67 <readline>
  80005d:	83 c4 10             	add    $0x10,%esp
	int totalNumOfCusts = strtol(line, NULL, 10);
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	6a 0a                	push   $0xa
  800065:	6a 00                	push   $0x0
  800067:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  80006d:	50                   	push   %eax
  80006e:	e8 5c 11 00 00       	call   8011cf <strtol>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	readline("Enter shop capacity: ", line) ;
  800079:	83 ec 08             	sub    $0x8,%esp
  80007c:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  800082:	50                   	push   %eax
  800083:	68 a2 1f 80 00       	push   $0x801fa2
  800088:	e8 da 0b 00 00       	call   800c67 <readline>
  80008d:	83 c4 10             	add    $0x10,%esp
	int shopCapacity = strtol(line, NULL, 10);
  800090:	83 ec 04             	sub    $0x4,%esp
  800093:	6a 0a                	push   $0xa
  800095:	6a 00                	push   $0x0
  800097:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  80009d:	50                   	push   %eax
  80009e:	e8 2c 11 00 00       	call   8011cf <strtol>
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct semaphore shopCapacitySem = create_semaphore("shopCapacity", shopCapacity);
  8000a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000ac:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	52                   	push   %edx
  8000b6:	68 b8 1f 80 00       	push   $0x801fb8
  8000bb:	50                   	push   %eax
  8000bc:	e8 dd 1a 00 00       	call   801b9e <create_semaphore>
  8000c1:	83 c4 0c             	add    $0xc,%esp
	struct semaphore dependSem = create_semaphore("depend", 0);
  8000c4:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	6a 00                	push   $0x0
  8000cf:	68 c5 1f 80 00       	push   $0x801fc5
  8000d4:	50                   	push   %eax
  8000d5:	e8 c4 1a 00 00       	call   801b9e <create_semaphore>
  8000da:	83 c4 0c             	add    $0xc,%esp

	int i = 0 ;
  8000dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int id ;
	for (; i<totalNumOfCusts; i++)
  8000e4:	eb 61                	jmp    800147 <_main+0x10f>
	{
		id = sys_create_env("sem2Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000e6:	a1 04 30 80 00       	mov    0x803004,%eax
  8000eb:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  8000f1:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f6:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  8000fc:	89 c1                	mov    %eax,%ecx
  8000fe:	a1 04 30 80 00       	mov    0x803004,%eax
  800103:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800109:	52                   	push   %edx
  80010a:	51                   	push   %ecx
  80010b:	50                   	push   %eax
  80010c:	68 cc 1f 80 00       	push   $0x801fcc
  800111:	e8 da 16 00 00       	call   8017f0 <sys_create_env>
  800116:	83 c4 10             	add    $0x10,%esp
  800119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (id == E_ENV_CREATION_ERROR)
  80011c:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800120:	75 14                	jne    800136 <_main+0xfe>
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
  800122:	83 ec 04             	sub    $0x4,%esp
  800125:	68 d8 1f 80 00       	push   $0x801fd8
  80012a:	6a 18                	push   $0x18
  80012c:	68 24 20 80 00       	push   $0x802024
  800131:	e8 e0 01 00 00       	call   800316 <_panic>
		sys_run_env(id) ;
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	ff 75 e4             	pushl  -0x1c(%ebp)
  80013c:	e8 cd 16 00 00       	call   80180e <sys_run_env>
  800141:	83 c4 10             	add    $0x10,%esp
	struct semaphore shopCapacitySem = create_semaphore("shopCapacity", shopCapacity);
	struct semaphore dependSem = create_semaphore("depend", 0);

	int i = 0 ;
	int id ;
	for (; i<totalNumOfCusts; i++)
  800144:	ff 45 f4             	incl   -0xc(%ebp)
  800147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80014a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80014d:	7c 97                	jl     8000e6 <_main+0xae>
		if (id == E_ENV_CREATION_ERROR)
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
		sys_run_env(id) ;
	}

	for (i = 0 ; i<totalNumOfCusts; i++)
  80014f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800156:	eb 14                	jmp    80016c <_main+0x134>
	{
		wait_semaphore(dependSem);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff b5 d4 fe ff ff    	pushl  -0x12c(%ebp)
  800161:	e8 6c 1a 00 00       	call   801bd2 <wait_semaphore>
  800166:	83 c4 10             	add    $0x10,%esp
		if (id == E_ENV_CREATION_ERROR)
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
		sys_run_env(id) ;
	}

	for (i = 0 ; i<totalNumOfCusts; i++)
  800169:	ff 45 f4             	incl   -0xc(%ebp)
  80016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80016f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800172:	7c e4                	jl     800158 <_main+0x120>
	{
		wait_semaphore(dependSem);
	}
	int sem1val = semaphore_count(shopCapacitySem);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff b5 d8 fe ff ff    	pushl  -0x128(%ebp)
  80017d:	e8 84 1a 00 00       	call   801c06 <semaphore_count>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int sem2val = semaphore_count(dependSem);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff b5 d4 fe ff ff    	pushl  -0x12c(%ebp)
  800191:	e8 70 1a 00 00       	call   801c06 <semaphore_count>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//wait a while to allow the slaves to finish printing their closing messages
	env_sleep(10000);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	68 10 27 00 00       	push   $0x2710
  8001a4:	e8 68 1a 00 00       	call   801c11 <env_sleep>
  8001a9:	83 c4 10             	add    $0x10,%esp
	if (sem2val == 0 && sem1val == shopCapacity)
  8001ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001b0:	75 1a                	jne    8001cc <_main+0x194>
  8001b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8001b8:	75 12                	jne    8001cc <_main+0x194>
		cprintf("\nCongratulations!! Test of Semaphores [2] completed successfully!!\n\n\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 44 20 80 00       	push   $0x802044
  8001c2:	e8 0c 04 00 00       	call   8005d3 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp
  8001ca:	eb 10                	jmp    8001dc <_main+0x1a4>
	else
		cprintf("\nError: wrong semaphore value... please review your semaphore code again...\n");
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	68 8c 20 80 00       	push   $0x80208c
  8001d4:	e8 fa 03 00 00       	call   8005d3 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp

	return;
  8001dc:	90                   	nop
}
  8001dd:	c9                   	leave  
  8001de:	c3                   	ret    

008001df <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001df:	55                   	push   %ebp
  8001e0:	89 e5                	mov    %esp,%ebp
  8001e2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001e5:	e8 74 16 00 00       	call   80185e <sys_getenvindex>
  8001ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001f0:	89 d0                	mov    %edx,%eax
  8001f2:	c1 e0 02             	shl    $0x2,%eax
  8001f5:	01 d0                	add    %edx,%eax
  8001f7:	01 c0                	add    %eax,%eax
  8001f9:	01 d0                	add    %edx,%eax
  8001fb:	c1 e0 02             	shl    $0x2,%eax
  8001fe:	01 d0                	add    %edx,%eax
  800200:	01 c0                	add    %eax,%eax
  800202:	01 d0                	add    %edx,%eax
  800204:	c1 e0 04             	shl    $0x4,%eax
  800207:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80020c:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800211:	a1 04 30 80 00       	mov    0x803004,%eax
  800216:	8a 40 20             	mov    0x20(%eax),%al
  800219:	84 c0                	test   %al,%al
  80021b:	74 0d                	je     80022a <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80021d:	a1 04 30 80 00       	mov    0x803004,%eax
  800222:	83 c0 20             	add    $0x20,%eax
  800225:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80022a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80022e:	7e 0a                	jle    80023a <libmain+0x5b>
		binaryname = argv[0];
  800230:	8b 45 0c             	mov    0xc(%ebp),%eax
  800233:	8b 00                	mov    (%eax),%eax
  800235:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80023a:	83 ec 08             	sub    $0x8,%esp
  80023d:	ff 75 0c             	pushl  0xc(%ebp)
  800240:	ff 75 08             	pushl  0x8(%ebp)
  800243:	e8 f0 fd ff ff       	call   800038 <_main>
  800248:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80024b:	e8 92 13 00 00       	call   8015e2 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	68 f4 20 80 00       	push   $0x8020f4
  800258:	e8 76 03 00 00       	call   8005d3 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800260:	a1 04 30 80 00       	mov    0x803004,%eax
  800265:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80026b:	a1 04 30 80 00       	mov    0x803004,%eax
  800270:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800276:	83 ec 04             	sub    $0x4,%esp
  800279:	52                   	push   %edx
  80027a:	50                   	push   %eax
  80027b:	68 1c 21 80 00       	push   $0x80211c
  800280:	e8 4e 03 00 00       	call   8005d3 <cprintf>
  800285:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800288:	a1 04 30 80 00       	mov    0x803004,%eax
  80028d:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800293:	a1 04 30 80 00       	mov    0x803004,%eax
  800298:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  80029e:	a1 04 30 80 00       	mov    0x803004,%eax
  8002a3:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8002a9:	51                   	push   %ecx
  8002aa:	52                   	push   %edx
  8002ab:	50                   	push   %eax
  8002ac:	68 44 21 80 00       	push   $0x802144
  8002b1:	e8 1d 03 00 00       	call   8005d3 <cprintf>
  8002b6:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002b9:	a1 04 30 80 00       	mov    0x803004,%eax
  8002be:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8002c4:	83 ec 08             	sub    $0x8,%esp
  8002c7:	50                   	push   %eax
  8002c8:	68 9c 21 80 00       	push   $0x80219c
  8002cd:	e8 01 03 00 00       	call   8005d3 <cprintf>
  8002d2:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002d5:	83 ec 0c             	sub    $0xc,%esp
  8002d8:	68 f4 20 80 00       	push   $0x8020f4
  8002dd:	e8 f1 02 00 00       	call   8005d3 <cprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002e5:	e8 12 13 00 00       	call   8015fc <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8002ea:	e8 19 00 00 00       	call   800308 <exit>
}
  8002ef:	90                   	nop
  8002f0:	c9                   	leave  
  8002f1:	c3                   	ret    

008002f2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002f8:	83 ec 0c             	sub    $0xc,%esp
  8002fb:	6a 00                	push   $0x0
  8002fd:	e8 28 15 00 00       	call   80182a <sys_destroy_env>
  800302:	83 c4 10             	add    $0x10,%esp
}
  800305:	90                   	nop
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <exit>:

void
exit(void)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80030e:	e8 7d 15 00 00       	call   801890 <sys_exit_env>
}
  800313:	90                   	nop
  800314:	c9                   	leave  
  800315:	c3                   	ret    

00800316 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80031c:	8d 45 10             	lea    0x10(%ebp),%eax
  80031f:	83 c0 04             	add    $0x4,%eax
  800322:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800325:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80032a:	85 c0                	test   %eax,%eax
  80032c:	74 16                	je     800344 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80032e:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	50                   	push   %eax
  800337:	68 b0 21 80 00       	push   $0x8021b0
  80033c:	e8 92 02 00 00       	call   8005d3 <cprintf>
  800341:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800344:	a1 00 30 80 00       	mov    0x803000,%eax
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	50                   	push   %eax
  800350:	68 b5 21 80 00       	push   $0x8021b5
  800355:	e8 79 02 00 00       	call   8005d3 <cprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80035d:	8b 45 10             	mov    0x10(%ebp),%eax
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	ff 75 f4             	pushl  -0xc(%ebp)
  800366:	50                   	push   %eax
  800367:	e8 fc 01 00 00       	call   800568 <vcprintf>
  80036c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80036f:	83 ec 08             	sub    $0x8,%esp
  800372:	6a 00                	push   $0x0
  800374:	68 d1 21 80 00       	push   $0x8021d1
  800379:	e8 ea 01 00 00       	call   800568 <vcprintf>
  80037e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800381:	e8 82 ff ff ff       	call   800308 <exit>

	// should not return here
	while (1) ;
  800386:	eb fe                	jmp    800386 <_panic+0x70>

00800388 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80038e:	a1 04 30 80 00       	mov    0x803004,%eax
  800393:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800399:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039c:	39 c2                	cmp    %eax,%edx
  80039e:	74 14                	je     8003b4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003a0:	83 ec 04             	sub    $0x4,%esp
  8003a3:	68 d4 21 80 00       	push   $0x8021d4
  8003a8:	6a 26                	push   $0x26
  8003aa:	68 20 22 80 00       	push   $0x802220
  8003af:	e8 62 ff ff ff       	call   800316 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003c2:	e9 c5 00 00 00       	jmp    80048c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	01 d0                	add    %edx,%eax
  8003d6:	8b 00                	mov    (%eax),%eax
  8003d8:	85 c0                	test   %eax,%eax
  8003da:	75 08                	jne    8003e4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003dc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003df:	e9 a5 00 00 00       	jmp    800489 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003eb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003f2:	eb 69                	jmp    80045d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003f4:	a1 04 30 80 00       	mov    0x803004,%eax
  8003f9:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8003ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800402:	89 d0                	mov    %edx,%eax
  800404:	01 c0                	add    %eax,%eax
  800406:	01 d0                	add    %edx,%eax
  800408:	c1 e0 03             	shl    $0x3,%eax
  80040b:	01 c8                	add    %ecx,%eax
  80040d:	8a 40 04             	mov    0x4(%eax),%al
  800410:	84 c0                	test   %al,%al
  800412:	75 46                	jne    80045a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800414:	a1 04 30 80 00       	mov    0x803004,%eax
  800419:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80041f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800422:	89 d0                	mov    %edx,%eax
  800424:	01 c0                	add    %eax,%eax
  800426:	01 d0                	add    %edx,%eax
  800428:	c1 e0 03             	shl    $0x3,%eax
  80042b:	01 c8                	add    %ecx,%eax
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800432:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800435:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80043a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80043c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	01 c8                	add    %ecx,%eax
  80044b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80044d:	39 c2                	cmp    %eax,%edx
  80044f:	75 09                	jne    80045a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800451:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800458:	eb 15                	jmp    80046f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80045a:	ff 45 e8             	incl   -0x18(%ebp)
  80045d:	a1 04 30 80 00       	mov    0x803004,%eax
  800462:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800468:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80046b:	39 c2                	cmp    %eax,%edx
  80046d:	77 85                	ja     8003f4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80046f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800473:	75 14                	jne    800489 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 2c 22 80 00       	push   $0x80222c
  80047d:	6a 3a                	push   $0x3a
  80047f:	68 20 22 80 00       	push   $0x802220
  800484:	e8 8d fe ff ff       	call   800316 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800489:	ff 45 f0             	incl   -0x10(%ebp)
  80048c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800492:	0f 8c 2f ff ff ff    	jl     8003c7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800498:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80049f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004a6:	eb 26                	jmp    8004ce <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004a8:	a1 04 30 80 00       	mov    0x803004,%eax
  8004ad:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8004b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b6:	89 d0                	mov    %edx,%eax
  8004b8:	01 c0                	add    %eax,%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	c1 e0 03             	shl    $0x3,%eax
  8004bf:	01 c8                	add    %ecx,%eax
  8004c1:	8a 40 04             	mov    0x4(%eax),%al
  8004c4:	3c 01                	cmp    $0x1,%al
  8004c6:	75 03                	jne    8004cb <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004c8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004cb:	ff 45 e0             	incl   -0x20(%ebp)
  8004ce:	a1 04 30 80 00       	mov    0x803004,%eax
  8004d3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004dc:	39 c2                	cmp    %eax,%edx
  8004de:	77 c8                	ja     8004a8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004e6:	74 14                	je     8004fc <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004e8:	83 ec 04             	sub    $0x4,%esp
  8004eb:	68 80 22 80 00       	push   $0x802280
  8004f0:	6a 44                	push   $0x44
  8004f2:	68 20 22 80 00       	push   $0x802220
  8004f7:	e8 1a fe ff ff       	call   800316 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004fc:	90                   	nop
  8004fd:	c9                   	leave  
  8004fe:	c3                   	ret    

008004ff <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800505:	8b 45 0c             	mov    0xc(%ebp),%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	8d 48 01             	lea    0x1(%eax),%ecx
  80050d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800510:	89 0a                	mov    %ecx,(%edx)
  800512:	8b 55 08             	mov    0x8(%ebp),%edx
  800515:	88 d1                	mov    %dl,%cl
  800517:	8b 55 0c             	mov    0xc(%ebp),%edx
  80051a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80051e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800521:	8b 00                	mov    (%eax),%eax
  800523:	3d ff 00 00 00       	cmp    $0xff,%eax
  800528:	75 2c                	jne    800556 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80052a:	a0 08 30 80 00       	mov    0x803008,%al
  80052f:	0f b6 c0             	movzbl %al,%eax
  800532:	8b 55 0c             	mov    0xc(%ebp),%edx
  800535:	8b 12                	mov    (%edx),%edx
  800537:	89 d1                	mov    %edx,%ecx
  800539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053c:	83 c2 08             	add    $0x8,%edx
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	50                   	push   %eax
  800543:	51                   	push   %ecx
  800544:	52                   	push   %edx
  800545:	e8 56 10 00 00       	call   8015a0 <sys_cputs>
  80054a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80054d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800550:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800556:	8b 45 0c             	mov    0xc(%ebp),%eax
  800559:	8b 40 04             	mov    0x4(%eax),%eax
  80055c:	8d 50 01             	lea    0x1(%eax),%edx
  80055f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800562:	89 50 04             	mov    %edx,0x4(%eax)
}
  800565:	90                   	nop
  800566:	c9                   	leave  
  800567:	c3                   	ret    

00800568 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800568:	55                   	push   %ebp
  800569:	89 e5                	mov    %esp,%ebp
  80056b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800571:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800578:	00 00 00 
	b.cnt = 0;
  80057b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800582:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800585:	ff 75 0c             	pushl  0xc(%ebp)
  800588:	ff 75 08             	pushl  0x8(%ebp)
  80058b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800591:	50                   	push   %eax
  800592:	68 ff 04 80 00       	push   $0x8004ff
  800597:	e8 11 02 00 00       	call   8007ad <vprintfmt>
  80059c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80059f:	a0 08 30 80 00       	mov    0x803008,%al
  8005a4:	0f b6 c0             	movzbl %al,%eax
  8005a7:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005ad:	83 ec 04             	sub    $0x4,%esp
  8005b0:	50                   	push   %eax
  8005b1:	52                   	push   %edx
  8005b2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b8:	83 c0 08             	add    $0x8,%eax
  8005bb:	50                   	push   %eax
  8005bc:	e8 df 0f 00 00       	call   8015a0 <sys_cputs>
  8005c1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005c4:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8005cb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005d1:	c9                   	leave  
  8005d2:	c3                   	ret    

008005d3 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005d3:	55                   	push   %ebp
  8005d4:	89 e5                	mov    %esp,%ebp
  8005d6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d9:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8005e0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	83 ec 08             	sub    $0x8,%esp
  8005ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ef:	50                   	push   %eax
  8005f0:	e8 73 ff ff ff       	call   800568 <vcprintf>
  8005f5:	83 c4 10             	add    $0x10,%esp
  8005f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005fe:	c9                   	leave  
  8005ff:	c3                   	ret    

00800600 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800600:	55                   	push   %ebp
  800601:	89 e5                	mov    %esp,%ebp
  800603:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800606:	e8 d7 0f 00 00       	call   8015e2 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80060b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80060e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800611:	8b 45 08             	mov    0x8(%ebp),%eax
  800614:	83 ec 08             	sub    $0x8,%esp
  800617:	ff 75 f4             	pushl  -0xc(%ebp)
  80061a:	50                   	push   %eax
  80061b:	e8 48 ff ff ff       	call   800568 <vcprintf>
  800620:	83 c4 10             	add    $0x10,%esp
  800623:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800626:	e8 d1 0f 00 00       	call   8015fc <sys_unlock_cons>
	return cnt;
  80062b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80062e:	c9                   	leave  
  80062f:	c3                   	ret    

00800630 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800630:	55                   	push   %ebp
  800631:	89 e5                	mov    %esp,%ebp
  800633:	53                   	push   %ebx
  800634:	83 ec 14             	sub    $0x14,%esp
  800637:	8b 45 10             	mov    0x10(%ebp),%eax
  80063a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800643:	8b 45 18             	mov    0x18(%ebp),%eax
  800646:	ba 00 00 00 00       	mov    $0x0,%edx
  80064b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80064e:	77 55                	ja     8006a5 <printnum+0x75>
  800650:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800653:	72 05                	jb     80065a <printnum+0x2a>
  800655:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800658:	77 4b                	ja     8006a5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80065a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80065d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800660:	8b 45 18             	mov    0x18(%ebp),%eax
  800663:	ba 00 00 00 00       	mov    $0x0,%edx
  800668:	52                   	push   %edx
  800669:	50                   	push   %eax
  80066a:	ff 75 f4             	pushl  -0xc(%ebp)
  80066d:	ff 75 f0             	pushl  -0x10(%ebp)
  800670:	e8 8f 16 00 00       	call   801d04 <__udivdi3>
  800675:	83 c4 10             	add    $0x10,%esp
  800678:	83 ec 04             	sub    $0x4,%esp
  80067b:	ff 75 20             	pushl  0x20(%ebp)
  80067e:	53                   	push   %ebx
  80067f:	ff 75 18             	pushl  0x18(%ebp)
  800682:	52                   	push   %edx
  800683:	50                   	push   %eax
  800684:	ff 75 0c             	pushl  0xc(%ebp)
  800687:	ff 75 08             	pushl  0x8(%ebp)
  80068a:	e8 a1 ff ff ff       	call   800630 <printnum>
  80068f:	83 c4 20             	add    $0x20,%esp
  800692:	eb 1a                	jmp    8006ae <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800694:	83 ec 08             	sub    $0x8,%esp
  800697:	ff 75 0c             	pushl  0xc(%ebp)
  80069a:	ff 75 20             	pushl  0x20(%ebp)
  80069d:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a0:	ff d0                	call   *%eax
  8006a2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006a5:	ff 4d 1c             	decl   0x1c(%ebp)
  8006a8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006ac:	7f e6                	jg     800694 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ae:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006bc:	53                   	push   %ebx
  8006bd:	51                   	push   %ecx
  8006be:	52                   	push   %edx
  8006bf:	50                   	push   %eax
  8006c0:	e8 4f 17 00 00       	call   801e14 <__umoddi3>
  8006c5:	83 c4 10             	add    $0x10,%esp
  8006c8:	05 f4 24 80 00       	add    $0x8024f4,%eax
  8006cd:	8a 00                	mov    (%eax),%al
  8006cf:	0f be c0             	movsbl %al,%eax
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	ff 75 0c             	pushl  0xc(%ebp)
  8006d8:	50                   	push   %eax
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	ff d0                	call   *%eax
  8006de:	83 c4 10             	add    $0x10,%esp
}
  8006e1:	90                   	nop
  8006e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e5:	c9                   	leave  
  8006e6:	c3                   	ret    

008006e7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006e7:	55                   	push   %ebp
  8006e8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ea:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ee:	7e 1c                	jle    80070c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	8d 50 08             	lea    0x8(%eax),%edx
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	89 10                	mov    %edx,(%eax)
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	83 e8 08             	sub    $0x8,%eax
  800705:	8b 50 04             	mov    0x4(%eax),%edx
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	eb 40                	jmp    80074c <getuint+0x65>
	else if (lflag)
  80070c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800710:	74 1e                	je     800730 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	8b 00                	mov    (%eax),%eax
  800717:	8d 50 04             	lea    0x4(%eax),%edx
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	89 10                	mov    %edx,(%eax)
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	83 e8 04             	sub    $0x4,%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	ba 00 00 00 00       	mov    $0x0,%edx
  80072e:	eb 1c                	jmp    80074c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	8d 50 04             	lea    0x4(%eax),%edx
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	89 10                	mov    %edx,(%eax)
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	83 e8 04             	sub    $0x4,%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80074c:	5d                   	pop    %ebp
  80074d:	c3                   	ret    

0080074e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80074e:	55                   	push   %ebp
  80074f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800751:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800755:	7e 1c                	jle    800773 <getint+0x25>
		return va_arg(*ap, long long);
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	8d 50 08             	lea    0x8(%eax),%edx
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	89 10                	mov    %edx,(%eax)
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	8b 00                	mov    (%eax),%eax
  800769:	83 e8 08             	sub    $0x8,%eax
  80076c:	8b 50 04             	mov    0x4(%eax),%edx
  80076f:	8b 00                	mov    (%eax),%eax
  800771:	eb 38                	jmp    8007ab <getint+0x5d>
	else if (lflag)
  800773:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800777:	74 1a                	je     800793 <getint+0x45>
		return va_arg(*ap, long);
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	8d 50 04             	lea    0x4(%eax),%edx
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	89 10                	mov    %edx,(%eax)
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	83 e8 04             	sub    $0x4,%eax
  80078e:	8b 00                	mov    (%eax),%eax
  800790:	99                   	cltd   
  800791:	eb 18                	jmp    8007ab <getint+0x5d>
	else
		return va_arg(*ap, int);
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	8b 00                	mov    (%eax),%eax
  800798:	8d 50 04             	lea    0x4(%eax),%edx
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	89 10                	mov    %edx,(%eax)
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	83 e8 04             	sub    $0x4,%eax
  8007a8:	8b 00                	mov    (%eax),%eax
  8007aa:	99                   	cltd   
}
  8007ab:	5d                   	pop    %ebp
  8007ac:	c3                   	ret    

008007ad <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	56                   	push   %esi
  8007b1:	53                   	push   %ebx
  8007b2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b5:	eb 17                	jmp    8007ce <vprintfmt+0x21>
			if (ch == '\0')
  8007b7:	85 db                	test   %ebx,%ebx
  8007b9:	0f 84 c1 03 00 00    	je     800b80 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	ff 75 0c             	pushl  0xc(%ebp)
  8007c5:	53                   	push   %ebx
  8007c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c9:	ff d0                	call   *%eax
  8007cb:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d1:	8d 50 01             	lea    0x1(%eax),%edx
  8007d4:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d7:	8a 00                	mov    (%eax),%al
  8007d9:	0f b6 d8             	movzbl %al,%ebx
  8007dc:	83 fb 25             	cmp    $0x25,%ebx
  8007df:	75 d6                	jne    8007b7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007e5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007ec:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007f3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800801:	8b 45 10             	mov    0x10(%ebp),%eax
  800804:	8d 50 01             	lea    0x1(%eax),%edx
  800807:	89 55 10             	mov    %edx,0x10(%ebp)
  80080a:	8a 00                	mov    (%eax),%al
  80080c:	0f b6 d8             	movzbl %al,%ebx
  80080f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800812:	83 f8 5b             	cmp    $0x5b,%eax
  800815:	0f 87 3d 03 00 00    	ja     800b58 <vprintfmt+0x3ab>
  80081b:	8b 04 85 18 25 80 00 	mov    0x802518(,%eax,4),%eax
  800822:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800824:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800828:	eb d7                	jmp    800801 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80082a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80082e:	eb d1                	jmp    800801 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800830:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800837:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80083a:	89 d0                	mov    %edx,%eax
  80083c:	c1 e0 02             	shl    $0x2,%eax
  80083f:	01 d0                	add    %edx,%eax
  800841:	01 c0                	add    %eax,%eax
  800843:	01 d8                	add    %ebx,%eax
  800845:	83 e8 30             	sub    $0x30,%eax
  800848:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80084b:	8b 45 10             	mov    0x10(%ebp),%eax
  80084e:	8a 00                	mov    (%eax),%al
  800850:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800853:	83 fb 2f             	cmp    $0x2f,%ebx
  800856:	7e 3e                	jle    800896 <vprintfmt+0xe9>
  800858:	83 fb 39             	cmp    $0x39,%ebx
  80085b:	7f 39                	jg     800896 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80085d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800860:	eb d5                	jmp    800837 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	83 c0 04             	add    $0x4,%eax
  800868:	89 45 14             	mov    %eax,0x14(%ebp)
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	83 e8 04             	sub    $0x4,%eax
  800871:	8b 00                	mov    (%eax),%eax
  800873:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800876:	eb 1f                	jmp    800897 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800878:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087c:	79 83                	jns    800801 <vprintfmt+0x54>
				width = 0;
  80087e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800885:	e9 77 ff ff ff       	jmp    800801 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80088a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800891:	e9 6b ff ff ff       	jmp    800801 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800896:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800897:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089b:	0f 89 60 ff ff ff    	jns    800801 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008ae:	e9 4e ff ff ff       	jmp    800801 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008b3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008b6:	e9 46 ff ff ff       	jmp    800801 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	83 c0 04             	add    $0x4,%eax
  8008c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	83 e8 04             	sub    $0x4,%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	83 ec 08             	sub    $0x8,%esp
  8008cf:	ff 75 0c             	pushl  0xc(%ebp)
  8008d2:	50                   	push   %eax
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	ff d0                	call   *%eax
  8008d8:	83 c4 10             	add    $0x10,%esp
			break;
  8008db:	e9 9b 02 00 00       	jmp    800b7b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 c0 04             	add    $0x4,%eax
  8008e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	83 e8 04             	sub    $0x4,%eax
  8008ef:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008f1:	85 db                	test   %ebx,%ebx
  8008f3:	79 02                	jns    8008f7 <vprintfmt+0x14a>
				err = -err;
  8008f5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008f7:	83 fb 64             	cmp    $0x64,%ebx
  8008fa:	7f 0b                	jg     800907 <vprintfmt+0x15a>
  8008fc:	8b 34 9d 60 23 80 00 	mov    0x802360(,%ebx,4),%esi
  800903:	85 f6                	test   %esi,%esi
  800905:	75 19                	jne    800920 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800907:	53                   	push   %ebx
  800908:	68 05 25 80 00       	push   $0x802505
  80090d:	ff 75 0c             	pushl  0xc(%ebp)
  800910:	ff 75 08             	pushl  0x8(%ebp)
  800913:	e8 70 02 00 00       	call   800b88 <printfmt>
  800918:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80091b:	e9 5b 02 00 00       	jmp    800b7b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800920:	56                   	push   %esi
  800921:	68 0e 25 80 00       	push   $0x80250e
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	e8 57 02 00 00       	call   800b88 <printfmt>
  800931:	83 c4 10             	add    $0x10,%esp
			break;
  800934:	e9 42 02 00 00       	jmp    800b7b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	83 c0 04             	add    $0x4,%eax
  80093f:	89 45 14             	mov    %eax,0x14(%ebp)
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	83 e8 04             	sub    $0x4,%eax
  800948:	8b 30                	mov    (%eax),%esi
  80094a:	85 f6                	test   %esi,%esi
  80094c:	75 05                	jne    800953 <vprintfmt+0x1a6>
				p = "(null)";
  80094e:	be 11 25 80 00       	mov    $0x802511,%esi
			if (width > 0 && padc != '-')
  800953:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800957:	7e 6d                	jle    8009c6 <vprintfmt+0x219>
  800959:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80095d:	74 67                	je     8009c6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80095f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	50                   	push   %eax
  800966:	56                   	push   %esi
  800967:	e8 26 05 00 00       	call   800e92 <strnlen>
  80096c:	83 c4 10             	add    $0x10,%esp
  80096f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800972:	eb 16                	jmp    80098a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800974:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	50                   	push   %eax
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	ff d0                	call   *%eax
  800984:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800987:	ff 4d e4             	decl   -0x1c(%ebp)
  80098a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098e:	7f e4                	jg     800974 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800990:	eb 34                	jmp    8009c6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800992:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800996:	74 1c                	je     8009b4 <vprintfmt+0x207>
  800998:	83 fb 1f             	cmp    $0x1f,%ebx
  80099b:	7e 05                	jle    8009a2 <vprintfmt+0x1f5>
  80099d:	83 fb 7e             	cmp    $0x7e,%ebx
  8009a0:	7e 12                	jle    8009b4 <vprintfmt+0x207>
					putch('?', putdat);
  8009a2:	83 ec 08             	sub    $0x8,%esp
  8009a5:	ff 75 0c             	pushl  0xc(%ebp)
  8009a8:	6a 3f                	push   $0x3f
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	ff d0                	call   *%eax
  8009af:	83 c4 10             	add    $0x10,%esp
  8009b2:	eb 0f                	jmp    8009c3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	53                   	push   %ebx
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	ff d0                	call   *%eax
  8009c0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c3:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c6:	89 f0                	mov    %esi,%eax
  8009c8:	8d 70 01             	lea    0x1(%eax),%esi
  8009cb:	8a 00                	mov    (%eax),%al
  8009cd:	0f be d8             	movsbl %al,%ebx
  8009d0:	85 db                	test   %ebx,%ebx
  8009d2:	74 24                	je     8009f8 <vprintfmt+0x24b>
  8009d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d8:	78 b8                	js     800992 <vprintfmt+0x1e5>
  8009da:	ff 4d e0             	decl   -0x20(%ebp)
  8009dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e1:	79 af                	jns    800992 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e3:	eb 13                	jmp    8009f8 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009e5:	83 ec 08             	sub    $0x8,%esp
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	6a 20                	push   $0x20
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	ff d0                	call   *%eax
  8009f2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f5:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fc:	7f e7                	jg     8009e5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009fe:	e9 78 01 00 00       	jmp    800b7b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 e8             	pushl  -0x18(%ebp)
  800a09:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0c:	50                   	push   %eax
  800a0d:	e8 3c fd ff ff       	call   80074e <getint>
  800a12:	83 c4 10             	add    $0x10,%esp
  800a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a21:	85 d2                	test   %edx,%edx
  800a23:	79 23                	jns    800a48 <vprintfmt+0x29b>
				putch('-', putdat);
  800a25:	83 ec 08             	sub    $0x8,%esp
  800a28:	ff 75 0c             	pushl  0xc(%ebp)
  800a2b:	6a 2d                	push   $0x2d
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	ff d0                	call   *%eax
  800a32:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a3b:	f7 d8                	neg    %eax
  800a3d:	83 d2 00             	adc    $0x0,%edx
  800a40:	f7 da                	neg    %edx
  800a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a45:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a48:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a4f:	e9 bc 00 00 00       	jmp    800b10 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5d:	50                   	push   %eax
  800a5e:	e8 84 fc ff ff       	call   8006e7 <getuint>
  800a63:	83 c4 10             	add    $0x10,%esp
  800a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a69:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a6c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a73:	e9 98 00 00 00       	jmp    800b10 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a78:	83 ec 08             	sub    $0x8,%esp
  800a7b:	ff 75 0c             	pushl  0xc(%ebp)
  800a7e:	6a 58                	push   $0x58
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	ff d0                	call   *%eax
  800a85:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	6a 58                	push   $0x58
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	ff d0                	call   *%eax
  800a95:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	6a 58                	push   $0x58
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	ff d0                	call   *%eax
  800aa5:	83 c4 10             	add    $0x10,%esp
			break;
  800aa8:	e9 ce 00 00 00       	jmp    800b7b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800aad:	83 ec 08             	sub    $0x8,%esp
  800ab0:	ff 75 0c             	pushl  0xc(%ebp)
  800ab3:	6a 30                	push   $0x30
  800ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab8:	ff d0                	call   *%eax
  800aba:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800abd:	83 ec 08             	sub    $0x8,%esp
  800ac0:	ff 75 0c             	pushl  0xc(%ebp)
  800ac3:	6a 78                	push   $0x78
  800ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac8:	ff d0                	call   *%eax
  800aca:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800acd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad0:	83 c0 04             	add    $0x4,%eax
  800ad3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad9:	83 e8 04             	sub    $0x4,%eax
  800adc:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ade:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ae8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aef:	eb 1f                	jmp    800b10 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800af1:	83 ec 08             	sub    $0x8,%esp
  800af4:	ff 75 e8             	pushl  -0x18(%ebp)
  800af7:	8d 45 14             	lea    0x14(%ebp),%eax
  800afa:	50                   	push   %eax
  800afb:	e8 e7 fb ff ff       	call   8006e7 <getuint>
  800b00:	83 c4 10             	add    $0x10,%esp
  800b03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b09:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b10:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b17:	83 ec 04             	sub    $0x4,%esp
  800b1a:	52                   	push   %edx
  800b1b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b1e:	50                   	push   %eax
  800b1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b22:	ff 75 f0             	pushl  -0x10(%ebp)
  800b25:	ff 75 0c             	pushl  0xc(%ebp)
  800b28:	ff 75 08             	pushl  0x8(%ebp)
  800b2b:	e8 00 fb ff ff       	call   800630 <printnum>
  800b30:	83 c4 20             	add    $0x20,%esp
			break;
  800b33:	eb 46                	jmp    800b7b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	ff 75 0c             	pushl  0xc(%ebp)
  800b3b:	53                   	push   %ebx
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	ff d0                	call   *%eax
  800b41:	83 c4 10             	add    $0x10,%esp
			break;
  800b44:	eb 35                	jmp    800b7b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b46:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800b4d:	eb 2c                	jmp    800b7b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b4f:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800b56:	eb 23                	jmp    800b7b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	ff 75 0c             	pushl  0xc(%ebp)
  800b5e:	6a 25                	push   $0x25
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	ff d0                	call   *%eax
  800b65:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b68:	ff 4d 10             	decl   0x10(%ebp)
  800b6b:	eb 03                	jmp    800b70 <vprintfmt+0x3c3>
  800b6d:	ff 4d 10             	decl   0x10(%ebp)
  800b70:	8b 45 10             	mov    0x10(%ebp),%eax
  800b73:	48                   	dec    %eax
  800b74:	8a 00                	mov    (%eax),%al
  800b76:	3c 25                	cmp    $0x25,%al
  800b78:	75 f3                	jne    800b6d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b7a:	90                   	nop
		}
	}
  800b7b:	e9 35 fc ff ff       	jmp    8007b5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b80:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b84:	5b                   	pop    %ebx
  800b85:	5e                   	pop    %esi
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b8e:	8d 45 10             	lea    0x10(%ebp),%eax
  800b91:	83 c0 04             	add    $0x4,%eax
  800b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b97:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9d:	50                   	push   %eax
  800b9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ba1:	ff 75 08             	pushl  0x8(%ebp)
  800ba4:	e8 04 fc ff ff       	call   8007ad <vprintfmt>
  800ba9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bac:	90                   	nop
  800bad:	c9                   	leave  
  800bae:	c3                   	ret    

00800baf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	8b 40 08             	mov    0x8(%eax),%eax
  800bb8:	8d 50 01             	lea    0x1(%eax),%edx
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc4:	8b 10                	mov    (%eax),%edx
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	8b 40 04             	mov    0x4(%eax),%eax
  800bcc:	39 c2                	cmp    %eax,%edx
  800bce:	73 12                	jae    800be2 <sprintputch+0x33>
		*b->buf++ = ch;
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	8b 00                	mov    (%eax),%eax
  800bd5:	8d 48 01             	lea    0x1(%eax),%ecx
  800bd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdb:	89 0a                	mov    %ecx,(%edx)
  800bdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800be0:	88 10                	mov    %dl,(%eax)
}
  800be2:	90                   	nop
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	01 d0                	add    %edx,%eax
  800bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c0a:	74 06                	je     800c12 <vsnprintf+0x2d>
  800c0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c10:	7f 07                	jg     800c19 <vsnprintf+0x34>
		return -E_INVAL;
  800c12:	b8 03 00 00 00       	mov    $0x3,%eax
  800c17:	eb 20                	jmp    800c39 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c19:	ff 75 14             	pushl  0x14(%ebp)
  800c1c:	ff 75 10             	pushl  0x10(%ebp)
  800c1f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c22:	50                   	push   %eax
  800c23:	68 af 0b 80 00       	push   $0x800baf
  800c28:	e8 80 fb ff ff       	call   8007ad <vprintfmt>
  800c2d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c33:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c39:	c9                   	leave  
  800c3a:	c3                   	ret    

00800c3b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c41:	8d 45 10             	lea    0x10(%ebp),%eax
  800c44:	83 c0 04             	add    $0x4,%eax
  800c47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c50:	50                   	push   %eax
  800c51:	ff 75 0c             	pushl  0xc(%ebp)
  800c54:	ff 75 08             	pushl  0x8(%ebp)
  800c57:	e8 89 ff ff ff       	call   800be5 <vsnprintf>
  800c5c:	83 c4 10             	add    $0x10,%esp
  800c5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c65:	c9                   	leave  
  800c66:	c3                   	ret    

00800c67 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800c6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c71:	74 13                	je     800c86 <readline+0x1f>
		cprintf("%s", prompt);
  800c73:	83 ec 08             	sub    $0x8,%esp
  800c76:	ff 75 08             	pushl  0x8(%ebp)
  800c79:	68 88 26 80 00       	push   $0x802688
  800c7e:	e8 50 f9 ff ff       	call   8005d3 <cprintf>
  800c83:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800c86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800c8d:	83 ec 0c             	sub    $0xc,%esp
  800c90:	6a 00                	push   $0x0
  800c92:	e8 60 10 00 00       	call   801cf7 <iscons>
  800c97:	83 c4 10             	add    $0x10,%esp
  800c9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800c9d:	e8 42 10 00 00       	call   801ce4 <getchar>
  800ca2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800ca5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ca9:	79 22                	jns    800ccd <readline+0x66>
			if (c != -E_EOF)
  800cab:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800caf:	0f 84 ad 00 00 00    	je     800d62 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800cb5:	83 ec 08             	sub    $0x8,%esp
  800cb8:	ff 75 ec             	pushl  -0x14(%ebp)
  800cbb:	68 8b 26 80 00       	push   $0x80268b
  800cc0:	e8 0e f9 ff ff       	call   8005d3 <cprintf>
  800cc5:	83 c4 10             	add    $0x10,%esp
			break;
  800cc8:	e9 95 00 00 00       	jmp    800d62 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ccd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800cd1:	7e 34                	jle    800d07 <readline+0xa0>
  800cd3:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800cda:	7f 2b                	jg     800d07 <readline+0xa0>
			if (echoing)
  800cdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ce0:	74 0e                	je     800cf0 <readline+0x89>
				cputchar(c);
  800ce2:	83 ec 0c             	sub    $0xc,%esp
  800ce5:	ff 75 ec             	pushl  -0x14(%ebp)
  800ce8:	e8 d8 0f 00 00       	call   801cc5 <cputchar>
  800ced:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cf3:	8d 50 01             	lea    0x1(%eax),%edx
  800cf6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800cf9:	89 c2                	mov    %eax,%edx
  800cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfe:	01 d0                	add    %edx,%eax
  800d00:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d03:	88 10                	mov    %dl,(%eax)
  800d05:	eb 56                	jmp    800d5d <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800d07:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800d0b:	75 1f                	jne    800d2c <readline+0xc5>
  800d0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800d11:	7e 19                	jle    800d2c <readline+0xc5>
			if (echoing)
  800d13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d17:	74 0e                	je     800d27 <readline+0xc0>
				cputchar(c);
  800d19:	83 ec 0c             	sub    $0xc,%esp
  800d1c:	ff 75 ec             	pushl  -0x14(%ebp)
  800d1f:	e8 a1 0f 00 00       	call   801cc5 <cputchar>
  800d24:	83 c4 10             	add    $0x10,%esp

			i--;
  800d27:	ff 4d f4             	decl   -0xc(%ebp)
  800d2a:	eb 31                	jmp    800d5d <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800d2c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800d30:	74 0a                	je     800d3c <readline+0xd5>
  800d32:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800d36:	0f 85 61 ff ff ff    	jne    800c9d <readline+0x36>
			if (echoing)
  800d3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d40:	74 0e                	je     800d50 <readline+0xe9>
				cputchar(c);
  800d42:	83 ec 0c             	sub    $0xc,%esp
  800d45:	ff 75 ec             	pushl  -0x14(%ebp)
  800d48:	e8 78 0f 00 00       	call   801cc5 <cputchar>
  800d4d:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800d50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d56:	01 d0                	add    %edx,%eax
  800d58:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800d5b:	eb 06                	jmp    800d63 <readline+0xfc>
		}
	}
  800d5d:	e9 3b ff ff ff       	jmp    800c9d <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800d62:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800d63:	90                   	nop
  800d64:	c9                   	leave  
  800d65:	c3                   	ret    

00800d66 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800d6c:	e8 71 08 00 00       	call   8015e2 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800d71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d75:	74 13                	je     800d8a <atomic_readline+0x24>
			cprintf("%s", prompt);
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 08             	pushl  0x8(%ebp)
  800d7d:	68 88 26 80 00       	push   $0x802688
  800d82:	e8 4c f8 ff ff       	call   8005d3 <cprintf>
  800d87:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800d8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800d91:	83 ec 0c             	sub    $0xc,%esp
  800d94:	6a 00                	push   $0x0
  800d96:	e8 5c 0f 00 00       	call   801cf7 <iscons>
  800d9b:	83 c4 10             	add    $0x10,%esp
  800d9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800da1:	e8 3e 0f 00 00       	call   801ce4 <getchar>
  800da6:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800da9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800dad:	79 22                	jns    800dd1 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800daf:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800db3:	0f 84 ad 00 00 00    	je     800e66 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800db9:	83 ec 08             	sub    $0x8,%esp
  800dbc:	ff 75 ec             	pushl  -0x14(%ebp)
  800dbf:	68 8b 26 80 00       	push   $0x80268b
  800dc4:	e8 0a f8 ff ff       	call   8005d3 <cprintf>
  800dc9:	83 c4 10             	add    $0x10,%esp
				break;
  800dcc:	e9 95 00 00 00       	jmp    800e66 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800dd1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800dd5:	7e 34                	jle    800e0b <atomic_readline+0xa5>
  800dd7:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800dde:	7f 2b                	jg     800e0b <atomic_readline+0xa5>
				if (echoing)
  800de0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800de4:	74 0e                	je     800df4 <atomic_readline+0x8e>
					cputchar(c);
  800de6:	83 ec 0c             	sub    $0xc,%esp
  800de9:	ff 75 ec             	pushl  -0x14(%ebp)
  800dec:	e8 d4 0e 00 00       	call   801cc5 <cputchar>
  800df1:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800df7:	8d 50 01             	lea    0x1(%eax),%edx
  800dfa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800dfd:	89 c2                	mov    %eax,%edx
  800dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e02:	01 d0                	add    %edx,%eax
  800e04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e07:	88 10                	mov    %dl,(%eax)
  800e09:	eb 56                	jmp    800e61 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800e0b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800e0f:	75 1f                	jne    800e30 <atomic_readline+0xca>
  800e11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800e15:	7e 19                	jle    800e30 <atomic_readline+0xca>
				if (echoing)
  800e17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e1b:	74 0e                	je     800e2b <atomic_readline+0xc5>
					cputchar(c);
  800e1d:	83 ec 0c             	sub    $0xc,%esp
  800e20:	ff 75 ec             	pushl  -0x14(%ebp)
  800e23:	e8 9d 0e 00 00       	call   801cc5 <cputchar>
  800e28:	83 c4 10             	add    $0x10,%esp
				i--;
  800e2b:	ff 4d f4             	decl   -0xc(%ebp)
  800e2e:	eb 31                	jmp    800e61 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800e30:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800e34:	74 0a                	je     800e40 <atomic_readline+0xda>
  800e36:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800e3a:	0f 85 61 ff ff ff    	jne    800da1 <atomic_readline+0x3b>
				if (echoing)
  800e40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e44:	74 0e                	je     800e54 <atomic_readline+0xee>
					cputchar(c);
  800e46:	83 ec 0c             	sub    $0xc,%esp
  800e49:	ff 75 ec             	pushl  -0x14(%ebp)
  800e4c:	e8 74 0e 00 00       	call   801cc5 <cputchar>
  800e51:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800e54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	01 d0                	add    %edx,%eax
  800e5c:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800e5f:	eb 06                	jmp    800e67 <atomic_readline+0x101>
			}
		}
  800e61:	e9 3b ff ff ff       	jmp    800da1 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800e66:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800e67:	e8 90 07 00 00       	call   8015fc <sys_unlock_cons>
}
  800e6c:	90                   	nop
  800e6d:	c9                   	leave  
  800e6e:	c3                   	ret    

00800e6f <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e7c:	eb 06                	jmp    800e84 <strlen+0x15>
		n++;
  800e7e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e81:	ff 45 08             	incl   0x8(%ebp)
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	84 c0                	test   %al,%al
  800e8b:	75 f1                	jne    800e7e <strlen+0xf>
		n++;
	return n;
  800e8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9f:	eb 09                	jmp    800eaa <strnlen+0x18>
		n++;
  800ea1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea4:	ff 45 08             	incl   0x8(%ebp)
  800ea7:	ff 4d 0c             	decl   0xc(%ebp)
  800eaa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eae:	74 09                	je     800eb9 <strnlen+0x27>
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	84 c0                	test   %al,%al
  800eb7:	75 e8                	jne    800ea1 <strnlen+0xf>
		n++;
	return n;
  800eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800eca:	90                   	nop
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	8d 50 01             	lea    0x1(%eax),%edx
  800ed1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eda:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800edd:	8a 12                	mov    (%edx),%dl
  800edf:	88 10                	mov    %dl,(%eax)
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	84 c0                	test   %al,%al
  800ee5:	75 e4                	jne    800ecb <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ee7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    

00800eec <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ef8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eff:	eb 1f                	jmp    800f20 <strncpy+0x34>
		*dst++ = *src;
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8d 50 01             	lea    0x1(%eax),%edx
  800f07:	89 55 08             	mov    %edx,0x8(%ebp)
  800f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0d:	8a 12                	mov    (%edx),%dl
  800f0f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	84 c0                	test   %al,%al
  800f18:	74 03                	je     800f1d <strncpy+0x31>
			src++;
  800f1a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f1d:	ff 45 fc             	incl   -0x4(%ebp)
  800f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f23:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f26:	72 d9                	jb     800f01 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f28:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3d:	74 30                	je     800f6f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f3f:	eb 16                	jmp    800f57 <strlcpy+0x2a>
			*dst++ = *src++;
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8d 50 01             	lea    0x1(%eax),%edx
  800f47:	89 55 08             	mov    %edx,0x8(%ebp)
  800f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f50:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f53:	8a 12                	mov    (%edx),%dl
  800f55:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f57:	ff 4d 10             	decl   0x10(%ebp)
  800f5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5e:	74 09                	je     800f69 <strlcpy+0x3c>
  800f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	84 c0                	test   %al,%al
  800f67:	75 d8                	jne    800f41 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f75:	29 c2                	sub    %eax,%edx
  800f77:	89 d0                	mov    %edx,%eax
}
  800f79:	c9                   	leave  
  800f7a:	c3                   	ret    

00800f7b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f7e:	eb 06                	jmp    800f86 <strcmp+0xb>
		p++, q++;
  800f80:	ff 45 08             	incl   0x8(%ebp)
  800f83:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	84 c0                	test   %al,%al
  800f8d:	74 0e                	je     800f9d <strcmp+0x22>
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 10                	mov    (%eax),%dl
  800f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	38 c2                	cmp    %al,%dl
  800f9b:	74 e3                	je     800f80 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	0f b6 d0             	movzbl %al,%edx
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	0f b6 c0             	movzbl %al,%eax
  800fad:	29 c2                	sub    %eax,%edx
  800faf:	89 d0                	mov    %edx,%eax
}
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    

00800fb3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fb6:	eb 09                	jmp    800fc1 <strncmp+0xe>
		n--, p++, q++;
  800fb8:	ff 4d 10             	decl   0x10(%ebp)
  800fbb:	ff 45 08             	incl   0x8(%ebp)
  800fbe:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc5:	74 17                	je     800fde <strncmp+0x2b>
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	84 c0                	test   %al,%al
  800fce:	74 0e                	je     800fde <strncmp+0x2b>
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8a 10                	mov    (%eax),%dl
  800fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	38 c2                	cmp    %al,%dl
  800fdc:	74 da                	je     800fb8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe2:	75 07                	jne    800feb <strncmp+0x38>
		return 0;
  800fe4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe9:	eb 14                	jmp    800fff <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	0f b6 d0             	movzbl %al,%edx
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	0f b6 c0             	movzbl %al,%eax
  800ffb:	29 c2                	sub    %eax,%edx
  800ffd:	89 d0                	mov    %edx,%eax
}
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    

00801001 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 04             	sub    $0x4,%esp
  801007:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80100d:	eb 12                	jmp    801021 <strchr+0x20>
		if (*s == c)
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801017:	75 05                	jne    80101e <strchr+0x1d>
			return (char *) s;
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	eb 11                	jmp    80102f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80101e:	ff 45 08             	incl   0x8(%ebp)
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	84 c0                	test   %al,%al
  801028:	75 e5                	jne    80100f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80102a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	83 ec 04             	sub    $0x4,%esp
  801037:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80103d:	eb 0d                	jmp    80104c <strfind+0x1b>
		if (*s == c)
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801047:	74 0e                	je     801057 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801049:	ff 45 08             	incl   0x8(%ebp)
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	84 c0                	test   %al,%al
  801053:	75 ea                	jne    80103f <strfind+0xe>
  801055:	eb 01                	jmp    801058 <strfind+0x27>
		if (*s == c)
			break;
  801057:	90                   	nop
	return (char *) s;
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80105b:	c9                   	leave  
  80105c:	c3                   	ret    

0080105d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801069:	8b 45 10             	mov    0x10(%ebp),%eax
  80106c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80106f:	eb 0e                	jmp    80107f <memset+0x22>
		*p++ = c;
  801071:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801074:	8d 50 01             	lea    0x1(%eax),%edx
  801077:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80107a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80107f:	ff 4d f8             	decl   -0x8(%ebp)
  801082:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801086:	79 e9                	jns    801071 <memset+0x14>
		*p++ = c;

	return v;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80108b:	c9                   	leave  
  80108c:	c3                   	ret    

0080108d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80108d:	55                   	push   %ebp
  80108e:	89 e5                	mov    %esp,%ebp
  801090:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80109f:	eb 16                	jmp    8010b7 <memcpy+0x2a>
		*d++ = *s++;
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	8d 50 01             	lea    0x1(%eax),%edx
  8010a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ad:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010b3:	8a 12                	mov    (%edx),%dl
  8010b5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ba:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010bd:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c0:	85 c0                	test   %eax,%eax
  8010c2:	75 dd                	jne    8010a1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c7:	c9                   	leave  
  8010c8:	c3                   	ret    

008010c9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
  8010cc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010e1:	73 50                	jae    801133 <memmove+0x6a>
  8010e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e9:	01 d0                	add    %edx,%eax
  8010eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ee:	76 43                	jbe    801133 <memmove+0x6a>
		s += n;
  8010f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010fc:	eb 10                	jmp    80110e <memmove+0x45>
			*--d = *--s;
  8010fe:	ff 4d f8             	decl   -0x8(%ebp)
  801101:	ff 4d fc             	decl   -0x4(%ebp)
  801104:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801107:	8a 10                	mov    (%eax),%dl
  801109:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80110e:	8b 45 10             	mov    0x10(%ebp),%eax
  801111:	8d 50 ff             	lea    -0x1(%eax),%edx
  801114:	89 55 10             	mov    %edx,0x10(%ebp)
  801117:	85 c0                	test   %eax,%eax
  801119:	75 e3                	jne    8010fe <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80111b:	eb 23                	jmp    801140 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80111d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801120:	8d 50 01             	lea    0x1(%eax),%edx
  801123:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801126:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801129:	8d 4a 01             	lea    0x1(%edx),%ecx
  80112c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80112f:	8a 12                	mov    (%edx),%dl
  801131:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801133:	8b 45 10             	mov    0x10(%ebp),%eax
  801136:	8d 50 ff             	lea    -0x1(%eax),%edx
  801139:	89 55 10             	mov    %edx,0x10(%ebp)
  80113c:	85 c0                	test   %eax,%eax
  80113e:	75 dd                	jne    80111d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801143:	c9                   	leave  
  801144:	c3                   	ret    

00801145 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801151:	8b 45 0c             	mov    0xc(%ebp),%eax
  801154:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801157:	eb 2a                	jmp    801183 <memcmp+0x3e>
		if (*s1 != *s2)
  801159:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115c:	8a 10                	mov    (%eax),%dl
  80115e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	38 c2                	cmp    %al,%dl
  801165:	74 16                	je     80117d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801167:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116a:	8a 00                	mov    (%eax),%al
  80116c:	0f b6 d0             	movzbl %al,%edx
  80116f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	0f b6 c0             	movzbl %al,%eax
  801177:	29 c2                	sub    %eax,%edx
  801179:	89 d0                	mov    %edx,%eax
  80117b:	eb 18                	jmp    801195 <memcmp+0x50>
		s1++, s2++;
  80117d:	ff 45 fc             	incl   -0x4(%ebp)
  801180:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801183:	8b 45 10             	mov    0x10(%ebp),%eax
  801186:	8d 50 ff             	lea    -0x1(%eax),%edx
  801189:	89 55 10             	mov    %edx,0x10(%ebp)
  80118c:	85 c0                	test   %eax,%eax
  80118e:	75 c9                	jne    801159 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801190:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801195:	c9                   	leave  
  801196:	c3                   	ret    

00801197 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80119d:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a3:	01 d0                	add    %edx,%eax
  8011a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011a8:	eb 15                	jmp    8011bf <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	0f b6 d0             	movzbl %al,%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	0f b6 c0             	movzbl %al,%eax
  8011b8:	39 c2                	cmp    %eax,%edx
  8011ba:	74 0d                	je     8011c9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011bc:	ff 45 08             	incl   0x8(%ebp)
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011c5:	72 e3                	jb     8011aa <memfind+0x13>
  8011c7:	eb 01                	jmp    8011ca <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011c9:	90                   	nop
	return (void *) s;
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011cd:	c9                   	leave  
  8011ce:	c3                   	ret    

008011cf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011e3:	eb 03                	jmp    8011e8 <strtol+0x19>
		s++;
  8011e5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	3c 20                	cmp    $0x20,%al
  8011ef:	74 f4                	je     8011e5 <strtol+0x16>
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	3c 09                	cmp    $0x9,%al
  8011f8:	74 eb                	je     8011e5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 2b                	cmp    $0x2b,%al
  801201:	75 05                	jne    801208 <strtol+0x39>
		s++;
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	eb 13                	jmp    80121b <strtol+0x4c>
	else if (*s == '-')
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 2d                	cmp    $0x2d,%al
  80120f:	75 0a                	jne    80121b <strtol+0x4c>
		s++, neg = 1;
  801211:	ff 45 08             	incl   0x8(%ebp)
  801214:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80121b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121f:	74 06                	je     801227 <strtol+0x58>
  801221:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801225:	75 20                	jne    801247 <strtol+0x78>
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	8a 00                	mov    (%eax),%al
  80122c:	3c 30                	cmp    $0x30,%al
  80122e:	75 17                	jne    801247 <strtol+0x78>
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	40                   	inc    %eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3c 78                	cmp    $0x78,%al
  801238:	75 0d                	jne    801247 <strtol+0x78>
		s += 2, base = 16;
  80123a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80123e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801245:	eb 28                	jmp    80126f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801247:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80124b:	75 15                	jne    801262 <strtol+0x93>
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	3c 30                	cmp    $0x30,%al
  801254:	75 0c                	jne    801262 <strtol+0x93>
		s++, base = 8;
  801256:	ff 45 08             	incl   0x8(%ebp)
  801259:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801260:	eb 0d                	jmp    80126f <strtol+0xa0>
	else if (base == 0)
  801262:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801266:	75 07                	jne    80126f <strtol+0xa0>
		base = 10;
  801268:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	8a 00                	mov    (%eax),%al
  801274:	3c 2f                	cmp    $0x2f,%al
  801276:	7e 19                	jle    801291 <strtol+0xc2>
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	3c 39                	cmp    $0x39,%al
  80127f:	7f 10                	jg     801291 <strtol+0xc2>
			dig = *s - '0';
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	0f be c0             	movsbl %al,%eax
  801289:	83 e8 30             	sub    $0x30,%eax
  80128c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80128f:	eb 42                	jmp    8012d3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	3c 60                	cmp    $0x60,%al
  801298:	7e 19                	jle    8012b3 <strtol+0xe4>
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	8a 00                	mov    (%eax),%al
  80129f:	3c 7a                	cmp    $0x7a,%al
  8012a1:	7f 10                	jg     8012b3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	0f be c0             	movsbl %al,%eax
  8012ab:	83 e8 57             	sub    $0x57,%eax
  8012ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012b1:	eb 20                	jmp    8012d3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	8a 00                	mov    (%eax),%al
  8012b8:	3c 40                	cmp    $0x40,%al
  8012ba:	7e 39                	jle    8012f5 <strtol+0x126>
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	8a 00                	mov    (%eax),%al
  8012c1:	3c 5a                	cmp    $0x5a,%al
  8012c3:	7f 30                	jg     8012f5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	8a 00                	mov    (%eax),%al
  8012ca:	0f be c0             	movsbl %al,%eax
  8012cd:	83 e8 37             	sub    $0x37,%eax
  8012d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012d9:	7d 19                	jge    8012f4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012db:	ff 45 08             	incl   0x8(%ebp)
  8012de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012e5:	89 c2                	mov    %eax,%edx
  8012e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ea:	01 d0                	add    %edx,%eax
  8012ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012ef:	e9 7b ff ff ff       	jmp    80126f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012f4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012f9:	74 08                	je     801303 <strtol+0x134>
		*endptr = (char *) s;
  8012fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801301:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801303:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801307:	74 07                	je     801310 <strtol+0x141>
  801309:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130c:	f7 d8                	neg    %eax
  80130e:	eb 03                	jmp    801313 <strtol+0x144>
  801310:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <ltostr>:

void
ltostr(long value, char *str)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80131b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801322:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801329:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80132d:	79 13                	jns    801342 <ltostr+0x2d>
	{
		neg = 1;
  80132f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80133c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80133f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80134a:	99                   	cltd   
  80134b:	f7 f9                	idiv   %ecx
  80134d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801350:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801353:	8d 50 01             	lea    0x1(%eax),%edx
  801356:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801359:	89 c2                	mov    %eax,%edx
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	01 d0                	add    %edx,%eax
  801360:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801363:	83 c2 30             	add    $0x30,%edx
  801366:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801368:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80136b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801370:	f7 e9                	imul   %ecx
  801372:	c1 fa 02             	sar    $0x2,%edx
  801375:	89 c8                	mov    %ecx,%eax
  801377:	c1 f8 1f             	sar    $0x1f,%eax
  80137a:	29 c2                	sub    %eax,%edx
  80137c:	89 d0                	mov    %edx,%eax
  80137e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801381:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801385:	75 bb                	jne    801342 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801387:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80138e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801391:	48                   	dec    %eax
  801392:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801395:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801399:	74 3d                	je     8013d8 <ltostr+0xc3>
		start = 1 ;
  80139b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013a2:	eb 34                	jmp    8013d8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013aa:	01 d0                	add    %edx,%eax
  8013ac:	8a 00                	mov    (%eax),%al
  8013ae:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b7:	01 c2                	add    %eax,%edx
  8013b9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bf:	01 c8                	add    %ecx,%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	01 c2                	add    %eax,%edx
  8013cd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013d0:	88 02                	mov    %al,(%edx)
		start++ ;
  8013d2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013d5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013de:	7c c4                	jl     8013a4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013e0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e6:	01 d0                	add    %edx,%eax
  8013e8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013eb:	90                   	nop
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013f4:	ff 75 08             	pushl  0x8(%ebp)
  8013f7:	e8 73 fa ff ff       	call   800e6f <strlen>
  8013fc:	83 c4 04             	add    $0x4,%esp
  8013ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801402:	ff 75 0c             	pushl  0xc(%ebp)
  801405:	e8 65 fa ff ff       	call   800e6f <strlen>
  80140a:	83 c4 04             	add    $0x4,%esp
  80140d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801417:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80141e:	eb 17                	jmp    801437 <strcconcat+0x49>
		final[s] = str1[s] ;
  801420:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	01 c2                	add    %eax,%edx
  801428:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	01 c8                	add    %ecx,%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801434:	ff 45 fc             	incl   -0x4(%ebp)
  801437:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80143a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80143d:	7c e1                	jl     801420 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80143f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801446:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80144d:	eb 1f                	jmp    80146e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80144f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801452:	8d 50 01             	lea    0x1(%eax),%edx
  801455:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801458:	89 c2                	mov    %eax,%edx
  80145a:	8b 45 10             	mov    0x10(%ebp),%eax
  80145d:	01 c2                	add    %eax,%edx
  80145f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801462:	8b 45 0c             	mov    0xc(%ebp),%eax
  801465:	01 c8                	add    %ecx,%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80146b:	ff 45 f8             	incl   -0x8(%ebp)
  80146e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801471:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801474:	7c d9                	jl     80144f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801476:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801479:	8b 45 10             	mov    0x10(%ebp),%eax
  80147c:	01 d0                	add    %edx,%eax
  80147e:	c6 00 00             	movb   $0x0,(%eax)
}
  801481:	90                   	nop
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801487:	8b 45 14             	mov    0x14(%ebp),%eax
  80148a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801490:	8b 45 14             	mov    0x14(%ebp),%eax
  801493:	8b 00                	mov    (%eax),%eax
  801495:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80149c:	8b 45 10             	mov    0x10(%ebp),%eax
  80149f:	01 d0                	add    %edx,%eax
  8014a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014a7:	eb 0c                	jmp    8014b5 <strsplit+0x31>
			*string++ = 0;
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8d 50 01             	lea    0x1(%eax),%edx
  8014af:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 18                	je     8014d6 <strsplit+0x52>
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	8a 00                	mov    (%eax),%al
  8014c3:	0f be c0             	movsbl %al,%eax
  8014c6:	50                   	push   %eax
  8014c7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ca:	e8 32 fb ff ff       	call   801001 <strchr>
  8014cf:	83 c4 08             	add    $0x8,%esp
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	75 d3                	jne    8014a9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	8a 00                	mov    (%eax),%al
  8014db:	84 c0                	test   %al,%al
  8014dd:	74 5a                	je     801539 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014df:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e2:	8b 00                	mov    (%eax),%eax
  8014e4:	83 f8 0f             	cmp    $0xf,%eax
  8014e7:	75 07                	jne    8014f0 <strsplit+0x6c>
		{
			return 0;
  8014e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ee:	eb 66                	jmp    801556 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f3:	8b 00                	mov    (%eax),%eax
  8014f5:	8d 48 01             	lea    0x1(%eax),%ecx
  8014f8:	8b 55 14             	mov    0x14(%ebp),%edx
  8014fb:	89 0a                	mov    %ecx,(%edx)
  8014fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801504:	8b 45 10             	mov    0x10(%ebp),%eax
  801507:	01 c2                	add    %eax,%edx
  801509:	8b 45 08             	mov    0x8(%ebp),%eax
  80150c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80150e:	eb 03                	jmp    801513 <strsplit+0x8f>
			string++;
  801510:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	8a 00                	mov    (%eax),%al
  801518:	84 c0                	test   %al,%al
  80151a:	74 8b                	je     8014a7 <strsplit+0x23>
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	8a 00                	mov    (%eax),%al
  801521:	0f be c0             	movsbl %al,%eax
  801524:	50                   	push   %eax
  801525:	ff 75 0c             	pushl  0xc(%ebp)
  801528:	e8 d4 fa ff ff       	call   801001 <strchr>
  80152d:	83 c4 08             	add    $0x8,%esp
  801530:	85 c0                	test   %eax,%eax
  801532:	74 dc                	je     801510 <strsplit+0x8c>
			string++;
	}
  801534:	e9 6e ff ff ff       	jmp    8014a7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801539:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80153a:	8b 45 14             	mov    0x14(%ebp),%eax
  80153d:	8b 00                	mov    (%eax),%eax
  80153f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801546:	8b 45 10             	mov    0x10(%ebp),%eax
  801549:	01 d0                	add    %edx,%eax
  80154b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801551:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
  80155b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80155e:	83 ec 04             	sub    $0x4,%esp
  801561:	68 9c 26 80 00       	push   $0x80269c
  801566:	68 3f 01 00 00       	push   $0x13f
  80156b:	68 be 26 80 00       	push   $0x8026be
  801570:	e8 a1 ed ff ff       	call   800316 <_panic>

00801575 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	57                   	push   %edi
  801579:	56                   	push   %esi
  80157a:	53                   	push   %ebx
  80157b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	8b 55 0c             	mov    0xc(%ebp),%edx
  801584:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801587:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80158a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80158d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801590:	cd 30                	int    $0x30
  801592:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801595:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	5b                   	pop    %ebx
  80159c:	5e                   	pop    %esi
  80159d:	5f                   	pop    %edi
  80159e:	5d                   	pop    %ebp
  80159f:	c3                   	ret    

008015a0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 04             	sub    $0x4,%esp
  8015a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015ac:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	52                   	push   %edx
  8015b8:	ff 75 0c             	pushl  0xc(%ebp)
  8015bb:	50                   	push   %eax
  8015bc:	6a 00                	push   $0x0
  8015be:	e8 b2 ff ff ff       	call   801575 <syscall>
  8015c3:	83 c4 18             	add    $0x18,%esp
}
  8015c6:	90                   	nop
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 02                	push   $0x2
  8015d8:	e8 98 ff ff ff       	call   801575 <syscall>
  8015dd:	83 c4 18             	add    $0x18,%esp
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 03                	push   $0x3
  8015f1:	e8 7f ff ff ff       	call   801575 <syscall>
  8015f6:	83 c4 18             	add    $0x18,%esp
}
  8015f9:	90                   	nop
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 04                	push   $0x4
  80160b:	e8 65 ff ff ff       	call   801575 <syscall>
  801610:	83 c4 18             	add    $0x18,%esp
}
  801613:	90                   	nop
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	52                   	push   %edx
  801626:	50                   	push   %eax
  801627:	6a 08                	push   $0x8
  801629:	e8 47 ff ff ff       	call   801575 <syscall>
  80162e:	83 c4 18             	add    $0x18,%esp
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	56                   	push   %esi
  801637:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801638:	8b 75 18             	mov    0x18(%ebp),%esi
  80163b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80163e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801641:	8b 55 0c             	mov    0xc(%ebp),%edx
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	56                   	push   %esi
  801648:	53                   	push   %ebx
  801649:	51                   	push   %ecx
  80164a:	52                   	push   %edx
  80164b:	50                   	push   %eax
  80164c:	6a 09                	push   $0x9
  80164e:	e8 22 ff ff ff       	call   801575 <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
}
  801656:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801659:	5b                   	pop    %ebx
  80165a:	5e                   	pop    %esi
  80165b:	5d                   	pop    %ebp
  80165c:	c3                   	ret    

0080165d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801660:	8b 55 0c             	mov    0xc(%ebp),%edx
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	52                   	push   %edx
  80166d:	50                   	push   %eax
  80166e:	6a 0a                	push   $0xa
  801670:	e8 00 ff ff ff       	call   801575 <syscall>
  801675:	83 c4 18             	add    $0x18,%esp
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	ff 75 0c             	pushl  0xc(%ebp)
  801686:	ff 75 08             	pushl  0x8(%ebp)
  801689:	6a 0b                	push   $0xb
  80168b:	e8 e5 fe ff ff       	call   801575 <syscall>
  801690:	83 c4 18             	add    $0x18,%esp
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 0c                	push   $0xc
  8016a4:	e8 cc fe ff ff       	call   801575 <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp
}
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 0d                	push   $0xd
  8016bd:	e8 b3 fe ff ff       	call   801575 <syscall>
  8016c2:	83 c4 18             	add    $0x18,%esp
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 0e                	push   $0xe
  8016d6:	e8 9a fe ff ff       	call   801575 <syscall>
  8016db:	83 c4 18             	add    $0x18,%esp
}
  8016de:	c9                   	leave  
  8016df:	c3                   	ret    

008016e0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 0f                	push   $0xf
  8016ef:	e8 81 fe ff ff       	call   801575 <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	ff 75 08             	pushl  0x8(%ebp)
  801707:	6a 10                	push   $0x10
  801709:	e8 67 fe ff ff       	call   801575 <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 11                	push   $0x11
  801722:	e8 4e fe ff ff       	call   801575 <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
}
  80172a:	90                   	nop
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_cputc>:

void
sys_cputc(const char c)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 04             	sub    $0x4,%esp
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801739:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	50                   	push   %eax
  801746:	6a 01                	push   $0x1
  801748:	e8 28 fe ff ff       	call   801575 <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
}
  801750:	90                   	nop
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 14                	push   $0x14
  801762:	e8 0e fe ff ff       	call   801575 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
}
  80176a:	90                   	nop
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	8b 45 10             	mov    0x10(%ebp),%eax
  801776:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801779:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80177c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	6a 00                	push   $0x0
  801785:	51                   	push   %ecx
  801786:	52                   	push   %edx
  801787:	ff 75 0c             	pushl  0xc(%ebp)
  80178a:	50                   	push   %eax
  80178b:	6a 15                	push   $0x15
  80178d:	e8 e3 fd ff ff       	call   801575 <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80179a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	52                   	push   %edx
  8017a7:	50                   	push   %eax
  8017a8:	6a 16                	push   $0x16
  8017aa:	e8 c6 fd ff ff       	call   801575 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	51                   	push   %ecx
  8017c5:	52                   	push   %edx
  8017c6:	50                   	push   %eax
  8017c7:	6a 17                	push   $0x17
  8017c9:	e8 a7 fd ff ff       	call   801575 <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	52                   	push   %edx
  8017e3:	50                   	push   %eax
  8017e4:	6a 18                	push   $0x18
  8017e6:	e8 8a fd ff ff       	call   801575 <syscall>
  8017eb:	83 c4 18             	add    $0x18,%esp
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	6a 00                	push   $0x0
  8017f8:	ff 75 14             	pushl  0x14(%ebp)
  8017fb:	ff 75 10             	pushl  0x10(%ebp)
  8017fe:	ff 75 0c             	pushl  0xc(%ebp)
  801801:	50                   	push   %eax
  801802:	6a 19                	push   $0x19
  801804:	e8 6c fd ff ff       	call   801575 <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	50                   	push   %eax
  80181d:	6a 1a                	push   $0x1a
  80181f:	e8 51 fd ff ff       	call   801575 <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
}
  801827:	90                   	nop
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80182d:	8b 45 08             	mov    0x8(%ebp),%eax
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	50                   	push   %eax
  801839:	6a 1b                	push   $0x1b
  80183b:	e8 35 fd ff ff       	call   801575 <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 05                	push   $0x5
  801854:	e8 1c fd ff ff       	call   801575 <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 06                	push   $0x6
  80186d:	e8 03 fd ff ff       	call   801575 <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
}
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 07                	push   $0x7
  801886:	e8 ea fc ff ff       	call   801575 <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <sys_exit_env>:


void sys_exit_env(void)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 1c                	push   $0x1c
  80189f:	e8 d1 fc ff ff       	call   801575 <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	90                   	nop
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018b0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018b3:	8d 50 04             	lea    0x4(%eax),%edx
  8018b6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	52                   	push   %edx
  8018c0:	50                   	push   %eax
  8018c1:	6a 1d                	push   $0x1d
  8018c3:	e8 ad fc ff ff       	call   801575 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
	return result;
  8018cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018d4:	89 01                	mov    %eax,(%ecx)
  8018d6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	c9                   	leave  
  8018dd:	c2 04 00             	ret    $0x4

008018e0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	ff 75 10             	pushl  0x10(%ebp)
  8018ea:	ff 75 0c             	pushl  0xc(%ebp)
  8018ed:	ff 75 08             	pushl  0x8(%ebp)
  8018f0:	6a 13                	push   $0x13
  8018f2:	e8 7e fc ff ff       	call   801575 <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018fa:	90                   	nop
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <sys_rcr2>:
uint32 sys_rcr2()
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 1e                	push   $0x1e
  80190c:	e8 64 fc ff ff       	call   801575 <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	83 ec 04             	sub    $0x4,%esp
  80191c:	8b 45 08             	mov    0x8(%ebp),%eax
  80191f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801922:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	50                   	push   %eax
  80192f:	6a 1f                	push   $0x1f
  801931:	e8 3f fc ff ff       	call   801575 <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
	return ;
  801939:	90                   	nop
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <rsttst>:
void rsttst()
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 21                	push   $0x21
  80194b:	e8 25 fc ff ff       	call   801575 <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
	return ;
  801953:	90                   	nop
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	83 ec 04             	sub    $0x4,%esp
  80195c:	8b 45 14             	mov    0x14(%ebp),%eax
  80195f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801962:	8b 55 18             	mov    0x18(%ebp),%edx
  801965:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801969:	52                   	push   %edx
  80196a:	50                   	push   %eax
  80196b:	ff 75 10             	pushl  0x10(%ebp)
  80196e:	ff 75 0c             	pushl  0xc(%ebp)
  801971:	ff 75 08             	pushl  0x8(%ebp)
  801974:	6a 20                	push   $0x20
  801976:	e8 fa fb ff ff       	call   801575 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
	return ;
  80197e:	90                   	nop
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <chktst>:
void chktst(uint32 n)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	ff 75 08             	pushl  0x8(%ebp)
  80198f:	6a 22                	push   $0x22
  801991:	e8 df fb ff ff       	call   801575 <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
	return ;
  801999:	90                   	nop
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <inctst>:

void inctst()
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 23                	push   $0x23
  8019ab:	e8 c5 fb ff ff       	call   801575 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b3:	90                   	nop
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <gettst>:
uint32 gettst()
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 24                	push   $0x24
  8019c5:	e8 ab fb ff ff       	call   801575 <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 25                	push   $0x25
  8019e1:	e8 8f fb ff ff       	call   801575 <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
  8019e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019ec:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019f0:	75 07                	jne    8019f9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8019f7:	eb 05                	jmp    8019fe <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 25                	push   $0x25
  801a12:	e8 5e fb ff ff       	call   801575 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
  801a1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a1d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a21:	75 07                	jne    801a2a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a23:	b8 01 00 00 00       	mov    $0x1,%eax
  801a28:	eb 05                	jmp    801a2f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 25                	push   $0x25
  801a43:	e8 2d fb ff ff       	call   801575 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
  801a4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a4e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a52:	75 07                	jne    801a5b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a54:	b8 01 00 00 00       	mov    $0x1,%eax
  801a59:	eb 05                	jmp    801a60 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 25                	push   $0x25
  801a74:	e8 fc fa ff ff       	call   801575 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
  801a7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a7f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a83:	75 07                	jne    801a8c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a85:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8a:	eb 05                	jmp    801a91 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	ff 75 08             	pushl  0x8(%ebp)
  801aa1:	6a 26                	push   $0x26
  801aa3:	e8 cd fa ff ff       	call   801575 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
	return ;
  801aab:	90                   	nop
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ab2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ab5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	6a 00                	push   $0x0
  801ac0:	53                   	push   %ebx
  801ac1:	51                   	push   %ecx
  801ac2:	52                   	push   %edx
  801ac3:	50                   	push   %eax
  801ac4:	6a 27                	push   $0x27
  801ac6:	e8 aa fa ff ff       	call   801575 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	52                   	push   %edx
  801ae3:	50                   	push   %eax
  801ae4:	6a 28                	push   $0x28
  801ae6:	e8 8a fa ff ff       	call   801575 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801af3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801af6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	6a 00                	push   $0x0
  801afe:	51                   	push   %ecx
  801aff:	ff 75 10             	pushl  0x10(%ebp)
  801b02:	52                   	push   %edx
  801b03:	50                   	push   %eax
  801b04:	6a 29                	push   $0x29
  801b06:	e8 6a fa ff ff       	call   801575 <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	ff 75 10             	pushl  0x10(%ebp)
  801b1a:	ff 75 0c             	pushl  0xc(%ebp)
  801b1d:	ff 75 08             	pushl  0x8(%ebp)
  801b20:	6a 12                	push   $0x12
  801b22:	e8 4e fa ff ff       	call   801575 <syscall>
  801b27:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2a:	90                   	nop
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	52                   	push   %edx
  801b3d:	50                   	push   %eax
  801b3e:	6a 2a                	push   $0x2a
  801b40:	e8 30 fa ff ff       	call   801575 <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
	return;
  801b48:	90                   	nop
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	50                   	push   %eax
  801b5a:	6a 2b                	push   $0x2b
  801b5c:	e8 14 fa ff ff       	call   801575 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	ff 75 08             	pushl  0x8(%ebp)
  801b75:	6a 2c                	push   $0x2c
  801b77:	e8 f9 f9 ff ff       	call   801575 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
	return;
  801b7f:	90                   	nop
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	ff 75 0c             	pushl  0xc(%ebp)
  801b8e:	ff 75 08             	pushl  0x8(%ebp)
  801b91:	6a 2d                	push   $0x2d
  801b93:	e8 dd f9 ff ff       	call   801575 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
	return;
  801b9b:	90                   	nop
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  801ba4:	83 ec 04             	sub    $0x4,%esp
  801ba7:	68 cc 26 80 00       	push   $0x8026cc
  801bac:	6a 09                	push   $0x9
  801bae:	68 f4 26 80 00       	push   $0x8026f4
  801bb3:	e8 5e e7 ff ff       	call   800316 <_panic>

00801bb8 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  801bbe:	83 ec 04             	sub    $0x4,%esp
  801bc1:	68 04 27 80 00       	push   $0x802704
  801bc6:	6a 10                	push   $0x10
  801bc8:	68 f4 26 80 00       	push   $0x8026f4
  801bcd:	e8 44 e7 ff ff       	call   800316 <_panic>

00801bd2 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  801bd8:	83 ec 04             	sub    $0x4,%esp
  801bdb:	68 2c 27 80 00       	push   $0x80272c
  801be0:	6a 18                	push   $0x18
  801be2:	68 f4 26 80 00       	push   $0x8026f4
  801be7:	e8 2a e7 ff ff       	call   800316 <_panic>

00801bec <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  801bf2:	83 ec 04             	sub    $0x4,%esp
  801bf5:	68 54 27 80 00       	push   $0x802754
  801bfa:	6a 20                	push   $0x20
  801bfc:	68 f4 26 80 00       	push   $0x8026f4
  801c01:	e8 10 e7 ff ff       	call   800316 <_panic>

00801c06 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	8b 40 10             	mov    0x10(%eax),%eax
}
  801c0f:	5d                   	pop    %ebp
  801c10:	c3                   	ret    

00801c11 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801c17:	8b 55 08             	mov    0x8(%ebp),%edx
  801c1a:	89 d0                	mov    %edx,%eax
  801c1c:	c1 e0 02             	shl    $0x2,%eax
  801c1f:	01 d0                	add    %edx,%eax
  801c21:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c28:	01 d0                	add    %edx,%eax
  801c2a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c31:	01 d0                	add    %edx,%eax
  801c33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c3a:	01 d0                	add    %edx,%eax
  801c3c:	c1 e0 04             	shl    $0x4,%eax
  801c3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801c42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801c49:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801c4c:	83 ec 0c             	sub    $0xc,%esp
  801c4f:	50                   	push   %eax
  801c50:	e8 55 fc ff ff       	call   8018aa <sys_get_virtual_time>
  801c55:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801c58:	eb 41                	jmp    801c9b <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801c5a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801c5d:	83 ec 0c             	sub    $0xc,%esp
  801c60:	50                   	push   %eax
  801c61:	e8 44 fc ff ff       	call   8018aa <sys_get_virtual_time>
  801c66:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801c69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c6f:	29 c2                	sub    %eax,%edx
  801c71:	89 d0                	mov    %edx,%eax
  801c73:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801c76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c7c:	89 d1                	mov    %edx,%ecx
  801c7e:	29 c1                	sub    %eax,%ecx
  801c80:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c86:	39 c2                	cmp    %eax,%edx
  801c88:	0f 97 c0             	seta   %al
  801c8b:	0f b6 c0             	movzbl %al,%eax
  801c8e:	29 c1                	sub    %eax,%ecx
  801c90:	89 c8                	mov    %ecx,%eax
  801c92:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801c95:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c98:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ca1:	72 b7                	jb     801c5a <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801ca3:	90                   	nop
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801cac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801cb3:	eb 03                	jmp    801cb8 <busy_wait+0x12>
  801cb5:	ff 45 fc             	incl   -0x4(%ebp)
  801cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cbb:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cbe:	72 f5                	jb     801cb5 <busy_wait+0xf>
	return i;
  801cc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801cd1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801cd5:	83 ec 0c             	sub    $0xc,%esp
  801cd8:	50                   	push   %eax
  801cd9:	e8 4f fa ff ff       	call   80172d <sys_cputc>
  801cde:	83 c4 10             	add    $0x10,%esp
}
  801ce1:	90                   	nop
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <getchar>:


int
getchar(void)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801cea:	e8 da f8 ff ff       	call   8015c9 <sys_cgetc>
  801cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <iscons>:

int iscons(int fdnum)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801cfa:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cff:	5d                   	pop    %ebp
  801d00:	c3                   	ret    
  801d01:	66 90                	xchg   %ax,%ax
  801d03:	90                   	nop

00801d04 <__udivdi3>:
  801d04:	55                   	push   %ebp
  801d05:	57                   	push   %edi
  801d06:	56                   	push   %esi
  801d07:	53                   	push   %ebx
  801d08:	83 ec 1c             	sub    $0x1c,%esp
  801d0b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d0f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d1b:	89 ca                	mov    %ecx,%edx
  801d1d:	89 f8                	mov    %edi,%eax
  801d1f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d23:	85 f6                	test   %esi,%esi
  801d25:	75 2d                	jne    801d54 <__udivdi3+0x50>
  801d27:	39 cf                	cmp    %ecx,%edi
  801d29:	77 65                	ja     801d90 <__udivdi3+0x8c>
  801d2b:	89 fd                	mov    %edi,%ebp
  801d2d:	85 ff                	test   %edi,%edi
  801d2f:	75 0b                	jne    801d3c <__udivdi3+0x38>
  801d31:	b8 01 00 00 00       	mov    $0x1,%eax
  801d36:	31 d2                	xor    %edx,%edx
  801d38:	f7 f7                	div    %edi
  801d3a:	89 c5                	mov    %eax,%ebp
  801d3c:	31 d2                	xor    %edx,%edx
  801d3e:	89 c8                	mov    %ecx,%eax
  801d40:	f7 f5                	div    %ebp
  801d42:	89 c1                	mov    %eax,%ecx
  801d44:	89 d8                	mov    %ebx,%eax
  801d46:	f7 f5                	div    %ebp
  801d48:	89 cf                	mov    %ecx,%edi
  801d4a:	89 fa                	mov    %edi,%edx
  801d4c:	83 c4 1c             	add    $0x1c,%esp
  801d4f:	5b                   	pop    %ebx
  801d50:	5e                   	pop    %esi
  801d51:	5f                   	pop    %edi
  801d52:	5d                   	pop    %ebp
  801d53:	c3                   	ret    
  801d54:	39 ce                	cmp    %ecx,%esi
  801d56:	77 28                	ja     801d80 <__udivdi3+0x7c>
  801d58:	0f bd fe             	bsr    %esi,%edi
  801d5b:	83 f7 1f             	xor    $0x1f,%edi
  801d5e:	75 40                	jne    801da0 <__udivdi3+0x9c>
  801d60:	39 ce                	cmp    %ecx,%esi
  801d62:	72 0a                	jb     801d6e <__udivdi3+0x6a>
  801d64:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d68:	0f 87 9e 00 00 00    	ja     801e0c <__udivdi3+0x108>
  801d6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d73:	89 fa                	mov    %edi,%edx
  801d75:	83 c4 1c             	add    $0x1c,%esp
  801d78:	5b                   	pop    %ebx
  801d79:	5e                   	pop    %esi
  801d7a:	5f                   	pop    %edi
  801d7b:	5d                   	pop    %ebp
  801d7c:	c3                   	ret    
  801d7d:	8d 76 00             	lea    0x0(%esi),%esi
  801d80:	31 ff                	xor    %edi,%edi
  801d82:	31 c0                	xor    %eax,%eax
  801d84:	89 fa                	mov    %edi,%edx
  801d86:	83 c4 1c             	add    $0x1c,%esp
  801d89:	5b                   	pop    %ebx
  801d8a:	5e                   	pop    %esi
  801d8b:	5f                   	pop    %edi
  801d8c:	5d                   	pop    %ebp
  801d8d:	c3                   	ret    
  801d8e:	66 90                	xchg   %ax,%ax
  801d90:	89 d8                	mov    %ebx,%eax
  801d92:	f7 f7                	div    %edi
  801d94:	31 ff                	xor    %edi,%edi
  801d96:	89 fa                	mov    %edi,%edx
  801d98:	83 c4 1c             	add    $0x1c,%esp
  801d9b:	5b                   	pop    %ebx
  801d9c:	5e                   	pop    %esi
  801d9d:	5f                   	pop    %edi
  801d9e:	5d                   	pop    %ebp
  801d9f:	c3                   	ret    
  801da0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801da5:	89 eb                	mov    %ebp,%ebx
  801da7:	29 fb                	sub    %edi,%ebx
  801da9:	89 f9                	mov    %edi,%ecx
  801dab:	d3 e6                	shl    %cl,%esi
  801dad:	89 c5                	mov    %eax,%ebp
  801daf:	88 d9                	mov    %bl,%cl
  801db1:	d3 ed                	shr    %cl,%ebp
  801db3:	89 e9                	mov    %ebp,%ecx
  801db5:	09 f1                	or     %esi,%ecx
  801db7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801dbb:	89 f9                	mov    %edi,%ecx
  801dbd:	d3 e0                	shl    %cl,%eax
  801dbf:	89 c5                	mov    %eax,%ebp
  801dc1:	89 d6                	mov    %edx,%esi
  801dc3:	88 d9                	mov    %bl,%cl
  801dc5:	d3 ee                	shr    %cl,%esi
  801dc7:	89 f9                	mov    %edi,%ecx
  801dc9:	d3 e2                	shl    %cl,%edx
  801dcb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dcf:	88 d9                	mov    %bl,%cl
  801dd1:	d3 e8                	shr    %cl,%eax
  801dd3:	09 c2                	or     %eax,%edx
  801dd5:	89 d0                	mov    %edx,%eax
  801dd7:	89 f2                	mov    %esi,%edx
  801dd9:	f7 74 24 0c          	divl   0xc(%esp)
  801ddd:	89 d6                	mov    %edx,%esi
  801ddf:	89 c3                	mov    %eax,%ebx
  801de1:	f7 e5                	mul    %ebp
  801de3:	39 d6                	cmp    %edx,%esi
  801de5:	72 19                	jb     801e00 <__udivdi3+0xfc>
  801de7:	74 0b                	je     801df4 <__udivdi3+0xf0>
  801de9:	89 d8                	mov    %ebx,%eax
  801deb:	31 ff                	xor    %edi,%edi
  801ded:	e9 58 ff ff ff       	jmp    801d4a <__udivdi3+0x46>
  801df2:	66 90                	xchg   %ax,%ax
  801df4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801df8:	89 f9                	mov    %edi,%ecx
  801dfa:	d3 e2                	shl    %cl,%edx
  801dfc:	39 c2                	cmp    %eax,%edx
  801dfe:	73 e9                	jae    801de9 <__udivdi3+0xe5>
  801e00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e03:	31 ff                	xor    %edi,%edi
  801e05:	e9 40 ff ff ff       	jmp    801d4a <__udivdi3+0x46>
  801e0a:	66 90                	xchg   %ax,%ax
  801e0c:	31 c0                	xor    %eax,%eax
  801e0e:	e9 37 ff ff ff       	jmp    801d4a <__udivdi3+0x46>
  801e13:	90                   	nop

00801e14 <__umoddi3>:
  801e14:	55                   	push   %ebp
  801e15:	57                   	push   %edi
  801e16:	56                   	push   %esi
  801e17:	53                   	push   %ebx
  801e18:	83 ec 1c             	sub    $0x1c,%esp
  801e1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e27:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e33:	89 f3                	mov    %esi,%ebx
  801e35:	89 fa                	mov    %edi,%edx
  801e37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e3b:	89 34 24             	mov    %esi,(%esp)
  801e3e:	85 c0                	test   %eax,%eax
  801e40:	75 1a                	jne    801e5c <__umoddi3+0x48>
  801e42:	39 f7                	cmp    %esi,%edi
  801e44:	0f 86 a2 00 00 00    	jbe    801eec <__umoddi3+0xd8>
  801e4a:	89 c8                	mov    %ecx,%eax
  801e4c:	89 f2                	mov    %esi,%edx
  801e4e:	f7 f7                	div    %edi
  801e50:	89 d0                	mov    %edx,%eax
  801e52:	31 d2                	xor    %edx,%edx
  801e54:	83 c4 1c             	add    $0x1c,%esp
  801e57:	5b                   	pop    %ebx
  801e58:	5e                   	pop    %esi
  801e59:	5f                   	pop    %edi
  801e5a:	5d                   	pop    %ebp
  801e5b:	c3                   	ret    
  801e5c:	39 f0                	cmp    %esi,%eax
  801e5e:	0f 87 ac 00 00 00    	ja     801f10 <__umoddi3+0xfc>
  801e64:	0f bd e8             	bsr    %eax,%ebp
  801e67:	83 f5 1f             	xor    $0x1f,%ebp
  801e6a:	0f 84 ac 00 00 00    	je     801f1c <__umoddi3+0x108>
  801e70:	bf 20 00 00 00       	mov    $0x20,%edi
  801e75:	29 ef                	sub    %ebp,%edi
  801e77:	89 fe                	mov    %edi,%esi
  801e79:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e7d:	89 e9                	mov    %ebp,%ecx
  801e7f:	d3 e0                	shl    %cl,%eax
  801e81:	89 d7                	mov    %edx,%edi
  801e83:	89 f1                	mov    %esi,%ecx
  801e85:	d3 ef                	shr    %cl,%edi
  801e87:	09 c7                	or     %eax,%edi
  801e89:	89 e9                	mov    %ebp,%ecx
  801e8b:	d3 e2                	shl    %cl,%edx
  801e8d:	89 14 24             	mov    %edx,(%esp)
  801e90:	89 d8                	mov    %ebx,%eax
  801e92:	d3 e0                	shl    %cl,%eax
  801e94:	89 c2                	mov    %eax,%edx
  801e96:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e9a:	d3 e0                	shl    %cl,%eax
  801e9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ea4:	89 f1                	mov    %esi,%ecx
  801ea6:	d3 e8                	shr    %cl,%eax
  801ea8:	09 d0                	or     %edx,%eax
  801eaa:	d3 eb                	shr    %cl,%ebx
  801eac:	89 da                	mov    %ebx,%edx
  801eae:	f7 f7                	div    %edi
  801eb0:	89 d3                	mov    %edx,%ebx
  801eb2:	f7 24 24             	mull   (%esp)
  801eb5:	89 c6                	mov    %eax,%esi
  801eb7:	89 d1                	mov    %edx,%ecx
  801eb9:	39 d3                	cmp    %edx,%ebx
  801ebb:	0f 82 87 00 00 00    	jb     801f48 <__umoddi3+0x134>
  801ec1:	0f 84 91 00 00 00    	je     801f58 <__umoddi3+0x144>
  801ec7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ecb:	29 f2                	sub    %esi,%edx
  801ecd:	19 cb                	sbb    %ecx,%ebx
  801ecf:	89 d8                	mov    %ebx,%eax
  801ed1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ed5:	d3 e0                	shl    %cl,%eax
  801ed7:	89 e9                	mov    %ebp,%ecx
  801ed9:	d3 ea                	shr    %cl,%edx
  801edb:	09 d0                	or     %edx,%eax
  801edd:	89 e9                	mov    %ebp,%ecx
  801edf:	d3 eb                	shr    %cl,%ebx
  801ee1:	89 da                	mov    %ebx,%edx
  801ee3:	83 c4 1c             	add    $0x1c,%esp
  801ee6:	5b                   	pop    %ebx
  801ee7:	5e                   	pop    %esi
  801ee8:	5f                   	pop    %edi
  801ee9:	5d                   	pop    %ebp
  801eea:	c3                   	ret    
  801eeb:	90                   	nop
  801eec:	89 fd                	mov    %edi,%ebp
  801eee:	85 ff                	test   %edi,%edi
  801ef0:	75 0b                	jne    801efd <__umoddi3+0xe9>
  801ef2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef7:	31 d2                	xor    %edx,%edx
  801ef9:	f7 f7                	div    %edi
  801efb:	89 c5                	mov    %eax,%ebp
  801efd:	89 f0                	mov    %esi,%eax
  801eff:	31 d2                	xor    %edx,%edx
  801f01:	f7 f5                	div    %ebp
  801f03:	89 c8                	mov    %ecx,%eax
  801f05:	f7 f5                	div    %ebp
  801f07:	89 d0                	mov    %edx,%eax
  801f09:	e9 44 ff ff ff       	jmp    801e52 <__umoddi3+0x3e>
  801f0e:	66 90                	xchg   %ax,%ax
  801f10:	89 c8                	mov    %ecx,%eax
  801f12:	89 f2                	mov    %esi,%edx
  801f14:	83 c4 1c             	add    $0x1c,%esp
  801f17:	5b                   	pop    %ebx
  801f18:	5e                   	pop    %esi
  801f19:	5f                   	pop    %edi
  801f1a:	5d                   	pop    %ebp
  801f1b:	c3                   	ret    
  801f1c:	3b 04 24             	cmp    (%esp),%eax
  801f1f:	72 06                	jb     801f27 <__umoddi3+0x113>
  801f21:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f25:	77 0f                	ja     801f36 <__umoddi3+0x122>
  801f27:	89 f2                	mov    %esi,%edx
  801f29:	29 f9                	sub    %edi,%ecx
  801f2b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f2f:	89 14 24             	mov    %edx,(%esp)
  801f32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f36:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f3a:	8b 14 24             	mov    (%esp),%edx
  801f3d:	83 c4 1c             	add    $0x1c,%esp
  801f40:	5b                   	pop    %ebx
  801f41:	5e                   	pop    %esi
  801f42:	5f                   	pop    %edi
  801f43:	5d                   	pop    %ebp
  801f44:	c3                   	ret    
  801f45:	8d 76 00             	lea    0x0(%esi),%esi
  801f48:	2b 04 24             	sub    (%esp),%eax
  801f4b:	19 fa                	sbb    %edi,%edx
  801f4d:	89 d1                	mov    %edx,%ecx
  801f4f:	89 c6                	mov    %eax,%esi
  801f51:	e9 71 ff ff ff       	jmp    801ec7 <__umoddi3+0xb3>
  801f56:	66 90                	xchg   %ax,%ax
  801f58:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f5c:	72 ea                	jb     801f48 <__umoddi3+0x134>
  801f5e:	89 d9                	mov    %ebx,%ecx
  801f60:	e9 62 ff ff ff       	jmp    801ec7 <__umoddi3+0xb3>
