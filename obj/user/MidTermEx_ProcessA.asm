
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
  80003e:	e8 0c 15 00 00       	call   80154f <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 00 1e 80 00       	push   $0x801e00
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 55 11 00 00       	call   8011ab <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 02 1e 80 00       	push   $0x801e02
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 3f 11 00 00       	call   8011ab <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 09 1e 80 00       	push   $0x801e09
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 29 11 00 00       	call   8011ab <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 ee 14 00 00       	call   801582 <sys_get_virtual_time>
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
  8000b7:	e8 2d 18 00 00       	call   8018e9 <env_sleep>
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
  8000d0:	e8 ad 14 00 00       	call   801582 <sys_get_virtual_time>
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
  8000f8:	e8 ec 17 00 00       	call   8018e9 <env_sleep>
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
  80010f:	e8 6e 14 00 00       	call   801582 <sys_get_virtual_time>
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
  800137:	e8 ad 17 00 00       	call   8018e9 <env_sleep>
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
  800158:	e8 33 17 00 00       	call   801890 <get_semaphore>
  80015d:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(T);
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	ff 75 c4             	pushl  -0x3c(%ebp)
  800166:	e8 59 17 00 00       	call   8018c4 <signal_semaphore>
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
  800184:	e8 ad 13 00 00       	call   801536 <sys_getenvindex>
  800189:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80018c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018f:	89 d0                	mov    %edx,%eax
  800191:	c1 e0 02             	shl    $0x2,%eax
  800194:	01 d0                	add    %edx,%eax
  800196:	01 c0                	add    %eax,%eax
  800198:	01 d0                	add    %edx,%eax
  80019a:	c1 e0 02             	shl    $0x2,%eax
  80019d:	01 d0                	add    %edx,%eax
  80019f:	01 c0                	add    %eax,%eax
  8001a1:	01 d0                	add    %edx,%eax
  8001a3:	c1 e0 04             	shl    $0x4,%eax
  8001a6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ab:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b0:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b5:	8a 40 20             	mov    0x20(%eax),%al
  8001b8:	84 c0                	test   %al,%al
  8001ba:	74 0d                	je     8001c9 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8001bc:	a1 04 30 80 00       	mov    0x803004,%eax
  8001c1:	83 c0 20             	add    $0x20,%eax
  8001c4:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001cd:	7e 0a                	jle    8001d9 <libmain+0x5b>
		binaryname = argv[0];
  8001cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d2:	8b 00                	mov    (%eax),%eax
  8001d4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	ff 75 0c             	pushl  0xc(%ebp)
  8001df:	ff 75 08             	pushl  0x8(%ebp)
  8001e2:	e8 51 fe ff ff       	call   800038 <_main>
  8001e7:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001ea:	e8 cb 10 00 00       	call   8012ba <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	68 34 1e 80 00       	push   $0x801e34
  8001f7:	e8 8d 01 00 00       	call   800389 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001ff:	a1 04 30 80 00       	mov    0x803004,%eax
  800204:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80020a:	a1 04 30 80 00       	mov    0x803004,%eax
  80020f:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	52                   	push   %edx
  800219:	50                   	push   %eax
  80021a:	68 5c 1e 80 00       	push   $0x801e5c
  80021f:	e8 65 01 00 00       	call   800389 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800227:	a1 04 30 80 00       	mov    0x803004,%eax
  80022c:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800232:	a1 04 30 80 00       	mov    0x803004,%eax
  800237:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  80023d:	a1 04 30 80 00       	mov    0x803004,%eax
  800242:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800248:	51                   	push   %ecx
  800249:	52                   	push   %edx
  80024a:	50                   	push   %eax
  80024b:	68 84 1e 80 00       	push   $0x801e84
  800250:	e8 34 01 00 00       	call   800389 <cprintf>
  800255:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800258:	a1 04 30 80 00       	mov    0x803004,%eax
  80025d:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800263:	83 ec 08             	sub    $0x8,%esp
  800266:	50                   	push   %eax
  800267:	68 dc 1e 80 00       	push   $0x801edc
  80026c:	e8 18 01 00 00       	call   800389 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	68 34 1e 80 00       	push   $0x801e34
  80027c:	e8 08 01 00 00       	call   800389 <cprintf>
  800281:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800284:	e8 4b 10 00 00       	call   8012d4 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800289:	e8 19 00 00 00       	call   8002a7 <exit>
}
  80028e:	90                   	nop
  80028f:	c9                   	leave  
  800290:	c3                   	ret    

00800291 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 00                	push   $0x0
  80029c:	e8 61 12 00 00       	call   801502 <sys_destroy_env>
  8002a1:	83 c4 10             	add    $0x10,%esp
}
  8002a4:	90                   	nop
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <exit>:

void
exit(void)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ad:	e8 b6 12 00 00       	call   801568 <sys_exit_env>
}
  8002b2:	90                   	nop
  8002b3:	c9                   	leave  
  8002b4:	c3                   	ret    

008002b5 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002be:	8b 00                	mov    (%eax),%eax
  8002c0:	8d 48 01             	lea    0x1(%eax),%ecx
  8002c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c6:	89 0a                	mov    %ecx,(%edx)
  8002c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002cb:	88 d1                	mov    %dl,%cl
  8002cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	8b 00                	mov    (%eax),%eax
  8002d9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002de:	75 2c                	jne    80030c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002e0:	a0 08 30 80 00       	mov    0x803008,%al
  8002e5:	0f b6 c0             	movzbl %al,%eax
  8002e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002eb:	8b 12                	mov    (%edx),%edx
  8002ed:	89 d1                	mov    %edx,%ecx
  8002ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f2:	83 c2 08             	add    $0x8,%edx
  8002f5:	83 ec 04             	sub    $0x4,%esp
  8002f8:	50                   	push   %eax
  8002f9:	51                   	push   %ecx
  8002fa:	52                   	push   %edx
  8002fb:	e8 78 0f 00 00       	call   801278 <sys_cputs>
  800300:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800303:	8b 45 0c             	mov    0xc(%ebp),%eax
  800306:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80030c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030f:	8b 40 04             	mov    0x4(%eax),%eax
  800312:	8d 50 01             	lea    0x1(%eax),%edx
  800315:	8b 45 0c             	mov    0xc(%ebp),%eax
  800318:	89 50 04             	mov    %edx,0x4(%eax)
}
  80031b:	90                   	nop
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800327:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80032e:	00 00 00 
	b.cnt = 0;
  800331:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800338:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80033b:	ff 75 0c             	pushl  0xc(%ebp)
  80033e:	ff 75 08             	pushl  0x8(%ebp)
  800341:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800347:	50                   	push   %eax
  800348:	68 b5 02 80 00       	push   $0x8002b5
  80034d:	e8 11 02 00 00       	call   800563 <vprintfmt>
  800352:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800355:	a0 08 30 80 00       	mov    0x803008,%al
  80035a:	0f b6 c0             	movzbl %al,%eax
  80035d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	50                   	push   %eax
  800367:	52                   	push   %edx
  800368:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80036e:	83 c0 08             	add    $0x8,%eax
  800371:	50                   	push   %eax
  800372:	e8 01 0f 00 00       	call   801278 <sys_cputs>
  800377:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80037a:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800381:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800387:	c9                   	leave  
  800388:	c3                   	ret    

00800389 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80038f:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800396:	8d 45 0c             	lea    0xc(%ebp),%eax
  800399:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80039c:	8b 45 08             	mov    0x8(%ebp),%eax
  80039f:	83 ec 08             	sub    $0x8,%esp
  8003a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a5:	50                   	push   %eax
  8003a6:	e8 73 ff ff ff       	call   80031e <vcprintf>
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003b4:	c9                   	leave  
  8003b5:	c3                   	ret    

008003b6 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003bc:	e8 f9 0e 00 00       	call   8012ba <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003c1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ca:	83 ec 08             	sub    $0x8,%esp
  8003cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d0:	50                   	push   %eax
  8003d1:	e8 48 ff ff ff       	call   80031e <vcprintf>
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003dc:	e8 f3 0e 00 00       	call   8012d4 <sys_unlock_cons>
	return cnt;
  8003e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	53                   	push   %ebx
  8003ea:	83 ec 14             	sub    $0x14,%esp
  8003ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8003f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003f9:	8b 45 18             	mov    0x18(%ebp),%eax
  8003fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800401:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800404:	77 55                	ja     80045b <printnum+0x75>
  800406:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800409:	72 05                	jb     800410 <printnum+0x2a>
  80040b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80040e:	77 4b                	ja     80045b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800410:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800413:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800416:	8b 45 18             	mov    0x18(%ebp),%eax
  800419:	ba 00 00 00 00       	mov    $0x0,%edx
  80041e:	52                   	push   %edx
  80041f:	50                   	push   %eax
  800420:	ff 75 f4             	pushl  -0xc(%ebp)
  800423:	ff 75 f0             	pushl  -0x10(%ebp)
  800426:	e8 5d 17 00 00       	call   801b88 <__udivdi3>
  80042b:	83 c4 10             	add    $0x10,%esp
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	ff 75 20             	pushl  0x20(%ebp)
  800434:	53                   	push   %ebx
  800435:	ff 75 18             	pushl  0x18(%ebp)
  800438:	52                   	push   %edx
  800439:	50                   	push   %eax
  80043a:	ff 75 0c             	pushl  0xc(%ebp)
  80043d:	ff 75 08             	pushl  0x8(%ebp)
  800440:	e8 a1 ff ff ff       	call   8003e6 <printnum>
  800445:	83 c4 20             	add    $0x20,%esp
  800448:	eb 1a                	jmp    800464 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80044a:	83 ec 08             	sub    $0x8,%esp
  80044d:	ff 75 0c             	pushl  0xc(%ebp)
  800450:	ff 75 20             	pushl  0x20(%ebp)
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	ff d0                	call   *%eax
  800458:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80045b:	ff 4d 1c             	decl   0x1c(%ebp)
  80045e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800462:	7f e6                	jg     80044a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800464:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800467:	bb 00 00 00 00       	mov    $0x0,%ebx
  80046c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80046f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800472:	53                   	push   %ebx
  800473:	51                   	push   %ecx
  800474:	52                   	push   %edx
  800475:	50                   	push   %eax
  800476:	e8 1d 18 00 00       	call   801c98 <__umoddi3>
  80047b:	83 c4 10             	add    $0x10,%esp
  80047e:	05 14 21 80 00       	add    $0x802114,%eax
  800483:	8a 00                	mov    (%eax),%al
  800485:	0f be c0             	movsbl %al,%eax
  800488:	83 ec 08             	sub    $0x8,%esp
  80048b:	ff 75 0c             	pushl  0xc(%ebp)
  80048e:	50                   	push   %eax
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	ff d0                	call   *%eax
  800494:	83 c4 10             	add    $0x10,%esp
}
  800497:	90                   	nop
  800498:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004a0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004a4:	7e 1c                	jle    8004c2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	8d 50 08             	lea    0x8(%eax),%edx
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	89 10                	mov    %edx,(%eax)
  8004b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b6:	8b 00                	mov    (%eax),%eax
  8004b8:	83 e8 08             	sub    $0x8,%eax
  8004bb:	8b 50 04             	mov    0x4(%eax),%edx
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	eb 40                	jmp    800502 <getuint+0x65>
	else if (lflag)
  8004c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004c6:	74 1e                	je     8004e6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	8d 50 04             	lea    0x4(%eax),%edx
  8004d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d3:	89 10                	mov    %edx,(%eax)
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	83 e8 04             	sub    $0x4,%eax
  8004dd:	8b 00                	mov    (%eax),%eax
  8004df:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e4:	eb 1c                	jmp    800502 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e9:	8b 00                	mov    (%eax),%eax
  8004eb:	8d 50 04             	lea    0x4(%eax),%edx
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	89 10                	mov    %edx,(%eax)
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	8b 00                	mov    (%eax),%eax
  8004f8:	83 e8 04             	sub    $0x4,%eax
  8004fb:	8b 00                	mov    (%eax),%eax
  8004fd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800502:	5d                   	pop    %ebp
  800503:	c3                   	ret    

