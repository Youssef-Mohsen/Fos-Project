
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
  800041:	e8 15 18 00 00       	call   80185b <sys_getenvid>
  800046:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char line[256] ;
	readline("Enter total number of customers: ", line) ;
  800049:	83 ec 08             	sub    $0x8,%esp
  80004c:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  800052:	50                   	push   %eax
  800053:	68 80 1f 80 00       	push   $0x801f80
  800058:	e8 20 0c 00 00       	call   800c7d <readline>
  80005d:	83 c4 10             	add    $0x10,%esp
	int totalNumOfCusts = strtol(line, NULL, 10);
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	6a 0a                	push   $0xa
  800065:	6a 00                	push   $0x0
  800067:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  80006d:	50                   	push   %eax
  80006e:	e8 72 11 00 00       	call   8011e5 <strtol>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	readline("Enter shop capacity: ", line) ;
  800079:	83 ec 08             	sub    $0x8,%esp
  80007c:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  800082:	50                   	push   %eax
  800083:	68 a2 1f 80 00       	push   $0x801fa2
  800088:	e8 f0 0b 00 00       	call   800c7d <readline>
  80008d:	83 c4 10             	add    $0x10,%esp
	int shopCapacity = strtol(line, NULL, 10);
  800090:	83 ec 04             	sub    $0x4,%esp
  800093:	6a 0a                	push   $0xa
  800095:	6a 00                	push   $0x0
  800097:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  80009d:	50                   	push   %eax
  80009e:	e8 42 11 00 00       	call   8011e5 <strtol>
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct semaphore shopCapacitySem = create_semaphore("shopCapacity", shopCapacity);
  8000a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000ac:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	52                   	push   %edx
  8000b6:	68 b8 1f 80 00       	push   $0x801fb8
  8000bb:	50                   	push   %eax
  8000bc:	e8 f7 1a 00 00       	call   801bb8 <create_semaphore>
  8000c1:	83 c4 0c             	add    $0xc,%esp
	struct semaphore dependSem = create_semaphore("depend", 0);
  8000c4:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	6a 00                	push   $0x0
  8000cf:	68 c5 1f 80 00       	push   $0x801fc5
  8000d4:	50                   	push   %eax
  8000d5:	e8 de 1a 00 00       	call   801bb8 <create_semaphore>
  8000da:	83 c4 0c             	add    $0xc,%esp

	int i = 0 ;
  8000dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int id ;
	for (; i<totalNumOfCusts; i++)
  8000e4:	eb 61                	jmp    800147 <_main+0x10f>
	{
		id = sys_create_env("sem2Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000e6:	a1 04 30 80 00       	mov    0x803004,%eax
  8000eb:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8000f1:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f6:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000fc:	89 c1                	mov    %eax,%ecx
  8000fe:	a1 04 30 80 00       	mov    0x803004,%eax
  800103:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800109:	52                   	push   %edx
  80010a:	51                   	push   %ecx
  80010b:	50                   	push   %eax
  80010c:	68 cc 1f 80 00       	push   $0x801fcc
  800111:	e8 f0 16 00 00       	call   801806 <sys_create_env>
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
  800131:	e8 f6 01 00 00       	call   80032c <_panic>
		sys_run_env(id) ;
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	ff 75 e4             	pushl  -0x1c(%ebp)
  80013c:	e8 e3 16 00 00       	call   801824 <sys_run_env>
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
  800161:	e8 86 1a 00 00       	call   801bec <wait_semaphore>
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
  80017d:	e8 9e 1a 00 00       	call   801c20 <semaphore_count>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int sem2val = semaphore_count(dependSem);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff b5 d4 fe ff ff    	pushl  -0x12c(%ebp)
  800191:	e8 8a 1a 00 00       	call   801c20 <semaphore_count>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//wait a while to allow the slaves to finish printing their closing messages
	env_sleep(10000);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	68 10 27 00 00       	push   $0x2710
  8001a4:	e8 82 1a 00 00       	call   801c2b <env_sleep>
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
  8001c2:	e8 22 04 00 00       	call   8005e9 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp
  8001ca:	eb 10                	jmp    8001dc <_main+0x1a4>
	else
		cprintf("\nError: wrong semaphore value... please review your semaphore code again...\n");
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	68 8c 20 80 00       	push   $0x80208c
  8001d4:	e8 10 04 00 00       	call   8005e9 <cprintf>
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
  8001e5:	e8 8a 16 00 00       	call   801874 <sys_getenvindex>
  8001ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001f0:	89 d0                	mov    %edx,%eax
  8001f2:	c1 e0 06             	shl    $0x6,%eax
  8001f5:	29 d0                	sub    %edx,%eax
  8001f7:	c1 e0 02             	shl    $0x2,%eax
  8001fa:	01 d0                	add    %edx,%eax
  8001fc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800203:	01 c8                	add    %ecx,%eax
  800205:	c1 e0 03             	shl    $0x3,%eax
  800208:	01 d0                	add    %edx,%eax
  80020a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800211:	29 c2                	sub    %eax,%edx
  800213:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80021a:	89 c2                	mov    %eax,%edx
  80021c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800222:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800227:	a1 04 30 80 00       	mov    0x803004,%eax
  80022c:	8a 40 20             	mov    0x20(%eax),%al
  80022f:	84 c0                	test   %al,%al
  800231:	74 0d                	je     800240 <libmain+0x61>
		binaryname = myEnv->prog_name;
  800233:	a1 04 30 80 00       	mov    0x803004,%eax
  800238:	83 c0 20             	add    $0x20,%eax
  80023b:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800240:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800244:	7e 0a                	jle    800250 <libmain+0x71>
		binaryname = argv[0];
  800246:	8b 45 0c             	mov    0xc(%ebp),%eax
  800249:	8b 00                	mov    (%eax),%eax
  80024b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800250:	83 ec 08             	sub    $0x8,%esp
  800253:	ff 75 0c             	pushl  0xc(%ebp)
  800256:	ff 75 08             	pushl  0x8(%ebp)
  800259:	e8 da fd ff ff       	call   800038 <_main>
  80025e:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800261:	e8 92 13 00 00       	call   8015f8 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	68 f4 20 80 00       	push   $0x8020f4
  80026e:	e8 76 03 00 00       	call   8005e9 <cprintf>
  800273:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800276:	a1 04 30 80 00       	mov    0x803004,%eax
  80027b:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800281:	a1 04 30 80 00       	mov    0x803004,%eax
  800286:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	52                   	push   %edx
  800290:	50                   	push   %eax
  800291:	68 1c 21 80 00       	push   $0x80211c
  800296:	e8 4e 03 00 00       	call   8005e9 <cprintf>
  80029b:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80029e:	a1 04 30 80 00       	mov    0x803004,%eax
  8002a3:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8002a9:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ae:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8002b4:	a1 04 30 80 00       	mov    0x803004,%eax
  8002b9:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8002bf:	51                   	push   %ecx
  8002c0:	52                   	push   %edx
  8002c1:	50                   	push   %eax
  8002c2:	68 44 21 80 00       	push   $0x802144
  8002c7:	e8 1d 03 00 00       	call   8005e9 <cprintf>
  8002cc:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002cf:	a1 04 30 80 00       	mov    0x803004,%eax
  8002d4:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	50                   	push   %eax
  8002de:	68 9c 21 80 00       	push   $0x80219c
  8002e3:	e8 01 03 00 00       	call   8005e9 <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002eb:	83 ec 0c             	sub    $0xc,%esp
  8002ee:	68 f4 20 80 00       	push   $0x8020f4
  8002f3:	e8 f1 02 00 00       	call   8005e9 <cprintf>
  8002f8:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002fb:	e8 12 13 00 00       	call   801612 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800300:	e8 19 00 00 00       	call   80031e <exit>
}
  800305:	90                   	nop
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	6a 00                	push   $0x0
  800313:	e8 28 15 00 00       	call   801840 <sys_destroy_env>
  800318:	83 c4 10             	add    $0x10,%esp
}
  80031b:	90                   	nop
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <exit>:

void
exit(void)
{
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800324:	e8 7d 15 00 00       	call   8018a6 <sys_exit_env>
}
  800329:	90                   	nop
  80032a:	c9                   	leave  
  80032b:	c3                   	ret    

0080032c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800332:	8d 45 10             	lea    0x10(%ebp),%eax
  800335:	83 c0 04             	add    $0x4,%eax
  800338:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80033b:	a1 24 30 80 00       	mov    0x803024,%eax
  800340:	85 c0                	test   %eax,%eax
  800342:	74 16                	je     80035a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800344:	a1 24 30 80 00       	mov    0x803024,%eax
  800349:	83 ec 08             	sub    $0x8,%esp
  80034c:	50                   	push   %eax
  80034d:	68 b0 21 80 00       	push   $0x8021b0
  800352:	e8 92 02 00 00       	call   8005e9 <cprintf>
  800357:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80035a:	a1 00 30 80 00       	mov    0x803000,%eax
  80035f:	ff 75 0c             	pushl  0xc(%ebp)
  800362:	ff 75 08             	pushl  0x8(%ebp)
  800365:	50                   	push   %eax
  800366:	68 b5 21 80 00       	push   $0x8021b5
  80036b:	e8 79 02 00 00       	call   8005e9 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800373:	8b 45 10             	mov    0x10(%ebp),%eax
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	ff 75 f4             	pushl  -0xc(%ebp)
  80037c:	50                   	push   %eax
  80037d:	e8 fc 01 00 00       	call   80057e <vcprintf>
  800382:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800385:	83 ec 08             	sub    $0x8,%esp
  800388:	6a 00                	push   $0x0
  80038a:	68 d1 21 80 00       	push   $0x8021d1
  80038f:	e8 ea 01 00 00       	call   80057e <vcprintf>
  800394:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800397:	e8 82 ff ff ff       	call   80031e <exit>

	// should not return here
	while (1) ;
  80039c:	eb fe                	jmp    80039c <_panic+0x70>

