
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
  800053:	68 00 41 80 00       	push   $0x804100
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
  800083:	68 22 41 80 00       	push   $0x804122
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
  8000b6:	68 38 41 80 00       	push   $0x804138
  8000bb:	50                   	push   %eax
  8000bc:	e8 81 1b 00 00       	call   801c42 <create_semaphore>
  8000c1:	83 c4 0c             	add    $0xc,%esp
	struct semaphore dependSem = create_semaphore("depend", 0);
  8000c4:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	6a 00                	push   $0x0
  8000cf:	68 45 41 80 00       	push   $0x804145
  8000d4:	50                   	push   %eax
  8000d5:	e8 68 1b 00 00       	call   801c42 <create_semaphore>
  8000da:	83 c4 0c             	add    $0xc,%esp

	int i = 0 ;
  8000dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int id ;
	for (; i<totalNumOfCusts; i++)
  8000e4:	eb 61                	jmp    800147 <_main+0x10f>
	{
		id = sys_create_env("sem2Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8000eb:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8000f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8000f6:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000fc:	89 c1                	mov    %eax,%ecx
  8000fe:	a1 20 50 80 00       	mov    0x805020,%eax
  800103:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800109:	52                   	push   %edx
  80010a:	51                   	push   %ecx
  80010b:	50                   	push   %eax
  80010c:	68 4c 41 80 00       	push   $0x80414c
  800111:	e8 e2 16 00 00       	call   8017f8 <sys_create_env>
  800116:	83 c4 10             	add    $0x10,%esp
  800119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (id == E_ENV_CREATION_ERROR)
  80011c:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800120:	75 14                	jne    800136 <_main+0xfe>
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
  800122:	83 ec 04             	sub    $0x4,%esp
  800125:	68 58 41 80 00       	push   $0x804158
  80012a:	6a 18                	push   $0x18
  80012c:	68 a4 41 80 00       	push   $0x8041a4
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
  800161:	e8 9b 1b 00 00       	call   801d01 <wait_semaphore>
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
  80017d:	e8 73 1c 00 00       	call   801df5 <semaphore_count>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int sem2val = semaphore_count(dependSem);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff b5 d4 fe ff ff    	pushl  -0x12c(%ebp)
  800191:	e8 5f 1c 00 00       	call   801df5 <semaphore_count>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//wait a while to allow the slaves to finish printing their closing messages
	env_sleep(10000);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	68 10 27 00 00       	push   $0x2710
  8001a4:	e8 57 1c 00 00       	call   801e00 <env_sleep>
  8001a9:	83 c4 10             	add    $0x10,%esp
	if (sem2val == 0 && sem1val == shopCapacity)
  8001ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001b0:	75 1a                	jne    8001cc <_main+0x194>
  8001b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8001b8:	75 12                	jne    8001cc <_main+0x194>
		cprintf("\nCongratulations!! Test of Semaphores [2] completed successfully!!\n\n\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 c4 41 80 00       	push   $0x8041c4
  8001c2:	e8 14 04 00 00       	call   8005db <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp
  8001ca:	eb 10                	jmp    8001dc <_main+0x1a4>
	else
		cprintf("\nError: wrong semaphore value... please review your semaphore code again...\n");
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	68 0c 42 80 00       	push   $0x80420c
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
  800214:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800219:	a1 20 50 80 00       	mov    0x805020,%eax
  80021e:	8a 40 20             	mov    0x20(%eax),%al
  800221:	84 c0                	test   %al,%al
  800223:	74 0d                	je     800232 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800225:	a1 20 50 80 00       	mov    0x805020,%eax
  80022a:	83 c0 20             	add    $0x20,%eax
  80022d:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800232:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800236:	7e 0a                	jle    800242 <libmain+0x63>
		binaryname = argv[0];
  800238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023b:	8b 00                	mov    (%eax),%eax
  80023d:	a3 00 50 80 00       	mov    %eax,0x805000

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
  80025b:	68 74 42 80 00       	push   $0x804274
  800260:	e8 76 03 00 00       	call   8005db <cprintf>
  800265:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800268:	a1 20 50 80 00       	mov    0x805020,%eax
  80026d:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800273:	a1 20 50 80 00       	mov    0x805020,%eax
  800278:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80027e:	83 ec 04             	sub    $0x4,%esp
  800281:	52                   	push   %edx
  800282:	50                   	push   %eax
  800283:	68 9c 42 80 00       	push   $0x80429c
  800288:	e8 4e 03 00 00       	call   8005db <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800290:	a1 20 50 80 00       	mov    0x805020,%eax
  800295:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80029b:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a0:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8002a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ab:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8002b1:	51                   	push   %ecx
  8002b2:	52                   	push   %edx
  8002b3:	50                   	push   %eax
  8002b4:	68 c4 42 80 00       	push   $0x8042c4
  8002b9:	e8 1d 03 00 00       	call   8005db <cprintf>
  8002be:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8002c6:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	50                   	push   %eax
  8002d0:	68 1c 43 80 00       	push   $0x80431c
  8002d5:	e8 01 03 00 00       	call   8005db <cprintf>
  8002da:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002dd:	83 ec 0c             	sub    $0xc,%esp
  8002e0:	68 74 42 80 00       	push   $0x804274
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
  80032d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800332:	85 c0                	test   %eax,%eax
  800334:	74 16                	je     80034c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800336:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	50                   	push   %eax
  80033f:	68 30 43 80 00       	push   $0x804330
  800344:	e8 92 02 00 00       	call   8005db <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80034c:	a1 00 50 80 00       	mov    0x805000,%eax
  800351:	ff 75 0c             	pushl  0xc(%ebp)
  800354:	ff 75 08             	pushl  0x8(%ebp)
  800357:	50                   	push   %eax
  800358:	68 35 43 80 00       	push   $0x804335
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
  80037c:	68 51 43 80 00       	push   $0x804351
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
  800396:	a1 20 50 80 00       	mov    0x805020,%eax
  80039b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a4:	39 c2                	cmp    %eax,%edx
  8003a6:	74 14                	je     8003bc <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	68 54 43 80 00       	push   $0x804354
  8003b0:	6a 26                	push   $0x26
  8003b2:	68 a0 43 80 00       	push   $0x8043a0
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
  8003fc:	a1 20 50 80 00       	mov    0x805020,%eax
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
  80041c:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800465:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800480:	68 ac 43 80 00       	push   $0x8043ac
  800485:	6a 3a                	push   $0x3a
  800487:	68 a0 43 80 00       	push   $0x8043a0
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
  8004b0:	a1 20 50 80 00       	mov    0x805020,%eax
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
  8004d6:	a1 20 50 80 00       	mov    0x805020,%eax
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
  8004f3:	68 00 44 80 00       	push   $0x804400
  8004f8:	6a 44                	push   $0x44
  8004fa:	68 a0 43 80 00       	push   $0x8043a0
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
  800532:	a0 28 50 80 00       	mov    0x805028,%al
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
  8005a7:	a0 28 50 80 00       	mov    0x805028,%al
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
  8005cc:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
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
  8005e1:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  800678:	e8 0f 38 00 00       	call   803e8c <__udivdi3>
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
  8006c8:	e8 cf 38 00 00       	call   803f9c <__umoddi3>
  8006cd:	83 c4 10             	add    $0x10,%esp
  8006d0:	05 74 46 80 00       	add    $0x804674,%eax
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
  800823:	8b 04 85 98 46 80 00 	mov    0x804698(,%eax,4),%eax
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
  800904:	8b 34 9d e0 44 80 00 	mov    0x8044e0(,%ebx,4),%esi
  80090b:	85 f6                	test   %esi,%esi
  80090d:	75 19                	jne    800928 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80090f:	53                   	push   %ebx
  800910:	68 85 46 80 00       	push   $0x804685
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
  800929:	68 8e 46 80 00       	push   $0x80468e
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
  800956:	be 91 46 80 00       	mov    $0x804691,%esi
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
  800b4e:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800b55:	eb 2c                	jmp    800b83 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b57:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
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
  800c81:	68 08 48 80 00       	push   $0x804808
  800c86:	e8 50 f9 ff ff       	call   8005db <cprintf>
  800c8b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800c8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800c95:	83 ec 0c             	sub    $0xc,%esp
  800c98:	6a 00                	push   $0x0
  800c9a:	e8 47 12 00 00       	call   801ee6 <iscons>
  800c9f:	83 c4 10             	add    $0x10,%esp
  800ca2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800ca5:	e8 29 12 00 00       	call   801ed3 <getchar>
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
  800cc3:	68 0b 48 80 00       	push   $0x80480b
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
  800cf0:	e8 bf 11 00 00       	call   801eb4 <cputchar>
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
  800d27:	e8 88 11 00 00       	call   801eb4 <cputchar>
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
  800d50:	e8 5f 11 00 00       	call   801eb4 <cputchar>
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
  800d85:	68 08 48 80 00       	push   $0x804808
  800d8a:	e8 4c f8 ff ff       	call   8005db <cprintf>
  800d8f:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800d92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800d99:	83 ec 0c             	sub    $0xc,%esp
  800d9c:	6a 00                	push   $0x0
  800d9e:	e8 43 11 00 00       	call   801ee6 <iscons>
  800da3:	83 c4 10             	add    $0x10,%esp
  800da6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800da9:	e8 25 11 00 00       	call   801ed3 <getchar>
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
  800dc7:	68 0b 48 80 00       	push   $0x80480b
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
  800df4:	e8 bb 10 00 00       	call   801eb4 <cputchar>
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
  800e2b:	e8 84 10 00 00       	call   801eb4 <cputchar>
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
  800e54:	e8 5b 10 00 00       	call   801eb4 <cputchar>
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
  801569:	68 1c 48 80 00       	push   $0x80481c
  80156e:	68 3f 01 00 00       	push   $0x13f
  801573:	68 3e 48 80 00       	push   $0x80483e
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

00801ba6 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 2e                	push   $0x2e
  801bb8:	e8 c0 f9 ff ff       	call   80157d <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
  801bc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801bc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	50                   	push   %eax
  801bd7:	6a 2f                	push   $0x2f
  801bd9:	e8 9f f9 ff ff       	call   80157d <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
	return;
  801be1:	90                   	nop
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801be7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bea:	8b 45 08             	mov    0x8(%ebp),%eax
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	52                   	push   %edx
  801bf4:	50                   	push   %eax
  801bf5:	6a 30                	push   $0x30
  801bf7:	e8 81 f9 ff ff       	call   80157d <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
	return;
  801bff:	90                   	nop
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	50                   	push   %eax
  801c14:	6a 31                	push   $0x31
  801c16:	e8 62 f9 ff ff       	call   80157d <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
  801c1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	50                   	push   %eax
  801c35:	6a 32                	push   $0x32
  801c37:	e8 41 f9 ff ff       	call   80157d <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
	return;
  801c3f:	90                   	nop
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("create_semaphore is not implemented yet");
	//Your Code is Here...

		void* ret = smalloc(semaphoreName, sizeof(struct semaphore), 1);
  801c48:	83 ec 04             	sub    $0x4,%esp
  801c4b:	6a 01                	push   $0x1
  801c4d:	6a 04                	push   $0x4
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	e8 cd 05 00 00       	call   802224 <smalloc>
  801c57:	83 c4 10             	add    $0x10,%esp
  801c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if (ret == NULL ) panic("no memory in creat_semaphore");
  801c5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c61:	75 14                	jne    801c77 <create_semaphore+0x35>
  801c63:	83 ec 04             	sub    $0x4,%esp
  801c66:	68 4b 48 80 00       	push   $0x80484b
  801c6b:	6a 0d                	push   $0xd
  801c6d:	68 68 48 80 00       	push   $0x804868
  801c72:	e8 a7 e6 ff ff       	call   80031e <_panic>

	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  801c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	    sem_ptr->semdata->count = value;
  801c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c80:	8b 00                	mov    (%eax),%eax
  801c82:	8b 55 10             	mov    0x10(%ebp),%edx
  801c85:	89 50 10             	mov    %edx,0x10(%eax)
	    sys_init_queue(&(sem_ptr->semdata->queue));
  801c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8b:	8b 00                	mov    (%eax),%eax
  801c8d:	83 ec 0c             	sub    $0xc,%esp
  801c90:	50                   	push   %eax
  801c91:	e8 32 ff ff ff       	call   801bc8 <sys_init_queue>
  801c96:	83 c4 10             	add    $0x10,%esp

	    sem_ptr->semdata->lock = 0;
  801c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c9c:	8b 00                	mov    (%eax),%eax
  801c9e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	    return *sem_ptr;
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cab:	8b 12                	mov    (%edx),%edx
  801cad:	89 10                	mov    %edx,(%eax)
}
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	c9                   	leave  
  801cb3:	c2 04 00             	ret    $0x4

00801cb6 <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("get_semaphore is not implemented yet");
	//Your Code is Here...
		void* ret = sget(ownerEnvID, semaphoreName);
  801cbc:	83 ec 08             	sub    $0x8,%esp
  801cbf:	ff 75 10             	pushl  0x10(%ebp)
  801cc2:	ff 75 0c             	pushl  0xc(%ebp)
  801cc5:	e8 ff 05 00 00       	call   8022c9 <sget>
  801cca:	83 c4 10             	add    $0x10,%esp
  801ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (ret == NULL ) panic("no semaphore in get_semaphore");
  801cd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cd4:	75 14                	jne    801cea <get_semaphore+0x34>
  801cd6:	83 ec 04             	sub    $0x4,%esp
  801cd9:	68 78 48 80 00       	push   $0x804878
  801cde:	6a 1f                	push   $0x1f
  801ce0:	68 68 48 80 00       	push   $0x804868
  801ce5:	e8 34 e6 ff ff       	call   80031e <_panic>
	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  801cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ced:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    return *sem_ptr;
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cf6:	8b 12                	mov    (%edx),%edx
  801cf8:	89 10                	mov    %edx,(%eax)
}
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	c9                   	leave  
  801cfe:	c2 04 00             	ret    $0x4

00801d01 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("wait_semaphore is not implemented yet");
	//Your Code is Here...
			uint32 key = 1;
  801d07:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		    do { xchg(&sem.semdata->lock,key); } while (key != 0);
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	83 c0 14             	add    $0x14,%eax
  801d14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  801d1d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d23:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  801d26:	f0 87 02             	lock xchg %eax,(%edx)
  801d29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d30:	75 dc                	jne    801d0e <wait_semaphore+0xd>

		    sem.semdata->count--;
  801d32:	8b 45 08             	mov    0x8(%ebp),%eax
  801d35:	8b 50 10             	mov    0x10(%eax),%edx
  801d38:	4a                   	dec    %edx
  801d39:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count < 0) {
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	8b 40 10             	mov    0x10(%eax),%eax
  801d42:	85 c0                	test   %eax,%eax
  801d44:	79 30                	jns    801d76 <wait_semaphore+0x75>

	    	struct Env* cur_env = sys_get_cpu_process();
  801d46:	e8 5b fe ff ff       	call   801ba6 <sys_get_cpu_process>
  801d4b:	89 45 f0             	mov    %eax,-0x10(%ebp)

//	    	acquire_spinlock(&ProcessQueues.qlock); //acquire procque
	        sys_enqueue(&(sem.semdata->queue),cur_env);  // Add process to waiting queue
  801d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d51:	83 ec 08             	sub    $0x8,%esp
  801d54:	ff 75 f0             	pushl  -0x10(%ebp)
  801d57:	50                   	push   %eax
  801d58:	e8 87 fe ff ff       	call   801be4 <sys_enqueue>
  801d5d:	83 c4 10             	add    $0x10,%esp
	        cur_env->env_status= ENV_BLOCKED;
  801d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d63:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%eax)
	        sem.semdata->lock = 0;
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;

}
  801d74:	eb 0a                	jmp    801d80 <wait_semaphore+0x7f>
	        cur_env->env_status= ENV_BLOCKED;
	        sem.semdata->lock = 0;
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;
  801d76:	8b 45 08             	mov    0x8(%ebp),%eax
  801d79:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

}
  801d80:	90                   	nop
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("signal_semaphore is not implemented yet");
	//Your Code is Here...
		uint32 key = 1;
  801d89:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	    do { xchg(&sem.semdata->lock,key ); } while (key != 0);
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	83 c0 14             	add    $0x14,%eax
  801d96:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d9f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801da2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801da5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  801da8:	f0 87 02             	lock xchg %eax,(%edx)
  801dab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801db2:	75 dc                	jne    801d90 <signal_semaphore+0xd>
	    sem.semdata->count++;
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	8b 50 10             	mov    0x10(%eax),%edx
  801dba:	42                   	inc    %edx
  801dbb:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count <= 0) {
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	8b 40 10             	mov    0x10(%eax),%eax
  801dc4:	85 c0                	test   %eax,%eax
  801dc6:	7f 20                	jg     801de8 <signal_semaphore+0x65>
	        struct Env* env = sys_dequeue(&(sem.semdata->queue)) ;
  801dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcb:	83 ec 0c             	sub    $0xc,%esp
  801dce:	50                   	push   %eax
  801dcf:	e8 2e fe ff ff       	call   801c02 <sys_dequeue>
  801dd4:	83 c4 10             	add    $0x10,%esp
  801dd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	        sys_sched_insert_ready(env);
  801dda:	83 ec 0c             	sub    $0xc,%esp
  801ddd:	ff 75 f0             	pushl  -0x10(%ebp)
  801de0:	e8 41 fe ff ff       	call   801c26 <sys_sched_insert_ready>
  801de5:	83 c4 10             	add    $0x10,%esp
	    }
	    sem.semdata->lock = 0;
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  801df2:	90                   	nop
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801df8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfb:	8b 40 10             	mov    0x10(%eax),%eax
}
  801dfe:	5d                   	pop    %ebp
  801dff:	c3                   	ret    

