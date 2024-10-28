
obj/user/MidTermEx_ProcessA:     file format elf32-i386


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
  800031:	e8 48 01 00 00       	call   80017e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 48             	sub    $0x48,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 22 15 00 00       	call   801565 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 00 1e 80 00       	push   $0x801e00
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 6b 11 00 00       	call   8011c1 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 02 1e 80 00       	push   $0x801e02
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 55 11 00 00       	call   8011c1 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 09 1e 80 00       	push   $0x801e09
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 3f 11 00 00       	call   8011c1 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 04 15 00 00       	call   801598 <sys_get_virtual_time>
  800094:	83 c4 0c             	add    $0xc,%esp
  800097:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80009a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	f7 f1                	div    %ecx
  8000a6:	89 d0                	mov    %edx,%eax
  8000a8:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	50                   	push   %eax
  8000b7:	e8 43 18 00 00       	call   8018ff <env_sleep>
  8000bc:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Y = (*X) * 2 ;
  8000bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	01 c0                	add    %eax,%eax
  8000c6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 c3 14 00 00       	call   801598 <sys_get_virtual_time>
  8000d5:	83 c4 0c             	add    $0xc,%esp
  8000d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000db:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e5:	f7 f1                	div    %ecx
  8000e7:	89 d0                	mov    %edx,%eax
  8000e9:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 02 18 00 00       	call   8018ff <env_sleep>
  8000fd:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Y ;
  800100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800103:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800106:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800108:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 84 14 00 00       	call   801598 <sys_get_virtual_time>
  800114:	83 c4 0c             	add    $0xc,%esp
  800117:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80011a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80011f:	ba 00 00 00 00       	mov    $0x0,%edx
  800124:	f7 f1                	div    %ecx
  800126:	89 d0                	mov    %edx,%eax
  800128:	05 d0 07 00 00       	add    $0x7d0,%eax
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  800130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	50                   	push   %eax
  800137:	e8 c3 17 00 00       	call   8018ff <env_sleep>
  80013c:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	struct semaphore T ;

	if (*useSem == 1)
  80013f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800142:	8b 00                	mov    (%eax),%eax
  800144:	83 f8 01             	cmp    $0x1,%eax
  800147:	75 25                	jne    80016e <_main+0x136>
	{
		T = get_semaphore(parentenvID, "T");
  800149:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  80014c:	83 ec 04             	sub    $0x4,%esp
  80014f:	68 17 1e 80 00       	push   $0x801e17
  800154:	ff 75 f4             	pushl  -0xc(%ebp)
  800157:	50                   	push   %eax
  800158:	e8 49 17 00 00       	call   8018a6 <get_semaphore>
  80015d:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(T);
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	ff 75 c4             	pushl  -0x3c(%ebp)
  800166:	e8 6f 17 00 00       	call   8018da <signal_semaphore>
  80016b:	83 c4 10             	add    $0x10,%esp
	}

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80016e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800171:	8b 00                	mov    (%eax),%eax
  800173:	8d 50 01             	lea    0x1(%eax),%edx
  800176:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800179:	89 10                	mov    %edx,(%eax)

}
  80017b:	90                   	nop
  80017c:	c9                   	leave  
  80017d:	c3                   	ret    

0080017e <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800184:	e8 c3 13 00 00       	call   80154c <sys_getenvindex>
  800189:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80018c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018f:	89 d0                	mov    %edx,%eax
  800191:	c1 e0 06             	shl    $0x6,%eax
  800194:	29 d0                	sub    %edx,%eax
  800196:	c1 e0 02             	shl    $0x2,%eax
  800199:	01 d0                	add    %edx,%eax
  80019b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001a2:	01 c8                	add    %ecx,%eax
  8001a4:	c1 e0 03             	shl    $0x3,%eax
  8001a7:	01 d0                	add    %edx,%eax
  8001a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b0:	29 c2                	sub    %eax,%edx
  8001b2:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8001b9:	89 c2                	mov    %eax,%edx
  8001bb:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001c1:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c6:	a1 04 30 80 00       	mov    0x803004,%eax
  8001cb:	8a 40 20             	mov    0x20(%eax),%al
  8001ce:	84 c0                	test   %al,%al
  8001d0:	74 0d                	je     8001df <libmain+0x61>
		binaryname = myEnv->prog_name;
  8001d2:	a1 04 30 80 00       	mov    0x803004,%eax
  8001d7:	83 c0 20             	add    $0x20,%eax
  8001da:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e3:	7e 0a                	jle    8001ef <libmain+0x71>
		binaryname = argv[0];
  8001e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e8:	8b 00                	mov    (%eax),%eax
  8001ea:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 0c             	pushl  0xc(%ebp)
  8001f5:	ff 75 08             	pushl  0x8(%ebp)
  8001f8:	e8 3b fe ff ff       	call   800038 <_main>
  8001fd:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800200:	e8 cb 10 00 00       	call   8012d0 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 34 1e 80 00       	push   $0x801e34
  80020d:	e8 8d 01 00 00       	call   80039f <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800215:	a1 04 30 80 00       	mov    0x803004,%eax
  80021a:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800220:	a1 04 30 80 00       	mov    0x803004,%eax
  800225:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80022b:	83 ec 04             	sub    $0x4,%esp
  80022e:	52                   	push   %edx
  80022f:	50                   	push   %eax
  800230:	68 5c 1e 80 00       	push   $0x801e5c
  800235:	e8 65 01 00 00       	call   80039f <cprintf>
  80023a:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80023d:	a1 04 30 80 00       	mov    0x803004,%eax
  800242:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800248:	a1 04 30 80 00       	mov    0x803004,%eax
  80024d:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800253:	a1 04 30 80 00       	mov    0x803004,%eax
  800258:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80025e:	51                   	push   %ecx
  80025f:	52                   	push   %edx
  800260:	50                   	push   %eax
  800261:	68 84 1e 80 00       	push   $0x801e84
  800266:	e8 34 01 00 00       	call   80039f <cprintf>
  80026b:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80026e:	a1 04 30 80 00       	mov    0x803004,%eax
  800273:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800279:	83 ec 08             	sub    $0x8,%esp
  80027c:	50                   	push   %eax
  80027d:	68 dc 1e 80 00       	push   $0x801edc
  800282:	e8 18 01 00 00       	call   80039f <cprintf>
  800287:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	68 34 1e 80 00       	push   $0x801e34
  800292:	e8 08 01 00 00       	call   80039f <cprintf>
  800297:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80029a:	e8 4b 10 00 00       	call   8012ea <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80029f:	e8 19 00 00 00       	call   8002bd <exit>
}
  8002a4:	90                   	nop
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	6a 00                	push   $0x0
  8002b2:	e8 61 12 00 00       	call   801518 <sys_destroy_env>
  8002b7:	83 c4 10             	add    $0x10,%esp
}
  8002ba:	90                   	nop
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    

008002bd <exit>:

void
exit(void)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c3:	e8 b6 12 00 00       	call   80157e <sys_exit_env>
}
  8002c8:	90                   	nop
  8002c9:	c9                   	leave  
  8002ca:	c3                   	ret    

008002cb <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002cb:	55                   	push   %ebp
  8002cc:	89 e5                	mov    %esp,%ebp
  8002ce:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d4:	8b 00                	mov    (%eax),%eax
  8002d6:	8d 48 01             	lea    0x1(%eax),%ecx
  8002d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dc:	89 0a                	mov    %ecx,(%edx)
  8002de:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e1:	88 d1                	mov    %dl,%cl
  8002e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ed:	8b 00                	mov    (%eax),%eax
  8002ef:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002f4:	75 2c                	jne    800322 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002f6:	a0 08 30 80 00       	mov    0x803008,%al
  8002fb:	0f b6 c0             	movzbl %al,%eax
  8002fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800301:	8b 12                	mov    (%edx),%edx
  800303:	89 d1                	mov    %edx,%ecx
  800305:	8b 55 0c             	mov    0xc(%ebp),%edx
  800308:	83 c2 08             	add    $0x8,%edx
  80030b:	83 ec 04             	sub    $0x4,%esp
  80030e:	50                   	push   %eax
  80030f:	51                   	push   %ecx
  800310:	52                   	push   %edx
  800311:	e8 78 0f 00 00       	call   80128e <sys_cputs>
  800316:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800319:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800322:	8b 45 0c             	mov    0xc(%ebp),%eax
  800325:	8b 40 04             	mov    0x4(%eax),%eax
  800328:	8d 50 01             	lea    0x1(%eax),%edx
  80032b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800331:	90                   	nop
  800332:	c9                   	leave  
  800333:	c3                   	ret    

00800334 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800334:	55                   	push   %ebp
  800335:	89 e5                	mov    %esp,%ebp
  800337:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80033d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800344:	00 00 00 
	b.cnt = 0;
  800347:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80034e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800351:	ff 75 0c             	pushl  0xc(%ebp)
  800354:	ff 75 08             	pushl  0x8(%ebp)
  800357:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80035d:	50                   	push   %eax
  80035e:	68 cb 02 80 00       	push   $0x8002cb
  800363:	e8 11 02 00 00       	call   800579 <vprintfmt>
  800368:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80036b:	a0 08 30 80 00       	mov    0x803008,%al
  800370:	0f b6 c0             	movzbl %al,%eax
  800373:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800379:	83 ec 04             	sub    $0x4,%esp
  80037c:	50                   	push   %eax
  80037d:	52                   	push   %edx
  80037e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800384:	83 c0 08             	add    $0x8,%eax
  800387:	50                   	push   %eax
  800388:	e8 01 0f 00 00       	call   80128e <sys_cputs>
  80038d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800390:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800397:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003a5:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8003ac:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	83 ec 08             	sub    $0x8,%esp
  8003b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8003bb:	50                   	push   %eax
  8003bc:	e8 73 ff ff ff       	call   800334 <vcprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp
  8003c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003ca:	c9                   	leave  
  8003cb:	c3                   	ret    

008003cc <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003cc:	55                   	push   %ebp
  8003cd:	89 e5                	mov    %esp,%ebp
  8003cf:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003d2:	e8 f9 0e 00 00       	call   8012d0 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003d7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003da:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e0:	83 ec 08             	sub    $0x8,%esp
  8003e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e6:	50                   	push   %eax
  8003e7:	e8 48 ff ff ff       	call   800334 <vcprintf>
  8003ec:	83 c4 10             	add    $0x10,%esp
  8003ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003f2:	e8 f3 0e 00 00       	call   8012ea <sys_unlock_cons>
	return cnt;
  8003f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003fa:	c9                   	leave  
  8003fb:	c3                   	ret    

008003fc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	53                   	push   %ebx
  800400:	83 ec 14             	sub    $0x14,%esp
  800403:	8b 45 10             	mov    0x10(%ebp),%eax
  800406:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800409:	8b 45 14             	mov    0x14(%ebp),%eax
  80040c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80040f:	8b 45 18             	mov    0x18(%ebp),%eax
  800412:	ba 00 00 00 00       	mov    $0x0,%edx
  800417:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80041a:	77 55                	ja     800471 <printnum+0x75>
  80041c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80041f:	72 05                	jb     800426 <printnum+0x2a>
  800421:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800424:	77 4b                	ja     800471 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800426:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800429:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80042c:	8b 45 18             	mov    0x18(%ebp),%eax
  80042f:	ba 00 00 00 00       	mov    $0x0,%edx
  800434:	52                   	push   %edx
  800435:	50                   	push   %eax
  800436:	ff 75 f4             	pushl  -0xc(%ebp)
  800439:	ff 75 f0             	pushl  -0x10(%ebp)
  80043c:	e8 5b 17 00 00       	call   801b9c <__udivdi3>
  800441:	83 c4 10             	add    $0x10,%esp
  800444:	83 ec 04             	sub    $0x4,%esp
  800447:	ff 75 20             	pushl  0x20(%ebp)
  80044a:	53                   	push   %ebx
  80044b:	ff 75 18             	pushl  0x18(%ebp)
  80044e:	52                   	push   %edx
  80044f:	50                   	push   %eax
  800450:	ff 75 0c             	pushl  0xc(%ebp)
  800453:	ff 75 08             	pushl  0x8(%ebp)
  800456:	e8 a1 ff ff ff       	call   8003fc <printnum>
  80045b:	83 c4 20             	add    $0x20,%esp
  80045e:	eb 1a                	jmp    80047a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	ff 75 0c             	pushl  0xc(%ebp)
  800466:	ff 75 20             	pushl  0x20(%ebp)
  800469:	8b 45 08             	mov    0x8(%ebp),%eax
  80046c:	ff d0                	call   *%eax
  80046e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800471:	ff 4d 1c             	decl   0x1c(%ebp)
  800474:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800478:	7f e6                	jg     800460 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80047a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80047d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800485:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800488:	53                   	push   %ebx
  800489:	51                   	push   %ecx
  80048a:	52                   	push   %edx
  80048b:	50                   	push   %eax
  80048c:	e8 1b 18 00 00       	call   801cac <__umoddi3>
  800491:	83 c4 10             	add    $0x10,%esp
  800494:	05 14 21 80 00       	add    $0x802114,%eax
  800499:	8a 00                	mov    (%eax),%al
  80049b:	0f be c0             	movsbl %al,%eax
  80049e:	83 ec 08             	sub    $0x8,%esp
  8004a1:	ff 75 0c             	pushl  0xc(%ebp)
  8004a4:	50                   	push   %eax
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	ff d0                	call   *%eax
  8004aa:	83 c4 10             	add    $0x10,%esp
}
  8004ad:	90                   	nop
  8004ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004b1:	c9                   	leave  
  8004b2:	c3                   	ret    