0080039e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80039e:	55                   	push   %ebp
  80039f:	89 e5                	mov    %esp,%ebp
  8003a1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003a4:	a1 04 30 80 00       	mov    0x803004,%eax
  8003a9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b2:	39 c2                	cmp    %eax,%edx
  8003b4:	74 14                	je     8003ca <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003b6:	83 ec 04             	sub    $0x4,%esp
  8003b9:	68 d4 21 80 00       	push   $0x8021d4
  8003be:	6a 26                	push   $0x26
  8003c0:	68 20 22 80 00       	push   $0x802220
  8003c5:	e8 62 ff ff ff       	call   80032c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d8:	e9 c5 00 00 00       	jmp    8004a2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ea:	01 d0                	add    %edx,%eax
  8003ec:	8b 00                	mov    (%eax),%eax
  8003ee:	85 c0                	test   %eax,%eax
  8003f0:	75 08                	jne    8003fa <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003f2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003f5:	e9 a5 00 00 00       	jmp    80049f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800401:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800408:	eb 69                	jmp    800473 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80040a:	a1 04 30 80 00       	mov    0x803004,%eax
  80040f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800415:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800418:	89 d0                	mov    %edx,%eax
  80041a:	01 c0                	add    %eax,%eax
  80041c:	01 d0                	add    %edx,%eax
  80041e:	c1 e0 03             	shl    $0x3,%eax
  800421:	01 c8                	add    %ecx,%eax
  800423:	8a 40 04             	mov    0x4(%eax),%al
  800426:	84 c0                	test   %al,%al
  800428:	75 46                	jne    800470 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80042a:	a1 04 30 80 00       	mov    0x803004,%eax
  80042f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800435:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800438:	89 d0                	mov    %edx,%eax
  80043a:	01 c0                	add    %eax,%eax
  80043c:	01 d0                	add    %edx,%eax
  80043e:	c1 e0 03             	shl    $0x3,%eax
  800441:	01 c8                	add    %ecx,%eax
  800443:	8b 00                	mov    (%eax),%eax
  800445:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800448:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80044b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800450:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800455:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c8                	add    %ecx,%eax
  800461:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800463:	39 c2                	cmp    %eax,%edx
  800465:	75 09                	jne    800470 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800467:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80046e:	eb 15                	jmp    800485 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800470:	ff 45 e8             	incl   -0x18(%ebp)
  800473:	a1 04 30 80 00       	mov    0x803004,%eax
  800478:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80047e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800481:	39 c2                	cmp    %eax,%edx
  800483:	77 85                	ja     80040a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800485:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800489:	75 14                	jne    80049f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80048b:	83 ec 04             	sub    $0x4,%esp
  80048e:	68 2c 22 80 00       	push   $0x80222c
  800493:	6a 3a                	push   $0x3a
  800495:	68 20 22 80 00       	push   $0x802220
  80049a:	e8 8d fe ff ff       	call   80032c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80049f:	ff 45 f0             	incl   -0x10(%ebp)
  8004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a8:	0f 8c 2f ff ff ff    	jl     8003dd <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004bc:	eb 26                	jmp    8004e4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004be:	a1 04 30 80 00       	mov    0x803004,%eax
  8004c3:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8004c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cc:	89 d0                	mov    %edx,%eax
  8004ce:	01 c0                	add    %eax,%eax
  8004d0:	01 d0                	add    %edx,%eax
  8004d2:	c1 e0 03             	shl    $0x3,%eax
  8004d5:	01 c8                	add    %ecx,%eax
  8004d7:	8a 40 04             	mov    0x4(%eax),%al
  8004da:	3c 01                	cmp    $0x1,%al
  8004dc:	75 03                	jne    8004e1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004de:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e1:	ff 45 e0             	incl   -0x20(%ebp)
  8004e4:	a1 04 30 80 00       	mov    0x803004,%eax
  8004e9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f2:	39 c2                	cmp    %eax,%edx
  8004f4:	77 c8                	ja     8004be <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fc:	74 14                	je     800512 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 80 22 80 00       	push   $0x802280
  800506:	6a 44                	push   $0x44
  800508:	68 20 22 80 00       	push   $0x802220
  80050d:	e8 1a fe ff ff       	call   80032c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800512:	90                   	nop
  800513:	c9                   	leave  
  800514:	c3                   	ret    

00800515 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	8d 48 01             	lea    0x1(%eax),%ecx
  800523:	8b 55 0c             	mov    0xc(%ebp),%edx
  800526:	89 0a                	mov    %ecx,(%edx)
  800528:	8b 55 08             	mov    0x8(%ebp),%edx
  80052b:	88 d1                	mov    %dl,%cl
  80052d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800530:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800534:	8b 45 0c             	mov    0xc(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	3d ff 00 00 00       	cmp    $0xff,%eax
  80053e:	75 2c                	jne    80056c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800540:	a0 08 30 80 00       	mov    0x803008,%al
  800545:	0f b6 c0             	movzbl %al,%eax
  800548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80054b:	8b 12                	mov    (%edx),%edx
  80054d:	89 d1                	mov    %edx,%ecx
  80054f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800552:	83 c2 08             	add    $0x8,%edx
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	50                   	push   %eax
  800559:	51                   	push   %ecx
  80055a:	52                   	push   %edx
  80055b:	e8 56 10 00 00       	call   8015b6 <sys_cputs>
  800560:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800563:	8b 45 0c             	mov    0xc(%ebp),%eax
  800566:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80056c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056f:	8b 40 04             	mov    0x4(%eax),%eax
  800572:	8d 50 01             	lea    0x1(%eax),%edx
  800575:	8b 45 0c             	mov    0xc(%ebp),%eax
  800578:	89 50 04             	mov    %edx,0x4(%eax)
}
  80057b:	90                   	nop
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800587:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80058e:	00 00 00 
	b.cnt = 0;
  800591:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800598:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80059b:	ff 75 0c             	pushl  0xc(%ebp)
  80059e:	ff 75 08             	pushl  0x8(%ebp)
  8005a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a7:	50                   	push   %eax
  8005a8:	68 15 05 80 00       	push   $0x800515
  8005ad:	e8 11 02 00 00       	call   8007c3 <vprintfmt>
  8005b2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005b5:	a0 08 30 80 00       	mov    0x803008,%al
  8005ba:	0f b6 c0             	movzbl %al,%eax
  8005bd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	50                   	push   %eax
  8005c7:	52                   	push   %edx
  8005c8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ce:	83 c0 08             	add    $0x8,%eax
  8005d1:	50                   	push   %eax
  8005d2:	e8 df 0f 00 00       	call   8015b6 <sys_cputs>
  8005d7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005da:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8005e1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005e7:	c9                   	leave  
  8005e8:	c3                   	ret    

008005e9 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005e9:	55                   	push   %ebp
  8005ea:	89 e5                	mov    %esp,%ebp
  8005ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005ef:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8005f6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 f4             	pushl  -0xc(%ebp)
  800605:	50                   	push   %eax
  800606:	e8 73 ff ff ff       	call   80057e <vcprintf>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800611:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800614:	c9                   	leave  
  800615:	c3                   	ret    

00800616 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80061c:	e8 d7 0f 00 00       	call   8015f8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800621:	8d 45 0c             	lea    0xc(%ebp),%eax
  800624:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 f4             	pushl  -0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	e8 48 ff ff ff       	call   80057e <vcprintf>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80063c:	e8 d1 0f 00 00       	call   801612 <sys_unlock_cons>
	return cnt;
  800641:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800644:	c9                   	leave  
  800645:	c3                   	ret    

00800646 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800646:	55                   	push   %ebp
  800647:	89 e5                	mov    %esp,%ebp
  800649:	53                   	push   %ebx
  80064a:	83 ec 14             	sub    $0x14,%esp
  80064d:	8b 45 10             	mov    0x10(%ebp),%eax
  800650:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800659:	8b 45 18             	mov    0x18(%ebp),%eax
  80065c:	ba 00 00 00 00       	mov    $0x0,%edx
  800661:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800664:	77 55                	ja     8006bb <printnum+0x75>
  800666:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800669:	72 05                	jb     800670 <printnum+0x2a>
  80066b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80066e:	77 4b                	ja     8006bb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800670:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800673:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800676:	8b 45 18             	mov    0x18(%ebp),%eax
  800679:	ba 00 00 00 00       	mov    $0x0,%edx
  80067e:	52                   	push   %edx
  80067f:	50                   	push   %eax
  800680:	ff 75 f4             	pushl  -0xc(%ebp)
  800683:	ff 75 f0             	pushl  -0x10(%ebp)
  800686:	e8 91 16 00 00       	call   801d1c <__udivdi3>
  80068b:	83 c4 10             	add    $0x10,%esp
  80068e:	83 ec 04             	sub    $0x4,%esp
  800691:	ff 75 20             	pushl  0x20(%ebp)
  800694:	53                   	push   %ebx
  800695:	ff 75 18             	pushl  0x18(%ebp)
  800698:	52                   	push   %edx
  800699:	50                   	push   %eax
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	ff 75 08             	pushl  0x8(%ebp)
  8006a0:	e8 a1 ff ff ff       	call   800646 <printnum>
  8006a5:	83 c4 20             	add    $0x20,%esp
  8006a8:	eb 1a                	jmp    8006c4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	ff 75 0c             	pushl  0xc(%ebp)
  8006b0:	ff 75 20             	pushl  0x20(%ebp)
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	ff d0                	call   *%eax
  8006b8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006bb:	ff 4d 1c             	decl   0x1c(%ebp)
  8006be:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006c2:	7f e6                	jg     8006aa <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006c4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d2:	53                   	push   %ebx
  8006d3:	51                   	push   %ecx
  8006d4:	52                   	push   %edx
  8006d5:	50                   	push   %eax
  8006d6:	e8 51 17 00 00       	call   801e2c <__umoddi3>
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	05 f4 24 80 00       	add    $0x8024f4,%eax
  8006e3:	8a 00                	mov    (%eax),%al
  8006e5:	0f be c0             	movsbl %al,%eax
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	50                   	push   %eax
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	ff d0                	call   *%eax
  8006f4:	83 c4 10             	add    $0x10,%esp
}
  8006f7:	90                   	nop
  8006f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fb:	c9                   	leave  
  8006fc:	c3                   	ret    

008006fd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800700:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800704:	7e 1c                	jle    800722 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	8d 50 08             	lea    0x8(%eax),%edx
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	89 10                	mov    %edx,(%eax)
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	83 e8 08             	sub    $0x8,%eax
  80071b:	8b 50 04             	mov    0x4(%eax),%edx
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	eb 40                	jmp    800762 <getuint+0x65>
	else if (lflag)
  800722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800726:	74 1e                	je     800746 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	ba 00 00 00 00       	mov    $0x0,%edx
  800744:	eb 1c                	jmp    800762 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	8d 50 04             	lea    0x4(%eax),%edx
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	89 10                	mov    %edx,(%eax)
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	83 e8 04             	sub    $0x4,%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800762:	5d                   	pop    %ebp
  800763:	c3                   	ret    

00800764 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800767:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80076b:	7e 1c                	jle    800789 <getint+0x25>
		return va_arg(*ap, long long);
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	8d 50 08             	lea    0x8(%eax),%edx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	89 10                	mov    %edx,(%eax)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	83 e8 08             	sub    $0x8,%eax
  800782:	8b 50 04             	mov    0x4(%eax),%edx
  800785:	8b 00                	mov    (%eax),%eax
  800787:	eb 38                	jmp    8007c1 <getint+0x5d>
	else if (lflag)
  800789:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078d:	74 1a                	je     8007a9 <getint+0x45>
		return va_arg(*ap, long);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	8d 50 04             	lea    0x4(%eax),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 10                	mov    %edx,(%eax)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	83 e8 04             	sub    $0x4,%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	99                   	cltd   
  8007a7:	eb 18                	jmp    8007c1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	8d 50 04             	lea    0x4(%eax),%edx
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	89 10                	mov    %edx,(%eax)
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	83 e8 04             	sub    $0x4,%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	99                   	cltd   
}
  8007c1:	5d                   	pop    %ebp
  8007c2:	c3                   	ret    