00800504 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800504:	55                   	push   %ebp
  800505:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800507:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80050b:	7e 1c                	jle    800529 <getint+0x25>
		return va_arg(*ap, long long);
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	8d 50 08             	lea    0x8(%eax),%edx
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	89 10                	mov    %edx,(%eax)
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	83 e8 08             	sub    $0x8,%eax
  800522:	8b 50 04             	mov    0x4(%eax),%edx
  800525:	8b 00                	mov    (%eax),%eax
  800527:	eb 38                	jmp    800561 <getint+0x5d>
	else if (lflag)
  800529:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80052d:	74 1a                	je     800549 <getint+0x45>
		return va_arg(*ap, long);
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	8d 50 04             	lea    0x4(%eax),%edx
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	89 10                	mov    %edx,(%eax)
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	83 e8 04             	sub    $0x4,%eax
  800544:	8b 00                	mov    (%eax),%eax
  800546:	99                   	cltd   
  800547:	eb 18                	jmp    800561 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	8d 50 04             	lea    0x4(%eax),%edx
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	89 10                	mov    %edx,(%eax)
  800556:	8b 45 08             	mov    0x8(%ebp),%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	83 e8 04             	sub    $0x4,%eax
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	99                   	cltd   
}
  800561:	5d                   	pop    %ebp
  800562:	c3                   	ret    

00800563 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800563:	55                   	push   %ebp
  800564:	89 e5                	mov    %esp,%ebp
  800566:	56                   	push   %esi
  800567:	53                   	push   %ebx
  800568:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80056b:	eb 17                	jmp    800584 <vprintfmt+0x21>
			if (ch == '\0')
  80056d:	85 db                	test   %ebx,%ebx
  80056f:	0f 84 c1 03 00 00    	je     800936 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800575:	83 ec 08             	sub    $0x8,%esp
  800578:	ff 75 0c             	pushl  0xc(%ebp)
  80057b:	53                   	push   %ebx
  80057c:	8b 45 08             	mov    0x8(%ebp),%eax
  80057f:	ff d0                	call   *%eax
  800581:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800584:	8b 45 10             	mov    0x10(%ebp),%eax
  800587:	8d 50 01             	lea    0x1(%eax),%edx
  80058a:	89 55 10             	mov    %edx,0x10(%ebp)
  80058d:	8a 00                	mov    (%eax),%al
  80058f:	0f b6 d8             	movzbl %al,%ebx
  800592:	83 fb 25             	cmp    $0x25,%ebx
  800595:	75 d6                	jne    80056d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800597:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80059b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005a2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005b0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ba:	8d 50 01             	lea    0x1(%eax),%edx
  8005bd:	89 55 10             	mov    %edx,0x10(%ebp)
  8005c0:	8a 00                	mov    (%eax),%al
  8005c2:	0f b6 d8             	movzbl %al,%ebx
  8005c5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005c8:	83 f8 5b             	cmp    $0x5b,%eax
  8005cb:	0f 87 3d 03 00 00    	ja     80090e <vprintfmt+0x3ab>
  8005d1:	8b 04 85 38 21 80 00 	mov    0x802138(,%eax,4),%eax
  8005d8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005da:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005de:	eb d7                	jmp    8005b7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005e0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005e4:	eb d1                	jmp    8005b7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005e6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005f0:	89 d0                	mov    %edx,%eax
  8005f2:	c1 e0 02             	shl    $0x2,%eax
  8005f5:	01 d0                	add    %edx,%eax
  8005f7:	01 c0                	add    %eax,%eax
  8005f9:	01 d8                	add    %ebx,%eax
  8005fb:	83 e8 30             	sub    $0x30,%eax
  8005fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800601:	8b 45 10             	mov    0x10(%ebp),%eax
  800604:	8a 00                	mov    (%eax),%al
  800606:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800609:	83 fb 2f             	cmp    $0x2f,%ebx
  80060c:	7e 3e                	jle    80064c <vprintfmt+0xe9>
  80060e:	83 fb 39             	cmp    $0x39,%ebx
  800611:	7f 39                	jg     80064c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800613:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800616:	eb d5                	jmp    8005ed <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	83 c0 04             	add    $0x4,%eax
  80061e:	89 45 14             	mov    %eax,0x14(%ebp)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	83 e8 04             	sub    $0x4,%eax
  800627:	8b 00                	mov    (%eax),%eax
  800629:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80062c:	eb 1f                	jmp    80064d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80062e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800632:	79 83                	jns    8005b7 <vprintfmt+0x54>
				width = 0;
  800634:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80063b:	e9 77 ff ff ff       	jmp    8005b7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800640:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800647:	e9 6b ff ff ff       	jmp    8005b7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80064c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80064d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800651:	0f 89 60 ff ff ff    	jns    8005b7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800657:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80065d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800664:	e9 4e ff ff ff       	jmp    8005b7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800669:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80066c:	e9 46 ff ff ff       	jmp    8005b7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	83 c0 04             	add    $0x4,%eax
  800677:	89 45 14             	mov    %eax,0x14(%ebp)
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	83 e8 04             	sub    $0x4,%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	83 ec 08             	sub    $0x8,%esp
  800685:	ff 75 0c             	pushl  0xc(%ebp)
  800688:	50                   	push   %eax
  800689:	8b 45 08             	mov    0x8(%ebp),%eax
  80068c:	ff d0                	call   *%eax
  80068e:	83 c4 10             	add    $0x10,%esp
			break;
  800691:	e9 9b 02 00 00       	jmp    800931 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	83 c0 04             	add    $0x4,%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	83 e8 04             	sub    $0x4,%eax
  8006a5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006a7:	85 db                	test   %ebx,%ebx
  8006a9:	79 02                	jns    8006ad <vprintfmt+0x14a>
				err = -err;
  8006ab:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006ad:	83 fb 64             	cmp    $0x64,%ebx
  8006b0:	7f 0b                	jg     8006bd <vprintfmt+0x15a>
  8006b2:	8b 34 9d 80 1f 80 00 	mov    0x801f80(,%ebx,4),%esi
  8006b9:	85 f6                	test   %esi,%esi
  8006bb:	75 19                	jne    8006d6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006bd:	53                   	push   %ebx
  8006be:	68 25 21 80 00       	push   $0x802125
  8006c3:	ff 75 0c             	pushl  0xc(%ebp)
  8006c6:	ff 75 08             	pushl  0x8(%ebp)
  8006c9:	e8 70 02 00 00       	call   80093e <printfmt>
  8006ce:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006d1:	e9 5b 02 00 00       	jmp    800931 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006d6:	56                   	push   %esi
  8006d7:	68 2e 21 80 00       	push   $0x80212e
  8006dc:	ff 75 0c             	pushl  0xc(%ebp)
  8006df:	ff 75 08             	pushl  0x8(%ebp)
  8006e2:	e8 57 02 00 00       	call   80093e <printfmt>
  8006e7:	83 c4 10             	add    $0x10,%esp
			break;
  8006ea:	e9 42 02 00 00       	jmp    800931 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	83 c0 04             	add    $0x4,%eax
  8006f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	83 e8 04             	sub    $0x4,%eax
  8006fe:	8b 30                	mov    (%eax),%esi
  800700:	85 f6                	test   %esi,%esi
  800702:	75 05                	jne    800709 <vprintfmt+0x1a6>
				p = "(null)";
  800704:	be 31 21 80 00       	mov    $0x802131,%esi
			if (width > 0 && padc != '-')
  800709:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070d:	7e 6d                	jle    80077c <vprintfmt+0x219>
  80070f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800713:	74 67                	je     80077c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800715:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	50                   	push   %eax
  80071c:	56                   	push   %esi
  80071d:	e8 1e 03 00 00       	call   800a40 <strnlen>
  800722:	83 c4 10             	add    $0x10,%esp
  800725:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800728:	eb 16                	jmp    800740 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80072a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	ff 75 0c             	pushl  0xc(%ebp)
  800734:	50                   	push   %eax
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	ff d0                	call   *%eax
  80073a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80073d:	ff 4d e4             	decl   -0x1c(%ebp)
  800740:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800744:	7f e4                	jg     80072a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800746:	eb 34                	jmp    80077c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800748:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80074c:	74 1c                	je     80076a <vprintfmt+0x207>
  80074e:	83 fb 1f             	cmp    $0x1f,%ebx
  800751:	7e 05                	jle    800758 <vprintfmt+0x1f5>
  800753:	83 fb 7e             	cmp    $0x7e,%ebx
  800756:	7e 12                	jle    80076a <vprintfmt+0x207>
					putch('?', putdat);
  800758:	83 ec 08             	sub    $0x8,%esp
  80075b:	ff 75 0c             	pushl  0xc(%ebp)
  80075e:	6a 3f                	push   $0x3f
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	ff d0                	call   *%eax
  800765:	83 c4 10             	add    $0x10,%esp
  800768:	eb 0f                	jmp    800779 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	53                   	push   %ebx
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	ff d0                	call   *%eax
  800776:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800779:	ff 4d e4             	decl   -0x1c(%ebp)
  80077c:	89 f0                	mov    %esi,%eax
  80077e:	8d 70 01             	lea    0x1(%eax),%esi
  800781:	8a 00                	mov    (%eax),%al
  800783:	0f be d8             	movsbl %al,%ebx
  800786:	85 db                	test   %ebx,%ebx
  800788:	74 24                	je     8007ae <vprintfmt+0x24b>
  80078a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80078e:	78 b8                	js     800748 <vprintfmt+0x1e5>
  800790:	ff 4d e0             	decl   -0x20(%ebp)
  800793:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800797:	79 af                	jns    800748 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800799:	eb 13                	jmp    8007ae <vprintfmt+0x24b>
				putch(' ', putdat);
  80079b:	83 ec 08             	sub    $0x8,%esp
  80079e:	ff 75 0c             	pushl  0xc(%ebp)
  8007a1:	6a 20                	push   $0x20
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	ff d0                	call   *%eax
  8007a8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007ab:	ff 4d e4             	decl   -0x1c(%ebp)
  8007ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b2:	7f e7                	jg     80079b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007b4:	e9 78 01 00 00       	jmp    800931 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007b9:	83 ec 08             	sub    $0x8,%esp
  8007bc:	ff 75 e8             	pushl  -0x18(%ebp)
  8007bf:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c2:	50                   	push   %eax
  8007c3:	e8 3c fd ff ff       	call   800504 <getint>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d7:	85 d2                	test   %edx,%edx
  8007d9:	79 23                	jns    8007fe <vprintfmt+0x29b>
				putch('-', putdat);
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 0c             	pushl  0xc(%ebp)
  8007e1:	6a 2d                	push   $0x2d
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	ff d0                	call   *%eax
  8007e8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f1:	f7 d8                	neg    %eax
  8007f3:	83 d2 00             	adc    $0x0,%edx
  8007f6:	f7 da                	neg    %edx
  8007f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007fe:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800805:	e9 bc 00 00 00       	jmp    8008c6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 e8             	pushl  -0x18(%ebp)
  800810:	8d 45 14             	lea    0x14(%ebp),%eax
  800813:	50                   	push   %eax
  800814:	e8 84 fc ff ff       	call   80049d <getuint>
  800819:	83 c4 10             	add    $0x10,%esp
  80081c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800822:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800829:	e9 98 00 00 00       	jmp    8008c6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	ff 75 0c             	pushl  0xc(%ebp)
  800834:	6a 58                	push   $0x58
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	6a 58                	push   $0x58
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	ff d0                	call   *%eax
  80084b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	ff 75 0c             	pushl  0xc(%ebp)
  800854:	6a 58                	push   $0x58
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	ff d0                	call   *%eax
  80085b:	83 c4 10             	add    $0x10,%esp
			break;
  80085e:	e9 ce 00 00 00       	jmp    800931 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	6a 30                	push   $0x30
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	ff d0                	call   *%eax
  800870:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800873:	83 ec 08             	sub    $0x8,%esp
  800876:	ff 75 0c             	pushl  0xc(%ebp)
  800879:	6a 78                	push   $0x78
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	ff d0                	call   *%eax
  800880:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	83 c0 04             	add    $0x4,%eax
  800889:	89 45 14             	mov    %eax,0x14(%ebp)
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	83 e8 04             	sub    $0x4,%eax
  800892:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800894:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800897:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80089e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008a5:	eb 1f                	jmp    8008c6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008a7:	83 ec 08             	sub    $0x8,%esp
  8008aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8008ad:	8d 45 14             	lea    0x14(%ebp),%eax
  8008b0:	50                   	push   %eax
  8008b1:	e8 e7 fb ff ff       	call   80049d <getuint>
  8008b6:	83 c4 10             	add    $0x10,%esp
  8008b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008bf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008c6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008cd:	83 ec 04             	sub    $0x4,%esp
  8008d0:	52                   	push   %edx
  8008d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008d4:	50                   	push   %eax
  8008d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	ff 75 08             	pushl  0x8(%ebp)
  8008e1:	e8 00 fb ff ff       	call   8003e6 <printnum>
  8008e6:	83 c4 20             	add    $0x20,%esp
			break;
  8008e9:	eb 46                	jmp    800931 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	ff 75 0c             	pushl  0xc(%ebp)
  8008f1:	53                   	push   %ebx
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	ff d0                	call   *%eax
  8008f7:	83 c4 10             	add    $0x10,%esp
			break;
  8008fa:	eb 35                	jmp    800931 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008fc:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800903:	eb 2c                	jmp    800931 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800905:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  80090c:	eb 23                	jmp    800931 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	6a 25                	push   $0x25
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	ff d0                	call   *%eax
  80091b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80091e:	ff 4d 10             	decl   0x10(%ebp)
  800921:	eb 03                	jmp    800926 <vprintfmt+0x3c3>
  800923:	ff 4d 10             	decl   0x10(%ebp)
  800926:	8b 45 10             	mov    0x10(%ebp),%eax
  800929:	48                   	dec    %eax
  80092a:	8a 00                	mov    (%eax),%al
  80092c:	3c 25                	cmp    $0x25,%al
  80092e:	75 f3                	jne    800923 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800930:	90                   	nop
		}
	}
  800931:	e9 35 fc ff ff       	jmp    80056b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800936:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800937:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80093a:	5b                   	pop    %ebx
  80093b:	5e                   	pop    %esi
  80093c:	5d                   	pop    %ebp
  80093d:	c3                   	ret    

