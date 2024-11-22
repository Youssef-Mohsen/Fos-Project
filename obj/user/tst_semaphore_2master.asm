
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
  800041:	e8 07 18 00 00       	call   80184d <sys_getenvid>
  800046:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char line[256] ;
	readline("Enter total number of customers: ", line) ;
  800049:	83 ec 08             	sub    $0x8,%esp
  80004c:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  800052:	50                   	push   %eax
  800053:	68 80 1f 80 00       	push   $0x801f80
  800058:	e8 12 0c 00 00       	call   800c6f <readline>
  80005d:	83 c4 10             	add    $0x10,%esp
	int totalNumOfCusts = strtol(line, NULL, 10);
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	6a 0a                	push   $0xa
  800065:	6a 00                	push   $0x0
  800067:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  80006d:	50                   	push   %eax
  80006e:	e8 64 11 00 00       	call   8011d7 <strtol>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	readline("Enter shop capacity: ", line) ;
  800079:	83 ec 08             	sub    $0x8,%esp
  80007c:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  800082:	50                   	push   %eax
  800083:	68 a2 1f 80 00       	push   $0x801fa2
  800088:	e8 e2 0b 00 00       	call   800c6f <readline>
  80008d:	83 c4 10             	add    $0x10,%esp
	int shopCapacity = strtol(line, NULL, 10);
  800090:	83 ec 04             	sub    $0x4,%esp
  800093:	6a 0a                	push   $0xa
  800095:	6a 00                	push   $0x0
  800097:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  80009d:	50                   	push   %eax
  80009e:	e8 34 11 00 00       	call   8011d7 <strtol>
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct semaphore shopCapacitySem = create_semaphore("shopCapacity", shopCapacity);
  8000a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000ac:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	52                   	push   %edx
  8000b6:	68 b8 1f 80 00       	push   $0x801fb8
  8000bb:	50                   	push   %eax
  8000bc:	e8 e5 1a 00 00       	call   801ba6 <create_semaphore>
  8000c1:	83 c4 0c             	add    $0xc,%esp
	struct semaphore dependSem = create_semaphore("depend", 0);
  8000c4:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	6a 00                	push   $0x0
  8000cf:	68 c5 1f 80 00       	push   $0x801fc5
  8000d4:	50                   	push   %eax
  8000d5:	e8 cc 1a 00 00       	call   801ba6 <create_semaphore>
  8000da:	83 c4 0c             	add    $0xc,%esp

	int i = 0 ;
  8000dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int id ;
	for (; i<totalNumOfCusts; i++)
  8000e4:	eb 61                	jmp    800147 <_main+0x10f>
	{
		id = sys_create_env("sem2Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000e6:	a1 04 30 80 00       	mov    0x803004,%eax
  8000eb:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8000f1:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f6:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000fc:	89 c1                	mov    %eax,%ecx
  8000fe:	a1 04 30 80 00       	mov    0x803004,%eax
  800103:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800109:	52                   	push   %edx
  80010a:	51                   	push   %ecx
  80010b:	50                   	push   %eax
  80010c:	68 cc 1f 80 00       	push   $0x801fcc
  800111:	e8 e2 16 00 00       	call   8017f8 <sys_create_env>
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
  800131:	e8 e8 01 00 00       	call   80031e <_panic>
		sys_run_env(id) ;
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	ff 75 e4             	pushl  -0x1c(%ebp)
  80013c:	e8 d5 16 00 00       	call   801816 <sys_run_env>
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
  800161:	e8 74 1a 00 00       	call   801bda <wait_semaphore>
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
  80017d:	e8 8c 1a 00 00       	call   801c0e <semaphore_count>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int sem2val = semaphore_count(dependSem);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff b5 d4 fe ff ff    	pushl  -0x12c(%ebp)
  800191:	e8 78 1a 00 00       	call   801c0e <semaphore_count>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//wait a while to allow the slaves to finish printing their closing messages
	env_sleep(10000);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	68 10 27 00 00       	push   $0x2710
  8001a4:	e8 70 1a 00 00       	call   801c19 <env_sleep>
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
  8001c2:	e8 14 04 00 00       	call   8005db <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp
  8001ca:	eb 10                	jmp    8001dc <_main+0x1a4>
	else
		cprintf("\nError: wrong semaphore value... please review your semaphore code again...\n");
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	68 8c 20 80 00       	push   $0x80208c
  8001d4:	e8 02 04 00 00       	call   8005db <cprintf>
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
  8001e5:	e8 7c 16 00 00       	call   801866 <sys_getenvindex>
  8001ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001f0:	89 d0                	mov    %edx,%eax
  8001f2:	c1 e0 03             	shl    $0x3,%eax
  8001f5:	01 d0                	add    %edx,%eax
  8001f7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001fe:	01 c8                	add    %ecx,%eax
  800200:	01 c0                	add    %eax,%eax
  800202:	01 d0                	add    %edx,%eax
  800204:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80020b:	01 c8                	add    %ecx,%eax
  80020d:	01 d0                	add    %edx,%eax
  80020f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800214:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800219:	a1 04 30 80 00       	mov    0x803004,%eax
  80021e:	8a 40 20             	mov    0x20(%eax),%al
  800221:	84 c0                	test   %al,%al
  800223:	74 0d                	je     800232 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800225:	a1 04 30 80 00       	mov    0x803004,%eax
  80022a:	83 c0 20             	add    $0x20,%eax
  80022d:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800232:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800236:	7e 0a                	jle    800242 <libmain+0x63>
		binaryname = argv[0];
  800238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023b:	8b 00                	mov    (%eax),%eax
  80023d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	ff 75 0c             	pushl  0xc(%ebp)
  800248:	ff 75 08             	pushl  0x8(%ebp)
  80024b:	e8 e8 fd ff ff       	call   800038 <_main>
  800250:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800253:	e8 92 13 00 00       	call   8015ea <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	68 f4 20 80 00       	push   $0x8020f4
  800260:	e8 76 03 00 00       	call   8005db <cprintf>
  800265:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800268:	a1 04 30 80 00       	mov    0x803004,%eax
  80026d:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800273:	a1 04 30 80 00       	mov    0x803004,%eax
  800278:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80027e:	83 ec 04             	sub    $0x4,%esp
  800281:	52                   	push   %edx
  800282:	50                   	push   %eax
  800283:	68 1c 21 80 00       	push   $0x80211c
  800288:	e8 4e 03 00 00       	call   8005db <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800290:	a1 04 30 80 00       	mov    0x803004,%eax
  800295:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80029b:	a1 04 30 80 00       	mov    0x803004,%eax
  8002a0:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8002a6:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ab:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8002b1:	51                   	push   %ecx
  8002b2:	52                   	push   %edx
  8002b3:	50                   	push   %eax
  8002b4:	68 44 21 80 00       	push   $0x802144
  8002b9:	e8 1d 03 00 00       	call   8005db <cprintf>
  8002be:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c1:	a1 04 30 80 00       	mov    0x803004,%eax
  8002c6:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	50                   	push   %eax
  8002d0:	68 9c 21 80 00       	push   $0x80219c
  8002d5:	e8 01 03 00 00       	call   8005db <cprintf>
  8002da:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002dd:	83 ec 0c             	sub    $0xc,%esp
  8002e0:	68 f4 20 80 00       	push   $0x8020f4
  8002e5:	e8 f1 02 00 00       	call   8005db <cprintf>
  8002ea:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002ed:	e8 12 13 00 00       	call   801604 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8002f2:	e8 19 00 00 00       	call   800310 <exit>
}
  8002f7:	90                   	nop
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    

008002fa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	6a 00                	push   $0x0
  800305:	e8 28 15 00 00       	call   801832 <sys_destroy_env>
  80030a:	83 c4 10             	add    $0x10,%esp
}
  80030d:	90                   	nop
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

00800310 <exit>:

void
exit(void)
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800316:	e8 7d 15 00 00       	call   801898 <sys_exit_env>
}
  80031b:	90                   	nop
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800324:	8d 45 10             	lea    0x10(%ebp),%eax
  800327:	83 c0 04             	add    $0x4,%eax
  80032a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80032d:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800332:	85 c0                	test   %eax,%eax
  800334:	74 16                	je     80034c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800336:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	50                   	push   %eax
  80033f:	68 b0 21 80 00       	push   $0x8021b0
  800344:	e8 92 02 00 00       	call   8005db <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80034c:	a1 00 30 80 00       	mov    0x803000,%eax
  800351:	ff 75 0c             	pushl  0xc(%ebp)
  800354:	ff 75 08             	pushl  0x8(%ebp)
  800357:	50                   	push   %eax
  800358:	68 b5 21 80 00       	push   $0x8021b5
  80035d:	e8 79 02 00 00       	call   8005db <cprintf>
  800362:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800365:	8b 45 10             	mov    0x10(%ebp),%eax
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	ff 75 f4             	pushl  -0xc(%ebp)
  80036e:	50                   	push   %eax
  80036f:	e8 fc 01 00 00       	call   800570 <vcprintf>
  800374:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800377:	83 ec 08             	sub    $0x8,%esp
  80037a:	6a 00                	push   $0x0
  80037c:	68 d1 21 80 00       	push   $0x8021d1
  800381:	e8 ea 01 00 00       	call   800570 <vcprintf>
  800386:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800389:	e8 82 ff ff ff       	call   800310 <exit>

	// should not return here
	while (1) ;
  80038e:	eb fe                	jmp    80038e <_panic+0x70>

00800390 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800396:	a1 04 30 80 00       	mov    0x803004,%eax
  80039b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a4:	39 c2                	cmp    %eax,%edx
  8003a6:	74 14                	je     8003bc <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	68 d4 21 80 00       	push   $0x8021d4
  8003b0:	6a 26                	push   $0x26
  8003b2:	68 20 22 80 00       	push   $0x802220
  8003b7:	e8 62 ff ff ff       	call   80031e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003ca:	e9 c5 00 00 00       	jmp    800494 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003dc:	01 d0                	add    %edx,%eax
  8003de:	8b 00                	mov    (%eax),%eax
  8003e0:	85 c0                	test   %eax,%eax
  8003e2:	75 08                	jne    8003ec <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003e4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003e7:	e9 a5 00 00 00       	jmp    800491 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003ec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003fa:	eb 69                	jmp    800465 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003fc:	a1 04 30 80 00       	mov    0x803004,%eax
  800401:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800407:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80040a:	89 d0                	mov    %edx,%eax
  80040c:	01 c0                	add    %eax,%eax
  80040e:	01 d0                	add    %edx,%eax
  800410:	c1 e0 03             	shl    $0x3,%eax
  800413:	01 c8                	add    %ecx,%eax
  800415:	8a 40 04             	mov    0x4(%eax),%al
  800418:	84 c0                	test   %al,%al
  80041a:	75 46                	jne    800462 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80041c:	a1 04 30 80 00       	mov    0x803004,%eax
  800421:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800427:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80042a:	89 d0                	mov    %edx,%eax
  80042c:	01 c0                	add    %eax,%eax
  80042e:	01 d0                	add    %edx,%eax
  800430:	c1 e0 03             	shl    $0x3,%eax
  800433:	01 c8                	add    %ecx,%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80043a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80043d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800442:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800447:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c8                	add    %ecx,%eax
  800453:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800455:	39 c2                	cmp    %eax,%edx
  800457:	75 09                	jne    800462 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800459:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800460:	eb 15                	jmp    800477 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800462:	ff 45 e8             	incl   -0x18(%ebp)
  800465:	a1 04 30 80 00       	mov    0x803004,%eax
  80046a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800473:	39 c2                	cmp    %eax,%edx
  800475:	77 85                	ja     8003fc <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800477:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80047b:	75 14                	jne    800491 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80047d:	83 ec 04             	sub    $0x4,%esp
  800480:	68 2c 22 80 00       	push   $0x80222c
  800485:	6a 3a                	push   $0x3a
  800487:	68 20 22 80 00       	push   $0x802220
  80048c:	e8 8d fe ff ff       	call   80031e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800491:	ff 45 f0             	incl   -0x10(%ebp)
  800494:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800497:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049a:	0f 8c 2f ff ff ff    	jl     8003cf <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004ae:	eb 26                	jmp    8004d6 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004b0:	a1 04 30 80 00       	mov    0x803004,%eax
  8004b5:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8004bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004be:	89 d0                	mov    %edx,%eax
  8004c0:	01 c0                	add    %eax,%eax
  8004c2:	01 d0                	add    %edx,%eax
  8004c4:	c1 e0 03             	shl    $0x3,%eax
  8004c7:	01 c8                	add    %ecx,%eax
  8004c9:	8a 40 04             	mov    0x4(%eax),%al
  8004cc:	3c 01                	cmp    $0x1,%al
  8004ce:	75 03                	jne    8004d3 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004d0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d3:	ff 45 e0             	incl   -0x20(%ebp)
  8004d6:	a1 04 30 80 00       	mov    0x803004,%eax
  8004db:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8004e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e4:	39 c2                	cmp    %eax,%edx
  8004e6:	77 c8                	ja     8004b0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004eb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004ee:	74 14                	je     800504 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 80 22 80 00       	push   $0x802280
  8004f8:	6a 44                	push   $0x44
  8004fa:	68 20 22 80 00       	push   $0x802220
  8004ff:	e8 1a fe ff ff       	call   80031e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800504:	90                   	nop
  800505:	c9                   	leave  
  800506:	c3                   	ret    