00801e00 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801e06:	8b 55 08             	mov    0x8(%ebp),%edx
  801e09:	89 d0                	mov    %edx,%eax
  801e0b:	c1 e0 02             	shl    $0x2,%eax
  801e0e:	01 d0                	add    %edx,%eax
  801e10:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e17:	01 d0                	add    %edx,%eax
  801e19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e20:	01 d0                	add    %edx,%eax
  801e22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e29:	01 d0                	add    %edx,%eax
  801e2b:	c1 e0 04             	shl    $0x4,%eax
  801e2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801e31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801e38:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801e3b:	83 ec 0c             	sub    $0xc,%esp
  801e3e:	50                   	push   %eax
  801e3f:	e8 6e fa ff ff       	call   8018b2 <sys_get_virtual_time>
  801e44:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801e47:	eb 41                	jmp    801e8a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801e49:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801e4c:	83 ec 0c             	sub    $0xc,%esp
  801e4f:	50                   	push   %eax
  801e50:	e8 5d fa ff ff       	call   8018b2 <sys_get_virtual_time>
  801e55:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e58:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e5e:	29 c2                	sub    %eax,%edx
  801e60:	89 d0                	mov    %edx,%eax
  801e62:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e6b:	89 d1                	mov    %edx,%ecx
  801e6d:	29 c1                	sub    %eax,%ecx
  801e6f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e75:	39 c2                	cmp    %eax,%edx
  801e77:	0f 97 c0             	seta   %al
  801e7a:	0f b6 c0             	movzbl %al,%eax
  801e7d:	29 c1                	sub    %eax,%ecx
  801e7f:	89 c8                	mov    %ecx,%eax
  801e81:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e84:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e90:	72 b7                	jb     801e49 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e92:	90                   	nop
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801e9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801ea2:	eb 03                	jmp    801ea7 <busy_wait+0x12>
  801ea4:	ff 45 fc             	incl   -0x4(%ebp)
  801ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eaa:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ead:	72 f5                	jb     801ea4 <busy_wait+0xf>
	return i;
  801eaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801eba:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebd:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801ec0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801ec4:	83 ec 0c             	sub    $0xc,%esp
  801ec7:	50                   	push   %eax
  801ec8:	e8 68 f8 ff ff       	call   801735 <sys_cputc>
  801ecd:	83 c4 10             	add    $0x10,%esp
}
  801ed0:	90                   	nop
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <getchar>:


int
getchar(void)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801ed9:	e8 f3 f6 ff ff       	call   8015d1 <sys_cgetc>
  801ede:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <iscons>:

int iscons(int fdnum)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801ee9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801eee:	5d                   	pop    %ebp
  801eef:	c3                   	ret    

00801ef0 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801ef6:	83 ec 0c             	sub    $0xc,%esp
  801ef9:	ff 75 08             	pushl  0x8(%ebp)
  801efc:	e8 52 fc ff ff       	call   801b53 <sys_sbrk>
  801f01:	83 c4 10             	add    $0x10,%esp
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801f0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f10:	75 0a                	jne    801f1c <malloc+0x16>
  801f12:	b8 00 00 00 00       	mov    $0x0,%eax
  801f17:	e9 07 02 00 00       	jmp    802123 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801f1c:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801f23:	8b 55 08             	mov    0x8(%ebp),%edx
  801f26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f29:	01 d0                	add    %edx,%eax
  801f2b:	48                   	dec    %eax
  801f2c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801f2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f32:	ba 00 00 00 00       	mov    $0x0,%edx
  801f37:	f7 75 dc             	divl   -0x24(%ebp)
  801f3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f3d:	29 d0                	sub    %edx,%eax
  801f3f:	c1 e8 0c             	shr    $0xc,%eax
  801f42:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801f45:	a1 20 50 80 00       	mov    0x805020,%eax
  801f4a:	8b 40 78             	mov    0x78(%eax),%eax
  801f4d:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801f52:	29 c2                	sub    %eax,%edx
  801f54:	89 d0                	mov    %edx,%eax
  801f56:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801f59:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f5c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f61:	c1 e8 0c             	shr    $0xc,%eax
  801f64:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801f67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801f6e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801f75:	77 42                	ja     801fb9 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801f77:	e8 5b fa ff ff       	call   8019d7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f7c:	85 c0                	test   %eax,%eax
  801f7e:	74 16                	je     801f96 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801f80:	83 ec 0c             	sub    $0xc,%esp
  801f83:	ff 75 08             	pushl  0x8(%ebp)
  801f86:	e8 18 08 00 00       	call   8027a3 <alloc_block_FF>
  801f8b:	83 c4 10             	add    $0x10,%esp
  801f8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f91:	e9 8a 01 00 00       	jmp    802120 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801f96:	e8 6d fa ff ff       	call   801a08 <sys_isUHeapPlacementStrategyBESTFIT>
  801f9b:	85 c0                	test   %eax,%eax
  801f9d:	0f 84 7d 01 00 00    	je     802120 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801fa3:	83 ec 0c             	sub    $0xc,%esp
  801fa6:	ff 75 08             	pushl  0x8(%ebp)
  801fa9:	e8 b1 0c 00 00       	call   802c5f <alloc_block_BF>
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb4:	e9 67 01 00 00       	jmp    802120 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801fb9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801fbc:	48                   	dec    %eax
  801fbd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801fc0:	0f 86 53 01 00 00    	jbe    802119 <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801fc6:	a1 20 50 80 00       	mov    0x805020,%eax
  801fcb:	8b 40 78             	mov    0x78(%eax),%eax
  801fce:	05 00 10 00 00       	add    $0x1000,%eax
  801fd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801fd6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801fdd:	e9 de 00 00 00       	jmp    8020c0 <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801fe2:	a1 20 50 80 00       	mov    0x805020,%eax
  801fe7:	8b 40 78             	mov    0x78(%eax),%eax
  801fea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fed:	29 c2                	sub    %eax,%edx
  801fef:	89 d0                	mov    %edx,%eax
  801ff1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ff6:	c1 e8 0c             	shr    $0xc,%eax
  801ff9:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  802000:	85 c0                	test   %eax,%eax
  802002:	0f 85 ab 00 00 00    	jne    8020b3 <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  802008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200b:	05 00 10 00 00       	add    $0x1000,%eax
  802010:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  802013:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  80201a:	eb 47                	jmp    802063 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  80201c:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  802023:	76 0a                	jbe    80202f <malloc+0x129>
  802025:	b8 00 00 00 00       	mov    $0x0,%eax
  80202a:	e9 f4 00 00 00       	jmp    802123 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  80202f:	a1 20 50 80 00       	mov    0x805020,%eax
  802034:	8b 40 78             	mov    0x78(%eax),%eax
  802037:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80203a:	29 c2                	sub    %eax,%edx
  80203c:	89 d0                	mov    %edx,%eax
  80203e:	2d 00 10 00 00       	sub    $0x1000,%eax
  802043:	c1 e8 0c             	shr    $0xc,%eax
  802046:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  80204d:	85 c0                	test   %eax,%eax
  80204f:	74 08                	je     802059 <malloc+0x153>
					{
						
						i = j;
  802051:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802054:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  802057:	eb 5a                	jmp    8020b3 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  802059:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  802060:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  802063:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802066:	48                   	dec    %eax
  802067:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80206a:	77 b0                	ja     80201c <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  80206c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  802073:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80207a:	eb 2f                	jmp    8020ab <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  80207c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80207f:	c1 e0 0c             	shl    $0xc,%eax
  802082:	89 c2                	mov    %eax,%edx
  802084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802087:	01 c2                	add    %eax,%edx
  802089:	a1 20 50 80 00       	mov    0x805020,%eax
  80208e:	8b 40 78             	mov    0x78(%eax),%eax
  802091:	29 c2                	sub    %eax,%edx
  802093:	89 d0                	mov    %edx,%eax
  802095:	2d 00 10 00 00       	sub    $0x1000,%eax
  80209a:	c1 e8 0c             	shr    $0xc,%eax
  80209d:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  8020a4:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8020a8:	ff 45 e0             	incl   -0x20(%ebp)
  8020ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020ae:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8020b1:	72 c9                	jb     80207c <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  8020b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020b7:	75 16                	jne    8020cf <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8020b9:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8020c0:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8020c7:	0f 86 15 ff ff ff    	jbe    801fe2 <malloc+0xdc>
  8020cd:	eb 01                	jmp    8020d0 <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  8020cf:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8020d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020d4:	75 07                	jne    8020dd <malloc+0x1d7>
  8020d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020db:	eb 46                	jmp    802123 <malloc+0x21d>
		ptr = (void*)i;
  8020dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  8020e3:	a1 20 50 80 00       	mov    0x805020,%eax
  8020e8:	8b 40 78             	mov    0x78(%eax),%eax
  8020eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020ee:	29 c2                	sub    %eax,%edx
  8020f0:	89 d0                	mov    %edx,%eax
  8020f2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8020f7:	c1 e8 0c             	shr    $0xc,%eax
  8020fa:	89 c2                	mov    %eax,%edx
  8020fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020ff:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  802106:	83 ec 08             	sub    $0x8,%esp
  802109:	ff 75 08             	pushl  0x8(%ebp)
  80210c:	ff 75 f0             	pushl  -0x10(%ebp)
  80210f:	e8 76 fa ff ff       	call   801b8a <sys_allocate_user_mem>
  802114:	83 c4 10             	add    $0x10,%esp
  802117:	eb 07                	jmp    802120 <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  802119:	b8 00 00 00 00       	mov    $0x0,%eax
  80211e:	eb 03                	jmp    802123 <malloc+0x21d>
	}
	return ptr;
  802120:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  80212b:	a1 20 50 80 00       	mov    0x805020,%eax
  802130:	8b 40 78             	mov    0x78(%eax),%eax
  802133:	05 00 10 00 00       	add    $0x1000,%eax
  802138:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  80213b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  802142:	a1 20 50 80 00       	mov    0x805020,%eax
  802147:	8b 50 78             	mov    0x78(%eax),%edx
  80214a:	8b 45 08             	mov    0x8(%ebp),%eax
  80214d:	39 c2                	cmp    %eax,%edx
  80214f:	76 24                	jbe    802175 <free+0x50>
		size = get_block_size(va);
  802151:	83 ec 0c             	sub    $0xc,%esp
  802154:	ff 75 08             	pushl  0x8(%ebp)
  802157:	e8 c7 02 00 00       	call   802423 <get_block_size>
  80215c:	83 c4 10             	add    $0x10,%esp
  80215f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  802162:	83 ec 0c             	sub    $0xc,%esp
  802165:	ff 75 08             	pushl  0x8(%ebp)
  802168:	e8 d7 14 00 00       	call   803644 <free_block>
  80216d:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  802170:	e9 ac 00 00 00       	jmp    802221 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80217b:	0f 82 89 00 00 00    	jb     80220a <free+0xe5>
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  802189:	77 7f                	ja     80220a <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  80218b:	8b 55 08             	mov    0x8(%ebp),%edx
  80218e:	a1 20 50 80 00       	mov    0x805020,%eax
  802193:	8b 40 78             	mov    0x78(%eax),%eax
  802196:	29 c2                	sub    %eax,%edx
  802198:	89 d0                	mov    %edx,%eax
  80219a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80219f:	c1 e8 0c             	shr    $0xc,%eax
  8021a2:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  8021a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8021ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021af:	c1 e0 0c             	shl    $0xc,%eax
  8021b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8021b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8021bc:	eb 42                	jmp    802200 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8021be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c1:	c1 e0 0c             	shl    $0xc,%eax
  8021c4:	89 c2                	mov    %eax,%edx
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	01 c2                	add    %eax,%edx
  8021cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8021d0:	8b 40 78             	mov    0x78(%eax),%eax
  8021d3:	29 c2                	sub    %eax,%edx
  8021d5:	89 d0                	mov    %edx,%eax
  8021d7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8021dc:	c1 e8 0c             	shr    $0xc,%eax
  8021df:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  8021e6:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8021ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	83 ec 08             	sub    $0x8,%esp
  8021f3:	52                   	push   %edx
  8021f4:	50                   	push   %eax
  8021f5:	e8 74 f9 ff ff       	call   801b6e <sys_free_user_mem>
  8021fa:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8021fd:	ff 45 f4             	incl   -0xc(%ebp)
  802200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802203:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802206:	72 b6                	jb     8021be <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  802208:	eb 17                	jmp    802221 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  80220a:	83 ec 04             	sub    $0x4,%esp
  80220d:	68 98 48 80 00       	push   $0x804898
  802212:	68 87 00 00 00       	push   $0x87
  802217:	68 c2 48 80 00       	push   $0x8048c2
  80221c:	e8 fd e0 ff ff       	call   80031e <_panic>
	}
}
  802221:	90                   	nop
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
  802227:	83 ec 28             	sub    $0x28,%esp
  80222a:	8b 45 10             	mov    0x10(%ebp),%eax
  80222d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802230:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802234:	75 0a                	jne    802240 <smalloc+0x1c>
  802236:	b8 00 00 00 00       	mov    $0x0,%eax
  80223b:	e9 87 00 00 00       	jmp    8022c7 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  802240:	8b 45 0c             	mov    0xc(%ebp),%eax
  802243:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802246:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80224d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802253:	39 d0                	cmp    %edx,%eax
  802255:	73 02                	jae    802259 <smalloc+0x35>
  802257:	89 d0                	mov    %edx,%eax
  802259:	83 ec 0c             	sub    $0xc,%esp
  80225c:	50                   	push   %eax
  80225d:	e8 a4 fc ff ff       	call   801f06 <malloc>
  802262:	83 c4 10             	add    $0x10,%esp
  802265:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  802268:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80226c:	75 07                	jne    802275 <smalloc+0x51>
  80226e:	b8 00 00 00 00       	mov    $0x0,%eax
  802273:	eb 52                	jmp    8022c7 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802275:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802279:	ff 75 ec             	pushl  -0x14(%ebp)
  80227c:	50                   	push   %eax
  80227d:	ff 75 0c             	pushl  0xc(%ebp)
  802280:	ff 75 08             	pushl  0x8(%ebp)
  802283:	e8 ed f4 ff ff       	call   801775 <sys_createSharedObject>
  802288:	83 c4 10             	add    $0x10,%esp
  80228b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80228e:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802292:	74 06                	je     80229a <smalloc+0x76>
  802294:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802298:	75 07                	jne    8022a1 <smalloc+0x7d>
  80229a:	b8 00 00 00 00       	mov    $0x0,%eax
  80229f:	eb 26                	jmp    8022c7 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8022a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8022a9:	8b 40 78             	mov    0x78(%eax),%eax
  8022ac:	29 c2                	sub    %eax,%edx
  8022ae:	89 d0                	mov    %edx,%eax
  8022b0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8022b5:	c1 e8 0c             	shr    $0xc,%eax
  8022b8:	89 c2                	mov    %eax,%edx
  8022ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022bd:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8022c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8022cf:	83 ec 08             	sub    $0x8,%esp
  8022d2:	ff 75 0c             	pushl  0xc(%ebp)
  8022d5:	ff 75 08             	pushl  0x8(%ebp)
  8022d8:	e8 c2 f4 ff ff       	call   80179f <sys_getSizeOfSharedObject>
  8022dd:	83 c4 10             	add    $0x10,%esp
  8022e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8022e3:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8022e7:	75 07                	jne    8022f0 <sget+0x27>
  8022e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ee:	eb 7f                	jmp    80236f <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8022f6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802303:	39 d0                	cmp    %edx,%eax
  802305:	73 02                	jae    802309 <sget+0x40>
  802307:	89 d0                	mov    %edx,%eax
  802309:	83 ec 0c             	sub    $0xc,%esp
  80230c:	50                   	push   %eax
  80230d:	e8 f4 fb ff ff       	call   801f06 <malloc>
  802312:	83 c4 10             	add    $0x10,%esp
  802315:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802318:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80231c:	75 07                	jne    802325 <sget+0x5c>
  80231e:	b8 00 00 00 00       	mov    $0x0,%eax
  802323:	eb 4a                	jmp    80236f <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802325:	83 ec 04             	sub    $0x4,%esp
  802328:	ff 75 e8             	pushl  -0x18(%ebp)
  80232b:	ff 75 0c             	pushl  0xc(%ebp)
  80232e:	ff 75 08             	pushl  0x8(%ebp)
  802331:	e8 86 f4 ff ff       	call   8017bc <sys_getSharedObject>
  802336:	83 c4 10             	add    $0x10,%esp
  802339:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  80233c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80233f:	a1 20 50 80 00       	mov    0x805020,%eax
  802344:	8b 40 78             	mov    0x78(%eax),%eax
  802347:	29 c2                	sub    %eax,%edx
  802349:	89 d0                	mov    %edx,%eax
  80234b:	2d 00 10 00 00       	sub    $0x1000,%eax
  802350:	c1 e8 0c             	shr    $0xc,%eax
  802353:	89 c2                	mov    %eax,%edx
  802355:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802358:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80235f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802363:	75 07                	jne    80236c <sget+0xa3>
  802365:	b8 00 00 00 00       	mov    $0x0,%eax
  80236a:	eb 03                	jmp    80236f <sget+0xa6>
	return ptr;
  80236c:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
  802374:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802377:	8b 55 08             	mov    0x8(%ebp),%edx
  80237a:	a1 20 50 80 00       	mov    0x805020,%eax
  80237f:	8b 40 78             	mov    0x78(%eax),%eax
  802382:	29 c2                	sub    %eax,%edx
  802384:	89 d0                	mov    %edx,%eax
  802386:	2d 00 10 00 00       	sub    $0x1000,%eax
  80238b:	c1 e8 0c             	shr    $0xc,%eax
  80238e:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  802395:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802398:	83 ec 08             	sub    $0x8,%esp
  80239b:	ff 75 08             	pushl  0x8(%ebp)
  80239e:	ff 75 f4             	pushl  -0xc(%ebp)
  8023a1:	e8 35 f4 ff ff       	call   8017db <sys_freeSharedObject>
  8023a6:	83 c4 10             	add    $0x10,%esp
  8023a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8023ac:	90                   	nop
  8023ad:	c9                   	leave  
  8023ae:	c3                   	ret    