0080093e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800944:	8d 45 10             	lea    0x10(%ebp),%eax
  800947:	83 c0 04             	add    $0x4,%eax
  80094a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80094d:	8b 45 10             	mov    0x10(%ebp),%eax
  800950:	ff 75 f4             	pushl  -0xc(%ebp)
  800953:	50                   	push   %eax
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	ff 75 08             	pushl  0x8(%ebp)
  80095a:	e8 04 fc ff ff       	call   800563 <vprintfmt>
  80095f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800962:	90                   	nop
  800963:	c9                   	leave  
  800964:	c3                   	ret    

00800965 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096b:	8b 40 08             	mov    0x8(%eax),%eax
  80096e:	8d 50 01             	lea    0x1(%eax),%edx
  800971:	8b 45 0c             	mov    0xc(%ebp),%eax
  800974:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097a:	8b 10                	mov    (%eax),%edx
  80097c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097f:	8b 40 04             	mov    0x4(%eax),%eax
  800982:	39 c2                	cmp    %eax,%edx
  800984:	73 12                	jae    800998 <sprintputch+0x33>
		*b->buf++ = ch;
  800986:	8b 45 0c             	mov    0xc(%ebp),%eax
  800989:	8b 00                	mov    (%eax),%eax
  80098b:	8d 48 01             	lea    0x1(%eax),%ecx
  80098e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800991:	89 0a                	mov    %ecx,(%edx)
  800993:	8b 55 08             	mov    0x8(%ebp),%edx
  800996:	88 10                	mov    %dl,(%eax)
}
  800998:	90                   	nop
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009aa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	01 d0                	add    %edx,%eax
  8009b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009c0:	74 06                	je     8009c8 <vsnprintf+0x2d>
  8009c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009c6:	7f 07                	jg     8009cf <vsnprintf+0x34>
		return -E_INVAL;
  8009c8:	b8 03 00 00 00       	mov    $0x3,%eax
  8009cd:	eb 20                	jmp    8009ef <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009cf:	ff 75 14             	pushl  0x14(%ebp)
  8009d2:	ff 75 10             	pushl  0x10(%ebp)
  8009d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009d8:	50                   	push   %eax
  8009d9:	68 65 09 80 00       	push   $0x800965
  8009de:	e8 80 fb ff ff       	call   800563 <vprintfmt>
  8009e3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009e9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009ef:	c9                   	leave  
  8009f0:	c3                   	ret    

008009f1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009f7:	8d 45 10             	lea    0x10(%ebp),%eax
  8009fa:	83 c0 04             	add    $0x4,%eax
  8009fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a00:	8b 45 10             	mov    0x10(%ebp),%eax
  800a03:	ff 75 f4             	pushl  -0xc(%ebp)
  800a06:	50                   	push   %eax
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	ff 75 08             	pushl  0x8(%ebp)
  800a0d:	e8 89 ff ff ff       	call   80099b <vsnprintf>
  800a12:	83 c4 10             	add    $0x10,%esp
  800a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a1b:	c9                   	leave  
  800a1c:	c3                   	ret    

00800a1d <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2a:	eb 06                	jmp    800a32 <strlen+0x15>
		n++;
  800a2c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a2f:	ff 45 08             	incl   0x8(%ebp)
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	8a 00                	mov    (%eax),%al
  800a37:	84 c0                	test   %al,%al
  800a39:	75 f1                	jne    800a2c <strlen+0xf>
		n++;
	return n;
  800a3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a3e:	c9                   	leave  
  800a3f:	c3                   	ret    

00800a40 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a4d:	eb 09                	jmp    800a58 <strnlen+0x18>
		n++;
  800a4f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a52:	ff 45 08             	incl   0x8(%ebp)
  800a55:	ff 4d 0c             	decl   0xc(%ebp)
  800a58:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a5c:	74 09                	je     800a67 <strnlen+0x27>
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	8a 00                	mov    (%eax),%al
  800a63:	84 c0                	test   %al,%al
  800a65:	75 e8                	jne    800a4f <strnlen+0xf>
		n++;
	return n;
  800a67:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a6a:	c9                   	leave  
  800a6b:	c3                   	ret    

00800a6c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a78:	90                   	nop
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	8d 50 01             	lea    0x1(%eax),%edx
  800a7f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a85:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a88:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a8b:	8a 12                	mov    (%edx),%dl
  800a8d:	88 10                	mov    %dl,(%eax)
  800a8f:	8a 00                	mov    (%eax),%al
  800a91:	84 c0                	test   %al,%al
  800a93:	75 e4                	jne    800a79 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a98:	c9                   	leave  
  800a99:	c3                   	ret    

00800a9a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800aa6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aad:	eb 1f                	jmp    800ace <strncpy+0x34>
		*dst++ = *src;
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	8d 50 01             	lea    0x1(%eax),%edx
  800ab5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abb:	8a 12                	mov    (%edx),%dl
  800abd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800abf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac2:	8a 00                	mov    (%eax),%al
  800ac4:	84 c0                	test   %al,%al
  800ac6:	74 03                	je     800acb <strncpy+0x31>
			src++;
  800ac8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800acb:	ff 45 fc             	incl   -0x4(%ebp)
  800ace:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ad4:	72 d9                	jb     800aaf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ad6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ad9:	c9                   	leave  
  800ada:	c3                   	ret    

00800adb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ae7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aeb:	74 30                	je     800b1d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800aed:	eb 16                	jmp    800b05 <strlcpy+0x2a>
			*dst++ = *src++;
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8d 50 01             	lea    0x1(%eax),%edx
  800af5:	89 55 08             	mov    %edx,0x8(%ebp)
  800af8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800afe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b01:	8a 12                	mov    (%edx),%dl
  800b03:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b05:	ff 4d 10             	decl   0x10(%ebp)
  800b08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b0c:	74 09                	je     800b17 <strlcpy+0x3c>
  800b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b11:	8a 00                	mov    (%eax),%al
  800b13:	84 c0                	test   %al,%al
  800b15:	75 d8                	jne    800aef <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b23:	29 c2                	sub    %eax,%edx
  800b25:	89 d0                	mov    %edx,%eax
}
  800b27:	c9                   	leave  
  800b28:	c3                   	ret    

00800b29 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b2c:	eb 06                	jmp    800b34 <strcmp+0xb>
		p++, q++;
  800b2e:	ff 45 08             	incl   0x8(%ebp)
  800b31:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8a 00                	mov    (%eax),%al
  800b39:	84 c0                	test   %al,%al
  800b3b:	74 0e                	je     800b4b <strcmp+0x22>
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	8a 10                	mov    (%eax),%dl
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8a 00                	mov    (%eax),%al
  800b47:	38 c2                	cmp    %al,%dl
  800b49:	74 e3                	je     800b2e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	8a 00                	mov    (%eax),%al
  800b50:	0f b6 d0             	movzbl %al,%edx
  800b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b56:	8a 00                	mov    (%eax),%al
  800b58:	0f b6 c0             	movzbl %al,%eax
  800b5b:	29 c2                	sub    %eax,%edx
  800b5d:	89 d0                	mov    %edx,%eax
}
  800b5f:	5d                   	pop    %ebp
  800b60:	c3                   	ret    

00800b61 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b64:	eb 09                	jmp    800b6f <strncmp+0xe>
		n--, p++, q++;
  800b66:	ff 4d 10             	decl   0x10(%ebp)
  800b69:	ff 45 08             	incl   0x8(%ebp)
  800b6c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b73:	74 17                	je     800b8c <strncmp+0x2b>
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	8a 00                	mov    (%eax),%al
  800b7a:	84 c0                	test   %al,%al
  800b7c:	74 0e                	je     800b8c <strncmp+0x2b>
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	8a 10                	mov    (%eax),%dl
  800b83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b86:	8a 00                	mov    (%eax),%al
  800b88:	38 c2                	cmp    %al,%dl
  800b8a:	74 da                	je     800b66 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b90:	75 07                	jne    800b99 <strncmp+0x38>
		return 0;
  800b92:	b8 00 00 00 00       	mov    $0x0,%eax
  800b97:	eb 14                	jmp    800bad <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8a 00                	mov    (%eax),%al
  800b9e:	0f b6 d0             	movzbl %al,%edx
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8a 00                	mov    (%eax),%al
  800ba6:	0f b6 c0             	movzbl %al,%eax
  800ba9:	29 c2                	sub    %eax,%edx
  800bab:	89 d0                	mov    %edx,%eax
}
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	83 ec 04             	sub    $0x4,%esp
  800bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bbb:	eb 12                	jmp    800bcf <strchr+0x20>
		if (*s == c)
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	8a 00                	mov    (%eax),%al
  800bc2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bc5:	75 05                	jne    800bcc <strchr+0x1d>
			return (char *) s;
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	eb 11                	jmp    800bdd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bcc:	ff 45 08             	incl   0x8(%ebp)
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	8a 00                	mov    (%eax),%al
  800bd4:	84 c0                	test   %al,%al
  800bd6:	75 e5                	jne    800bbd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bdd:	c9                   	leave  
  800bde:	c3                   	ret    