00800507 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800507:	55                   	push   %ebp
  800508:	89 e5                	mov    %esp,%ebp
  80050a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80050d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	8d 48 01             	lea    0x1(%eax),%ecx
  800515:	8b 55 0c             	mov    0xc(%ebp),%edx
  800518:	89 0a                	mov    %ecx,(%edx)
  80051a:	8b 55 08             	mov    0x8(%ebp),%edx
  80051d:	88 d1                	mov    %dl,%cl
  80051f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800522:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800526:	8b 45 0c             	mov    0xc(%ebp),%eax
  800529:	8b 00                	mov    (%eax),%eax
  80052b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800530:	75 2c                	jne    80055e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800532:	a0 08 30 80 00       	mov    0x803008,%al
  800537:	0f b6 c0             	movzbl %al,%eax
  80053a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053d:	8b 12                	mov    (%edx),%edx
  80053f:	89 d1                	mov    %edx,%ecx
  800541:	8b 55 0c             	mov    0xc(%ebp),%edx
  800544:	83 c2 08             	add    $0x8,%edx
  800547:	83 ec 04             	sub    $0x4,%esp
  80054a:	50                   	push   %eax
  80054b:	51                   	push   %ecx
  80054c:	52                   	push   %edx
  80054d:	e8 56 10 00 00       	call   8015a8 <sys_cputs>
  800552:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800555:	8b 45 0c             	mov    0xc(%ebp),%eax
  800558:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80055e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800561:	8b 40 04             	mov    0x4(%eax),%eax
  800564:	8d 50 01             	lea    0x1(%eax),%edx
  800567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80056d:	90                   	nop
  80056e:	c9                   	leave  
  80056f:	c3                   	ret    

00800570 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800579:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800580:	00 00 00 
	b.cnt = 0;
  800583:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80058a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80058d:	ff 75 0c             	pushl  0xc(%ebp)
  800590:	ff 75 08             	pushl  0x8(%ebp)
  800593:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800599:	50                   	push   %eax
  80059a:	68 07 05 80 00       	push   $0x800507
  80059f:	e8 11 02 00 00       	call   8007b5 <vprintfmt>
  8005a4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005a7:	a0 08 30 80 00       	mov    0x803008,%al
  8005ac:	0f b6 c0             	movzbl %al,%eax
  8005af:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005b5:	83 ec 04             	sub    $0x4,%esp
  8005b8:	50                   	push   %eax
  8005b9:	52                   	push   %edx
  8005ba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005c0:	83 c0 08             	add    $0x8,%eax
  8005c3:	50                   	push   %eax
  8005c4:	e8 df 0f 00 00       	call   8015a8 <sys_cputs>
  8005c9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005cc:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8005d3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005d9:	c9                   	leave  
  8005da:	c3                   	ret    

008005db <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005db:	55                   	push   %ebp
  8005dc:	89 e5                	mov    %esp,%ebp
  8005de:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e1:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8005e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f1:	83 ec 08             	sub    $0x8,%esp
  8005f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f7:	50                   	push   %eax
  8005f8:	e8 73 ff ff ff       	call   800570 <vcprintf>
  8005fd:	83 c4 10             	add    $0x10,%esp
  800600:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800603:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800606:	c9                   	leave  
  800607:	c3                   	ret    

00800608 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800608:	55                   	push   %ebp
  800609:	89 e5                	mov    %esp,%ebp
  80060b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80060e:	e8 d7 0f 00 00       	call   8015ea <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800613:	8d 45 0c             	lea    0xc(%ebp),%eax
  800616:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	83 ec 08             	sub    $0x8,%esp
  80061f:	ff 75 f4             	pushl  -0xc(%ebp)
  800622:	50                   	push   %eax
  800623:	e8 48 ff ff ff       	call   800570 <vcprintf>
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80062e:	e8 d1 0f 00 00       	call   801604 <sys_unlock_cons>
	return cnt;
  800633:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800636:	c9                   	leave  
  800637:	c3                   	ret    

00800638 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800638:	55                   	push   %ebp
  800639:	89 e5                	mov    %esp,%ebp
  80063b:	53                   	push   %ebx
  80063c:	83 ec 14             	sub    $0x14,%esp
  80063f:	8b 45 10             	mov    0x10(%ebp),%eax
  800642:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80064b:	8b 45 18             	mov    0x18(%ebp),%eax
  80064e:	ba 00 00 00 00       	mov    $0x0,%edx
  800653:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800656:	77 55                	ja     8006ad <printnum+0x75>
  800658:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80065b:	72 05                	jb     800662 <printnum+0x2a>
  80065d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800660:	77 4b                	ja     8006ad <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800662:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800665:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800668:	8b 45 18             	mov    0x18(%ebp),%eax
  80066b:	ba 00 00 00 00       	mov    $0x0,%edx
  800670:	52                   	push   %edx
  800671:	50                   	push   %eax
  800672:	ff 75 f4             	pushl  -0xc(%ebp)
  800675:	ff 75 f0             	pushl  -0x10(%ebp)
  800678:	e8 8f 16 00 00       	call   801d0c <__udivdi3>
  80067d:	83 c4 10             	add    $0x10,%esp
  800680:	83 ec 04             	sub    $0x4,%esp
  800683:	ff 75 20             	pushl  0x20(%ebp)
  800686:	53                   	push   %ebx
  800687:	ff 75 18             	pushl  0x18(%ebp)
  80068a:	52                   	push   %edx
  80068b:	50                   	push   %eax
  80068c:	ff 75 0c             	pushl  0xc(%ebp)
  80068f:	ff 75 08             	pushl  0x8(%ebp)
  800692:	e8 a1 ff ff ff       	call   800638 <printnum>
  800697:	83 c4 20             	add    $0x20,%esp
  80069a:	eb 1a                	jmp    8006b6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	ff 75 20             	pushl  0x20(%ebp)
  8006a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a8:	ff d0                	call   *%eax
  8006aa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006ad:	ff 4d 1c             	decl   0x1c(%ebp)
  8006b0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006b4:	7f e6                	jg     80069c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006b6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c4:	53                   	push   %ebx
  8006c5:	51                   	push   %ecx
  8006c6:	52                   	push   %edx
  8006c7:	50                   	push   %eax
  8006c8:	e8 4f 17 00 00       	call   801e1c <__umoddi3>
  8006cd:	83 c4 10             	add    $0x10,%esp
  8006d0:	05 f4 24 80 00       	add    $0x8024f4,%eax
  8006d5:	8a 00                	mov    (%eax),%al
  8006d7:	0f be c0             	movsbl %al,%eax
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	ff 75 0c             	pushl  0xc(%ebp)
  8006e0:	50                   	push   %eax
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	ff d0                	call   *%eax
  8006e6:	83 c4 10             	add    $0x10,%esp
}
  8006e9:	90                   	nop
  8006ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ed:	c9                   	leave  
  8006ee:	c3                   	ret    

008006ef <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006ef:	55                   	push   %ebp
  8006f0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006f2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f6:	7e 1c                	jle    800714 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	8d 50 08             	lea    0x8(%eax),%edx
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	89 10                	mov    %edx,(%eax)
  800705:	8b 45 08             	mov    0x8(%ebp),%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	83 e8 08             	sub    $0x8,%eax
  80070d:	8b 50 04             	mov    0x4(%eax),%edx
  800710:	8b 00                	mov    (%eax),%eax
  800712:	eb 40                	jmp    800754 <getuint+0x65>
	else if (lflag)
  800714:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800718:	74 1e                	je     800738 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	8d 50 04             	lea    0x4(%eax),%edx
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	89 10                	mov    %edx,(%eax)
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	83 e8 04             	sub    $0x4,%eax
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	ba 00 00 00 00       	mov    $0x0,%edx
  800736:	eb 1c                	jmp    800754 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	8d 50 04             	lea    0x4(%eax),%edx
  800740:	8b 45 08             	mov    0x8(%ebp),%eax
  800743:	89 10                	mov    %edx,(%eax)
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	8b 00                	mov    (%eax),%eax
  80074a:	83 e8 04             	sub    $0x4,%eax
  80074d:	8b 00                	mov    (%eax),%eax
  80074f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800754:	5d                   	pop    %ebp
  800755:	c3                   	ret    

00800756 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800756:	55                   	push   %ebp
  800757:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800759:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075d:	7e 1c                	jle    80077b <getint+0x25>
		return va_arg(*ap, long long);
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	8d 50 08             	lea    0x8(%eax),%edx
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	89 10                	mov    %edx,(%eax)
  80076c:	8b 45 08             	mov    0x8(%ebp),%eax
  80076f:	8b 00                	mov    (%eax),%eax
  800771:	83 e8 08             	sub    $0x8,%eax
  800774:	8b 50 04             	mov    0x4(%eax),%edx
  800777:	8b 00                	mov    (%eax),%eax
  800779:	eb 38                	jmp    8007b3 <getint+0x5d>
	else if (lflag)
  80077b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80077f:	74 1a                	je     80079b <getint+0x45>
		return va_arg(*ap, long);
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	8d 50 04             	lea    0x4(%eax),%edx
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	89 10                	mov    %edx,(%eax)
  80078e:	8b 45 08             	mov    0x8(%ebp),%eax
  800791:	8b 00                	mov    (%eax),%eax
  800793:	83 e8 04             	sub    $0x4,%eax
  800796:	8b 00                	mov    (%eax),%eax
  800798:	99                   	cltd   
  800799:	eb 18                	jmp    8007b3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	8d 50 04             	lea    0x4(%eax),%edx
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	89 10                	mov    %edx,(%eax)
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	8b 00                	mov    (%eax),%eax
  8007ad:	83 e8 04             	sub    $0x4,%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	99                   	cltd   
}
  8007b3:	5d                   	pop    %ebp
  8007b4:	c3                   	ret    