008004b3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004b6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ba:	7e 1c                	jle    8004d8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	8d 50 08             	lea    0x8(%eax),%edx
  8004c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c7:	89 10                	mov    %edx,(%eax)
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	83 e8 08             	sub    $0x8,%eax
  8004d1:	8b 50 04             	mov    0x4(%eax),%edx
  8004d4:	8b 00                	mov    (%eax),%eax
  8004d6:	eb 40                	jmp    800518 <getuint+0x65>
	else if (lflag)
  8004d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004dc:	74 1e                	je     8004fc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004de:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e1:	8b 00                	mov    (%eax),%eax
  8004e3:	8d 50 04             	lea    0x4(%eax),%edx
  8004e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e9:	89 10                	mov    %edx,(%eax)
  8004eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	83 e8 04             	sub    $0x4,%eax
  8004f3:	8b 00                	mov    (%eax),%eax
  8004f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fa:	eb 1c                	jmp    800518 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ff:	8b 00                	mov    (%eax),%eax
  800501:	8d 50 04             	lea    0x4(%eax),%edx
  800504:	8b 45 08             	mov    0x8(%ebp),%eax
  800507:	89 10                	mov    %edx,(%eax)
  800509:	8b 45 08             	mov    0x8(%ebp),%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	83 e8 04             	sub    $0x4,%eax
  800511:	8b 00                	mov    (%eax),%eax
  800513:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800518:	5d                   	pop    %ebp
  800519:	c3                   	ret    

0080051a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80051d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800521:	7e 1c                	jle    80053f <getint+0x25>
		return va_arg(*ap, long long);
  800523:	8b 45 08             	mov    0x8(%ebp),%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	8d 50 08             	lea    0x8(%eax),%edx
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	89 10                	mov    %edx,(%eax)
  800530:	8b 45 08             	mov    0x8(%ebp),%eax
  800533:	8b 00                	mov    (%eax),%eax
  800535:	83 e8 08             	sub    $0x8,%eax
  800538:	8b 50 04             	mov    0x4(%eax),%edx
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	eb 38                	jmp    800577 <getint+0x5d>
	else if (lflag)
  80053f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800543:	74 1a                	je     80055f <getint+0x45>
		return va_arg(*ap, long);
  800545:	8b 45 08             	mov    0x8(%ebp),%eax
  800548:	8b 00                	mov    (%eax),%eax
  80054a:	8d 50 04             	lea    0x4(%eax),%edx
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	89 10                	mov    %edx,(%eax)
  800552:	8b 45 08             	mov    0x8(%ebp),%eax
  800555:	8b 00                	mov    (%eax),%eax
  800557:	83 e8 04             	sub    $0x4,%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	99                   	cltd   
  80055d:	eb 18                	jmp    800577 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	8b 00                	mov    (%eax),%eax
  800564:	8d 50 04             	lea    0x4(%eax),%edx
  800567:	8b 45 08             	mov    0x8(%ebp),%eax
  80056a:	89 10                	mov    %edx,(%eax)
  80056c:	8b 45 08             	mov    0x8(%ebp),%eax
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	83 e8 04             	sub    $0x4,%eax
  800574:	8b 00                	mov    (%eax),%eax
  800576:	99                   	cltd   
}
  800577:	5d                   	pop    %ebp
  800578:	c3                   	ret    

00800579 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800579:	55                   	push   %ebp
  80057a:	89 e5                	mov    %esp,%ebp
  80057c:	56                   	push   %esi
  80057d:	53                   	push   %ebx
  80057e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800581:	eb 17                	jmp    80059a <vprintfmt+0x21>
			if (ch == '\0')
  800583:	85 db                	test   %ebx,%ebx
  800585:	0f 84 c1 03 00 00    	je     80094c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80058b:	83 ec 08             	sub    $0x8,%esp
  80058e:	ff 75 0c             	pushl  0xc(%ebp)
  800591:	53                   	push   %ebx
  800592:	8b 45 08             	mov    0x8(%ebp),%eax
  800595:	ff d0                	call   *%eax
  800597:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80059a:	8b 45 10             	mov    0x10(%ebp),%eax
  80059d:	8d 50 01             	lea    0x1(%eax),%edx
  8005a0:	89 55 10             	mov    %edx,0x10(%ebp)
  8005a3:	8a 00                	mov    (%eax),%al
  8005a5:	0f b6 d8             	movzbl %al,%ebx
  8005a8:	83 fb 25             	cmp    $0x25,%ebx
  8005ab:	75 d6                	jne    800583 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005ad:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005b1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005b8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005bf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005c6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d0:	8d 50 01             	lea    0x1(%eax),%edx
  8005d3:	89 55 10             	mov    %edx,0x10(%ebp)
  8005d6:	8a 00                	mov    (%eax),%al
  8005d8:	0f b6 d8             	movzbl %al,%ebx
  8005db:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005de:	83 f8 5b             	cmp    $0x5b,%eax
  8005e1:	0f 87 3d 03 00 00    	ja     800924 <vprintfmt+0x3ab>
  8005e7:	8b 04 85 38 21 80 00 	mov    0x802138(,%eax,4),%eax
  8005ee:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005f0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005f4:	eb d7                	jmp    8005cd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005f6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005fa:	eb d1                	jmp    8005cd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800603:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800606:	89 d0                	mov    %edx,%eax
  800608:	c1 e0 02             	shl    $0x2,%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	01 c0                	add    %eax,%eax
  80060f:	01 d8                	add    %ebx,%eax
  800611:	83 e8 30             	sub    $0x30,%eax
  800614:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800617:	8b 45 10             	mov    0x10(%ebp),%eax
  80061a:	8a 00                	mov    (%eax),%al
  80061c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80061f:	83 fb 2f             	cmp    $0x2f,%ebx
  800622:	7e 3e                	jle    800662 <vprintfmt+0xe9>
  800624:	83 fb 39             	cmp    $0x39,%ebx
  800627:	7f 39                	jg     800662 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800629:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80062c:	eb d5                	jmp    800603 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	83 c0 04             	add    $0x4,%eax
  800634:	89 45 14             	mov    %eax,0x14(%ebp)
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	83 e8 04             	sub    $0x4,%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800642:	eb 1f                	jmp    800663 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800644:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800648:	79 83                	jns    8005cd <vprintfmt+0x54>
				width = 0;
  80064a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800651:	e9 77 ff ff ff       	jmp    8005cd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800656:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80065d:	e9 6b ff ff ff       	jmp    8005cd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800662:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800663:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800667:	0f 89 60 ff ff ff    	jns    8005cd <vprintfmt+0x54>
				width = precision, precision = -1;
  80066d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800670:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800673:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80067a:	e9 4e ff ff ff       	jmp    8005cd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80067f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800682:	e9 46 ff ff ff       	jmp    8005cd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	83 c0 04             	add    $0x4,%eax
  80068d:	89 45 14             	mov    %eax,0x14(%ebp)
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	83 e8 04             	sub    $0x4,%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	ff 75 0c             	pushl  0xc(%ebp)
  80069e:	50                   	push   %eax
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	ff d0                	call   *%eax
  8006a4:	83 c4 10             	add    $0x10,%esp
			break;
  8006a7:	e9 9b 02 00 00       	jmp    800947 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	83 c0 04             	add    $0x4,%eax
  8006b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	83 e8 04             	sub    $0x4,%eax
  8006bb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006bd:	85 db                	test   %ebx,%ebx
  8006bf:	79 02                	jns    8006c3 <vprintfmt+0x14a>
				err = -err;
  8006c1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006c3:	83 fb 64             	cmp    $0x64,%ebx
  8006c6:	7f 0b                	jg     8006d3 <vprintfmt+0x15a>
  8006c8:	8b 34 9d 80 1f 80 00 	mov    0x801f80(,%ebx,4),%esi
  8006cf:	85 f6                	test   %esi,%esi
  8006d1:	75 19                	jne    8006ec <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006d3:	53                   	push   %ebx
  8006d4:	68 25 21 80 00       	push   $0x802125
  8006d9:	ff 75 0c             	pushl  0xc(%ebp)
  8006dc:	ff 75 08             	pushl  0x8(%ebp)
  8006df:	e8 70 02 00 00       	call   800954 <printfmt>
  8006e4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006e7:	e9 5b 02 00 00       	jmp    800947 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006ec:	56                   	push   %esi
  8006ed:	68 2e 21 80 00       	push   $0x80212e
  8006f2:	ff 75 0c             	pushl  0xc(%ebp)
  8006f5:	ff 75 08             	pushl  0x8(%ebp)
  8006f8:	e8 57 02 00 00       	call   800954 <printfmt>
  8006fd:	83 c4 10             	add    $0x10,%esp
			break;
  800700:	e9 42 02 00 00       	jmp    800947 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	83 c0 04             	add    $0x4,%eax
  80070b:	89 45 14             	mov    %eax,0x14(%ebp)
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	83 e8 04             	sub    $0x4,%eax
  800714:	8b 30                	mov    (%eax),%esi
  800716:	85 f6                	test   %esi,%esi
  800718:	75 05                	jne    80071f <vprintfmt+0x1a6>
				p = "(null)";
  80071a:	be 31 21 80 00       	mov    $0x802131,%esi
			if (width > 0 && padc != '-')
  80071f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800723:	7e 6d                	jle    800792 <vprintfmt+0x219>
  800725:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800729:	74 67                	je     800792 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80072b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	50                   	push   %eax
  800732:	56                   	push   %esi
  800733:	e8 1e 03 00 00       	call   800a56 <strnlen>
  800738:	83 c4 10             	add    $0x10,%esp
  80073b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80073e:	eb 16                	jmp    800756 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800740:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	50                   	push   %eax
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	ff d0                	call   *%eax
  800750:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800753:	ff 4d e4             	decl   -0x1c(%ebp)
  800756:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80075a:	7f e4                	jg     800740 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80075c:	eb 34                	jmp    800792 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80075e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800762:	74 1c                	je     800780 <vprintfmt+0x207>
  800764:	83 fb 1f             	cmp    $0x1f,%ebx
  800767:	7e 05                	jle    80076e <vprintfmt+0x1f5>
  800769:	83 fb 7e             	cmp    $0x7e,%ebx
  80076c:	7e 12                	jle    800780 <vprintfmt+0x207>
					putch('?', putdat);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 0c             	pushl  0xc(%ebp)
  800774:	6a 3f                	push   $0x3f
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	ff d0                	call   *%eax
  80077b:	83 c4 10             	add    $0x10,%esp
  80077e:	eb 0f                	jmp    80078f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	ff 75 0c             	pushl  0xc(%ebp)
  800786:	53                   	push   %ebx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	ff d0                	call   *%eax
  80078c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80078f:	ff 4d e4             	decl   -0x1c(%ebp)
  800792:	89 f0                	mov    %esi,%eax
  800794:	8d 70 01             	lea    0x1(%eax),%esi
  800797:	8a 00                	mov    (%eax),%al
  800799:	0f be d8             	movsbl %al,%ebx
  80079c:	85 db                	test   %ebx,%ebx
  80079e:	74 24                	je     8007c4 <vprintfmt+0x24b>
  8007a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007a4:	78 b8                	js     80075e <vprintfmt+0x1e5>
  8007a6:	ff 4d e0             	decl   -0x20(%ebp)
  8007a9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007ad:	79 af                	jns    80075e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007af:	eb 13                	jmp    8007c4 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	ff 75 0c             	pushl  0xc(%ebp)
  8007b7:	6a 20                	push   $0x20
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	ff d0                	call   *%eax
  8007be:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007c1:	ff 4d e4             	decl   -0x1c(%ebp)
  8007c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c8:	7f e7                	jg     8007b1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007ca:	e9 78 01 00 00       	jmp    800947 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d8:	50                   	push   %eax
  8007d9:	e8 3c fd ff ff       	call   80051a <getint>
  8007de:	83 c4 10             	add    $0x10,%esp
  8007e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ed:	85 d2                	test   %edx,%edx
  8007ef:	79 23                	jns    800814 <vprintfmt+0x29b>
				putch('-', putdat);
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 0c             	pushl  0xc(%ebp)
  8007f7:	6a 2d                	push   $0x2d
  8007f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fc:	ff d0                	call   *%eax
  8007fe:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800804:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800807:	f7 d8                	neg    %eax
  800809:	83 d2 00             	adc    $0x0,%edx
  80080c:	f7 da                	neg    %edx
  80080e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800811:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800814:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081b:	e9 bc 00 00 00       	jmp    8008dc <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 e8             	pushl  -0x18(%ebp)
  800826:	8d 45 14             	lea    0x14(%ebp),%eax
  800829:	50                   	push   %eax
  80082a:	e8 84 fc ff ff       	call   8004b3 <getuint>
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800835:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800838:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80083f:	e9 98 00 00 00       	jmp    8008dc <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	ff 75 0c             	pushl  0xc(%ebp)
  80084a:	6a 58                	push   $0x58
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	ff d0                	call   *%eax
  800851:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800854:	83 ec 08             	sub    $0x8,%esp
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	6a 58                	push   $0x58
  80085c:	8b 45 08             	mov    0x8(%ebp),%eax
  80085f:	ff d0                	call   *%eax
  800861:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800864:	83 ec 08             	sub    $0x8,%esp
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	6a 58                	push   $0x58
  80086c:	8b 45 08             	mov    0x8(%ebp),%eax
  80086f:	ff d0                	call   *%eax
  800871:	83 c4 10             	add    $0x10,%esp
			break;
  800874:	e9 ce 00 00 00       	jmp    800947 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	ff 75 0c             	pushl  0xc(%ebp)
  80087f:	6a 30                	push   $0x30
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	ff d0                	call   *%eax
  800886:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	6a 78                	push   $0x78
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	ff d0                	call   *%eax
  800896:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	83 c0 04             	add    $0x4,%eax
  80089f:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	83 e8 04             	sub    $0x4,%eax
  8008a8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008b4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008bb:	eb 1f                	jmp    8008dc <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	ff 75 e8             	pushl  -0x18(%ebp)
  8008c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008c6:	50                   	push   %eax
  8008c7:	e8 e7 fb ff ff       	call   8004b3 <getuint>
  8008cc:	83 c4 10             	add    $0x10,%esp
  8008cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008d5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008dc:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e3:	83 ec 04             	sub    $0x4,%esp
  8008e6:	52                   	push   %edx
  8008e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008ea:	50                   	push   %eax
  8008eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	ff 75 08             	pushl  0x8(%ebp)
  8008f7:	e8 00 fb ff ff       	call   8003fc <printnum>
  8008fc:	83 c4 20             	add    $0x20,%esp
			break;
  8008ff:	eb 46                	jmp    800947 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800901:	83 ec 08             	sub    $0x8,%esp
  800904:	ff 75 0c             	pushl  0xc(%ebp)
  800907:	53                   	push   %ebx
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	ff d0                	call   *%eax
  80090d:	83 c4 10             	add    $0x10,%esp
			break;
  800910:	eb 35                	jmp    800947 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800912:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800919:	eb 2c                	jmp    800947 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80091b:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800922:	eb 23                	jmp    800947 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	6a 25                	push   $0x25
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	ff d0                	call   *%eax
  800931:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800934:	ff 4d 10             	decl   0x10(%ebp)
  800937:	eb 03                	jmp    80093c <vprintfmt+0x3c3>
  800939:	ff 4d 10             	decl   0x10(%ebp)
  80093c:	8b 45 10             	mov    0x10(%ebp),%eax
  80093f:	48                   	dec    %eax
  800940:	8a 00                	mov    (%eax),%al
  800942:	3c 25                	cmp    $0x25,%al
  800944:	75 f3                	jne    800939 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800946:	90                   	nop
		}
	}
  800947:	e9 35 fc ff ff       	jmp    800581 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80094c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80094d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800950:	5b                   	pop    %ebx
  800951:	5e                   	pop    %esi
  800952:	5d                   	pop    %ebp
  800953:	c3                   	ret    