008023af <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
  8023b2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8023b5:	83 ec 04             	sub    $0x4,%esp
  8023b8:	68 d0 48 80 00       	push   $0x8048d0
  8023bd:	68 e4 00 00 00       	push   $0xe4
  8023c2:	68 c2 48 80 00       	push   $0x8048c2
  8023c7:	e8 52 df ff ff       	call   80031e <_panic>

008023cc <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
  8023cf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023d2:	83 ec 04             	sub    $0x4,%esp
  8023d5:	68 f6 48 80 00       	push   $0x8048f6
  8023da:	68 f0 00 00 00       	push   $0xf0
  8023df:	68 c2 48 80 00       	push   $0x8048c2
  8023e4:	e8 35 df ff ff       	call   80031e <_panic>

008023e9 <shrink>:

}
void shrink(uint32 newSize)
{
  8023e9:	55                   	push   %ebp
  8023ea:	89 e5                	mov    %esp,%ebp
  8023ec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023ef:	83 ec 04             	sub    $0x4,%esp
  8023f2:	68 f6 48 80 00       	push   $0x8048f6
  8023f7:	68 f5 00 00 00       	push   $0xf5
  8023fc:	68 c2 48 80 00       	push   $0x8048c2
  802401:	e8 18 df ff ff       	call   80031e <_panic>

00802406 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
  802409:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80240c:	83 ec 04             	sub    $0x4,%esp
  80240f:	68 f6 48 80 00       	push   $0x8048f6
  802414:	68 fa 00 00 00       	push   $0xfa
  802419:	68 c2 48 80 00       	push   $0x8048c2
  80241e:	e8 fb de ff ff       	call   80031e <_panic>

00802423 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
  802426:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802429:	8b 45 08             	mov    0x8(%ebp),%eax
  80242c:	83 e8 04             	sub    $0x4,%eax
  80242f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802432:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802435:	8b 00                	mov    (%eax),%eax
  802437:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	83 e8 04             	sub    $0x4,%eax
  802448:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80244b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80244e:	8b 00                	mov    (%eax),%eax
  802450:	83 e0 01             	and    $0x1,%eax
  802453:	85 c0                	test   %eax,%eax
  802455:	0f 94 c0             	sete   %al
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802460:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80246a:	83 f8 02             	cmp    $0x2,%eax
  80246d:	74 2b                	je     80249a <alloc_block+0x40>
  80246f:	83 f8 02             	cmp    $0x2,%eax
  802472:	7f 07                	jg     80247b <alloc_block+0x21>
  802474:	83 f8 01             	cmp    $0x1,%eax
  802477:	74 0e                	je     802487 <alloc_block+0x2d>
  802479:	eb 58                	jmp    8024d3 <alloc_block+0x79>
  80247b:	83 f8 03             	cmp    $0x3,%eax
  80247e:	74 2d                	je     8024ad <alloc_block+0x53>
  802480:	83 f8 04             	cmp    $0x4,%eax
  802483:	74 3b                	je     8024c0 <alloc_block+0x66>
  802485:	eb 4c                	jmp    8024d3 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802487:	83 ec 0c             	sub    $0xc,%esp
  80248a:	ff 75 08             	pushl  0x8(%ebp)
  80248d:	e8 11 03 00 00       	call   8027a3 <alloc_block_FF>
  802492:	83 c4 10             	add    $0x10,%esp
  802495:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802498:	eb 4a                	jmp    8024e4 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80249a:	83 ec 0c             	sub    $0xc,%esp
  80249d:	ff 75 08             	pushl  0x8(%ebp)
  8024a0:	e8 c7 19 00 00       	call   803e6c <alloc_block_NF>
  8024a5:	83 c4 10             	add    $0x10,%esp
  8024a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024ab:	eb 37                	jmp    8024e4 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8024ad:	83 ec 0c             	sub    $0xc,%esp
  8024b0:	ff 75 08             	pushl  0x8(%ebp)
  8024b3:	e8 a7 07 00 00       	call   802c5f <alloc_block_BF>
  8024b8:	83 c4 10             	add    $0x10,%esp
  8024bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024be:	eb 24                	jmp    8024e4 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8024c0:	83 ec 0c             	sub    $0xc,%esp
  8024c3:	ff 75 08             	pushl  0x8(%ebp)
  8024c6:	e8 84 19 00 00       	call   803e4f <alloc_block_WF>
  8024cb:	83 c4 10             	add    $0x10,%esp
  8024ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024d1:	eb 11                	jmp    8024e4 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8024d3:	83 ec 0c             	sub    $0xc,%esp
  8024d6:	68 08 49 80 00       	push   $0x804908
  8024db:	e8 fb e0 ff ff       	call   8005db <cprintf>
  8024e0:	83 c4 10             	add    $0x10,%esp
		break;
  8024e3:	90                   	nop
	}
	return va;
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	53                   	push   %ebx
  8024ed:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8024f0:	83 ec 0c             	sub    $0xc,%esp
  8024f3:	68 28 49 80 00       	push   $0x804928
  8024f8:	e8 de e0 ff ff       	call   8005db <cprintf>
  8024fd:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802500:	83 ec 0c             	sub    $0xc,%esp
  802503:	68 53 49 80 00       	push   $0x804953
  802508:	e8 ce e0 ff ff       	call   8005db <cprintf>
  80250d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802516:	eb 37                	jmp    80254f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802518:	83 ec 0c             	sub    $0xc,%esp
  80251b:	ff 75 f4             	pushl  -0xc(%ebp)
  80251e:	e8 19 ff ff ff       	call   80243c <is_free_block>
  802523:	83 c4 10             	add    $0x10,%esp
  802526:	0f be d8             	movsbl %al,%ebx
  802529:	83 ec 0c             	sub    $0xc,%esp
  80252c:	ff 75 f4             	pushl  -0xc(%ebp)
  80252f:	e8 ef fe ff ff       	call   802423 <get_block_size>
  802534:	83 c4 10             	add    $0x10,%esp
  802537:	83 ec 04             	sub    $0x4,%esp
  80253a:	53                   	push   %ebx
  80253b:	50                   	push   %eax
  80253c:	68 6b 49 80 00       	push   $0x80496b
  802541:	e8 95 e0 ff ff       	call   8005db <cprintf>
  802546:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802549:	8b 45 10             	mov    0x10(%ebp),%eax
  80254c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802553:	74 07                	je     80255c <print_blocks_list+0x73>
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 00                	mov    (%eax),%eax
  80255a:	eb 05                	jmp    802561 <print_blocks_list+0x78>
  80255c:	b8 00 00 00 00       	mov    $0x0,%eax
  802561:	89 45 10             	mov    %eax,0x10(%ebp)
  802564:	8b 45 10             	mov    0x10(%ebp),%eax
  802567:	85 c0                	test   %eax,%eax
  802569:	75 ad                	jne    802518 <print_blocks_list+0x2f>
  80256b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256f:	75 a7                	jne    802518 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802571:	83 ec 0c             	sub    $0xc,%esp
  802574:	68 28 49 80 00       	push   $0x804928
  802579:	e8 5d e0 ff ff       	call   8005db <cprintf>
  80257e:	83 c4 10             	add    $0x10,%esp

}
  802581:	90                   	nop
  802582:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802585:	c9                   	leave  
  802586:	c3                   	ret    

00802587 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802587:	55                   	push   %ebp
  802588:	89 e5                	mov    %esp,%ebp
  80258a:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80258d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802590:	83 e0 01             	and    $0x1,%eax
  802593:	85 c0                	test   %eax,%eax
  802595:	74 03                	je     80259a <initialize_dynamic_allocator+0x13>
  802597:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80259a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80259e:	0f 84 c7 01 00 00    	je     80276b <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8025a4:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8025ab:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8025ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b4:	01 d0                	add    %edx,%eax
  8025b6:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8025bb:	0f 87 ad 01 00 00    	ja     80276e <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8025c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c4:	85 c0                	test   %eax,%eax
  8025c6:	0f 89 a5 01 00 00    	jns    802771 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8025cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8025cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d2:	01 d0                	add    %edx,%eax
  8025d4:	83 e8 04             	sub    $0x4,%eax
  8025d7:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8025dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8025e3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025eb:	e9 87 00 00 00       	jmp    802677 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8025f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f4:	75 14                	jne    80260a <initialize_dynamic_allocator+0x83>
  8025f6:	83 ec 04             	sub    $0x4,%esp
  8025f9:	68 83 49 80 00       	push   $0x804983
  8025fe:	6a 79                	push   $0x79
  802600:	68 a1 49 80 00       	push   $0x8049a1
  802605:	e8 14 dd ff ff       	call   80031e <_panic>
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	8b 00                	mov    (%eax),%eax
  80260f:	85 c0                	test   %eax,%eax
  802611:	74 10                	je     802623 <initialize_dynamic_allocator+0x9c>
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 00                	mov    (%eax),%eax
  802618:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261b:	8b 52 04             	mov    0x4(%edx),%edx
  80261e:	89 50 04             	mov    %edx,0x4(%eax)
  802621:	eb 0b                	jmp    80262e <initialize_dynamic_allocator+0xa7>
  802623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802626:	8b 40 04             	mov    0x4(%eax),%eax
  802629:	a3 30 50 80 00       	mov    %eax,0x805030
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	8b 40 04             	mov    0x4(%eax),%eax
  802634:	85 c0                	test   %eax,%eax
  802636:	74 0f                	je     802647 <initialize_dynamic_allocator+0xc0>
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 40 04             	mov    0x4(%eax),%eax
  80263e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802641:	8b 12                	mov    (%edx),%edx
  802643:	89 10                	mov    %edx,(%eax)
  802645:	eb 0a                	jmp    802651 <initialize_dynamic_allocator+0xca>
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	8b 00                	mov    (%eax),%eax
  80264c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802664:	a1 38 50 80 00       	mov    0x805038,%eax
  802669:	48                   	dec    %eax
  80266a:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80266f:	a1 34 50 80 00       	mov    0x805034,%eax
  802674:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802677:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267b:	74 07                	je     802684 <initialize_dynamic_allocator+0xfd>
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 00                	mov    (%eax),%eax
  802682:	eb 05                	jmp    802689 <initialize_dynamic_allocator+0x102>
  802684:	b8 00 00 00 00       	mov    $0x0,%eax
  802689:	a3 34 50 80 00       	mov    %eax,0x805034
  80268e:	a1 34 50 80 00       	mov    0x805034,%eax
  802693:	85 c0                	test   %eax,%eax
  802695:	0f 85 55 ff ff ff    	jne    8025f0 <initialize_dynamic_allocator+0x69>
  80269b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269f:	0f 85 4b ff ff ff    	jne    8025f0 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8026a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8026ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ae:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8026b4:	a1 44 50 80 00       	mov    0x805044,%eax
  8026b9:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8026be:	a1 40 50 80 00       	mov    0x805040,%eax
  8026c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8026c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cc:	83 c0 08             	add    $0x8,%eax
  8026cf:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8026d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d5:	83 c0 04             	add    $0x4,%eax
  8026d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026db:	83 ea 08             	sub    $0x8,%edx
  8026de:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8026e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e6:	01 d0                	add    %edx,%eax
  8026e8:	83 e8 08             	sub    $0x8,%eax
  8026eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ee:	83 ea 08             	sub    $0x8,%edx
  8026f1:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8026f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8026fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802706:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80270a:	75 17                	jne    802723 <initialize_dynamic_allocator+0x19c>
  80270c:	83 ec 04             	sub    $0x4,%esp
  80270f:	68 bc 49 80 00       	push   $0x8049bc
  802714:	68 90 00 00 00       	push   $0x90
  802719:	68 a1 49 80 00       	push   $0x8049a1
  80271e:	e8 fb db ff ff       	call   80031e <_panic>
  802723:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272c:	89 10                	mov    %edx,(%eax)
  80272e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802731:	8b 00                	mov    (%eax),%eax
  802733:	85 c0                	test   %eax,%eax
  802735:	74 0d                	je     802744 <initialize_dynamic_allocator+0x1bd>
  802737:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80273c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80273f:	89 50 04             	mov    %edx,0x4(%eax)
  802742:	eb 08                	jmp    80274c <initialize_dynamic_allocator+0x1c5>
  802744:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802747:	a3 30 50 80 00       	mov    %eax,0x805030
  80274c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802754:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802757:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275e:	a1 38 50 80 00       	mov    0x805038,%eax
  802763:	40                   	inc    %eax
  802764:	a3 38 50 80 00       	mov    %eax,0x805038
  802769:	eb 07                	jmp    802772 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80276b:	90                   	nop
  80276c:	eb 04                	jmp    802772 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80276e:	90                   	nop
  80276f:	eb 01                	jmp    802772 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802771:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802772:	c9                   	leave  
  802773:	c3                   	ret    

00802774 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802777:	8b 45 10             	mov    0x10(%ebp),%eax
  80277a:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80277d:	8b 45 08             	mov    0x8(%ebp),%eax
  802780:	8d 50 fc             	lea    -0x4(%eax),%edx
  802783:	8b 45 0c             	mov    0xc(%ebp),%eax
  802786:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802788:	8b 45 08             	mov    0x8(%ebp),%eax
  80278b:	83 e8 04             	sub    $0x4,%eax
  80278e:	8b 00                	mov    (%eax),%eax
  802790:	83 e0 fe             	and    $0xfffffffe,%eax
  802793:	8d 50 f8             	lea    -0x8(%eax),%edx
  802796:	8b 45 08             	mov    0x8(%ebp),%eax
  802799:	01 c2                	add    %eax,%edx
  80279b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80279e:	89 02                	mov    %eax,(%edx)
}
  8027a0:	90                   	nop
  8027a1:	5d                   	pop    %ebp
  8027a2:	c3                   	ret    

