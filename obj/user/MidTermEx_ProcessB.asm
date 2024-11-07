
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 47 01 00 00       	call   80017d <libmain>
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
  80003e:	e8 0b 15 00 00       	call   80154e <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 00 1e 80 00       	push   $0x801e00
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 54 11 00 00       	call   8011aa <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 02 1e 80 00       	push   $0x801e02
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 3e 11 00 00       	call   8011aa <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 09 1e 80 00       	push   $0x801e09
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 28 11 00 00       	call   8011aa <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Z ;
	struct semaphore T ;
	if (*useSem == 1)
  800088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80008b:	8b 00                	mov    (%eax),%eax
  80008d:	83 f8 01             	cmp    $0x1,%eax
  800090:	75 25                	jne    8000b7 <_main+0x7f>
	{
		T = get_semaphore(parentenvID, "T");
  800092:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  800095:	83 ec 04             	sub    $0x4,%esp
  800098:	68 17 1e 80 00       	push   $0x801e17
  80009d:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a0:	50                   	push   %eax
  8000a1:	e8 e9 17 00 00       	call   80188f <get_semaphore>
  8000a6:	83 c4 0c             	add    $0xc,%esp
		wait_semaphore(T);
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	ff 75 c4             	pushl  -0x3c(%ebp)
  8000af:	e8 f5 17 00 00       	call   8018a9 <wait_semaphore>
  8000b4:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000b7:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	50                   	push   %eax
  8000be:	e8 be 14 00 00       	call   801581 <sys_get_virtual_time>
  8000c3:	83 c4 0c             	add    $0xc,%esp
  8000c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000c9:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d3:	f7 f1                	div    %ecx
  8000d5:	89 d0                	mov    %edx,%eax
  8000d7:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	50                   	push   %eax
  8000e6:	e8 fd 17 00 00       	call   8018e8 <env_sleep>
  8000eb:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  8000ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f1:	8b 00                	mov    (%eax),%eax
  8000f3:	40                   	inc    %eax
  8000f4:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000f7:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	50                   	push   %eax
  8000fe:	e8 7e 14 00 00       	call   801581 <sys_get_virtual_time>
  800103:	83 c4 0c             	add    $0xc,%esp
  800106:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800109:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80010e:	ba 00 00 00 00       	mov    $0x0,%edx
  800113:	f7 f1                	div    %ecx
  800115:	89 d0                	mov    %edx,%eax
  800117:	05 d0 07 00 00       	add    $0x7d0,%eax
  80011c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80011f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	50                   	push   %eax
  800126:	e8 bd 17 00 00       	call   8018e8 <env_sleep>
  80012b:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  80012e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800131:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800134:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800136:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	50                   	push   %eax
  80013d:	e8 3f 14 00 00       	call   801581 <sys_get_virtual_time>
  800142:	83 c4 0c             	add    $0xc,%esp
  800145:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800148:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80014d:	ba 00 00 00 00       	mov    $0x0,%edx
  800152:	f7 f1                	div    %ecx
  800154:	89 d0                	mov    %edx,%eax
  800156:	05 d0 07 00 00       	add    $0x7d0,%eax
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80015e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	50                   	push   %eax
  800165:	e8 7e 17 00 00       	call   8018e8 <env_sleep>
  80016a:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80016d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800170:	8b 00                	mov    (%eax),%eax
  800172:	8d 50 01             	lea    0x1(%eax),%edx
  800175:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800178:	89 10                	mov    %edx,(%eax)

}
  80017a:	90                   	nop
  80017b:	c9                   	leave  
  80017c:	c3                   	ret    

0080017d <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800183:	e8 ad 13 00 00       	call   801535 <sys_getenvindex>
  800188:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80018b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018e:	89 d0                	mov    %edx,%eax
  800190:	c1 e0 02             	shl    $0x2,%eax
  800193:	01 d0                	add    %edx,%eax
  800195:	01 c0                	add    %eax,%eax
  800197:	01 d0                	add    %edx,%eax
  800199:	c1 e0 02             	shl    $0x2,%eax
  80019c:	01 d0                	add    %edx,%eax
  80019e:	01 c0                	add    %eax,%eax
  8001a0:	01 d0                	add    %edx,%eax
  8001a2:	c1 e0 04             	shl    $0x4,%eax
  8001a5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001aa:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001af:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b4:	8a 40 20             	mov    0x20(%eax),%al
  8001b7:	84 c0                	test   %al,%al
  8001b9:	74 0d                	je     8001c8 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8001bb:	a1 04 30 80 00       	mov    0x803004,%eax
  8001c0:	83 c0 20             	add    $0x20,%eax
  8001c3:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001cc:	7e 0a                	jle    8001d8 <libmain+0x5b>
		binaryname = argv[0];
  8001ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d1:	8b 00                	mov    (%eax),%eax
  8001d3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001d8:	83 ec 08             	sub    $0x8,%esp
  8001db:	ff 75 0c             	pushl  0xc(%ebp)
  8001de:	ff 75 08             	pushl  0x8(%ebp)
  8001e1:	e8 52 fe ff ff       	call   800038 <_main>
  8001e6:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001e9:	e8 cb 10 00 00       	call   8012b9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	68 34 1e 80 00       	push   $0x801e34
  8001f6:	e8 8d 01 00 00       	call   800388 <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001fe:	a1 04 30 80 00       	mov    0x803004,%eax
  800203:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800209:	a1 04 30 80 00       	mov    0x803004,%eax
  80020e:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800214:	83 ec 04             	sub    $0x4,%esp
  800217:	52                   	push   %edx
  800218:	50                   	push   %eax
  800219:	68 5c 1e 80 00       	push   $0x801e5c
  80021e:	e8 65 01 00 00       	call   800388 <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800226:	a1 04 30 80 00       	mov    0x803004,%eax
  80022b:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800231:	a1 04 30 80 00       	mov    0x803004,%eax
  800236:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  80023c:	a1 04 30 80 00       	mov    0x803004,%eax
  800241:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800247:	51                   	push   %ecx
  800248:	52                   	push   %edx
  800249:	50                   	push   %eax
  80024a:	68 84 1e 80 00       	push   $0x801e84
  80024f:	e8 34 01 00 00       	call   800388 <cprintf>
  800254:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800257:	a1 04 30 80 00       	mov    0x803004,%eax
  80025c:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800262:	83 ec 08             	sub    $0x8,%esp
  800265:	50                   	push   %eax
  800266:	68 dc 1e 80 00       	push   $0x801edc
  80026b:	e8 18 01 00 00       	call   800388 <cprintf>
  800270:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	68 34 1e 80 00       	push   $0x801e34
  80027b:	e8 08 01 00 00       	call   800388 <cprintf>
  800280:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800283:	e8 4b 10 00 00       	call   8012d3 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800288:	e8 19 00 00 00       	call   8002a6 <exit>
}
  80028d:	90                   	nop
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	6a 00                	push   $0x0
  80029b:	e8 61 12 00 00       	call   801501 <sys_destroy_env>
  8002a0:	83 c4 10             	add    $0x10,%esp
}
  8002a3:	90                   	nop
  8002a4:	c9                   	leave  
  8002a5:	c3                   	ret    

008002a6 <exit>:

void
exit(void)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ac:	e8 b6 12 00 00       	call   801567 <sys_exit_env>
}
  8002b1:	90                   	nop
  8002b2:	c9                   	leave  
  8002b3:	c3                   	ret    

008002b4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002bd:	8b 00                	mov    (%eax),%eax
  8002bf:	8d 48 01             	lea    0x1(%eax),%ecx
  8002c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c5:	89 0a                	mov    %ecx,(%edx)
  8002c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ca:	88 d1                	mov    %dl,%cl
  8002cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002cf:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002dd:	75 2c                	jne    80030b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002df:	a0 08 30 80 00       	mov    0x803008,%al
  8002e4:	0f b6 c0             	movzbl %al,%eax
  8002e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ea:	8b 12                	mov    (%edx),%edx
  8002ec:	89 d1                	mov    %edx,%ecx
  8002ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f1:	83 c2 08             	add    $0x8,%edx
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	50                   	push   %eax
  8002f8:	51                   	push   %ecx
  8002f9:	52                   	push   %edx
  8002fa:	e8 78 0f 00 00       	call   801277 <sys_cputs>
  8002ff:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800302:	8b 45 0c             	mov    0xc(%ebp),%eax
  800305:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80030b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030e:	8b 40 04             	mov    0x4(%eax),%eax
  800311:	8d 50 01             	lea    0x1(%eax),%edx
  800314:	8b 45 0c             	mov    0xc(%ebp),%eax
  800317:	89 50 04             	mov    %edx,0x4(%eax)
}
  80031a:	90                   	nop
  80031b:	c9                   	leave  
  80031c:	c3                   	ret    

0080031d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800326:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80032d:	00 00 00 
	b.cnt = 0;
  800330:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800337:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80033a:	ff 75 0c             	pushl  0xc(%ebp)
  80033d:	ff 75 08             	pushl  0x8(%ebp)
  800340:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800346:	50                   	push   %eax
  800347:	68 b4 02 80 00       	push   $0x8002b4
  80034c:	e8 11 02 00 00       	call   800562 <vprintfmt>
  800351:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800354:	a0 08 30 80 00       	mov    0x803008,%al
  800359:	0f b6 c0             	movzbl %al,%eax
  80035c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800362:	83 ec 04             	sub    $0x4,%esp
  800365:	50                   	push   %eax
  800366:	52                   	push   %edx
  800367:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80036d:	83 c0 08             	add    $0x8,%eax
  800370:	50                   	push   %eax
  800371:	e8 01 0f 00 00       	call   801277 <sys_cputs>
  800376:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800379:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800380:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800386:	c9                   	leave  
  800387:	c3                   	ret    

00800388 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80038e:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800395:	8d 45 0c             	lea    0xc(%ebp),%eax
  800398:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a4:	50                   	push   %eax
  8003a5:	e8 73 ff ff ff       	call   80031d <vcprintf>
  8003aa:	83 c4 10             	add    $0x10,%esp
  8003ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003b3:	c9                   	leave  
  8003b4:	c3                   	ret    