008007c3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	56                   	push   %esi
  8007c7:	53                   	push   %ebx
  8007c8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cb:	eb 17                	jmp    8007e4 <vprintfmt+0x21>
			if (ch == '\0')
  8007cd:	85 db                	test   %ebx,%ebx
  8007cf:	0f 84 c1 03 00 00    	je     800b96 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	ff 75 0c             	pushl  0xc(%ebp)
  8007db:	53                   	push   %ebx
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	ff d0                	call   *%eax
  8007e1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ed:	8a 00                	mov    (%eax),%al
  8007ef:	0f b6 d8             	movzbl %al,%ebx
  8007f2:	83 fb 25             	cmp    $0x25,%ebx
  8007f5:	75 d6                	jne    8007cd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007f7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007fb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800802:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800809:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800810:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800817:	8b 45 10             	mov    0x10(%ebp),%eax
  80081a:	8d 50 01             	lea    0x1(%eax),%edx
  80081d:	89 55 10             	mov    %edx,0x10(%ebp)
  800820:	8a 00                	mov    (%eax),%al
  800822:	0f b6 d8             	movzbl %al,%ebx
  800825:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800828:	83 f8 5b             	cmp    $0x5b,%eax
  80082b:	0f 87 3d 03 00 00    	ja     800b6e <vprintfmt+0x3ab>
  800831:	8b 04 85 18 25 80 00 	mov    0x802518(,%eax,4),%eax
  800838:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80083a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80083e:	eb d7                	jmp    800817 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800840:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800844:	eb d1                	jmp    800817 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800846:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80084d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800850:	89 d0                	mov    %edx,%eax
  800852:	c1 e0 02             	shl    $0x2,%eax
  800855:	01 d0                	add    %edx,%eax
  800857:	01 c0                	add    %eax,%eax
  800859:	01 d8                	add    %ebx,%eax
  80085b:	83 e8 30             	sub    $0x30,%eax
  80085e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800861:	8b 45 10             	mov    0x10(%ebp),%eax
  800864:	8a 00                	mov    (%eax),%al
  800866:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800869:	83 fb 2f             	cmp    $0x2f,%ebx
  80086c:	7e 3e                	jle    8008ac <vprintfmt+0xe9>
  80086e:	83 fb 39             	cmp    $0x39,%ebx
  800871:	7f 39                	jg     8008ac <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800873:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800876:	eb d5                	jmp    80084d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	83 c0 04             	add    $0x4,%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	83 e8 04             	sub    $0x4,%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80088c:	eb 1f                	jmp    8008ad <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80088e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800892:	79 83                	jns    800817 <vprintfmt+0x54>
				width = 0;
  800894:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80089b:	e9 77 ff ff ff       	jmp    800817 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008a0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008a7:	e9 6b ff ff ff       	jmp    800817 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008ac:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b1:	0f 89 60 ff ff ff    	jns    800817 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008c4:	e9 4e ff ff ff       	jmp    800817 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008cc:	e9 46 ff ff ff       	jmp    800817 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	83 c0 04             	add    $0x4,%eax
  8008d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	83 e8 04             	sub    $0x4,%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	83 ec 08             	sub    $0x8,%esp
  8008e5:	ff 75 0c             	pushl  0xc(%ebp)
  8008e8:	50                   	push   %eax
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	ff d0                	call   *%eax
  8008ee:	83 c4 10             	add    $0x10,%esp
			break;
  8008f1:	e9 9b 02 00 00       	jmp    800b91 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f9:	83 c0 04             	add    $0x4,%eax
  8008fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	83 e8 04             	sub    $0x4,%eax
  800905:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800907:	85 db                	test   %ebx,%ebx
  800909:	79 02                	jns    80090d <vprintfmt+0x14a>
				err = -err;
  80090b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80090d:	83 fb 64             	cmp    $0x64,%ebx
  800910:	7f 0b                	jg     80091d <vprintfmt+0x15a>
  800912:	8b 34 9d 60 23 80 00 	mov    0x802360(,%ebx,4),%esi
  800919:	85 f6                	test   %esi,%esi
  80091b:	75 19                	jne    800936 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80091d:	53                   	push   %ebx
  80091e:	68 05 25 80 00       	push   $0x802505
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	ff 75 08             	pushl  0x8(%ebp)
  800929:	e8 70 02 00 00       	call   800b9e <printfmt>
  80092e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800931:	e9 5b 02 00 00       	jmp    800b91 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800936:	56                   	push   %esi
  800937:	68 0e 25 80 00       	push   $0x80250e
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	ff 75 08             	pushl  0x8(%ebp)
  800942:	e8 57 02 00 00       	call   800b9e <printfmt>
  800947:	83 c4 10             	add    $0x10,%esp
			break;
  80094a:	e9 42 02 00 00       	jmp    800b91 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	83 c0 04             	add    $0x4,%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	83 e8 04             	sub    $0x4,%eax
  80095e:	8b 30                	mov    (%eax),%esi
  800960:	85 f6                	test   %esi,%esi
  800962:	75 05                	jne    800969 <vprintfmt+0x1a6>
				p = "(null)";
  800964:	be 11 25 80 00       	mov    $0x802511,%esi
			if (width > 0 && padc != '-')
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7e 6d                	jle    8009dc <vprintfmt+0x219>
  80096f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800973:	74 67                	je     8009dc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800975:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	50                   	push   %eax
  80097c:	56                   	push   %esi
  80097d:	e8 26 05 00 00       	call   800ea8 <strnlen>
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800988:	eb 16                	jmp    8009a0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80098a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	50                   	push   %eax
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	ff d0                	call   *%eax
  80099a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80099d:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a4:	7f e4                	jg     80098a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a6:	eb 34                	jmp    8009dc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009ac:	74 1c                	je     8009ca <vprintfmt+0x207>
  8009ae:	83 fb 1f             	cmp    $0x1f,%ebx
  8009b1:	7e 05                	jle    8009b8 <vprintfmt+0x1f5>
  8009b3:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b6:	7e 12                	jle    8009ca <vprintfmt+0x207>
					putch('?', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 3f                	push   $0x3f
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
  8009c8:	eb 0f                	jmp    8009d9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	53                   	push   %ebx
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009dc:	89 f0                	mov    %esi,%eax
  8009de:	8d 70 01             	lea    0x1(%eax),%esi
  8009e1:	8a 00                	mov    (%eax),%al
  8009e3:	0f be d8             	movsbl %al,%ebx
  8009e6:	85 db                	test   %ebx,%ebx
  8009e8:	74 24                	je     800a0e <vprintfmt+0x24b>
  8009ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ee:	78 b8                	js     8009a8 <vprintfmt+0x1e5>
  8009f0:	ff 4d e0             	decl   -0x20(%ebp)
  8009f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f7:	79 af                	jns    8009a8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f9:	eb 13                	jmp    800a0e <vprintfmt+0x24b>
				putch(' ', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 20                	push   $0x20
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a12:	7f e7                	jg     8009fb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a14:	e9 78 01 00 00       	jmp    800b91 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a1f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a22:	50                   	push   %eax
  800a23:	e8 3c fd ff ff       	call   800764 <getint>
  800a28:	83 c4 10             	add    $0x10,%esp
  800a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a37:	85 d2                	test   %edx,%edx
  800a39:	79 23                	jns    800a5e <vprintfmt+0x29b>
				putch('-', putdat);
  800a3b:	83 ec 08             	sub    $0x8,%esp
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	6a 2d                	push   $0x2d
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	ff d0                	call   *%eax
  800a48:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a51:	f7 d8                	neg    %eax
  800a53:	83 d2 00             	adc    $0x0,%edx
  800a56:	f7 da                	neg    %edx
  800a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a5e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a65:	e9 bc 00 00 00       	jmp    800b26 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a6a:	83 ec 08             	sub    $0x8,%esp
  800a6d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a70:	8d 45 14             	lea    0x14(%ebp),%eax
  800a73:	50                   	push   %eax
  800a74:	e8 84 fc ff ff       	call   8006fd <getuint>
  800a79:	83 c4 10             	add    $0x10,%esp
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a89:	e9 98 00 00 00       	jmp    800b26 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 58                	push   $0x58
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 58                	push   $0x58
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	6a 58                	push   $0x58
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	ff d0                	call   *%eax
  800abb:	83 c4 10             	add    $0x10,%esp
			break;
  800abe:	e9 ce 00 00 00       	jmp    800b91 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	6a 30                	push   $0x30
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	6a 78                	push   $0x78
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 c0 04             	add    $0x4,%eax
  800ae9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 e8 04             	sub    $0x4,%eax
  800af2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800afe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b05:	eb 1f                	jmp    800b26 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b10:	50                   	push   %eax
  800b11:	e8 e7 fb ff ff       	call   8006fd <getuint>
  800b16:	83 c4 10             	add    $0x10,%esp
  800b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b1f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b26:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b2d:	83 ec 04             	sub    $0x4,%esp
  800b30:	52                   	push   %edx
  800b31:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b34:	50                   	push   %eax
  800b35:	ff 75 f4             	pushl  -0xc(%ebp)
  800b38:	ff 75 f0             	pushl  -0x10(%ebp)
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 00 fb ff ff       	call   800646 <printnum>
  800b46:	83 c4 20             	add    $0x20,%esp
			break;
  800b49:	eb 46                	jmp    800b91 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	53                   	push   %ebx
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
			break;
  800b5a:	eb 35                	jmp    800b91 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b5c:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800b63:	eb 2c                	jmp    800b91 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b65:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800b6c:	eb 23                	jmp    800b91 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b6e:	83 ec 08             	sub    $0x8,%esp
  800b71:	ff 75 0c             	pushl  0xc(%ebp)
  800b74:	6a 25                	push   $0x25
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b7e:	ff 4d 10             	decl   0x10(%ebp)
  800b81:	eb 03                	jmp    800b86 <vprintfmt+0x3c3>
  800b83:	ff 4d 10             	decl   0x10(%ebp)
  800b86:	8b 45 10             	mov    0x10(%ebp),%eax
  800b89:	48                   	dec    %eax
  800b8a:	8a 00                	mov    (%eax),%al
  800b8c:	3c 25                	cmp    $0x25,%al
  800b8e:	75 f3                	jne    800b83 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b90:	90                   	nop
		}
	}
  800b91:	e9 35 fc ff ff       	jmp    8007cb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b96:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b97:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b9a:	5b                   	pop    %ebx
  800b9b:	5e                   	pop    %esi
  800b9c:	5d                   	pop    %ebp
  800b9d:	c3                   	ret    

00800b9e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ba4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba7:	83 c0 04             	add    $0x4,%eax
  800baa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bad:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb3:	50                   	push   %eax
  800bb4:	ff 75 0c             	pushl  0xc(%ebp)
  800bb7:	ff 75 08             	pushl  0x8(%ebp)
  800bba:	e8 04 fc ff ff       	call   8007c3 <vprintfmt>
  800bbf:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bc2:	90                   	nop
  800bc3:	c9                   	leave  
  800bc4:	c3                   	ret    

00800bc5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcb:	8b 40 08             	mov    0x8(%eax),%eax
  800bce:	8d 50 01             	lea    0x1(%eax),%edx
  800bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bda:	8b 10                	mov    (%eax),%edx
  800bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdf:	8b 40 04             	mov    0x4(%eax),%eax
  800be2:	39 c2                	cmp    %eax,%edx
  800be4:	73 12                	jae    800bf8 <sprintputch+0x33>
		*b->buf++ = ch;
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	8b 00                	mov    (%eax),%eax
  800beb:	8d 48 01             	lea    0x1(%eax),%ecx
  800bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf1:	89 0a                	mov    %ecx,(%edx)
  800bf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf6:	88 10                	mov    %dl,(%eax)
}
  800bf8:	90                   	nop
  800bf9:	5d                   	pop    %ebp
  800bfa:	c3                   	ret    

00800bfb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	01 d0                	add    %edx,%eax
  800c12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c20:	74 06                	je     800c28 <vsnprintf+0x2d>
  800c22:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c26:	7f 07                	jg     800c2f <vsnprintf+0x34>
		return -E_INVAL;
  800c28:	b8 03 00 00 00       	mov    $0x3,%eax
  800c2d:	eb 20                	jmp    800c4f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c2f:	ff 75 14             	pushl  0x14(%ebp)
  800c32:	ff 75 10             	pushl  0x10(%ebp)
  800c35:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c38:	50                   	push   %eax
  800c39:	68 c5 0b 80 00       	push   $0x800bc5
  800c3e:	e8 80 fb ff ff       	call   8007c3 <vprintfmt>
  800c43:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c49:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c4f:	c9                   	leave  
  800c50:	c3                   	ret    

00800c51 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c57:	8d 45 10             	lea    0x10(%ebp),%eax
  800c5a:	83 c0 04             	add    $0x4,%eax
  800c5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c60:	8b 45 10             	mov    0x10(%ebp),%eax
  800c63:	ff 75 f4             	pushl  -0xc(%ebp)
  800c66:	50                   	push   %eax
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	ff 75 08             	pushl  0x8(%ebp)
  800c6d:	e8 89 ff ff ff       	call   800bfb <vsnprintf>
  800c72:	83 c4 10             	add    $0x10,%esp
  800c75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c7b:	c9                   	leave  
  800c7c:	c3                   	ret    