008007b5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	56                   	push   %esi
  8007b9:	53                   	push   %ebx
  8007ba:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bd:	eb 17                	jmp    8007d6 <vprintfmt+0x21>
			if (ch == '\0')
  8007bf:	85 db                	test   %ebx,%ebx
  8007c1:	0f 84 c1 03 00 00    	je     800b88 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007c7:	83 ec 08             	sub    $0x8,%esp
  8007ca:	ff 75 0c             	pushl  0xc(%ebp)
  8007cd:	53                   	push   %ebx
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	ff d0                	call   *%eax
  8007d3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d9:	8d 50 01             	lea    0x1(%eax),%edx
  8007dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8007df:	8a 00                	mov    (%eax),%al
  8007e1:	0f b6 d8             	movzbl %al,%ebx
  8007e4:	83 fb 25             	cmp    $0x25,%ebx
  8007e7:	75 d6                	jne    8007bf <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007ed:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007f4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800802:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800809:	8b 45 10             	mov    0x10(%ebp),%eax
  80080c:	8d 50 01             	lea    0x1(%eax),%edx
  80080f:	89 55 10             	mov    %edx,0x10(%ebp)
  800812:	8a 00                	mov    (%eax),%al
  800814:	0f b6 d8             	movzbl %al,%ebx
  800817:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80081a:	83 f8 5b             	cmp    $0x5b,%eax
  80081d:	0f 87 3d 03 00 00    	ja     800b60 <vprintfmt+0x3ab>
  800823:	8b 04 85 18 25 80 00 	mov    0x802518(,%eax,4),%eax
  80082a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80082c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800830:	eb d7                	jmp    800809 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800832:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800836:	eb d1                	jmp    800809 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800838:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80083f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800842:	89 d0                	mov    %edx,%eax
  800844:	c1 e0 02             	shl    $0x2,%eax
  800847:	01 d0                	add    %edx,%eax
  800849:	01 c0                	add    %eax,%eax
  80084b:	01 d8                	add    %ebx,%eax
  80084d:	83 e8 30             	sub    $0x30,%eax
  800850:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800853:	8b 45 10             	mov    0x10(%ebp),%eax
  800856:	8a 00                	mov    (%eax),%al
  800858:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80085b:	83 fb 2f             	cmp    $0x2f,%ebx
  80085e:	7e 3e                	jle    80089e <vprintfmt+0xe9>
  800860:	83 fb 39             	cmp    $0x39,%ebx
  800863:	7f 39                	jg     80089e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800865:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800868:	eb d5                	jmp    80083f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	83 c0 04             	add    $0x4,%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 e8 04             	sub    $0x4,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80087e:	eb 1f                	jmp    80089f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800880:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800884:	79 83                	jns    800809 <vprintfmt+0x54>
				width = 0;
  800886:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80088d:	e9 77 ff ff ff       	jmp    800809 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800892:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800899:	e9 6b ff ff ff       	jmp    800809 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80089e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80089f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a3:	0f 89 60 ff ff ff    	jns    800809 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008af:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008b6:	e9 4e ff ff ff       	jmp    800809 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008bb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008be:	e9 46 ff ff ff       	jmp    800809 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c6:	83 c0 04             	add    $0x4,%eax
  8008c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	83 e8 04             	sub    $0x4,%eax
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	50                   	push   %eax
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	ff d0                	call   *%eax
  8008e0:	83 c4 10             	add    $0x10,%esp
			break;
  8008e3:	e9 9b 02 00 00       	jmp    800b83 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	83 c0 04             	add    $0x4,%eax
  8008ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f4:	83 e8 04             	sub    $0x4,%eax
  8008f7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008f9:	85 db                	test   %ebx,%ebx
  8008fb:	79 02                	jns    8008ff <vprintfmt+0x14a>
				err = -err;
  8008fd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008ff:	83 fb 64             	cmp    $0x64,%ebx
  800902:	7f 0b                	jg     80090f <vprintfmt+0x15a>
  800904:	8b 34 9d 60 23 80 00 	mov    0x802360(,%ebx,4),%esi
  80090b:	85 f6                	test   %esi,%esi
  80090d:	75 19                	jne    800928 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80090f:	53                   	push   %ebx
  800910:	68 05 25 80 00       	push   $0x802505
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	ff 75 08             	pushl  0x8(%ebp)
  80091b:	e8 70 02 00 00       	call   800b90 <printfmt>
  800920:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800923:	e9 5b 02 00 00       	jmp    800b83 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800928:	56                   	push   %esi
  800929:	68 0e 25 80 00       	push   $0x80250e
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	ff 75 08             	pushl  0x8(%ebp)
  800934:	e8 57 02 00 00       	call   800b90 <printfmt>
  800939:	83 c4 10             	add    $0x10,%esp
			break;
  80093c:	e9 42 02 00 00       	jmp    800b83 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800941:	8b 45 14             	mov    0x14(%ebp),%eax
  800944:	83 c0 04             	add    $0x4,%eax
  800947:	89 45 14             	mov    %eax,0x14(%ebp)
  80094a:	8b 45 14             	mov    0x14(%ebp),%eax
  80094d:	83 e8 04             	sub    $0x4,%eax
  800950:	8b 30                	mov    (%eax),%esi
  800952:	85 f6                	test   %esi,%esi
  800954:	75 05                	jne    80095b <vprintfmt+0x1a6>
				p = "(null)";
  800956:	be 11 25 80 00       	mov    $0x802511,%esi
			if (width > 0 && padc != '-')
  80095b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095f:	7e 6d                	jle    8009ce <vprintfmt+0x219>
  800961:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800965:	74 67                	je     8009ce <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800967:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80096a:	83 ec 08             	sub    $0x8,%esp
  80096d:	50                   	push   %eax
  80096e:	56                   	push   %esi
  80096f:	e8 26 05 00 00       	call   800e9a <strnlen>
  800974:	83 c4 10             	add    $0x10,%esp
  800977:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80097a:	eb 16                	jmp    800992 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80097c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800980:	83 ec 08             	sub    $0x8,%esp
  800983:	ff 75 0c             	pushl  0xc(%ebp)
  800986:	50                   	push   %eax
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	ff d0                	call   *%eax
  80098c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80098f:	ff 4d e4             	decl   -0x1c(%ebp)
  800992:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800996:	7f e4                	jg     80097c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800998:	eb 34                	jmp    8009ce <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80099a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80099e:	74 1c                	je     8009bc <vprintfmt+0x207>
  8009a0:	83 fb 1f             	cmp    $0x1f,%ebx
  8009a3:	7e 05                	jle    8009aa <vprintfmt+0x1f5>
  8009a5:	83 fb 7e             	cmp    $0x7e,%ebx
  8009a8:	7e 12                	jle    8009bc <vprintfmt+0x207>
					putch('?', putdat);
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	6a 3f                	push   $0x3f
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	ff d0                	call   *%eax
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	eb 0f                	jmp    8009cb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	53                   	push   %ebx
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	ff d0                	call   *%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009cb:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ce:	89 f0                	mov    %esi,%eax
  8009d0:	8d 70 01             	lea    0x1(%eax),%esi
  8009d3:	8a 00                	mov    (%eax),%al
  8009d5:	0f be d8             	movsbl %al,%ebx
  8009d8:	85 db                	test   %ebx,%ebx
  8009da:	74 24                	je     800a00 <vprintfmt+0x24b>
  8009dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e0:	78 b8                	js     80099a <vprintfmt+0x1e5>
  8009e2:	ff 4d e0             	decl   -0x20(%ebp)
  8009e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e9:	79 af                	jns    80099a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009eb:	eb 13                	jmp    800a00 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	ff 75 0c             	pushl  0xc(%ebp)
  8009f3:	6a 20                	push   $0x20
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	ff d0                	call   *%eax
  8009fa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009fd:	ff 4d e4             	decl   -0x1c(%ebp)
  800a00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a04:	7f e7                	jg     8009ed <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a06:	e9 78 01 00 00       	jmp    800b83 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a0b:	83 ec 08             	sub    $0x8,%esp
  800a0e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a11:	8d 45 14             	lea    0x14(%ebp),%eax
  800a14:	50                   	push   %eax
  800a15:	e8 3c fd ff ff       	call   800756 <getint>
  800a1a:	83 c4 10             	add    $0x10,%esp
  800a1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a20:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a29:	85 d2                	test   %edx,%edx
  800a2b:	79 23                	jns    800a50 <vprintfmt+0x29b>
				putch('-', putdat);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 0c             	pushl  0xc(%ebp)
  800a33:	6a 2d                	push   $0x2d
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	ff d0                	call   *%eax
  800a3a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a43:	f7 d8                	neg    %eax
  800a45:	83 d2 00             	adc    $0x0,%edx
  800a48:	f7 da                	neg    %edx
  800a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a50:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a57:	e9 bc 00 00 00       	jmp    800b18 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 e8             	pushl  -0x18(%ebp)
  800a62:	8d 45 14             	lea    0x14(%ebp),%eax
  800a65:	50                   	push   %eax
  800a66:	e8 84 fc ff ff       	call   8006ef <getuint>
  800a6b:	83 c4 10             	add    $0x10,%esp
  800a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a71:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a74:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a7b:	e9 98 00 00 00       	jmp    800b18 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a80:	83 ec 08             	sub    $0x8,%esp
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	6a 58                	push   $0x58
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	ff d0                	call   *%eax
  800a8d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a90:	83 ec 08             	sub    $0x8,%esp
  800a93:	ff 75 0c             	pushl  0xc(%ebp)
  800a96:	6a 58                	push   $0x58
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	ff d0                	call   *%eax
  800a9d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 0c             	pushl  0xc(%ebp)
  800aa6:	6a 58                	push   $0x58
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	ff d0                	call   *%eax
  800aad:	83 c4 10             	add    $0x10,%esp
			break;
  800ab0:	e9 ce 00 00 00       	jmp    800b83 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ab5:	83 ec 08             	sub    $0x8,%esp
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	6a 30                	push   $0x30
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	ff d0                	call   *%eax
  800ac2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	6a 78                	push   $0x78
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	ff d0                	call   *%eax
  800ad2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad8:	83 c0 04             	add    $0x4,%eax
  800adb:	89 45 14             	mov    %eax,0x14(%ebp)
  800ade:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae1:	83 e8 04             	sub    $0x4,%eax
  800ae4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800af0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800af7:	eb 1f                	jmp    800b18 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800af9:	83 ec 08             	sub    $0x8,%esp
  800afc:	ff 75 e8             	pushl  -0x18(%ebp)
  800aff:	8d 45 14             	lea    0x14(%ebp),%eax
  800b02:	50                   	push   %eax
  800b03:	e8 e7 fb ff ff       	call   8006ef <getuint>
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b11:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b18:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b1f:	83 ec 04             	sub    $0x4,%esp
  800b22:	52                   	push   %edx
  800b23:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b26:	50                   	push   %eax
  800b27:	ff 75 f4             	pushl  -0xc(%ebp)
  800b2a:	ff 75 f0             	pushl  -0x10(%ebp)
  800b2d:	ff 75 0c             	pushl  0xc(%ebp)
  800b30:	ff 75 08             	pushl  0x8(%ebp)
  800b33:	e8 00 fb ff ff       	call   800638 <printnum>
  800b38:	83 c4 20             	add    $0x20,%esp
			break;
  800b3b:	eb 46                	jmp    800b83 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b3d:	83 ec 08             	sub    $0x8,%esp
  800b40:	ff 75 0c             	pushl  0xc(%ebp)
  800b43:	53                   	push   %ebx
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	ff d0                	call   *%eax
  800b49:	83 c4 10             	add    $0x10,%esp
			break;
  800b4c:	eb 35                	jmp    800b83 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b4e:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800b55:	eb 2c                	jmp    800b83 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b57:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800b5e:	eb 23                	jmp    800b83 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b60:	83 ec 08             	sub    $0x8,%esp
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	6a 25                	push   $0x25
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	ff d0                	call   *%eax
  800b6d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b70:	ff 4d 10             	decl   0x10(%ebp)
  800b73:	eb 03                	jmp    800b78 <vprintfmt+0x3c3>
  800b75:	ff 4d 10             	decl   0x10(%ebp)
  800b78:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7b:	48                   	dec    %eax
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	3c 25                	cmp    $0x25,%al
  800b80:	75 f3                	jne    800b75 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b82:	90                   	nop
		}
	}
  800b83:	e9 35 fc ff ff       	jmp    8007bd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b88:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b8c:	5b                   	pop    %ebx
  800b8d:	5e                   	pop    %esi
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b96:	8d 45 10             	lea    0x10(%ebp),%eax
  800b99:	83 c0 04             	add    $0x4,%eax
  800b9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba5:	50                   	push   %eax
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	ff 75 08             	pushl  0x8(%ebp)
  800bac:	e8 04 fc ff ff       	call   8007b5 <vprintfmt>
  800bb1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bb4:	90                   	nop
  800bb5:	c9                   	leave  
  800bb6:	c3                   	ret    