00800954 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80095a:	8d 45 10             	lea    0x10(%ebp),%eax
  80095d:	83 c0 04             	add    $0x4,%eax
  800960:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800963:	8b 45 10             	mov    0x10(%ebp),%eax
  800966:	ff 75 f4             	pushl  -0xc(%ebp)
  800969:	50                   	push   %eax
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	ff 75 08             	pushl  0x8(%ebp)
  800970:	e8 04 fc ff ff       	call   800579 <vprintfmt>
  800975:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800978:	90                   	nop
  800979:	c9                   	leave  
  80097a:	c3                   	ret    

0080097b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80097e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800981:	8b 40 08             	mov    0x8(%eax),%eax
  800984:	8d 50 01             	lea    0x1(%eax),%edx
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80098d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800990:	8b 10                	mov    (%eax),%edx
  800992:	8b 45 0c             	mov    0xc(%ebp),%eax
  800995:	8b 40 04             	mov    0x4(%eax),%eax
  800998:	39 c2                	cmp    %eax,%edx
  80099a:	73 12                	jae    8009ae <sprintputch+0x33>
		*b->buf++ = ch;
  80099c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099f:	8b 00                	mov    (%eax),%eax
  8009a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8009a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a7:	89 0a                	mov    %ecx,(%edx)
  8009a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8009ac:	88 10                	mov    %dl,(%eax)
}
  8009ae:	90                   	nop
  8009af:	5d                   	pop    %ebp
  8009b0:	c3                   	ret    

008009b1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	01 d0                	add    %edx,%eax
  8009c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009d6:	74 06                	je     8009de <vsnprintf+0x2d>
  8009d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009dc:	7f 07                	jg     8009e5 <vsnprintf+0x34>
		return -E_INVAL;
  8009de:	b8 03 00 00 00       	mov    $0x3,%eax
  8009e3:	eb 20                	jmp    800a05 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009e5:	ff 75 14             	pushl  0x14(%ebp)
  8009e8:	ff 75 10             	pushl  0x10(%ebp)
  8009eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009ee:	50                   	push   %eax
  8009ef:	68 7b 09 80 00       	push   $0x80097b
  8009f4:	e8 80 fb ff ff       	call   800579 <vprintfmt>
  8009f9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ff:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a05:	c9                   	leave  
  800a06:	c3                   	ret    

00800a07 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a0d:	8d 45 10             	lea    0x10(%ebp),%eax
  800a10:	83 c0 04             	add    $0x4,%eax
  800a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a16:	8b 45 10             	mov    0x10(%ebp),%eax
  800a19:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1c:	50                   	push   %eax
  800a1d:	ff 75 0c             	pushl  0xc(%ebp)
  800a20:	ff 75 08             	pushl  0x8(%ebp)
  800a23:	e8 89 ff ff ff       	call   8009b1 <vsnprintf>
  800a28:	83 c4 10             	add    $0x10,%esp
  800a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a31:	c9                   	leave  
  800a32:	c3                   	ret    

00800a33 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a40:	eb 06                	jmp    800a48 <strlen+0x15>
		n++;
  800a42:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a45:	ff 45 08             	incl   0x8(%ebp)
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	8a 00                	mov    (%eax),%al
  800a4d:	84 c0                	test   %al,%al
  800a4f:	75 f1                	jne    800a42 <strlen+0xf>
		n++;
	return n;
  800a51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a54:	c9                   	leave  
  800a55:	c3                   	ret    

00800a56 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a63:	eb 09                	jmp    800a6e <strnlen+0x18>
		n++;
  800a65:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a68:	ff 45 08             	incl   0x8(%ebp)
  800a6b:	ff 4d 0c             	decl   0xc(%ebp)
  800a6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a72:	74 09                	je     800a7d <strnlen+0x27>
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	8a 00                	mov    (%eax),%al
  800a79:	84 c0                	test   %al,%al
  800a7b:	75 e8                	jne    800a65 <strnlen+0xf>
		n++;
	return n;
  800a7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a80:	c9                   	leave  
  800a81:	c3                   	ret    

00800a82 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a8e:	90                   	nop
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8d 50 01             	lea    0x1(%eax),%edx
  800a95:	89 55 08             	mov    %edx,0x8(%ebp)
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a9e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aa1:	8a 12                	mov    (%edx),%dl
  800aa3:	88 10                	mov    %dl,(%eax)
  800aa5:	8a 00                	mov    (%eax),%al
  800aa7:	84 c0                	test   %al,%al
  800aa9:	75 e4                	jne    800a8f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800aab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aae:	c9                   	leave  
  800aaf:	c3                   	ret    

00800ab0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800abc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ac3:	eb 1f                	jmp    800ae4 <strncpy+0x34>
		*dst++ = *src;
  800ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac8:	8d 50 01             	lea    0x1(%eax),%edx
  800acb:	89 55 08             	mov    %edx,0x8(%ebp)
  800ace:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad1:	8a 12                	mov    (%edx),%dl
  800ad3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ad5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad8:	8a 00                	mov    (%eax),%al
  800ada:	84 c0                	test   %al,%al
  800adc:	74 03                	je     800ae1 <strncpy+0x31>
			src++;
  800ade:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ae1:	ff 45 fc             	incl   -0x4(%ebp)
  800ae4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ae7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800aea:	72 d9                	jb     800ac5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800aec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800aef:	c9                   	leave  
  800af0:	c3                   	ret    

00800af1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800afd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b01:	74 30                	je     800b33 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b03:	eb 16                	jmp    800b1b <strlcpy+0x2a>
			*dst++ = *src++;
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	8d 50 01             	lea    0x1(%eax),%edx
  800b0b:	89 55 08             	mov    %edx,0x8(%ebp)
  800b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b11:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b14:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b17:	8a 12                	mov    (%edx),%dl
  800b19:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b1b:	ff 4d 10             	decl   0x10(%ebp)
  800b1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b22:	74 09                	je     800b2d <strlcpy+0x3c>
  800b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b27:	8a 00                	mov    (%eax),%al
  800b29:	84 c0                	test   %al,%al
  800b2b:	75 d8                	jne    800b05 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b33:	8b 55 08             	mov    0x8(%ebp),%edx
  800b36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b39:	29 c2                	sub    %eax,%edx
  800b3b:	89 d0                	mov    %edx,%eax
}
  800b3d:	c9                   	leave  
  800b3e:	c3                   	ret    