00800bdf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	83 ec 04             	sub    $0x4,%esp
  800be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800beb:	eb 0d                	jmp    800bfa <strfind+0x1b>
		if (*s == c)
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	8a 00                	mov    (%eax),%al
  800bf2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bf5:	74 0e                	je     800c05 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bf7:	ff 45 08             	incl   0x8(%ebp)
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	8a 00                	mov    (%eax),%al
  800bff:	84 c0                	test   %al,%al
  800c01:	75 ea                	jne    800bed <strfind+0xe>
  800c03:	eb 01                	jmp    800c06 <strfind+0x27>
		if (*s == c)
			break;
  800c05:	90                   	nop
	return (char *) s;
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c17:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c1d:	eb 0e                	jmp    800c2d <memset+0x22>
		*p++ = c;
  800c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c22:	8d 50 01             	lea    0x1(%eax),%edx
  800c25:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c2d:	ff 4d f8             	decl   -0x8(%ebp)
  800c30:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c34:	79 e9                	jns    800c1f <memset+0x14>
		*p++ = c;

	return v;
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c39:	c9                   	leave  
  800c3a:	c3                   	ret    

00800c3b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c4d:	eb 16                	jmp    800c65 <memcpy+0x2a>
		*d++ = *s++;
  800c4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c52:	8d 50 01             	lea    0x1(%eax),%edx
  800c55:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c5e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c61:	8a 12                	mov    (%edx),%dl
  800c63:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c65:	8b 45 10             	mov    0x10(%ebp),%eax
  800c68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c6e:	85 c0                	test   %eax,%eax
  800c70:	75 dd                	jne    800c4f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c75:	c9                   	leave  
  800c76:	c3                   	ret    

00800c77 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c8c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c8f:	73 50                	jae    800ce1 <memmove+0x6a>
  800c91:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c94:	8b 45 10             	mov    0x10(%ebp),%eax
  800c97:	01 d0                	add    %edx,%eax
  800c99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c9c:	76 43                	jbe    800ce1 <memmove+0x6a>
		s += n;
  800c9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ca4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800caa:	eb 10                	jmp    800cbc <memmove+0x45>
			*--d = *--s;
  800cac:	ff 4d f8             	decl   -0x8(%ebp)
  800caf:	ff 4d fc             	decl   -0x4(%ebp)
  800cb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb5:	8a 10                	mov    (%eax),%dl
  800cb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cba:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800cbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc2:	89 55 10             	mov    %edx,0x10(%ebp)
  800cc5:	85 c0                	test   %eax,%eax
  800cc7:	75 e3                	jne    800cac <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cc9:	eb 23                	jmp    800cee <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ccb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cce:	8d 50 01             	lea    0x1(%eax),%edx
  800cd1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cd4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cd7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cda:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cdd:	8a 12                	mov    (%edx),%dl
  800cdf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ce1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ce7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cea:	85 c0                	test   %eax,%eax
  800cec:	75 dd                	jne    800ccb <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d02:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d05:	eb 2a                	jmp    800d31 <memcmp+0x3e>
		if (*s1 != *s2)
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0a:	8a 10                	mov    (%eax),%dl
  800d0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	38 c2                	cmp    %al,%dl
  800d13:	74 16                	je     800d2b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	0f b6 d0             	movzbl %al,%edx
  800d1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	0f b6 c0             	movzbl %al,%eax
  800d25:	29 c2                	sub    %eax,%edx
  800d27:	89 d0                	mov    %edx,%eax
  800d29:	eb 18                	jmp    800d43 <memcmp+0x50>
		s1++, s2++;
  800d2b:	ff 45 fc             	incl   -0x4(%ebp)
  800d2e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d31:	8b 45 10             	mov    0x10(%ebp),%eax
  800d34:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d37:	89 55 10             	mov    %edx,0x10(%ebp)
  800d3a:	85 c0                	test   %eax,%eax
  800d3c:	75 c9                	jne    800d07 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d43:	c9                   	leave  
  800d44:	c3                   	ret    

00800d45 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d51:	01 d0                	add    %edx,%eax
  800d53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d56:	eb 15                	jmp    800d6d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	0f b6 d0             	movzbl %al,%edx
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	0f b6 c0             	movzbl %al,%eax
  800d66:	39 c2                	cmp    %eax,%edx
  800d68:	74 0d                	je     800d77 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d6a:	ff 45 08             	incl   0x8(%ebp)
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d73:	72 e3                	jb     800d58 <memfind+0x13>
  800d75:	eb 01                	jmp    800d78 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d77:	90                   	nop
	return (void *) s;
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d7b:	c9                   	leave  
  800d7c:	c3                   	ret    

00800d7d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d8a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d91:	eb 03                	jmp    800d96 <strtol+0x19>
		s++;
  800d93:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3c 20                	cmp    $0x20,%al
  800d9d:	74 f4                	je     800d93 <strtol+0x16>
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	8a 00                	mov    (%eax),%al
  800da4:	3c 09                	cmp    $0x9,%al
  800da6:	74 eb                	je     800d93 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	3c 2b                	cmp    $0x2b,%al
  800daf:	75 05                	jne    800db6 <strtol+0x39>
		s++;
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	eb 13                	jmp    800dc9 <strtol+0x4c>
	else if (*s == '-')
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	3c 2d                	cmp    $0x2d,%al
  800dbd:	75 0a                	jne    800dc9 <strtol+0x4c>
		s++, neg = 1;
  800dbf:	ff 45 08             	incl   0x8(%ebp)
  800dc2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dc9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dcd:	74 06                	je     800dd5 <strtol+0x58>
  800dcf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800dd3:	75 20                	jne    800df5 <strtol+0x78>
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	8a 00                	mov    (%eax),%al
  800dda:	3c 30                	cmp    $0x30,%al
  800ddc:	75 17                	jne    800df5 <strtol+0x78>
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	40                   	inc    %eax
  800de2:	8a 00                	mov    (%eax),%al
  800de4:	3c 78                	cmp    $0x78,%al
  800de6:	75 0d                	jne    800df5 <strtol+0x78>
		s += 2, base = 16;
  800de8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dec:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800df3:	eb 28                	jmp    800e1d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800df5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df9:	75 15                	jne    800e10 <strtol+0x93>
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8a 00                	mov    (%eax),%al
  800e00:	3c 30                	cmp    $0x30,%al
  800e02:	75 0c                	jne    800e10 <strtol+0x93>
		s++, base = 8;
  800e04:	ff 45 08             	incl   0x8(%ebp)
  800e07:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e0e:	eb 0d                	jmp    800e1d <strtol+0xa0>
	else if (base == 0)
  800e10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e14:	75 07                	jne    800e1d <strtol+0xa0>
		base = 10;
  800e16:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	3c 2f                	cmp    $0x2f,%al
  800e24:	7e 19                	jle    800e3f <strtol+0xc2>
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8a 00                	mov    (%eax),%al
  800e2b:	3c 39                	cmp    $0x39,%al
  800e2d:	7f 10                	jg     800e3f <strtol+0xc2>
			dig = *s - '0';
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	8a 00                	mov    (%eax),%al
  800e34:	0f be c0             	movsbl %al,%eax
  800e37:	83 e8 30             	sub    $0x30,%eax
  800e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e3d:	eb 42                	jmp    800e81 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	3c 60                	cmp    $0x60,%al
  800e46:	7e 19                	jle    800e61 <strtol+0xe4>
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	3c 7a                	cmp    $0x7a,%al
  800e4f:	7f 10                	jg     800e61 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8a 00                	mov    (%eax),%al
  800e56:	0f be c0             	movsbl %al,%eax
  800e59:	83 e8 57             	sub    $0x57,%eax
  800e5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e5f:	eb 20                	jmp    800e81 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	3c 40                	cmp    $0x40,%al
  800e68:	7e 39                	jle    800ea3 <strtol+0x126>
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	3c 5a                	cmp    $0x5a,%al
  800e71:	7f 30                	jg     800ea3 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	0f be c0             	movsbl %al,%eax
  800e7b:	83 e8 37             	sub    $0x37,%eax
  800e7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e84:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e87:	7d 19                	jge    800ea2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e89:	ff 45 08             	incl   0x8(%ebp)
  800e8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e93:	89 c2                	mov    %eax,%edx
  800e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e98:	01 d0                	add    %edx,%eax
  800e9a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e9d:	e9 7b ff ff ff       	jmp    800e1d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ea2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ea3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea7:	74 08                	je     800eb1 <strtol+0x134>
		*endptr = (char *) s;
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaf:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800eb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800eb5:	74 07                	je     800ebe <strtol+0x141>
  800eb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eba:	f7 d8                	neg    %eax
  800ebc:	eb 03                	jmp    800ec1 <strtol+0x144>
  800ebe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec1:	c9                   	leave  
  800ec2:	c3                   	ret    

00800ec3 <ltostr>:

void
ltostr(long value, char *str)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ec9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800ed0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ed7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800edb:	79 13                	jns    800ef0 <ltostr+0x2d>
	{
		neg = 1;
  800edd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eea:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800eed:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ef8:	99                   	cltd   
  800ef9:	f7 f9                	idiv   %ecx
  800efb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800efe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f01:	8d 50 01             	lea    0x1(%eax),%edx
  800f04:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f07:	89 c2                	mov    %eax,%edx
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	01 d0                	add    %edx,%eax
  800f0e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f11:	83 c2 30             	add    $0x30,%edx
  800f14:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f19:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f1e:	f7 e9                	imul   %ecx
  800f20:	c1 fa 02             	sar    $0x2,%edx
  800f23:	89 c8                	mov    %ecx,%eax
  800f25:	c1 f8 1f             	sar    $0x1f,%eax
  800f28:	29 c2                	sub    %eax,%edx
  800f2a:	89 d0                	mov    %edx,%eax
  800f2c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f33:	75 bb                	jne    800ef0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3f:	48                   	dec    %eax
  800f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f43:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f47:	74 3d                	je     800f86 <ltostr+0xc3>
		start = 1 ;
  800f49:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f50:	eb 34                	jmp    800f86 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	01 d0                	add    %edx,%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	01 c2                	add    %eax,%edx
  800f67:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	01 c8                	add    %ecx,%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	01 c2                	add    %eax,%edx
  800f7b:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7e:	88 02                	mov    %al,(%edx)
		start++ ;
  800f80:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f83:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f89:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8c:	7c c4                	jl     800f52 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	01 d0                	add    %edx,%eax
  800f96:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f99:	90                   	nop
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa2:	ff 75 08             	pushl  0x8(%ebp)
  800fa5:	e8 73 fa ff ff       	call   800a1d <strlen>
  800faa:	83 c4 04             	add    $0x4,%esp
  800fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fb0:	ff 75 0c             	pushl  0xc(%ebp)
  800fb3:	e8 65 fa ff ff       	call   800a1d <strlen>
  800fb8:	83 c4 04             	add    $0x4,%esp
  800fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcc:	eb 17                	jmp    800fe5 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 c2                	add    %eax,%edx
  800fd6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	01 c8                	add    %ecx,%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe2:	ff 45 fc             	incl   -0x4(%ebp)
  800fe5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800feb:	7c e1                	jl     800fce <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffb:	eb 1f                	jmp    80101c <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8d 50 01             	lea    0x1(%eax),%edx
  801003:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801006:	89 c2                	mov    %eax,%edx
  801008:	8b 45 10             	mov    0x10(%ebp),%eax
  80100b:	01 c2                	add    %eax,%edx
  80100d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	01 c8                	add    %ecx,%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801019:	ff 45 f8             	incl   -0x8(%ebp)
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801022:	7c d9                	jl     800ffd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801024:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801027:	8b 45 10             	mov    0x10(%ebp),%eax
  80102a:	01 d0                	add    %edx,%eax
  80102c:	c6 00 00             	movb   $0x0,(%eax)
}
  80102f:	90                   	nop
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801035:	8b 45 14             	mov    0x14(%ebp),%eax
  801038:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103e:	8b 45 14             	mov    0x14(%ebp),%eax
  801041:	8b 00                	mov    (%eax),%eax
  801043:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80104a:	8b 45 10             	mov    0x10(%ebp),%eax
  80104d:	01 d0                	add    %edx,%eax
  80104f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801055:	eb 0c                	jmp    801063 <strsplit+0x31>
			*string++ = 0;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	8d 50 01             	lea    0x1(%eax),%edx
  80105d:	89 55 08             	mov    %edx,0x8(%ebp)
  801060:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	84 c0                	test   %al,%al
  80106a:	74 18                	je     801084 <strsplit+0x52>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	0f be c0             	movsbl %al,%eax
  801074:	50                   	push   %eax
  801075:	ff 75 0c             	pushl  0xc(%ebp)
  801078:	e8 32 fb ff ff       	call   800baf <strchr>
  80107d:	83 c4 08             	add    $0x8,%esp
  801080:	85 c0                	test   %eax,%eax
  801082:	75 d3                	jne    801057 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	84 c0                	test   %al,%al
  80108b:	74 5a                	je     8010e7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108d:	8b 45 14             	mov    0x14(%ebp),%eax
  801090:	8b 00                	mov    (%eax),%eax
  801092:	83 f8 0f             	cmp    $0xf,%eax
  801095:	75 07                	jne    80109e <strsplit+0x6c>
		{
			return 0;
  801097:	b8 00 00 00 00       	mov    $0x0,%eax
  80109c:	eb 66                	jmp    801104 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109e:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a6:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a9:	89 0a                	mov    %ecx,(%edx)
  8010ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b5:	01 c2                	add    %eax,%edx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bc:	eb 03                	jmp    8010c1 <strsplit+0x8f>
			string++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	84 c0                	test   %al,%al
  8010c8:	74 8b                	je     801055 <strsplit+0x23>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	0f be c0             	movsbl %al,%eax
  8010d2:	50                   	push   %eax
  8010d3:	ff 75 0c             	pushl  0xc(%ebp)
  8010d6:	e8 d4 fa ff ff       	call   800baf <strchr>
  8010db:	83 c4 08             	add    $0x8,%esp
  8010de:	85 c0                	test   %eax,%eax
  8010e0:	74 dc                	je     8010be <strsplit+0x8c>
			string++;
	}
  8010e2:	e9 6e ff ff ff       	jmp    801055 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010eb:	8b 00                	mov    (%eax),%eax
  8010ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f7:	01 d0                	add    %edx,%eax
  8010f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010ff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801104:	c9                   	leave  
  801105:	c3                   	ret    

00801106 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80110c:	83 ec 04             	sub    $0x4,%esp
  80110f:	68 a8 22 80 00       	push   $0x8022a8
  801114:	68 3f 01 00 00       	push   $0x13f
  801119:	68 ca 22 80 00       	push   $0x8022ca
  80111e:	e8 7a 08 00 00       	call   80199d <_panic>

00801123 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
  801126:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801129:	83 ec 0c             	sub    $0xc,%esp
  80112c:	ff 75 08             	pushl  0x8(%ebp)
  80112f:	e8 ef 06 00 00       	call   801823 <sys_sbrk>
  801134:	83 c4 10             	add    $0x10,%esp
}
  801137:	c9                   	leave  
  801138:	c3                   	ret    

00801139 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80113f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801143:	75 07                	jne    80114c <malloc+0x13>
  801145:	b8 00 00 00 00       	mov    $0x0,%eax
  80114a:	eb 14                	jmp    801160 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80114c:	83 ec 04             	sub    $0x4,%esp
  80114f:	68 d8 22 80 00       	push   $0x8022d8
  801154:	6a 1b                	push   $0x1b
  801156:	68 fd 22 80 00       	push   $0x8022fd
  80115b:	e8 3d 08 00 00       	call   80199d <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801160:	c9                   	leave  
  801161:	c3                   	ret    

00801162 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801168:	83 ec 04             	sub    $0x4,%esp
  80116b:	68 0c 23 80 00       	push   $0x80230c
  801170:	6a 29                	push   $0x29
  801172:	68 fd 22 80 00       	push   $0x8022fd
  801177:	e8 21 08 00 00       	call   80199d <_panic>

0080117c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	83 ec 18             	sub    $0x18,%esp
  801182:	8b 45 10             	mov    0x10(%ebp),%eax
  801185:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801188:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80118c:	75 07                	jne    801195 <smalloc+0x19>
  80118e:	b8 00 00 00 00       	mov    $0x0,%eax
  801193:	eb 14                	jmp    8011a9 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801195:	83 ec 04             	sub    $0x4,%esp
  801198:	68 30 23 80 00       	push   $0x802330
  80119d:	6a 38                	push   $0x38
  80119f:	68 fd 22 80 00       	push   $0x8022fd
  8011a4:	e8 f4 07 00 00       	call   80199d <_panic>
	return NULL;
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8011b1:	83 ec 04             	sub    $0x4,%esp
  8011b4:	68 58 23 80 00       	push   $0x802358
  8011b9:	6a 43                	push   $0x43
  8011bb:	68 fd 22 80 00       	push   $0x8022fd
  8011c0:	e8 d8 07 00 00       	call   80199d <_panic>

008011c5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8011cb:	83 ec 04             	sub    $0x4,%esp
  8011ce:	68 7c 23 80 00       	push   $0x80237c
  8011d3:	6a 5b                	push   $0x5b
  8011d5:	68 fd 22 80 00       	push   $0x8022fd
  8011da:	e8 be 07 00 00       	call   80199d <_panic>

008011df <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8011e5:	83 ec 04             	sub    $0x4,%esp
  8011e8:	68 a0 23 80 00       	push   $0x8023a0
  8011ed:	6a 72                	push   $0x72
  8011ef:	68 fd 22 80 00       	push   $0x8022fd
  8011f4:	e8 a4 07 00 00       	call   80199d <_panic>

008011f9 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8011ff:	83 ec 04             	sub    $0x4,%esp
  801202:	68 c6 23 80 00       	push   $0x8023c6
  801207:	6a 7e                	push   $0x7e
  801209:	68 fd 22 80 00       	push   $0x8022fd
  80120e:	e8 8a 07 00 00       	call   80199d <_panic>

00801213 <shrink>:

}
void shrink(uint32 newSize)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801219:	83 ec 04             	sub    $0x4,%esp
  80121c:	68 c6 23 80 00       	push   $0x8023c6
  801221:	68 83 00 00 00       	push   $0x83
  801226:	68 fd 22 80 00       	push   $0x8022fd
  80122b:	e8 6d 07 00 00       	call   80199d <_panic>

00801230 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801236:	83 ec 04             	sub    $0x4,%esp
  801239:	68 c6 23 80 00       	push   $0x8023c6
  80123e:	68 88 00 00 00       	push   $0x88
  801243:	68 fd 22 80 00       	push   $0x8022fd
  801248:	e8 50 07 00 00       	call   80199d <_panic>

0080124d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	57                   	push   %edi
  801251:	56                   	push   %esi
  801252:	53                   	push   %ebx
  801253:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80125f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801262:	8b 7d 18             	mov    0x18(%ebp),%edi
  801265:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801268:	cd 30                	int    $0x30
  80126a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80126d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801270:	83 c4 10             	add    $0x10,%esp
  801273:	5b                   	pop    %ebx
  801274:	5e                   	pop    %esi
  801275:	5f                   	pop    %edi
  801276:	5d                   	pop    %ebp
  801277:	c3                   	ret    

00801278 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	83 ec 04             	sub    $0x4,%esp
  80127e:	8b 45 10             	mov    0x10(%ebp),%eax
  801281:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801284:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	6a 00                	push   $0x0
  80128d:	6a 00                	push   $0x0
  80128f:	52                   	push   %edx
  801290:	ff 75 0c             	pushl  0xc(%ebp)
  801293:	50                   	push   %eax
  801294:	6a 00                	push   $0x0
  801296:	e8 b2 ff ff ff       	call   80124d <syscall>
  80129b:	83 c4 18             	add    $0x18,%esp
}
  80129e:	90                   	nop
  80129f:	c9                   	leave  
  8012a0:	c3                   	ret    

008012a1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012a4:	6a 00                	push   $0x0
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	6a 00                	push   $0x0
  8012ac:	6a 00                	push   $0x0
  8012ae:	6a 02                	push   $0x2
  8012b0:	e8 98 ff ff ff       	call   80124d <syscall>
  8012b5:	83 c4 18             	add    $0x18,%esp
}
  8012b8:	c9                   	leave  
  8012b9:	c3                   	ret    

008012ba <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 00                	push   $0x0
  8012c5:	6a 00                	push   $0x0
  8012c7:	6a 03                	push   $0x3
  8012c9:	e8 7f ff ff ff       	call   80124d <syscall>
  8012ce:	83 c4 18             	add    $0x18,%esp
}
  8012d1:	90                   	nop
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012d7:	6a 00                	push   $0x0
  8012d9:	6a 00                	push   $0x0
  8012db:	6a 00                	push   $0x0
  8012dd:	6a 00                	push   $0x0
  8012df:	6a 00                	push   $0x0
  8012e1:	6a 04                	push   $0x4
  8012e3:	e8 65 ff ff ff       	call   80124d <syscall>
  8012e8:	83 c4 18             	add    $0x18,%esp
}
  8012eb:	90                   	nop
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 00                	push   $0x0
  8012fd:	52                   	push   %edx
  8012fe:	50                   	push   %eax
  8012ff:	6a 08                	push   $0x8
  801301:	e8 47 ff ff ff       	call   80124d <syscall>
  801306:	83 c4 18             	add    $0x18,%esp
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	56                   	push   %esi
  80130f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801310:	8b 75 18             	mov    0x18(%ebp),%esi
  801313:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801316:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801319:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	56                   	push   %esi
  801320:	53                   	push   %ebx
  801321:	51                   	push   %ecx
  801322:	52                   	push   %edx
  801323:	50                   	push   %eax
  801324:	6a 09                	push   $0x9
  801326:	e8 22 ff ff ff       	call   80124d <syscall>
  80132b:	83 c4 18             	add    $0x18,%esp
}
  80132e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801331:	5b                   	pop    %ebx
  801332:	5e                   	pop    %esi
  801333:	5d                   	pop    %ebp
  801334:	c3                   	ret    

00801335 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801338:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	52                   	push   %edx
  801345:	50                   	push   %eax
  801346:	6a 0a                	push   $0xa
  801348:	e8 00 ff ff ff       	call   80124d <syscall>
  80134d:	83 c4 18             	add    $0x18,%esp
}
  801350:	c9                   	leave  
  801351:	c3                   	ret    

00801352 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	ff 75 0c             	pushl  0xc(%ebp)
  80135e:	ff 75 08             	pushl  0x8(%ebp)
  801361:	6a 0b                	push   $0xb
  801363:	e8 e5 fe ff ff       	call   80124d <syscall>
  801368:	83 c4 18             	add    $0x18,%esp
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 0c                	push   $0xc
  80137c:	e8 cc fe ff ff       	call   80124d <syscall>
  801381:	83 c4 18             	add    $0x18,%esp
}
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 0d                	push   $0xd
  801395:	e8 b3 fe ff ff       	call   80124d <syscall>
  80139a:	83 c4 18             	add    $0x18,%esp
}
  80139d:	c9                   	leave  
  80139e:	c3                   	ret    