00800bb7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbd:	8b 40 08             	mov    0x8(%eax),%eax
  800bc0:	8d 50 01             	lea    0x1(%eax),%edx
  800bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcc:	8b 10                	mov    (%eax),%edx
  800bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd1:	8b 40 04             	mov    0x4(%eax),%eax
  800bd4:	39 c2                	cmp    %eax,%edx
  800bd6:	73 12                	jae    800bea <sprintputch+0x33>
		*b->buf++ = ch;
  800bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdb:	8b 00                	mov    (%eax),%eax
  800bdd:	8d 48 01             	lea    0x1(%eax),%ecx
  800be0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be3:	89 0a                	mov    %ecx,(%edx)
  800be5:	8b 55 08             	mov    0x8(%ebp),%edx
  800be8:	88 10                	mov    %dl,(%eax)
}
  800bea:	90                   	nop
  800beb:	5d                   	pop    %ebp
  800bec:	c3                   	ret    

00800bed <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	01 d0                	add    %edx,%eax
  800c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c12:	74 06                	je     800c1a <vsnprintf+0x2d>
  800c14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c18:	7f 07                	jg     800c21 <vsnprintf+0x34>
		return -E_INVAL;
  800c1a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c1f:	eb 20                	jmp    800c41 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c21:	ff 75 14             	pushl  0x14(%ebp)
  800c24:	ff 75 10             	pushl  0x10(%ebp)
  800c27:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c2a:	50                   	push   %eax
  800c2b:	68 b7 0b 80 00       	push   $0x800bb7
  800c30:	e8 80 fb ff ff       	call   8007b5 <vprintfmt>
  800c35:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c3b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c49:	8d 45 10             	lea    0x10(%ebp),%eax
  800c4c:	83 c0 04             	add    $0x4,%eax
  800c4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
  800c55:	ff 75 f4             	pushl  -0xc(%ebp)
  800c58:	50                   	push   %eax
  800c59:	ff 75 0c             	pushl  0xc(%ebp)
  800c5c:	ff 75 08             	pushl  0x8(%ebp)
  800c5f:	e8 89 ff ff ff       	call   800bed <vsnprintf>
  800c64:	83 c4 10             	add    $0x10,%esp
  800c67:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c6d:	c9                   	leave  
  800c6e:	c3                   	ret    

00800c6f <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800c75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c79:	74 13                	je     800c8e <readline+0x1f>
		cprintf("%s", prompt);
  800c7b:	83 ec 08             	sub    $0x8,%esp
  800c7e:	ff 75 08             	pushl  0x8(%ebp)
  800c81:	68 88 26 80 00       	push   $0x802688
  800c86:	e8 50 f9 ff ff       	call   8005db <cprintf>
  800c8b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800c8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800c95:	83 ec 0c             	sub    $0xc,%esp
  800c98:	6a 00                	push   $0x0
  800c9a:	e8 60 10 00 00       	call   801cff <iscons>
  800c9f:	83 c4 10             	add    $0x10,%esp
  800ca2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800ca5:	e8 42 10 00 00       	call   801cec <getchar>
  800caa:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800cad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800cb1:	79 22                	jns    800cd5 <readline+0x66>
			if (c != -E_EOF)
  800cb3:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800cb7:	0f 84 ad 00 00 00    	je     800d6a <readline+0xfb>
				cprintf("read error: %e\n", c);
  800cbd:	83 ec 08             	sub    $0x8,%esp
  800cc0:	ff 75 ec             	pushl  -0x14(%ebp)
  800cc3:	68 8b 26 80 00       	push   $0x80268b
  800cc8:	e8 0e f9 ff ff       	call   8005db <cprintf>
  800ccd:	83 c4 10             	add    $0x10,%esp
			break;
  800cd0:	e9 95 00 00 00       	jmp    800d6a <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800cd5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800cd9:	7e 34                	jle    800d0f <readline+0xa0>
  800cdb:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ce2:	7f 2b                	jg     800d0f <readline+0xa0>
			if (echoing)
  800ce4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ce8:	74 0e                	je     800cf8 <readline+0x89>
				cputchar(c);
  800cea:	83 ec 0c             	sub    $0xc,%esp
  800ced:	ff 75 ec             	pushl  -0x14(%ebp)
  800cf0:	e8 d8 0f 00 00       	call   801ccd <cputchar>
  800cf5:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cfb:	8d 50 01             	lea    0x1(%eax),%edx
  800cfe:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800d01:	89 c2                	mov    %eax,%edx
  800d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d06:	01 d0                	add    %edx,%eax
  800d08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d0b:	88 10                	mov    %dl,(%eax)
  800d0d:	eb 56                	jmp    800d65 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800d0f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800d13:	75 1f                	jne    800d34 <readline+0xc5>
  800d15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800d19:	7e 19                	jle    800d34 <readline+0xc5>
			if (echoing)
  800d1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d1f:	74 0e                	je     800d2f <readline+0xc0>
				cputchar(c);
  800d21:	83 ec 0c             	sub    $0xc,%esp
  800d24:	ff 75 ec             	pushl  -0x14(%ebp)
  800d27:	e8 a1 0f 00 00       	call   801ccd <cputchar>
  800d2c:	83 c4 10             	add    $0x10,%esp

			i--;
  800d2f:	ff 4d f4             	decl   -0xc(%ebp)
  800d32:	eb 31                	jmp    800d65 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800d34:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800d38:	74 0a                	je     800d44 <readline+0xd5>
  800d3a:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800d3e:	0f 85 61 ff ff ff    	jne    800ca5 <readline+0x36>
			if (echoing)
  800d44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d48:	74 0e                	je     800d58 <readline+0xe9>
				cputchar(c);
  800d4a:	83 ec 0c             	sub    $0xc,%esp
  800d4d:	ff 75 ec             	pushl  -0x14(%ebp)
  800d50:	e8 78 0f 00 00       	call   801ccd <cputchar>
  800d55:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800d58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	01 d0                	add    %edx,%eax
  800d60:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800d63:	eb 06                	jmp    800d6b <readline+0xfc>
		}
	}
  800d65:	e9 3b ff ff ff       	jmp    800ca5 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800d6a:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800d6b:	90                   	nop
  800d6c:	c9                   	leave  
  800d6d:	c3                   	ret    

00800d6e <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800d74:	e8 71 08 00 00       	call   8015ea <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800d79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d7d:	74 13                	je     800d92 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 08             	pushl  0x8(%ebp)
  800d85:	68 88 26 80 00       	push   $0x802688
  800d8a:	e8 4c f8 ff ff       	call   8005db <cprintf>
  800d8f:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800d92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800d99:	83 ec 0c             	sub    $0xc,%esp
  800d9c:	6a 00                	push   $0x0
  800d9e:	e8 5c 0f 00 00       	call   801cff <iscons>
  800da3:	83 c4 10             	add    $0x10,%esp
  800da6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800da9:	e8 3e 0f 00 00       	call   801cec <getchar>
  800dae:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800db1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800db5:	79 22                	jns    800dd9 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800db7:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800dbb:	0f 84 ad 00 00 00    	je     800e6e <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800dc1:	83 ec 08             	sub    $0x8,%esp
  800dc4:	ff 75 ec             	pushl  -0x14(%ebp)
  800dc7:	68 8b 26 80 00       	push   $0x80268b
  800dcc:	e8 0a f8 ff ff       	call   8005db <cprintf>
  800dd1:	83 c4 10             	add    $0x10,%esp
				break;
  800dd4:	e9 95 00 00 00       	jmp    800e6e <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800dd9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ddd:	7e 34                	jle    800e13 <atomic_readline+0xa5>
  800ddf:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800de6:	7f 2b                	jg     800e13 <atomic_readline+0xa5>
				if (echoing)
  800de8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800dec:	74 0e                	je     800dfc <atomic_readline+0x8e>
					cputchar(c);
  800dee:	83 ec 0c             	sub    $0xc,%esp
  800df1:	ff 75 ec             	pushl  -0x14(%ebp)
  800df4:	e8 d4 0e 00 00       	call   801ccd <cputchar>
  800df9:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dff:	8d 50 01             	lea    0x1(%eax),%edx
  800e02:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800e05:	89 c2                	mov    %eax,%edx
  800e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0a:	01 d0                	add    %edx,%eax
  800e0c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e0f:	88 10                	mov    %dl,(%eax)
  800e11:	eb 56                	jmp    800e69 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800e13:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800e17:	75 1f                	jne    800e38 <atomic_readline+0xca>
  800e19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800e1d:	7e 19                	jle    800e38 <atomic_readline+0xca>
				if (echoing)
  800e1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e23:	74 0e                	je     800e33 <atomic_readline+0xc5>
					cputchar(c);
  800e25:	83 ec 0c             	sub    $0xc,%esp
  800e28:	ff 75 ec             	pushl  -0x14(%ebp)
  800e2b:	e8 9d 0e 00 00       	call   801ccd <cputchar>
  800e30:	83 c4 10             	add    $0x10,%esp
				i--;
  800e33:	ff 4d f4             	decl   -0xc(%ebp)
  800e36:	eb 31                	jmp    800e69 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800e38:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800e3c:	74 0a                	je     800e48 <atomic_readline+0xda>
  800e3e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800e42:	0f 85 61 ff ff ff    	jne    800da9 <atomic_readline+0x3b>
				if (echoing)
  800e48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e4c:	74 0e                	je     800e5c <atomic_readline+0xee>
					cputchar(c);
  800e4e:	83 ec 0c             	sub    $0xc,%esp
  800e51:	ff 75 ec             	pushl  -0x14(%ebp)
  800e54:	e8 74 0e 00 00       	call   801ccd <cputchar>
  800e59:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800e5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e62:	01 d0                	add    %edx,%eax
  800e64:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800e67:	eb 06                	jmp    800e6f <atomic_readline+0x101>
			}
		}
  800e69:	e9 3b ff ff ff       	jmp    800da9 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800e6e:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800e6f:	e8 90 07 00 00       	call   801604 <sys_unlock_cons>
}
  800e74:	90                   	nop
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e84:	eb 06                	jmp    800e8c <strlen+0x15>
		n++;
  800e86:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e89:	ff 45 08             	incl   0x8(%ebp)
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	84 c0                	test   %al,%al
  800e93:	75 f1                	jne    800e86 <strlen+0xf>
		n++;
	return n;
  800e95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e98:	c9                   	leave  
  800e99:	c3                   	ret    

00800e9a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea7:	eb 09                	jmp    800eb2 <strnlen+0x18>
		n++;
  800ea9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eac:	ff 45 08             	incl   0x8(%ebp)
  800eaf:	ff 4d 0c             	decl   0xc(%ebp)
  800eb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eb6:	74 09                	je     800ec1 <strnlen+0x27>
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	84 c0                	test   %al,%al
  800ebf:	75 e8                	jne    800ea9 <strnlen+0xf>
		n++;
	return n;
  800ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ec4:	c9                   	leave  
  800ec5:	c3                   	ret    

00800ec6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ed2:	90                   	nop
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8d 50 01             	lea    0x1(%eax),%edx
  800ed9:	89 55 08             	mov    %edx,0x8(%ebp)
  800edc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800edf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ee5:	8a 12                	mov    (%edx),%dl
  800ee7:	88 10                	mov    %dl,(%eax)
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	84 c0                	test   %al,%al
  800eed:	75 e4                	jne    800ed3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800eef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    

00800ef4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f07:	eb 1f                	jmp    800f28 <strncpy+0x34>
		*dst++ = *src;
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	8d 50 01             	lea    0x1(%eax),%edx
  800f0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800f12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f15:	8a 12                	mov    (%edx),%dl
  800f17:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	84 c0                	test   %al,%al
  800f20:	74 03                	je     800f25 <strncpy+0x31>
			src++;
  800f22:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f25:	ff 45 fc             	incl   -0x4(%ebp)
  800f28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f2e:	72 d9                	jb     800f09 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f30:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f33:	c9                   	leave  
  800f34:	c3                   	ret    

00800f35 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f45:	74 30                	je     800f77 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f47:	eb 16                	jmp    800f5f <strlcpy+0x2a>
			*dst++ = *src++;
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8d 50 01             	lea    0x1(%eax),%edx
  800f4f:	89 55 08             	mov    %edx,0x8(%ebp)
  800f52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f55:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f58:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f5b:	8a 12                	mov    (%edx),%dl
  800f5d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f5f:	ff 4d 10             	decl   0x10(%ebp)
  800f62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f66:	74 09                	je     800f71 <strlcpy+0x3c>
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	84 c0                	test   %al,%al
  800f6f:	75 d8                	jne    800f49 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f77:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7d:	29 c2                	sub    %eax,%edx
  800f7f:	89 d0                	mov    %edx,%eax
}
  800f81:	c9                   	leave  
  800f82:	c3                   	ret    