008003b5 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003b5:	55                   	push   %ebp
  8003b6:	89 e5                	mov    %esp,%ebp
  8003b8:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003bb:	e8 f9 0e 00 00       	call   8012b9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003c0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	83 ec 08             	sub    $0x8,%esp
  8003cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8003cf:	50                   	push   %eax
  8003d0:	e8 48 ff ff ff       	call   80031d <vcprintf>
  8003d5:	83 c4 10             	add    $0x10,%esp
  8003d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003db:	e8 f3 0e 00 00       	call   8012d3 <sys_unlock_cons>
	return cnt;
  8003e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003e3:	c9                   	leave  
  8003e4:	c3                   	ret    

008003e5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	53                   	push   %ebx
  8003e9:	83 ec 14             	sub    $0x14,%esp
  8003ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003f8:	8b 45 18             	mov    0x18(%ebp),%eax
  8003fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800400:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800403:	77 55                	ja     80045a <printnum+0x75>
  800405:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800408:	72 05                	jb     80040f <printnum+0x2a>
  80040a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80040d:	77 4b                	ja     80045a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80040f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800412:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800415:	8b 45 18             	mov    0x18(%ebp),%eax
  800418:	ba 00 00 00 00       	mov    $0x0,%edx
  80041d:	52                   	push   %edx
  80041e:	50                   	push   %eax
  80041f:	ff 75 f4             	pushl  -0xc(%ebp)
  800422:	ff 75 f0             	pushl  -0x10(%ebp)
  800425:	e8 5e 17 00 00       	call   801b88 <__udivdi3>
  80042a:	83 c4 10             	add    $0x10,%esp
  80042d:	83 ec 04             	sub    $0x4,%esp
  800430:	ff 75 20             	pushl  0x20(%ebp)
  800433:	53                   	push   %ebx
  800434:	ff 75 18             	pushl  0x18(%ebp)
  800437:	52                   	push   %edx
  800438:	50                   	push   %eax
  800439:	ff 75 0c             	pushl  0xc(%ebp)
  80043c:	ff 75 08             	pushl  0x8(%ebp)
  80043f:	e8 a1 ff ff ff       	call   8003e5 <printnum>
  800444:	83 c4 20             	add    $0x20,%esp
  800447:	eb 1a                	jmp    800463 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800449:	83 ec 08             	sub    $0x8,%esp
  80044c:	ff 75 0c             	pushl  0xc(%ebp)
  80044f:	ff 75 20             	pushl  0x20(%ebp)
  800452:	8b 45 08             	mov    0x8(%ebp),%eax
  800455:	ff d0                	call   *%eax
  800457:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80045a:	ff 4d 1c             	decl   0x1c(%ebp)
  80045d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800461:	7f e6                	jg     800449 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800463:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800466:	bb 00 00 00 00       	mov    $0x0,%ebx
  80046b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80046e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800471:	53                   	push   %ebx
  800472:	51                   	push   %ecx
  800473:	52                   	push   %edx
  800474:	50                   	push   %eax
  800475:	e8 1e 18 00 00       	call   801c98 <__umoddi3>
  80047a:	83 c4 10             	add    $0x10,%esp
  80047d:	05 14 21 80 00       	add    $0x802114,%eax
  800482:	8a 00                	mov    (%eax),%al
  800484:	0f be c0             	movsbl %al,%eax
  800487:	83 ec 08             	sub    $0x8,%esp
  80048a:	ff 75 0c             	pushl  0xc(%ebp)
  80048d:	50                   	push   %eax
  80048e:	8b 45 08             	mov    0x8(%ebp),%eax
  800491:	ff d0                	call   *%eax
  800493:	83 c4 10             	add    $0x10,%esp
}
  800496:	90                   	nop
  800497:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80049a:	c9                   	leave  
  80049b:	c3                   	ret    

0080049c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80049c:	55                   	push   %ebp
  80049d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80049f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004a3:	7e 1c                	jle    8004c1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	8d 50 08             	lea    0x8(%eax),%edx
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	89 10                	mov    %edx,(%eax)
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	83 e8 08             	sub    $0x8,%eax
  8004ba:	8b 50 04             	mov    0x4(%eax),%edx
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	eb 40                	jmp    800501 <getuint+0x65>
	else if (lflag)
  8004c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004c5:	74 1e                	je     8004e5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	8d 50 04             	lea    0x4(%eax),%edx
  8004cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	83 e8 04             	sub    $0x4,%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e3:	eb 1c                	jmp    800501 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	8d 50 04             	lea    0x4(%eax),%edx
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f0:	89 10                	mov    %edx,(%eax)
  8004f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	83 e8 04             	sub    $0x4,%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800501:	5d                   	pop    %ebp
  800502:	c3                   	ret    

00800503 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800503:	55                   	push   %ebp
  800504:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800506:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80050a:	7e 1c                	jle    800528 <getint+0x25>
		return va_arg(*ap, long long);
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	8d 50 08             	lea    0x8(%eax),%edx
  800514:	8b 45 08             	mov    0x8(%ebp),%eax
  800517:	89 10                	mov    %edx,(%eax)
  800519:	8b 45 08             	mov    0x8(%ebp),%eax
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	83 e8 08             	sub    $0x8,%eax
  800521:	8b 50 04             	mov    0x4(%eax),%edx
  800524:	8b 00                	mov    (%eax),%eax
  800526:	eb 38                	jmp    800560 <getint+0x5d>
	else if (lflag)
  800528:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80052c:	74 1a                	je     800548 <getint+0x45>
		return va_arg(*ap, long);
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	8b 00                	mov    (%eax),%eax
  800533:	8d 50 04             	lea    0x4(%eax),%edx
  800536:	8b 45 08             	mov    0x8(%ebp),%eax
  800539:	89 10                	mov    %edx,(%eax)
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	83 e8 04             	sub    $0x4,%eax
  800543:	8b 00                	mov    (%eax),%eax
  800545:	99                   	cltd   
  800546:	eb 18                	jmp    800560 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	8d 50 04             	lea    0x4(%eax),%edx
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	89 10                	mov    %edx,(%eax)
  800555:	8b 45 08             	mov    0x8(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	83 e8 04             	sub    $0x4,%eax
  80055d:	8b 00                	mov    (%eax),%eax
  80055f:	99                   	cltd   
}
  800560:	5d                   	pop    %ebp
  800561:	c3                   	ret    