0080139f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 0e                	push   $0xe
  8013ae:	e8 9a fe ff ff       	call   80124d <syscall>
  8013b3:	83 c4 18             	add    $0x18,%esp
}
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 0f                	push   $0xf
  8013c7:	e8 81 fe ff ff       	call   80124d <syscall>
  8013cc:	83 c4 18             	add    $0x18,%esp
}
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	ff 75 08             	pushl  0x8(%ebp)
  8013df:	6a 10                	push   $0x10
  8013e1:	e8 67 fe ff ff       	call   80124d <syscall>
  8013e6:	83 c4 18             	add    $0x18,%esp
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 11                	push   $0x11
  8013fa:	e8 4e fe ff ff       	call   80124d <syscall>
  8013ff:	83 c4 18             	add    $0x18,%esp
}
  801402:	90                   	nop
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <sys_cputc>:

void
sys_cputc(const char c)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	83 ec 04             	sub    $0x4,%esp
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801411:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	50                   	push   %eax
  80141e:	6a 01                	push   $0x1
  801420:	e8 28 fe ff ff       	call   80124d <syscall>
  801425:	83 c4 18             	add    $0x18,%esp
}
  801428:	90                   	nop
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 14                	push   $0x14
  80143a:	e8 0e fe ff ff       	call   80124d <syscall>
  80143f:	83 c4 18             	add    $0x18,%esp
}
  801442:	90                   	nop
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	83 ec 04             	sub    $0x4,%esp
  80144b:	8b 45 10             	mov    0x10(%ebp),%eax
  80144e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801451:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801454:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	6a 00                	push   $0x0
  80145d:	51                   	push   %ecx
  80145e:	52                   	push   %edx
  80145f:	ff 75 0c             	pushl  0xc(%ebp)
  801462:	50                   	push   %eax
  801463:	6a 15                	push   $0x15
  801465:	e8 e3 fd ff ff       	call   80124d <syscall>
  80146a:	83 c4 18             	add    $0x18,%esp
}
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801472:	8b 55 0c             	mov    0xc(%ebp),%edx
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	6a 00                	push   $0x0
  80147e:	52                   	push   %edx
  80147f:	50                   	push   %eax
  801480:	6a 16                	push   $0x16
  801482:	e8 c6 fd ff ff       	call   80124d <syscall>
  801487:	83 c4 18             	add    $0x18,%esp
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80148f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801492:	8b 55 0c             	mov    0xc(%ebp),%edx
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	51                   	push   %ecx
  80149d:	52                   	push   %edx
  80149e:	50                   	push   %eax
  80149f:	6a 17                	push   $0x17
  8014a1:	e8 a7 fd ff ff       	call   80124d <syscall>
  8014a6:	83 c4 18             	add    $0x18,%esp
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	52                   	push   %edx
  8014bb:	50                   	push   %eax
  8014bc:	6a 18                	push   $0x18
  8014be:	e8 8a fd ff ff       	call   80124d <syscall>
  8014c3:	83 c4 18             	add    $0x18,%esp
}
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ce:	6a 00                	push   $0x0
  8014d0:	ff 75 14             	pushl  0x14(%ebp)
  8014d3:	ff 75 10             	pushl  0x10(%ebp)
  8014d6:	ff 75 0c             	pushl  0xc(%ebp)
  8014d9:	50                   	push   %eax
  8014da:	6a 19                	push   $0x19
  8014dc:	e8 6c fd ff ff       	call   80124d <syscall>
  8014e1:	83 c4 18             	add    $0x18,%esp
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	50                   	push   %eax
  8014f5:	6a 1a                	push   $0x1a
  8014f7:	e8 51 fd ff ff       	call   80124d <syscall>
  8014fc:	83 c4 18             	add    $0x18,%esp
}
  8014ff:	90                   	nop
  801500:	c9                   	leave  
  801501:	c3                   	ret    

00801502 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	50                   	push   %eax
  801511:	6a 1b                	push   $0x1b
  801513:	e8 35 fd ff ff       	call   80124d <syscall>
  801518:	83 c4 18             	add    $0x18,%esp
}
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    

0080151d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 05                	push   $0x5
  80152c:	e8 1c fd ff ff       	call   80124d <syscall>
  801531:	83 c4 18             	add    $0x18,%esp
}
  801534:	c9                   	leave  
  801535:	c3                   	ret    

00801536 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 06                	push   $0x6
  801545:	e8 03 fd ff ff       	call   80124d <syscall>
  80154a:	83 c4 18             	add    $0x18,%esp
}
  80154d:	c9                   	leave  
  80154e:	c3                   	ret    

0080154f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 07                	push   $0x7
  80155e:	e8 ea fc ff ff       	call   80124d <syscall>
  801563:	83 c4 18             	add    $0x18,%esp
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <sys_exit_env>:


void sys_exit_env(void)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 1c                	push   $0x1c
  801577:	e8 d1 fc ff ff       	call   80124d <syscall>
  80157c:	83 c4 18             	add    $0x18,%esp
}
  80157f:	90                   	nop
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801588:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80158b:	8d 50 04             	lea    0x4(%eax),%edx
  80158e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	52                   	push   %edx
  801598:	50                   	push   %eax
  801599:	6a 1d                	push   $0x1d
  80159b:	e8 ad fc ff ff       	call   80124d <syscall>
  8015a0:	83 c4 18             	add    $0x18,%esp
	return result;
  8015a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ac:	89 01                	mov    %eax,(%ecx)
  8015ae:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	c9                   	leave  
  8015b5:	c2 04 00             	ret    $0x4

008015b8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	ff 75 10             	pushl  0x10(%ebp)
  8015c2:	ff 75 0c             	pushl  0xc(%ebp)
  8015c5:	ff 75 08             	pushl  0x8(%ebp)
  8015c8:	6a 13                	push   $0x13
  8015ca:	e8 7e fc ff ff       	call   80124d <syscall>
  8015cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d2:	90                   	nop
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 1e                	push   $0x1e
  8015e4:	e8 64 fc ff ff       	call   80124d <syscall>
  8015e9:	83 c4 18             	add    $0x18,%esp
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	83 ec 04             	sub    $0x4,%esp
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015fa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	50                   	push   %eax
  801607:	6a 1f                	push   $0x1f
  801609:	e8 3f fc ff ff       	call   80124d <syscall>
  80160e:	83 c4 18             	add    $0x18,%esp
	return ;
  801611:	90                   	nop
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <rsttst>:
void rsttst()
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 21                	push   $0x21
  801623:	e8 25 fc ff ff       	call   80124d <syscall>
  801628:	83 c4 18             	add    $0x18,%esp
	return ;
  80162b:	90                   	nop
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	83 ec 04             	sub    $0x4,%esp
  801634:	8b 45 14             	mov    0x14(%ebp),%eax
  801637:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80163a:	8b 55 18             	mov    0x18(%ebp),%edx
  80163d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801641:	52                   	push   %edx
  801642:	50                   	push   %eax
  801643:	ff 75 10             	pushl  0x10(%ebp)
  801646:	ff 75 0c             	pushl  0xc(%ebp)
  801649:	ff 75 08             	pushl  0x8(%ebp)
  80164c:	6a 20                	push   $0x20
  80164e:	e8 fa fb ff ff       	call   80124d <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
	return ;
  801656:	90                   	nop
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <chktst>:
void chktst(uint32 n)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	ff 75 08             	pushl  0x8(%ebp)
  801667:	6a 22                	push   $0x22
  801669:	e8 df fb ff ff       	call   80124d <syscall>
  80166e:	83 c4 18             	add    $0x18,%esp
	return ;
  801671:	90                   	nop
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <inctst>:

void inctst()
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 23                	push   $0x23
  801683:	e8 c5 fb ff ff       	call   80124d <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
	return ;
  80168b:	90                   	nop
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <gettst>:
uint32 gettst()
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 24                	push   $0x24
  80169d:	e8 ab fb ff ff       	call   80124d <syscall>
  8016a2:	83 c4 18             	add    $0x18,%esp
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 25                	push   $0x25
  8016b9:	e8 8f fb ff ff       	call   80124d <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
  8016c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8016c4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8016c8:	75 07                	jne    8016d1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8016ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8016cf:	eb 05                	jmp    8016d6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8016d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 25                	push   $0x25
  8016ea:	e8 5e fb ff ff       	call   80124d <syscall>
  8016ef:	83 c4 18             	add    $0x18,%esp
  8016f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016f5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016f9:	75 07                	jne    801702 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016fb:	b8 01 00 00 00       	mov    $0x1,%eax
  801700:	eb 05                	jmp    801707 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801702:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 25                	push   $0x25
  80171b:	e8 2d fb ff ff       	call   80124d <syscall>
  801720:	83 c4 18             	add    $0x18,%esp
  801723:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801726:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80172a:	75 07                	jne    801733 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80172c:	b8 01 00 00 00       	mov    $0x1,%eax
  801731:	eb 05                	jmp    801738 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801733:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 25                	push   $0x25
  80174c:	e8 fc fa ff ff       	call   80124d <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
  801754:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801757:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80175b:	75 07                	jne    801764 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80175d:	b8 01 00 00 00       	mov    $0x1,%eax
  801762:	eb 05                	jmp    801769 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801764:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	ff 75 08             	pushl  0x8(%ebp)
  801779:	6a 26                	push   $0x26
  80177b:	e8 cd fa ff ff       	call   80124d <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
	return ;
  801783:	90                   	nop
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80178a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80178d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801790:	8b 55 0c             	mov    0xc(%ebp),%edx
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
  801796:	6a 00                	push   $0x0
  801798:	53                   	push   %ebx
  801799:	51                   	push   %ecx
  80179a:	52                   	push   %edx
  80179b:	50                   	push   %eax
  80179c:	6a 27                	push   $0x27
  80179e:	e8 aa fa ff ff       	call   80124d <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8017ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	52                   	push   %edx
  8017bb:	50                   	push   %eax
  8017bc:	6a 28                	push   $0x28
  8017be:	e8 8a fa ff ff       	call   80124d <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8017cb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	6a 00                	push   $0x0
  8017d6:	51                   	push   %ecx
  8017d7:	ff 75 10             	pushl  0x10(%ebp)
  8017da:	52                   	push   %edx
  8017db:	50                   	push   %eax
  8017dc:	6a 29                	push   $0x29
  8017de:	e8 6a fa ff ff       	call   80124d <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	ff 75 10             	pushl  0x10(%ebp)
  8017f2:	ff 75 0c             	pushl  0xc(%ebp)
  8017f5:	ff 75 08             	pushl  0x8(%ebp)
  8017f8:	6a 12                	push   $0x12
  8017fa:	e8 4e fa ff ff       	call   80124d <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801802:	90                   	nop
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801808:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	52                   	push   %edx
  801815:	50                   	push   %eax
  801816:	6a 2a                	push   $0x2a
  801818:	e8 30 fa ff ff       	call   80124d <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
	return;
  801820:	90                   	nop
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	50                   	push   %eax
  801832:	6a 2b                	push   $0x2b
  801834:	e8 14 fa ff ff       	call   80124d <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	ff 75 0c             	pushl  0xc(%ebp)
  80184a:	ff 75 08             	pushl  0x8(%ebp)
  80184d:	6a 2c                	push   $0x2c
  80184f:	e8 f9 f9 ff ff       	call   80124d <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
	return;
  801857:	90                   	nop
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	ff 75 0c             	pushl  0xc(%ebp)
  801866:	ff 75 08             	pushl  0x8(%ebp)
  801869:	6a 2d                	push   $0x2d
  80186b:	e8 dd f9 ff ff       	call   80124d <syscall>
  801870:	83 c4 18             	add    $0x18,%esp
	return;
  801873:	90                   	nop
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	68 d8 23 80 00       	push   $0x8023d8
  801884:	6a 09                	push   $0x9
  801886:	68 00 24 80 00       	push   $0x802400
  80188b:	e8 0d 01 00 00       	call   80199d <_panic>