00800b3f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b42:	eb 06                	jmp    800b4a <strcmp+0xb>
		p++, q++;
  800b44:	ff 45 08             	incl   0x8(%ebp)
  800b47:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	8a 00                	mov    (%eax),%al
  800b4f:	84 c0                	test   %al,%al
  800b51:	74 0e                	je     800b61 <strcmp+0x22>
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8a 10                	mov    (%eax),%dl
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	8a 00                	mov    (%eax),%al
  800b5d:	38 c2                	cmp    %al,%dl
  800b5f:	74 e3                	je     800b44 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	8a 00                	mov    (%eax),%al
  800b66:	0f b6 d0             	movzbl %al,%edx
  800b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6c:	8a 00                	mov    (%eax),%al
  800b6e:	0f b6 c0             	movzbl %al,%eax
  800b71:	29 c2                	sub    %eax,%edx
  800b73:	89 d0                	mov    %edx,%eax
}
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b7a:	eb 09                	jmp    800b85 <strncmp+0xe>
		n--, p++, q++;
  800b7c:	ff 4d 10             	decl   0x10(%ebp)
  800b7f:	ff 45 08             	incl   0x8(%ebp)
  800b82:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b89:	74 17                	je     800ba2 <strncmp+0x2b>
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	8a 00                	mov    (%eax),%al
  800b90:	84 c0                	test   %al,%al
  800b92:	74 0e                	je     800ba2 <strncmp+0x2b>
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	8a 10                	mov    (%eax),%dl
  800b99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9c:	8a 00                	mov    (%eax),%al
  800b9e:	38 c2                	cmp    %al,%dl
  800ba0:	74 da                	je     800b7c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ba2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ba6:	75 07                	jne    800baf <strncmp+0x38>
		return 0;
  800ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bad:	eb 14                	jmp    800bc3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8a 00                	mov    (%eax),%al
  800bb4:	0f b6 d0             	movzbl %al,%edx
  800bb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	0f b6 c0             	movzbl %al,%eax
  800bbf:	29 c2                	sub    %eax,%edx
  800bc1:	89 d0                	mov    %edx,%eax
}
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 04             	sub    $0x4,%esp
  800bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bce:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bd1:	eb 12                	jmp    800be5 <strchr+0x20>
		if (*s == c)
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bdb:	75 05                	jne    800be2 <strchr+0x1d>
			return (char *) s;
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	eb 11                	jmp    800bf3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800be2:	ff 45 08             	incl   0x8(%ebp)
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	8a 00                	mov    (%eax),%al
  800bea:	84 c0                	test   %al,%al
  800bec:	75 e5                	jne    800bd3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf3:	c9                   	leave  
  800bf4:	c3                   	ret    

00800bf5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	83 ec 04             	sub    $0x4,%esp
  800bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c01:	eb 0d                	jmp    800c10 <strfind+0x1b>
		if (*s == c)
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	8a 00                	mov    (%eax),%al
  800c08:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c0b:	74 0e                	je     800c1b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c0d:	ff 45 08             	incl   0x8(%ebp)
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	8a 00                	mov    (%eax),%al
  800c15:	84 c0                	test   %al,%al
  800c17:	75 ea                	jne    800c03 <strfind+0xe>
  800c19:	eb 01                	jmp    800c1c <strfind+0x27>
		if (*s == c)
			break;
  800c1b:	90                   	nop
	return (char *) s;
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c1f:	c9                   	leave  
  800c20:	c3                   	ret    

00800c21 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c30:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c33:	eb 0e                	jmp    800c43 <memset+0x22>
		*p++ = c;
  800c35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c38:	8d 50 01             	lea    0x1(%eax),%edx
  800c3b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c41:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c43:	ff 4d f8             	decl   -0x8(%ebp)
  800c46:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c4a:	79 e9                	jns    800c35 <memset+0x14>
		*p++ = c;

	return v;
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c4f:	c9                   	leave  
  800c50:	c3                   	ret    

00800c51 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c63:	eb 16                	jmp    800c7b <memcpy+0x2a>
		*d++ = *s++;
  800c65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c68:	8d 50 01             	lea    0x1(%eax),%edx
  800c6b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c71:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c74:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c77:	8a 12                	mov    (%edx),%dl
  800c79:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c81:	89 55 10             	mov    %edx,0x10(%ebp)
  800c84:	85 c0                	test   %eax,%eax
  800c86:	75 dd                	jne    800c65 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c8b:	c9                   	leave  
  800c8c:	c3                   	ret    

00800c8d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ca5:	73 50                	jae    800cf7 <memmove+0x6a>
  800ca7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800caa:	8b 45 10             	mov    0x10(%ebp),%eax
  800cad:	01 d0                	add    %edx,%eax
  800caf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cb2:	76 43                	jbe    800cf7 <memmove+0x6a>
		s += n;
  800cb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800cba:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbd:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800cc0:	eb 10                	jmp    800cd2 <memmove+0x45>
			*--d = *--s;
  800cc2:	ff 4d f8             	decl   -0x8(%ebp)
  800cc5:	ff 4d fc             	decl   -0x4(%ebp)
  800cc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccb:	8a 10                	mov    (%eax),%dl
  800ccd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cd0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800cd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd8:	89 55 10             	mov    %edx,0x10(%ebp)
  800cdb:	85 c0                	test   %eax,%eax
  800cdd:	75 e3                	jne    800cc2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cdf:	eb 23                	jmp    800d04 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ce1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ce4:	8d 50 01             	lea    0x1(%eax),%edx
  800ce7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ced:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cf0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cf3:	8a 12                	mov    (%edx),%dl
  800cf5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cfd:	89 55 10             	mov    %edx,0x10(%ebp)
  800d00:	85 c0                	test   %eax,%eax
  800d02:	75 dd                	jne    800ce1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d1b:	eb 2a                	jmp    800d47 <memcmp+0x3e>
		if (*s1 != *s2)
  800d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d20:	8a 10                	mov    (%eax),%dl
  800d22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	38 c2                	cmp    %al,%dl
  800d29:	74 16                	je     800d41 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f b6 d0             	movzbl %al,%edx
  800d33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	0f b6 c0             	movzbl %al,%eax
  800d3b:	29 c2                	sub    %eax,%edx
  800d3d:	89 d0                	mov    %edx,%eax
  800d3f:	eb 18                	jmp    800d59 <memcmp+0x50>
		s1++, s2++;
  800d41:	ff 45 fc             	incl   -0x4(%ebp)
  800d44:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d47:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d50:	85 c0                	test   %eax,%eax
  800d52:	75 c9                	jne    800d1d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d59:	c9                   	leave  
  800d5a:	c3                   	ret    

00800d5b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d61:	8b 55 08             	mov    0x8(%ebp),%edx
  800d64:	8b 45 10             	mov    0x10(%ebp),%eax
  800d67:	01 d0                	add    %edx,%eax
  800d69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d6c:	eb 15                	jmp    800d83 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	0f b6 d0             	movzbl %al,%edx
  800d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d79:	0f b6 c0             	movzbl %al,%eax
  800d7c:	39 c2                	cmp    %eax,%edx
  800d7e:	74 0d                	je     800d8d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d80:	ff 45 08             	incl   0x8(%ebp)
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d89:	72 e3                	jb     800d6e <memfind+0x13>
  800d8b:	eb 01                	jmp    800d8e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d8d:	90                   	nop
	return (void *) s;
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800da0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800da7:	eb 03                	jmp    800dac <strtol+0x19>
		s++;
  800da9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8a 00                	mov    (%eax),%al
  800db1:	3c 20                	cmp    $0x20,%al
  800db3:	74 f4                	je     800da9 <strtol+0x16>
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	3c 09                	cmp    $0x9,%al
  800dbc:	74 eb                	je     800da9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	3c 2b                	cmp    $0x2b,%al
  800dc5:	75 05                	jne    800dcc <strtol+0x39>
		s++;
  800dc7:	ff 45 08             	incl   0x8(%ebp)
  800dca:	eb 13                	jmp    800ddf <strtol+0x4c>
	else if (*s == '-')
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	3c 2d                	cmp    $0x2d,%al
  800dd3:	75 0a                	jne    800ddf <strtol+0x4c>
		s++, neg = 1;
  800dd5:	ff 45 08             	incl   0x8(%ebp)
  800dd8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ddf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de3:	74 06                	je     800deb <strtol+0x58>
  800de5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800de9:	75 20                	jne    800e0b <strtol+0x78>
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	3c 30                	cmp    $0x30,%al
  800df2:	75 17                	jne    800e0b <strtol+0x78>
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	40                   	inc    %eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	3c 78                	cmp    $0x78,%al
  800dfc:	75 0d                	jne    800e0b <strtol+0x78>
		s += 2, base = 16;
  800dfe:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e02:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e09:	eb 28                	jmp    800e33 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0f:	75 15                	jne    800e26 <strtol+0x93>
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	8a 00                	mov    (%eax),%al
  800e16:	3c 30                	cmp    $0x30,%al
  800e18:	75 0c                	jne    800e26 <strtol+0x93>
		s++, base = 8;
  800e1a:	ff 45 08             	incl   0x8(%ebp)
  800e1d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e24:	eb 0d                	jmp    800e33 <strtol+0xa0>
	else if (base == 0)
  800e26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2a:	75 07                	jne    800e33 <strtol+0xa0>
		base = 10;
  800e2c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	3c 2f                	cmp    $0x2f,%al
  800e3a:	7e 19                	jle    800e55 <strtol+0xc2>
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	8a 00                	mov    (%eax),%al
  800e41:	3c 39                	cmp    $0x39,%al
  800e43:	7f 10                	jg     800e55 <strtol+0xc2>
			dig = *s - '0';
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8a 00                	mov    (%eax),%al
  800e4a:	0f be c0             	movsbl %al,%eax
  800e4d:	83 e8 30             	sub    $0x30,%eax
  800e50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e53:	eb 42                	jmp    800e97 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	3c 60                	cmp    $0x60,%al
  800e5c:	7e 19                	jle    800e77 <strtol+0xe4>
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	3c 7a                	cmp    $0x7a,%al
  800e65:	7f 10                	jg     800e77 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	0f be c0             	movsbl %al,%eax
  800e6f:	83 e8 57             	sub    $0x57,%eax
  800e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e75:	eb 20                	jmp    800e97 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	3c 40                	cmp    $0x40,%al
  800e7e:	7e 39                	jle    800eb9 <strtol+0x126>
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	3c 5a                	cmp    $0x5a,%al
  800e87:	7f 30                	jg     800eb9 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f be c0             	movsbl %al,%eax
  800e91:	83 e8 37             	sub    $0x37,%eax
  800e94:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e9a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e9d:	7d 19                	jge    800eb8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e9f:	ff 45 08             	incl   0x8(%ebp)
  800ea2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ea9:	89 c2                	mov    %eax,%edx
  800eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eae:	01 d0                	add    %edx,%eax
  800eb0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800eb3:	e9 7b ff ff ff       	jmp    800e33 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800eb8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800eb9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ebd:	74 08                	je     800ec7 <strtol+0x134>
		*endptr = (char *) s;
  800ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ec7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ecb:	74 07                	je     800ed4 <strtol+0x141>
  800ecd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed0:	f7 d8                	neg    %eax
  800ed2:	eb 03                	jmp    800ed7 <strtol+0x144>
  800ed4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ed7:	c9                   	leave  
  800ed8:	c3                   	ret    

00800ed9 <ltostr>:

void
ltostr(long value, char *str)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800edf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800ee6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ef1:	79 13                	jns    800f06 <ltostr+0x2d>
	{
		neg = 1;
  800ef3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f00:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f03:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f0e:	99                   	cltd   
  800f0f:	f7 f9                	idiv   %ecx
  800f11:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f17:	8d 50 01             	lea    0x1(%eax),%edx
  800f1a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f1d:	89 c2                	mov    %eax,%edx
  800f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f22:	01 d0                	add    %edx,%eax
  800f24:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f27:	83 c2 30             	add    $0x30,%edx
  800f2a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f2f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f34:	f7 e9                	imul   %ecx
  800f36:	c1 fa 02             	sar    $0x2,%edx
  800f39:	89 c8                	mov    %ecx,%eax
  800f3b:	c1 f8 1f             	sar    $0x1f,%eax
  800f3e:	29 c2                	sub    %eax,%edx
  800f40:	89 d0                	mov    %edx,%eax
  800f42:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f49:	75 bb                	jne    800f06 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f55:	48                   	dec    %eax
  800f56:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f59:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f5d:	74 3d                	je     800f9c <ltostr+0xc3>
		start = 1 ;
  800f5f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f66:	eb 34                	jmp    800f9c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	01 d0                	add    %edx,%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7b:	01 c2                	add    %eax,%edx
  800f7d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	01 c8                	add    %ecx,%eax
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8f:	01 c2                	add    %eax,%edx
  800f91:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f94:	88 02                	mov    %al,(%edx)
		start++ ;
  800f96:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f99:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f9f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fa2:	7c c4                	jl     800f68 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800fa4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faa:	01 d0                	add    %edx,%eax
  800fac:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800faf:	90                   	nop
  800fb0:	c9                   	leave  
  800fb1:	c3                   	ret    

00800fb2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
  800fb5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fb8:	ff 75 08             	pushl  0x8(%ebp)
  800fbb:	e8 73 fa ff ff       	call   800a33 <strlen>
  800fc0:	83 c4 04             	add    $0x4,%esp
  800fc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fc6:	ff 75 0c             	pushl  0xc(%ebp)
  800fc9:	e8 65 fa ff ff       	call   800a33 <strlen>
  800fce:	83 c4 04             	add    $0x4,%esp
  800fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fdb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fe2:	eb 17                	jmp    800ffb <strcconcat+0x49>
		final[s] = str1[s] ;
  800fe4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fea:	01 c2                	add    %eax,%edx
  800fec:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	01 c8                	add    %ecx,%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ff8:	ff 45 fc             	incl   -0x4(%ebp)
  800ffb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801001:	7c e1                	jl     800fe4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801003:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80100a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801011:	eb 1f                	jmp    801032 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801013:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801016:	8d 50 01             	lea    0x1(%eax),%edx
  801019:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80101c:	89 c2                	mov    %eax,%edx
  80101e:	8b 45 10             	mov    0x10(%ebp),%eax
  801021:	01 c2                	add    %eax,%edx
  801023:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	01 c8                	add    %ecx,%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80102f:	ff 45 f8             	incl   -0x8(%ebp)
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801035:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801038:	7c d9                	jl     801013 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80103a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80103d:	8b 45 10             	mov    0x10(%ebp),%eax
  801040:	01 d0                	add    %edx,%eax
  801042:	c6 00 00             	movb   $0x0,(%eax)
}
  801045:	90                   	nop
  801046:	c9                   	leave  
  801047:	c3                   	ret    

00801048 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80104b:	8b 45 14             	mov    0x14(%ebp),%eax
  80104e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801054:	8b 45 14             	mov    0x14(%ebp),%eax
  801057:	8b 00                	mov    (%eax),%eax
  801059:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801060:	8b 45 10             	mov    0x10(%ebp),%eax
  801063:	01 d0                	add    %edx,%eax
  801065:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80106b:	eb 0c                	jmp    801079 <strsplit+0x31>
			*string++ = 0;
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8d 50 01             	lea    0x1(%eax),%edx
  801073:	89 55 08             	mov    %edx,0x8(%ebp)
  801076:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	84 c0                	test   %al,%al
  801080:	74 18                	je     80109a <strsplit+0x52>
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	0f be c0             	movsbl %al,%eax
  80108a:	50                   	push   %eax
  80108b:	ff 75 0c             	pushl  0xc(%ebp)
  80108e:	e8 32 fb ff ff       	call   800bc5 <strchr>
  801093:	83 c4 08             	add    $0x8,%esp
  801096:	85 c0                	test   %eax,%eax
  801098:	75 d3                	jne    80106d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	84 c0                	test   %al,%al
  8010a1:	74 5a                	je     8010fd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8010a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a6:	8b 00                	mov    (%eax),%eax
  8010a8:	83 f8 0f             	cmp    $0xf,%eax
  8010ab:	75 07                	jne    8010b4 <strsplit+0x6c>
		{
			return 0;
  8010ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b2:	eb 66                	jmp    80111a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b7:	8b 00                	mov    (%eax),%eax
  8010b9:	8d 48 01             	lea    0x1(%eax),%ecx
  8010bc:	8b 55 14             	mov    0x14(%ebp),%edx
  8010bf:	89 0a                	mov    %ecx,(%edx)
  8010c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	01 c2                	add    %eax,%edx
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010d2:	eb 03                	jmp    8010d7 <strsplit+0x8f>
			string++;
  8010d4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	84 c0                	test   %al,%al
  8010de:	74 8b                	je     80106b <strsplit+0x23>
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	0f be c0             	movsbl %al,%eax
  8010e8:	50                   	push   %eax
  8010e9:	ff 75 0c             	pushl  0xc(%ebp)
  8010ec:	e8 d4 fa ff ff       	call   800bc5 <strchr>
  8010f1:	83 c4 08             	add    $0x8,%esp
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	74 dc                	je     8010d4 <strsplit+0x8c>
			string++;
	}
  8010f8:	e9 6e ff ff ff       	jmp    80106b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010fd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801101:	8b 00                	mov    (%eax),%eax
  801103:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80110a:	8b 45 10             	mov    0x10(%ebp),%eax
  80110d:	01 d0                	add    %edx,%eax
  80110f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801115:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801122:	83 ec 04             	sub    $0x4,%esp
  801125:	68 a8 22 80 00       	push   $0x8022a8
  80112a:	68 3f 01 00 00       	push   $0x13f
  80112f:	68 ca 22 80 00       	push   $0x8022ca
  801134:	e8 7a 08 00 00       	call   8019b3 <_panic>

00801139 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80113f:	83 ec 0c             	sub    $0xc,%esp
  801142:	ff 75 08             	pushl  0x8(%ebp)
  801145:	e8 ef 06 00 00       	call   801839 <sys_sbrk>
  80114a:	83 c4 10             	add    $0x10,%esp
}
  80114d:	c9                   	leave  
  80114e:	c3                   	ret    

0080114f <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
  801152:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801155:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801159:	75 07                	jne    801162 <malloc+0x13>
  80115b:	b8 00 00 00 00       	mov    $0x0,%eax
  801160:	eb 14                	jmp    801176 <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801162:	83 ec 04             	sub    $0x4,%esp
  801165:	68 d8 22 80 00       	push   $0x8022d8
  80116a:	6a 1b                	push   $0x1b
  80116c:	68 fd 22 80 00       	push   $0x8022fd
  801171:	e8 3d 08 00 00       	call   8019b3 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80117e:	83 ec 04             	sub    $0x4,%esp
  801181:	68 0c 23 80 00       	push   $0x80230c
  801186:	6a 29                	push   $0x29
  801188:	68 fd 22 80 00       	push   $0x8022fd
  80118d:	e8 21 08 00 00       	call   8019b3 <_panic>

00801192 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	83 ec 18             	sub    $0x18,%esp
  801198:	8b 45 10             	mov    0x10(%ebp),%eax
  80119b:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80119e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011a2:	75 07                	jne    8011ab <smalloc+0x19>
  8011a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a9:	eb 14                	jmp    8011bf <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8011ab:	83 ec 04             	sub    $0x4,%esp
  8011ae:	68 30 23 80 00       	push   $0x802330
  8011b3:	6a 38                	push   $0x38
  8011b5:	68 fd 22 80 00       	push   $0x8022fd
  8011ba:	e8 f4 07 00 00       	call   8019b3 <_panic>
	return NULL;
}
  8011bf:	c9                   	leave  
  8011c0:	c3                   	ret    

008011c1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
  8011c4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8011c7:	83 ec 04             	sub    $0x4,%esp
  8011ca:	68 58 23 80 00       	push   $0x802358
  8011cf:	6a 43                	push   $0x43
  8011d1:	68 fd 22 80 00       	push   $0x8022fd
  8011d6:	e8 d8 07 00 00       	call   8019b3 <_panic>

008011db <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8011e1:	83 ec 04             	sub    $0x4,%esp
  8011e4:	68 7c 23 80 00       	push   $0x80237c
  8011e9:	6a 5b                	push   $0x5b
  8011eb:	68 fd 22 80 00       	push   $0x8022fd
  8011f0:	e8 be 07 00 00       	call   8019b3 <_panic>

008011f5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8011fb:	83 ec 04             	sub    $0x4,%esp
  8011fe:	68 a0 23 80 00       	push   $0x8023a0
  801203:	6a 72                	push   $0x72
  801205:	68 fd 22 80 00       	push   $0x8022fd
  80120a:	e8 a4 07 00 00       	call   8019b3 <_panic>

0080120f <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801215:	83 ec 04             	sub    $0x4,%esp
  801218:	68 c6 23 80 00       	push   $0x8023c6
  80121d:	6a 7e                	push   $0x7e
  80121f:	68 fd 22 80 00       	push   $0x8022fd
  801224:	e8 8a 07 00 00       	call   8019b3 <_panic>

00801229 <shrink>:

}
void shrink(uint32 newSize)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80122f:	83 ec 04             	sub    $0x4,%esp
  801232:	68 c6 23 80 00       	push   $0x8023c6
  801237:	68 83 00 00 00       	push   $0x83
  80123c:	68 fd 22 80 00       	push   $0x8022fd
  801241:	e8 6d 07 00 00       	call   8019b3 <_panic>

00801246 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80124c:	83 ec 04             	sub    $0x4,%esp
  80124f:	68 c6 23 80 00       	push   $0x8023c6
  801254:	68 88 00 00 00       	push   $0x88
  801259:	68 fd 22 80 00       	push   $0x8022fd
  80125e:	e8 50 07 00 00       	call   8019b3 <_panic>

00801263 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	57                   	push   %edi
  801267:	56                   	push   %esi
  801268:	53                   	push   %ebx
  801269:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801272:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801275:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801278:	8b 7d 18             	mov    0x18(%ebp),%edi
  80127b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80127e:	cd 30                	int    $0x30
  801280:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801283:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801286:	83 c4 10             	add    $0x10,%esp
  801289:	5b                   	pop    %ebx
  80128a:	5e                   	pop    %esi
  80128b:	5f                   	pop    %edi
  80128c:	5d                   	pop    %ebp
  80128d:	c3                   	ret    

0080128e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	83 ec 04             	sub    $0x4,%esp
  801294:	8b 45 10             	mov    0x10(%ebp),%eax
  801297:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80129a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	6a 00                	push   $0x0
  8012a3:	6a 00                	push   $0x0
  8012a5:	52                   	push   %edx
  8012a6:	ff 75 0c             	pushl  0xc(%ebp)
  8012a9:	50                   	push   %eax
  8012aa:	6a 00                	push   $0x0
  8012ac:	e8 b2 ff ff ff       	call   801263 <syscall>
  8012b1:	83 c4 18             	add    $0x18,%esp
}
  8012b4:	90                   	nop
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    

008012b7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012ba:	6a 00                	push   $0x0
  8012bc:	6a 00                	push   $0x0
  8012be:	6a 00                	push   $0x0
  8012c0:	6a 00                	push   $0x0
  8012c2:	6a 00                	push   $0x0
  8012c4:	6a 02                	push   $0x2
  8012c6:	e8 98 ff ff ff       	call   801263 <syscall>
  8012cb:	83 c4 18             	add    $0x18,%esp
}
  8012ce:	c9                   	leave  
  8012cf:	c3                   	ret    

008012d0 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012d3:	6a 00                	push   $0x0
  8012d5:	6a 00                	push   $0x0
  8012d7:	6a 00                	push   $0x0
  8012d9:	6a 00                	push   $0x0
  8012db:	6a 00                	push   $0x0
  8012dd:	6a 03                	push   $0x3
  8012df:	e8 7f ff ff ff       	call   801263 <syscall>
  8012e4:	83 c4 18             	add    $0x18,%esp
}
  8012e7:	90                   	nop
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 00                	push   $0x0
  8012f1:	6a 00                	push   $0x0
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 04                	push   $0x4
  8012f9:	e8 65 ff ff ff       	call   801263 <syscall>
  8012fe:	83 c4 18             	add    $0x18,%esp
}
  801301:	90                   	nop
  801302:	c9                   	leave  
  801303:	c3                   	ret    