00800f83 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f86:	eb 06                	jmp    800f8e <strcmp+0xb>
		p++, q++;
  800f88:	ff 45 08             	incl   0x8(%ebp)
  800f8b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	84 c0                	test   %al,%al
  800f95:	74 0e                	je     800fa5 <strcmp+0x22>
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 10                	mov    (%eax),%dl
  800f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	38 c2                	cmp    %al,%dl
  800fa3:	74 e3                	je     800f88 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	0f b6 d0             	movzbl %al,%edx
  800fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	0f b6 c0             	movzbl %al,%eax
  800fb5:	29 c2                	sub    %eax,%edx
  800fb7:	89 d0                	mov    %edx,%eax
}
  800fb9:	5d                   	pop    %ebp
  800fba:	c3                   	ret    

00800fbb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fbe:	eb 09                	jmp    800fc9 <strncmp+0xe>
		n--, p++, q++;
  800fc0:	ff 4d 10             	decl   0x10(%ebp)
  800fc3:	ff 45 08             	incl   0x8(%ebp)
  800fc6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fc9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcd:	74 17                	je     800fe6 <strncmp+0x2b>
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	84 c0                	test   %al,%al
  800fd6:	74 0e                	je     800fe6 <strncmp+0x2b>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 10                	mov    (%eax),%dl
  800fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe0:	8a 00                	mov    (%eax),%al
  800fe2:	38 c2                	cmp    %al,%dl
  800fe4:	74 da                	je     800fc0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fe6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fea:	75 07                	jne    800ff3 <strncmp+0x38>
		return 0;
  800fec:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff1:	eb 14                	jmp    801007 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	0f b6 d0             	movzbl %al,%edx
  800ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	0f b6 c0             	movzbl %al,%eax
  801003:	29 c2                	sub    %eax,%edx
  801005:	89 d0                	mov    %edx,%eax
}
  801007:	5d                   	pop    %ebp
  801008:	c3                   	ret    

00801009 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 04             	sub    $0x4,%esp
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801015:	eb 12                	jmp    801029 <strchr+0x20>
		if (*s == c)
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80101f:	75 05                	jne    801026 <strchr+0x1d>
			return (char *) s;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	eb 11                	jmp    801037 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801026:	ff 45 08             	incl   0x8(%ebp)
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	84 c0                	test   %al,%al
  801030:	75 e5                	jne    801017 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801032:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	83 ec 04             	sub    $0x4,%esp
  80103f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801042:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801045:	eb 0d                	jmp    801054 <strfind+0x1b>
		if (*s == c)
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	8a 00                	mov    (%eax),%al
  80104c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80104f:	74 0e                	je     80105f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801051:	ff 45 08             	incl   0x8(%ebp)
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	84 c0                	test   %al,%al
  80105b:	75 ea                	jne    801047 <strfind+0xe>
  80105d:	eb 01                	jmp    801060 <strfind+0x27>
		if (*s == c)
			break;
  80105f:	90                   	nop
	return (char *) s;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801071:	8b 45 10             	mov    0x10(%ebp),%eax
  801074:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801077:	eb 0e                	jmp    801087 <memset+0x22>
		*p++ = c;
  801079:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107c:	8d 50 01             	lea    0x1(%eax),%edx
  80107f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801082:	8b 55 0c             	mov    0xc(%ebp),%edx
  801085:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801087:	ff 4d f8             	decl   -0x8(%ebp)
  80108a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80108e:	79 e9                	jns    801079 <memset+0x14>
		*p++ = c;

	return v;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80109b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010a7:	eb 16                	jmp    8010bf <memcpy+0x2a>
		*d++ = *s++;
  8010a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ac:	8d 50 01             	lea    0x1(%eax),%edx
  8010af:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010bb:	8a 12                	mov    (%edx),%dl
  8010bd:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c5:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	75 dd                	jne    8010a9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010e9:	73 50                	jae    80113b <memmove+0x6a>
  8010eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f1:	01 d0                	add    %edx,%eax
  8010f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f6:	76 43                	jbe    80113b <memmove+0x6a>
		s += n;
  8010f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fb:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801101:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801104:	eb 10                	jmp    801116 <memmove+0x45>
			*--d = *--s;
  801106:	ff 4d f8             	decl   -0x8(%ebp)
  801109:	ff 4d fc             	decl   -0x4(%ebp)
  80110c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110f:	8a 10                	mov    (%eax),%dl
  801111:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801114:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801116:	8b 45 10             	mov    0x10(%ebp),%eax
  801119:	8d 50 ff             	lea    -0x1(%eax),%edx
  80111c:	89 55 10             	mov    %edx,0x10(%ebp)
  80111f:	85 c0                	test   %eax,%eax
  801121:	75 e3                	jne    801106 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801123:	eb 23                	jmp    801148 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801125:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801128:	8d 50 01             	lea    0x1(%eax),%edx
  80112b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80112e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801131:	8d 4a 01             	lea    0x1(%edx),%ecx
  801134:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801137:	8a 12                	mov    (%edx),%dl
  801139:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80113b:	8b 45 10             	mov    0x10(%ebp),%eax
  80113e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801141:	89 55 10             	mov    %edx,0x10(%ebp)
  801144:	85 c0                	test   %eax,%eax
  801146:	75 dd                	jne    801125 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80115f:	eb 2a                	jmp    80118b <memcmp+0x3e>
		if (*s1 != *s2)
  801161:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801164:	8a 10                	mov    (%eax),%dl
  801166:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	38 c2                	cmp    %al,%dl
  80116d:	74 16                	je     801185 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80116f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	0f b6 d0             	movzbl %al,%edx
  801177:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	0f b6 c0             	movzbl %al,%eax
  80117f:	29 c2                	sub    %eax,%edx
  801181:	89 d0                	mov    %edx,%eax
  801183:	eb 18                	jmp    80119d <memcmp+0x50>
		s1++, s2++;
  801185:	ff 45 fc             	incl   -0x4(%ebp)
  801188:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80118b:	8b 45 10             	mov    0x10(%ebp),%eax
  80118e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801191:	89 55 10             	mov    %edx,0x10(%ebp)
  801194:	85 c0                	test   %eax,%eax
  801196:	75 c9                	jne    801161 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801198:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80119d:	c9                   	leave  
  80119e:	c3                   	ret    

0080119f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ab:	01 d0                	add    %edx,%eax
  8011ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011b0:	eb 15                	jmp    8011c7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	8a 00                	mov    (%eax),%al
  8011b7:	0f b6 d0             	movzbl %al,%edx
  8011ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bd:	0f b6 c0             	movzbl %al,%eax
  8011c0:	39 c2                	cmp    %eax,%edx
  8011c2:	74 0d                	je     8011d1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011c4:	ff 45 08             	incl   0x8(%ebp)
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011cd:	72 e3                	jb     8011b2 <memfind+0x13>
  8011cf:	eb 01                	jmp    8011d2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011d1:	90                   	nop
	return (void *) s;
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011e4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011eb:	eb 03                	jmp    8011f0 <strtol+0x19>
		s++;
  8011ed:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	3c 20                	cmp    $0x20,%al
  8011f7:	74 f4                	je     8011ed <strtol+0x16>
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	3c 09                	cmp    $0x9,%al
  801200:	74 eb                	je     8011ed <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	3c 2b                	cmp    $0x2b,%al
  801209:	75 05                	jne    801210 <strtol+0x39>
		s++;
  80120b:	ff 45 08             	incl   0x8(%ebp)
  80120e:	eb 13                	jmp    801223 <strtol+0x4c>
	else if (*s == '-')
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	8a 00                	mov    (%eax),%al
  801215:	3c 2d                	cmp    $0x2d,%al
  801217:	75 0a                	jne    801223 <strtol+0x4c>
		s++, neg = 1;
  801219:	ff 45 08             	incl   0x8(%ebp)
  80121c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801223:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801227:	74 06                	je     80122f <strtol+0x58>
  801229:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80122d:	75 20                	jne    80124f <strtol+0x78>
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	3c 30                	cmp    $0x30,%al
  801236:	75 17                	jne    80124f <strtol+0x78>
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	40                   	inc    %eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	3c 78                	cmp    $0x78,%al
  801240:	75 0d                	jne    80124f <strtol+0x78>
		s += 2, base = 16;
  801242:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801246:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80124d:	eb 28                	jmp    801277 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80124f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801253:	75 15                	jne    80126a <strtol+0x93>
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	3c 30                	cmp    $0x30,%al
  80125c:	75 0c                	jne    80126a <strtol+0x93>
		s++, base = 8;
  80125e:	ff 45 08             	incl   0x8(%ebp)
  801261:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801268:	eb 0d                	jmp    801277 <strtol+0xa0>
	else if (base == 0)
  80126a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80126e:	75 07                	jne    801277 <strtol+0xa0>
		base = 10;
  801270:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	3c 2f                	cmp    $0x2f,%al
  80127e:	7e 19                	jle    801299 <strtol+0xc2>
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	3c 39                	cmp    $0x39,%al
  801287:	7f 10                	jg     801299 <strtol+0xc2>
			dig = *s - '0';
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	0f be c0             	movsbl %al,%eax
  801291:	83 e8 30             	sub    $0x30,%eax
  801294:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801297:	eb 42                	jmp    8012db <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	3c 60                	cmp    $0x60,%al
  8012a0:	7e 19                	jle    8012bb <strtol+0xe4>
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	3c 7a                	cmp    $0x7a,%al
  8012a9:	7f 10                	jg     8012bb <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	0f be c0             	movsbl %al,%eax
  8012b3:	83 e8 57             	sub    $0x57,%eax
  8012b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012b9:	eb 20                	jmp    8012db <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	8a 00                	mov    (%eax),%al
  8012c0:	3c 40                	cmp    $0x40,%al
  8012c2:	7e 39                	jle    8012fd <strtol+0x126>
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	3c 5a                	cmp    $0x5a,%al
  8012cb:	7f 30                	jg     8012fd <strtol+0x126>
			dig = *s - 'A' + 10;
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	0f be c0             	movsbl %al,%eax
  8012d5:	83 e8 37             	sub    $0x37,%eax
  8012d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012de:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012e1:	7d 19                	jge    8012fc <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012e3:	ff 45 08             	incl   0x8(%ebp)
  8012e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012ed:	89 c2                	mov    %eax,%edx
  8012ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f2:	01 d0                	add    %edx,%eax
  8012f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012f7:	e9 7b ff ff ff       	jmp    801277 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012fc:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801301:	74 08                	je     80130b <strtol+0x134>
		*endptr = (char *) s;
  801303:	8b 45 0c             	mov    0xc(%ebp),%eax
  801306:	8b 55 08             	mov    0x8(%ebp),%edx
  801309:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80130b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80130f:	74 07                	je     801318 <strtol+0x141>
  801311:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801314:	f7 d8                	neg    %eax
  801316:	eb 03                	jmp    80131b <strtol+0x144>
  801318:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <ltostr>:

void
ltostr(long value, char *str)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801323:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80132a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801331:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801335:	79 13                	jns    80134a <ltostr+0x2d>
	{
		neg = 1;
  801337:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80133e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801341:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801344:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801347:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801352:	99                   	cltd   
  801353:	f7 f9                	idiv   %ecx
  801355:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801358:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135b:	8d 50 01             	lea    0x1(%eax),%edx
  80135e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801361:	89 c2                	mov    %eax,%edx
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80136b:	83 c2 30             	add    $0x30,%edx
  80136e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801370:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801373:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801378:	f7 e9                	imul   %ecx
  80137a:	c1 fa 02             	sar    $0x2,%edx
  80137d:	89 c8                	mov    %ecx,%eax
  80137f:	c1 f8 1f             	sar    $0x1f,%eax
  801382:	29 c2                	sub    %eax,%edx
  801384:	89 d0                	mov    %edx,%eax
  801386:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801389:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138d:	75 bb                	jne    80134a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80138f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801396:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801399:	48                   	dec    %eax
  80139a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80139d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013a1:	74 3d                	je     8013e0 <ltostr+0xc3>
		start = 1 ;
  8013a3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013aa:	eb 34                	jmp    8013e0 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b2:	01 d0                	add    %edx,%eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bf:	01 c2                	add    %eax,%edx
  8013c1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	01 c8                	add    %ecx,%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d3:	01 c2                	add    %eax,%edx
  8013d5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013d8:	88 02                	mov    %al,(%edx)
		start++ ;
  8013da:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013dd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e6:	7c c4                	jl     8013ac <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013e8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ee:	01 d0                	add    %edx,%eax
  8013f0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013f3:	90                   	nop
  8013f4:	c9                   	leave  
  8013f5:	c3                   	ret    

008013f6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013fc:	ff 75 08             	pushl  0x8(%ebp)
  8013ff:	e8 73 fa ff ff       	call   800e77 <strlen>
  801404:	83 c4 04             	add    $0x4,%esp
  801407:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80140a:	ff 75 0c             	pushl  0xc(%ebp)
  80140d:	e8 65 fa ff ff       	call   800e77 <strlen>
  801412:	83 c4 04             	add    $0x4,%esp
  801415:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80141f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801426:	eb 17                	jmp    80143f <strcconcat+0x49>
		final[s] = str1[s] ;
  801428:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142b:	8b 45 10             	mov    0x10(%ebp),%eax
  80142e:	01 c2                	add    %eax,%edx
  801430:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	01 c8                	add    %ecx,%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80143c:	ff 45 fc             	incl   -0x4(%ebp)
  80143f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801442:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801445:	7c e1                	jl     801428 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801447:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80144e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801455:	eb 1f                	jmp    801476 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801457:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80145a:	8d 50 01             	lea    0x1(%eax),%edx
  80145d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801460:	89 c2                	mov    %eax,%edx
  801462:	8b 45 10             	mov    0x10(%ebp),%eax
  801465:	01 c2                	add    %eax,%edx
  801467:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80146a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146d:	01 c8                	add    %ecx,%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801473:	ff 45 f8             	incl   -0x8(%ebp)
  801476:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801479:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80147c:	7c d9                	jl     801457 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80147e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801481:	8b 45 10             	mov    0x10(%ebp),%eax
  801484:	01 d0                	add    %edx,%eax
  801486:	c6 00 00             	movb   $0x0,(%eax)
}
  801489:	90                   	nop
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80148f:	8b 45 14             	mov    0x14(%ebp),%eax
  801492:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801498:	8b 45 14             	mov    0x14(%ebp),%eax
  80149b:	8b 00                	mov    (%eax),%eax
  80149d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a7:	01 d0                	add    %edx,%eax
  8014a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014af:	eb 0c                	jmp    8014bd <strsplit+0x31>
			*string++ = 0;
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	8d 50 01             	lea    0x1(%eax),%edx
  8014b7:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ba:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	84 c0                	test   %al,%al
  8014c4:	74 18                	je     8014de <strsplit+0x52>
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	8a 00                	mov    (%eax),%al
  8014cb:	0f be c0             	movsbl %al,%eax
  8014ce:	50                   	push   %eax
  8014cf:	ff 75 0c             	pushl  0xc(%ebp)
  8014d2:	e8 32 fb ff ff       	call   801009 <strchr>
  8014d7:	83 c4 08             	add    $0x8,%esp
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	75 d3                	jne    8014b1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	84 c0                	test   %al,%al
  8014e5:	74 5a                	je     801541 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ea:	8b 00                	mov    (%eax),%eax
  8014ec:	83 f8 0f             	cmp    $0xf,%eax
  8014ef:	75 07                	jne    8014f8 <strsplit+0x6c>
		{
			return 0;
  8014f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f6:	eb 66                	jmp    80155e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fb:	8b 00                	mov    (%eax),%eax
  8014fd:	8d 48 01             	lea    0x1(%eax),%ecx
  801500:	8b 55 14             	mov    0x14(%ebp),%edx
  801503:	89 0a                	mov    %ecx,(%edx)
  801505:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80150c:	8b 45 10             	mov    0x10(%ebp),%eax
  80150f:	01 c2                	add    %eax,%edx
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801516:	eb 03                	jmp    80151b <strsplit+0x8f>
			string++;
  801518:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	84 c0                	test   %al,%al
  801522:	74 8b                	je     8014af <strsplit+0x23>
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	0f be c0             	movsbl %al,%eax
  80152c:	50                   	push   %eax
  80152d:	ff 75 0c             	pushl  0xc(%ebp)
  801530:	e8 d4 fa ff ff       	call   801009 <strchr>
  801535:	83 c4 08             	add    $0x8,%esp
  801538:	85 c0                	test   %eax,%eax
  80153a:	74 dc                	je     801518 <strsplit+0x8c>
			string++;
	}
  80153c:	e9 6e ff ff ff       	jmp    8014af <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801541:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801542:	8b 45 14             	mov    0x14(%ebp),%eax
  801545:	8b 00                	mov    (%eax),%eax
  801547:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80154e:	8b 45 10             	mov    0x10(%ebp),%eax
  801551:	01 d0                	add    %edx,%eax
  801553:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801559:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801566:	83 ec 04             	sub    $0x4,%esp
  801569:	68 9c 26 80 00       	push   $0x80269c
  80156e:	68 3f 01 00 00       	push   $0x13f
  801573:	68 be 26 80 00       	push   $0x8026be
  801578:	e8 a1 ed ff ff       	call   80031e <_panic>

0080157d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	57                   	push   %edi
  801581:	56                   	push   %esi
  801582:	53                   	push   %ebx
  801583:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80158f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801592:	8b 7d 18             	mov    0x18(%ebp),%edi
  801595:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801598:	cd 30                	int    $0x30
  80159a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80159d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015a0:	83 c4 10             	add    $0x10,%esp
  8015a3:	5b                   	pop    %ebx
  8015a4:	5e                   	pop    %esi
  8015a5:	5f                   	pop    %edi
  8015a6:	5d                   	pop    %ebp
  8015a7:	c3                   	ret    

008015a8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 04             	sub    $0x4,%esp
  8015ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015b4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	52                   	push   %edx
  8015c0:	ff 75 0c             	pushl  0xc(%ebp)
  8015c3:	50                   	push   %eax
  8015c4:	6a 00                	push   $0x0
  8015c6:	e8 b2 ff ff ff       	call   80157d <syscall>
  8015cb:	83 c4 18             	add    $0x18,%esp
}
  8015ce:	90                   	nop
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 02                	push   $0x2
  8015e0:	e8 98 ff ff ff       	call   80157d <syscall>
  8015e5:	83 c4 18             	add    $0x18,%esp
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 03                	push   $0x3
  8015f9:	e8 7f ff ff ff       	call   80157d <syscall>
  8015fe:	83 c4 18             	add    $0x18,%esp
}
  801601:	90                   	nop
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 04                	push   $0x4
  801613:	e8 65 ff ff ff       	call   80157d <syscall>
  801618:	83 c4 18             	add    $0x18,%esp
}
  80161b:	90                   	nop
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801621:	8b 55 0c             	mov    0xc(%ebp),%edx
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	52                   	push   %edx
  80162e:	50                   	push   %eax
  80162f:	6a 08                	push   $0x8
  801631:	e8 47 ff ff ff       	call   80157d <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	56                   	push   %esi
  80163f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801640:	8b 75 18             	mov    0x18(%ebp),%esi
  801643:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801646:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801649:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	56                   	push   %esi
  801650:	53                   	push   %ebx
  801651:	51                   	push   %ecx
  801652:	52                   	push   %edx
  801653:	50                   	push   %eax
  801654:	6a 09                	push   $0x9
  801656:	e8 22 ff ff ff       	call   80157d <syscall>
  80165b:	83 c4 18             	add    $0x18,%esp
}
  80165e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801661:	5b                   	pop    %ebx
  801662:	5e                   	pop    %esi
  801663:	5d                   	pop    %ebp
  801664:	c3                   	ret    

00801665 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801668:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	52                   	push   %edx
  801675:	50                   	push   %eax
  801676:	6a 0a                	push   $0xa
  801678:	e8 00 ff ff ff       	call   80157d <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	ff 75 0c             	pushl  0xc(%ebp)
  80168e:	ff 75 08             	pushl  0x8(%ebp)
  801691:	6a 0b                	push   $0xb
  801693:	e8 e5 fe ff ff       	call   80157d <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 0c                	push   $0xc
  8016ac:	e8 cc fe ff ff       	call   80157d <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 0d                	push   $0xd
  8016c5:	e8 b3 fe ff ff       	call   80157d <syscall>
  8016ca:	83 c4 18             	add    $0x18,%esp
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 0e                	push   $0xe
  8016de:	e8 9a fe ff ff       	call   80157d <syscall>
  8016e3:	83 c4 18             	add    $0x18,%esp
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 0f                	push   $0xf
  8016f7:	e8 81 fe ff ff       	call   80157d <syscall>
  8016fc:	83 c4 18             	add    $0x18,%esp
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	ff 75 08             	pushl  0x8(%ebp)
  80170f:	6a 10                	push   $0x10
  801711:	e8 67 fe ff ff       	call   80157d <syscall>
  801716:	83 c4 18             	add    $0x18,%esp
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 11                	push   $0x11
  80172a:	e8 4e fe ff ff       	call   80157d <syscall>
  80172f:	83 c4 18             	add    $0x18,%esp
}
  801732:	90                   	nop
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <sys_cputc>:

void
sys_cputc(const char c)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	83 ec 04             	sub    $0x4,%esp
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801741:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	50                   	push   %eax
  80174e:	6a 01                	push   $0x1
  801750:	e8 28 fe ff ff       	call   80157d <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
}
  801758:	90                   	nop
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 14                	push   $0x14
  80176a:	e8 0e fe ff ff       	call   80157d <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
}
  801772:	90                   	nop
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 04             	sub    $0x4,%esp
  80177b:	8b 45 10             	mov    0x10(%ebp),%eax
  80177e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801781:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801784:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	6a 00                	push   $0x0
  80178d:	51                   	push   %ecx
  80178e:	52                   	push   %edx
  80178f:	ff 75 0c             	pushl  0xc(%ebp)
  801792:	50                   	push   %eax
  801793:	6a 15                	push   $0x15
  801795:	e8 e3 fd ff ff       	call   80157d <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	52                   	push   %edx
  8017af:	50                   	push   %eax
  8017b0:	6a 16                	push   $0x16
  8017b2:	e8 c6 fd ff ff       	call   80157d <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	51                   	push   %ecx
  8017cd:	52                   	push   %edx
  8017ce:	50                   	push   %eax
  8017cf:	6a 17                	push   $0x17
  8017d1:	e8 a7 fd ff ff       	call   80157d <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	52                   	push   %edx
  8017eb:	50                   	push   %eax
  8017ec:	6a 18                	push   $0x18
  8017ee:	e8 8a fd ff ff       	call   80157d <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	6a 00                	push   $0x0
  801800:	ff 75 14             	pushl  0x14(%ebp)
  801803:	ff 75 10             	pushl  0x10(%ebp)
  801806:	ff 75 0c             	pushl  0xc(%ebp)
  801809:	50                   	push   %eax
  80180a:	6a 19                	push   $0x19
  80180c:	e8 6c fd ff ff       	call   80157d <syscall>
  801811:	83 c4 18             	add    $0x18,%esp
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	50                   	push   %eax
  801825:	6a 1a                	push   $0x1a
  801827:	e8 51 fd ff ff       	call   80157d <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
}
  80182f:	90                   	nop
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	50                   	push   %eax
  801841:	6a 1b                	push   $0x1b
  801843:	e8 35 fd ff ff       	call   80157d <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 05                	push   $0x5
  80185c:	e8 1c fd ff ff       	call   80157d <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 06                	push   $0x6
  801875:	e8 03 fd ff ff       	call   80157d <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 07                	push   $0x7
  80188e:	e8 ea fc ff ff       	call   80157d <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <sys_exit_env>:


void sys_exit_env(void)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 1c                	push   $0x1c
  8018a7:	e8 d1 fc ff ff       	call   80157d <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	90                   	nop
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018b8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018bb:	8d 50 04             	lea    0x4(%eax),%edx
  8018be:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	52                   	push   %edx
  8018c8:	50                   	push   %eax
  8018c9:	6a 1d                	push   $0x1d
  8018cb:	e8 ad fc ff ff       	call   80157d <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
	return result;
  8018d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018dc:	89 01                	mov    %eax,(%ecx)
  8018de:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	c9                   	leave  
  8018e5:	c2 04 00             	ret    $0x4

008018e8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	ff 75 10             	pushl  0x10(%ebp)
  8018f2:	ff 75 0c             	pushl  0xc(%ebp)
  8018f5:	ff 75 08             	pushl  0x8(%ebp)
  8018f8:	6a 13                	push   $0x13
  8018fa:	e8 7e fc ff ff       	call   80157d <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801902:	90                   	nop
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_rcr2>:
uint32 sys_rcr2()
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 1e                	push   $0x1e
  801914:	e8 64 fc ff ff       	call   80157d <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	83 ec 04             	sub    $0x4,%esp
  801924:	8b 45 08             	mov    0x8(%ebp),%eax
  801927:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80192a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	50                   	push   %eax
  801937:	6a 1f                	push   $0x1f
  801939:	e8 3f fc ff ff       	call   80157d <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
	return ;
  801941:	90                   	nop
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <rsttst>:
void rsttst()
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 21                	push   $0x21
  801953:	e8 25 fc ff ff       	call   80157d <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
	return ;
  80195b:	90                   	nop
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	83 ec 04             	sub    $0x4,%esp
  801964:	8b 45 14             	mov    0x14(%ebp),%eax
  801967:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80196a:	8b 55 18             	mov    0x18(%ebp),%edx
  80196d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801971:	52                   	push   %edx
  801972:	50                   	push   %eax
  801973:	ff 75 10             	pushl  0x10(%ebp)
  801976:	ff 75 0c             	pushl  0xc(%ebp)
  801979:	ff 75 08             	pushl  0x8(%ebp)
  80197c:	6a 20                	push   $0x20
  80197e:	e8 fa fb ff ff       	call   80157d <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
	return ;
  801986:	90                   	nop
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <chktst>:
void chktst(uint32 n)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	ff 75 08             	pushl  0x8(%ebp)
  801997:	6a 22                	push   $0x22
  801999:	e8 df fb ff ff       	call   80157d <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a1:	90                   	nop
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <inctst>:

void inctst()
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 23                	push   $0x23
  8019b3:	e8 c5 fb ff ff       	call   80157d <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bb:	90                   	nop
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <gettst>:
uint32 gettst()
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 24                	push   $0x24
  8019cd:	e8 ab fb ff ff       	call   80157d <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 25                	push   $0x25
  8019e9:	e8 8f fb ff ff       	call   80157d <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
  8019f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019f4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019f8:	75 07                	jne    801a01 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ff:	eb 05                	jmp    801a06 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 25                	push   $0x25
  801a1a:	e8 5e fb ff ff       	call   80157d <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
  801a22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a25:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a29:	75 07                	jne    801a32 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801a30:	eb 05                	jmp    801a37 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 25                	push   $0x25
  801a4b:	e8 2d fb ff ff       	call   80157d <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
  801a53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a56:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a5a:	75 07                	jne    801a63 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a5c:	b8 01 00 00 00       	mov    $0x1,%eax
  801a61:	eb 05                	jmp    801a68 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 25                	push   $0x25
  801a7c:	e8 fc fa ff ff       	call   80157d <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
  801a84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a87:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a8b:	75 07                	jne    801a94 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a92:	eb 05                	jmp    801a99 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	ff 75 08             	pushl  0x8(%ebp)
  801aa9:	6a 26                	push   $0x26
  801aab:	e8 cd fa ff ff       	call   80157d <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab3:	90                   	nop
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801aba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801abd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	6a 00                	push   $0x0
  801ac8:	53                   	push   %ebx
  801ac9:	51                   	push   %ecx
  801aca:	52                   	push   %edx
  801acb:	50                   	push   %eax
  801acc:	6a 27                	push   $0x27
  801ace:	e8 aa fa ff ff       	call   80157d <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ade:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	52                   	push   %edx
  801aeb:	50                   	push   %eax
  801aec:	6a 28                	push   $0x28
  801aee:	e8 8a fa ff ff       	call   80157d <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801afb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	6a 00                	push   $0x0
  801b06:	51                   	push   %ecx
  801b07:	ff 75 10             	pushl  0x10(%ebp)
  801b0a:	52                   	push   %edx
  801b0b:	50                   	push   %eax
  801b0c:	6a 29                	push   $0x29
  801b0e:	e8 6a fa ff ff       	call   80157d <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	ff 75 10             	pushl  0x10(%ebp)
  801b22:	ff 75 0c             	pushl  0xc(%ebp)
  801b25:	ff 75 08             	pushl  0x8(%ebp)
  801b28:	6a 12                	push   $0x12
  801b2a:	e8 4e fa ff ff       	call   80157d <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b32:	90                   	nop
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	52                   	push   %edx
  801b45:	50                   	push   %eax
  801b46:	6a 2a                	push   $0x2a
  801b48:	e8 30 fa ff ff       	call   80157d <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
	return;
  801b50:	90                   	nop
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	50                   	push   %eax
  801b62:	6a 2b                	push   $0x2b
  801b64:	e8 14 fa ff ff       	call   80157d <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	ff 75 0c             	pushl  0xc(%ebp)
  801b7a:	ff 75 08             	pushl  0x8(%ebp)
  801b7d:	6a 2c                	push   $0x2c
  801b7f:	e8 f9 f9 ff ff       	call   80157d <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
	return;
  801b87:	90                   	nop
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	ff 75 0c             	pushl  0xc(%ebp)
  801b96:	ff 75 08             	pushl  0x8(%ebp)
  801b99:	6a 2d                	push   $0x2d
  801b9b:	e8 dd f9 ff ff       	call   80157d <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
	return;
  801ba3:	90                   	nop
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  801bac:	83 ec 04             	sub    $0x4,%esp
  801baf:	68 cc 26 80 00       	push   $0x8026cc
  801bb4:	6a 09                	push   $0x9
  801bb6:	68 f4 26 80 00       	push   $0x8026f4
  801bbb:	e8 5e e7 ff ff       	call   80031e <_panic>

00801bc0 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  801bc6:	83 ec 04             	sub    $0x4,%esp
  801bc9:	68 04 27 80 00       	push   $0x802704
  801bce:	6a 10                	push   $0x10
  801bd0:	68 f4 26 80 00       	push   $0x8026f4
  801bd5:	e8 44 e7 ff ff       	call   80031e <_panic>

00801bda <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  801be0:	83 ec 04             	sub    $0x4,%esp
  801be3:	68 2c 27 80 00       	push   $0x80272c
  801be8:	6a 18                	push   $0x18
  801bea:	68 f4 26 80 00       	push   $0x8026f4
  801bef:	e8 2a e7 ff ff       	call   80031e <_panic>

00801bf4 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  801bfa:	83 ec 04             	sub    $0x4,%esp
  801bfd:	68 54 27 80 00       	push   $0x802754
  801c02:	6a 20                	push   $0x20
  801c04:	68 f4 26 80 00       	push   $0x8026f4
  801c09:	e8 10 e7 ff ff       	call   80031e <_panic>

00801c0e <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	8b 40 10             	mov    0x10(%eax),%eax
}
  801c17:	5d                   	pop    %ebp
  801c18:	c3                   	ret    

00801c19 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801c1f:	8b 55 08             	mov    0x8(%ebp),%edx
  801c22:	89 d0                	mov    %edx,%eax
  801c24:	c1 e0 02             	shl    $0x2,%eax
  801c27:	01 d0                	add    %edx,%eax
  801c29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c30:	01 d0                	add    %edx,%eax
  801c32:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c39:	01 d0                	add    %edx,%eax
  801c3b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c42:	01 d0                	add    %edx,%eax
  801c44:	c1 e0 04             	shl    $0x4,%eax
  801c47:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801c4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801c51:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801c54:	83 ec 0c             	sub    $0xc,%esp
  801c57:	50                   	push   %eax
  801c58:	e8 55 fc ff ff       	call   8018b2 <sys_get_virtual_time>
  801c5d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801c60:	eb 41                	jmp    801ca3 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801c62:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801c65:	83 ec 0c             	sub    $0xc,%esp
  801c68:	50                   	push   %eax
  801c69:	e8 44 fc ff ff       	call   8018b2 <sys_get_virtual_time>
  801c6e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801c71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c77:	29 c2                	sub    %eax,%edx
  801c79:	89 d0                	mov    %edx,%eax
  801c7b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801c7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c84:	89 d1                	mov    %edx,%ecx
  801c86:	29 c1                	sub    %eax,%ecx
  801c88:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c8e:	39 c2                	cmp    %eax,%edx
  801c90:	0f 97 c0             	seta   %al
  801c93:	0f b6 c0             	movzbl %al,%eax
  801c96:	29 c1                	sub    %eax,%ecx
  801c98:	89 c8                	mov    %ecx,%eax
  801c9a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801c9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ca0:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ca9:	72 b7                	jb     801c62 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801cab:	90                   	nop
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801cb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801cbb:	eb 03                	jmp    801cc0 <busy_wait+0x12>
  801cbd:	ff 45 fc             	incl   -0x4(%ebp)
  801cc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cc3:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cc6:	72 f5                	jb     801cbd <busy_wait+0xf>
	return i;
  801cc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801cd9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801cdd:	83 ec 0c             	sub    $0xc,%esp
  801ce0:	50                   	push   %eax
  801ce1:	e8 4f fa ff ff       	call   801735 <sys_cputc>
  801ce6:	83 c4 10             	add    $0x10,%esp
}
  801ce9:	90                   	nop
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <getchar>:


int
getchar(void)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801cf2:	e8 da f8 ff ff       	call   8015d1 <sys_cgetc>
  801cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <iscons>:

int iscons(int fdnum)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801d02:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d07:	5d                   	pop    %ebp
  801d08:	c3                   	ret    
  801d09:	66 90                	xchg   %ax,%ax
  801d0b:	90                   	nop