00800c7d <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800c7d:	55                   	push   %ebp
  800c7e:	89 e5                	mov    %esp,%ebp
  800c80:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800c83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c87:	74 13                	je     800c9c <readline+0x1f>
		cprintf("%s", prompt);
  800c89:	83 ec 08             	sub    $0x8,%esp
  800c8c:	ff 75 08             	pushl  0x8(%ebp)
  800c8f:	68 88 26 80 00       	push   $0x802688
  800c94:	e8 50 f9 ff ff       	call   8005e9 <cprintf>
  800c99:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800c9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800ca3:	83 ec 0c             	sub    $0xc,%esp
  800ca6:	6a 00                	push   $0x0
  800ca8:	e8 64 10 00 00       	call   801d11 <iscons>
  800cad:	83 c4 10             	add    $0x10,%esp
  800cb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800cb3:	e8 46 10 00 00       	call   801cfe <getchar>
  800cb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800cbb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800cbf:	79 22                	jns    800ce3 <readline+0x66>
			if (c != -E_EOF)
  800cc1:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800cc5:	0f 84 ad 00 00 00    	je     800d78 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	ff 75 ec             	pushl  -0x14(%ebp)
  800cd1:	68 8b 26 80 00       	push   $0x80268b
  800cd6:	e8 0e f9 ff ff       	call   8005e9 <cprintf>
  800cdb:	83 c4 10             	add    $0x10,%esp
			break;
  800cde:	e9 95 00 00 00       	jmp    800d78 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ce3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ce7:	7e 34                	jle    800d1d <readline+0xa0>
  800ce9:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800cf0:	7f 2b                	jg     800d1d <readline+0xa0>
			if (echoing)
  800cf2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cf6:	74 0e                	je     800d06 <readline+0x89>
				cputchar(c);
  800cf8:	83 ec 0c             	sub    $0xc,%esp
  800cfb:	ff 75 ec             	pushl  -0x14(%ebp)
  800cfe:	e8 dc 0f 00 00       	call   801cdf <cputchar>
  800d03:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d09:	8d 50 01             	lea    0x1(%eax),%edx
  800d0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800d0f:	89 c2                	mov    %eax,%edx
  800d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d14:	01 d0                	add    %edx,%eax
  800d16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d19:	88 10                	mov    %dl,(%eax)
  800d1b:	eb 56                	jmp    800d73 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800d1d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800d21:	75 1f                	jne    800d42 <readline+0xc5>
  800d23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800d27:	7e 19                	jle    800d42 <readline+0xc5>
			if (echoing)
  800d29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d2d:	74 0e                	je     800d3d <readline+0xc0>
				cputchar(c);
  800d2f:	83 ec 0c             	sub    $0xc,%esp
  800d32:	ff 75 ec             	pushl  -0x14(%ebp)
  800d35:	e8 a5 0f 00 00       	call   801cdf <cputchar>
  800d3a:	83 c4 10             	add    $0x10,%esp

			i--;
  800d3d:	ff 4d f4             	decl   -0xc(%ebp)
  800d40:	eb 31                	jmp    800d73 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800d42:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800d46:	74 0a                	je     800d52 <readline+0xd5>
  800d48:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800d4c:	0f 85 61 ff ff ff    	jne    800cb3 <readline+0x36>
			if (echoing)
  800d52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d56:	74 0e                	je     800d66 <readline+0xe9>
				cputchar(c);
  800d58:	83 ec 0c             	sub    $0xc,%esp
  800d5b:	ff 75 ec             	pushl  -0x14(%ebp)
  800d5e:	e8 7c 0f 00 00       	call   801cdf <cputchar>
  800d63:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800d66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6c:	01 d0                	add    %edx,%eax
  800d6e:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800d71:	eb 06                	jmp    800d79 <readline+0xfc>
		}
	}
  800d73:	e9 3b ff ff ff       	jmp    800cb3 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800d78:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800d79:	90                   	nop
  800d7a:	c9                   	leave  
  800d7b:	c3                   	ret    

00800d7c <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800d82:	e8 71 08 00 00       	call   8015f8 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800d87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d8b:	74 13                	je     800da0 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800d8d:	83 ec 08             	sub    $0x8,%esp
  800d90:	ff 75 08             	pushl  0x8(%ebp)
  800d93:	68 88 26 80 00       	push   $0x802688
  800d98:	e8 4c f8 ff ff       	call   8005e9 <cprintf>
  800d9d:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800da0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800da7:	83 ec 0c             	sub    $0xc,%esp
  800daa:	6a 00                	push   $0x0
  800dac:	e8 60 0f 00 00       	call   801d11 <iscons>
  800db1:	83 c4 10             	add    $0x10,%esp
  800db4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800db7:	e8 42 0f 00 00       	call   801cfe <getchar>
  800dbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800dbf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800dc3:	79 22                	jns    800de7 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800dc5:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800dc9:	0f 84 ad 00 00 00    	je     800e7c <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800dcf:	83 ec 08             	sub    $0x8,%esp
  800dd2:	ff 75 ec             	pushl  -0x14(%ebp)
  800dd5:	68 8b 26 80 00       	push   $0x80268b
  800dda:	e8 0a f8 ff ff       	call   8005e9 <cprintf>
  800ddf:	83 c4 10             	add    $0x10,%esp
				break;
  800de2:	e9 95 00 00 00       	jmp    800e7c <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800de7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800deb:	7e 34                	jle    800e21 <atomic_readline+0xa5>
  800ded:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800df4:	7f 2b                	jg     800e21 <atomic_readline+0xa5>
				if (echoing)
  800df6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800dfa:	74 0e                	je     800e0a <atomic_readline+0x8e>
					cputchar(c);
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	ff 75 ec             	pushl  -0x14(%ebp)
  800e02:	e8 d8 0e 00 00       	call   801cdf <cputchar>
  800e07:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e0d:	8d 50 01             	lea    0x1(%eax),%edx
  800e10:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800e13:	89 c2                	mov    %eax,%edx
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	01 d0                	add    %edx,%eax
  800e1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e1d:	88 10                	mov    %dl,(%eax)
  800e1f:	eb 56                	jmp    800e77 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800e21:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800e25:	75 1f                	jne    800e46 <atomic_readline+0xca>
  800e27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800e2b:	7e 19                	jle    800e46 <atomic_readline+0xca>
				if (echoing)
  800e2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e31:	74 0e                	je     800e41 <atomic_readline+0xc5>
					cputchar(c);
  800e33:	83 ec 0c             	sub    $0xc,%esp
  800e36:	ff 75 ec             	pushl  -0x14(%ebp)
  800e39:	e8 a1 0e 00 00       	call   801cdf <cputchar>
  800e3e:	83 c4 10             	add    $0x10,%esp
				i--;
  800e41:	ff 4d f4             	decl   -0xc(%ebp)
  800e44:	eb 31                	jmp    800e77 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800e46:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800e4a:	74 0a                	je     800e56 <atomic_readline+0xda>
  800e4c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800e50:	0f 85 61 ff ff ff    	jne    800db7 <atomic_readline+0x3b>
				if (echoing)
  800e56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e5a:	74 0e                	je     800e6a <atomic_readline+0xee>
					cputchar(c);
  800e5c:	83 ec 0c             	sub    $0xc,%esp
  800e5f:	ff 75 ec             	pushl  -0x14(%ebp)
  800e62:	e8 78 0e 00 00       	call   801cdf <cputchar>
  800e67:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800e6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	01 d0                	add    %edx,%eax
  800e72:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800e75:	eb 06                	jmp    800e7d <atomic_readline+0x101>
			}
		}
  800e77:	e9 3b ff ff ff       	jmp    800db7 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800e7c:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800e7d:	e8 90 07 00 00       	call   801612 <sys_unlock_cons>
}
  800e82:	90                   	nop
  800e83:	c9                   	leave  
  800e84:	c3                   	ret    

00800e85 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e92:	eb 06                	jmp    800e9a <strlen+0x15>
		n++;
  800e94:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e97:	ff 45 08             	incl   0x8(%ebp)
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8a 00                	mov    (%eax),%al
  800e9f:	84 c0                	test   %al,%al
  800ea1:	75 f1                	jne    800e94 <strlen+0xf>
		n++;
	return n;
  800ea3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea6:	c9                   	leave  
  800ea7:	c3                   	ret    

00800ea8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb5:	eb 09                	jmp    800ec0 <strnlen+0x18>
		n++;
  800eb7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eba:	ff 45 08             	incl   0x8(%ebp)
  800ebd:	ff 4d 0c             	decl   0xc(%ebp)
  800ec0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec4:	74 09                	je     800ecf <strnlen+0x27>
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	84 c0                	test   %al,%al
  800ecd:	75 e8                	jne    800eb7 <strnlen+0xf>
		n++;
	return n;
  800ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ed2:	c9                   	leave  
  800ed3:	c3                   	ret    

00800ed4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ee0:	90                   	nop
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8d 50 01             	lea    0x1(%eax),%edx
  800ee7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eed:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ef3:	8a 12                	mov    (%edx),%dl
  800ef5:	88 10                	mov    %dl,(%eax)
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	84 c0                	test   %al,%al
  800efb:	75 e4                	jne    800ee1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800efd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f00:	c9                   	leave  
  800f01:	c3                   	ret    

00800f02 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f15:	eb 1f                	jmp    800f36 <strncpy+0x34>
		*dst++ = *src;
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8d 50 01             	lea    0x1(%eax),%edx
  800f1d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f23:	8a 12                	mov    (%edx),%dl
  800f25:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	84 c0                	test   %al,%al
  800f2e:	74 03                	je     800f33 <strncpy+0x31>
			src++;
  800f30:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f33:	ff 45 fc             	incl   -0x4(%ebp)
  800f36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f39:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f3c:	72 d9                	jb     800f17 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f41:	c9                   	leave  
  800f42:	c3                   	ret    

00800f43 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f53:	74 30                	je     800f85 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f55:	eb 16                	jmp    800f6d <strlcpy+0x2a>
			*dst++ = *src++;
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	8d 50 01             	lea    0x1(%eax),%edx
  800f5d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f63:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f66:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f69:	8a 12                	mov    (%edx),%dl
  800f6b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f6d:	ff 4d 10             	decl   0x10(%ebp)
  800f70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f74:	74 09                	je     800f7f <strlcpy+0x3c>
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	8a 00                	mov    (%eax),%al
  800f7b:	84 c0                	test   %al,%al
  800f7d:	75 d8                	jne    800f57 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f85:	8b 55 08             	mov    0x8(%ebp),%edx
  800f88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8b:	29 c2                	sub    %eax,%edx
  800f8d:	89 d0                	mov    %edx,%eax
}
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f94:	eb 06                	jmp    800f9c <strcmp+0xb>
		p++, q++;
  800f96:	ff 45 08             	incl   0x8(%ebp)
  800f99:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	84 c0                	test   %al,%al
  800fa3:	74 0e                	je     800fb3 <strcmp+0x22>
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 10                	mov    (%eax),%dl
  800faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	38 c2                	cmp    %al,%dl
  800fb1:	74 e3                	je     800f96 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	0f b6 d0             	movzbl %al,%edx
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	0f b6 c0             	movzbl %al,%eax
  800fc3:	29 c2                	sub    %eax,%edx
  800fc5:	89 d0                	mov    %edx,%eax
}
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    

00800fc9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fcc:	eb 09                	jmp    800fd7 <strncmp+0xe>
		n--, p++, q++;
  800fce:	ff 4d 10             	decl   0x10(%ebp)
  800fd1:	ff 45 08             	incl   0x8(%ebp)
  800fd4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdb:	74 17                	je     800ff4 <strncmp+0x2b>
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	8a 00                	mov    (%eax),%al
  800fe2:	84 c0                	test   %al,%al
  800fe4:	74 0e                	je     800ff4 <strncmp+0x2b>
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 10                	mov    (%eax),%dl
  800feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	38 c2                	cmp    %al,%dl
  800ff2:	74 da                	je     800fce <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ff4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff8:	75 07                	jne    801001 <strncmp+0x38>
		return 0;
  800ffa:	b8 00 00 00 00       	mov    $0x0,%eax
  800fff:	eb 14                	jmp    801015 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	0f b6 d0             	movzbl %al,%edx
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	8a 00                	mov    (%eax),%al
  80100e:	0f b6 c0             	movzbl %al,%eax
  801011:	29 c2                	sub    %eax,%edx
  801013:	89 d0                	mov    %edx,%eax
}
  801015:	5d                   	pop    %ebp
  801016:	c3                   	ret    