00801304 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801307:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	6a 00                	push   $0x0
  80130f:	6a 00                	push   $0x0
  801311:	6a 00                	push   $0x0
  801313:	52                   	push   %edx
  801314:	50                   	push   %eax
  801315:	6a 08                	push   $0x8
  801317:	e8 47 ff ff ff       	call   801263 <syscall>
  80131c:	83 c4 18             	add    $0x18,%esp
}
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	56                   	push   %esi
  801325:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801326:	8b 75 18             	mov    0x18(%ebp),%esi
  801329:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80132c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80132f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	56                   	push   %esi
  801336:	53                   	push   %ebx
  801337:	51                   	push   %ecx
  801338:	52                   	push   %edx
  801339:	50                   	push   %eax
  80133a:	6a 09                	push   $0x9
  80133c:	e8 22 ff ff ff       	call   801263 <syscall>
  801341:	83 c4 18             	add    $0x18,%esp
}
  801344:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801347:	5b                   	pop    %ebx
  801348:	5e                   	pop    %esi
  801349:	5d                   	pop    %ebp
  80134a:	c3                   	ret    

0080134b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80134e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	52                   	push   %edx
  80135b:	50                   	push   %eax
  80135c:	6a 0a                	push   $0xa
  80135e:	e8 00 ff ff ff       	call   801263 <syscall>
  801363:	83 c4 18             	add    $0x18,%esp
}
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	ff 75 0c             	pushl  0xc(%ebp)
  801374:	ff 75 08             	pushl  0x8(%ebp)
  801377:	6a 0b                	push   $0xb
  801379:	e8 e5 fe ff ff       	call   801263 <syscall>
  80137e:	83 c4 18             	add    $0x18,%esp
}
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 0c                	push   $0xc
  801392:	e8 cc fe ff ff       	call   801263 <syscall>
  801397:	83 c4 18             	add    $0x18,%esp
}
  80139a:	c9                   	leave  
  80139b:	c3                   	ret    

0080139c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 0d                	push   $0xd
  8013ab:	e8 b3 fe ff ff       	call   801263 <syscall>
  8013b0:	83 c4 18             	add    $0x18,%esp
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 0e                	push   $0xe
  8013c4:	e8 9a fe ff ff       	call   801263 <syscall>
  8013c9:	83 c4 18             	add    $0x18,%esp
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 0f                	push   $0xf
  8013dd:	e8 81 fe ff ff       	call   801263 <syscall>
  8013e2:	83 c4 18             	add    $0x18,%esp
}
  8013e5:	c9                   	leave  
  8013e6:	c3                   	ret    

008013e7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	ff 75 08             	pushl  0x8(%ebp)
  8013f5:	6a 10                	push   $0x10
  8013f7:	e8 67 fe ff ff       	call   801263 <syscall>
  8013fc:	83 c4 18             	add    $0x18,%esp
}
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    

00801401 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 11                	push   $0x11
  801410:	e8 4e fe ff ff       	call   801263 <syscall>
  801415:	83 c4 18             	add    $0x18,%esp
}
  801418:	90                   	nop
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <sys_cputc>:

void
sys_cputc(const char c)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 04             	sub    $0x4,%esp
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801427:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	50                   	push   %eax
  801434:	6a 01                	push   $0x1
  801436:	e8 28 fe ff ff       	call   801263 <syscall>
  80143b:	83 c4 18             	add    $0x18,%esp
}
  80143e:	90                   	nop
  80143f:	c9                   	leave  
  801440:	c3                   	ret    

00801441 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 14                	push   $0x14
  801450:	e8 0e fe ff ff       	call   801263 <syscall>
  801455:	83 c4 18             	add    $0x18,%esp
}
  801458:	90                   	nop
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 04             	sub    $0x4,%esp
  801461:	8b 45 10             	mov    0x10(%ebp),%eax
  801464:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801467:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80146a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	6a 00                	push   $0x0
  801473:	51                   	push   %ecx
  801474:	52                   	push   %edx
  801475:	ff 75 0c             	pushl  0xc(%ebp)
  801478:	50                   	push   %eax
  801479:	6a 15                	push   $0x15
  80147b:	e8 e3 fd ff ff       	call   801263 <syscall>
  801480:	83 c4 18             	add    $0x18,%esp
}
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	52                   	push   %edx
  801495:	50                   	push   %eax
  801496:	6a 16                	push   $0x16
  801498:	e8 c6 fd ff ff       	call   801263 <syscall>
  80149d:	83 c4 18             	add    $0x18,%esp
}
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    

008014a2 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	51                   	push   %ecx
  8014b3:	52                   	push   %edx
  8014b4:	50                   	push   %eax
  8014b5:	6a 17                	push   $0x17
  8014b7:	e8 a7 fd ff ff       	call   801263 <syscall>
  8014bc:	83 c4 18             	add    $0x18,%esp
}
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	52                   	push   %edx
  8014d1:	50                   	push   %eax
  8014d2:	6a 18                	push   $0x18
  8014d4:	e8 8a fd ff ff       	call   801263 <syscall>
  8014d9:	83 c4 18             	add    $0x18,%esp
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	6a 00                	push   $0x0
  8014e6:	ff 75 14             	pushl  0x14(%ebp)
  8014e9:	ff 75 10             	pushl  0x10(%ebp)
  8014ec:	ff 75 0c             	pushl  0xc(%ebp)
  8014ef:	50                   	push   %eax
  8014f0:	6a 19                	push   $0x19
  8014f2:	e8 6c fd ff ff       	call   801263 <syscall>
  8014f7:	83 c4 18             	add    $0x18,%esp
}
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	50                   	push   %eax
  80150b:	6a 1a                	push   $0x1a
  80150d:	e8 51 fd ff ff       	call   801263 <syscall>
  801512:	83 c4 18             	add    $0x18,%esp
}
  801515:	90                   	nop
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	50                   	push   %eax
  801527:	6a 1b                	push   $0x1b
  801529:	e8 35 fd ff ff       	call   801263 <syscall>
  80152e:	83 c4 18             	add    $0x18,%esp
}
  801531:	c9                   	leave  
  801532:	c3                   	ret    

00801533 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 05                	push   $0x5
  801542:	e8 1c fd ff ff       	call   801263 <syscall>
  801547:	83 c4 18             	add    $0x18,%esp
}
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    

0080154c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 06                	push   $0x6
  80155b:	e8 03 fd ff ff       	call   801263 <syscall>
  801560:	83 c4 18             	add    $0x18,%esp
}
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 07                	push   $0x7
  801574:	e8 ea fc ff ff       	call   801263 <syscall>
  801579:	83 c4 18             	add    $0x18,%esp
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <sys_exit_env>:


void sys_exit_env(void)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 1c                	push   $0x1c
  80158d:	e8 d1 fc ff ff       	call   801263 <syscall>
  801592:	83 c4 18             	add    $0x18,%esp
}
  801595:	90                   	nop
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80159e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015a1:	8d 50 04             	lea    0x4(%eax),%edx
  8015a4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	52                   	push   %edx
  8015ae:	50                   	push   %eax
  8015af:	6a 1d                	push   $0x1d
  8015b1:	e8 ad fc ff ff       	call   801263 <syscall>
  8015b6:	83 c4 18             	add    $0x18,%esp
	return result;
  8015b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c2:	89 01                	mov    %eax,(%ecx)
  8015c4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	c9                   	leave  
  8015cb:	c2 04 00             	ret    $0x4

008015ce <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	ff 75 10             	pushl  0x10(%ebp)
  8015d8:	ff 75 0c             	pushl  0xc(%ebp)
  8015db:	ff 75 08             	pushl  0x8(%ebp)
  8015de:	6a 13                	push   $0x13
  8015e0:	e8 7e fc ff ff       	call   801263 <syscall>
  8015e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e8:	90                   	nop
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <sys_rcr2>:
uint32 sys_rcr2()
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 1e                	push   $0x1e
  8015fa:	e8 64 fc ff ff       	call   801263 <syscall>
  8015ff:	83 c4 18             	add    $0x18,%esp
}
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	83 ec 04             	sub    $0x4,%esp
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801610:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	50                   	push   %eax
  80161d:	6a 1f                	push   $0x1f
  80161f:	e8 3f fc ff ff       	call   801263 <syscall>
  801624:	83 c4 18             	add    $0x18,%esp
	return ;
  801627:	90                   	nop
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <rsttst>:
void rsttst()
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 21                	push   $0x21
  801639:	e8 25 fc ff ff       	call   801263 <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
	return ;
  801641:	90                   	nop
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	83 ec 04             	sub    $0x4,%esp
  80164a:	8b 45 14             	mov    0x14(%ebp),%eax
  80164d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801650:	8b 55 18             	mov    0x18(%ebp),%edx
  801653:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801657:	52                   	push   %edx
  801658:	50                   	push   %eax
  801659:	ff 75 10             	pushl  0x10(%ebp)
  80165c:	ff 75 0c             	pushl  0xc(%ebp)
  80165f:	ff 75 08             	pushl  0x8(%ebp)
  801662:	6a 20                	push   $0x20
  801664:	e8 fa fb ff ff       	call   801263 <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
	return ;
  80166c:	90                   	nop
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <chktst>:
void chktst(uint32 n)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	ff 75 08             	pushl  0x8(%ebp)
  80167d:	6a 22                	push   $0x22
  80167f:	e8 df fb ff ff       	call   801263 <syscall>
  801684:	83 c4 18             	add    $0x18,%esp
	return ;
  801687:	90                   	nop
}
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <inctst>:

void inctst()
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 23                	push   $0x23
  801699:	e8 c5 fb ff ff       	call   801263 <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a1:	90                   	nop
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <gettst>:
uint32 gettst()
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 24                	push   $0x24
  8016b3:	e8 ab fb ff ff       	call   801263 <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 25                	push   $0x25
  8016cf:	e8 8f fb ff ff       	call   801263 <syscall>
  8016d4:	83 c4 18             	add    $0x18,%esp
  8016d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8016da:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8016de:	75 07                	jne    8016e7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8016e0:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e5:	eb 05                	jmp    8016ec <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8016e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 25                	push   $0x25
  801700:	e8 5e fb ff ff       	call   801263 <syscall>
  801705:	83 c4 18             	add    $0x18,%esp
  801708:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80170b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80170f:	75 07                	jne    801718 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801711:	b8 01 00 00 00       	mov    $0x1,%eax
  801716:	eb 05                	jmp    80171d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801718:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 25                	push   $0x25
  801731:	e8 2d fb ff ff       	call   801263 <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
  801739:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80173c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801740:	75 07                	jne    801749 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801742:	b8 01 00 00 00       	mov    $0x1,%eax
  801747:	eb 05                	jmp    80174e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801749:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 25                	push   $0x25
  801762:	e8 fc fa ff ff       	call   801263 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
  80176a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80176d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801771:	75 07                	jne    80177a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801773:	b8 01 00 00 00       	mov    $0x1,%eax
  801778:	eb 05                	jmp    80177f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80177a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	6a 26                	push   $0x26
  801791:	e8 cd fa ff ff       	call   801263 <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
	return ;
  801799:	90                   	nop
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	6a 00                	push   $0x0
  8017ae:	53                   	push   %ebx
  8017af:	51                   	push   %ecx
  8017b0:	52                   	push   %edx
  8017b1:	50                   	push   %eax
  8017b2:	6a 27                	push   $0x27
  8017b4:	e8 aa fa ff ff       	call   801263 <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
}
  8017bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8017c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	52                   	push   %edx
  8017d1:	50                   	push   %eax
  8017d2:	6a 28                	push   $0x28
  8017d4:	e8 8a fa ff ff       	call   801263 <syscall>
  8017d9:	83 c4 18             	add    $0x18,%esp
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8017e1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	6a 00                	push   $0x0
  8017ec:	51                   	push   %ecx
  8017ed:	ff 75 10             	pushl  0x10(%ebp)
  8017f0:	52                   	push   %edx
  8017f1:	50                   	push   %eax
  8017f2:	6a 29                	push   $0x29
  8017f4:	e8 6a fa ff ff       	call   801263 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	ff 75 10             	pushl  0x10(%ebp)
  801808:	ff 75 0c             	pushl  0xc(%ebp)
  80180b:	ff 75 08             	pushl  0x8(%ebp)
  80180e:	6a 12                	push   $0x12
  801810:	e8 4e fa ff ff       	call   801263 <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
	return ;
  801818:	90                   	nop
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80181e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	52                   	push   %edx
  80182b:	50                   	push   %eax
  80182c:	6a 2a                	push   $0x2a
  80182e:	e8 30 fa ff ff       	call   801263 <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
	return;
  801836:	90                   	nop
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	50                   	push   %eax
  801848:	6a 2b                	push   $0x2b
  80184a:	e8 14 fa ff ff       	call   801263 <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	ff 75 0c             	pushl  0xc(%ebp)
  801860:	ff 75 08             	pushl  0x8(%ebp)
  801863:	6a 2c                	push   $0x2c
  801865:	e8 f9 f9 ff ff       	call   801263 <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
	return;
  80186d:	90                   	nop
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	ff 75 0c             	pushl  0xc(%ebp)
  80187c:	ff 75 08             	pushl  0x8(%ebp)
  80187f:	6a 2d                	push   $0x2d
  801881:	e8 dd f9 ff ff       	call   801263 <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
	return;
  801889:	90                   	nop
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  801892:	83 ec 04             	sub    $0x4,%esp
  801895:	68 d8 23 80 00       	push   $0x8023d8
  80189a:	6a 09                	push   $0x9
  80189c:	68 00 24 80 00       	push   $0x802400
  8018a1:	e8 0d 01 00 00       	call   8019b3 <_panic>