00800562 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800562:	55                   	push   %ebp
  800563:	89 e5                	mov    %esp,%ebp
  800565:	56                   	push   %esi
  800566:	53                   	push   %ebx
  800567:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80056a:	eb 17                	jmp    800583 <vprintfmt+0x21>
			if (ch == '\0')
  80056c:	85 db                	test   %ebx,%ebx
  80056e:	0f 84 c1 03 00 00    	je     800935 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 0c             	pushl  0xc(%ebp)
  80057a:	53                   	push   %ebx
  80057b:	8b 45 08             	mov    0x8(%ebp),%eax
  80057e:	ff d0                	call   *%eax
  800580:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800583:	8b 45 10             	mov    0x10(%ebp),%eax
  800586:	8d 50 01             	lea    0x1(%eax),%edx
  800589:	89 55 10             	mov    %edx,0x10(%ebp)
  80058c:	8a 00                	mov    (%eax),%al
  80058e:	0f b6 d8             	movzbl %al,%ebx
  800591:	83 fb 25             	cmp    $0x25,%ebx
  800594:	75 d6                	jne    80056c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800596:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80059a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005a1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005af:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b9:	8d 50 01             	lea    0x1(%eax),%edx
  8005bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8005bf:	8a 00                	mov    (%eax),%al
  8005c1:	0f b6 d8             	movzbl %al,%ebx
  8005c4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005c7:	83 f8 5b             	cmp    $0x5b,%eax
  8005ca:	0f 87 3d 03 00 00    	ja     80090d <vprintfmt+0x3ab>
  8005d0:	8b 04 85 38 21 80 00 	mov    0x802138(,%eax,4),%eax
  8005d7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005d9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005dd:	eb d7                	jmp    8005b6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005df:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005e3:	eb d1                	jmp    8005b6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ef:	89 d0                	mov    %edx,%eax
  8005f1:	c1 e0 02             	shl    $0x2,%eax
  8005f4:	01 d0                	add    %edx,%eax
  8005f6:	01 c0                	add    %eax,%eax
  8005f8:	01 d8                	add    %ebx,%eax
  8005fa:	83 e8 30             	sub    $0x30,%eax
  8005fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800600:	8b 45 10             	mov    0x10(%ebp),%eax
  800603:	8a 00                	mov    (%eax),%al
  800605:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800608:	83 fb 2f             	cmp    $0x2f,%ebx
  80060b:	7e 3e                	jle    80064b <vprintfmt+0xe9>
  80060d:	83 fb 39             	cmp    $0x39,%ebx
  800610:	7f 39                	jg     80064b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800612:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800615:	eb d5                	jmp    8005ec <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	83 c0 04             	add    $0x4,%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
  800620:	8b 45 14             	mov    0x14(%ebp),%eax
  800623:	83 e8 04             	sub    $0x4,%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80062b:	eb 1f                	jmp    80064c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80062d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800631:	79 83                	jns    8005b6 <vprintfmt+0x54>
				width = 0;
  800633:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80063a:	e9 77 ff ff ff       	jmp    8005b6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80063f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800646:	e9 6b ff ff ff       	jmp    8005b6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80064b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80064c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800650:	0f 89 60 ff ff ff    	jns    8005b6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800656:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800659:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80065c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800663:	e9 4e ff ff ff       	jmp    8005b6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800668:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80066b:	e9 46 ff ff ff       	jmp    8005b6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	83 c0 04             	add    $0x4,%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	83 e8 04             	sub    $0x4,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	ff 75 0c             	pushl  0xc(%ebp)
  800687:	50                   	push   %eax
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	ff d0                	call   *%eax
  80068d:	83 c4 10             	add    $0x10,%esp
			break;
  800690:	e9 9b 02 00 00       	jmp    800930 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	83 c0 04             	add    $0x4,%eax
  80069b:	89 45 14             	mov    %eax,0x14(%ebp)
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	83 e8 04             	sub    $0x4,%eax
  8006a4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006a6:	85 db                	test   %ebx,%ebx
  8006a8:	79 02                	jns    8006ac <vprintfmt+0x14a>
				err = -err;
  8006aa:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006ac:	83 fb 64             	cmp    $0x64,%ebx
  8006af:	7f 0b                	jg     8006bc <vprintfmt+0x15a>
  8006b1:	8b 34 9d 80 1f 80 00 	mov    0x801f80(,%ebx,4),%esi
  8006b8:	85 f6                	test   %esi,%esi
  8006ba:	75 19                	jne    8006d5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006bc:	53                   	push   %ebx
  8006bd:	68 25 21 80 00       	push   $0x802125
  8006c2:	ff 75 0c             	pushl  0xc(%ebp)
  8006c5:	ff 75 08             	pushl  0x8(%ebp)
  8006c8:	e8 70 02 00 00       	call   80093d <printfmt>
  8006cd:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006d0:	e9 5b 02 00 00       	jmp    800930 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006d5:	56                   	push   %esi
  8006d6:	68 2e 21 80 00       	push   $0x80212e
  8006db:	ff 75 0c             	pushl  0xc(%ebp)
  8006de:	ff 75 08             	pushl  0x8(%ebp)
  8006e1:	e8 57 02 00 00       	call   80093d <printfmt>
  8006e6:	83 c4 10             	add    $0x10,%esp
			break;
  8006e9:	e9 42 02 00 00       	jmp    800930 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	83 c0 04             	add    $0x4,%eax
  8006f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	83 e8 04             	sub    $0x4,%eax
  8006fd:	8b 30                	mov    (%eax),%esi
  8006ff:	85 f6                	test   %esi,%esi
  800701:	75 05                	jne    800708 <vprintfmt+0x1a6>
				p = "(null)";
  800703:	be 31 21 80 00       	mov    $0x802131,%esi
			if (width > 0 && padc != '-')
  800708:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070c:	7e 6d                	jle    80077b <vprintfmt+0x219>
  80070e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800712:	74 67                	je     80077b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800714:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	50                   	push   %eax
  80071b:	56                   	push   %esi
  80071c:	e8 1e 03 00 00       	call   800a3f <strnlen>
  800721:	83 c4 10             	add    $0x10,%esp
  800724:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800727:	eb 16                	jmp    80073f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800729:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80072d:	83 ec 08             	sub    $0x8,%esp
  800730:	ff 75 0c             	pushl  0xc(%ebp)
  800733:	50                   	push   %eax
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	ff d0                	call   *%eax
  800739:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80073c:	ff 4d e4             	decl   -0x1c(%ebp)
  80073f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800743:	7f e4                	jg     800729 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800745:	eb 34                	jmp    80077b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800747:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80074b:	74 1c                	je     800769 <vprintfmt+0x207>
  80074d:	83 fb 1f             	cmp    $0x1f,%ebx
  800750:	7e 05                	jle    800757 <vprintfmt+0x1f5>
  800752:	83 fb 7e             	cmp    $0x7e,%ebx
  800755:	7e 12                	jle    800769 <vprintfmt+0x207>
					putch('?', putdat);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	ff 75 0c             	pushl  0xc(%ebp)
  80075d:	6a 3f                	push   $0x3f
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	ff d0                	call   *%eax
  800764:	83 c4 10             	add    $0x10,%esp
  800767:	eb 0f                	jmp    800778 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	ff 75 0c             	pushl  0xc(%ebp)
  80076f:	53                   	push   %ebx
  800770:	8b 45 08             	mov    0x8(%ebp),%eax
  800773:	ff d0                	call   *%eax
  800775:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800778:	ff 4d e4             	decl   -0x1c(%ebp)
  80077b:	89 f0                	mov    %esi,%eax
  80077d:	8d 70 01             	lea    0x1(%eax),%esi
  800780:	8a 00                	mov    (%eax),%al
  800782:	0f be d8             	movsbl %al,%ebx
  800785:	85 db                	test   %ebx,%ebx
  800787:	74 24                	je     8007ad <vprintfmt+0x24b>
  800789:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80078d:	78 b8                	js     800747 <vprintfmt+0x1e5>
  80078f:	ff 4d e0             	decl   -0x20(%ebp)
  800792:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800796:	79 af                	jns    800747 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800798:	eb 13                	jmp    8007ad <vprintfmt+0x24b>
				putch(' ', putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	ff 75 0c             	pushl  0xc(%ebp)
  8007a0:	6a 20                	push   $0x20
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	ff d0                	call   *%eax
  8007a7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007aa:	ff 4d e4             	decl   -0x1c(%ebp)
  8007ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b1:	7f e7                	jg     80079a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007b3:	e9 78 01 00 00       	jmp    800930 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	ff 75 e8             	pushl  -0x18(%ebp)
  8007be:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c1:	50                   	push   %eax
  8007c2:	e8 3c fd ff ff       	call   800503 <getint>
  8007c7:	83 c4 10             	add    $0x10,%esp
  8007ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d6:	85 d2                	test   %edx,%edx
  8007d8:	79 23                	jns    8007fd <vprintfmt+0x29b>
				putch('-', putdat);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	ff 75 0c             	pushl  0xc(%ebp)
  8007e0:	6a 2d                	push   $0x2d
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	ff d0                	call   *%eax
  8007e7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f0:	f7 d8                	neg    %eax
  8007f2:	83 d2 00             	adc    $0x0,%edx
  8007f5:	f7 da                	neg    %edx
  8007f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007fd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800804:	e9 bc 00 00 00       	jmp    8008c5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800809:	83 ec 08             	sub    $0x8,%esp
  80080c:	ff 75 e8             	pushl  -0x18(%ebp)
  80080f:	8d 45 14             	lea    0x14(%ebp),%eax
  800812:	50                   	push   %eax
  800813:	e8 84 fc ff ff       	call   80049c <getuint>
  800818:	83 c4 10             	add    $0x10,%esp
  80081b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800821:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800828:	e9 98 00 00 00       	jmp    8008c5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	6a 58                	push   $0x58
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	ff d0                	call   *%eax
  80083a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	6a 58                	push   $0x58
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	ff d0                	call   *%eax
  80084a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	ff 75 0c             	pushl  0xc(%ebp)
  800853:	6a 58                	push   $0x58
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	ff d0                	call   *%eax
  80085a:	83 c4 10             	add    $0x10,%esp
			break;
  80085d:	e9 ce 00 00 00       	jmp    800930 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	6a 30                	push   $0x30
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	ff d0                	call   *%eax
  80086f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	ff 75 0c             	pushl  0xc(%ebp)
  800878:	6a 78                	push   $0x78
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	ff d0                	call   *%eax
  80087f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800882:	8b 45 14             	mov    0x14(%ebp),%eax
  800885:	83 c0 04             	add    $0x4,%eax
  800888:	89 45 14             	mov    %eax,0x14(%ebp)
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 e8 04             	sub    $0x4,%eax
  800891:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800893:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800896:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80089d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008a4:	eb 1f                	jmp    8008c5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008a6:	83 ec 08             	sub    $0x8,%esp
  8008a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8008ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8008af:	50                   	push   %eax
  8008b0:	e8 e7 fb ff ff       	call   80049c <getuint>
  8008b5:	83 c4 10             	add    $0x10,%esp
  8008b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008be:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008c5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008cc:	83 ec 04             	sub    $0x4,%esp
  8008cf:	52                   	push   %edx
  8008d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008d3:	50                   	push   %eax
  8008d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8008da:	ff 75 0c             	pushl  0xc(%ebp)
  8008dd:	ff 75 08             	pushl  0x8(%ebp)
  8008e0:	e8 00 fb ff ff       	call   8003e5 <printnum>
  8008e5:	83 c4 20             	add    $0x20,%esp
			break;
  8008e8:	eb 46                	jmp    800930 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008ea:	83 ec 08             	sub    $0x8,%esp
  8008ed:	ff 75 0c             	pushl  0xc(%ebp)
  8008f0:	53                   	push   %ebx
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	ff d0                	call   *%eax
  8008f6:	83 c4 10             	add    $0x10,%esp
			break;
  8008f9:	eb 35                	jmp    800930 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008fb:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800902:	eb 2c                	jmp    800930 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800904:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  80090b:	eb 23                	jmp    800930 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	ff 75 0c             	pushl  0xc(%ebp)
  800913:	6a 25                	push   $0x25
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	ff d0                	call   *%eax
  80091a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80091d:	ff 4d 10             	decl   0x10(%ebp)
  800920:	eb 03                	jmp    800925 <vprintfmt+0x3c3>
  800922:	ff 4d 10             	decl   0x10(%ebp)
  800925:	8b 45 10             	mov    0x10(%ebp),%eax
  800928:	48                   	dec    %eax
  800929:	8a 00                	mov    (%eax),%al
  80092b:	3c 25                	cmp    $0x25,%al
  80092d:	75 f3                	jne    800922 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80092f:	90                   	nop
		}
	}
  800930:	e9 35 fc ff ff       	jmp    80056a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800935:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800936:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800939:	5b                   	pop    %ebx
  80093a:	5e                   	pop    %esi
  80093b:	5d                   	pop    %ebp
  80093c:	c3                   	ret    

0080093d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80093d:	55                   	push   %ebp
  80093e:	89 e5                	mov    %esp,%ebp
  800940:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800943:	8d 45 10             	lea    0x10(%ebp),%eax
  800946:	83 c0 04             	add    $0x4,%eax
  800949:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80094c:	8b 45 10             	mov    0x10(%ebp),%eax
  80094f:	ff 75 f4             	pushl  -0xc(%ebp)
  800952:	50                   	push   %eax
  800953:	ff 75 0c             	pushl  0xc(%ebp)
  800956:	ff 75 08             	pushl  0x8(%ebp)
  800959:	e8 04 fc ff ff       	call   800562 <vprintfmt>
  80095e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800961:	90                   	nop
  800962:	c9                   	leave  
  800963:	c3                   	ret    

00800964 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096a:	8b 40 08             	mov    0x8(%eax),%eax
  80096d:	8d 50 01             	lea    0x1(%eax),%edx
  800970:	8b 45 0c             	mov    0xc(%ebp),%eax
  800973:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800976:	8b 45 0c             	mov    0xc(%ebp),%eax
  800979:	8b 10                	mov    (%eax),%edx
  80097b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097e:	8b 40 04             	mov    0x4(%eax),%eax
  800981:	39 c2                	cmp    %eax,%edx
  800983:	73 12                	jae    800997 <sprintputch+0x33>
		*b->buf++ = ch;
  800985:	8b 45 0c             	mov    0xc(%ebp),%eax
  800988:	8b 00                	mov    (%eax),%eax
  80098a:	8d 48 01             	lea    0x1(%eax),%ecx
  80098d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800990:	89 0a                	mov    %ecx,(%edx)
  800992:	8b 55 08             	mov    0x8(%ebp),%edx
  800995:	88 10                	mov    %dl,(%eax)
}
  800997:	90                   	nop
  800998:	5d                   	pop    %ebp
  800999:	c3                   	ret    