00801890 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  801896:	83 ec 04             	sub    $0x4,%esp
  801899:	68 10 24 80 00       	push   $0x802410
  80189e:	6a 10                	push   $0x10
  8018a0:	68 00 24 80 00       	push   $0x802400
  8018a5:	e8 f3 00 00 00       	call   80199d <_panic>

008018aa <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8018b0:	83 ec 04             	sub    $0x4,%esp
  8018b3:	68 38 24 80 00       	push   $0x802438
  8018b8:	6a 18                	push   $0x18
  8018ba:	68 00 24 80 00       	push   $0x802400
  8018bf:	e8 d9 00 00 00       	call   80199d <_panic>

008018c4 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8018ca:	83 ec 04             	sub    $0x4,%esp
  8018cd:	68 60 24 80 00       	push   $0x802460
  8018d2:	6a 20                	push   $0x20
  8018d4:	68 00 24 80 00       	push   $0x802400
  8018d9:	e8 bf 00 00 00       	call   80199d <_panic>

008018de <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	8b 40 10             	mov    0x10(%eax),%eax
}
  8018e7:	5d                   	pop    %ebp
  8018e8:	c3                   	ret    

008018e9 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8018ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8018f2:	89 d0                	mov    %edx,%eax
  8018f4:	c1 e0 02             	shl    $0x2,%eax
  8018f7:	01 d0                	add    %edx,%eax
  8018f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801900:	01 d0                	add    %edx,%eax
  801902:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801909:	01 d0                	add    %edx,%eax
  80190b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801912:	01 d0                	add    %edx,%eax
  801914:	c1 e0 04             	shl    $0x4,%eax
  801917:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80191a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801921:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801924:	83 ec 0c             	sub    $0xc,%esp
  801927:	50                   	push   %eax
  801928:	e8 55 fc ff ff       	call   801582 <sys_get_virtual_time>
  80192d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801930:	eb 41                	jmp    801973 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801932:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801935:	83 ec 0c             	sub    $0xc,%esp
  801938:	50                   	push   %eax
  801939:	e8 44 fc ff ff       	call   801582 <sys_get_virtual_time>
  80193e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801941:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801944:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801947:	29 c2                	sub    %eax,%edx
  801949:	89 d0                	mov    %edx,%eax
  80194b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80194e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801951:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801954:	89 d1                	mov    %edx,%ecx
  801956:	29 c1                	sub    %eax,%ecx
  801958:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80195b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80195e:	39 c2                	cmp    %eax,%edx
  801960:	0f 97 c0             	seta   %al
  801963:	0f b6 c0             	movzbl %al,%eax
  801966:	29 c1                	sub    %eax,%ecx
  801968:	89 c8                	mov    %ecx,%eax
  80196a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80196d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801970:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801976:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801979:	72 b7                	jb     801932 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80197b:	90                   	nop
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801984:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80198b:	eb 03                	jmp    801990 <busy_wait+0x12>
  80198d:	ff 45 fc             	incl   -0x4(%ebp)
  801990:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801993:	3b 45 08             	cmp    0x8(%ebp),%eax
  801996:	72 f5                	jb     80198d <busy_wait+0xf>
	return i;
  801998:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8019a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8019a6:	83 c0 04             	add    $0x4,%eax
  8019a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8019ac:	a1 24 30 80 00       	mov    0x803024,%eax
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	74 16                	je     8019cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8019b5:	a1 24 30 80 00       	mov    0x803024,%eax
  8019ba:	83 ec 08             	sub    $0x8,%esp
  8019bd:	50                   	push   %eax
  8019be:	68 88 24 80 00       	push   $0x802488
  8019c3:	e8 c1 e9 ff ff       	call   800389 <cprintf>
  8019c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8019cb:	a1 00 30 80 00       	mov    0x803000,%eax
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	ff 75 08             	pushl  0x8(%ebp)
  8019d6:	50                   	push   %eax
  8019d7:	68 8d 24 80 00       	push   $0x80248d
  8019dc:	e8 a8 e9 ff ff       	call   800389 <cprintf>
  8019e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8019e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e7:	83 ec 08             	sub    $0x8,%esp
  8019ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ed:	50                   	push   %eax
  8019ee:	e8 2b e9 ff ff       	call   80031e <vcprintf>
  8019f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8019f6:	83 ec 08             	sub    $0x8,%esp
  8019f9:	6a 00                	push   $0x0
  8019fb:	68 a9 24 80 00       	push   $0x8024a9
  801a00:	e8 19 e9 ff ff       	call   80031e <vcprintf>
  801a05:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801a08:	e8 9a e8 ff ff       	call   8002a7 <exit>

	// should not return here
	while (1) ;
  801a0d:	eb fe                	jmp    801a0d <_panic+0x70>

00801a0f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801a15:	a1 04 30 80 00       	mov    0x803004,%eax
  801a1a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a23:	39 c2                	cmp    %eax,%edx
  801a25:	74 14                	je     801a3b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801a27:	83 ec 04             	sub    $0x4,%esp
  801a2a:	68 ac 24 80 00       	push   $0x8024ac
  801a2f:	6a 26                	push   $0x26
  801a31:	68 f8 24 80 00       	push   $0x8024f8
  801a36:	e8 62 ff ff ff       	call   80199d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801a3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801a42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801a49:	e9 c5 00 00 00       	jmp    801b13 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a51:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	01 d0                	add    %edx,%eax
  801a5d:	8b 00                	mov    (%eax),%eax
  801a5f:	85 c0                	test   %eax,%eax
  801a61:	75 08                	jne    801a6b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801a63:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a66:	e9 a5 00 00 00       	jmp    801b10 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a6b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a72:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a79:	eb 69                	jmp    801ae4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a7b:	a1 04 30 80 00       	mov    0x803004,%eax
  801a80:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801a86:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a89:	89 d0                	mov    %edx,%eax
  801a8b:	01 c0                	add    %eax,%eax
  801a8d:	01 d0                	add    %edx,%eax
  801a8f:	c1 e0 03             	shl    $0x3,%eax
  801a92:	01 c8                	add    %ecx,%eax
  801a94:	8a 40 04             	mov    0x4(%eax),%al
  801a97:	84 c0                	test   %al,%al
  801a99:	75 46                	jne    801ae1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a9b:	a1 04 30 80 00       	mov    0x803004,%eax
  801aa0:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801aa6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801aa9:	89 d0                	mov    %edx,%eax
  801aab:	01 c0                	add    %eax,%eax
  801aad:	01 d0                	add    %edx,%eax
  801aaf:	c1 e0 03             	shl    $0x3,%eax
  801ab2:	01 c8                	add    %ecx,%eax
  801ab4:	8b 00                	mov    (%eax),%eax
  801ab6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ab9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801abc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ac1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	01 c8                	add    %ecx,%eax
  801ad2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ad4:	39 c2                	cmp    %eax,%edx
  801ad6:	75 09                	jne    801ae1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801ad8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801adf:	eb 15                	jmp    801af6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ae1:	ff 45 e8             	incl   -0x18(%ebp)
  801ae4:	a1 04 30 80 00       	mov    0x803004,%eax
  801ae9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801af2:	39 c2                	cmp    %eax,%edx
  801af4:	77 85                	ja     801a7b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801af6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801afa:	75 14                	jne    801b10 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801afc:	83 ec 04             	sub    $0x4,%esp
  801aff:	68 04 25 80 00       	push   $0x802504
  801b04:	6a 3a                	push   $0x3a
  801b06:	68 f8 24 80 00       	push   $0x8024f8
  801b0b:	e8 8d fe ff ff       	call   80199d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801b10:	ff 45 f0             	incl   -0x10(%ebp)
  801b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b16:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801b19:	0f 8c 2f ff ff ff    	jl     801a4e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801b1f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b26:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b2d:	eb 26                	jmp    801b55 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801b2f:	a1 04 30 80 00       	mov    0x803004,%eax
  801b34:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801b3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b3d:	89 d0                	mov    %edx,%eax
  801b3f:	01 c0                	add    %eax,%eax
  801b41:	01 d0                	add    %edx,%eax
  801b43:	c1 e0 03             	shl    $0x3,%eax
  801b46:	01 c8                	add    %ecx,%eax
  801b48:	8a 40 04             	mov    0x4(%eax),%al
  801b4b:	3c 01                	cmp    $0x1,%al
  801b4d:	75 03                	jne    801b52 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801b4f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b52:	ff 45 e0             	incl   -0x20(%ebp)
  801b55:	a1 04 30 80 00       	mov    0x803004,%eax
  801b5a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b63:	39 c2                	cmp    %eax,%edx
  801b65:	77 c8                	ja     801b2f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b6d:	74 14                	je     801b83 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b6f:	83 ec 04             	sub    $0x4,%esp
  801b72:	68 58 25 80 00       	push   $0x802558
  801b77:	6a 44                	push   $0x44
  801b79:	68 f8 24 80 00       	push   $0x8024f8
  801b7e:	e8 1a fe ff ff       	call   80199d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b83:	90                   	nop
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    
  801b86:	66 90                	xchg   %ax,%ax