008018a6 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8018ac:	83 ec 04             	sub    $0x4,%esp
  8018af:	68 10 24 80 00       	push   $0x802410
  8018b4:	6a 10                	push   $0x10
  8018b6:	68 00 24 80 00       	push   $0x802400
  8018bb:	e8 f3 00 00 00       	call   8019b3 <_panic>

008018c0 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8018c6:	83 ec 04             	sub    $0x4,%esp
  8018c9:	68 38 24 80 00       	push   $0x802438
  8018ce:	6a 18                	push   $0x18
  8018d0:	68 00 24 80 00       	push   $0x802400
  8018d5:	e8 d9 00 00 00       	call   8019b3 <_panic>

008018da <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8018e0:	83 ec 04             	sub    $0x4,%esp
  8018e3:	68 60 24 80 00       	push   $0x802460
  8018e8:	6a 20                	push   $0x20
  8018ea:	68 00 24 80 00       	push   $0x802400
  8018ef:	e8 bf 00 00 00       	call   8019b3 <_panic>

008018f4 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	8b 40 10             	mov    0x10(%eax),%eax
}
  8018fd:	5d                   	pop    %ebp
  8018fe:	c3                   	ret    

008018ff <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801905:	8b 55 08             	mov    0x8(%ebp),%edx
  801908:	89 d0                	mov    %edx,%eax
  80190a:	c1 e0 02             	shl    $0x2,%eax
  80190d:	01 d0                	add    %edx,%eax
  80190f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801916:	01 d0                	add    %edx,%eax
  801918:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80191f:	01 d0                	add    %edx,%eax
  801921:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801928:	01 d0                	add    %edx,%eax
  80192a:	c1 e0 04             	shl    $0x4,%eax
  80192d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801930:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801937:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80193a:	83 ec 0c             	sub    $0xc,%esp
  80193d:	50                   	push   %eax
  80193e:	e8 55 fc ff ff       	call   801598 <sys_get_virtual_time>
  801943:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801946:	eb 41                	jmp    801989 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801948:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80194b:	83 ec 0c             	sub    $0xc,%esp
  80194e:	50                   	push   %eax
  80194f:	e8 44 fc ff ff       	call   801598 <sys_get_virtual_time>
  801954:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801957:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80195a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80195d:	29 c2                	sub    %eax,%edx
  80195f:	89 d0                	mov    %edx,%eax
  801961:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801964:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801967:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80196a:	89 d1                	mov    %edx,%ecx
  80196c:	29 c1                	sub    %eax,%ecx
  80196e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801971:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801974:	39 c2                	cmp    %eax,%edx
  801976:	0f 97 c0             	seta   %al
  801979:	0f b6 c0             	movzbl %al,%eax
  80197c:	29 c1                	sub    %eax,%ecx
  80197e:	89 c8                	mov    %ecx,%eax
  801980:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801983:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801986:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80198f:	72 b7                	jb     801948 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801991:	90                   	nop
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80199a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8019a1:	eb 03                	jmp    8019a6 <busy_wait+0x12>
  8019a3:	ff 45 fc             	incl   -0x4(%ebp)
  8019a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019ac:	72 f5                	jb     8019a3 <busy_wait+0xf>
	return i;
  8019ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8019b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8019bc:	83 c0 04             	add    $0x4,%eax
  8019bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8019c2:	a1 24 30 80 00       	mov    0x803024,%eax
  8019c7:	85 c0                	test   %eax,%eax
  8019c9:	74 16                	je     8019e1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8019cb:	a1 24 30 80 00       	mov    0x803024,%eax
  8019d0:	83 ec 08             	sub    $0x8,%esp
  8019d3:	50                   	push   %eax
  8019d4:	68 88 24 80 00       	push   $0x802488
  8019d9:	e8 c1 e9 ff ff       	call   80039f <cprintf>
  8019de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8019e1:	a1 00 30 80 00       	mov    0x803000,%eax
  8019e6:	ff 75 0c             	pushl  0xc(%ebp)
  8019e9:	ff 75 08             	pushl  0x8(%ebp)
  8019ec:	50                   	push   %eax
  8019ed:	68 8d 24 80 00       	push   $0x80248d
  8019f2:	e8 a8 e9 ff ff       	call   80039f <cprintf>
  8019f7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8019fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fd:	83 ec 08             	sub    $0x8,%esp
  801a00:	ff 75 f4             	pushl  -0xc(%ebp)
  801a03:	50                   	push   %eax
  801a04:	e8 2b e9 ff ff       	call   800334 <vcprintf>
  801a09:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801a0c:	83 ec 08             	sub    $0x8,%esp
  801a0f:	6a 00                	push   $0x0
  801a11:	68 a9 24 80 00       	push   $0x8024a9
  801a16:	e8 19 e9 ff ff       	call   800334 <vcprintf>
  801a1b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801a1e:	e8 9a e8 ff ff       	call   8002bd <exit>

	// should not return here
	while (1) ;
  801a23:	eb fe                	jmp    801a23 <_panic+0x70>

00801a25 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801a2b:	a1 04 30 80 00       	mov    0x803004,%eax
  801a30:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a39:	39 c2                	cmp    %eax,%edx
  801a3b:	74 14                	je     801a51 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801a3d:	83 ec 04             	sub    $0x4,%esp
  801a40:	68 ac 24 80 00       	push   $0x8024ac
  801a45:	6a 26                	push   $0x26
  801a47:	68 f8 24 80 00       	push   $0x8024f8
  801a4c:	e8 62 ff ff ff       	call   8019b3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801a51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801a58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801a5f:	e9 c5 00 00 00       	jmp    801b29 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	01 d0                	add    %edx,%eax
  801a73:	8b 00                	mov    (%eax),%eax
  801a75:	85 c0                	test   %eax,%eax
  801a77:	75 08                	jne    801a81 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801a79:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a7c:	e9 a5 00 00 00       	jmp    801b26 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a81:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a88:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a8f:	eb 69                	jmp    801afa <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a91:	a1 04 30 80 00       	mov    0x803004,%eax
  801a96:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801a9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a9f:	89 d0                	mov    %edx,%eax
  801aa1:	01 c0                	add    %eax,%eax
  801aa3:	01 d0                	add    %edx,%eax
  801aa5:	c1 e0 03             	shl    $0x3,%eax
  801aa8:	01 c8                	add    %ecx,%eax
  801aaa:	8a 40 04             	mov    0x4(%eax),%al
  801aad:	84 c0                	test   %al,%al
  801aaf:	75 46                	jne    801af7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ab1:	a1 04 30 80 00       	mov    0x803004,%eax
  801ab6:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801abc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801abf:	89 d0                	mov    %edx,%eax
  801ac1:	01 c0                	add    %eax,%eax
  801ac3:	01 d0                	add    %edx,%eax
  801ac5:	c1 e0 03             	shl    $0x3,%eax
  801ac8:	01 c8                	add    %ecx,%eax
  801aca:	8b 00                	mov    (%eax),%eax
  801acc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801acf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ad2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ad7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801adc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	01 c8                	add    %ecx,%eax
  801ae8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801aea:	39 c2                	cmp    %eax,%edx
  801aec:	75 09                	jne    801af7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801aee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801af5:	eb 15                	jmp    801b0c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801af7:	ff 45 e8             	incl   -0x18(%ebp)
  801afa:	a1 04 30 80 00       	mov    0x803004,%eax
  801aff:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b08:	39 c2                	cmp    %eax,%edx
  801b0a:	77 85                	ja     801a91 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801b0c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b10:	75 14                	jne    801b26 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801b12:	83 ec 04             	sub    $0x4,%esp
  801b15:	68 04 25 80 00       	push   $0x802504
  801b1a:	6a 3a                	push   $0x3a
  801b1c:	68 f8 24 80 00       	push   $0x8024f8
  801b21:	e8 8d fe ff ff       	call   8019b3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801b26:	ff 45 f0             	incl   -0x10(%ebp)
  801b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801b2f:	0f 8c 2f ff ff ff    	jl     801a64 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801b35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b3c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b43:	eb 26                	jmp    801b6b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801b45:	a1 04 30 80 00       	mov    0x803004,%eax
  801b4a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801b50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b53:	89 d0                	mov    %edx,%eax
  801b55:	01 c0                	add    %eax,%eax
  801b57:	01 d0                	add    %edx,%eax
  801b59:	c1 e0 03             	shl    $0x3,%eax
  801b5c:	01 c8                	add    %ecx,%eax
  801b5e:	8a 40 04             	mov    0x4(%eax),%al
  801b61:	3c 01                	cmp    $0x1,%al
  801b63:	75 03                	jne    801b68 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801b65:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b68:	ff 45 e0             	incl   -0x20(%ebp)
  801b6b:	a1 04 30 80 00       	mov    0x803004,%eax
  801b70:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b79:	39 c2                	cmp    %eax,%edx
  801b7b:	77 c8                	ja     801b45 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b80:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b83:	74 14                	je     801b99 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b85:	83 ec 04             	sub    $0x4,%esp
  801b88:	68 58 25 80 00       	push   $0x802558
  801b8d:	6a 44                	push   $0x44
  801b8f:	68 f8 24 80 00       	push   $0x8024f8
  801b94:	e8 1a fe ff ff       	call   8019b3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b99:	90                   	nop
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <__udivdi3>:
  801b9c:	55                   	push   %ebp
  801b9d:	57                   	push   %edi
  801b9e:	56                   	push   %esi
  801b9f:	53                   	push   %ebx
  801ba0:	83 ec 1c             	sub    $0x1c,%esp
  801ba3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ba7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801baf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bb3:	89 ca                	mov    %ecx,%edx
  801bb5:	89 f8                	mov    %edi,%eax
  801bb7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bbb:	85 f6                	test   %esi,%esi
  801bbd:	75 2d                	jne    801bec <__udivdi3+0x50>
  801bbf:	39 cf                	cmp    %ecx,%edi
  801bc1:	77 65                	ja     801c28 <__udivdi3+0x8c>
  801bc3:	89 fd                	mov    %edi,%ebp
  801bc5:	85 ff                	test   %edi,%edi
  801bc7:	75 0b                	jne    801bd4 <__udivdi3+0x38>
  801bc9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bce:	31 d2                	xor    %edx,%edx
  801bd0:	f7 f7                	div    %edi
  801bd2:	89 c5                	mov    %eax,%ebp
  801bd4:	31 d2                	xor    %edx,%edx
  801bd6:	89 c8                	mov    %ecx,%eax
  801bd8:	f7 f5                	div    %ebp
  801bda:	89 c1                	mov    %eax,%ecx
  801bdc:	89 d8                	mov    %ebx,%eax
  801bde:	f7 f5                	div    %ebp
  801be0:	89 cf                	mov    %ecx,%edi
  801be2:	89 fa                	mov    %edi,%edx
  801be4:	83 c4 1c             	add    $0x1c,%esp
  801be7:	5b                   	pop    %ebx
  801be8:	5e                   	pop    %esi
  801be9:	5f                   	pop    %edi
  801bea:	5d                   	pop    %ebp
  801beb:	c3                   	ret    
  801bec:	39 ce                	cmp    %ecx,%esi
  801bee:	77 28                	ja     801c18 <__udivdi3+0x7c>
  801bf0:	0f bd fe             	bsr    %esi,%edi
  801bf3:	83 f7 1f             	xor    $0x1f,%edi
  801bf6:	75 40                	jne    801c38 <__udivdi3+0x9c>
  801bf8:	39 ce                	cmp    %ecx,%esi
  801bfa:	72 0a                	jb     801c06 <__udivdi3+0x6a>
  801bfc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c00:	0f 87 9e 00 00 00    	ja     801ca4 <__udivdi3+0x108>
  801c06:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0b:	89 fa                	mov    %edi,%edx
  801c0d:	83 c4 1c             	add    $0x1c,%esp
  801c10:	5b                   	pop    %ebx
  801c11:	5e                   	pop    %esi
  801c12:	5f                   	pop    %edi
  801c13:	5d                   	pop    %ebp
  801c14:	c3                   	ret    
  801c15:	8d 76 00             	lea    0x0(%esi),%esi
  801c18:	31 ff                	xor    %edi,%edi
  801c1a:	31 c0                	xor    %eax,%eax
  801c1c:	89 fa                	mov    %edi,%edx
  801c1e:	83 c4 1c             	add    $0x1c,%esp
  801c21:	5b                   	pop    %ebx
  801c22:	5e                   	pop    %esi
  801c23:	5f                   	pop    %edi
  801c24:	5d                   	pop    %ebp
  801c25:	c3                   	ret    
  801c26:	66 90                	xchg   %ax,%ax
  801c28:	89 d8                	mov    %ebx,%eax
  801c2a:	f7 f7                	div    %edi
  801c2c:	31 ff                	xor    %edi,%edi
  801c2e:	89 fa                	mov    %edi,%edx
  801c30:	83 c4 1c             	add    $0x1c,%esp
  801c33:	5b                   	pop    %ebx
  801c34:	5e                   	pop    %esi
  801c35:	5f                   	pop    %edi
  801c36:	5d                   	pop    %ebp
  801c37:	c3                   	ret    
  801c38:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c3d:	89 eb                	mov    %ebp,%ebx
  801c3f:	29 fb                	sub    %edi,%ebx
  801c41:	89 f9                	mov    %edi,%ecx
  801c43:	d3 e6                	shl    %cl,%esi
  801c45:	89 c5                	mov    %eax,%ebp
  801c47:	88 d9                	mov    %bl,%cl
  801c49:	d3 ed                	shr    %cl,%ebp
  801c4b:	89 e9                	mov    %ebp,%ecx
  801c4d:	09 f1                	or     %esi,%ecx
  801c4f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c53:	89 f9                	mov    %edi,%ecx
  801c55:	d3 e0                	shl    %cl,%eax
  801c57:	89 c5                	mov    %eax,%ebp
  801c59:	89 d6                	mov    %edx,%esi
  801c5b:	88 d9                	mov    %bl,%cl
  801c5d:	d3 ee                	shr    %cl,%esi
  801c5f:	89 f9                	mov    %edi,%ecx
  801c61:	d3 e2                	shl    %cl,%edx
  801c63:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c67:	88 d9                	mov    %bl,%cl
  801c69:	d3 e8                	shr    %cl,%eax
  801c6b:	09 c2                	or     %eax,%edx
  801c6d:	89 d0                	mov    %edx,%eax
  801c6f:	89 f2                	mov    %esi,%edx
  801c71:	f7 74 24 0c          	divl   0xc(%esp)
  801c75:	89 d6                	mov    %edx,%esi
  801c77:	89 c3                	mov    %eax,%ebx
  801c79:	f7 e5                	mul    %ebp
  801c7b:	39 d6                	cmp    %edx,%esi
  801c7d:	72 19                	jb     801c98 <__udivdi3+0xfc>
  801c7f:	74 0b                	je     801c8c <__udivdi3+0xf0>
  801c81:	89 d8                	mov    %ebx,%eax
  801c83:	31 ff                	xor    %edi,%edi
  801c85:	e9 58 ff ff ff       	jmp    801be2 <__udivdi3+0x46>
  801c8a:	66 90                	xchg   %ax,%ax
  801c8c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c90:	89 f9                	mov    %edi,%ecx
  801c92:	d3 e2                	shl    %cl,%edx
  801c94:	39 c2                	cmp    %eax,%edx
  801c96:	73 e9                	jae    801c81 <__udivdi3+0xe5>
  801c98:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c9b:	31 ff                	xor    %edi,%edi
  801c9d:	e9 40 ff ff ff       	jmp    801be2 <__udivdi3+0x46>
  801ca2:	66 90                	xchg   %ax,%ax
  801ca4:	31 c0                	xor    %eax,%eax
  801ca6:	e9 37 ff ff ff       	jmp    801be2 <__udivdi3+0x46>
  801cab:	90                   	nop