008027a3 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8027a3:	55                   	push   %ebp
  8027a4:	89 e5                	mov    %esp,%ebp
  8027a6:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ac:	83 e0 01             	and    $0x1,%eax
  8027af:	85 c0                	test   %eax,%eax
  8027b1:	74 03                	je     8027b6 <alloc_block_FF+0x13>
  8027b3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027b6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027ba:	77 07                	ja     8027c3 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027bc:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027c3:	a1 24 50 80 00       	mov    0x805024,%eax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	75 73                	jne    80283f <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cf:	83 c0 10             	add    $0x10,%eax
  8027d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027d5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8027dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e2:	01 d0                	add    %edx,%eax
  8027e4:	48                   	dec    %eax
  8027e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8027e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8027f0:	f7 75 ec             	divl   -0x14(%ebp)
  8027f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f6:	29 d0                	sub    %edx,%eax
  8027f8:	c1 e8 0c             	shr    $0xc,%eax
  8027fb:	83 ec 0c             	sub    $0xc,%esp
  8027fe:	50                   	push   %eax
  8027ff:	e8 ec f6 ff ff       	call   801ef0 <sbrk>
  802804:	83 c4 10             	add    $0x10,%esp
  802807:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80280a:	83 ec 0c             	sub    $0xc,%esp
  80280d:	6a 00                	push   $0x0
  80280f:	e8 dc f6 ff ff       	call   801ef0 <sbrk>
  802814:	83 c4 10             	add    $0x10,%esp
  802817:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80281a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80281d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802820:	83 ec 08             	sub    $0x8,%esp
  802823:	50                   	push   %eax
  802824:	ff 75 e4             	pushl  -0x1c(%ebp)
  802827:	e8 5b fd ff ff       	call   802587 <initialize_dynamic_allocator>
  80282c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80282f:	83 ec 0c             	sub    $0xc,%esp
  802832:	68 df 49 80 00       	push   $0x8049df
  802837:	e8 9f dd ff ff       	call   8005db <cprintf>
  80283c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80283f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802843:	75 0a                	jne    80284f <alloc_block_FF+0xac>
	        return NULL;
  802845:	b8 00 00 00 00       	mov    $0x0,%eax
  80284a:	e9 0e 04 00 00       	jmp    802c5d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80284f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802856:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80285b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285e:	e9 f3 02 00 00       	jmp    802b56 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802869:	83 ec 0c             	sub    $0xc,%esp
  80286c:	ff 75 bc             	pushl  -0x44(%ebp)
  80286f:	e8 af fb ff ff       	call   802423 <get_block_size>
  802874:	83 c4 10             	add    $0x10,%esp
  802877:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80287a:	8b 45 08             	mov    0x8(%ebp),%eax
  80287d:	83 c0 08             	add    $0x8,%eax
  802880:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802883:	0f 87 c5 02 00 00    	ja     802b4e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802889:	8b 45 08             	mov    0x8(%ebp),%eax
  80288c:	83 c0 18             	add    $0x18,%eax
  80288f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802892:	0f 87 19 02 00 00    	ja     802ab1 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802898:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80289b:	2b 45 08             	sub    0x8(%ebp),%eax
  80289e:	83 e8 08             	sub    $0x8,%eax
  8028a1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8028a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a7:	8d 50 08             	lea    0x8(%eax),%edx
  8028aa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8028ad:	01 d0                	add    %edx,%eax
  8028af:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	83 c0 08             	add    $0x8,%eax
  8028b8:	83 ec 04             	sub    $0x4,%esp
  8028bb:	6a 01                	push   $0x1
  8028bd:	50                   	push   %eax
  8028be:	ff 75 bc             	pushl  -0x44(%ebp)
  8028c1:	e8 ae fe ff ff       	call   802774 <set_block_data>
  8028c6:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 40 04             	mov    0x4(%eax),%eax
  8028cf:	85 c0                	test   %eax,%eax
  8028d1:	75 68                	jne    80293b <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028d3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8028d7:	75 17                	jne    8028f0 <alloc_block_FF+0x14d>
  8028d9:	83 ec 04             	sub    $0x4,%esp
  8028dc:	68 bc 49 80 00       	push   $0x8049bc
  8028e1:	68 d7 00 00 00       	push   $0xd7
  8028e6:	68 a1 49 80 00       	push   $0x8049a1
  8028eb:	e8 2e da ff ff       	call   80031e <_panic>
  8028f0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8028f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028f9:	89 10                	mov    %edx,(%eax)
  8028fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8028fe:	8b 00                	mov    (%eax),%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	74 0d                	je     802911 <alloc_block_FF+0x16e>
  802904:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802909:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80290c:	89 50 04             	mov    %edx,0x4(%eax)
  80290f:	eb 08                	jmp    802919 <alloc_block_FF+0x176>
  802911:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802914:	a3 30 50 80 00       	mov    %eax,0x805030
  802919:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80291c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802921:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802924:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292b:	a1 38 50 80 00       	mov    0x805038,%eax
  802930:	40                   	inc    %eax
  802931:	a3 38 50 80 00       	mov    %eax,0x805038
  802936:	e9 dc 00 00 00       	jmp    802a17 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	8b 00                	mov    (%eax),%eax
  802940:	85 c0                	test   %eax,%eax
  802942:	75 65                	jne    8029a9 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802944:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802948:	75 17                	jne    802961 <alloc_block_FF+0x1be>
  80294a:	83 ec 04             	sub    $0x4,%esp
  80294d:	68 f0 49 80 00       	push   $0x8049f0
  802952:	68 db 00 00 00       	push   $0xdb
  802957:	68 a1 49 80 00       	push   $0x8049a1
  80295c:	e8 bd d9 ff ff       	call   80031e <_panic>
  802961:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802967:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80296a:	89 50 04             	mov    %edx,0x4(%eax)
  80296d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802970:	8b 40 04             	mov    0x4(%eax),%eax
  802973:	85 c0                	test   %eax,%eax
  802975:	74 0c                	je     802983 <alloc_block_FF+0x1e0>
  802977:	a1 30 50 80 00       	mov    0x805030,%eax
  80297c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80297f:	89 10                	mov    %edx,(%eax)
  802981:	eb 08                	jmp    80298b <alloc_block_FF+0x1e8>
  802983:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802986:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80298b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80298e:	a3 30 50 80 00       	mov    %eax,0x805030
  802993:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802996:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299c:	a1 38 50 80 00       	mov    0x805038,%eax
  8029a1:	40                   	inc    %eax
  8029a2:	a3 38 50 80 00       	mov    %eax,0x805038
  8029a7:	eb 6e                	jmp    802a17 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8029a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ad:	74 06                	je     8029b5 <alloc_block_FF+0x212>
  8029af:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029b3:	75 17                	jne    8029cc <alloc_block_FF+0x229>
  8029b5:	83 ec 04             	sub    $0x4,%esp
  8029b8:	68 14 4a 80 00       	push   $0x804a14
  8029bd:	68 df 00 00 00       	push   $0xdf
  8029c2:	68 a1 49 80 00       	push   $0x8049a1
  8029c7:	e8 52 d9 ff ff       	call   80031e <_panic>
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	8b 10                	mov    (%eax),%edx
  8029d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029d4:	89 10                	mov    %edx,(%eax)
  8029d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	74 0b                	je     8029ea <alloc_block_FF+0x247>
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 00                	mov    (%eax),%eax
  8029e4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029e7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029f0:	89 10                	mov    %edx,(%eax)
  8029f2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f8:	89 50 04             	mov    %edx,0x4(%eax)
  8029fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	85 c0                	test   %eax,%eax
  802a02:	75 08                	jne    802a0c <alloc_block_FF+0x269>
  802a04:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a07:	a3 30 50 80 00       	mov    %eax,0x805030
  802a0c:	a1 38 50 80 00       	mov    0x805038,%eax
  802a11:	40                   	inc    %eax
  802a12:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802a17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1b:	75 17                	jne    802a34 <alloc_block_FF+0x291>
  802a1d:	83 ec 04             	sub    $0x4,%esp
  802a20:	68 83 49 80 00       	push   $0x804983
  802a25:	68 e1 00 00 00       	push   $0xe1
  802a2a:	68 a1 49 80 00       	push   $0x8049a1
  802a2f:	e8 ea d8 ff ff       	call   80031e <_panic>
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 00                	mov    (%eax),%eax
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	74 10                	je     802a4d <alloc_block_FF+0x2aa>
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	8b 00                	mov    (%eax),%eax
  802a42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a45:	8b 52 04             	mov    0x4(%edx),%edx
  802a48:	89 50 04             	mov    %edx,0x4(%eax)
  802a4b:	eb 0b                	jmp    802a58 <alloc_block_FF+0x2b5>
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 40 04             	mov    0x4(%eax),%eax
  802a53:	a3 30 50 80 00       	mov    %eax,0x805030
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	8b 40 04             	mov    0x4(%eax),%eax
  802a5e:	85 c0                	test   %eax,%eax
  802a60:	74 0f                	je     802a71 <alloc_block_FF+0x2ce>
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 40 04             	mov    0x4(%eax),%eax
  802a68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6b:	8b 12                	mov    (%edx),%edx
  802a6d:	89 10                	mov    %edx,(%eax)
  802a6f:	eb 0a                	jmp    802a7b <alloc_block_FF+0x2d8>
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 00                	mov    (%eax),%eax
  802a76:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8e:	a1 38 50 80 00       	mov    0x805038,%eax
  802a93:	48                   	dec    %eax
  802a94:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802a99:	83 ec 04             	sub    $0x4,%esp
  802a9c:	6a 00                	push   $0x0
  802a9e:	ff 75 b4             	pushl  -0x4c(%ebp)
  802aa1:	ff 75 b0             	pushl  -0x50(%ebp)
  802aa4:	e8 cb fc ff ff       	call   802774 <set_block_data>
  802aa9:	83 c4 10             	add    $0x10,%esp
  802aac:	e9 95 00 00 00       	jmp    802b46 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802ab1:	83 ec 04             	sub    $0x4,%esp
  802ab4:	6a 01                	push   $0x1
  802ab6:	ff 75 b8             	pushl  -0x48(%ebp)
  802ab9:	ff 75 bc             	pushl  -0x44(%ebp)
  802abc:	e8 b3 fc ff ff       	call   802774 <set_block_data>
  802ac1:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802ac4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac8:	75 17                	jne    802ae1 <alloc_block_FF+0x33e>
  802aca:	83 ec 04             	sub    $0x4,%esp
  802acd:	68 83 49 80 00       	push   $0x804983
  802ad2:	68 e8 00 00 00       	push   $0xe8
  802ad7:	68 a1 49 80 00       	push   $0x8049a1
  802adc:	e8 3d d8 ff ff       	call   80031e <_panic>
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	8b 00                	mov    (%eax),%eax
  802ae6:	85 c0                	test   %eax,%eax
  802ae8:	74 10                	je     802afa <alloc_block_FF+0x357>
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	8b 00                	mov    (%eax),%eax
  802aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af2:	8b 52 04             	mov    0x4(%edx),%edx
  802af5:	89 50 04             	mov    %edx,0x4(%eax)
  802af8:	eb 0b                	jmp    802b05 <alloc_block_FF+0x362>
  802afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afd:	8b 40 04             	mov    0x4(%eax),%eax
  802b00:	a3 30 50 80 00       	mov    %eax,0x805030
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 40 04             	mov    0x4(%eax),%eax
  802b0b:	85 c0                	test   %eax,%eax
  802b0d:	74 0f                	je     802b1e <alloc_block_FF+0x37b>
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 40 04             	mov    0x4(%eax),%eax
  802b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b18:	8b 12                	mov    (%edx),%edx
  802b1a:	89 10                	mov    %edx,(%eax)
  802b1c:	eb 0a                	jmp    802b28 <alloc_block_FF+0x385>
  802b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b21:	8b 00                	mov    (%eax),%eax
  802b23:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3b:	a1 38 50 80 00       	mov    0x805038,%eax
  802b40:	48                   	dec    %eax
  802b41:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802b46:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b49:	e9 0f 01 00 00       	jmp    802c5d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802b4e:	a1 34 50 80 00       	mov    0x805034,%eax
  802b53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5a:	74 07                	je     802b63 <alloc_block_FF+0x3c0>
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	8b 00                	mov    (%eax),%eax
  802b61:	eb 05                	jmp    802b68 <alloc_block_FF+0x3c5>
  802b63:	b8 00 00 00 00       	mov    $0x0,%eax
  802b68:	a3 34 50 80 00       	mov    %eax,0x805034
  802b6d:	a1 34 50 80 00       	mov    0x805034,%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	0f 85 e9 fc ff ff    	jne    802863 <alloc_block_FF+0xc0>
  802b7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7e:	0f 85 df fc ff ff    	jne    802863 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	83 c0 08             	add    $0x8,%eax
  802b8a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b8d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802b94:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b9a:	01 d0                	add    %edx,%eax
  802b9c:	48                   	dec    %eax
  802b9d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802ba0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ba3:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba8:	f7 75 d8             	divl   -0x28(%ebp)
  802bab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bae:	29 d0                	sub    %edx,%eax
  802bb0:	c1 e8 0c             	shr    $0xc,%eax
  802bb3:	83 ec 0c             	sub    $0xc,%esp
  802bb6:	50                   	push   %eax
  802bb7:	e8 34 f3 ff ff       	call   801ef0 <sbrk>
  802bbc:	83 c4 10             	add    $0x10,%esp
  802bbf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802bc2:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802bc6:	75 0a                	jne    802bd2 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bcd:	e9 8b 00 00 00       	jmp    802c5d <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802bd2:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802bd9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bdc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bdf:	01 d0                	add    %edx,%eax
  802be1:	48                   	dec    %eax
  802be2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802be5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802be8:	ba 00 00 00 00       	mov    $0x0,%edx
  802bed:	f7 75 cc             	divl   -0x34(%ebp)
  802bf0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802bf3:	29 d0                	sub    %edx,%eax
  802bf5:	8d 50 fc             	lea    -0x4(%eax),%edx
  802bf8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bfb:	01 d0                	add    %edx,%eax
  802bfd:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802c02:	a1 40 50 80 00       	mov    0x805040,%eax
  802c07:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c0d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c14:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c17:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c1a:	01 d0                	add    %edx,%eax
  802c1c:	48                   	dec    %eax
  802c1d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c20:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c23:	ba 00 00 00 00       	mov    $0x0,%edx
  802c28:	f7 75 c4             	divl   -0x3c(%ebp)
  802c2b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c2e:	29 d0                	sub    %edx,%eax
  802c30:	83 ec 04             	sub    $0x4,%esp
  802c33:	6a 01                	push   $0x1
  802c35:	50                   	push   %eax
  802c36:	ff 75 d0             	pushl  -0x30(%ebp)
  802c39:	e8 36 fb ff ff       	call   802774 <set_block_data>
  802c3e:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802c41:	83 ec 0c             	sub    $0xc,%esp
  802c44:	ff 75 d0             	pushl  -0x30(%ebp)
  802c47:	e8 f8 09 00 00       	call   803644 <free_block>
  802c4c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802c4f:	83 ec 0c             	sub    $0xc,%esp
  802c52:	ff 75 08             	pushl  0x8(%ebp)
  802c55:	e8 49 fb ff ff       	call   8027a3 <alloc_block_FF>
  802c5a:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802c5d:	c9                   	leave  
  802c5e:	c3                   	ret    