0080099a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	01 d0                	add    %edx,%eax
  8009b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009bf:	74 06                	je     8009c7 <vsnprintf+0x2d>
  8009c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009c5:	7f 07                	jg     8009ce <vsnprintf+0x34>
		return -E_INVAL;
  8009c7:	b8 03 00 00 00       	mov    $0x3,%eax
  8009cc:	eb 20                	jmp    8009ee <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009ce:	ff 75 14             	pushl  0x14(%ebp)
  8009d1:	ff 75 10             	pushl  0x10(%ebp)
  8009d4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009d7:	50                   	push   %eax
  8009d8:	68 64 09 80 00       	push   $0x800964
  8009dd:	e8 80 fb ff ff       	call   800562 <vprintfmt>
  8009e2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009e8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009ee:	c9                   	leave  
  8009ef:	c3                   	ret    

008009f0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009f6:	8d 45 10             	lea    0x10(%ebp),%eax
  8009f9:	83 c0 04             	add    $0x4,%eax
  8009fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800a02:	ff 75 f4             	pushl  -0xc(%ebp)
  800a05:	50                   	push   %eax
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	ff 75 08             	pushl  0x8(%ebp)
  800a0c:	e8 89 ff ff ff       	call   80099a <vsnprintf>
  800a11:	83 c4 10             	add    $0x10,%esp
  800a14:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a1a:	c9                   	leave  
  800a1b:	c3                   	ret    

00800a1c <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a29:	eb 06                	jmp    800a31 <strlen+0x15>
		n++;
  800a2b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a2e:	ff 45 08             	incl   0x8(%ebp)
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	8a 00                	mov    (%eax),%al
  800a36:	84 c0                	test   %al,%al
  800a38:	75 f1                	jne    800a2b <strlen+0xf>
		n++;
	return n;
  800a3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a3d:	c9                   	leave  
  800a3e:	c3                   	ret    

00800a3f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a4c:	eb 09                	jmp    800a57 <strnlen+0x18>
		n++;
  800a4e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a51:	ff 45 08             	incl   0x8(%ebp)
  800a54:	ff 4d 0c             	decl   0xc(%ebp)
  800a57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a5b:	74 09                	je     800a66 <strnlen+0x27>
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	8a 00                	mov    (%eax),%al
  800a62:	84 c0                	test   %al,%al
  800a64:	75 e8                	jne    800a4e <strnlen+0xf>
		n++;
	return n;
  800a66:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a69:	c9                   	leave  
  800a6a:	c3                   	ret    

00800a6b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a77:	90                   	nop
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8d 50 01             	lea    0x1(%eax),%edx
  800a7e:	89 55 08             	mov    %edx,0x8(%ebp)
  800a81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a84:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a87:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a8a:	8a 12                	mov    (%edx),%dl
  800a8c:	88 10                	mov    %dl,(%eax)
  800a8e:	8a 00                	mov    (%eax),%al
  800a90:	84 c0                	test   %al,%al
  800a92:	75 e4                	jne    800a78 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a94:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a97:	c9                   	leave  
  800a98:	c3                   	ret    

00800a99 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800aa5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aac:	eb 1f                	jmp    800acd <strncpy+0x34>
		*dst++ = *src;
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	8d 50 01             	lea    0x1(%eax),%edx
  800ab4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aba:	8a 12                	mov    (%edx),%dl
  800abc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800abe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac1:	8a 00                	mov    (%eax),%al
  800ac3:	84 c0                	test   %al,%al
  800ac5:	74 03                	je     800aca <strncpy+0x31>
			src++;
  800ac7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aca:	ff 45 fc             	incl   -0x4(%ebp)
  800acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ad3:	72 d9                	jb     800aae <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ad5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ad8:	c9                   	leave  
  800ad9:	c3                   	ret    

00800ada <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ae6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aea:	74 30                	je     800b1c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800aec:	eb 16                	jmp    800b04 <strlcpy+0x2a>
			*dst++ = *src++;
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8d 50 01             	lea    0x1(%eax),%edx
  800af4:	89 55 08             	mov    %edx,0x8(%ebp)
  800af7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800afd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b00:	8a 12                	mov    (%edx),%dl
  800b02:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b04:	ff 4d 10             	decl   0x10(%ebp)
  800b07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b0b:	74 09                	je     800b16 <strlcpy+0x3c>
  800b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b10:	8a 00                	mov    (%eax),%al
  800b12:	84 c0                	test   %al,%al
  800b14:	75 d8                	jne    800aee <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b22:	29 c2                	sub    %eax,%edx
  800b24:	89 d0                	mov    %edx,%eax
}
  800b26:	c9                   	leave  
  800b27:	c3                   	ret    

00800b28 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b2b:	eb 06                	jmp    800b33 <strcmp+0xb>
		p++, q++;
  800b2d:	ff 45 08             	incl   0x8(%ebp)
  800b30:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	8a 00                	mov    (%eax),%al
  800b38:	84 c0                	test   %al,%al
  800b3a:	74 0e                	je     800b4a <strcmp+0x22>
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8a 10                	mov    (%eax),%dl
  800b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b44:	8a 00                	mov    (%eax),%al
  800b46:	38 c2                	cmp    %al,%dl
  800b48:	74 e3                	je     800b2d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	8a 00                	mov    (%eax),%al
  800b4f:	0f b6 d0             	movzbl %al,%edx
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8a 00                	mov    (%eax),%al
  800b57:	0f b6 c0             	movzbl %al,%eax
  800b5a:	29 c2                	sub    %eax,%edx
  800b5c:	89 d0                	mov    %edx,%eax
}
  800b5e:	5d                   	pop    %ebp
  800b5f:	c3                   	ret    

00800b60 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b63:	eb 09                	jmp    800b6e <strncmp+0xe>
		n--, p++, q++;
  800b65:	ff 4d 10             	decl   0x10(%ebp)
  800b68:	ff 45 08             	incl   0x8(%ebp)
  800b6b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b72:	74 17                	je     800b8b <strncmp+0x2b>
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	8a 00                	mov    (%eax),%al
  800b79:	84 c0                	test   %al,%al
  800b7b:	74 0e                	je     800b8b <strncmp+0x2b>
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	8a 10                	mov    (%eax),%dl
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	38 c2                	cmp    %al,%dl
  800b89:	74 da                	je     800b65 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b8f:	75 07                	jne    800b98 <strncmp+0x38>
		return 0;
  800b91:	b8 00 00 00 00       	mov    $0x0,%eax
  800b96:	eb 14                	jmp    800bac <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	8a 00                	mov    (%eax),%al
  800b9d:	0f b6 d0             	movzbl %al,%edx
  800ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba3:	8a 00                	mov    (%eax),%al
  800ba5:	0f b6 c0             	movzbl %al,%eax
  800ba8:	29 c2                	sub    %eax,%edx
  800baa:	89 d0                	mov    %edx,%eax
}
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    

00800bae <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	83 ec 04             	sub    $0x4,%esp
  800bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bba:	eb 12                	jmp    800bce <strchr+0x20>
		if (*s == c)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8a 00                	mov    (%eax),%al
  800bc1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bc4:	75 05                	jne    800bcb <strchr+0x1d>
			return (char *) s;
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	eb 11                	jmp    800bdc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bcb:	ff 45 08             	incl   0x8(%ebp)
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8a 00                	mov    (%eax),%al
  800bd3:	84 c0                	test   %al,%al
  800bd5:	75 e5                	jne    800bbc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bdc:	c9                   	leave  
  800bdd:	c3                   	ret    

00800bde <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	83 ec 04             	sub    $0x4,%esp
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bea:	eb 0d                	jmp    800bf9 <strfind+0x1b>
		if (*s == c)
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	8a 00                	mov    (%eax),%al
  800bf1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bf4:	74 0e                	je     800c04 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bf6:	ff 45 08             	incl   0x8(%ebp)
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	75 ea                	jne    800bec <strfind+0xe>
  800c02:	eb 01                	jmp    800c05 <strfind+0x27>
		if (*s == c)
			break;
  800c04:	90                   	nop
	return (char *) s;
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c08:	c9                   	leave  
  800c09:	c3                   	ret    

00800c0a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c16:	8b 45 10             	mov    0x10(%ebp),%eax
  800c19:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c1c:	eb 0e                	jmp    800c2c <memset+0x22>
		*p++ = c;
  800c1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c21:	8d 50 01             	lea    0x1(%eax),%edx
  800c24:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c2c:	ff 4d f8             	decl   -0x8(%ebp)
  800c2f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c33:	79 e9                	jns    800c1e <memset+0x14>
		*p++ = c;

	return v;
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c38:	c9                   	leave  
  800c39:	c3                   	ret    

00800c3a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c4c:	eb 16                	jmp    800c64 <memcpy+0x2a>
		*d++ = *s++;
  800c4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c51:	8d 50 01             	lea    0x1(%eax),%edx
  800c54:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c5d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c60:	8a 12                	mov    (%edx),%dl
  800c62:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c64:	8b 45 10             	mov    0x10(%ebp),%eax
  800c67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c6d:	85 c0                	test   %eax,%eax
  800c6f:	75 dd                	jne    800c4e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c8b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c8e:	73 50                	jae    800ce0 <memmove+0x6a>
  800c90:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c93:	8b 45 10             	mov    0x10(%ebp),%eax
  800c96:	01 d0                	add    %edx,%eax
  800c98:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c9b:	76 43                	jbe    800ce0 <memmove+0x6a>
		s += n;
  800c9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ca3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ca9:	eb 10                	jmp    800cbb <memmove+0x45>
			*--d = *--s;
  800cab:	ff 4d f8             	decl   -0x8(%ebp)
  800cae:	ff 4d fc             	decl   -0x4(%ebp)
  800cb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb4:	8a 10                	mov    (%eax),%dl
  800cb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cb9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800cbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800cc4:	85 c0                	test   %eax,%eax
  800cc6:	75 e3                	jne    800cab <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cc8:	eb 23                	jmp    800ced <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ccd:	8d 50 01             	lea    0x1(%eax),%edx
  800cd0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cd3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cd6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cdc:	8a 12                	mov    (%edx),%dl
  800cde:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ce6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce9:	85 c0                	test   %eax,%eax
  800ceb:	75 dd                	jne    800cca <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf0:	c9                   	leave  
  800cf1:	c3                   	ret    