00801cac <__umoddi3>:
  801cac:	55                   	push   %ebp
  801cad:	57                   	push   %edi
  801cae:	56                   	push   %esi
  801caf:	53                   	push   %ebx
  801cb0:	83 ec 1c             	sub    $0x1c,%esp
  801cb3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cb7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cbf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cc3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cc7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ccb:	89 f3                	mov    %esi,%ebx
  801ccd:	89 fa                	mov    %edi,%edx
  801ccf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cd3:	89 34 24             	mov    %esi,(%esp)
  801cd6:	85 c0                	test   %eax,%eax
  801cd8:	75 1a                	jne    801cf4 <__umoddi3+0x48>
  801cda:	39 f7                	cmp    %esi,%edi
  801cdc:	0f 86 a2 00 00 00    	jbe    801d84 <__umoddi3+0xd8>
  801ce2:	89 c8                	mov    %ecx,%eax
  801ce4:	89 f2                	mov    %esi,%edx
  801ce6:	f7 f7                	div    %edi
  801ce8:	89 d0                	mov    %edx,%eax
  801cea:	31 d2                	xor    %edx,%edx
  801cec:	83 c4 1c             	add    $0x1c,%esp
  801cef:	5b                   	pop    %ebx
  801cf0:	5e                   	pop    %esi
  801cf1:	5f                   	pop    %edi
  801cf2:	5d                   	pop    %ebp
  801cf3:	c3                   	ret    
  801cf4:	39 f0                	cmp    %esi,%eax
  801cf6:	0f 87 ac 00 00 00    	ja     801da8 <__umoddi3+0xfc>
  801cfc:	0f bd e8             	bsr    %eax,%ebp
  801cff:	83 f5 1f             	xor    $0x1f,%ebp
  801d02:	0f 84 ac 00 00 00    	je     801db4 <__umoddi3+0x108>
  801d08:	bf 20 00 00 00       	mov    $0x20,%edi
  801d0d:	29 ef                	sub    %ebp,%edi
  801d0f:	89 fe                	mov    %edi,%esi
  801d11:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d15:	89 e9                	mov    %ebp,%ecx
  801d17:	d3 e0                	shl    %cl,%eax
  801d19:	89 d7                	mov    %edx,%edi
  801d1b:	89 f1                	mov    %esi,%ecx
  801d1d:	d3 ef                	shr    %cl,%edi
  801d1f:	09 c7                	or     %eax,%edi
  801d21:	89 e9                	mov    %ebp,%ecx
  801d23:	d3 e2                	shl    %cl,%edx
  801d25:	89 14 24             	mov    %edx,(%esp)
  801d28:	89 d8                	mov    %ebx,%eax
  801d2a:	d3 e0                	shl    %cl,%eax
  801d2c:	89 c2                	mov    %eax,%edx
  801d2e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d32:	d3 e0                	shl    %cl,%eax
  801d34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d38:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d3c:	89 f1                	mov    %esi,%ecx
  801d3e:	d3 e8                	shr    %cl,%eax
  801d40:	09 d0                	or     %edx,%eax
  801d42:	d3 eb                	shr    %cl,%ebx
  801d44:	89 da                	mov    %ebx,%edx
  801d46:	f7 f7                	div    %edi
  801d48:	89 d3                	mov    %edx,%ebx
  801d4a:	f7 24 24             	mull   (%esp)
  801d4d:	89 c6                	mov    %eax,%esi
  801d4f:	89 d1                	mov    %edx,%ecx
  801d51:	39 d3                	cmp    %edx,%ebx
  801d53:	0f 82 87 00 00 00    	jb     801de0 <__umoddi3+0x134>
  801d59:	0f 84 91 00 00 00    	je     801df0 <__umoddi3+0x144>
  801d5f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d63:	29 f2                	sub    %esi,%edx
  801d65:	19 cb                	sbb    %ecx,%ebx
  801d67:	89 d8                	mov    %ebx,%eax
  801d69:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d6d:	d3 e0                	shl    %cl,%eax
  801d6f:	89 e9                	mov    %ebp,%ecx
  801d71:	d3 ea                	shr    %cl,%edx
  801d73:	09 d0                	or     %edx,%eax
  801d75:	89 e9                	mov    %ebp,%ecx
  801d77:	d3 eb                	shr    %cl,%ebx
  801d79:	89 da                	mov    %ebx,%edx
  801d7b:	83 c4 1c             	add    $0x1c,%esp
  801d7e:	5b                   	pop    %ebx
  801d7f:	5e                   	pop    %esi
  801d80:	5f                   	pop    %edi
  801d81:	5d                   	pop    %ebp
  801d82:	c3                   	ret    
  801d83:	90                   	nop
  801d84:	89 fd                	mov    %edi,%ebp
  801d86:	85 ff                	test   %edi,%edi
  801d88:	75 0b                	jne    801d95 <__umoddi3+0xe9>
  801d8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8f:	31 d2                	xor    %edx,%edx
  801d91:	f7 f7                	div    %edi
  801d93:	89 c5                	mov    %eax,%ebp
  801d95:	89 f0                	mov    %esi,%eax
  801d97:	31 d2                	xor    %edx,%edx
  801d99:	f7 f5                	div    %ebp
  801d9b:	89 c8                	mov    %ecx,%eax
  801d9d:	f7 f5                	div    %ebp
  801d9f:	89 d0                	mov    %edx,%eax
  801da1:	e9 44 ff ff ff       	jmp    801cea <__umoddi3+0x3e>
  801da6:	66 90                	xchg   %ax,%ax
  801da8:	89 c8                	mov    %ecx,%eax
  801daa:	89 f2                	mov    %esi,%edx
  801dac:	83 c4 1c             	add    $0x1c,%esp
  801daf:	5b                   	pop    %ebx
  801db0:	5e                   	pop    %esi
  801db1:	5f                   	pop    %edi
  801db2:	5d                   	pop    %ebp
  801db3:	c3                   	ret    
  801db4:	3b 04 24             	cmp    (%esp),%eax
  801db7:	72 06                	jb     801dbf <__umoddi3+0x113>
  801db9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801dbd:	77 0f                	ja     801dce <__umoddi3+0x122>
  801dbf:	89 f2                	mov    %esi,%edx
  801dc1:	29 f9                	sub    %edi,%ecx
  801dc3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801dc7:	89 14 24             	mov    %edx,(%esp)
  801dca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dce:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dd2:	8b 14 24             	mov    (%esp),%edx
  801dd5:	83 c4 1c             	add    $0x1c,%esp
  801dd8:	5b                   	pop    %ebx
  801dd9:	5e                   	pop    %esi
  801dda:	5f                   	pop    %edi
  801ddb:	5d                   	pop    %ebp
  801ddc:	c3                   	ret    
  801ddd:	8d 76 00             	lea    0x0(%esi),%esi
  801de0:	2b 04 24             	sub    (%esp),%eax
  801de3:	19 fa                	sbb    %edi,%edx
  801de5:	89 d1                	mov    %edx,%ecx
  801de7:	89 c6                	mov    %eax,%esi
  801de9:	e9 71 ff ff ff       	jmp    801d5f <__umoddi3+0xb3>
  801dee:	66 90                	xchg   %ax,%ax
  801df0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801df4:	72 ea                	jb     801de0 <__umoddi3+0x134>
  801df6:	89 d9                	mov    %ebx,%ecx
  801df8:	e9 62 ff ff ff       	jmp    801d5f <__umoddi3+0xb3>