00802c5f <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802c5f:	55                   	push   %ebp
  802c60:	89 e5                	mov    %esp,%ebp
  802c62:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	83 e0 01             	and    $0x1,%eax
  802c6b:	85 c0                	test   %eax,%eax
  802c6d:	74 03                	je     802c72 <alloc_block_BF+0x13>
  802c6f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802c72:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802c76:	77 07                	ja     802c7f <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802c78:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802c7f:	a1 24 50 80 00       	mov    0x805024,%eax
  802c84:	85 c0                	test   %eax,%eax
  802c86:	75 73                	jne    802cfb <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	83 c0 10             	add    $0x10,%eax
  802c8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802c91:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802c98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9e:	01 d0                	add    %edx,%eax
  802ca0:	48                   	dec    %eax
  802ca1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ca4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  802cac:	f7 75 e0             	divl   -0x20(%ebp)
  802caf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cb2:	29 d0                	sub    %edx,%eax
  802cb4:	c1 e8 0c             	shr    $0xc,%eax
  802cb7:	83 ec 0c             	sub    $0xc,%esp
  802cba:	50                   	push   %eax
  802cbb:	e8 30 f2 ff ff       	call   801ef0 <sbrk>
  802cc0:	83 c4 10             	add    $0x10,%esp
  802cc3:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802cc6:	83 ec 0c             	sub    $0xc,%esp
  802cc9:	6a 00                	push   $0x0
  802ccb:	e8 20 f2 ff ff       	call   801ef0 <sbrk>
  802cd0:	83 c4 10             	add    $0x10,%esp
  802cd3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802cd6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cd9:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802cdc:	83 ec 08             	sub    $0x8,%esp
  802cdf:	50                   	push   %eax
  802ce0:	ff 75 d8             	pushl  -0x28(%ebp)
  802ce3:	e8 9f f8 ff ff       	call   802587 <initialize_dynamic_allocator>
  802ce8:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802ceb:	83 ec 0c             	sub    $0xc,%esp
  802cee:	68 df 49 80 00       	push   $0x8049df
  802cf3:	e8 e3 d8 ff ff       	call   8005db <cprintf>
  802cf8:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802cfb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802d02:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802d09:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802d10:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802d17:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d1f:	e9 1d 01 00 00       	jmp    802e41 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802d2a:	83 ec 0c             	sub    $0xc,%esp
  802d2d:	ff 75 a8             	pushl  -0x58(%ebp)
  802d30:	e8 ee f6 ff ff       	call   802423 <get_block_size>
  802d35:	83 c4 10             	add    $0x10,%esp
  802d38:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3e:	83 c0 08             	add    $0x8,%eax
  802d41:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d44:	0f 87 ef 00 00 00    	ja     802e39 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	83 c0 18             	add    $0x18,%eax
  802d50:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d53:	77 1d                	ja     802d72 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d58:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d5b:	0f 86 d8 00 00 00    	jbe    802e39 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802d61:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802d67:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802d6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d6d:	e9 c7 00 00 00       	jmp    802e39 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	83 c0 08             	add    $0x8,%eax
  802d78:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d7b:	0f 85 9d 00 00 00    	jne    802e1e <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802d81:	83 ec 04             	sub    $0x4,%esp
  802d84:	6a 01                	push   $0x1
  802d86:	ff 75 a4             	pushl  -0x5c(%ebp)
  802d89:	ff 75 a8             	pushl  -0x58(%ebp)
  802d8c:	e8 e3 f9 ff ff       	call   802774 <set_block_data>
  802d91:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802d94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d98:	75 17                	jne    802db1 <alloc_block_BF+0x152>
  802d9a:	83 ec 04             	sub    $0x4,%esp
  802d9d:	68 83 49 80 00       	push   $0x804983
  802da2:	68 2c 01 00 00       	push   $0x12c
  802da7:	68 a1 49 80 00       	push   $0x8049a1
  802dac:	e8 6d d5 ff ff       	call   80031e <_panic>
  802db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db4:	8b 00                	mov    (%eax),%eax
  802db6:	85 c0                	test   %eax,%eax
  802db8:	74 10                	je     802dca <alloc_block_BF+0x16b>
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 00                	mov    (%eax),%eax
  802dbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc2:	8b 52 04             	mov    0x4(%edx),%edx
  802dc5:	89 50 04             	mov    %edx,0x4(%eax)
  802dc8:	eb 0b                	jmp    802dd5 <alloc_block_BF+0x176>
  802dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcd:	8b 40 04             	mov    0x4(%eax),%eax
  802dd0:	a3 30 50 80 00       	mov    %eax,0x805030
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 40 04             	mov    0x4(%eax),%eax
  802ddb:	85 c0                	test   %eax,%eax
  802ddd:	74 0f                	je     802dee <alloc_block_BF+0x18f>
  802ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de2:	8b 40 04             	mov    0x4(%eax),%eax
  802de5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de8:	8b 12                	mov    (%edx),%edx
  802dea:	89 10                	mov    %edx,(%eax)
  802dec:	eb 0a                	jmp    802df8 <alloc_block_BF+0x199>
  802dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df1:	8b 00                	mov    (%eax),%eax
  802df3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0b:	a1 38 50 80 00       	mov    0x805038,%eax
  802e10:	48                   	dec    %eax
  802e11:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802e16:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e19:	e9 01 04 00 00       	jmp    80321f <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e21:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e24:	76 13                	jbe    802e39 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802e26:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802e2d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e30:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802e33:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802e36:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802e39:	a1 34 50 80 00       	mov    0x805034,%eax
  802e3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e45:	74 07                	je     802e4e <alloc_block_BF+0x1ef>
  802e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4a:	8b 00                	mov    (%eax),%eax
  802e4c:	eb 05                	jmp    802e53 <alloc_block_BF+0x1f4>
  802e4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e53:	a3 34 50 80 00       	mov    %eax,0x805034
  802e58:	a1 34 50 80 00       	mov    0x805034,%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	0f 85 bf fe ff ff    	jne    802d24 <alloc_block_BF+0xc5>
  802e65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e69:	0f 85 b5 fe ff ff    	jne    802d24 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802e6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e73:	0f 84 26 02 00 00    	je     80309f <alloc_block_BF+0x440>
  802e79:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e7d:	0f 85 1c 02 00 00    	jne    80309f <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802e83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e86:	2b 45 08             	sub    0x8(%ebp),%eax
  802e89:	83 e8 08             	sub    $0x8,%eax
  802e8c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	8d 50 08             	lea    0x8(%eax),%edx
  802e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e98:	01 d0                	add    %edx,%eax
  802e9a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	83 c0 08             	add    $0x8,%eax
  802ea3:	83 ec 04             	sub    $0x4,%esp
  802ea6:	6a 01                	push   $0x1
  802ea8:	50                   	push   %eax
  802ea9:	ff 75 f0             	pushl  -0x10(%ebp)
  802eac:	e8 c3 f8 ff ff       	call   802774 <set_block_data>
  802eb1:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb7:	8b 40 04             	mov    0x4(%eax),%eax
  802eba:	85 c0                	test   %eax,%eax
  802ebc:	75 68                	jne    802f26 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ebe:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ec2:	75 17                	jne    802edb <alloc_block_BF+0x27c>
  802ec4:	83 ec 04             	sub    $0x4,%esp
  802ec7:	68 bc 49 80 00       	push   $0x8049bc
  802ecc:	68 45 01 00 00       	push   $0x145
  802ed1:	68 a1 49 80 00       	push   $0x8049a1
  802ed6:	e8 43 d4 ff ff       	call   80031e <_panic>
  802edb:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802ee1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ee4:	89 10                	mov    %edx,(%eax)
  802ee6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ee9:	8b 00                	mov    (%eax),%eax
  802eeb:	85 c0                	test   %eax,%eax
  802eed:	74 0d                	je     802efc <alloc_block_BF+0x29d>
  802eef:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ef4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ef7:	89 50 04             	mov    %edx,0x4(%eax)
  802efa:	eb 08                	jmp    802f04 <alloc_block_BF+0x2a5>
  802efc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802eff:	a3 30 50 80 00       	mov    %eax,0x805030
  802f04:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f07:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f0c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f16:	a1 38 50 80 00       	mov    0x805038,%eax
  802f1b:	40                   	inc    %eax
  802f1c:	a3 38 50 80 00       	mov    %eax,0x805038
  802f21:	e9 dc 00 00 00       	jmp    803002 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f29:	8b 00                	mov    (%eax),%eax
  802f2b:	85 c0                	test   %eax,%eax
  802f2d:	75 65                	jne    802f94 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f2f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f33:	75 17                	jne    802f4c <alloc_block_BF+0x2ed>
  802f35:	83 ec 04             	sub    $0x4,%esp
  802f38:	68 f0 49 80 00       	push   $0x8049f0
  802f3d:	68 4a 01 00 00       	push   $0x14a
  802f42:	68 a1 49 80 00       	push   $0x8049a1
  802f47:	e8 d2 d3 ff ff       	call   80031e <_panic>
  802f4c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f52:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f55:	89 50 04             	mov    %edx,0x4(%eax)
  802f58:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f5b:	8b 40 04             	mov    0x4(%eax),%eax
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	74 0c                	je     802f6e <alloc_block_BF+0x30f>
  802f62:	a1 30 50 80 00       	mov    0x805030,%eax
  802f67:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f6a:	89 10                	mov    %edx,(%eax)
  802f6c:	eb 08                	jmp    802f76 <alloc_block_BF+0x317>
  802f6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f71:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f76:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f79:	a3 30 50 80 00       	mov    %eax,0x805030
  802f7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f87:	a1 38 50 80 00       	mov    0x805038,%eax
  802f8c:	40                   	inc    %eax
  802f8d:	a3 38 50 80 00       	mov    %eax,0x805038
  802f92:	eb 6e                	jmp    803002 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802f94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f98:	74 06                	je     802fa0 <alloc_block_BF+0x341>
  802f9a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f9e:	75 17                	jne    802fb7 <alloc_block_BF+0x358>
  802fa0:	83 ec 04             	sub    $0x4,%esp
  802fa3:	68 14 4a 80 00       	push   $0x804a14
  802fa8:	68 4f 01 00 00       	push   $0x14f
  802fad:	68 a1 49 80 00       	push   $0x8049a1
  802fb2:	e8 67 d3 ff ff       	call   80031e <_panic>
  802fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fba:	8b 10                	mov    (%eax),%edx
  802fbc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fbf:	89 10                	mov    %edx,(%eax)
  802fc1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fc4:	8b 00                	mov    (%eax),%eax
  802fc6:	85 c0                	test   %eax,%eax
  802fc8:	74 0b                	je     802fd5 <alloc_block_BF+0x376>
  802fca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcd:	8b 00                	mov    (%eax),%eax
  802fcf:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fd2:	89 50 04             	mov    %edx,0x4(%eax)
  802fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fdb:	89 10                	mov    %edx,(%eax)
  802fdd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fe0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fe3:	89 50 04             	mov    %edx,0x4(%eax)
  802fe6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fe9:	8b 00                	mov    (%eax),%eax
  802feb:	85 c0                	test   %eax,%eax
  802fed:	75 08                	jne    802ff7 <alloc_block_BF+0x398>
  802fef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ff2:	a3 30 50 80 00       	mov    %eax,0x805030
  802ff7:	a1 38 50 80 00       	mov    0x805038,%eax
  802ffc:	40                   	inc    %eax
  802ffd:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803002:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803006:	75 17                	jne    80301f <alloc_block_BF+0x3c0>
  803008:	83 ec 04             	sub    $0x4,%esp
  80300b:	68 83 49 80 00       	push   $0x804983
  803010:	68 51 01 00 00       	push   $0x151
  803015:	68 a1 49 80 00       	push   $0x8049a1
  80301a:	e8 ff d2 ff ff       	call   80031e <_panic>
  80301f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803022:	8b 00                	mov    (%eax),%eax
  803024:	85 c0                	test   %eax,%eax
  803026:	74 10                	je     803038 <alloc_block_BF+0x3d9>
  803028:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302b:	8b 00                	mov    (%eax),%eax
  80302d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803030:	8b 52 04             	mov    0x4(%edx),%edx
  803033:	89 50 04             	mov    %edx,0x4(%eax)
  803036:	eb 0b                	jmp    803043 <alloc_block_BF+0x3e4>
  803038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303b:	8b 40 04             	mov    0x4(%eax),%eax
  80303e:	a3 30 50 80 00       	mov    %eax,0x805030
  803043:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803046:	8b 40 04             	mov    0x4(%eax),%eax
  803049:	85 c0                	test   %eax,%eax
  80304b:	74 0f                	je     80305c <alloc_block_BF+0x3fd>
  80304d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803050:	8b 40 04             	mov    0x4(%eax),%eax
  803053:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803056:	8b 12                	mov    (%edx),%edx
  803058:	89 10                	mov    %edx,(%eax)
  80305a:	eb 0a                	jmp    803066 <alloc_block_BF+0x407>
  80305c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305f:	8b 00                	mov    (%eax),%eax
  803061:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803069:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803072:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803079:	a1 38 50 80 00       	mov    0x805038,%eax
  80307e:	48                   	dec    %eax
  80307f:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  803084:	83 ec 04             	sub    $0x4,%esp
  803087:	6a 00                	push   $0x0
  803089:	ff 75 d0             	pushl  -0x30(%ebp)
  80308c:	ff 75 cc             	pushl  -0x34(%ebp)
  80308f:	e8 e0 f6 ff ff       	call   802774 <set_block_data>
  803094:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309a:	e9 80 01 00 00       	jmp    80321f <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  80309f:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8030a3:	0f 85 9d 00 00 00    	jne    803146 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8030a9:	83 ec 04             	sub    $0x4,%esp
  8030ac:	6a 01                	push   $0x1
  8030ae:	ff 75 ec             	pushl  -0x14(%ebp)
  8030b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8030b4:	e8 bb f6 ff ff       	call   802774 <set_block_data>
  8030b9:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8030bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030c0:	75 17                	jne    8030d9 <alloc_block_BF+0x47a>
  8030c2:	83 ec 04             	sub    $0x4,%esp
  8030c5:	68 83 49 80 00       	push   $0x804983
  8030ca:	68 58 01 00 00       	push   $0x158
  8030cf:	68 a1 49 80 00       	push   $0x8049a1
  8030d4:	e8 45 d2 ff ff       	call   80031e <_panic>
  8030d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030dc:	8b 00                	mov    (%eax),%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	74 10                	je     8030f2 <alloc_block_BF+0x493>
  8030e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e5:	8b 00                	mov    (%eax),%eax
  8030e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030ea:	8b 52 04             	mov    0x4(%edx),%edx
  8030ed:	89 50 04             	mov    %edx,0x4(%eax)
  8030f0:	eb 0b                	jmp    8030fd <alloc_block_BF+0x49e>
  8030f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f5:	8b 40 04             	mov    0x4(%eax),%eax
  8030f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8030fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803100:	8b 40 04             	mov    0x4(%eax),%eax
  803103:	85 c0                	test   %eax,%eax
  803105:	74 0f                	je     803116 <alloc_block_BF+0x4b7>
  803107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310a:	8b 40 04             	mov    0x4(%eax),%eax
  80310d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803110:	8b 12                	mov    (%edx),%edx
  803112:	89 10                	mov    %edx,(%eax)
  803114:	eb 0a                	jmp    803120 <alloc_block_BF+0x4c1>
  803116:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803119:	8b 00                	mov    (%eax),%eax
  80311b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803123:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803129:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803133:	a1 38 50 80 00       	mov    0x805038,%eax
  803138:	48                   	dec    %eax
  803139:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  80313e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803141:	e9 d9 00 00 00       	jmp    80321f <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803146:	8b 45 08             	mov    0x8(%ebp),%eax
  803149:	83 c0 08             	add    $0x8,%eax
  80314c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80314f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803156:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803159:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80315c:	01 d0                	add    %edx,%eax
  80315e:	48                   	dec    %eax
  80315f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803162:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803165:	ba 00 00 00 00       	mov    $0x0,%edx
  80316a:	f7 75 c4             	divl   -0x3c(%ebp)
  80316d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803170:	29 d0                	sub    %edx,%eax
  803172:	c1 e8 0c             	shr    $0xc,%eax
  803175:	83 ec 0c             	sub    $0xc,%esp
  803178:	50                   	push   %eax
  803179:	e8 72 ed ff ff       	call   801ef0 <sbrk>
  80317e:	83 c4 10             	add    $0x10,%esp
  803181:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803184:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803188:	75 0a                	jne    803194 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80318a:	b8 00 00 00 00       	mov    $0x0,%eax
  80318f:	e9 8b 00 00 00       	jmp    80321f <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803194:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80319b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80319e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8031a1:	01 d0                	add    %edx,%eax
  8031a3:	48                   	dec    %eax
  8031a4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8031a7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8031aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8031af:	f7 75 b8             	divl   -0x48(%ebp)
  8031b2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8031b5:	29 d0                	sub    %edx,%eax
  8031b7:	8d 50 fc             	lea    -0x4(%eax),%edx
  8031ba:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8031bd:	01 d0                	add    %edx,%eax
  8031bf:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  8031c4:	a1 40 50 80 00       	mov    0x805040,%eax
  8031c9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8031cf:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8031d6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8031dc:	01 d0                	add    %edx,%eax
  8031de:	48                   	dec    %eax
  8031df:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8031e2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8031e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8031ea:	f7 75 b0             	divl   -0x50(%ebp)
  8031ed:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8031f0:	29 d0                	sub    %edx,%eax
  8031f2:	83 ec 04             	sub    $0x4,%esp
  8031f5:	6a 01                	push   $0x1
  8031f7:	50                   	push   %eax
  8031f8:	ff 75 bc             	pushl  -0x44(%ebp)
  8031fb:	e8 74 f5 ff ff       	call   802774 <set_block_data>
  803200:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803203:	83 ec 0c             	sub    $0xc,%esp
  803206:	ff 75 bc             	pushl  -0x44(%ebp)
  803209:	e8 36 04 00 00       	call   803644 <free_block>
  80320e:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803211:	83 ec 0c             	sub    $0xc,%esp
  803214:	ff 75 08             	pushl  0x8(%ebp)
  803217:	e8 43 fa ff ff       	call   802c5f <alloc_block_BF>
  80321c:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80321f:	c9                   	leave  
  803220:	c3                   	ret    