00801017 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 04             	sub    $0x4,%esp
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801023:	eb 12                	jmp    801037 <strchr+0x20>
		if (*s == c)
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80102d:	75 05                	jne    801034 <strchr+0x1d>
			return (char *) s;
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	eb 11                	jmp    801045 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801034:	ff 45 08             	incl   0x8(%ebp)
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	84 c0                	test   %al,%al
  80103e:	75 e5                	jne    801025 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801040:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801045:	c9                   	leave  
  801046:	c3                   	ret    

00801047 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	83 ec 04             	sub    $0x4,%esp
  80104d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801050:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801053:	eb 0d                	jmp    801062 <strfind+0x1b>
		if (*s == c)
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80105d:	74 0e                	je     80106d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80105f:	ff 45 08             	incl   0x8(%ebp)
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	84 c0                	test   %al,%al
  801069:	75 ea                	jne    801055 <strfind+0xe>
  80106b:	eb 01                	jmp    80106e <strfind+0x27>
		if (*s == c)
			break;
  80106d:	90                   	nop
	return (char *) s;
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801071:	c9                   	leave  
  801072:	c3                   	ret    

00801073 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80107f:	8b 45 10             	mov    0x10(%ebp),%eax
  801082:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801085:	eb 0e                	jmp    801095 <memset+0x22>
		*p++ = c;
  801087:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108a:	8d 50 01             	lea    0x1(%eax),%edx
  80108d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801090:	8b 55 0c             	mov    0xc(%ebp),%edx
  801093:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801095:	ff 4d f8             	decl   -0x8(%ebp)
  801098:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80109c:	79 e9                	jns    801087 <memset+0x14>
		*p++ = c;

	return v;
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    

008010a3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010b5:	eb 16                	jmp    8010cd <memcpy+0x2a>
		*d++ = *s++;
  8010b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ba:	8d 50 01             	lea    0x1(%eax),%edx
  8010bd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010c9:	8a 12                	mov    (%edx),%dl
  8010cb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d3:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	75 dd                	jne    8010b7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010dd:	c9                   	leave  
  8010de:	c3                   	ret    

008010df <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f7:	73 50                	jae    801149 <memmove+0x6a>
  8010f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ff:	01 d0                	add    %edx,%eax
  801101:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801104:	76 43                	jbe    801149 <memmove+0x6a>
		s += n;
  801106:	8b 45 10             	mov    0x10(%ebp),%eax
  801109:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80110c:	8b 45 10             	mov    0x10(%ebp),%eax
  80110f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801112:	eb 10                	jmp    801124 <memmove+0x45>
			*--d = *--s;
  801114:	ff 4d f8             	decl   -0x8(%ebp)
  801117:	ff 4d fc             	decl   -0x4(%ebp)
  80111a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111d:	8a 10                	mov    (%eax),%dl
  80111f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801122:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801124:	8b 45 10             	mov    0x10(%ebp),%eax
  801127:	8d 50 ff             	lea    -0x1(%eax),%edx
  80112a:	89 55 10             	mov    %edx,0x10(%ebp)
  80112d:	85 c0                	test   %eax,%eax
  80112f:	75 e3                	jne    801114 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801131:	eb 23                	jmp    801156 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801133:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801136:	8d 50 01             	lea    0x1(%eax),%edx
  801139:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80113c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801142:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801145:	8a 12                	mov    (%edx),%dl
  801147:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801149:	8b 45 10             	mov    0x10(%ebp),%eax
  80114c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114f:	89 55 10             	mov    %edx,0x10(%ebp)
  801152:	85 c0                	test   %eax,%eax
  801154:	75 dd                	jne    801133 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801159:	c9                   	leave  
  80115a:	c3                   	ret    

0080115b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80116d:	eb 2a                	jmp    801199 <memcmp+0x3e>
		if (*s1 != *s2)
  80116f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801172:	8a 10                	mov    (%eax),%dl
  801174:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801177:	8a 00                	mov    (%eax),%al
  801179:	38 c2                	cmp    %al,%dl
  80117b:	74 16                	je     801193 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80117d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	0f b6 d0             	movzbl %al,%edx
  801185:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	0f b6 c0             	movzbl %al,%eax
  80118d:	29 c2                	sub    %eax,%edx
  80118f:	89 d0                	mov    %edx,%eax
  801191:	eb 18                	jmp    8011ab <memcmp+0x50>
		s1++, s2++;
  801193:	ff 45 fc             	incl   -0x4(%ebp)
  801196:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801199:	8b 45 10             	mov    0x10(%ebp),%eax
  80119c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119f:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	75 c9                	jne    80116f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    

008011ad <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	01 d0                	add    %edx,%eax
  8011bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011be:	eb 15                	jmp    8011d5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	8a 00                	mov    (%eax),%al
  8011c5:	0f b6 d0             	movzbl %al,%edx
  8011c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cb:	0f b6 c0             	movzbl %al,%eax
  8011ce:	39 c2                	cmp    %eax,%edx
  8011d0:	74 0d                	je     8011df <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011d2:	ff 45 08             	incl   0x8(%ebp)
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011db:	72 e3                	jb     8011c0 <memfind+0x13>
  8011dd:	eb 01                	jmp    8011e0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011df:	90                   	nop
	return (void *) s;
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    

008011e5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f9:	eb 03                	jmp    8011fe <strtol+0x19>
		s++;
  8011fb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	3c 20                	cmp    $0x20,%al
  801205:	74 f4                	je     8011fb <strtol+0x16>
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	3c 09                	cmp    $0x9,%al
  80120e:	74 eb                	je     8011fb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	8a 00                	mov    (%eax),%al
  801215:	3c 2b                	cmp    $0x2b,%al
  801217:	75 05                	jne    80121e <strtol+0x39>
		s++;
  801219:	ff 45 08             	incl   0x8(%ebp)
  80121c:	eb 13                	jmp    801231 <strtol+0x4c>
	else if (*s == '-')
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	3c 2d                	cmp    $0x2d,%al
  801225:	75 0a                	jne    801231 <strtol+0x4c>
		s++, neg = 1;
  801227:	ff 45 08             	incl   0x8(%ebp)
  80122a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801231:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801235:	74 06                	je     80123d <strtol+0x58>
  801237:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80123b:	75 20                	jne    80125d <strtol+0x78>
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	8a 00                	mov    (%eax),%al
  801242:	3c 30                	cmp    $0x30,%al
  801244:	75 17                	jne    80125d <strtol+0x78>
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	40                   	inc    %eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	3c 78                	cmp    $0x78,%al
  80124e:	75 0d                	jne    80125d <strtol+0x78>
		s += 2, base = 16;
  801250:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801254:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80125b:	eb 28                	jmp    801285 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80125d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801261:	75 15                	jne    801278 <strtol+0x93>
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	3c 30                	cmp    $0x30,%al
  80126a:	75 0c                	jne    801278 <strtol+0x93>
		s++, base = 8;
  80126c:	ff 45 08             	incl   0x8(%ebp)
  80126f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801276:	eb 0d                	jmp    801285 <strtol+0xa0>
	else if (base == 0)
  801278:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80127c:	75 07                	jne    801285 <strtol+0xa0>
		base = 10;
  80127e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	8a 00                	mov    (%eax),%al
  80128a:	3c 2f                	cmp    $0x2f,%al
  80128c:	7e 19                	jle    8012a7 <strtol+0xc2>
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
  801291:	8a 00                	mov    (%eax),%al
  801293:	3c 39                	cmp    $0x39,%al
  801295:	7f 10                	jg     8012a7 <strtol+0xc2>
			dig = *s - '0';
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	0f be c0             	movsbl %al,%eax
  80129f:	83 e8 30             	sub    $0x30,%eax
  8012a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a5:	eb 42                	jmp    8012e9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	3c 60                	cmp    $0x60,%al
  8012ae:	7e 19                	jle    8012c9 <strtol+0xe4>
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	3c 7a                	cmp    $0x7a,%al
  8012b7:	7f 10                	jg     8012c9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	0f be c0             	movsbl %al,%eax
  8012c1:	83 e8 57             	sub    $0x57,%eax
  8012c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c7:	eb 20                	jmp    8012e9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	8a 00                	mov    (%eax),%al
  8012ce:	3c 40                	cmp    $0x40,%al
  8012d0:	7e 39                	jle    80130b <strtol+0x126>
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	8a 00                	mov    (%eax),%al
  8012d7:	3c 5a                	cmp    $0x5a,%al
  8012d9:	7f 30                	jg     80130b <strtol+0x126>
			dig = *s - 'A' + 10;
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	8a 00                	mov    (%eax),%al
  8012e0:	0f be c0             	movsbl %al,%eax
  8012e3:	83 e8 37             	sub    $0x37,%eax
  8012e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ec:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012ef:	7d 19                	jge    80130a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012f1:	ff 45 08             	incl   0x8(%ebp)
  8012f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012fb:	89 c2                	mov    %eax,%edx
  8012fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801300:	01 d0                	add    %edx,%eax
  801302:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801305:	e9 7b ff ff ff       	jmp    801285 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80130a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80130b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130f:	74 08                	je     801319 <strtol+0x134>
		*endptr = (char *) s;
  801311:	8b 45 0c             	mov    0xc(%ebp),%eax
  801314:	8b 55 08             	mov    0x8(%ebp),%edx
  801317:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801319:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80131d:	74 07                	je     801326 <strtol+0x141>
  80131f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801322:	f7 d8                	neg    %eax
  801324:	eb 03                	jmp    801329 <strtol+0x144>
  801326:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <ltostr>:

void
ltostr(long value, char *str)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801331:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801338:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80133f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801343:	79 13                	jns    801358 <ltostr+0x2d>
	{
		neg = 1;
  801345:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80134c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801352:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801355:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801360:	99                   	cltd   
  801361:	f7 f9                	idiv   %ecx
  801363:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801366:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801369:	8d 50 01             	lea    0x1(%eax),%edx
  80136c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80136f:	89 c2                	mov    %eax,%edx
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	01 d0                	add    %edx,%eax
  801376:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801379:	83 c2 30             	add    $0x30,%edx
  80137c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80137e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801381:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801386:	f7 e9                	imul   %ecx
  801388:	c1 fa 02             	sar    $0x2,%edx
  80138b:	89 c8                	mov    %ecx,%eax
  80138d:	c1 f8 1f             	sar    $0x1f,%eax
  801390:	29 c2                	sub    %eax,%edx
  801392:	89 d0                	mov    %edx,%eax
  801394:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801397:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80139b:	75 bb                	jne    801358 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80139d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a7:	48                   	dec    %eax
  8013a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013af:	74 3d                	je     8013ee <ltostr+0xc3>
		start = 1 ;
  8013b1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013b8:	eb 34                	jmp    8013ee <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c0:	01 d0                	add    %edx,%eax
  8013c2:	8a 00                	mov    (%eax),%al
  8013c4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cd:	01 c2                	add    %eax,%edx
  8013cf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	01 c8                	add    %ecx,%eax
  8013d7:	8a 00                	mov    (%eax),%al
  8013d9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e1:	01 c2                	add    %eax,%edx
  8013e3:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013e6:	88 02                	mov    %al,(%edx)
		start++ ;
  8013e8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013eb:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013f4:	7c c4                	jl     8013ba <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013f6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fc:	01 d0                	add    %edx,%eax
  8013fe:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801401:	90                   	nop
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80140a:	ff 75 08             	pushl  0x8(%ebp)
  80140d:	e8 73 fa ff ff       	call   800e85 <strlen>
  801412:	83 c4 04             	add    $0x4,%esp
  801415:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801418:	ff 75 0c             	pushl  0xc(%ebp)
  80141b:	e8 65 fa ff ff       	call   800e85 <strlen>
  801420:	83 c4 04             	add    $0x4,%esp
  801423:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801426:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80142d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801434:	eb 17                	jmp    80144d <strcconcat+0x49>
		final[s] = str1[s] ;
  801436:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801439:	8b 45 10             	mov    0x10(%ebp),%eax
  80143c:	01 c2                	add    %eax,%edx
  80143e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	01 c8                	add    %ecx,%eax
  801446:	8a 00                	mov    (%eax),%al
  801448:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80144a:	ff 45 fc             	incl   -0x4(%ebp)
  80144d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801450:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801453:	7c e1                	jl     801436 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801455:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80145c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801463:	eb 1f                	jmp    801484 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801465:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80146e:	89 c2                	mov    %eax,%edx
  801470:	8b 45 10             	mov    0x10(%ebp),%eax
  801473:	01 c2                	add    %eax,%edx
  801475:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147b:	01 c8                	add    %ecx,%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801481:	ff 45 f8             	incl   -0x8(%ebp)
  801484:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801487:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80148a:	7c d9                	jl     801465 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80148c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148f:	8b 45 10             	mov    0x10(%ebp),%eax
  801492:	01 d0                	add    %edx,%eax
  801494:	c6 00 00             	movb   $0x0,(%eax)
}
  801497:	90                   	nop
  801498:	c9                   	leave  
  801499:	c3                   	ret    