00800cf2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d04:	eb 2a                	jmp    800d30 <memcmp+0x3e>
		if (*s1 != *s2)
  800d06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d09:	8a 10                	mov    (%eax),%dl
  800d0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	38 c2                	cmp    %al,%dl
  800d12:	74 16                	je     800d2a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	0f b6 d0             	movzbl %al,%edx
  800d1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d1f:	8a 00                	mov    (%eax),%al
  800d21:	0f b6 c0             	movzbl %al,%eax
  800d24:	29 c2                	sub    %eax,%edx
  800d26:	89 d0                	mov    %edx,%eax
  800d28:	eb 18                	jmp    800d42 <memcmp+0x50>
		s1++, s2++;
  800d2a:	ff 45 fc             	incl   -0x4(%ebp)
  800d2d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d30:	8b 45 10             	mov    0x10(%ebp),%eax
  800d33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d36:	89 55 10             	mov    %edx,0x10(%ebp)
  800d39:	85 c0                	test   %eax,%eax
  800d3b:	75 c9                	jne    800d06 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d42:	c9                   	leave  
  800d43:	c3                   	ret    

00800d44 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d50:	01 d0                	add    %edx,%eax
  800d52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d55:	eb 15                	jmp    800d6c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	0f b6 d0             	movzbl %al,%edx
  800d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d62:	0f b6 c0             	movzbl %al,%eax
  800d65:	39 c2                	cmp    %eax,%edx
  800d67:	74 0d                	je     800d76 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d69:	ff 45 08             	incl   0x8(%ebp)
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d72:	72 e3                	jb     800d57 <memfind+0x13>
  800d74:	eb 01                	jmp    800d77 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d76:	90                   	nop
	return (void *) s;
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d7a:	c9                   	leave  
  800d7b:	c3                   	ret    

00800d7c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d89:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d90:	eb 03                	jmp    800d95 <strtol+0x19>
		s++;
  800d92:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	3c 20                	cmp    $0x20,%al
  800d9c:	74 f4                	je     800d92 <strtol+0x16>
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	3c 09                	cmp    $0x9,%al
  800da5:	74 eb                	je     800d92 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	3c 2b                	cmp    $0x2b,%al
  800dae:	75 05                	jne    800db5 <strtol+0x39>
		s++;
  800db0:	ff 45 08             	incl   0x8(%ebp)
  800db3:	eb 13                	jmp    800dc8 <strtol+0x4c>
	else if (*s == '-')
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	3c 2d                	cmp    $0x2d,%al
  800dbc:	75 0a                	jne    800dc8 <strtol+0x4c>
		s++, neg = 1;
  800dbe:	ff 45 08             	incl   0x8(%ebp)
  800dc1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dc8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dcc:	74 06                	je     800dd4 <strtol+0x58>
  800dce:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800dd2:	75 20                	jne    800df4 <strtol+0x78>
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	3c 30                	cmp    $0x30,%al
  800ddb:	75 17                	jne    800df4 <strtol+0x78>
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	40                   	inc    %eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	3c 78                	cmp    $0x78,%al
  800de5:	75 0d                	jne    800df4 <strtol+0x78>
		s += 2, base = 16;
  800de7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800deb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800df2:	eb 28                	jmp    800e1c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800df4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df8:	75 15                	jne    800e0f <strtol+0x93>
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8a 00                	mov    (%eax),%al
  800dff:	3c 30                	cmp    $0x30,%al
  800e01:	75 0c                	jne    800e0f <strtol+0x93>
		s++, base = 8;
  800e03:	ff 45 08             	incl   0x8(%ebp)
  800e06:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e0d:	eb 0d                	jmp    800e1c <strtol+0xa0>
	else if (base == 0)
  800e0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e13:	75 07                	jne    800e1c <strtol+0xa0>
		base = 10;
  800e15:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	3c 2f                	cmp    $0x2f,%al
  800e23:	7e 19                	jle    800e3e <strtol+0xc2>
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8a 00                	mov    (%eax),%al
  800e2a:	3c 39                	cmp    $0x39,%al
  800e2c:	7f 10                	jg     800e3e <strtol+0xc2>
			dig = *s - '0';
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	0f be c0             	movsbl %al,%eax
  800e36:	83 e8 30             	sub    $0x30,%eax
  800e39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e3c:	eb 42                	jmp    800e80 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	3c 60                	cmp    $0x60,%al
  800e45:	7e 19                	jle    800e60 <strtol+0xe4>
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	3c 7a                	cmp    $0x7a,%al
  800e4e:	7f 10                	jg     800e60 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	0f be c0             	movsbl %al,%eax
  800e58:	83 e8 57             	sub    $0x57,%eax
  800e5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e5e:	eb 20                	jmp    800e80 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	3c 40                	cmp    $0x40,%al
  800e67:	7e 39                	jle    800ea2 <strtol+0x126>
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	3c 5a                	cmp    $0x5a,%al
  800e70:	7f 30                	jg     800ea2 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	0f be c0             	movsbl %al,%eax
  800e7a:	83 e8 37             	sub    $0x37,%eax
  800e7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e83:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e86:	7d 19                	jge    800ea1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e88:	ff 45 08             	incl   0x8(%ebp)
  800e8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e92:	89 c2                	mov    %eax,%edx
  800e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e97:	01 d0                	add    %edx,%eax
  800e99:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e9c:	e9 7b ff ff ff       	jmp    800e1c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ea1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ea2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea6:	74 08                	je     800eb0 <strtol+0x134>
		*endptr = (char *) s;
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	8b 55 08             	mov    0x8(%ebp),%edx
  800eae:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800eb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800eb4:	74 07                	je     800ebd <strtol+0x141>
  800eb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb9:	f7 d8                	neg    %eax
  800ebb:	eb 03                	jmp    800ec0 <strtol+0x144>
  800ebd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <ltostr>:

void
ltostr(long value, char *str)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ec8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800ecf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ed6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800eda:	79 13                	jns    800eef <ltostr+0x2d>
	{
		neg = 1;
  800edc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ee9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800eec:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ef7:	99                   	cltd   
  800ef8:	f7 f9                	idiv   %ecx
  800efa:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800efd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f00:	8d 50 01             	lea    0x1(%eax),%edx
  800f03:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f06:	89 c2                	mov    %eax,%edx
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	01 d0                	add    %edx,%eax
  800f0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f10:	83 c2 30             	add    $0x30,%edx
  800f13:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f18:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f1d:	f7 e9                	imul   %ecx
  800f1f:	c1 fa 02             	sar    $0x2,%edx
  800f22:	89 c8                	mov    %ecx,%eax
  800f24:	c1 f8 1f             	sar    $0x1f,%eax
  800f27:	29 c2                	sub    %eax,%edx
  800f29:	89 d0                	mov    %edx,%eax
  800f2b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f32:	75 bb                	jne    800eef <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3e:	48                   	dec    %eax
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f46:	74 3d                	je     800f85 <ltostr+0xc3>
		start = 1 ;
  800f48:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f4f:	eb 34                	jmp    800f85 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	01 c2                	add    %eax,%edx
  800f66:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	01 c8                	add    %ecx,%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	01 c2                	add    %eax,%edx
  800f7a:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7d:	88 02                	mov    %al,(%edx)
		start++ ;
  800f7f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f82:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8b:	7c c4                	jl     800f51 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	01 d0                	add    %edx,%eax
  800f95:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f98:	90                   	nop
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa1:	ff 75 08             	pushl  0x8(%ebp)
  800fa4:	e8 73 fa ff ff       	call   800a1c <strlen>
  800fa9:	83 c4 04             	add    $0x4,%esp
  800fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800faf:	ff 75 0c             	pushl  0xc(%ebp)
  800fb2:	e8 65 fa ff ff       	call   800a1c <strlen>
  800fb7:	83 c4 04             	add    $0x4,%esp
  800fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcb:	eb 17                	jmp    800fe4 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	01 c2                	add    %eax,%edx
  800fd5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	01 c8                	add    %ecx,%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe1:	ff 45 fc             	incl   -0x4(%ebp)
  800fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fea:	7c e1                	jl     800fcd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffa:	eb 1f                	jmp    80101b <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fff:	8d 50 01             	lea    0x1(%eax),%edx
  801002:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801005:	89 c2                	mov    %eax,%edx
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	01 c2                	add    %eax,%edx
  80100c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	01 c8                	add    %ecx,%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801018:	ff 45 f8             	incl   -0x8(%ebp)
  80101b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801021:	7c d9                	jl     800ffc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801023:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801026:	8b 45 10             	mov    0x10(%ebp),%eax
  801029:	01 d0                	add    %edx,%eax
  80102b:	c6 00 00             	movb   $0x0,(%eax)
}
  80102e:	90                   	nop
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801034:	8b 45 14             	mov    0x14(%ebp),%eax
  801037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103d:	8b 45 14             	mov    0x14(%ebp),%eax
  801040:	8b 00                	mov    (%eax),%eax
  801042:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	01 d0                	add    %edx,%eax
  80104e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801054:	eb 0c                	jmp    801062 <strsplit+0x31>
			*string++ = 0;
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8d 50 01             	lea    0x1(%eax),%edx
  80105c:	89 55 08             	mov    %edx,0x8(%ebp)
  80105f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	84 c0                	test   %al,%al
  801069:	74 18                	je     801083 <strsplit+0x52>
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	0f be c0             	movsbl %al,%eax
  801073:	50                   	push   %eax
  801074:	ff 75 0c             	pushl  0xc(%ebp)
  801077:	e8 32 fb ff ff       	call   800bae <strchr>
  80107c:	83 c4 08             	add    $0x8,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	75 d3                	jne    801056 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	84 c0                	test   %al,%al
  80108a:	74 5a                	je     8010e6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108c:	8b 45 14             	mov    0x14(%ebp),%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	83 f8 0f             	cmp    $0xf,%eax
  801094:	75 07                	jne    80109d <strsplit+0x6c>
		{
			return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
  80109b:	eb 66                	jmp    801103 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109d:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a5:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a8:	89 0a                	mov    %ecx,(%edx)
  8010aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b4:	01 c2                	add    %eax,%edx
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bb:	eb 03                	jmp    8010c0 <strsplit+0x8f>
			string++;
  8010bd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	84 c0                	test   %al,%al
  8010c7:	74 8b                	je     801054 <strsplit+0x23>
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	0f be c0             	movsbl %al,%eax
  8010d1:	50                   	push   %eax
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	e8 d4 fa ff ff       	call   800bae <strchr>
  8010da:	83 c4 08             	add    $0x8,%esp
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	74 dc                	je     8010bd <strsplit+0x8c>
			string++;
	}
  8010e1:	e9 6e ff ff ff       	jmp    801054 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ea:	8b 00                	mov    (%eax),%eax
  8010ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80110b:	83 ec 04             	sub    $0x4,%esp
  80110e:	68 a8 22 80 00       	push   $0x8022a8
  801113:	68 3f 01 00 00       	push   $0x13f
  801118:	68 ca 22 80 00       	push   $0x8022ca
  80111d:	e8 7a 08 00 00       	call   80199c <_panic>