00803221 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803221:	55                   	push   %ebp
  803222:	89 e5                	mov    %esp,%ebp
  803224:	53                   	push   %ebx
  803225:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80322f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803236:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80323a:	74 1e                	je     80325a <merging+0x39>
  80323c:	ff 75 08             	pushl  0x8(%ebp)
  80323f:	e8 df f1 ff ff       	call   802423 <get_block_size>
  803244:	83 c4 04             	add    $0x4,%esp
  803247:	89 c2                	mov    %eax,%edx
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	01 d0                	add    %edx,%eax
  80324e:	3b 45 10             	cmp    0x10(%ebp),%eax
  803251:	75 07                	jne    80325a <merging+0x39>
		prev_is_free = 1;
  803253:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80325a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80325e:	74 1e                	je     80327e <merging+0x5d>
  803260:	ff 75 10             	pushl  0x10(%ebp)
  803263:	e8 bb f1 ff ff       	call   802423 <get_block_size>
  803268:	83 c4 04             	add    $0x4,%esp
  80326b:	89 c2                	mov    %eax,%edx
  80326d:	8b 45 10             	mov    0x10(%ebp),%eax
  803270:	01 d0                	add    %edx,%eax
  803272:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803275:	75 07                	jne    80327e <merging+0x5d>
		next_is_free = 1;
  803277:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80327e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803282:	0f 84 cc 00 00 00    	je     803354 <merging+0x133>
  803288:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80328c:	0f 84 c2 00 00 00    	je     803354 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803292:	ff 75 08             	pushl  0x8(%ebp)
  803295:	e8 89 f1 ff ff       	call   802423 <get_block_size>
  80329a:	83 c4 04             	add    $0x4,%esp
  80329d:	89 c3                	mov    %eax,%ebx
  80329f:	ff 75 10             	pushl  0x10(%ebp)
  8032a2:	e8 7c f1 ff ff       	call   802423 <get_block_size>
  8032a7:	83 c4 04             	add    $0x4,%esp
  8032aa:	01 c3                	add    %eax,%ebx
  8032ac:	ff 75 0c             	pushl  0xc(%ebp)
  8032af:	e8 6f f1 ff ff       	call   802423 <get_block_size>
  8032b4:	83 c4 04             	add    $0x4,%esp
  8032b7:	01 d8                	add    %ebx,%eax
  8032b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8032bc:	6a 00                	push   $0x0
  8032be:	ff 75 ec             	pushl  -0x14(%ebp)
  8032c1:	ff 75 08             	pushl  0x8(%ebp)
  8032c4:	e8 ab f4 ff ff       	call   802774 <set_block_data>
  8032c9:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8032cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032d0:	75 17                	jne    8032e9 <merging+0xc8>
  8032d2:	83 ec 04             	sub    $0x4,%esp
  8032d5:	68 83 49 80 00       	push   $0x804983
  8032da:	68 7d 01 00 00       	push   $0x17d
  8032df:	68 a1 49 80 00       	push   $0x8049a1
  8032e4:	e8 35 d0 ff ff       	call   80031e <_panic>
  8032e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ec:	8b 00                	mov    (%eax),%eax
  8032ee:	85 c0                	test   %eax,%eax
  8032f0:	74 10                	je     803302 <merging+0xe1>
  8032f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032f5:	8b 00                	mov    (%eax),%eax
  8032f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032fa:	8b 52 04             	mov    0x4(%edx),%edx
  8032fd:	89 50 04             	mov    %edx,0x4(%eax)
  803300:	eb 0b                	jmp    80330d <merging+0xec>
  803302:	8b 45 0c             	mov    0xc(%ebp),%eax
  803305:	8b 40 04             	mov    0x4(%eax),%eax
  803308:	a3 30 50 80 00       	mov    %eax,0x805030
  80330d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803310:	8b 40 04             	mov    0x4(%eax),%eax
  803313:	85 c0                	test   %eax,%eax
  803315:	74 0f                	je     803326 <merging+0x105>
  803317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80331a:	8b 40 04             	mov    0x4(%eax),%eax
  80331d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803320:	8b 12                	mov    (%edx),%edx
  803322:	89 10                	mov    %edx,(%eax)
  803324:	eb 0a                	jmp    803330 <merging+0x10f>
  803326:	8b 45 0c             	mov    0xc(%ebp),%eax
  803329:	8b 00                	mov    (%eax),%eax
  80332b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803330:	8b 45 0c             	mov    0xc(%ebp),%eax
  803333:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80333c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803343:	a1 38 50 80 00       	mov    0x805038,%eax
  803348:	48                   	dec    %eax
  803349:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80334e:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80334f:	e9 ea 02 00 00       	jmp    80363e <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803354:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803358:	74 3b                	je     803395 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80335a:	83 ec 0c             	sub    $0xc,%esp
  80335d:	ff 75 08             	pushl  0x8(%ebp)
  803360:	e8 be f0 ff ff       	call   802423 <get_block_size>
  803365:	83 c4 10             	add    $0x10,%esp
  803368:	89 c3                	mov    %eax,%ebx
  80336a:	83 ec 0c             	sub    $0xc,%esp
  80336d:	ff 75 10             	pushl  0x10(%ebp)
  803370:	e8 ae f0 ff ff       	call   802423 <get_block_size>
  803375:	83 c4 10             	add    $0x10,%esp
  803378:	01 d8                	add    %ebx,%eax
  80337a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80337d:	83 ec 04             	sub    $0x4,%esp
  803380:	6a 00                	push   $0x0
  803382:	ff 75 e8             	pushl  -0x18(%ebp)
  803385:	ff 75 08             	pushl  0x8(%ebp)
  803388:	e8 e7 f3 ff ff       	call   802774 <set_block_data>
  80338d:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803390:	e9 a9 02 00 00       	jmp    80363e <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803395:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803399:	0f 84 2d 01 00 00    	je     8034cc <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80339f:	83 ec 0c             	sub    $0xc,%esp
  8033a2:	ff 75 10             	pushl  0x10(%ebp)
  8033a5:	e8 79 f0 ff ff       	call   802423 <get_block_size>
  8033aa:	83 c4 10             	add    $0x10,%esp
  8033ad:	89 c3                	mov    %eax,%ebx
  8033af:	83 ec 0c             	sub    $0xc,%esp
  8033b2:	ff 75 0c             	pushl  0xc(%ebp)
  8033b5:	e8 69 f0 ff ff       	call   802423 <get_block_size>
  8033ba:	83 c4 10             	add    $0x10,%esp
  8033bd:	01 d8                	add    %ebx,%eax
  8033bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8033c2:	83 ec 04             	sub    $0x4,%esp
  8033c5:	6a 00                	push   $0x0
  8033c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033ca:	ff 75 10             	pushl  0x10(%ebp)
  8033cd:	e8 a2 f3 ff ff       	call   802774 <set_block_data>
  8033d2:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8033d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8033d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8033db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033df:	74 06                	je     8033e7 <merging+0x1c6>
  8033e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8033e5:	75 17                	jne    8033fe <merging+0x1dd>
  8033e7:	83 ec 04             	sub    $0x4,%esp
  8033ea:	68 48 4a 80 00       	push   $0x804a48
  8033ef:	68 8d 01 00 00       	push   $0x18d
  8033f4:	68 a1 49 80 00       	push   $0x8049a1
  8033f9:	e8 20 cf ff ff       	call   80031e <_panic>
  8033fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803401:	8b 50 04             	mov    0x4(%eax),%edx
  803404:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803407:	89 50 04             	mov    %edx,0x4(%eax)
  80340a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80340d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803410:	89 10                	mov    %edx,(%eax)
  803412:	8b 45 0c             	mov    0xc(%ebp),%eax
  803415:	8b 40 04             	mov    0x4(%eax),%eax
  803418:	85 c0                	test   %eax,%eax
  80341a:	74 0d                	je     803429 <merging+0x208>
  80341c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80341f:	8b 40 04             	mov    0x4(%eax),%eax
  803422:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803425:	89 10                	mov    %edx,(%eax)
  803427:	eb 08                	jmp    803431 <merging+0x210>
  803429:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80342c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803431:	8b 45 0c             	mov    0xc(%ebp),%eax
  803434:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803437:	89 50 04             	mov    %edx,0x4(%eax)
  80343a:	a1 38 50 80 00       	mov    0x805038,%eax
  80343f:	40                   	inc    %eax
  803440:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803445:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803449:	75 17                	jne    803462 <merging+0x241>
  80344b:	83 ec 04             	sub    $0x4,%esp
  80344e:	68 83 49 80 00       	push   $0x804983
  803453:	68 8e 01 00 00       	push   $0x18e
  803458:	68 a1 49 80 00       	push   $0x8049a1
  80345d:	e8 bc ce ff ff       	call   80031e <_panic>
  803462:	8b 45 0c             	mov    0xc(%ebp),%eax
  803465:	8b 00                	mov    (%eax),%eax
  803467:	85 c0                	test   %eax,%eax
  803469:	74 10                	je     80347b <merging+0x25a>
  80346b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80346e:	8b 00                	mov    (%eax),%eax
  803470:	8b 55 0c             	mov    0xc(%ebp),%edx
  803473:	8b 52 04             	mov    0x4(%edx),%edx
  803476:	89 50 04             	mov    %edx,0x4(%eax)
  803479:	eb 0b                	jmp    803486 <merging+0x265>
  80347b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80347e:	8b 40 04             	mov    0x4(%eax),%eax
  803481:	a3 30 50 80 00       	mov    %eax,0x805030
  803486:	8b 45 0c             	mov    0xc(%ebp),%eax
  803489:	8b 40 04             	mov    0x4(%eax),%eax
  80348c:	85 c0                	test   %eax,%eax
  80348e:	74 0f                	je     80349f <merging+0x27e>
  803490:	8b 45 0c             	mov    0xc(%ebp),%eax
  803493:	8b 40 04             	mov    0x4(%eax),%eax
  803496:	8b 55 0c             	mov    0xc(%ebp),%edx
  803499:	8b 12                	mov    (%edx),%edx
  80349b:	89 10                	mov    %edx,(%eax)
  80349d:	eb 0a                	jmp    8034a9 <merging+0x288>
  80349f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a2:	8b 00                	mov    (%eax),%eax
  8034a4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8034c1:	48                   	dec    %eax
  8034c2:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034c7:	e9 72 01 00 00       	jmp    80363e <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8034cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8034cf:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8034d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034d6:	74 79                	je     803551 <merging+0x330>
  8034d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034dc:	74 73                	je     803551 <merging+0x330>
  8034de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034e2:	74 06                	je     8034ea <merging+0x2c9>
  8034e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8034e8:	75 17                	jne    803501 <merging+0x2e0>
  8034ea:	83 ec 04             	sub    $0x4,%esp
  8034ed:	68 14 4a 80 00       	push   $0x804a14
  8034f2:	68 94 01 00 00       	push   $0x194
  8034f7:	68 a1 49 80 00       	push   $0x8049a1
  8034fc:	e8 1d ce ff ff       	call   80031e <_panic>
  803501:	8b 45 08             	mov    0x8(%ebp),%eax
  803504:	8b 10                	mov    (%eax),%edx
  803506:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803509:	89 10                	mov    %edx,(%eax)
  80350b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80350e:	8b 00                	mov    (%eax),%eax
  803510:	85 c0                	test   %eax,%eax
  803512:	74 0b                	je     80351f <merging+0x2fe>
  803514:	8b 45 08             	mov    0x8(%ebp),%eax
  803517:	8b 00                	mov    (%eax),%eax
  803519:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80351c:	89 50 04             	mov    %edx,0x4(%eax)
  80351f:	8b 45 08             	mov    0x8(%ebp),%eax
  803522:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803525:	89 10                	mov    %edx,(%eax)
  803527:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80352a:	8b 55 08             	mov    0x8(%ebp),%edx
  80352d:	89 50 04             	mov    %edx,0x4(%eax)
  803530:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803533:	8b 00                	mov    (%eax),%eax
  803535:	85 c0                	test   %eax,%eax
  803537:	75 08                	jne    803541 <merging+0x320>
  803539:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80353c:	a3 30 50 80 00       	mov    %eax,0x805030
  803541:	a1 38 50 80 00       	mov    0x805038,%eax
  803546:	40                   	inc    %eax
  803547:	a3 38 50 80 00       	mov    %eax,0x805038
  80354c:	e9 ce 00 00 00       	jmp    80361f <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803551:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803555:	74 65                	je     8035bc <merging+0x39b>
  803557:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80355b:	75 17                	jne    803574 <merging+0x353>
  80355d:	83 ec 04             	sub    $0x4,%esp
  803560:	68 f0 49 80 00       	push   $0x8049f0
  803565:	68 95 01 00 00       	push   $0x195
  80356a:	68 a1 49 80 00       	push   $0x8049a1
  80356f:	e8 aa cd ff ff       	call   80031e <_panic>
  803574:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80357a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80357d:	89 50 04             	mov    %edx,0x4(%eax)
  803580:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803583:	8b 40 04             	mov    0x4(%eax),%eax
  803586:	85 c0                	test   %eax,%eax
  803588:	74 0c                	je     803596 <merging+0x375>
  80358a:	a1 30 50 80 00       	mov    0x805030,%eax
  80358f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803592:	89 10                	mov    %edx,(%eax)
  803594:	eb 08                	jmp    80359e <merging+0x37d>
  803596:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803599:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80359e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8035a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035af:	a1 38 50 80 00       	mov    0x805038,%eax
  8035b4:	40                   	inc    %eax
  8035b5:	a3 38 50 80 00       	mov    %eax,0x805038
  8035ba:	eb 63                	jmp    80361f <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8035bc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035c0:	75 17                	jne    8035d9 <merging+0x3b8>
  8035c2:	83 ec 04             	sub    $0x4,%esp
  8035c5:	68 bc 49 80 00       	push   $0x8049bc
  8035ca:	68 98 01 00 00       	push   $0x198
  8035cf:	68 a1 49 80 00       	push   $0x8049a1
  8035d4:	e8 45 cd ff ff       	call   80031e <_panic>
  8035d9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8035df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035e2:	89 10                	mov    %edx,(%eax)
  8035e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035e7:	8b 00                	mov    (%eax),%eax
  8035e9:	85 c0                	test   %eax,%eax
  8035eb:	74 0d                	je     8035fa <merging+0x3d9>
  8035ed:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035f5:	89 50 04             	mov    %edx,0x4(%eax)
  8035f8:	eb 08                	jmp    803602 <merging+0x3e1>
  8035fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035fd:	a3 30 50 80 00       	mov    %eax,0x805030
  803602:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803605:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80360a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80360d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803614:	a1 38 50 80 00       	mov    0x805038,%eax
  803619:	40                   	inc    %eax
  80361a:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80361f:	83 ec 0c             	sub    $0xc,%esp
  803622:	ff 75 10             	pushl  0x10(%ebp)
  803625:	e8 f9 ed ff ff       	call   802423 <get_block_size>
  80362a:	83 c4 10             	add    $0x10,%esp
  80362d:	83 ec 04             	sub    $0x4,%esp
  803630:	6a 00                	push   $0x0
  803632:	50                   	push   %eax
  803633:	ff 75 10             	pushl  0x10(%ebp)
  803636:	e8 39 f1 ff ff       	call   802774 <set_block_data>
  80363b:	83 c4 10             	add    $0x10,%esp
	}
}
  80363e:	90                   	nop
  80363f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803642:	c9                   	leave  
  803643:	c3                   	ret    

00803644 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803644:	55                   	push   %ebp
  803645:	89 e5                	mov    %esp,%ebp
  803647:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80364a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80364f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803652:	a1 30 50 80 00       	mov    0x805030,%eax
  803657:	3b 45 08             	cmp    0x8(%ebp),%eax
  80365a:	73 1b                	jae    803677 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80365c:	a1 30 50 80 00       	mov    0x805030,%eax
  803661:	83 ec 04             	sub    $0x4,%esp
  803664:	ff 75 08             	pushl  0x8(%ebp)
  803667:	6a 00                	push   $0x0
  803669:	50                   	push   %eax
  80366a:	e8 b2 fb ff ff       	call   803221 <merging>
  80366f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803672:	e9 8b 00 00 00       	jmp    803702 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803677:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80367c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80367f:	76 18                	jbe    803699 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803681:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803686:	83 ec 04             	sub    $0x4,%esp
  803689:	ff 75 08             	pushl  0x8(%ebp)
  80368c:	50                   	push   %eax
  80368d:	6a 00                	push   $0x0
  80368f:	e8 8d fb ff ff       	call   803221 <merging>
  803694:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803697:	eb 69                	jmp    803702 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803699:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80369e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036a1:	eb 39                	jmp    8036dc <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8036a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036a9:	73 29                	jae    8036d4 <free_block+0x90>
  8036ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ae:	8b 00                	mov    (%eax),%eax
  8036b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036b3:	76 1f                	jbe    8036d4 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8036b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b8:	8b 00                	mov    (%eax),%eax
  8036ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8036bd:	83 ec 04             	sub    $0x4,%esp
  8036c0:	ff 75 08             	pushl  0x8(%ebp)
  8036c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8036c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8036c9:	e8 53 fb ff ff       	call   803221 <merging>
  8036ce:	83 c4 10             	add    $0x10,%esp
			break;
  8036d1:	90                   	nop
		}
	}
}
  8036d2:	eb 2e                	jmp    803702 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8036d4:	a1 34 50 80 00       	mov    0x805034,%eax
  8036d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e0:	74 07                	je     8036e9 <free_block+0xa5>
  8036e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e5:	8b 00                	mov    (%eax),%eax
  8036e7:	eb 05                	jmp    8036ee <free_block+0xaa>
  8036e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ee:	a3 34 50 80 00       	mov    %eax,0x805034
  8036f3:	a1 34 50 80 00       	mov    0x805034,%eax
  8036f8:	85 c0                	test   %eax,%eax
  8036fa:	75 a7                	jne    8036a3 <free_block+0x5f>
  8036fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803700:	75 a1                	jne    8036a3 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803702:	90                   	nop
  803703:	c9                   	leave  
  803704:	c3                   	ret    

00803705 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803705:	55                   	push   %ebp
  803706:	89 e5                	mov    %esp,%ebp
  803708:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80370b:	ff 75 08             	pushl  0x8(%ebp)
  80370e:	e8 10 ed ff ff       	call   802423 <get_block_size>
  803713:	83 c4 04             	add    $0x4,%esp
  803716:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803719:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803720:	eb 17                	jmp    803739 <copy_data+0x34>
  803722:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803725:	8b 45 0c             	mov    0xc(%ebp),%eax
  803728:	01 c2                	add    %eax,%edx
  80372a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80372d:	8b 45 08             	mov    0x8(%ebp),%eax
  803730:	01 c8                	add    %ecx,%eax
  803732:	8a 00                	mov    (%eax),%al
  803734:	88 02                	mov    %al,(%edx)
  803736:	ff 45 fc             	incl   -0x4(%ebp)
  803739:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80373c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80373f:	72 e1                	jb     803722 <copy_data+0x1d>
}
  803741:	90                   	nop
  803742:	c9                   	leave  
  803743:	c3                   	ret    