0080149a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80149d:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a9:	8b 00                	mov    (%eax),%eax
  8014ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b5:	01 d0                	add    %edx,%eax
  8014b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014bd:	eb 0c                	jmp    8014cb <strsplit+0x31>
			*string++ = 0;
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	8d 50 01             	lea    0x1(%eax),%edx
  8014c5:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ce:	8a 00                	mov    (%eax),%al
  8014d0:	84 c0                	test   %al,%al
  8014d2:	74 18                	je     8014ec <strsplit+0x52>
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	8a 00                	mov    (%eax),%al
  8014d9:	0f be c0             	movsbl %al,%eax
  8014dc:	50                   	push   %eax
  8014dd:	ff 75 0c             	pushl  0xc(%ebp)
  8014e0:	e8 32 fb ff ff       	call   801017 <strchr>
  8014e5:	83 c4 08             	add    $0x8,%esp
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	75 d3                	jne    8014bf <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	8a 00                	mov    (%eax),%al
  8014f1:	84 c0                	test   %al,%al
  8014f3:	74 5a                	je     80154f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f8:	8b 00                	mov    (%eax),%eax
  8014fa:	83 f8 0f             	cmp    $0xf,%eax
  8014fd:	75 07                	jne    801506 <strsplit+0x6c>
		{
			return 0;
  8014ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801504:	eb 66                	jmp    80156c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801506:	8b 45 14             	mov    0x14(%ebp),%eax
  801509:	8b 00                	mov    (%eax),%eax
  80150b:	8d 48 01             	lea    0x1(%eax),%ecx
  80150e:	8b 55 14             	mov    0x14(%ebp),%edx
  801511:	89 0a                	mov    %ecx,(%edx)
  801513:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151a:	8b 45 10             	mov    0x10(%ebp),%eax
  80151d:	01 c2                	add    %eax,%edx
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801524:	eb 03                	jmp    801529 <strsplit+0x8f>
			string++;
  801526:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	8a 00                	mov    (%eax),%al
  80152e:	84 c0                	test   %al,%al
  801530:	74 8b                	je     8014bd <strsplit+0x23>
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	8a 00                	mov    (%eax),%al
  801537:	0f be c0             	movsbl %al,%eax
  80153a:	50                   	push   %eax
  80153b:	ff 75 0c             	pushl  0xc(%ebp)
  80153e:	e8 d4 fa ff ff       	call   801017 <strchr>
  801543:	83 c4 08             	add    $0x8,%esp
  801546:	85 c0                	test   %eax,%eax
  801548:	74 dc                	je     801526 <strsplit+0x8c>
			string++;
	}
  80154a:	e9 6e ff ff ff       	jmp    8014bd <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80154f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801550:	8b 45 14             	mov    0x14(%ebp),%eax
  801553:	8b 00                	mov    (%eax),%eax
  801555:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80155c:	8b 45 10             	mov    0x10(%ebp),%eax
  80155f:	01 d0                	add    %edx,%eax
  801561:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801567:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801574:	83 ec 04             	sub    $0x4,%esp
  801577:	68 9c 26 80 00       	push   $0x80269c
  80157c:	68 3f 01 00 00       	push   $0x13f
  801581:	68 be 26 80 00       	push   $0x8026be
  801586:	e8 a1 ed ff ff       	call   80032c <_panic>

0080158b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	57                   	push   %edi
  80158f:	56                   	push   %esi
  801590:	53                   	push   %ebx
  801591:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
  801597:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80159d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015a0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015a3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015a6:	cd 30                	int    $0x30
  8015a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015ae:	83 c4 10             	add    $0x10,%esp
  8015b1:	5b                   	pop    %ebx
  8015b2:	5e                   	pop    %esi
  8015b3:	5f                   	pop    %edi
  8015b4:	5d                   	pop    %ebp
  8015b5:	c3                   	ret    

008015b6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 04             	sub    $0x4,%esp
  8015bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015c2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	52                   	push   %edx
  8015ce:	ff 75 0c             	pushl  0xc(%ebp)
  8015d1:	50                   	push   %eax
  8015d2:	6a 00                	push   $0x0
  8015d4:	e8 b2 ff ff ff       	call   80158b <syscall>
  8015d9:	83 c4 18             	add    $0x18,%esp
}
  8015dc:	90                   	nop
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <sys_cgetc>:

int
sys_cgetc(void)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 02                	push   $0x2
  8015ee:	e8 98 ff ff ff       	call   80158b <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 03                	push   $0x3
  801607:	e8 7f ff ff ff       	call   80158b <syscall>
  80160c:	83 c4 18             	add    $0x18,%esp
}
  80160f:	90                   	nop
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 04                	push   $0x4
  801621:	e8 65 ff ff ff       	call   80158b <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
}
  801629:	90                   	nop
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80162f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	52                   	push   %edx
  80163c:	50                   	push   %eax
  80163d:	6a 08                	push   $0x8
  80163f:	e8 47 ff ff ff       	call   80158b <syscall>
  801644:	83 c4 18             	add    $0x18,%esp
}
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	56                   	push   %esi
  80164d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80164e:	8b 75 18             	mov    0x18(%ebp),%esi
  801651:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801654:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801657:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	56                   	push   %esi
  80165e:	53                   	push   %ebx
  80165f:	51                   	push   %ecx
  801660:	52                   	push   %edx
  801661:	50                   	push   %eax
  801662:	6a 09                	push   $0x9
  801664:	e8 22 ff ff ff       	call   80158b <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
}
  80166c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80166f:	5b                   	pop    %ebx
  801670:	5e                   	pop    %esi
  801671:	5d                   	pop    %ebp
  801672:	c3                   	ret    

00801673 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801676:	8b 55 0c             	mov    0xc(%ebp),%edx
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	52                   	push   %edx
  801683:	50                   	push   %eax
  801684:	6a 0a                	push   $0xa
  801686:	e8 00 ff ff ff       	call   80158b <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	ff 75 0c             	pushl  0xc(%ebp)
  80169c:	ff 75 08             	pushl  0x8(%ebp)
  80169f:	6a 0b                	push   $0xb
  8016a1:	e8 e5 fe ff ff       	call   80158b <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 0c                	push   $0xc
  8016ba:	e8 cc fe ff ff       	call   80158b <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 0d                	push   $0xd
  8016d3:	e8 b3 fe ff ff       	call   80158b <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 0e                	push   $0xe
  8016ec:	e8 9a fe ff ff       	call   80158b <syscall>
  8016f1:	83 c4 18             	add    $0x18,%esp
}
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 0f                	push   $0xf
  801705:	e8 81 fe ff ff       	call   80158b <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	ff 75 08             	pushl  0x8(%ebp)
  80171d:	6a 10                	push   $0x10
  80171f:	e8 67 fe ff ff       	call   80158b <syscall>
  801724:	83 c4 18             	add    $0x18,%esp
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 11                	push   $0x11
  801738:	e8 4e fe ff ff       	call   80158b <syscall>
  80173d:	83 c4 18             	add    $0x18,%esp
}
  801740:	90                   	nop
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <sys_cputc>:

void
sys_cputc(const char c)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	83 ec 04             	sub    $0x4,%esp
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80174f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	50                   	push   %eax
  80175c:	6a 01                	push   $0x1
  80175e:	e8 28 fe ff ff       	call   80158b <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
}
  801766:	90                   	nop
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 14                	push   $0x14
  801778:	e8 0e fe ff ff       	call   80158b <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
}
  801780:	90                   	nop
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 04             	sub    $0x4,%esp
  801789:	8b 45 10             	mov    0x10(%ebp),%eax
  80178c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80178f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801792:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	6a 00                	push   $0x0
  80179b:	51                   	push   %ecx
  80179c:	52                   	push   %edx
  80179d:	ff 75 0c             	pushl  0xc(%ebp)
  8017a0:	50                   	push   %eax
  8017a1:	6a 15                	push   $0x15
  8017a3:	e8 e3 fd ff ff       	call   80158b <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	52                   	push   %edx
  8017bd:	50                   	push   %eax
  8017be:	6a 16                	push   $0x16
  8017c0:	e8 c6 fd ff ff       	call   80158b <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	51                   	push   %ecx
  8017db:	52                   	push   %edx
  8017dc:	50                   	push   %eax
  8017dd:	6a 17                	push   $0x17
  8017df:	e8 a7 fd ff ff       	call   80158b <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	52                   	push   %edx
  8017f9:	50                   	push   %eax
  8017fa:	6a 18                	push   $0x18
  8017fc:	e8 8a fd ff ff       	call   80158b <syscall>
  801801:	83 c4 18             	add    $0x18,%esp
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	6a 00                	push   $0x0
  80180e:	ff 75 14             	pushl  0x14(%ebp)
  801811:	ff 75 10             	pushl  0x10(%ebp)
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	50                   	push   %eax
  801818:	6a 19                	push   $0x19
  80181a:	e8 6c fd ff ff       	call   80158b <syscall>
  80181f:	83 c4 18             	add    $0x18,%esp
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	50                   	push   %eax
  801833:	6a 1a                	push   $0x1a
  801835:	e8 51 fd ff ff       	call   80158b <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	90                   	nop
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	50                   	push   %eax
  80184f:	6a 1b                	push   $0x1b
  801851:	e8 35 fd ff ff       	call   80158b <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 05                	push   $0x5
  80186a:	e8 1c fd ff ff       	call   80158b <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 06                	push   $0x6
  801883:	e8 03 fd ff ff       	call   80158b <syscall>
  801888:	83 c4 18             	add    $0x18,%esp
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 07                	push   $0x7
  80189c:	e8 ea fc ff ff       	call   80158b <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_exit_env>:


void sys_exit_env(void)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 1c                	push   $0x1c
  8018b5:	e8 d1 fc ff ff       	call   80158b <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	90                   	nop
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018c6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018c9:	8d 50 04             	lea    0x4(%eax),%edx
  8018cc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	52                   	push   %edx
  8018d6:	50                   	push   %eax
  8018d7:	6a 1d                	push   $0x1d
  8018d9:	e8 ad fc ff ff       	call   80158b <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
	return result;
  8018e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018ea:	89 01                	mov    %eax,(%ecx)
  8018ec:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	c9                   	leave  
  8018f3:	c2 04 00             	ret    $0x4