00801d0c <__udivdi3>:
  801d0c:	55                   	push   %ebp
  801d0d:	57                   	push   %edi
  801d0e:	56                   	push   %esi
  801d0f:	53                   	push   %ebx
  801d10:	83 ec 1c             	sub    $0x1c,%esp
  801d13:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d17:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d23:	89 ca                	mov    %ecx,%edx
  801d25:	89 f8                	mov    %edi,%eax
  801d27:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d2b:	85 f6                	test   %esi,%esi
  801d2d:	75 2d                	jne    801d5c <__udivdi3+0x50>
  801d2f:	39 cf                	cmp    %ecx,%edi
  801d31:	77 65                	ja     801d98 <__udivdi3+0x8c>
  801d33:	89 fd                	mov    %edi,%ebp
  801d35:	85 ff                	test   %edi,%edi
  801d37:	75 0b                	jne    801d44 <__udivdi3+0x38>
  801d39:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3e:	31 d2                	xor    %edx,%edx
  801d40:	f7 f7                	div    %edi
  801d42:	89 c5                	mov    %eax,%ebp
  801d44:	31 d2                	xor    %edx,%edx
  801d46:	89 c8                	mov    %ecx,%eax
  801d48:	f7 f5                	div    %ebp
  801d4a:	89 c1                	mov    %eax,%ecx
  801d4c:	89 d8                	mov    %ebx,%eax
  801d4e:	f7 f5                	div    %ebp
  801d50:	89 cf                	mov    %ecx,%edi
  801d52:	89 fa                	mov    %edi,%edx
  801d54:	83 c4 1c             	add    $0x1c,%esp
  801d57:	5b                   	pop    %ebx
  801d58:	5e                   	pop    %esi
  801d59:	5f                   	pop    %edi
  801d5a:	5d                   	pop    %ebp
  801d5b:	c3                   	ret    
  801d5c:	39 ce                	cmp    %ecx,%esi
  801d5e:	77 28                	ja     801d88 <__udivdi3+0x7c>
  801d60:	0f bd fe             	bsr    %esi,%edi
  801d63:	83 f7 1f             	xor    $0x1f,%edi
  801d66:	75 40                	jne    801da8 <__udivdi3+0x9c>
  801d68:	39 ce                	cmp    %ecx,%esi
  801d6a:	72 0a                	jb     801d76 <__udivdi3+0x6a>
  801d6c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d70:	0f 87 9e 00 00 00    	ja     801e14 <__udivdi3+0x108>
  801d76:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7b:	89 fa                	mov    %edi,%edx
  801d7d:	83 c4 1c             	add    $0x1c,%esp
  801d80:	5b                   	pop    %ebx
  801d81:	5e                   	pop    %esi
  801d82:	5f                   	pop    %edi
  801d83:	5d                   	pop    %ebp
  801d84:	c3                   	ret    
  801d85:	8d 76 00             	lea    0x0(%esi),%esi
  801d88:	31 ff                	xor    %edi,%edi
  801d8a:	31 c0                	xor    %eax,%eax
  801d8c:	89 fa                	mov    %edi,%edx
  801d8e:	83 c4 1c             	add    $0x1c,%esp
  801d91:	5b                   	pop    %ebx
  801d92:	5e                   	pop    %esi
  801d93:	5f                   	pop    %edi
  801d94:	5d                   	pop    %ebp
  801d95:	c3                   	ret    
  801d96:	66 90                	xchg   %ax,%ax
  801d98:	89 d8                	mov    %ebx,%eax
  801d9a:	f7 f7                	div    %edi
  801d9c:	31 ff                	xor    %edi,%edi
  801d9e:	89 fa                	mov    %edi,%edx
  801da0:	83 c4 1c             	add    $0x1c,%esp
  801da3:	5b                   	pop    %ebx
  801da4:	5e                   	pop    %esi
  801da5:	5f                   	pop    %edi
  801da6:	5d                   	pop    %ebp
  801da7:	c3                   	ret    
  801da8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801dad:	89 eb                	mov    %ebp,%ebx
  801daf:	29 fb                	sub    %edi,%ebx
  801db1:	89 f9                	mov    %edi,%ecx
  801db3:	d3 e6                	shl    %cl,%esi
  801db5:	89 c5                	mov    %eax,%ebp
  801db7:	88 d9                	mov    %bl,%cl
  801db9:	d3 ed                	shr    %cl,%ebp
  801dbb:	89 e9                	mov    %ebp,%ecx
  801dbd:	09 f1                	or     %esi,%ecx
  801dbf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801dc3:	89 f9                	mov    %edi,%ecx
  801dc5:	d3 e0                	shl    %cl,%eax
  801dc7:	89 c5                	mov    %eax,%ebp
  801dc9:	89 d6                	mov    %edx,%esi
  801dcb:	88 d9                	mov    %bl,%cl
  801dcd:	d3 ee                	shr    %cl,%esi
  801dcf:	89 f9                	mov    %edi,%ecx
  801dd1:	d3 e2                	shl    %cl,%edx
  801dd3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dd7:	88 d9                	mov    %bl,%cl
  801dd9:	d3 e8                	shr    %cl,%eax
  801ddb:	09 c2                	or     %eax,%edx
  801ddd:	89 d0                	mov    %edx,%eax
  801ddf:	89 f2                	mov    %esi,%edx
  801de1:	f7 74 24 0c          	divl   0xc(%esp)
  801de5:	89 d6                	mov    %edx,%esi
  801de7:	89 c3                	mov    %eax,%ebx
  801de9:	f7 e5                	mul    %ebp
  801deb:	39 d6                	cmp    %edx,%esi
  801ded:	72 19                	jb     801e08 <__udivdi3+0xfc>
  801def:	74 0b                	je     801dfc <__udivdi3+0xf0>
  801df1:	89 d8                	mov    %ebx,%eax
  801df3:	31 ff                	xor    %edi,%edi
  801df5:	e9 58 ff ff ff       	jmp    801d52 <__udivdi3+0x46>
  801dfa:	66 90                	xchg   %ax,%ax
  801dfc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e00:	89 f9                	mov    %edi,%ecx
  801e02:	d3 e2                	shl    %cl,%edx
  801e04:	39 c2                	cmp    %eax,%edx
  801e06:	73 e9                	jae    801df1 <__udivdi3+0xe5>
  801e08:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e0b:	31 ff                	xor    %edi,%edi
  801e0d:	e9 40 ff ff ff       	jmp    801d52 <__udivdi3+0x46>
  801e12:	66 90                	xchg   %ax,%ax
  801e14:	31 c0                	xor    %eax,%eax
  801e16:	e9 37 ff ff ff       	jmp    801d52 <__udivdi3+0x46>
  801e1b:	90                   	nop

00801e1c <__umoddi3>:
  801e1c:	55                   	push   %ebp
  801e1d:	57                   	push   %edi
  801e1e:	56                   	push   %esi
  801e1f:	53                   	push   %ebx
  801e20:	83 ec 1c             	sub    $0x1c,%esp
  801e23:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e27:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e2f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e3b:	89 f3                	mov    %esi,%ebx
  801e3d:	89 fa                	mov    %edi,%edx
  801e3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e43:	89 34 24             	mov    %esi,(%esp)
  801e46:	85 c0                	test   %eax,%eax
  801e48:	75 1a                	jne    801e64 <__umoddi3+0x48>
  801e4a:	39 f7                	cmp    %esi,%edi
  801e4c:	0f 86 a2 00 00 00    	jbe    801ef4 <__umoddi3+0xd8>
  801e52:	89 c8                	mov    %ecx,%eax
  801e54:	89 f2                	mov    %esi,%edx
  801e56:	f7 f7                	div    %edi
  801e58:	89 d0                	mov    %edx,%eax
  801e5a:	31 d2                	xor    %edx,%edx
  801e5c:	83 c4 1c             	add    $0x1c,%esp
  801e5f:	5b                   	pop    %ebx
  801e60:	5e                   	pop    %esi
  801e61:	5f                   	pop    %edi
  801e62:	5d                   	pop    %ebp
  801e63:	c3                   	ret    
  801e64:	39 f0                	cmp    %esi,%eax
  801e66:	0f 87 ac 00 00 00    	ja     801f18 <__umoddi3+0xfc>
  801e6c:	0f bd e8             	bsr    %eax,%ebp
  801e6f:	83 f5 1f             	xor    $0x1f,%ebp
  801e72:	0f 84 ac 00 00 00    	je     801f24 <__umoddi3+0x108>
  801e78:	bf 20 00 00 00       	mov    $0x20,%edi
  801e7d:	29 ef                	sub    %ebp,%edi
  801e7f:	89 fe                	mov    %edi,%esi
  801e81:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e85:	89 e9                	mov    %ebp,%ecx
  801e87:	d3 e0                	shl    %cl,%eax
  801e89:	89 d7                	mov    %edx,%edi
  801e8b:	89 f1                	mov    %esi,%ecx
  801e8d:	d3 ef                	shr    %cl,%edi
  801e8f:	09 c7                	or     %eax,%edi
  801e91:	89 e9                	mov    %ebp,%ecx
  801e93:	d3 e2                	shl    %cl,%edx
  801e95:	89 14 24             	mov    %edx,(%esp)
  801e98:	89 d8                	mov    %ebx,%eax
  801e9a:	d3 e0                	shl    %cl,%eax
  801e9c:	89 c2                	mov    %eax,%edx
  801e9e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ea2:	d3 e0                	shl    %cl,%eax
  801ea4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801eac:	89 f1                	mov    %esi,%ecx
  801eae:	d3 e8                	shr    %cl,%eax
  801eb0:	09 d0                	or     %edx,%eax
  801eb2:	d3 eb                	shr    %cl,%ebx
  801eb4:	89 da                	mov    %ebx,%edx
  801eb6:	f7 f7                	div    %edi
  801eb8:	89 d3                	mov    %edx,%ebx
  801eba:	f7 24 24             	mull   (%esp)
  801ebd:	89 c6                	mov    %eax,%esi
  801ebf:	89 d1                	mov    %edx,%ecx
  801ec1:	39 d3                	cmp    %edx,%ebx
  801ec3:	0f 82 87 00 00 00    	jb     801f50 <__umoddi3+0x134>
  801ec9:	0f 84 91 00 00 00    	je     801f60 <__umoddi3+0x144>
  801ecf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ed3:	29 f2                	sub    %esi,%edx
  801ed5:	19 cb                	sbb    %ecx,%ebx
  801ed7:	89 d8                	mov    %ebx,%eax
  801ed9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801edd:	d3 e0                	shl    %cl,%eax
  801edf:	89 e9                	mov    %ebp,%ecx
  801ee1:	d3 ea                	shr    %cl,%edx
  801ee3:	09 d0                	or     %edx,%eax
  801ee5:	89 e9                	mov    %ebp,%ecx
  801ee7:	d3 eb                	shr    %cl,%ebx
  801ee9:	89 da                	mov    %ebx,%edx
  801eeb:	83 c4 1c             	add    $0x1c,%esp
  801eee:	5b                   	pop    %ebx
  801eef:	5e                   	pop    %esi
  801ef0:	5f                   	pop    %edi
  801ef1:	5d                   	pop    %ebp
  801ef2:	c3                   	ret    
  801ef3:	90                   	nop
  801ef4:	89 fd                	mov    %edi,%ebp
  801ef6:	85 ff                	test   %edi,%edi
  801ef8:	75 0b                	jne    801f05 <__umoddi3+0xe9>
  801efa:	b8 01 00 00 00       	mov    $0x1,%eax
  801eff:	31 d2                	xor    %edx,%edx
  801f01:	f7 f7                	div    %edi
  801f03:	89 c5                	mov    %eax,%ebp
  801f05:	89 f0                	mov    %esi,%eax
  801f07:	31 d2                	xor    %edx,%edx
  801f09:	f7 f5                	div    %ebp
  801f0b:	89 c8                	mov    %ecx,%eax
  801f0d:	f7 f5                	div    %ebp
  801f0f:	89 d0                	mov    %edx,%eax
  801f11:	e9 44 ff ff ff       	jmp    801e5a <__umoddi3+0x3e>
  801f16:	66 90                	xchg   %ax,%ax
  801f18:	89 c8                	mov    %ecx,%eax
  801f1a:	89 f2                	mov    %esi,%edx
  801f1c:	83 c4 1c             	add    $0x1c,%esp
  801f1f:	5b                   	pop    %ebx
  801f20:	5e                   	pop    %esi
  801f21:	5f                   	pop    %edi
  801f22:	5d                   	pop    %ebp
  801f23:	c3                   	ret    
  801f24:	3b 04 24             	cmp    (%esp),%eax
  801f27:	72 06                	jb     801f2f <__umoddi3+0x113>
  801f29:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f2d:	77 0f                	ja     801f3e <__umoddi3+0x122>
  801f2f:	89 f2                	mov    %esi,%edx
  801f31:	29 f9                	sub    %edi,%ecx
  801f33:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f37:	89 14 24             	mov    %edx,(%esp)
  801f3a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f3e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f42:	8b 14 24             	mov    (%esp),%edx
  801f45:	83 c4 1c             	add    $0x1c,%esp
  801f48:	5b                   	pop    %ebx
  801f49:	5e                   	pop    %esi
  801f4a:	5f                   	pop    %edi
  801f4b:	5d                   	pop    %ebp
  801f4c:	c3                   	ret    
  801f4d:	8d 76 00             	lea    0x0(%esi),%esi
  801f50:	2b 04 24             	sub    (%esp),%eax
  801f53:	19 fa                	sbb    %edi,%edx
  801f55:	89 d1                	mov    %edx,%ecx
  801f57:	89 c6                	mov    %eax,%esi
  801f59:	e9 71 ff ff ff       	jmp    801ecf <__umoddi3+0xb3>
  801f5e:	66 90                	xchg   %ax,%ax
  801f60:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f64:	72 ea                	jb     801f50 <__umoddi3+0x134>
  801f66:	89 d9                	mov    %ebx,%ecx
  801f68:	e9 62 ff ff ff       	jmp    801ecf <__umoddi3+0xb3>