00801122 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
  801125:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801128:	83 ec 0c             	sub    $0xc,%esp
  80112b:	ff 75 08             	pushl  0x8(%ebp)
  80112e:	e8 ef 06 00 00       	call   801822 <sys_sbrk>
  801133:	83 c4 10             	add    $0x10,%esp
}
  801136:	c9                   	leave  
  801137:	c3                   	ret    

00801138 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80113e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801142:	75 07                	jne    80114b <malloc+0x13>
  801144:	b8 00 00 00 00       	mov    $0x0,%eax
  801149:	eb 14                	jmp    80115f <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80114b:	83 ec 04             	sub    $0x4,%esp
  80114e:	68 d8 22 80 00       	push   $0x8022d8
  801153:	6a 1b                	push   $0x1b
  801155:	68 fd 22 80 00       	push   $0x8022fd
  80115a:	e8 3d 08 00 00       	call   80199c <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80115f:	c9                   	leave  
  801160:	c3                   	ret    

00801161 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
  801164:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801167:	83 ec 04             	sub    $0x4,%esp
  80116a:	68 0c 23 80 00       	push   $0x80230c
  80116f:	6a 29                	push   $0x29
  801171:	68 fd 22 80 00       	push   $0x8022fd
  801176:	e8 21 08 00 00       	call   80199c <_panic>

0080117b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	83 ec 18             	sub    $0x18,%esp
  801181:	8b 45 10             	mov    0x10(%ebp),%eax
  801184:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801187:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80118b:	75 07                	jne    801194 <smalloc+0x19>
  80118d:	b8 00 00 00 00       	mov    $0x0,%eax
  801192:	eb 14                	jmp    8011a8 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801194:	83 ec 04             	sub    $0x4,%esp
  801197:	68 30 23 80 00       	push   $0x802330
  80119c:	6a 38                	push   $0x38
  80119e:	68 fd 22 80 00       	push   $0x8022fd
  8011a3:	e8 f4 07 00 00       	call   80199c <_panic>
	return NULL;
}
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8011b0:	83 ec 04             	sub    $0x4,%esp
  8011b3:	68 58 23 80 00       	push   $0x802358
  8011b8:	6a 43                	push   $0x43
  8011ba:	68 fd 22 80 00       	push   $0x8022fd
  8011bf:	e8 d8 07 00 00       	call   80199c <_panic>

008011c4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
  8011c7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8011ca:	83 ec 04             	sub    $0x4,%esp
  8011cd:	68 7c 23 80 00       	push   $0x80237c
  8011d2:	6a 5b                	push   $0x5b
  8011d4:	68 fd 22 80 00       	push   $0x8022fd
  8011d9:	e8 be 07 00 00       	call   80199c <_panic>

008011de <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8011e4:	83 ec 04             	sub    $0x4,%esp
  8011e7:	68 a0 23 80 00       	push   $0x8023a0
  8011ec:	6a 72                	push   $0x72
  8011ee:	68 fd 22 80 00       	push   $0x8022fd
  8011f3:	e8 a4 07 00 00       	call   80199c <_panic>

008011f8 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
  8011fb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8011fe:	83 ec 04             	sub    $0x4,%esp
  801201:	68 c6 23 80 00       	push   $0x8023c6
  801206:	6a 7e                	push   $0x7e
  801208:	68 fd 22 80 00       	push   $0x8022fd
  80120d:	e8 8a 07 00 00       	call   80199c <_panic>

00801212 <shrink>:

}
void shrink(uint32 newSize)
{
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
  801215:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801218:	83 ec 04             	sub    $0x4,%esp
  80121b:	68 c6 23 80 00       	push   $0x8023c6
  801220:	68 83 00 00 00       	push   $0x83
  801225:	68 fd 22 80 00       	push   $0x8022fd
  80122a:	e8 6d 07 00 00       	call   80199c <_panic>

0080122f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
  801232:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801235:	83 ec 04             	sub    $0x4,%esp
  801238:	68 c6 23 80 00       	push   $0x8023c6
  80123d:	68 88 00 00 00       	push   $0x88
  801242:	68 fd 22 80 00       	push   $0x8022fd
  801247:	e8 50 07 00 00       	call   80199c <_panic>

0080124c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	57                   	push   %edi
  801250:	56                   	push   %esi
  801251:	53                   	push   %ebx
  801252:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80125e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801261:	8b 7d 18             	mov    0x18(%ebp),%edi
  801264:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801267:	cd 30                	int    $0x30
  801269:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80126c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80126f:	83 c4 10             	add    $0x10,%esp
  801272:	5b                   	pop    %ebx
  801273:	5e                   	pop    %esi
  801274:	5f                   	pop    %edi
  801275:	5d                   	pop    %ebp
  801276:	c3                   	ret    

00801277 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 04             	sub    $0x4,%esp
  80127d:	8b 45 10             	mov    0x10(%ebp),%eax
  801280:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801283:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	6a 00                	push   $0x0
  80128c:	6a 00                	push   $0x0
  80128e:	52                   	push   %edx
  80128f:	ff 75 0c             	pushl  0xc(%ebp)
  801292:	50                   	push   %eax
  801293:	6a 00                	push   $0x0
  801295:	e8 b2 ff ff ff       	call   80124c <syscall>
  80129a:	83 c4 18             	add    $0x18,%esp
}
  80129d:	90                   	nop
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    

008012a0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012a3:	6a 00                	push   $0x0
  8012a5:	6a 00                	push   $0x0
  8012a7:	6a 00                	push   $0x0
  8012a9:	6a 00                	push   $0x0
  8012ab:	6a 00                	push   $0x0
  8012ad:	6a 02                	push   $0x2
  8012af:	e8 98 ff ff ff       	call   80124c <syscall>
  8012b4:	83 c4 18             	add    $0x18,%esp
}
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

008012b9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012bc:	6a 00                	push   $0x0
  8012be:	6a 00                	push   $0x0
  8012c0:	6a 00                	push   $0x0
  8012c2:	6a 00                	push   $0x0
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 03                	push   $0x3
  8012c8:	e8 7f ff ff ff       	call   80124c <syscall>
  8012cd:	83 c4 18             	add    $0x18,%esp
}
  8012d0:	90                   	nop
  8012d1:	c9                   	leave  
  8012d2:	c3                   	ret    

008012d3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 04                	push   $0x4
  8012e2:	e8 65 ff ff ff       	call   80124c <syscall>
  8012e7:	83 c4 18             	add    $0x18,%esp
}
  8012ea:	90                   	nop
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	52                   	push   %edx
  8012fd:	50                   	push   %eax
  8012fe:	6a 08                	push   $0x8
  801300:	e8 47 ff ff ff       	call   80124c <syscall>
  801305:	83 c4 18             	add    $0x18,%esp
}
  801308:	c9                   	leave  
  801309:	c3                   	ret    

0080130a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
  80130d:	56                   	push   %esi
  80130e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80130f:	8b 75 18             	mov    0x18(%ebp),%esi
  801312:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801315:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801318:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	56                   	push   %esi
  80131f:	53                   	push   %ebx
  801320:	51                   	push   %ecx
  801321:	52                   	push   %edx
  801322:	50                   	push   %eax
  801323:	6a 09                	push   $0x9
  801325:	e8 22 ff ff ff       	call   80124c <syscall>
  80132a:	83 c4 18             	add    $0x18,%esp
}
  80132d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801330:	5b                   	pop    %ebx
  801331:	5e                   	pop    %esi
  801332:	5d                   	pop    %ebp
  801333:	c3                   	ret    

00801334 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801337:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	52                   	push   %edx
  801344:	50                   	push   %eax
  801345:	6a 0a                	push   $0xa
  801347:	e8 00 ff ff ff       	call   80124c <syscall>
  80134c:	83 c4 18             	add    $0x18,%esp
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	ff 75 0c             	pushl  0xc(%ebp)
  80135d:	ff 75 08             	pushl  0x8(%ebp)
  801360:	6a 0b                	push   $0xb
  801362:	e8 e5 fe ff ff       	call   80124c <syscall>
  801367:	83 c4 18             	add    $0x18,%esp
}
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 0c                	push   $0xc
  80137b:	e8 cc fe ff ff       	call   80124c <syscall>
  801380:	83 c4 18             	add    $0x18,%esp
}
  801383:	c9                   	leave  
  801384:	c3                   	ret    

00801385 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 0d                	push   $0xd
  801394:	e8 b3 fe ff ff       	call   80124c <syscall>
  801399:	83 c4 18             	add    $0x18,%esp
}
  80139c:	c9                   	leave  
  80139d:	c3                   	ret    

0080139e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 0e                	push   $0xe
  8013ad:	e8 9a fe ff ff       	call   80124c <syscall>
  8013b2:	83 c4 18             	add    $0x18,%esp
}
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 0f                	push   $0xf
  8013c6:	e8 81 fe ff ff       	call   80124c <syscall>
  8013cb:	83 c4 18             	add    $0x18,%esp
}
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	ff 75 08             	pushl  0x8(%ebp)
  8013de:	6a 10                	push   $0x10
  8013e0:	e8 67 fe ff ff       	call   80124c <syscall>
  8013e5:	83 c4 18             	add    $0x18,%esp
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 11                	push   $0x11
  8013f9:	e8 4e fe ff ff       	call   80124c <syscall>
  8013fe:	83 c4 18             	add    $0x18,%esp
}
  801401:	90                   	nop
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <sys_cputc>:

void
sys_cputc(const char c)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 04             	sub    $0x4,%esp
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801410:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	50                   	push   %eax
  80141d:	6a 01                	push   $0x1
  80141f:	e8 28 fe ff ff       	call   80124c <syscall>
  801424:	83 c4 18             	add    $0x18,%esp
}
  801427:	90                   	nop
  801428:	c9                   	leave  
  801429:	c3                   	ret    

0080142a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 14                	push   $0x14
  801439:	e8 0e fe ff ff       	call   80124c <syscall>
  80143e:	83 c4 18             	add    $0x18,%esp
}
  801441:	90                   	nop
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	83 ec 04             	sub    $0x4,%esp
  80144a:	8b 45 10             	mov    0x10(%ebp),%eax
  80144d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801450:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801453:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	6a 00                	push   $0x0
  80145c:	51                   	push   %ecx
  80145d:	52                   	push   %edx
  80145e:	ff 75 0c             	pushl  0xc(%ebp)
  801461:	50                   	push   %eax
  801462:	6a 15                	push   $0x15
  801464:	e8 e3 fd ff ff       	call   80124c <syscall>
  801469:	83 c4 18             	add    $0x18,%esp
}
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801471:	8b 55 0c             	mov    0xc(%ebp),%edx
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	52                   	push   %edx
  80147e:	50                   	push   %eax
  80147f:	6a 16                	push   $0x16
  801481:	e8 c6 fd ff ff       	call   80124c <syscall>
  801486:	83 c4 18             	add    $0x18,%esp
}
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80148e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801491:	8b 55 0c             	mov    0xc(%ebp),%edx
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	51                   	push   %ecx
  80149c:	52                   	push   %edx
  80149d:	50                   	push   %eax
  80149e:	6a 17                	push   $0x17
  8014a0:	e8 a7 fd ff ff       	call   80124c <syscall>
  8014a5:	83 c4 18             	add    $0x18,%esp
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	52                   	push   %edx
  8014ba:	50                   	push   %eax
  8014bb:	6a 18                	push   $0x18
  8014bd:	e8 8a fd ff ff       	call   80124c <syscall>
  8014c2:	83 c4 18             	add    $0x18,%esp
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	6a 00                	push   $0x0
  8014cf:	ff 75 14             	pushl  0x14(%ebp)
  8014d2:	ff 75 10             	pushl  0x10(%ebp)
  8014d5:	ff 75 0c             	pushl  0xc(%ebp)
  8014d8:	50                   	push   %eax
  8014d9:	6a 19                	push   $0x19
  8014db:	e8 6c fd ff ff       	call   80124c <syscall>
  8014e0:	83 c4 18             	add    $0x18,%esp
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	50                   	push   %eax
  8014f4:	6a 1a                	push   $0x1a
  8014f6:	e8 51 fd ff ff       	call   80124c <syscall>
  8014fb:	83 c4 18             	add    $0x18,%esp
}
  8014fe:	90                   	nop
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	50                   	push   %eax
  801510:	6a 1b                	push   $0x1b
  801512:	e8 35 fd ff ff       	call   80124c <syscall>
  801517:	83 c4 18             	add    $0x18,%esp
}
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 05                	push   $0x5
  80152b:	e8 1c fd ff ff       	call   80124c <syscall>
  801530:	83 c4 18             	add    $0x18,%esp
}
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 06                	push   $0x6
  801544:	e8 03 fd ff ff       	call   80124c <syscall>
  801549:	83 c4 18             	add    $0x18,%esp
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 07                	push   $0x7
  80155d:	e8 ea fc ff ff       	call   80124c <syscall>
  801562:	83 c4 18             	add    $0x18,%esp
}
  801565:	c9                   	leave  
  801566:	c3                   	ret    

00801567 <sys_exit_env>:


void sys_exit_env(void)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	6a 1c                	push   $0x1c
  801576:	e8 d1 fc ff ff       	call   80124c <syscall>
  80157b:	83 c4 18             	add    $0x18,%esp
}
  80157e:	90                   	nop
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801587:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80158a:	8d 50 04             	lea    0x4(%eax),%edx
  80158d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	52                   	push   %edx
  801597:	50                   	push   %eax
  801598:	6a 1d                	push   $0x1d
  80159a:	e8 ad fc ff ff       	call   80124c <syscall>
  80159f:	83 c4 18             	add    $0x18,%esp
	return result;
  8015a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ab:	89 01                	mov    %eax,(%ecx)
  8015ad:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	c9                   	leave  
  8015b4:	c2 04 00             	ret    $0x4

008015b7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	ff 75 10             	pushl  0x10(%ebp)
  8015c1:	ff 75 0c             	pushl  0xc(%ebp)
  8015c4:	ff 75 08             	pushl  0x8(%ebp)
  8015c7:	6a 13                	push   $0x13
  8015c9:	e8 7e fc ff ff       	call   80124c <syscall>
  8015ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d1:	90                   	nop
}
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 1e                	push   $0x1e
  8015e3:	e8 64 fc ff ff       	call   80124c <syscall>
  8015e8:	83 c4 18             	add    $0x18,%esp
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 04             	sub    $0x4,%esp
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015f9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	50                   	push   %eax
  801606:	6a 1f                	push   $0x1f
  801608:	e8 3f fc ff ff       	call   80124c <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
	return ;
  801610:	90                   	nop
}
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <rsttst>:
void rsttst()
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 21                	push   $0x21
  801622:	e8 25 fc ff ff       	call   80124c <syscall>
  801627:	83 c4 18             	add    $0x18,%esp
	return ;
  80162a:	90                   	nop
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 04             	sub    $0x4,%esp
  801633:	8b 45 14             	mov    0x14(%ebp),%eax
  801636:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801639:	8b 55 18             	mov    0x18(%ebp),%edx
  80163c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801640:	52                   	push   %edx
  801641:	50                   	push   %eax
  801642:	ff 75 10             	pushl  0x10(%ebp)
  801645:	ff 75 0c             	pushl  0xc(%ebp)
  801648:	ff 75 08             	pushl  0x8(%ebp)
  80164b:	6a 20                	push   $0x20
  80164d:	e8 fa fb ff ff       	call   80124c <syscall>
  801652:	83 c4 18             	add    $0x18,%esp
	return ;
  801655:	90                   	nop
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <chktst>:
void chktst(uint32 n)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	ff 75 08             	pushl  0x8(%ebp)
  801666:	6a 22                	push   $0x22
  801668:	e8 df fb ff ff       	call   80124c <syscall>
  80166d:	83 c4 18             	add    $0x18,%esp
	return ;
  801670:	90                   	nop
}
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <inctst>:

void inctst()
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 23                	push   $0x23
  801682:	e8 c5 fb ff ff       	call   80124c <syscall>
  801687:	83 c4 18             	add    $0x18,%esp
	return ;
  80168a:	90                   	nop
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <gettst>:
uint32 gettst()
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 24                	push   $0x24
  80169c:	e8 ab fb ff ff       	call   80124c <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 25                	push   $0x25
  8016b8:	e8 8f fb ff ff       	call   80124c <syscall>
  8016bd:	83 c4 18             	add    $0x18,%esp
  8016c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8016c3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8016c7:	75 07                	jne    8016d0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8016c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ce:	eb 05                	jmp    8016d5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8016d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 25                	push   $0x25
  8016e9:	e8 5e fb ff ff       	call   80124c <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
  8016f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016f4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016f8:	75 07                	jne    801701 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ff:	eb 05                	jmp    801706 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801701:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 25                	push   $0x25
  80171a:	e8 2d fb ff ff       	call   80124c <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
  801722:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801725:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801729:	75 07                	jne    801732 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80172b:	b8 01 00 00 00       	mov    $0x1,%eax
  801730:	eb 05                	jmp    801737 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801732:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 25                	push   $0x25
  80174b:	e8 fc fa ff ff       	call   80124c <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
  801753:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801756:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80175a:	75 07                	jne    801763 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80175c:	b8 01 00 00 00       	mov    $0x1,%eax
  801761:	eb 05                	jmp    801768 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801763:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	ff 75 08             	pushl  0x8(%ebp)
  801778:	6a 26                	push   $0x26
  80177a:	e8 cd fa ff ff       	call   80124c <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
	return ;
  801782:	90                   	nop
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801789:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80178c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80178f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	6a 00                	push   $0x0
  801797:	53                   	push   %ebx
  801798:	51                   	push   %ecx
  801799:	52                   	push   %edx
  80179a:	50                   	push   %eax
  80179b:	6a 27                	push   $0x27
  80179d:	e8 aa fa ff ff       	call   80124c <syscall>
  8017a2:	83 c4 18             	add    $0x18,%esp
}
  8017a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8017ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	52                   	push   %edx
  8017ba:	50                   	push   %eax
  8017bb:	6a 28                	push   $0x28
  8017bd:	e8 8a fa ff ff       	call   80124c <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8017ca:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d3:	6a 00                	push   $0x0
  8017d5:	51                   	push   %ecx
  8017d6:	ff 75 10             	pushl  0x10(%ebp)
  8017d9:	52                   	push   %edx
  8017da:	50                   	push   %eax
  8017db:	6a 29                	push   $0x29
  8017dd:	e8 6a fa ff ff       	call   80124c <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	ff 75 10             	pushl  0x10(%ebp)
  8017f1:	ff 75 0c             	pushl  0xc(%ebp)
  8017f4:	ff 75 08             	pushl  0x8(%ebp)
  8017f7:	6a 12                	push   $0x12
  8017f9:	e8 4e fa ff ff       	call   80124c <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
	return ;
  801801:	90                   	nop
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801807:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	52                   	push   %edx
  801814:	50                   	push   %eax
  801815:	6a 2a                	push   $0x2a
  801817:	e8 30 fa ff ff       	call   80124c <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
	return;
  80181f:	90                   	nop
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	50                   	push   %eax
  801831:	6a 2b                	push   $0x2b
  801833:	e8 14 fa ff ff       	call   80124c <syscall>
  801838:	83 c4 18             	add    $0x18,%esp
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	ff 75 0c             	pushl  0xc(%ebp)
  801849:	ff 75 08             	pushl  0x8(%ebp)
  80184c:	6a 2c                	push   $0x2c
  80184e:	e8 f9 f9 ff ff       	call   80124c <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
	return;
  801856:	90                   	nop
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	ff 75 0c             	pushl  0xc(%ebp)
  801865:	ff 75 08             	pushl  0x8(%ebp)
  801868:	6a 2d                	push   $0x2d
  80186a:	e8 dd f9 ff ff       	call   80124c <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
	return;
  801872:	90                   	nop
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  80187b:	83 ec 04             	sub    $0x4,%esp
  80187e:	68 d8 23 80 00       	push   $0x8023d8
  801883:	6a 09                	push   $0x9
  801885:	68 00 24 80 00       	push   $0x802400
  80188a:	e8 0d 01 00 00       	call   80199c <_panic>