008018f6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	ff 75 10             	pushl  0x10(%ebp)
  801900:	ff 75 0c             	pushl  0xc(%ebp)
  801903:	ff 75 08             	pushl  0x8(%ebp)
  801906:	6a 13                	push   $0x13
  801908:	e8 7e fc ff ff       	call   80158b <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
	return ;
  801910:	90                   	nop
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_rcr2>:
uint32 sys_rcr2()
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 1e                	push   $0x1e
  801922:	e8 64 fc ff ff       	call   80158b <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	83 ec 04             	sub    $0x4,%esp
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801938:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	50                   	push   %eax
  801945:	6a 1f                	push   $0x1f
  801947:	e8 3f fc ff ff       	call   80158b <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
	return ;
  80194f:	90                   	nop
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <rsttst>:
void rsttst()
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 21                	push   $0x21
  801961:	e8 25 fc ff ff       	call   80158b <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
	return ;
  801969:	90                   	nop
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	83 ec 04             	sub    $0x4,%esp
  801972:	8b 45 14             	mov    0x14(%ebp),%eax
  801975:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801978:	8b 55 18             	mov    0x18(%ebp),%edx
  80197b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80197f:	52                   	push   %edx
  801980:	50                   	push   %eax
  801981:	ff 75 10             	pushl  0x10(%ebp)
  801984:	ff 75 0c             	pushl  0xc(%ebp)
  801987:	ff 75 08             	pushl  0x8(%ebp)
  80198a:	6a 20                	push   $0x20
  80198c:	e8 fa fb ff ff       	call   80158b <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
	return ;
  801994:	90                   	nop
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <chktst>:
void chktst(uint32 n)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	ff 75 08             	pushl  0x8(%ebp)
  8019a5:	6a 22                	push   $0x22
  8019a7:	e8 df fb ff ff       	call   80158b <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8019af:	90                   	nop
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <inctst>:

void inctst()
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 23                	push   $0x23
  8019c1:	e8 c5 fb ff ff       	call   80158b <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c9:	90                   	nop
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <gettst>:
uint32 gettst()
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 24                	push   $0x24
  8019db:	e8 ab fb ff ff       	call   80158b <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 25                	push   $0x25
  8019f7:	e8 8f fb ff ff       	call   80158b <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
  8019ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a02:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a06:	75 07                	jne    801a0f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a08:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0d:	eb 05                	jmp    801a14 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 25                	push   $0x25
  801a28:	e8 5e fb ff ff       	call   80158b <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
  801a30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a33:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a37:	75 07                	jne    801a40 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a39:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3e:	eb 05                	jmp    801a45 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 25                	push   $0x25
  801a59:	e8 2d fb ff ff       	call   80158b <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
  801a61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a64:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a68:	75 07                	jne    801a71 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6f:	eb 05                	jmp    801a76 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 25                	push   $0x25
  801a8a:	e8 fc fa ff ff       	call   80158b <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
  801a92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a95:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a99:	75 07                	jne    801aa2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a9b:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa0:	eb 05                	jmp    801aa7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801aa2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	ff 75 08             	pushl  0x8(%ebp)
  801ab7:	6a 26                	push   $0x26
  801ab9:	e8 cd fa ff ff       	call   80158b <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac1:	90                   	nop
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ac8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801acb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ace:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	6a 00                	push   $0x0
  801ad6:	53                   	push   %ebx
  801ad7:	51                   	push   %ecx
  801ad8:	52                   	push   %edx
  801ad9:	50                   	push   %eax
  801ada:	6a 27                	push   $0x27
  801adc:	e8 aa fa ff ff       	call   80158b <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
}
  801ae4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	52                   	push   %edx
  801af9:	50                   	push   %eax
  801afa:	6a 28                	push   $0x28
  801afc:	e8 8a fa ff ff       	call   80158b <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b09:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	6a 00                	push   $0x0
  801b14:	51                   	push   %ecx
  801b15:	ff 75 10             	pushl  0x10(%ebp)
  801b18:	52                   	push   %edx
  801b19:	50                   	push   %eax
  801b1a:	6a 29                	push   $0x29
  801b1c:	e8 6a fa ff ff       	call   80158b <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	ff 75 10             	pushl  0x10(%ebp)
  801b30:	ff 75 0c             	pushl  0xc(%ebp)
  801b33:	ff 75 08             	pushl  0x8(%ebp)
  801b36:	6a 12                	push   $0x12
  801b38:	e8 4e fa ff ff       	call   80158b <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b40:	90                   	nop
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	52                   	push   %edx
  801b53:	50                   	push   %eax
  801b54:	6a 2a                	push   $0x2a
  801b56:	e8 30 fa ff ff       	call   80158b <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
	return;
  801b5e:	90                   	nop
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801b67:	83 ec 04             	sub    $0x4,%esp
  801b6a:	68 cb 26 80 00       	push   $0x8026cb
  801b6f:	68 2e 01 00 00       	push   $0x12e
  801b74:	68 df 26 80 00       	push   $0x8026df
  801b79:	e8 ae e7 ff ff       	call   80032c <_panic>

00801b7e <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801b84:	83 ec 04             	sub    $0x4,%esp
  801b87:	68 cb 26 80 00       	push   $0x8026cb
  801b8c:	68 35 01 00 00       	push   $0x135
  801b91:	68 df 26 80 00       	push   $0x8026df
  801b96:	e8 91 e7 ff ff       	call   80032c <_panic>

00801b9b <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801ba1:	83 ec 04             	sub    $0x4,%esp
  801ba4:	68 cb 26 80 00       	push   $0x8026cb
  801ba9:	68 3b 01 00 00       	push   $0x13b
  801bae:	68 df 26 80 00       	push   $0x8026df
  801bb3:	e8 74 e7 ff ff       	call   80032c <_panic>

00801bb8 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  801bbe:	83 ec 04             	sub    $0x4,%esp
  801bc1:	68 f0 26 80 00       	push   $0x8026f0
  801bc6:	6a 09                	push   $0x9
  801bc8:	68 18 27 80 00       	push   $0x802718
  801bcd:	e8 5a e7 ff ff       	call   80032c <_panic>

00801bd2 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  801bd8:	83 ec 04             	sub    $0x4,%esp
  801bdb:	68 28 27 80 00       	push   $0x802728
  801be0:	6a 10                	push   $0x10
  801be2:	68 18 27 80 00       	push   $0x802718
  801be7:	e8 40 e7 ff ff       	call   80032c <_panic>

00801bec <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  801bf2:	83 ec 04             	sub    $0x4,%esp
  801bf5:	68 50 27 80 00       	push   $0x802750
  801bfa:	6a 18                	push   $0x18
  801bfc:	68 18 27 80 00       	push   $0x802718
  801c01:	e8 26 e7 ff ff       	call   80032c <_panic>

00801c06 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  801c0c:	83 ec 04             	sub    $0x4,%esp
  801c0f:	68 78 27 80 00       	push   $0x802778
  801c14:	6a 20                	push   $0x20
  801c16:	68 18 27 80 00       	push   $0x802718
  801c1b:	e8 0c e7 ff ff       	call   80032c <_panic>

00801c20 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	8b 40 10             	mov    0x10(%eax),%eax
}
  801c29:	5d                   	pop    %ebp
  801c2a:	c3                   	ret    

00801c2b <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801c31:	8b 55 08             	mov    0x8(%ebp),%edx
  801c34:	89 d0                	mov    %edx,%eax
  801c36:	c1 e0 02             	shl    $0x2,%eax
  801c39:	01 d0                	add    %edx,%eax
  801c3b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c42:	01 d0                	add    %edx,%eax
  801c44:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c4b:	01 d0                	add    %edx,%eax
  801c4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c54:	01 d0                	add    %edx,%eax
  801c56:	c1 e0 04             	shl    $0x4,%eax
  801c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801c5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801c63:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801c66:	83 ec 0c             	sub    $0xc,%esp
  801c69:	50                   	push   %eax
  801c6a:	e8 51 fc ff ff       	call   8018c0 <sys_get_virtual_time>
  801c6f:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801c72:	eb 41                	jmp    801cb5 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801c74:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801c77:	83 ec 0c             	sub    $0xc,%esp
  801c7a:	50                   	push   %eax
  801c7b:	e8 40 fc ff ff       	call   8018c0 <sys_get_virtual_time>
  801c80:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801c83:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c89:	29 c2                	sub    %eax,%edx
  801c8b:	89 d0                	mov    %edx,%eax
  801c8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801c90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c96:	89 d1                	mov    %edx,%ecx
  801c98:	29 c1                	sub    %eax,%ecx
  801c9a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca0:	39 c2                	cmp    %eax,%edx
  801ca2:	0f 97 c0             	seta   %al
  801ca5:	0f b6 c0             	movzbl %al,%eax
  801ca8:	29 c1                	sub    %eax,%ecx
  801caa:	89 c8                	mov    %ecx,%eax
  801cac:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801caf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801cbb:	72 b7                	jb     801c74 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801cbd:	90                   	nop
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801cc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801ccd:	eb 03                	jmp    801cd2 <busy_wait+0x12>
  801ccf:	ff 45 fc             	incl   -0x4(%ebp)
  801cd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cd5:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cd8:	72 f5                	jb     801ccf <busy_wait+0xf>
	return i;
  801cda:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801ceb:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801cef:	83 ec 0c             	sub    $0xc,%esp
  801cf2:	50                   	push   %eax
  801cf3:	e8 4b fa ff ff       	call   801743 <sys_cputc>
  801cf8:	83 c4 10             	add    $0x10,%esp
}
  801cfb:	90                   	nop
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <getchar>:


int
getchar(void)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801d04:	e8 d6 f8 ff ff       	call   8015df <sys_cgetc>
  801d09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <iscons>:

int iscons(int fdnum)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801d14:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d19:	5d                   	pop    %ebp
  801d1a:	c3                   	ret    
  801d1b:	90                   	nop