00801b88 <__udivdi3>:
  801b88:	55                   	push   %ebp
  801b89:	57                   	push   %edi
  801b8a:	56                   	push   %esi
  801b8b:	53                   	push   %ebx
  801b8c:	83 ec 1c             	sub    $0x1c,%esp
  801b8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b9f:	89 ca                	mov    %ecx,%edx
  801ba1:	89 f8                	mov    %edi,%eax
  801ba3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ba7:	85 f6                	test   %esi,%esi
  801ba9:	75 2d                	jne    801bd8 <__udivdi3+0x50>
  801bab:	39 cf                	cmp    %ecx,%edi
  801bad:	77 65                	ja     801c14 <__udivdi3+0x8c>
  801baf:	89 fd                	mov    %edi,%ebp
  801bb1:	85 ff                	test   %edi,%edi
  801bb3:	75 0b                	jne    801bc0 <__udivdi3+0x38>
  801bb5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bba:	31 d2                	xor    %edx,%edx
  801bbc:	f7 f7                	div    %edi
  801bbe:	89 c5                	mov    %eax,%ebp
  801bc0:	31 d2                	xor    %edx,%edx
  801bc2:	89 c8                	mov    %ecx,%eax
  801bc4:	f7 f5                	div    %ebp
  801bc6:	89 c1                	mov    %eax,%ecx
  801bc8:	89 d8                	mov    %ebx,%eax
  801bca:	f7 f5                	div    %ebp
  801bcc:	89 cf                	mov    %ecx,%edi
  801bce:	89 fa                	mov    %edi,%edx
  801bd0:	83 c4 1c             	add    $0x1c,%esp
  801bd3:	5b                   	pop    %ebx
  801bd4:	5e                   	pop    %esi
  801bd5:	5f                   	pop    %edi
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    
  801bd8:	39 ce                	cmp    %ecx,%esi
  801bda:	77 28                	ja     801c04 <__udivdi3+0x7c>
  801bdc:	0f bd fe             	bsr    %esi,%edi
  801bdf:	83 f7 1f             	xor    $0x1f,%edi
  801be2:	75 40                	jne    801c24 <__udivdi3+0x9c>
  801be4:	39 ce                	cmp    %ecx,%esi
  801be6:	72 0a                	jb     801bf2 <__udivdi3+0x6a>
  801be8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bec:	0f 87 9e 00 00 00    	ja     801c90 <__udivdi3+0x108>
  801bf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf7:	89 fa                	mov    %edi,%edx
  801bf9:	83 c4 1c             	add    $0x1c,%esp
  801bfc:	5b                   	pop    %ebx
  801bfd:	5e                   	pop    %esi
  801bfe:	5f                   	pop    %edi
  801bff:	5d                   	pop    %ebp
  801c00:	c3                   	ret    
  801c01:	8d 76 00             	lea    0x0(%esi),%esi
  801c04:	31 ff                	xor    %edi,%edi
  801c06:	31 c0                	xor    %eax,%eax
  801c08:	89 fa                	mov    %edi,%edx
  801c0a:	83 c4 1c             	add    $0x1c,%esp
  801c0d:	5b                   	pop    %ebx
  801c0e:	5e                   	pop    %esi
  801c0f:	5f                   	pop    %edi
  801c10:	5d                   	pop    %ebp
  801c11:	c3                   	ret    
  801c12:	66 90                	xchg   %ax,%ax
  801c14:	89 d8                	mov    %ebx,%eax
  801c16:	f7 f7                	div    %edi
  801c18:	31 ff                	xor    %edi,%edi
  801c1a:	89 fa                	mov    %edi,%edx
  801c1c:	83 c4 1c             	add    $0x1c,%esp
  801c1f:	5b                   	pop    %ebx
  801c20:	5e                   	pop    %esi
  801c21:	5f                   	pop    %edi
  801c22:	5d                   	pop    %ebp
  801c23:	c3                   	ret    
  801c24:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c29:	89 eb                	mov    %ebp,%ebx
  801c2b:	29 fb                	sub    %edi,%ebx
  801c2d:	89 f9                	mov    %edi,%ecx
  801c2f:	d3 e6                	shl    %cl,%esi
  801c31:	89 c5                	mov    %eax,%ebp
  801c33:	88 d9                	mov    %bl,%cl
  801c35:	d3 ed                	shr    %cl,%ebp
  801c37:	89 e9                	mov    %ebp,%ecx
  801c39:	09 f1                	or     %esi,%ecx
  801c3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c3f:	89 f9                	mov    %edi,%ecx
  801c41:	d3 e0                	shl    %cl,%eax
  801c43:	89 c5                	mov    %eax,%ebp
  801c45:	89 d6                	mov    %edx,%esi
  801c47:	88 d9                	mov    %bl,%cl
  801c49:	d3 ee                	shr    %cl,%esi
  801c4b:	89 f9                	mov    %edi,%ecx
  801c4d:	d3 e2                	shl    %cl,%edx
  801c4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c53:	88 d9                	mov    %bl,%cl
  801c55:	d3 e8                	shr    %cl,%eax
  801c57:	09 c2                	or     %eax,%edx
  801c59:	89 d0                	mov    %edx,%eax
  801c5b:	89 f2                	mov    %esi,%edx
  801c5d:	f7 74 24 0c          	divl   0xc(%esp)
  801c61:	89 d6                	mov    %edx,%esi
  801c63:	89 c3                	mov    %eax,%ebx
  801c65:	f7 e5                	mul    %ebp
  801c67:	39 d6                	cmp    %edx,%esi
  801c69:	72 19                	jb     801c84 <__udivdi3+0xfc>
  801c6b:	74 0b                	je     801c78 <__udivdi3+0xf0>
  801c6d:	89 d8                	mov    %ebx,%eax
  801c6f:	31 ff                	xor    %edi,%edi
  801c71:	e9 58 ff ff ff       	jmp    801bce <__udivdi3+0x46>
  801c76:	66 90                	xchg   %ax,%ax
  801c78:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c7c:	89 f9                	mov    %edi,%ecx
  801c7e:	d3 e2                	shl    %cl,%edx
  801c80:	39 c2                	cmp    %eax,%edx
  801c82:	73 e9                	jae    801c6d <__udivdi3+0xe5>
  801c84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c87:	31 ff                	xor    %edi,%edi
  801c89:	e9 40 ff ff ff       	jmp    801bce <__udivdi3+0x46>
  801c8e:	66 90                	xchg   %ax,%ax
  801c90:	31 c0                	xor    %eax,%eax
  801c92:	e9 37 ff ff ff       	jmp    801bce <__udivdi3+0x46>
  801c97:	90                   	nop

00801c98 <__umoddi3>:
  801c98:	55                   	push   %ebp
  801c99:	57                   	push   %edi
  801c9a:	56                   	push   %esi
  801c9b:	53                   	push   %ebx
  801c9c:	83 ec 1c             	sub    $0x1c,%esp
  801c9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ca3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ca7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801caf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cb7:	89 f3                	mov    %esi,%ebx
  801cb9:	89 fa                	mov    %edi,%edx
  801cbb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cbf:	89 34 24             	mov    %esi,(%esp)
  801cc2:	85 c0                	test   %eax,%eax
  801cc4:	75 1a                	jne    801ce0 <__umoddi3+0x48>
  801cc6:	39 f7                	cmp    %esi,%edi
  801cc8:	0f 86 a2 00 00 00    	jbe    801d70 <__umoddi3+0xd8>
  801cce:	89 c8                	mov    %ecx,%eax
  801cd0:	89 f2                	mov    %esi,%edx
  801cd2:	f7 f7                	div    %edi
  801cd4:	89 d0                	mov    %edx,%eax
  801cd6:	31 d2                	xor    %edx,%edx
  801cd8:	83 c4 1c             	add    $0x1c,%esp
  801cdb:	5b                   	pop    %ebx
  801cdc:	5e                   	pop    %esi
  801cdd:	5f                   	pop    %edi
  801cde:	5d                   	pop    %ebp
  801cdf:	c3                   	ret    
  801ce0:	39 f0                	cmp    %esi,%eax
  801ce2:	0f 87 ac 00 00 00    	ja     801d94 <__umoddi3+0xfc>
  801ce8:	0f bd e8             	bsr    %eax,%ebp
  801ceb:	83 f5 1f             	xor    $0x1f,%ebp
  801cee:	0f 84 ac 00 00 00    	je     801da0 <__umoddi3+0x108>
  801cf4:	bf 20 00 00 00       	mov    $0x20,%edi
  801cf9:	29 ef                	sub    %ebp,%edi
  801cfb:	89 fe                	mov    %edi,%esi
  801cfd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d01:	89 e9                	mov    %ebp,%ecx
  801d03:	d3 e0                	shl    %cl,%eax
  801d05:	89 d7                	mov    %edx,%edi
  801d07:	89 f1                	mov    %esi,%ecx
  801d09:	d3 ef                	shr    %cl,%edi
  801d0b:	09 c7                	or     %eax,%edi
  801d0d:	89 e9                	mov    %ebp,%ecx
  801d0f:	d3 e2                	shl    %cl,%edx
  801d11:	89 14 24             	mov    %edx,(%esp)
  801d14:	89 d8                	mov    %ebx,%eax
  801d16:	d3 e0                	shl    %cl,%eax
  801d18:	89 c2                	mov    %eax,%edx
  801d1a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d1e:	d3 e0                	shl    %cl,%eax
  801d20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d24:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d28:	89 f1                	mov    %esi,%ecx
  801d2a:	d3 e8                	shr    %cl,%eax
  801d2c:	09 d0                	or     %edx,%eax
  801d2e:	d3 eb                	shr    %cl,%ebx
  801d30:	89 da                	mov    %ebx,%edx
  801d32:	f7 f7                	div    %edi
  801d34:	89 d3                	mov    %edx,%ebx
  801d36:	f7 24 24             	mull   (%esp)
  801d39:	89 c6                	mov    %eax,%esi
  801d3b:	89 d1                	mov    %edx,%ecx
  801d3d:	39 d3                	cmp    %edx,%ebx
  801d3f:	0f 82 87 00 00 00    	jb     801dcc <__umoddi3+0x134>
  801d45:	0f 84 91 00 00 00    	je     801ddc <__umoddi3+0x144>
  801d4b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d4f:	29 f2                	sub    %esi,%edx
  801d51:	19 cb                	sbb    %ecx,%ebx
  801d53:	89 d8                	mov    %ebx,%eax
  801d55:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d59:	d3 e0                	shl    %cl,%eax
  801d5b:	89 e9                	mov    %ebp,%ecx
  801d5d:	d3 ea                	shr    %cl,%edx
  801d5f:	09 d0                	or     %edx,%eax
  801d61:	89 e9                	mov    %ebp,%ecx
  801d63:	d3 eb                	shr    %cl,%ebx
  801d65:	89 da                	mov    %ebx,%edx
  801d67:	83 c4 1c             	add    $0x1c,%esp
  801d6a:	5b                   	pop    %ebx
  801d6b:	5e                   	pop    %esi
  801d6c:	5f                   	pop    %edi
  801d6d:	5d                   	pop    %ebp
  801d6e:	c3                   	ret    
  801d6f:	90                   	nop
  801d70:	89 fd                	mov    %edi,%ebp
  801d72:	85 ff                	test   %edi,%edi
  801d74:	75 0b                	jne    801d81 <__umoddi3+0xe9>
  801d76:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7b:	31 d2                	xor    %edx,%edx
  801d7d:	f7 f7                	div    %edi
  801d7f:	89 c5                	mov    %eax,%ebp
  801d81:	89 f0                	mov    %esi,%eax
  801d83:	31 d2                	xor    %edx,%edx
  801d85:	f7 f5                	div    %ebp
  801d87:	89 c8                	mov    %ecx,%eax
  801d89:	f7 f5                	div    %ebp
  801d8b:	89 d0                	mov    %edx,%eax
  801d8d:	e9 44 ff ff ff       	jmp    801cd6 <__umoddi3+0x3e>
  801d92:	66 90                	xchg   %ax,%ax
  801d94:	89 c8                	mov    %ecx,%eax
  801d96:	89 f2                	mov    %esi,%edx
  801d98:	83 c4 1c             	add    $0x1c,%esp
  801d9b:	5b                   	pop    %ebx
  801d9c:	5e                   	pop    %esi
  801d9d:	5f                   	pop    %edi
  801d9e:	5d                   	pop    %ebp
  801d9f:	c3                   	ret    
  801da0:	3b 04 24             	cmp    (%esp),%eax
  801da3:	72 06                	jb     801dab <__umoddi3+0x113>
  801da5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801da9:	77 0f                	ja     801dba <__umoddi3+0x122>
  801dab:	89 f2                	mov    %esi,%edx
  801dad:	29 f9                	sub    %edi,%ecx
  801daf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801db3:	89 14 24             	mov    %edx,(%esp)
  801db6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dba:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dbe:	8b 14 24             	mov    (%esp),%edx
  801dc1:	83 c4 1c             	add    $0x1c,%esp
  801dc4:	5b                   	pop    %ebx
  801dc5:	5e                   	pop    %esi
  801dc6:	5f                   	pop    %edi
  801dc7:	5d                   	pop    %ebp
  801dc8:	c3                   	ret    
  801dc9:	8d 76 00             	lea    0x0(%esi),%esi
  801dcc:	2b 04 24             	sub    (%esp),%eax
  801dcf:	19 fa                	sbb    %edi,%edx
  801dd1:	89 d1                	mov    %edx,%ecx
  801dd3:	89 c6                	mov    %eax,%esi
  801dd5:	e9 71 ff ff ff       	jmp    801d4b <__umoddi3+0xb3>
  801dda:	66 90                	xchg   %ax,%ax
  801ddc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801de0:	72 ea                	jb     801dcc <__umoddi3+0x134>
  801de2:	89 d9                	mov    %ebx,%ecx
  801de4:	e9 62 ff ff ff       	jmp    801d4b <__umoddi3+0xb3>