0080188f <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  801895:	83 ec 04             	sub    $0x4,%esp
  801898:	68 10 24 80 00       	push   $0x802410
  80189d:	6a 10                	push   $0x10
  80189f:	68 00 24 80 00       	push   $0x802400
  8018a4:	e8 f3 00 00 00       	call   80199c <_panic>

008018a9 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8018af:	83 ec 04             	sub    $0x4,%esp
  8018b2:	68 38 24 80 00       	push   $0x802438
  8018b7:	6a 18                	push   $0x18
  8018b9:	68 00 24 80 00       	push   $0x802400
  8018be:	e8 d9 00 00 00       	call   80199c <_panic>

008018c3 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8018c9:	83 ec 04             	sub    $0x4,%esp
  8018cc:	68 60 24 80 00       	push   $0x802460
  8018d1:	6a 20                	push   $0x20
  8018d3:	68 00 24 80 00       	push   $0x802400
  8018d8:	e8 bf 00 00 00       	call   80199c <_panic>

008018dd <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	8b 40 10             	mov    0x10(%eax),%eax
}
  8018e6:	5d                   	pop    %ebp
  8018e7:	c3                   	ret    

008018e8 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8018ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8018f1:	89 d0                	mov    %edx,%eax
  8018f3:	c1 e0 02             	shl    $0x2,%eax
  8018f6:	01 d0                	add    %edx,%eax
  8018f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018ff:	01 d0                	add    %edx,%eax
  801901:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801908:	01 d0                	add    %edx,%eax
  80190a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801911:	01 d0                	add    %edx,%eax
  801913:	c1 e0 04             	shl    $0x4,%eax
  801916:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801919:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801920:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801923:	83 ec 0c             	sub    $0xc,%esp
  801926:	50                   	push   %eax
  801927:	e8 55 fc ff ff       	call   801581 <sys_get_virtual_time>
  80192c:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80192f:	eb 41                	jmp    801972 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801931:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801934:	83 ec 0c             	sub    $0xc,%esp
  801937:	50                   	push   %eax
  801938:	e8 44 fc ff ff       	call   801581 <sys_get_virtual_time>
  80193d:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801940:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801943:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801946:	29 c2                	sub    %eax,%edx
  801948:	89 d0                	mov    %edx,%eax
  80194a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80194d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801950:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801953:	89 d1                	mov    %edx,%ecx
  801955:	29 c1                	sub    %eax,%ecx
  801957:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80195a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80195d:	39 c2                	cmp    %eax,%edx
  80195f:	0f 97 c0             	seta   %al
  801962:	0f b6 c0             	movzbl %al,%eax
  801965:	29 c1                	sub    %eax,%ecx
  801967:	89 c8                	mov    %ecx,%eax
  801969:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80196c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80196f:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801975:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801978:	72 b7                	jb     801931 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80197a:	90                   	nop
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801983:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80198a:	eb 03                	jmp    80198f <busy_wait+0x12>
  80198c:	ff 45 fc             	incl   -0x4(%ebp)
  80198f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801992:	3b 45 08             	cmp    0x8(%ebp),%eax
  801995:	72 f5                	jb     80198c <busy_wait+0xf>
	return i;
  801997:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8019a2:	8d 45 10             	lea    0x10(%ebp),%eax
  8019a5:	83 c0 04             	add    $0x4,%eax
  8019a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8019ab:	a1 24 30 80 00       	mov    0x803024,%eax
  8019b0:	85 c0                	test   %eax,%eax
  8019b2:	74 16                	je     8019ca <_panic+0x2e>
		cprintf("%s: ", argv0);
  8019b4:	a1 24 30 80 00       	mov    0x803024,%eax
  8019b9:	83 ec 08             	sub    $0x8,%esp
  8019bc:	50                   	push   %eax
  8019bd:	68 88 24 80 00       	push   $0x802488
  8019c2:	e8 c1 e9 ff ff       	call   800388 <cprintf>
  8019c7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8019ca:	a1 00 30 80 00       	mov    0x803000,%eax
  8019cf:	ff 75 0c             	pushl  0xc(%ebp)
  8019d2:	ff 75 08             	pushl  0x8(%ebp)
  8019d5:	50                   	push   %eax
  8019d6:	68 8d 24 80 00       	push   $0x80248d
  8019db:	e8 a8 e9 ff ff       	call   800388 <cprintf>
  8019e0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8019e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e6:	83 ec 08             	sub    $0x8,%esp
  8019e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ec:	50                   	push   %eax
  8019ed:	e8 2b e9 ff ff       	call   80031d <vcprintf>
  8019f2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8019f5:	83 ec 08             	sub    $0x8,%esp
  8019f8:	6a 00                	push   $0x0
  8019fa:	68 a9 24 80 00       	push   $0x8024a9
  8019ff:	e8 19 e9 ff ff       	call   80031d <vcprintf>
  801a04:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801a07:	e8 9a e8 ff ff       	call   8002a6 <exit>

	// should not return here
	while (1) ;
  801a0c:	eb fe                	jmp    801a0c <_panic+0x70>

00801a0e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801a14:	a1 04 30 80 00       	mov    0x803004,%eax
  801a19:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a22:	39 c2                	cmp    %eax,%edx
  801a24:	74 14                	je     801a3a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801a26:	83 ec 04             	sub    $0x4,%esp
  801a29:	68 ac 24 80 00       	push   $0x8024ac
  801a2e:	6a 26                	push   $0x26
  801a30:	68 f8 24 80 00       	push   $0x8024f8
  801a35:	e8 62 ff ff ff       	call   80199c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801a3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801a41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801a48:	e9 c5 00 00 00       	jmp    801b12 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	01 d0                	add    %edx,%eax
  801a5c:	8b 00                	mov    (%eax),%eax
  801a5e:	85 c0                	test   %eax,%eax
  801a60:	75 08                	jne    801a6a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801a62:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a65:	e9 a5 00 00 00       	jmp    801b0f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a6a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a71:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a78:	eb 69                	jmp    801ae3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a7a:	a1 04 30 80 00       	mov    0x803004,%eax
  801a7f:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801a85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a88:	89 d0                	mov    %edx,%eax
  801a8a:	01 c0                	add    %eax,%eax
  801a8c:	01 d0                	add    %edx,%eax
  801a8e:	c1 e0 03             	shl    $0x3,%eax
  801a91:	01 c8                	add    %ecx,%eax
  801a93:	8a 40 04             	mov    0x4(%eax),%al
  801a96:	84 c0                	test   %al,%al
  801a98:	75 46                	jne    801ae0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a9a:	a1 04 30 80 00       	mov    0x803004,%eax
  801a9f:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801aa5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801aa8:	89 d0                	mov    %edx,%eax
  801aaa:	01 c0                	add    %eax,%eax
  801aac:	01 d0                	add    %edx,%eax
  801aae:	c1 e0 03             	shl    $0x3,%eax
  801ab1:	01 c8                	add    %ecx,%eax
  801ab3:	8b 00                	mov    (%eax),%eax
  801ab5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ab8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801abb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ac0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	01 c8                	add    %ecx,%eax
  801ad1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ad3:	39 c2                	cmp    %eax,%edx
  801ad5:	75 09                	jne    801ae0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801ad7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801ade:	eb 15                	jmp    801af5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ae0:	ff 45 e8             	incl   -0x18(%ebp)
  801ae3:	a1 04 30 80 00       	mov    0x803004,%eax
  801ae8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801af1:	39 c2                	cmp    %eax,%edx
  801af3:	77 85                	ja     801a7a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801af5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801af9:	75 14                	jne    801b0f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801afb:	83 ec 04             	sub    $0x4,%esp
  801afe:	68 04 25 80 00       	push   $0x802504
  801b03:	6a 3a                	push   $0x3a
  801b05:	68 f8 24 80 00       	push   $0x8024f8
  801b0a:	e8 8d fe ff ff       	call   80199c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801b0f:	ff 45 f0             	incl   -0x10(%ebp)
  801b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b15:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801b18:	0f 8c 2f ff ff ff    	jl     801a4d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801b1e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b2c:	eb 26                	jmp    801b54 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801b2e:	a1 04 30 80 00       	mov    0x803004,%eax
  801b33:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801b39:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b3c:	89 d0                	mov    %edx,%eax
  801b3e:	01 c0                	add    %eax,%eax
  801b40:	01 d0                	add    %edx,%eax
  801b42:	c1 e0 03             	shl    $0x3,%eax
  801b45:	01 c8                	add    %ecx,%eax
  801b47:	8a 40 04             	mov    0x4(%eax),%al
  801b4a:	3c 01                	cmp    $0x1,%al
  801b4c:	75 03                	jne    801b51 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801b4e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b51:	ff 45 e0             	incl   -0x20(%ebp)
  801b54:	a1 04 30 80 00       	mov    0x803004,%eax
  801b59:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b62:	39 c2                	cmp    %eax,%edx
  801b64:	77 c8                	ja     801b2e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b69:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b6c:	74 14                	je     801b82 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b6e:	83 ec 04             	sub    $0x4,%esp
  801b71:	68 58 25 80 00       	push   $0x802558
  801b76:	6a 44                	push   $0x44
  801b78:	68 f8 24 80 00       	push   $0x8024f8
  801b7d:	e8 1a fe ff ff       	call   80199c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b82:	90                   	nop
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    
  801b85:	66 90                	xchg   %ax,%ax
  801b87:	90                   	nop

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