00801d1c <__udivdi3>:
  801d1c:	55                   	push   %ebp
  801d1d:	57                   	push   %edi
  801d1e:	56                   	push   %esi
  801d1f:	53                   	push   %ebx
  801d20:	83 ec 1c             	sub    $0x1c,%esp
  801d23:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d27:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d2f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d33:	89 ca                	mov    %ecx,%edx
  801d35:	89 f8                	mov    %edi,%eax
  801d37:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d3b:	85 f6                	test   %esi,%esi
  801d3d:	75 2d                	jne    801d6c <__udivdi3+0x50>
  801d3f:	39 cf                	cmp    %ecx,%edi
  801d41:	77 65                	ja     801da8 <__udivdi3+0x8c>
  801d43:	89 fd                	mov    %edi,%ebp
  801d45:	85 ff                	test   %edi,%edi
  801d47:	75 0b                	jne    801d54 <__udivdi3+0x38>
  801d49:	b8 01 00 00 00       	mov    $0x1,%eax
  801d4e:	31 d2                	xor    %edx,%edx
  801d50:	f7 f7                	div    %edi
  801d52:	89 c5                	mov    %eax,%ebp
  801d54:	31 d2                	xor    %edx,%edx
  801d56:	89 c8                	mov    %ecx,%eax
  801d58:	f7 f5                	div    %ebp
  801d5a:	89 c1                	mov    %eax,%ecx
  801d5c:	89 d8                	mov    %ebx,%eax
  801d5e:	f7 f5                	div    %ebp
  801d60:	89 cf                	mov    %ecx,%edi
  801d62:	89 fa                	mov    %edi,%edx
  801d64:	83 c4 1c             	add    $0x1c,%esp
  801d67:	5b                   	pop    %ebx
  801d68:	5e                   	pop    %esi
  801d69:	5f                   	pop    %edi
  801d6a:	5d                   	pop    %ebp
  801d6b:	c3                   	ret    
  801d6c:	39 ce                	cmp    %ecx,%esi
  801d6e:	77 28                	ja     801d98 <__udivdi3+0x7c>
  801d70:	0f bd fe             	bsr    %esi,%edi
  801d73:	83 f7 1f             	xor    $0x1f,%edi
  801d76:	75 40                	jne    801db8 <__udivdi3+0x9c>
  801d78:	39 ce                	cmp    %ecx,%esi
  801d7a:	72 0a                	jb     801d86 <__udivdi3+0x6a>
  801d7c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d80:	0f 87 9e 00 00 00    	ja     801e24 <__udivdi3+0x108>
  801d86:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8b:	89 fa                	mov    %edi,%edx
  801d8d:	83 c4 1c             	add    $0x1c,%esp
  801d90:	5b                   	pop    %ebx
  801d91:	5e                   	pop    %esi
  801d92:	5f                   	pop    %edi
  801d93:	5d                   	pop    %ebp
  801d94:	c3                   	ret    
  801d95:	8d 76 00             	lea    0x0(%esi),%esi
  801d98:	31 ff                	xor    %edi,%edi
  801d9a:	31 c0                	xor    %eax,%eax
  801d9c:	89 fa                	mov    %edi,%edx
  801d9e:	83 c4 1c             	add    $0x1c,%esp
  801da1:	5b                   	pop    %ebx
  801da2:	5e                   	pop    %esi
  801da3:	5f                   	pop    %edi
  801da4:	5d                   	pop    %ebp
  801da5:	c3                   	ret    
  801da6:	66 90                	xchg   %ax,%ax
  801da8:	89 d8                	mov    %ebx,%eax
  801daa:	f7 f7                	div    %edi
  801dac:	31 ff                	xor    %edi,%edi
  801dae:	89 fa                	mov    %edi,%edx
  801db0:	83 c4 1c             	add    $0x1c,%esp
  801db3:	5b                   	pop    %ebx
  801db4:	5e                   	pop    %esi
  801db5:	5f                   	pop    %edi
  801db6:	5d                   	pop    %ebp
  801db7:	c3                   	ret    
  801db8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801dbd:	89 eb                	mov    %ebp,%ebx
  801dbf:	29 fb                	sub    %edi,%ebx
  801dc1:	89 f9                	mov    %edi,%ecx
  801dc3:	d3 e6                	shl    %cl,%esi
  801dc5:	89 c5                	mov    %eax,%ebp
  801dc7:	88 d9                	mov    %bl,%cl
  801dc9:	d3 ed                	shr    %cl,%ebp
  801dcb:	89 e9                	mov    %ebp,%ecx
  801dcd:	09 f1                	or     %esi,%ecx
  801dcf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801dd3:	89 f9                	mov    %edi,%ecx
  801dd5:	d3 e0                	shl    %cl,%eax
  801dd7:	89 c5                	mov    %eax,%ebp
  801dd9:	89 d6                	mov    %edx,%esi
  801ddb:	88 d9                	mov    %bl,%cl
  801ddd:	d3 ee                	shr    %cl,%esi
  801ddf:	89 f9                	mov    %edi,%ecx
  801de1:	d3 e2                	shl    %cl,%edx
  801de3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801de7:	88 d9                	mov    %bl,%cl
  801de9:	d3 e8                	shr    %cl,%eax
  801deb:	09 c2                	or     %eax,%edx
  801ded:	89 d0                	mov    %edx,%eax
  801def:	89 f2                	mov    %esi,%edx
  801df1:	f7 74 24 0c          	divl   0xc(%esp)
  801df5:	89 d6                	mov    %edx,%esi
  801df7:	89 c3                	mov    %eax,%ebx
  801df9:	f7 e5                	mul    %ebp
  801dfb:	39 d6                	cmp    %edx,%esi
  801dfd:	72 19                	jb     801e18 <__udivdi3+0xfc>
  801dff:	74 0b                	je     801e0c <__udivdi3+0xf0>
  801e01:	89 d8                	mov    %ebx,%eax
  801e03:	31 ff                	xor    %edi,%edi
  801e05:	e9 58 ff ff ff       	jmp    801d62 <__udivdi3+0x46>
  801e0a:	66 90                	xchg   %ax,%ax
  801e0c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e10:	89 f9                	mov    %edi,%ecx
  801e12:	d3 e2                	shl    %cl,%edx
  801e14:	39 c2                	cmp    %eax,%edx
  801e16:	73 e9                	jae    801e01 <__udivdi3+0xe5>
  801e18:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e1b:	31 ff                	xor    %edi,%edi
  801e1d:	e9 40 ff ff ff       	jmp    801d62 <__udivdi3+0x46>
  801e22:	66 90                	xchg   %ax,%ax
  801e24:	31 c0                	xor    %eax,%eax
  801e26:	e9 37 ff ff ff       	jmp    801d62 <__udivdi3+0x46>
  801e2b:	90                   	nop

00801e2c <__umoddi3>:
  801e2c:	55                   	push   %ebp
  801e2d:	57                   	push   %edi
  801e2e:	56                   	push   %esi
  801e2f:	53                   	push   %ebx
  801e30:	83 ec 1c             	sub    $0x1c,%esp
  801e33:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e37:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e3f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e4b:	89 f3                	mov    %esi,%ebx
  801e4d:	89 fa                	mov    %edi,%edx
  801e4f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e53:	89 34 24             	mov    %esi,(%esp)
  801e56:	85 c0                	test   %eax,%eax
  801e58:	75 1a                	jne    801e74 <__umoddi3+0x48>
  801e5a:	39 f7                	cmp    %esi,%edi
  801e5c:	0f 86 a2 00 00 00    	jbe    801f04 <__umoddi3+0xd8>
  801e62:	89 c8                	mov    %ecx,%eax
  801e64:	89 f2                	mov    %esi,%edx
  801e66:	f7 f7                	div    %edi
  801e68:	89 d0                	mov    %edx,%eax
  801e6a:	31 d2                	xor    %edx,%edx
  801e6c:	83 c4 1c             	add    $0x1c,%esp
  801e6f:	5b                   	pop    %ebx
  801e70:	5e                   	pop    %esi
  801e71:	5f                   	pop    %edi
  801e72:	5d                   	pop    %ebp
  801e73:	c3                   	ret    
  801e74:	39 f0                	cmp    %esi,%eax
  801e76:	0f 87 ac 00 00 00    	ja     801f28 <__umoddi3+0xfc>
  801e7c:	0f bd e8             	bsr    %eax,%ebp
  801e7f:	83 f5 1f             	xor    $0x1f,%ebp
  801e82:	0f 84 ac 00 00 00    	je     801f34 <__umoddi3+0x108>
  801e88:	bf 20 00 00 00       	mov    $0x20,%edi
  801e8d:	29 ef                	sub    %ebp,%edi
  801e8f:	89 fe                	mov    %edi,%esi
  801e91:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e95:	89 e9                	mov    %ebp,%ecx
  801e97:	d3 e0                	shl    %cl,%eax
  801e99:	89 d7                	mov    %edx,%edi
  801e9b:	89 f1                	mov    %esi,%ecx
  801e9d:	d3 ef                	shr    %cl,%edi
  801e9f:	09 c7                	or     %eax,%edi
  801ea1:	89 e9                	mov    %ebp,%ecx
  801ea3:	d3 e2                	shl    %cl,%edx
  801ea5:	89 14 24             	mov    %edx,(%esp)
  801ea8:	89 d8                	mov    %ebx,%eax
  801eaa:	d3 e0                	shl    %cl,%eax
  801eac:	89 c2                	mov    %eax,%edx
  801eae:	8b 44 24 08          	mov    0x8(%esp),%eax
  801eb2:	d3 e0                	shl    %cl,%eax
  801eb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ebc:	89 f1                	mov    %esi,%ecx
  801ebe:	d3 e8                	shr    %cl,%eax
  801ec0:	09 d0                	or     %edx,%eax
  801ec2:	d3 eb                	shr    %cl,%ebx
  801ec4:	89 da                	mov    %ebx,%edx
  801ec6:	f7 f7                	div    %edi
  801ec8:	89 d3                	mov    %edx,%ebx
  801eca:	f7 24 24             	mull   (%esp)
  801ecd:	89 c6                	mov    %eax,%esi
  801ecf:	89 d1                	mov    %edx,%ecx
  801ed1:	39 d3                	cmp    %edx,%ebx
  801ed3:	0f 82 87 00 00 00    	jb     801f60 <__umoddi3+0x134>
  801ed9:	0f 84 91 00 00 00    	je     801f70 <__umoddi3+0x144>
  801edf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ee3:	29 f2                	sub    %esi,%edx
  801ee5:	19 cb                	sbb    %ecx,%ebx
  801ee7:	89 d8                	mov    %ebx,%eax
  801ee9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801eed:	d3 e0                	shl    %cl,%eax
  801eef:	89 e9                	mov    %ebp,%ecx
  801ef1:	d3 ea                	shr    %cl,%edx
  801ef3:	09 d0                	or     %edx,%eax
  801ef5:	89 e9                	mov    %ebp,%ecx
  801ef7:	d3 eb                	shr    %cl,%ebx
  801ef9:	89 da                	mov    %ebx,%edx
  801efb:	83 c4 1c             	add    $0x1c,%esp
  801efe:	5b                   	pop    %ebx
  801eff:	5e                   	pop    %esi
  801f00:	5f                   	pop    %edi
  801f01:	5d                   	pop    %ebp
  801f02:	c3                   	ret    
  801f03:	90                   	nop
  801f04:	89 fd                	mov    %edi,%ebp
  801f06:	85 ff                	test   %edi,%edi
  801f08:	75 0b                	jne    801f15 <__umoddi3+0xe9>
  801f0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0f:	31 d2                	xor    %edx,%edx
  801f11:	f7 f7                	div    %edi
  801f13:	89 c5                	mov    %eax,%ebp
  801f15:	89 f0                	mov    %esi,%eax
  801f17:	31 d2                	xor    %edx,%edx
  801f19:	f7 f5                	div    %ebp
  801f1b:	89 c8                	mov    %ecx,%eax
  801f1d:	f7 f5                	div    %ebp
  801f1f:	89 d0                	mov    %edx,%eax
  801f21:	e9 44 ff ff ff       	jmp    801e6a <__umoddi3+0x3e>
  801f26:	66 90                	xchg   %ax,%ax
  801f28:	89 c8                	mov    %ecx,%eax
  801f2a:	89 f2                	mov    %esi,%edx
  801f2c:	83 c4 1c             	add    $0x1c,%esp
  801f2f:	5b                   	pop    %ebx
  801f30:	5e                   	pop    %esi
  801f31:	5f                   	pop    %edi
  801f32:	5d                   	pop    %ebp
  801f33:	c3                   	ret    
  801f34:	3b 04 24             	cmp    (%esp),%eax
  801f37:	72 06                	jb     801f3f <__umoddi3+0x113>
  801f39:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f3d:	77 0f                	ja     801f4e <__umoddi3+0x122>
  801f3f:	89 f2                	mov    %esi,%edx
  801f41:	29 f9                	sub    %edi,%ecx
  801f43:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f47:	89 14 24             	mov    %edx,(%esp)
  801f4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f52:	8b 14 24             	mov    (%esp),%edx
  801f55:	83 c4 1c             	add    $0x1c,%esp
  801f58:	5b                   	pop    %ebx
  801f59:	5e                   	pop    %esi
  801f5a:	5f                   	pop    %edi
  801f5b:	5d                   	pop    %ebp
  801f5c:	c3                   	ret    
  801f5d:	8d 76 00             	lea    0x0(%esi),%esi
  801f60:	2b 04 24             	sub    (%esp),%eax
  801f63:	19 fa                	sbb    %edi,%edx
  801f65:	89 d1                	mov    %edx,%ecx
  801f67:	89 c6                	mov    %eax,%esi
  801f69:	e9 71 ff ff ff       	jmp    801edf <__umoddi3+0xb3>
  801f6e:	66 90                	xchg   %ax,%ax
  801f70:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f74:	72 ea                	jb     801f60 <__umoddi3+0x134>
  801f76:	89 d9                	mov    %ebx,%ecx
  801f78:	e9 62 ff ff ff       	jmp    801edf <__umoddi3+0xb3>