00803744 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803744:	55                   	push   %ebp
  803745:	89 e5                	mov    %esp,%ebp
  803747:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80374a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80374e:	75 23                	jne    803773 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803750:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803754:	74 13                	je     803769 <realloc_block_FF+0x25>
  803756:	83 ec 0c             	sub    $0xc,%esp
  803759:	ff 75 0c             	pushl  0xc(%ebp)
  80375c:	e8 42 f0 ff ff       	call   8027a3 <alloc_block_FF>
  803761:	83 c4 10             	add    $0x10,%esp
  803764:	e9 e4 06 00 00       	jmp    803e4d <realloc_block_FF+0x709>
		return NULL;
  803769:	b8 00 00 00 00       	mov    $0x0,%eax
  80376e:	e9 da 06 00 00       	jmp    803e4d <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803773:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803777:	75 18                	jne    803791 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803779:	83 ec 0c             	sub    $0xc,%esp
  80377c:	ff 75 08             	pushl  0x8(%ebp)
  80377f:	e8 c0 fe ff ff       	call   803644 <free_block>
  803784:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803787:	b8 00 00 00 00       	mov    $0x0,%eax
  80378c:	e9 bc 06 00 00       	jmp    803e4d <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803791:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803795:	77 07                	ja     80379e <realloc_block_FF+0x5a>
  803797:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80379e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037a1:	83 e0 01             	and    $0x1,%eax
  8037a4:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8037a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037aa:	83 c0 08             	add    $0x8,%eax
  8037ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8037b0:	83 ec 0c             	sub    $0xc,%esp
  8037b3:	ff 75 08             	pushl  0x8(%ebp)
  8037b6:	e8 68 ec ff ff       	call   802423 <get_block_size>
  8037bb:	83 c4 10             	add    $0x10,%esp
  8037be:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8037c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037c4:	83 e8 08             	sub    $0x8,%eax
  8037c7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8037ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cd:	83 e8 04             	sub    $0x4,%eax
  8037d0:	8b 00                	mov    (%eax),%eax
  8037d2:	83 e0 fe             	and    $0xfffffffe,%eax
  8037d5:	89 c2                	mov    %eax,%edx
  8037d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037da:	01 d0                	add    %edx,%eax
  8037dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8037df:	83 ec 0c             	sub    $0xc,%esp
  8037e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037e5:	e8 39 ec ff ff       	call   802423 <get_block_size>
  8037ea:	83 c4 10             	add    $0x10,%esp
  8037ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8037f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037f3:	83 e8 08             	sub    $0x8,%eax
  8037f6:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8037f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037fc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037ff:	75 08                	jne    803809 <realloc_block_FF+0xc5>
	{
		 return va;
  803801:	8b 45 08             	mov    0x8(%ebp),%eax
  803804:	e9 44 06 00 00       	jmp    803e4d <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803809:	8b 45 0c             	mov    0xc(%ebp),%eax
  80380c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80380f:	0f 83 d5 03 00 00    	jae    803bea <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803815:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803818:	2b 45 0c             	sub    0xc(%ebp),%eax
  80381b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80381e:	83 ec 0c             	sub    $0xc,%esp
  803821:	ff 75 e4             	pushl  -0x1c(%ebp)
  803824:	e8 13 ec ff ff       	call   80243c <is_free_block>
  803829:	83 c4 10             	add    $0x10,%esp
  80382c:	84 c0                	test   %al,%al
  80382e:	0f 84 3b 01 00 00    	je     80396f <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803834:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803837:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80383a:	01 d0                	add    %edx,%eax
  80383c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80383f:	83 ec 04             	sub    $0x4,%esp
  803842:	6a 01                	push   $0x1
  803844:	ff 75 f0             	pushl  -0x10(%ebp)
  803847:	ff 75 08             	pushl  0x8(%ebp)
  80384a:	e8 25 ef ff ff       	call   802774 <set_block_data>
  80384f:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803852:	8b 45 08             	mov    0x8(%ebp),%eax
  803855:	83 e8 04             	sub    $0x4,%eax
  803858:	8b 00                	mov    (%eax),%eax
  80385a:	83 e0 fe             	and    $0xfffffffe,%eax
  80385d:	89 c2                	mov    %eax,%edx
  80385f:	8b 45 08             	mov    0x8(%ebp),%eax
  803862:	01 d0                	add    %edx,%eax
  803864:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803867:	83 ec 04             	sub    $0x4,%esp
  80386a:	6a 00                	push   $0x0
  80386c:	ff 75 cc             	pushl  -0x34(%ebp)
  80386f:	ff 75 c8             	pushl  -0x38(%ebp)
  803872:	e8 fd ee ff ff       	call   802774 <set_block_data>
  803877:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80387a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80387e:	74 06                	je     803886 <realloc_block_FF+0x142>
  803880:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803884:	75 17                	jne    80389d <realloc_block_FF+0x159>
  803886:	83 ec 04             	sub    $0x4,%esp
  803889:	68 14 4a 80 00       	push   $0x804a14
  80388e:	68 f6 01 00 00       	push   $0x1f6
  803893:	68 a1 49 80 00       	push   $0x8049a1
  803898:	e8 81 ca ff ff       	call   80031e <_panic>
  80389d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a0:	8b 10                	mov    (%eax),%edx
  8038a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038a5:	89 10                	mov    %edx,(%eax)
  8038a7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038aa:	8b 00                	mov    (%eax),%eax
  8038ac:	85 c0                	test   %eax,%eax
  8038ae:	74 0b                	je     8038bb <realloc_block_FF+0x177>
  8038b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b3:	8b 00                	mov    (%eax),%eax
  8038b5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8038b8:	89 50 04             	mov    %edx,0x4(%eax)
  8038bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038be:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8038c1:	89 10                	mov    %edx,(%eax)
  8038c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038c9:	89 50 04             	mov    %edx,0x4(%eax)
  8038cc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038cf:	8b 00                	mov    (%eax),%eax
  8038d1:	85 c0                	test   %eax,%eax
  8038d3:	75 08                	jne    8038dd <realloc_block_FF+0x199>
  8038d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8038dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8038e2:	40                   	inc    %eax
  8038e3:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038ec:	75 17                	jne    803905 <realloc_block_FF+0x1c1>
  8038ee:	83 ec 04             	sub    $0x4,%esp
  8038f1:	68 83 49 80 00       	push   $0x804983
  8038f6:	68 f7 01 00 00       	push   $0x1f7
  8038fb:	68 a1 49 80 00       	push   $0x8049a1
  803900:	e8 19 ca ff ff       	call   80031e <_panic>
  803905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803908:	8b 00                	mov    (%eax),%eax
  80390a:	85 c0                	test   %eax,%eax
  80390c:	74 10                	je     80391e <realloc_block_FF+0x1da>
  80390e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803911:	8b 00                	mov    (%eax),%eax
  803913:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803916:	8b 52 04             	mov    0x4(%edx),%edx
  803919:	89 50 04             	mov    %edx,0x4(%eax)
  80391c:	eb 0b                	jmp    803929 <realloc_block_FF+0x1e5>
  80391e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803921:	8b 40 04             	mov    0x4(%eax),%eax
  803924:	a3 30 50 80 00       	mov    %eax,0x805030
  803929:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392c:	8b 40 04             	mov    0x4(%eax),%eax
  80392f:	85 c0                	test   %eax,%eax
  803931:	74 0f                	je     803942 <realloc_block_FF+0x1fe>
  803933:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803936:	8b 40 04             	mov    0x4(%eax),%eax
  803939:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80393c:	8b 12                	mov    (%edx),%edx
  80393e:	89 10                	mov    %edx,(%eax)
  803940:	eb 0a                	jmp    80394c <realloc_block_FF+0x208>
  803942:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803945:	8b 00                	mov    (%eax),%eax
  803947:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80394c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803955:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803958:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80395f:	a1 38 50 80 00       	mov    0x805038,%eax
  803964:	48                   	dec    %eax
  803965:	a3 38 50 80 00       	mov    %eax,0x805038
  80396a:	e9 73 02 00 00       	jmp    803be2 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  80396f:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803973:	0f 86 69 02 00 00    	jbe    803be2 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803979:	83 ec 04             	sub    $0x4,%esp
  80397c:	6a 01                	push   $0x1
  80397e:	ff 75 f0             	pushl  -0x10(%ebp)
  803981:	ff 75 08             	pushl  0x8(%ebp)
  803984:	e8 eb ed ff ff       	call   802774 <set_block_data>
  803989:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80398c:	8b 45 08             	mov    0x8(%ebp),%eax
  80398f:	83 e8 04             	sub    $0x4,%eax
  803992:	8b 00                	mov    (%eax),%eax
  803994:	83 e0 fe             	and    $0xfffffffe,%eax
  803997:	89 c2                	mov    %eax,%edx
  803999:	8b 45 08             	mov    0x8(%ebp),%eax
  80399c:	01 d0                	add    %edx,%eax
  80399e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8039a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8039a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8039a9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8039ad:	75 68                	jne    803a17 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8039af:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039b3:	75 17                	jne    8039cc <realloc_block_FF+0x288>
  8039b5:	83 ec 04             	sub    $0x4,%esp
  8039b8:	68 bc 49 80 00       	push   $0x8049bc
  8039bd:	68 06 02 00 00       	push   $0x206
  8039c2:	68 a1 49 80 00       	push   $0x8049a1
  8039c7:	e8 52 c9 ff ff       	call   80031e <_panic>
  8039cc:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8039d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039d5:	89 10                	mov    %edx,(%eax)
  8039d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039da:	8b 00                	mov    (%eax),%eax
  8039dc:	85 c0                	test   %eax,%eax
  8039de:	74 0d                	je     8039ed <realloc_block_FF+0x2a9>
  8039e0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8039e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039e8:	89 50 04             	mov    %edx,0x4(%eax)
  8039eb:	eb 08                	jmp    8039f5 <realloc_block_FF+0x2b1>
  8039ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039f0:	a3 30 50 80 00       	mov    %eax,0x805030
  8039f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039f8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a07:	a1 38 50 80 00       	mov    0x805038,%eax
  803a0c:	40                   	inc    %eax
  803a0d:	a3 38 50 80 00       	mov    %eax,0x805038
  803a12:	e9 b0 01 00 00       	jmp    803bc7 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803a17:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a1c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a1f:	76 68                	jbe    803a89 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a21:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a25:	75 17                	jne    803a3e <realloc_block_FF+0x2fa>
  803a27:	83 ec 04             	sub    $0x4,%esp
  803a2a:	68 bc 49 80 00       	push   $0x8049bc
  803a2f:	68 0b 02 00 00       	push   $0x20b
  803a34:	68 a1 49 80 00       	push   $0x8049a1
  803a39:	e8 e0 c8 ff ff       	call   80031e <_panic>
  803a3e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803a44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a47:	89 10                	mov    %edx,(%eax)
  803a49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a4c:	8b 00                	mov    (%eax),%eax
  803a4e:	85 c0                	test   %eax,%eax
  803a50:	74 0d                	je     803a5f <realloc_block_FF+0x31b>
  803a52:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a57:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a5a:	89 50 04             	mov    %edx,0x4(%eax)
  803a5d:	eb 08                	jmp    803a67 <realloc_block_FF+0x323>
  803a5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a62:	a3 30 50 80 00       	mov    %eax,0x805030
  803a67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a6a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a79:	a1 38 50 80 00       	mov    0x805038,%eax
  803a7e:	40                   	inc    %eax
  803a7f:	a3 38 50 80 00       	mov    %eax,0x805038
  803a84:	e9 3e 01 00 00       	jmp    803bc7 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803a89:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803a8e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a91:	73 68                	jae    803afb <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a93:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a97:	75 17                	jne    803ab0 <realloc_block_FF+0x36c>
  803a99:	83 ec 04             	sub    $0x4,%esp
  803a9c:	68 f0 49 80 00       	push   $0x8049f0
  803aa1:	68 10 02 00 00       	push   $0x210
  803aa6:	68 a1 49 80 00       	push   $0x8049a1
  803aab:	e8 6e c8 ff ff       	call   80031e <_panic>
  803ab0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803ab6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ab9:	89 50 04             	mov    %edx,0x4(%eax)
  803abc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803abf:	8b 40 04             	mov    0x4(%eax),%eax
  803ac2:	85 c0                	test   %eax,%eax
  803ac4:	74 0c                	je     803ad2 <realloc_block_FF+0x38e>
  803ac6:	a1 30 50 80 00       	mov    0x805030,%eax
  803acb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ace:	89 10                	mov    %edx,(%eax)
  803ad0:	eb 08                	jmp    803ada <realloc_block_FF+0x396>
  803ad2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ad5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ada:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803add:	a3 30 50 80 00       	mov    %eax,0x805030
  803ae2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aeb:	a1 38 50 80 00       	mov    0x805038,%eax
  803af0:	40                   	inc    %eax
  803af1:	a3 38 50 80 00       	mov    %eax,0x805038
  803af6:	e9 cc 00 00 00       	jmp    803bc7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803afb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803b02:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803b07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b0a:	e9 8a 00 00 00       	jmp    803b99 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b12:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b15:	73 7a                	jae    803b91 <realloc_block_FF+0x44d>
  803b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1a:	8b 00                	mov    (%eax),%eax
  803b1c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b1f:	73 70                	jae    803b91 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803b21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b25:	74 06                	je     803b2d <realloc_block_FF+0x3e9>
  803b27:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b2b:	75 17                	jne    803b44 <realloc_block_FF+0x400>
  803b2d:	83 ec 04             	sub    $0x4,%esp
  803b30:	68 14 4a 80 00       	push   $0x804a14
  803b35:	68 1a 02 00 00       	push   $0x21a
  803b3a:	68 a1 49 80 00       	push   $0x8049a1
  803b3f:	e8 da c7 ff ff       	call   80031e <_panic>
  803b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b47:	8b 10                	mov    (%eax),%edx
  803b49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b4c:	89 10                	mov    %edx,(%eax)
  803b4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b51:	8b 00                	mov    (%eax),%eax
  803b53:	85 c0                	test   %eax,%eax
  803b55:	74 0b                	je     803b62 <realloc_block_FF+0x41e>
  803b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5a:	8b 00                	mov    (%eax),%eax
  803b5c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b5f:	89 50 04             	mov    %edx,0x4(%eax)
  803b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b65:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b68:	89 10                	mov    %edx,(%eax)
  803b6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b70:	89 50 04             	mov    %edx,0x4(%eax)
  803b73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b76:	8b 00                	mov    (%eax),%eax
  803b78:	85 c0                	test   %eax,%eax
  803b7a:	75 08                	jne    803b84 <realloc_block_FF+0x440>
  803b7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b7f:	a3 30 50 80 00       	mov    %eax,0x805030
  803b84:	a1 38 50 80 00       	mov    0x805038,%eax
  803b89:	40                   	inc    %eax
  803b8a:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803b8f:	eb 36                	jmp    803bc7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803b91:	a1 34 50 80 00       	mov    0x805034,%eax
  803b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b9d:	74 07                	je     803ba6 <realloc_block_FF+0x462>
  803b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba2:	8b 00                	mov    (%eax),%eax
  803ba4:	eb 05                	jmp    803bab <realloc_block_FF+0x467>
  803ba6:	b8 00 00 00 00       	mov    $0x0,%eax
  803bab:	a3 34 50 80 00       	mov    %eax,0x805034
  803bb0:	a1 34 50 80 00       	mov    0x805034,%eax
  803bb5:	85 c0                	test   %eax,%eax
  803bb7:	0f 85 52 ff ff ff    	jne    803b0f <realloc_block_FF+0x3cb>
  803bbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bc1:	0f 85 48 ff ff ff    	jne    803b0f <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803bc7:	83 ec 04             	sub    $0x4,%esp
  803bca:	6a 00                	push   $0x0
  803bcc:	ff 75 d8             	pushl  -0x28(%ebp)
  803bcf:	ff 75 d4             	pushl  -0x2c(%ebp)
  803bd2:	e8 9d eb ff ff       	call   802774 <set_block_data>
  803bd7:	83 c4 10             	add    $0x10,%esp
				return va;
  803bda:	8b 45 08             	mov    0x8(%ebp),%eax
  803bdd:	e9 6b 02 00 00       	jmp    803e4d <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803be2:	8b 45 08             	mov    0x8(%ebp),%eax
  803be5:	e9 63 02 00 00       	jmp    803e4d <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803bea:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bed:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bf0:	0f 86 4d 02 00 00    	jbe    803e43 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803bf6:	83 ec 0c             	sub    $0xc,%esp
  803bf9:	ff 75 e4             	pushl  -0x1c(%ebp)
  803bfc:	e8 3b e8 ff ff       	call   80243c <is_free_block>
  803c01:	83 c4 10             	add    $0x10,%esp
  803c04:	84 c0                	test   %al,%al
  803c06:	0f 84 37 02 00 00    	je     803e43 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c0f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803c12:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803c15:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803c18:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803c1b:	76 38                	jbe    803c55 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803c1d:	83 ec 0c             	sub    $0xc,%esp
  803c20:	ff 75 0c             	pushl  0xc(%ebp)
  803c23:	e8 7b eb ff ff       	call   8027a3 <alloc_block_FF>
  803c28:	83 c4 10             	add    $0x10,%esp
  803c2b:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803c2e:	83 ec 08             	sub    $0x8,%esp
  803c31:	ff 75 c0             	pushl  -0x40(%ebp)
  803c34:	ff 75 08             	pushl  0x8(%ebp)
  803c37:	e8 c9 fa ff ff       	call   803705 <copy_data>
  803c3c:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803c3f:	83 ec 0c             	sub    $0xc,%esp
  803c42:	ff 75 08             	pushl  0x8(%ebp)
  803c45:	e8 fa f9 ff ff       	call   803644 <free_block>
  803c4a:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803c4d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803c50:	e9 f8 01 00 00       	jmp    803e4d <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803c55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c58:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803c5b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803c5e:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803c62:	0f 87 a0 00 00 00    	ja     803d08 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803c68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c6c:	75 17                	jne    803c85 <realloc_block_FF+0x541>
  803c6e:	83 ec 04             	sub    $0x4,%esp
  803c71:	68 83 49 80 00       	push   $0x804983
  803c76:	68 38 02 00 00       	push   $0x238
  803c7b:	68 a1 49 80 00       	push   $0x8049a1
  803c80:	e8 99 c6 ff ff       	call   80031e <_panic>
  803c85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c88:	8b 00                	mov    (%eax),%eax
  803c8a:	85 c0                	test   %eax,%eax
  803c8c:	74 10                	je     803c9e <realloc_block_FF+0x55a>
  803c8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c91:	8b 00                	mov    (%eax),%eax
  803c93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c96:	8b 52 04             	mov    0x4(%edx),%edx
  803c99:	89 50 04             	mov    %edx,0x4(%eax)
  803c9c:	eb 0b                	jmp    803ca9 <realloc_block_FF+0x565>
  803c9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca1:	8b 40 04             	mov    0x4(%eax),%eax
  803ca4:	a3 30 50 80 00       	mov    %eax,0x805030
  803ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cac:	8b 40 04             	mov    0x4(%eax),%eax
  803caf:	85 c0                	test   %eax,%eax
  803cb1:	74 0f                	je     803cc2 <realloc_block_FF+0x57e>
  803cb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cb6:	8b 40 04             	mov    0x4(%eax),%eax
  803cb9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cbc:	8b 12                	mov    (%edx),%edx
  803cbe:	89 10                	mov    %edx,(%eax)
  803cc0:	eb 0a                	jmp    803ccc <realloc_block_FF+0x588>
  803cc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc5:	8b 00                	mov    (%eax),%eax
  803cc7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ccc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ccf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cdf:	a1 38 50 80 00       	mov    0x805038,%eax
  803ce4:	48                   	dec    %eax
  803ce5:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803cea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ced:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cf0:	01 d0                	add    %edx,%eax
  803cf2:	83 ec 04             	sub    $0x4,%esp
  803cf5:	6a 01                	push   $0x1
  803cf7:	50                   	push   %eax
  803cf8:	ff 75 08             	pushl  0x8(%ebp)
  803cfb:	e8 74 ea ff ff       	call   802774 <set_block_data>
  803d00:	83 c4 10             	add    $0x10,%esp
  803d03:	e9 36 01 00 00       	jmp    803e3e <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803d08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d0b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d0e:	01 d0                	add    %edx,%eax
  803d10:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803d13:	83 ec 04             	sub    $0x4,%esp
  803d16:	6a 01                	push   $0x1
  803d18:	ff 75 f0             	pushl  -0x10(%ebp)
  803d1b:	ff 75 08             	pushl  0x8(%ebp)
  803d1e:	e8 51 ea ff ff       	call   802774 <set_block_data>
  803d23:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803d26:	8b 45 08             	mov    0x8(%ebp),%eax
  803d29:	83 e8 04             	sub    $0x4,%eax
  803d2c:	8b 00                	mov    (%eax),%eax
  803d2e:	83 e0 fe             	and    $0xfffffffe,%eax
  803d31:	89 c2                	mov    %eax,%edx
  803d33:	8b 45 08             	mov    0x8(%ebp),%eax
  803d36:	01 d0                	add    %edx,%eax
  803d38:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803d3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d3f:	74 06                	je     803d47 <realloc_block_FF+0x603>
  803d41:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803d45:	75 17                	jne    803d5e <realloc_block_FF+0x61a>
  803d47:	83 ec 04             	sub    $0x4,%esp
  803d4a:	68 14 4a 80 00       	push   $0x804a14
  803d4f:	68 44 02 00 00       	push   $0x244
  803d54:	68 a1 49 80 00       	push   $0x8049a1
  803d59:	e8 c0 c5 ff ff       	call   80031e <_panic>
  803d5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d61:	8b 10                	mov    (%eax),%edx
  803d63:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d66:	89 10                	mov    %edx,(%eax)
  803d68:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d6b:	8b 00                	mov    (%eax),%eax
  803d6d:	85 c0                	test   %eax,%eax
  803d6f:	74 0b                	je     803d7c <realloc_block_FF+0x638>
  803d71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d74:	8b 00                	mov    (%eax),%eax
  803d76:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803d79:	89 50 04             	mov    %edx,0x4(%eax)
  803d7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d7f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803d82:	89 10                	mov    %edx,(%eax)
  803d84:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d8a:	89 50 04             	mov    %edx,0x4(%eax)
  803d8d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d90:	8b 00                	mov    (%eax),%eax
  803d92:	85 c0                	test   %eax,%eax
  803d94:	75 08                	jne    803d9e <realloc_block_FF+0x65a>
  803d96:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803d99:	a3 30 50 80 00       	mov    %eax,0x805030
  803d9e:	a1 38 50 80 00       	mov    0x805038,%eax
  803da3:	40                   	inc    %eax
  803da4:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803da9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803dad:	75 17                	jne    803dc6 <realloc_block_FF+0x682>
  803daf:	83 ec 04             	sub    $0x4,%esp
  803db2:	68 83 49 80 00       	push   $0x804983
  803db7:	68 45 02 00 00       	push   $0x245
  803dbc:	68 a1 49 80 00       	push   $0x8049a1
  803dc1:	e8 58 c5 ff ff       	call   80031e <_panic>
  803dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc9:	8b 00                	mov    (%eax),%eax
  803dcb:	85 c0                	test   %eax,%eax
  803dcd:	74 10                	je     803ddf <realloc_block_FF+0x69b>
  803dcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd2:	8b 00                	mov    (%eax),%eax
  803dd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dd7:	8b 52 04             	mov    0x4(%edx),%edx
  803dda:	89 50 04             	mov    %edx,0x4(%eax)
  803ddd:	eb 0b                	jmp    803dea <realloc_block_FF+0x6a6>
  803ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de2:	8b 40 04             	mov    0x4(%eax),%eax
  803de5:	a3 30 50 80 00       	mov    %eax,0x805030
  803dea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ded:	8b 40 04             	mov    0x4(%eax),%eax
  803df0:	85 c0                	test   %eax,%eax
  803df2:	74 0f                	je     803e03 <realloc_block_FF+0x6bf>
  803df4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df7:	8b 40 04             	mov    0x4(%eax),%eax
  803dfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dfd:	8b 12                	mov    (%edx),%edx
  803dff:	89 10                	mov    %edx,(%eax)
  803e01:	eb 0a                	jmp    803e0d <realloc_block_FF+0x6c9>
  803e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e06:	8b 00                	mov    (%eax),%eax
  803e08:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803e0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e20:	a1 38 50 80 00       	mov    0x805038,%eax
  803e25:	48                   	dec    %eax
  803e26:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803e2b:	83 ec 04             	sub    $0x4,%esp
  803e2e:	6a 00                	push   $0x0
  803e30:	ff 75 bc             	pushl  -0x44(%ebp)
  803e33:	ff 75 b8             	pushl  -0x48(%ebp)
  803e36:	e8 39 e9 ff ff       	call   802774 <set_block_data>
  803e3b:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  803e41:	eb 0a                	jmp    803e4d <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803e43:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803e4a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803e4d:	c9                   	leave  
  803e4e:	c3                   	ret    

00803e4f <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803e4f:	55                   	push   %ebp
  803e50:	89 e5                	mov    %esp,%ebp
  803e52:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803e55:	83 ec 04             	sub    $0x4,%esp
  803e58:	68 80 4a 80 00       	push   $0x804a80
  803e5d:	68 58 02 00 00       	push   $0x258
  803e62:	68 a1 49 80 00       	push   $0x8049a1
  803e67:	e8 b2 c4 ff ff       	call   80031e <_panic>

00803e6c <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803e6c:	55                   	push   %ebp
  803e6d:	89 e5                	mov    %esp,%ebp
  803e6f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803e72:	83 ec 04             	sub    $0x4,%esp
  803e75:	68 a8 4a 80 00       	push   $0x804aa8
  803e7a:	68 61 02 00 00       	push   $0x261
  803e7f:	68 a1 49 80 00       	push   $0x8049a1
  803e84:	e8 95 c4 ff ff       	call   80031e <_panic>
  803e89:	66 90                	xchg   %ax,%ax
  803e8b:	90                   	nop

00803e8c <__udivdi3>:
  803e8c:	55                   	push   %ebp
  803e8d:	57                   	push   %edi
  803e8e:	56                   	push   %esi
  803e8f:	53                   	push   %ebx
  803e90:	83 ec 1c             	sub    $0x1c,%esp
  803e93:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e97:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e9f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ea3:	89 ca                	mov    %ecx,%edx
  803ea5:	89 f8                	mov    %edi,%eax
  803ea7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803eab:	85 f6                	test   %esi,%esi
  803ead:	75 2d                	jne    803edc <__udivdi3+0x50>
  803eaf:	39 cf                	cmp    %ecx,%edi
  803eb1:	77 65                	ja     803f18 <__udivdi3+0x8c>
  803eb3:	89 fd                	mov    %edi,%ebp
  803eb5:	85 ff                	test   %edi,%edi
  803eb7:	75 0b                	jne    803ec4 <__udivdi3+0x38>
  803eb9:	b8 01 00 00 00       	mov    $0x1,%eax
  803ebe:	31 d2                	xor    %edx,%edx
  803ec0:	f7 f7                	div    %edi
  803ec2:	89 c5                	mov    %eax,%ebp
  803ec4:	31 d2                	xor    %edx,%edx
  803ec6:	89 c8                	mov    %ecx,%eax
  803ec8:	f7 f5                	div    %ebp
  803eca:	89 c1                	mov    %eax,%ecx
  803ecc:	89 d8                	mov    %ebx,%eax
  803ece:	f7 f5                	div    %ebp
  803ed0:	89 cf                	mov    %ecx,%edi
  803ed2:	89 fa                	mov    %edi,%edx
  803ed4:	83 c4 1c             	add    $0x1c,%esp
  803ed7:	5b                   	pop    %ebx
  803ed8:	5e                   	pop    %esi
  803ed9:	5f                   	pop    %edi
  803eda:	5d                   	pop    %ebp
  803edb:	c3                   	ret    
  803edc:	39 ce                	cmp    %ecx,%esi
  803ede:	77 28                	ja     803f08 <__udivdi3+0x7c>
  803ee0:	0f bd fe             	bsr    %esi,%edi
  803ee3:	83 f7 1f             	xor    $0x1f,%edi
  803ee6:	75 40                	jne    803f28 <__udivdi3+0x9c>
  803ee8:	39 ce                	cmp    %ecx,%esi
  803eea:	72 0a                	jb     803ef6 <__udivdi3+0x6a>
  803eec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ef0:	0f 87 9e 00 00 00    	ja     803f94 <__udivdi3+0x108>
  803ef6:	b8 01 00 00 00       	mov    $0x1,%eax
  803efb:	89 fa                	mov    %edi,%edx
  803efd:	83 c4 1c             	add    $0x1c,%esp
  803f00:	5b                   	pop    %ebx
  803f01:	5e                   	pop    %esi
  803f02:	5f                   	pop    %edi
  803f03:	5d                   	pop    %ebp
  803f04:	c3                   	ret    
  803f05:	8d 76 00             	lea    0x0(%esi),%esi
  803f08:	31 ff                	xor    %edi,%edi
  803f0a:	31 c0                	xor    %eax,%eax
  803f0c:	89 fa                	mov    %edi,%edx
  803f0e:	83 c4 1c             	add    $0x1c,%esp
  803f11:	5b                   	pop    %ebx
  803f12:	5e                   	pop    %esi
  803f13:	5f                   	pop    %edi
  803f14:	5d                   	pop    %ebp
  803f15:	c3                   	ret    
  803f16:	66 90                	xchg   %ax,%ax
  803f18:	89 d8                	mov    %ebx,%eax
  803f1a:	f7 f7                	div    %edi
  803f1c:	31 ff                	xor    %edi,%edi
  803f1e:	89 fa                	mov    %edi,%edx
  803f20:	83 c4 1c             	add    $0x1c,%esp
  803f23:	5b                   	pop    %ebx
  803f24:	5e                   	pop    %esi
  803f25:	5f                   	pop    %edi
  803f26:	5d                   	pop    %ebp
  803f27:	c3                   	ret    
  803f28:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f2d:	89 eb                	mov    %ebp,%ebx
  803f2f:	29 fb                	sub    %edi,%ebx
  803f31:	89 f9                	mov    %edi,%ecx
  803f33:	d3 e6                	shl    %cl,%esi
  803f35:	89 c5                	mov    %eax,%ebp
  803f37:	88 d9                	mov    %bl,%cl
  803f39:	d3 ed                	shr    %cl,%ebp
  803f3b:	89 e9                	mov    %ebp,%ecx
  803f3d:	09 f1                	or     %esi,%ecx
  803f3f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f43:	89 f9                	mov    %edi,%ecx
  803f45:	d3 e0                	shl    %cl,%eax
  803f47:	89 c5                	mov    %eax,%ebp
  803f49:	89 d6                	mov    %edx,%esi
  803f4b:	88 d9                	mov    %bl,%cl
  803f4d:	d3 ee                	shr    %cl,%esi
  803f4f:	89 f9                	mov    %edi,%ecx
  803f51:	d3 e2                	shl    %cl,%edx
  803f53:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f57:	88 d9                	mov    %bl,%cl
  803f59:	d3 e8                	shr    %cl,%eax
  803f5b:	09 c2                	or     %eax,%edx
  803f5d:	89 d0                	mov    %edx,%eax
  803f5f:	89 f2                	mov    %esi,%edx
  803f61:	f7 74 24 0c          	divl   0xc(%esp)
  803f65:	89 d6                	mov    %edx,%esi
  803f67:	89 c3                	mov    %eax,%ebx
  803f69:	f7 e5                	mul    %ebp
  803f6b:	39 d6                	cmp    %edx,%esi
  803f6d:	72 19                	jb     803f88 <__udivdi3+0xfc>
  803f6f:	74 0b                	je     803f7c <__udivdi3+0xf0>
  803f71:	89 d8                	mov    %ebx,%eax
  803f73:	31 ff                	xor    %edi,%edi
  803f75:	e9 58 ff ff ff       	jmp    803ed2 <__udivdi3+0x46>
  803f7a:	66 90                	xchg   %ax,%ax
  803f7c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f80:	89 f9                	mov    %edi,%ecx
  803f82:	d3 e2                	shl    %cl,%edx
  803f84:	39 c2                	cmp    %eax,%edx
  803f86:	73 e9                	jae    803f71 <__udivdi3+0xe5>
  803f88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f8b:	31 ff                	xor    %edi,%edi
  803f8d:	e9 40 ff ff ff       	jmp    803ed2 <__udivdi3+0x46>
  803f92:	66 90                	xchg   %ax,%ax
  803f94:	31 c0                	xor    %eax,%eax
  803f96:	e9 37 ff ff ff       	jmp    803ed2 <__udivdi3+0x46>
  803f9b:	90                   	nop

00803f9c <__umoddi3>:
  803f9c:	55                   	push   %ebp
  803f9d:	57                   	push   %edi
  803f9e:	56                   	push   %esi
  803f9f:	53                   	push   %ebx
  803fa0:	83 ec 1c             	sub    $0x1c,%esp
  803fa3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803fa7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803fab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803faf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803fb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803fb7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803fbb:	89 f3                	mov    %esi,%ebx
  803fbd:	89 fa                	mov    %edi,%edx
  803fbf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fc3:	89 34 24             	mov    %esi,(%esp)
  803fc6:	85 c0                	test   %eax,%eax
  803fc8:	75 1a                	jne    803fe4 <__umoddi3+0x48>
  803fca:	39 f7                	cmp    %esi,%edi
  803fcc:	0f 86 a2 00 00 00    	jbe    804074 <__umoddi3+0xd8>
  803fd2:	89 c8                	mov    %ecx,%eax
  803fd4:	89 f2                	mov    %esi,%edx
  803fd6:	f7 f7                	div    %edi
  803fd8:	89 d0                	mov    %edx,%eax
  803fda:	31 d2                	xor    %edx,%edx
  803fdc:	83 c4 1c             	add    $0x1c,%esp
  803fdf:	5b                   	pop    %ebx
  803fe0:	5e                   	pop    %esi
  803fe1:	5f                   	pop    %edi
  803fe2:	5d                   	pop    %ebp
  803fe3:	c3                   	ret    
  803fe4:	39 f0                	cmp    %esi,%eax
  803fe6:	0f 87 ac 00 00 00    	ja     804098 <__umoddi3+0xfc>
  803fec:	0f bd e8             	bsr    %eax,%ebp
  803fef:	83 f5 1f             	xor    $0x1f,%ebp
  803ff2:	0f 84 ac 00 00 00    	je     8040a4 <__umoddi3+0x108>
  803ff8:	bf 20 00 00 00       	mov    $0x20,%edi
  803ffd:	29 ef                	sub    %ebp,%edi
  803fff:	89 fe                	mov    %edi,%esi
  804001:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804005:	89 e9                	mov    %ebp,%ecx
  804007:	d3 e0                	shl    %cl,%eax
  804009:	89 d7                	mov    %edx,%edi
  80400b:	89 f1                	mov    %esi,%ecx
  80400d:	d3 ef                	shr    %cl,%edi
  80400f:	09 c7                	or     %eax,%edi
  804011:	89 e9                	mov    %ebp,%ecx
  804013:	d3 e2                	shl    %cl,%edx
  804015:	89 14 24             	mov    %edx,(%esp)
  804018:	89 d8                	mov    %ebx,%eax
  80401a:	d3 e0                	shl    %cl,%eax
  80401c:	89 c2                	mov    %eax,%edx
  80401e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804022:	d3 e0                	shl    %cl,%eax
  804024:	89 44 24 04          	mov    %eax,0x4(%esp)
  804028:	8b 44 24 08          	mov    0x8(%esp),%eax
  80402c:	89 f1                	mov    %esi,%ecx
  80402e:	d3 e8                	shr    %cl,%eax
  804030:	09 d0                	or     %edx,%eax
  804032:	d3 eb                	shr    %cl,%ebx
  804034:	89 da                	mov    %ebx,%edx
  804036:	f7 f7                	div    %edi
  804038:	89 d3                	mov    %edx,%ebx
  80403a:	f7 24 24             	mull   (%esp)
  80403d:	89 c6                	mov    %eax,%esi
  80403f:	89 d1                	mov    %edx,%ecx
  804041:	39 d3                	cmp    %edx,%ebx
  804043:	0f 82 87 00 00 00    	jb     8040d0 <__umoddi3+0x134>
  804049:	0f 84 91 00 00 00    	je     8040e0 <__umoddi3+0x144>
  80404f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804053:	29 f2                	sub    %esi,%edx
  804055:	19 cb                	sbb    %ecx,%ebx
  804057:	89 d8                	mov    %ebx,%eax
  804059:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80405d:	d3 e0                	shl    %cl,%eax
  80405f:	89 e9                	mov    %ebp,%ecx
  804061:	d3 ea                	shr    %cl,%edx
  804063:	09 d0                	or     %edx,%eax
  804065:	89 e9                	mov    %ebp,%ecx
  804067:	d3 eb                	shr    %cl,%ebx
  804069:	89 da                	mov    %ebx,%edx
  80406b:	83 c4 1c             	add    $0x1c,%esp
  80406e:	5b                   	pop    %ebx
  80406f:	5e                   	pop    %esi
  804070:	5f                   	pop    %edi
  804071:	5d                   	pop    %ebp
  804072:	c3                   	ret    
  804073:	90                   	nop
  804074:	89 fd                	mov    %edi,%ebp
  804076:	85 ff                	test   %edi,%edi
  804078:	75 0b                	jne    804085 <__umoddi3+0xe9>
  80407a:	b8 01 00 00 00       	mov    $0x1,%eax
  80407f:	31 d2                	xor    %edx,%edx
  804081:	f7 f7                	div    %edi
  804083:	89 c5                	mov    %eax,%ebp
  804085:	89 f0                	mov    %esi,%eax
  804087:	31 d2                	xor    %edx,%edx
  804089:	f7 f5                	div    %ebp
  80408b:	89 c8                	mov    %ecx,%eax
  80408d:	f7 f5                	div    %ebp
  80408f:	89 d0                	mov    %edx,%eax
  804091:	e9 44 ff ff ff       	jmp    803fda <__umoddi3+0x3e>
  804096:	66 90                	xchg   %ax,%ax
  804098:	89 c8                	mov    %ecx,%eax
  80409a:	89 f2                	mov    %esi,%edx
  80409c:	83 c4 1c             	add    $0x1c,%esp
  80409f:	5b                   	pop    %ebx
  8040a0:	5e                   	pop    %esi
  8040a1:	5f                   	pop    %edi
  8040a2:	5d                   	pop    %ebp
  8040a3:	c3                   	ret    
  8040a4:	3b 04 24             	cmp    (%esp),%eax
  8040a7:	72 06                	jb     8040af <__umoddi3+0x113>
  8040a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8040ad:	77 0f                	ja     8040be <__umoddi3+0x122>
  8040af:	89 f2                	mov    %esi,%edx
  8040b1:	29 f9                	sub    %edi,%ecx
  8040b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8040b7:	89 14 24             	mov    %edx,(%esp)
  8040ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8040c2:	8b 14 24             	mov    (%esp),%edx
  8040c5:	83 c4 1c             	add    $0x1c,%esp
  8040c8:	5b                   	pop    %ebx
  8040c9:	5e                   	pop    %esi
  8040ca:	5f                   	pop    %edi
  8040cb:	5d                   	pop    %ebp
  8040cc:	c3                   	ret    
  8040cd:	8d 76 00             	lea    0x0(%esi),%esi
  8040d0:	2b 04 24             	sub    (%esp),%eax
  8040d3:	19 fa                	sbb    %edi,%edx
  8040d5:	89 d1                	mov    %edx,%ecx
  8040d7:	89 c6                	mov    %eax,%esi
  8040d9:	e9 71 ff ff ff       	jmp    80404f <__umoddi3+0xb3>
  8040de:	66 90                	xchg   %ax,%ax
  8040e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8040e4:	72 ea                	jb     8040d0 <__umoddi3+0x134>
  8040e6:	89 d9                	mov    %ebx,%ecx
  8040e8:	e9 62 ff ff ff       	jmp    80404f <__umoddi3+0xb3>
